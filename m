From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v7 1/1] ibacm: Add support for pathrecord query through netlink
Date: Tue, 30 Jun 2015 09:46:28 -0400
Message-ID: <1435671988-9814-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch enables ibacm to process pathrecord queries through netlink.
Since ibacm can cache pathrecords, this implementation provides an easy
pathrecord cache for kernel components and therefore offers great
performance advantage on large fabric systems.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v6:
- No change. Sync the version number with kernel patches.

Changes since v5:
- Change the parsing of request attributes due to the introduction of path_use
  and change of byte order for attribute data.

Changes since v4:
- Add error handling for unknown or incorrectly formated attributes.
  The request will be NACKed.

Changes since v3:
- Change the parsing from struct ib_user_path_rec to basic attributes.

Changes since v2:
- Redesign the communication protocol between the kernel and ibacm, as
  described below:
  http://www.spinics.net/lists/linux-rdma/msg25621.html

Changes since v1:
- Check rmpp_flags for rmpp MAD instead of rmpp_version.

 src/acm.c |  375 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 372 insertions(+), 3 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 7649725..efd4a8a 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -46,6 +46,8 @@
 #include <infiniband/acm_prov.h>
 #include <infiniband/umad.h>
 #include <infiniband/verbs.h>
+#include <infiniband/umad_types.h>
+#include <infiniband/umad_sa.h>
 #include <dlist.h>
 #include <dlfcn.h> 
 #include <search.h>
@@ -55,6 +57,8 @@
 #include <netinet/in.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
+#include <rdma/rdma_netlink.h>
+#include <rdma/ib_user_sa.h>
 #include <poll.h>
 #include "acm_mad.h"
 #include "acm_util.h"
@@ -66,6 +70,7 @@
 #define MAX_EP_ADDR 4
 #define NL_MSG_BUF_SIZE 4096
 #define ACM_PROV_NAME_SIZE 64
+#define NL_CLIENT_INDEX 0
 
 struct acmc_subnet {
 	DLIST_ENTRY            entry;
@@ -151,6 +156,26 @@ struct acmc_sa_req {
 	struct acm_sa_mad	mad;
 };
 
+struct acm_nl_status {
+	struct nlattr			attr_hdr;
+	struct rdma_nla_ls_status	status;
+};
+
+struct acm_nl_path {
+	struct nlattr			attr_hdr;
+	struct ib_path_rec_data		rec;
+};
+
+struct acm_nl_msg {
+	struct nlmsghdr				nlmsg_header;
+	union {
+		uint8_t				data[ACM_MSG_DATA_LENGTH];
+		struct nlattr			attr[0];
+		struct acm_nl_status		status[0];
+		struct acm_nl_path		path[0];
+	};
+};
+
 static char def_prov_name[ACM_PROV_NAME_SIZE] = "ibacmp";
 static DLIST_ENTRY provider_list;
 static struct acmc_prov *def_provider = NULL;
@@ -172,6 +197,7 @@ static struct acmc_ep *acm_find_ep(struct acmc_port *port, uint16_t pkey);
 static int acm_ep_insert_addr(struct acmc_ep *ep, const char *name, uint8_t *addr,
 			      size_t addr_len, uint8_t addr_type);
 static void acm_event_handler(struct acmc_device *dev);
+static int acm_nl_send(SOCKET sock, struct acm_msg *msg);
 
 static struct sa_data {
 	int		timeout;
@@ -466,7 +492,11 @@ int acm_resolve_response(uint64_t id, struct acm_msg *msg)
 		goto release;
 	}
 
-	ret = send(client->sock, (char *) msg, msg->hdr.length, 0);
+	if (id == NL_CLIENT_INDEX)
+		ret = acm_nl_send(client->sock, msg);
+	else
+		ret = send(client->sock, (char *) msg, msg->hdr.length, 0);
+
 	if (ret != msg->hdr.length)
 		acm_log(0, "ERROR - failed to send response\n");
 	else
@@ -597,6 +627,8 @@ static void acm_svr_accept(void)
 	}
 
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
+		if (i == NL_CLIENT_INDEX)
+			continue;
 		if (!atomic_get(&client_array[i].refcnt))
 			break;
 	}
@@ -1346,6 +1378,338 @@ static void acm_ipnl_handler(void)
 	}
 }
 
+static int acm_nl_send(SOCKET sock, struct acm_msg *msg)
+{
+	struct sockaddr_nl dst_addr;
+	struct acm_nl_msg acmnlmsg;
+	struct acm_nl_msg *orig;
+	int ret;
+	int datalen;
+
+	orig = (struct acm_nl_msg *) msg->hdr.tid;
+
+	memset(&dst_addr, 0, sizeof(dst_addr));
+	dst_addr.nl_family = AF_NETLINK;
+	dst_addr.nl_groups = (1 << (RDMA_NL_GROUP_LS - 1));
+
+	memset(&acmnlmsg, 0, sizeof(acmnlmsg));
+	acmnlmsg.nlmsg_header.nlmsg_len = NLMSG_HDRLEN;
+	acmnlmsg.nlmsg_header.nlmsg_pid = getpid();
+	acmnlmsg.nlmsg_header.nlmsg_type = orig->nlmsg_header.nlmsg_type;
+	acmnlmsg.nlmsg_header.nlmsg_flags = NLM_F_REQUEST;
+	acmnlmsg.nlmsg_header.nlmsg_seq = orig->nlmsg_header.nlmsg_seq;
+
+	if (msg->hdr.status != ACM_STATUS_SUCCESS) {
+		acm_log(2, "acm status no success = %d\n", msg->hdr.status);
+		acmnlmsg.nlmsg_header.nlmsg_flags |= RDMA_NL_LS_F_ERR;
+		acmnlmsg.nlmsg_header.nlmsg_len +=
+			NLA_ALIGN(sizeof(struct acm_nl_status));
+		acmnlmsg.status[0].attr_hdr.nla_type = LS_NLA_TYPE_STATUS;
+		acmnlmsg.status[0].attr_hdr.nla_len = NLA_HDRLEN +
+			sizeof(struct rdma_nla_ls_status);
+		if (msg->hdr.status == ACM_STATUS_EINVAL)
+			acmnlmsg.status[0].status.status = LS_NLA_STATUS_EINVAL;
+		else
+			acmnlmsg.status[0].status.status =
+				LS_NLA_STATUS_ENODATA;
+	} else {
+		acm_log(2, "acm status success\n");
+		acmnlmsg.nlmsg_header.nlmsg_flags |= RDMA_NL_LS_F_OK;
+		acmnlmsg.nlmsg_header.nlmsg_len +=
+			NLA_ALIGN(sizeof(struct acm_nl_path));
+		acmnlmsg.path[0].attr_hdr.nla_type = LS_NLA_TYPE_PATH_RECORD;
+		acmnlmsg.path[0].attr_hdr.nla_len = sizeof(struct acm_nl_path);
+		acmnlmsg.path[0].rec.flags =
+			IB_PATH_PRIMARY | IB_PATH_BIDIRECTIONAL;
+		if (msg->resolve_data[0].info.path.reversible_numpath &
+		    IBV_PATH_RECORD_REVERSIBLE)
+			acmnlmsg.path[0].rec.flags |= IB_PATH_GMP;
+		memcpy(acmnlmsg.path[0].rec.path_rec,
+		       &msg->resolve_data[0].info.path,
+		       sizeof(struct ibv_path_record));
+	}
+
+	datalen = NLMSG_ALIGN(acmnlmsg.nlmsg_header.nlmsg_len);
+	ret = sendto(sock, &acmnlmsg, datalen, 0,
+		     (const struct sockaddr *)&dst_addr,
+		     (socklen_t)sizeof(dst_addr));
+	if (ret != datalen) {
+		acm_log(0, "ERROR - sendto = %d errno = %d\n", ret, errno);
+		ret = -1;
+	} else {
+		ret = msg->hdr.length;
+	}
+
+	free(orig);
+
+	return ret;
+}
+
+#define NLA_LEN(nla)	((nla)->nla_len - NLA_HDRLEN)
+#define NLA_DATA(nla)	((char *)(nla) + NLA_HDRLEN)
+
+static int acm_nl_parse_path_attr(struct nlattr *attr,
+				   struct acm_ep_addr_data *data)
+{
+	struct ibv_path_record *path;
+	struct rdma_nla_ls_service_id  *sid;
+	struct rdma_nla_ls_gid *gid;
+	struct rdma_nla_ls_tclass *tcl;
+	struct rdma_nla_ls_path_use *use;
+	struct rdma_nla_ls_pkey *pkey;
+	struct rdma_nla_ls_qos_class *qos;
+	uint16_t val;
+	int ret = 0;
+
+#define IBV_PATH_RECORD_QOS_MASK 0xfff0
+
+	path = &data->info.path;
+	switch (attr->nla_type & RDMA_NLA_TYPE_MASK) {
+	case LS_NLA_TYPE_SERVICE_ID:
+		sid = (struct rdma_nla_ls_service_id *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(sid->service_id)) {
+			acm_log(2, "service_id 0x%llx\n", sid->service_id);
+			path->service_id = htonll(sid->service_id);
+		} else {
+			ret = -1;
+		}
+		break;
+
+	case LS_NLA_TYPE_DGID:
+		gid = (struct rdma_nla_ls_gid *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(gid->gid)) {
+			acm_format_name(2, log_data, sizeof(log_data),
+					ACM_ADDRESS_GID, gid->gid,
+					sizeof(union ibv_gid));
+			acm_log(2, "path dgid %s\n", log_data);
+			memcpy(path->dgid.raw, gid->gid, sizeof(path->dgid));
+			data->flags |= ACM_EP_FLAG_DEST;
+		} else {
+			ret = -1;
+		}
+		break;
+
+	case LS_NLA_TYPE_SGID:
+		gid = (struct rdma_nla_ls_gid *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(gid->gid)) {
+			acm_format_name(2, log_data, sizeof(log_data),
+					ACM_ADDRESS_GID, gid->gid,
+					sizeof(union ibv_gid));
+			acm_log(2, "path sgid %s\n", log_data);
+			memcpy(path->sgid.raw, gid->gid, sizeof(path->sgid));
+			data->flags |= ACM_EP_FLAG_SOURCE;
+		} else {
+			ret = -1;
+		}
+		break;
+
+	case LS_NLA_TYPE_TCLASS:
+		tcl = (struct rdma_nla_ls_tclass *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(tcl->tclass)) {
+			acm_log(2, "tclass 0x%x\n", tcl->tclass);
+			path->tclass = tcl->tclass;
+		} else {
+			ret = -1;
+		}
+		break;
+
+	case LS_NLA_TYPE_PATH_USE:
+		use = (struct rdma_nla_ls_path_use *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(use->use)) {
+			acm_log(2, "path use 0x%x\n", use->use);
+			/* We support only one pathrecord */
+			if (use->use == LS_NLA_PATH_USE_UNIDIRECTIONAL)
+				path->reversible_numpath = 1;
+			else
+				path->reversible_numpath =
+					IBV_PATH_RECORD_REVERSIBLE | 1;
+		} else {
+			ret = -1;
+		}
+		break;
+
+	case LS_NLA_TYPE_PKEY:
+		pkey = (struct rdma_nla_ls_pkey *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(pkey->pkey)) {
+			acm_log(2, "pkey 0x%x\n", pkey->pkey);
+			path->pkey = htons(pkey->pkey);
+		} else {
+			ret = -1;
+		}
+		break;
+
+	case LS_NLA_TYPE_QOS_CLASS:
+		qos = (struct rdma_nla_ls_qos_class *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(qos->qos_class)) {
+			acm_log(2, "qos_class 0x%x\n", qos->qos_class);
+			val = ntohs(path->qosclass_sl);
+			val &= ~IBV_PATH_RECORD_QOS_MASK;
+			val |= (qos->qos_class & IBV_PATH_RECORD_QOS_MASK);
+			path->qosclass_sl = htons(val);
+		} else {
+			ret = -1;
+		}
+		break;
+
+	default:
+		acm_log(1, "WARN: unknown attr %x\n", attr->nla_type);
+		/* We can not ignore a mandatory attribute */
+		if (attr->nla_type & RDMA_NLA_F_MANDATORY)
+			ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
+static void acm_nl_process_invalid_request(struct acmc_client *client,
+					   struct acm_nl_msg *acmnlmsg)
+{
+	struct acm_msg msg;
+
+	memset(&msg, 0, sizeof(msg));
+	msg.hdr.opcode = ACM_OP_RESOLVE;
+	msg.hdr.version = ACM_VERSION;
+	msg.hdr.length = ACM_MSG_HDR_LENGTH;
+	msg.hdr.status = ACM_STATUS_EINVAL;
+	msg.hdr.tid = (uint64_t) acmnlmsg;
+
+	acm_nl_send(client->sock, &msg);
+}
+
+static void acm_nl_process_resolve(struct acmc_client *client,
+				   struct acm_nl_msg *acmnlmsg)
+{
+	struct acm_msg msg;
+	struct nlattr *attr;
+	int payload_len;
+	int rem;
+	int total_attr_len;
+	int status;
+
+	memset(&msg, 0, sizeof(msg));
+	msg.hdr.opcode = ACM_OP_RESOLVE;
+	msg.hdr.version = ACM_VERSION;
+	msg.hdr.length = ACM_MSG_HDR_LENGTH + ACM_MSG_EP_LENGTH;
+	msg.hdr.status = ACM_STATUS_SUCCESS;
+	msg.hdr.tid = (uint64_t) acmnlmsg;
+	msg.resolve_data[0].type = ACM_EP_INFO_PATH;
+
+	payload_len = acmnlmsg->nlmsg_header.nlmsg_len - NLMSG_HDRLEN;
+	attr = NLMSG_DATA(&acmnlmsg->nlmsg_header);
+	rem = payload_len;
+	while (1) {
+		if (rem < (int) sizeof(*attr) ||
+		    attr->nla_len < sizeof(*attr) ||
+		    attr->nla_len > rem)
+			break;
+
+		status = acm_nl_parse_path_attr(attr, &msg.resolve_data[0]);
+		if (status) {
+			acm_nl_process_invalid_request(client, acmnlmsg);
+			return;
+		}
+
+		/* Next attribute */
+		total_attr_len = NLA_ALIGN(attr->nla_len);
+		rem -= total_attr_len;
+		attr = (struct nlattr *) ((char *) attr + total_attr_len);
+	}
+
+	atomic_inc(&counter[ACM_CNTR_RESOLVE]);
+	acm_svr_resolve(client, &msg);
+}
+
+static int acm_nl_is_valid_resolve_request(struct acm_nl_msg *acmnlmsg)
+{
+	int payload_len;
+
+	payload_len = acmnlmsg->nlmsg_header.nlmsg_len - NLMSG_HDRLEN;
+	if (payload_len < sizeof(struct nlattr))
+		return 0;
+
+	return 1;
+}
+
+static void acm_nl_receive(struct acmc_client *client)
+{
+	struct acm_nl_msg *acmnlmsg;
+	int datalen = sizeof(*acmnlmsg);
+	int ret;
+	uint16_t client_inx, op;
+
+	acmnlmsg = calloc(1, sizeof(*acmnlmsg));
+	if (!acmnlmsg) {
+		acm_log(0, "Out of memory for recving nl msg.\n");
+		return;
+	}
+	ret = recv(client->sock, acmnlmsg, datalen, 0);
+	if (!NLMSG_OK(&acmnlmsg->nlmsg_header, ret)) {
+		acm_log(0, "Netlink receive error: %d.\n", ret);
+		goto rcv_cleanup;
+	}
+
+	acm_log(2, "nlmsg: len %d type 0x%x flags 0x%x seq %d pid %d\n",
+		acmnlmsg->nlmsg_header.nlmsg_len,
+		acmnlmsg->nlmsg_header.nlmsg_type,
+		acmnlmsg->nlmsg_header.nlmsg_flags,
+		acmnlmsg->nlmsg_header.nlmsg_seq,
+		acmnlmsg->nlmsg_header.nlmsg_pid);
+
+	/* Currently we handle only request from the SA client */
+	client_inx = RDMA_NL_GET_CLIENT(acmnlmsg->nlmsg_header.nlmsg_type);
+	op = RDMA_NL_GET_OP(acmnlmsg->nlmsg_header.nlmsg_type);
+	if (client_inx != RDMA_NL_SA)
+		goto rcv_cleanup;
+
+	switch (op) {
+	case RDMA_NL_LS_OP_RESOLVE:
+		if (acm_nl_is_valid_resolve_request(acmnlmsg))
+			acm_nl_process_resolve(client, acmnlmsg);
+		else
+			acm_nl_process_invalid_request(client, acmnlmsg);
+		break;
+	default:
+		/* Not supported*/
+		acm_log(1, "WARN - invalid opcode %x\n", op);
+		acm_nl_process_invalid_request(client, acmnlmsg);
+		break;
+	}
+
+	return;
+rcv_cleanup:
+	free(acmnlmsg);
+}
+
+static int acm_init_nl(void)
+{
+	struct sockaddr_nl src_addr;
+	int ret;
+	SOCKET nl_rcv_socket;
+
+	nl_rcv_socket = socket(PF_NETLINK, SOCK_RAW, NETLINK_RDMA);
+	if (nl_rcv_socket == INVALID_SOCKET) {
+		acm_log(0, "ERROR - unable to allocate netlink recv socket\n");
+		return socket_errno();
+	}
+
+	memset(&src_addr, 0, sizeof(src_addr));
+	src_addr.nl_family = AF_NETLINK;
+	src_addr.nl_pid = getpid();
+	src_addr.nl_groups = (1 << (RDMA_NL_GROUP_LS - 1));
+
+	ret = bind(nl_rcv_socket, (struct sockaddr *)&src_addr,
+		   sizeof(src_addr));
+	if (ret == SOCKET_ERROR) {
+		acm_log(0, "ERROR - unable to bind netlink socket\n");
+		return socket_errno();
+	}
+
+	/* init nl client structure */
+	client_array[NL_CLIENT_INDEX].sock = nl_rcv_socket;
+	return 0;
+}
+
 static void acm_server(void)
 {
 	fd_set readfds;
@@ -1360,12 +1724,14 @@ static void acm_server(void)
 		acm_log(0, "ERROR - server listen failed\n");
 		return;
 	}
+	ret = acm_init_nl();
+	if (ret)
+		acm_log(1, "Warn - Netlink init failed\n");
 
 	while (1) {
 		n = (int) listen_socket;
 		FD_ZERO(&readfds);
 		FD_SET(listen_socket, &readfds);
-
 		n = max(n, (int) ip_mon_socket);
 		FD_SET(ip_mon_socket, &readfds);
 
@@ -1399,7 +1765,10 @@ static void acm_server(void)
 			if (client_array[i].sock != INVALID_SOCKET &&
 				FD_ISSET(client_array[i].sock, &readfds)) {
 				acm_log(2, "receiving from client %d\n", i);
-				acm_svr_receive(&client_array[i]);
+				if (i == NL_CLIENT_INDEX)
+					acm_nl_receive(&client_array[i]);
+				else
+					acm_svr_receive(&client_array[i]);
 			}
 		}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

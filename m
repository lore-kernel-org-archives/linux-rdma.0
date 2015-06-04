From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3 1/1] ibacm: Add support for pathrecord query through netlink
Date: Thu,  4 Jun 2015 08:27:56 -0400
Message-ID: <1433420876-13623-1-git-send-email-kaike.wan@intel.com>
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
 src/acm.c |  271 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 268 insertions(+), 3 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 7649725..62b7392 100644
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
+	struct rdma_nla_ls_path_rec	path;
+};
+
+struct acm_nl_msg {
+	struct nlmsghdr			nlmsg_header;
+	union {
+		uint8_t			data[ACM_MSG_DATA_LENGTH];
+		struct nlattr		attr[0];
+		struct acm_nl_status	status[0];
+		struct acm_nl_path	path[0];
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
@@ -1346,6 +1378,234 @@ static void acm_ipnl_handler(void)
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
+			sizeof(struct acm_nl_status);
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
+			sizeof(struct acm_nl_path) +
+			sizeof(struct ibv_path_record);
+		acmnlmsg.path[0].attr_hdr.nla_type = LS_NLA_TYPE_PATH_RECORD;
+		acmnlmsg.path[0].attr_hdr.nla_len = sizeof(struct acm_nl_path)
+			+ sizeof(struct ibv_path_record);
+		acmnlmsg.path[0].path.flags = LS_NLA_PATH_F_GMP;
+		memcpy(acmnlmsg.path[0].path.path_rec,
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
+static void acm_nl_process_resolve(struct acmc_client *client,
+				   struct acm_nl_msg *acmnlmsg)
+{
+	struct acm_msg msg;
+	struct ibv_path_record *path;
+	struct ib_user_path_rec *user_path;
+
+	user_path = (struct ib_user_path_rec *) acmnlmsg->path[0].path.path_rec;
+	acm_format_name(2, log_data, sizeof(log_data), ACM_ADDRESS_GID,
+			user_path->dgid, sizeof(union ibv_gid));
+	acm_log(2, "path dgid %s\n", log_data);
+	acm_format_name(2, log_data, sizeof(log_data), ACM_ADDRESS_GID,
+			user_path->sgid, sizeof(union ibv_gid));
+	acm_log(2, "path sgid %s\n", log_data);
+	atomic_inc(&counter[ACM_CNTR_RESOLVE]);
+
+	memset(&msg, 0, sizeof(msg));
+	msg.hdr.opcode = ACM_OP_RESOLVE;
+	msg.hdr.version = ACM_VERSION;
+	msg.hdr.length = ACM_MSG_HDR_LENGTH + ACM_MSG_EP_LENGTH;
+	msg.hdr.status = ACM_STATUS_SUCCESS;
+	msg.hdr.tid = (uint64_t) acmnlmsg;
+	msg.resolve_data[0].type = ACM_EP_INFO_PATH;
+	msg.resolve_data[0].flags = (ACM_EP_FLAG_SOURCE | ACM_EP_FLAG_DEST);
+	path = &msg.resolve_data[0].info.path;
+	memcpy(path->dgid.raw, user_path->dgid, sizeof(path->dgid));
+	memcpy(path->sgid.raw, user_path->sgid, sizeof(path->sgid));
+	path->dlid = user_path->dlid;
+	path->slid = user_path->slid;
+	path->pkey = user_path->pkey;
+	path->preference = user_path->preference;
+
+	acm_svr_resolve(client, &msg);
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
+static int acm_nl_is_valid_resolve_request(struct acm_nl_msg *acmnlmsg)
+{
+	int valid = 0;
+	int payload_len;
+	int len;
+
+	payload_len = acmnlmsg->nlmsg_header.nlmsg_len - NLMSG_HDRLEN;
+	if (payload_len < sizeof(struct nlattr))
+		return 0;
+
+	switch (acmnlmsg->attr[0].nla_type) {
+	case LS_NLA_TYPE_PATH_RECORD:
+		if (payload_len < sizeof(struct acm_nl_path))
+			break;
+
+		/* We support only struct ib_user_path_rec input */
+		if (!(acmnlmsg->path[0].path.flags & LS_NLA_PATH_F_USER))
+			break;
+
+		len = sizeof(struct acm_nl_path) +
+			sizeof(struct ib_user_path_rec);
+		if (payload_len < len ||
+		    acmnlmsg->path[0].attr_hdr.nla_len < len)
+			break;
+
+		valid = 1;
+		break;
+	default:
+		break;
+	}
+
+	return valid;
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
@@ -1360,12 +1620,14 @@ static void acm_server(void)
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
 
@@ -1399,7 +1661,10 @@ static void acm_server(void)
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

From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v9 1/1] ibacm: Add support for pathrecord query through netlink
Date: Fri, 14 Aug 2015 08:52:49 -0400
Message-ID: <1439556769-27948-1-git-send-email-kaike.wan@intel.com>
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
---
Changes since v8:
- Remove the status attribute and related code;
- Add a header file acm_netlink.h so that the code can be built in older
  system without the latest rdma_netlink.h header file;
- Add code to deal with netlink socket initialization error and close.

Changes since v7:
- Add the defines for netlink status code, which have been deleted from the
  kernel rdma_netlink.h file.
- Add the resolve family header to the netlink request message and modify
  the processing code accordingly.
- Return the pathrecord data flags based on the input path_use parameter
  in the resolve family header.

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

 Makefile.am       |   2 +-
 src/acm.c         | 365 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 src/acm_netlink.h | 128 +++++++++++++++++++
 3 files changed, 491 insertions(+), 4 deletions(-)
 create mode 100644 src/acm_netlink.h

diff --git a/Makefile.am b/Makefile.am
index 73b1a31..94a2993 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -37,7 +37,7 @@ man_MANS = \
 	man/ibacm.7
 
 EXTRA_DIST = src/acm_util.h prov/acmp/src/libibacmp.map include/acm_mad.h src/libacm.h ibacm.init.in \
-	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) ibacm_hosts.data
+	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) ibacm_hosts.data src/acm_netlink.h
 
 install-exec-hook:
 	install -D -m 755 ibacm.init $(DESTDIR)$(sysconfdir)/init.d/ibacm;
diff --git a/src/acm.c b/src/acm.c
index 7649725..ada0bfb 100644
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
@@ -55,9 +57,14 @@
 #include <netinet/in.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
+#include <rdma/rdma_netlink.h>
+#include <rdma/ib_user_sa.h>
 #include <poll.h>
 #include "acm_mad.h"
 #include "acm_util.h"
+#if !defined(RDMA_NL_LS_F_ERR)
+	#include "acm_netlink.h"
+#endif
 
 #define src_out     data[0]
 #define src_index   data[1]
@@ -66,6 +73,7 @@
 #define MAX_EP_ADDR 4
 #define NL_MSG_BUF_SIZE 4096
 #define ACM_PROV_NAME_SIZE 64
+#define NL_CLIENT_INDEX 0
 
 struct acmc_subnet {
 	DLIST_ENTRY            entry;
@@ -151,6 +159,21 @@ struct acmc_sa_req {
 	struct acm_sa_mad	mad;
 };
 
+struct acm_nl_path {
+	struct nlattr			attr_hdr;
+	struct ib_path_rec_data		rec;
+};
+
+struct acm_nl_msg {
+	struct nlmsghdr				nlmsg_header;
+	union {
+		uint8_t				data[ACM_MSG_DATA_LENGTH];
+		struct rdma_ls_resolve_header	resolve_header;
+		struct nlattr			attr[0];
+		struct acm_nl_path		path[0];
+	};
+};
+
 static char def_prov_name[ACM_PROV_NAME_SIZE] = "ibacmp";
 static DLIST_ENTRY provider_list;
 static struct acmc_prov *def_provider = NULL;
@@ -172,6 +195,7 @@ static struct acmc_ep *acm_find_ep(struct acmc_port *port, uint16_t pkey);
 static int acm_ep_insert_addr(struct acmc_ep *ep, const char *name, uint8_t *addr,
 			      size_t addr_len, uint8_t addr_type);
 static void acm_event_handler(struct acmc_device *dev);
+static int acm_nl_send(SOCKET sock, struct acm_msg *msg);
 
 static struct sa_data {
 	int		timeout;
@@ -466,7 +490,11 @@ int acm_resolve_response(uint64_t id, struct acm_msg *msg)
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
@@ -597,6 +625,8 @@ static void acm_svr_accept(void)
 	}
 
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
+		if (i == NL_CLIENT_INDEX)
+			continue;
 		if (!atomic_get(&client_array[i].refcnt))
 			break;
 	}
@@ -1346,6 +1376,328 @@ static void acm_ipnl_handler(void)
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
+	acmnlmsg.nlmsg_header.nlmsg_seq = orig->nlmsg_header.nlmsg_seq;
+
+	if (msg->hdr.status != ACM_STATUS_SUCCESS) {
+		acm_log(2, "acm status no success = %d\n", msg->hdr.status);
+		acmnlmsg.nlmsg_header.nlmsg_flags |= RDMA_NL_LS_F_ERR;
+	} else {
+		acm_log(2, "acm status success\n");
+		acmnlmsg.nlmsg_header.nlmsg_len +=
+			NLA_ALIGN(sizeof(struct acm_nl_path));
+		acmnlmsg.path[0].attr_hdr.nla_type = LS_NLA_TYPE_PATH_RECORD;
+		acmnlmsg.path[0].attr_hdr.nla_len = sizeof(struct acm_nl_path);
+		if (orig->resolve_header.path_use ==
+		    LS_RESOLVE_PATH_USE_UNIDIRECTIONAL)
+			acmnlmsg.path[0].rec.flags = IB_PATH_PRIMARY |
+				IB_PATH_OUTBOUND;
+		else
+			acmnlmsg.path[0].rec.flags = IB_PATH_PRIMARY |
+				IB_PATH_GMP | IB_PATH_BIDIRECTIONAL;
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
+	uint64_t  *sid;
+	struct rdma_nla_ls_gid *gid;
+	uint8_t *tcl;
+	uint16_t *pkey;
+	uint16_t *qos;
+	uint16_t val;
+	int ret = 0;
+
+#define IBV_PATH_RECORD_QOS_MASK 0xfff0
+
+	path = &data->info.path;
+	switch (attr->nla_type & RDMA_NLA_TYPE_MASK) {
+	case LS_NLA_TYPE_SERVICE_ID:
+		sid = (uint64_t *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(*sid)) {
+			acm_log(2, "service_id 0x%llx\n", *sid);
+			path->service_id = htonll(*sid);
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
+		tcl = (uint8_t *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(*tcl)) {
+			acm_log(2, "tclass 0x%x\n", *tcl);
+			path->tclass = *tcl;
+		} else {
+			ret = -1;
+		}
+		break;
+
+	case LS_NLA_TYPE_PKEY:
+		pkey = (uint16_t *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(*pkey)) {
+			acm_log(2, "pkey 0x%x\n", *pkey);
+			path->pkey = htons(*pkey);
+		} else {
+			ret = -1;
+		}
+		break;
+
+	case LS_NLA_TYPE_QOS_CLASS:
+		qos = (uint16_t *) NLA_DATA(attr);
+		if (NLA_LEN(attr) == sizeof(*qos)) {
+			acm_log(2, "qos_class 0x%x\n", *qos);
+			val = ntohs(path->qosclass_sl);
+			val &= ~IBV_PATH_RECORD_QOS_MASK;
+			val |= (*qos & IBV_PATH_RECORD_QOS_MASK);
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
+	int resolve_hdr_len;
+	int rem;
+	int total_attr_len;
+	int status;
+	unsigned char *data;
+
+	memset(&msg, 0, sizeof(msg));
+	msg.hdr.opcode = ACM_OP_RESOLVE;
+	msg.hdr.version = ACM_VERSION;
+	msg.hdr.length = ACM_MSG_HDR_LENGTH + ACM_MSG_EP_LENGTH;
+	msg.hdr.status = ACM_STATUS_SUCCESS;
+	msg.hdr.tid = (uint64_t) acmnlmsg;
+	msg.resolve_data[0].type = ACM_EP_INFO_PATH;
+
+	/* We support only one pathrecord */
+	acm_log(2, "path use 0x%x\n", acmnlmsg->resolve_header.path_use);
+	if (acmnlmsg->resolve_header.path_use ==
+	    LS_RESOLVE_PATH_USE_UNIDIRECTIONAL)
+		msg.resolve_data[0].info.path.reversible_numpath = 1;
+	else
+		msg.resolve_data[0].info.path.reversible_numpath =
+			IBV_PATH_RECORD_REVERSIBLE | 1;
+
+	data = (unsigned char *) &acmnlmsg->nlmsg_header + NLMSG_HDRLEN;
+	resolve_hdr_len = NLMSG_ALIGN(sizeof(struct rdma_ls_resolve_header));
+	attr = (struct nlattr *) (data + resolve_hdr_len);
+	payload_len = acmnlmsg->nlmsg_header.nlmsg_len - NLMSG_HDRLEN -
+		resolve_hdr_len;
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
+	if (payload_len < (sizeof(struct rdma_ls_resolve_header) +
+			   sizeof(struct nlattr)))
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
+	/* Currently we handle only request from the local service client */
+	client_inx = RDMA_NL_GET_CLIENT(acmnlmsg->nlmsg_header.nlmsg_type);
+	op = RDMA_NL_GET_OP(acmnlmsg->nlmsg_header.nlmsg_type);
+	if (client_inx != RDMA_NL_LS)
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
+		close(nl_rcv_socket);
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
@@ -1360,12 +1712,14 @@ static void acm_server(void)
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
 
@@ -1399,7 +1753,10 @@ static void acm_server(void)
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
 
@@ -2756,6 +3113,8 @@ int CDECL_FUNC main(int argc, char **argv)
 	acm_server();
 
 	acm_log(0, "shutting down\n");
+	if (client_array[NL_CLIENT_INDEX].sock != INVALID_SOCKET)
+		close(client_array[NL_CLIENT_INDEX].sock);
 	acm_close_providers();
 	acm_stop_sa_handler();
 	umad_done();
diff --git a/src/acm_netlink.h b/src/acm_netlink.h
new file mode 100644
index 0000000..867ae8c
--- /dev/null
+++ b/src/acm_netlink.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright (c) 2015 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under the OpenFabrics.org BSD license
+ * below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#if !defined(ACM_NETLINK_H)
+#define ACM_NETLINK_H
+
+/*
+ * This header file basically copies the local service related defines and
+ * structures from the latest kernel include/uapi/rdma/rdma_netlink.h file
+ * so that ibacm can be built without the latest kernel patches.
+ */
+
+enum {
+	RDMA_NL_LS = 4,	/* RDMA Local Services */
+};
+
+enum {
+	RDMA_NL_GROUP_LS = 3,
+};
+
+/*
+ * Local service operations:
+ *   RESOLVE - The client requests the local service to resolve a path.
+ *   SET_TIMEOUT - The local service requests the client to set the timeout.
+ */
+enum {
+	RDMA_NL_LS_OP_RESOLVE = 0,
+	RDMA_NL_LS_OP_SET_TIMEOUT,
+	RDMA_NL_LS_NUM_OPS
+};
+
+/* Local service netlink message flags */
+#define RDMA_NL_LS_F_ERR	0x0100	/* Failed response */
+
+/*
+ * Local service resolve operation family header.
+ * The layout for the resolve operation:
+ *    nlmsg header
+ *    family header
+ *    attributes
+ */
+
+/*
+ * Local service path use:
+ * Specify how the path(s) will be used.
+ *   ALL - For connected CM operation (6 pathrecords)
+ *   UNIDIRECTIONAL - For unidirectional UD (1 pathrecord)
+ *   GMP - For miscellaneous GMP like operation (at least 1 reversible
+ *         pathrecord)
+ */
+enum {
+	LS_RESOLVE_PATH_USE_ALL = 0,
+	LS_RESOLVE_PATH_USE_UNIDIRECTIONAL,
+	LS_RESOLVE_PATH_USE_GMP,
+	LS_RESOLVE_PATH_USE_MAX
+};
+
+#define LS_DEVICE_NAME_MAX 64
+
+struct rdma_ls_resolve_header {
+	__u8 device_name[LS_DEVICE_NAME_MAX];
+	__u8 port_num;
+	__u8 path_use;
+};
+
+/* Local service attribute type */
+#define RDMA_NLA_F_MANDATORY	(1 << 13)
+#define RDMA_NLA_TYPE_MASK	(~(NLA_F_NESTED | NLA_F_NET_BYTEORDER | \
+				  RDMA_NLA_F_MANDATORY))
+
+/*
+ * Local service attributes:
+ *   Attr Name       Size                       Byte order
+ *   -----------------------------------------------------
+ *   PATH_RECORD     struct ib_path_rec_data
+ *   TIMEOUT         u32                        cpu
+ *   SERVICE_ID      u64                        cpu
+ *   DGID            u8[16]                     BE
+ *   SGID            u8[16]                     BE
+ *   TCLASS          u8
+ *   PKEY            u16                        cpu
+ *   QOS_CLASS       u16                        cpu
+ */
+enum {
+	LS_NLA_TYPE_UNSPEC = 0,
+	LS_NLA_TYPE_PATH_RECORD,
+	LS_NLA_TYPE_TIMEOUT,
+	LS_NLA_TYPE_SERVICE_ID,
+	LS_NLA_TYPE_DGID,
+	LS_NLA_TYPE_SGID,
+	LS_NLA_TYPE_TCLASS,
+	LS_NLA_TYPE_PKEY,
+	LS_NLA_TYPE_QOS_CLASS,
+	LS_NLA_TYPE_MAX
+};
+
+/* Local service DGID/SGID attribute: big endian */
+struct rdma_nla_ls_gid {
+	__u8		gid[16];
+};
+
+#endif /* ACM_NETLINK_H */
-- 
1.8.2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

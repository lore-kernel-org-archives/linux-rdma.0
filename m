From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] ibacm: Add support for pathrecord query through netlink
Date: Mon, 18 May 2015 15:01:14 -0400
Message-ID: <1431975674-23602-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch enables ibacm to process pathrecord queries through netlink.
Since ibacm can cache pathrecords, this implementation provides an easy
pathrecord cache for kernel components and therefore offers great
performance advantage on large fabric systems. At this time, only
non-RMPP SA pathrecord queries are supported. All other queries will be
returned with errors.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |  219 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 216 insertions(+), 3 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 7649725..360ceca 100644
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
@@ -55,6 +57,7 @@
 #include <netinet/in.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
+#include <rdma/rdma_netlink.h>
 #include <poll.h>
 #include "acm_mad.h"
 #include "acm_util.h"
@@ -66,6 +69,14 @@
 #define MAX_EP_ADDR 4
 #define NL_MSG_BUF_SIZE 4096
 #define ACM_PROV_NAME_SIZE 64
+#define NL_CLIENT_INDEX 0
+#ifndef RDMA_NL_GROUP_MAD
+	#define RDMA_NL_GROUP_MAD 3
+	#define RDMA_NL_MAD 4
+	#define RDMA_NL_MAD_REQUEST 0
+#endif
+#define RDMA_NL_TYPE_MAD_REQUEST \
+	RDMA_NL_GET_TYPE(RDMA_NL_MAD, RDMA_NL_MAD_REQUEST)
 
 struct acmc_subnet {
 	DLIST_ENTRY            entry;
@@ -151,6 +162,14 @@ struct acmc_sa_req {
 	struct acm_sa_mad	mad;
 };
 
+struct acm_nl_resolve_msg {
+	struct nlmsghdr			nlmsg_header;
+	union {
+		struct acm_mad		mad;
+		struct ib_sa_mad	sa_mad;
+	};
+};
+
 static char def_prov_name[ACM_PROV_NAME_SIZE] = "ibacmp";
 static DLIST_ENTRY provider_list;
 static struct acmc_prov *def_provider = NULL;
@@ -172,6 +191,7 @@ static struct acmc_ep *acm_find_ep(struct acmc_port *port, uint16_t pkey);
 static int acm_ep_insert_addr(struct acmc_ep *ep, const char *name, uint8_t *addr,
 			      size_t addr_len, uint8_t addr_type);
 static void acm_event_handler(struct acmc_device *dev);
+static int acm_nl_send(SOCKET sock, struct acm_msg *msg);
 
 static struct sa_data {
 	int		timeout;
@@ -466,7 +486,11 @@ int acm_resolve_response(uint64_t id, struct acm_msg *msg)
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
@@ -597,6 +621,8 @@ static void acm_svr_accept(void)
 	}
 
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
+		if (i == NL_CLIENT_INDEX)
+			continue;
 		if (!atomic_get(&client_array[i].refcnt))
 			break;
 	}
@@ -1346,6 +1372,188 @@ static void acm_ipnl_handler(void)
 	}
 }
 
+static int acm_nl_send(SOCKET sock, struct acm_msg *msg)
+{
+	struct sockaddr_nl dst_addr;
+	struct acm_nl_resolve_msg acmnlmsg;
+	struct acm_nl_resolve_msg *orig;
+	struct ib_sa_mad *sa_mad = &acmnlmsg.sa_mad;
+	int ret;
+	int datalen;
+
+	orig = (struct acm_nl_resolve_msg *) msg->hdr.tid;
+
+	memset(&dst_addr, 0, sizeof(dst_addr));
+	dst_addr.nl_family = AF_NETLINK;
+	dst_addr.nl_groups = (1 << (RDMA_NL_GROUP_MAD - 1));
+
+	memset(&acmnlmsg, 0, sizeof(acmnlmsg));
+	datalen = sizeof(acmnlmsg);
+	acmnlmsg.nlmsg_header.nlmsg_len = datalen;
+	acmnlmsg.nlmsg_header.nlmsg_pid = getpid();
+	acmnlmsg.nlmsg_header.nlmsg_type = RDMA_NL_TYPE_MAD_REQUEST;
+	acmnlmsg.nlmsg_header.nlmsg_flags = NLM_F_REQUEST;
+	acmnlmsg.nlmsg_header.nlmsg_seq = orig->nlmsg_header.nlmsg_seq;
+
+	if (msg->hdr.status != ACM_STATUS_SUCCESS) {
+		acm_log(2, "acm status no success = %d\n", msg->hdr.status);
+		memcpy(&acmnlmsg.mad, &orig->mad,
+		       sizeof(acmnlmsg.mad));
+		acmnlmsg.mad.method |= IB_METHOD_RESP;
+		sa_mad->status = htons(UMAD_SA_STATUS_NO_RECORDS);
+	} else {
+		acm_log(2, "acm status success\n");
+		memcpy(sa_mad, &orig->sa_mad,
+		       sizeof(*sa_mad) - sizeof(sa_mad->data));
+		sa_mad->method |= IB_METHOD_RESP;
+		sa_mad->status = UMAD_SA_STATUS_SUCCESS;
+		memcpy(sa_mad->data, &msg->resolve_data[0].info.path,
+		       ACM_MSG_EP_LENGTH);
+	}
+
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
+static inline int acm_nl_supported_sa_mad(struct ib_sa_mad *sa_mad)
+{
+	return (sa_mad->rmpp_version == 0 &&
+		sa_mad->method == UMAD_METHOD_GET &&
+		sa_mad->attr_id == htons(UMAD_SA_ATTR_PATH_REC));
+}
+
+static void acm_nl_process_sa_mad(struct acmc_client *client,
+				  struct acm_nl_resolve_msg *acmnlmsg)
+{
+	struct acm_msg msg;
+	struct ib_sa_mad *sa_mad = &acmnlmsg->sa_mad;
+
+	acm_format_name(2, log_data, sizeof(log_data), ACM_ADDRESS_GID,
+			&sa_mad->data[8], sizeof(union ibv_gid));
+	acm_log(2, "path dgid %s\n", log_data);
+	acm_format_name(2, log_data, sizeof(log_data), ACM_ADDRESS_GID,
+			&sa_mad->data[24], sizeof(union ibv_gid));
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
+	memcpy(&msg.resolve_data[0].info.path, &sa_mad->data,
+	       sizeof(struct ibv_path_record));
+
+	acm_svr_resolve(client, &msg);
+}
+
+static void acm_nl_process_invalid_mad(struct acmc_client *client,
+				  struct acm_nl_resolve_msg *acmnlmsg)
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
+static void acm_nl_receive(struct acmc_client *client)
+{
+	struct acm_nl_resolve_msg *acmnlmsg;
+	int datalen = sizeof(*acmnlmsg);
+	int ret;
+
+	acmnlmsg = calloc(1, sizeof(*acmnlmsg));
+	if (!acmnlmsg) {
+		acm_log(0, "Out of memory for recving nl msg.\n");
+		return;
+	}
+	ret = recv(client->sock, acmnlmsg, datalen, 0);
+	if (ret < 0 && errno == ENOBUFS) {
+		acm_log(0, "ENOBUFS returned from netlink receive.\n");
+		free(acmnlmsg);
+		return;
+	}
+
+	acm_log(2, "nlmsg: len %d type 0x%x flags 0x%x seq %d pid %d\n",
+		acmnlmsg->nlmsg_header.nlmsg_len,
+		acmnlmsg->nlmsg_header.nlmsg_type,
+		acmnlmsg->nlmsg_header.nlmsg_flags,
+		acmnlmsg->nlmsg_header.nlmsg_seq,
+		acmnlmsg->nlmsg_header.nlmsg_pid);
+	if (acmnlmsg->nlmsg_header.nlmsg_type != NLMSG_DONE) {
+		switch (acmnlmsg->mad.mgmt_class) {
+		case UMAD_CLASS_SUBN_ADM:
+			if (acm_nl_supported_sa_mad(&acmnlmsg->sa_mad)) {
+				acm_nl_process_sa_mad(client, acmnlmsg);
+			} else {
+				acm_log(1, "WARN SA: mtd %x att %x rmpp %x\n",
+					acmnlmsg->sa_mad.method,
+					acmnlmsg->sa_mad.attr_id,
+					acmnlmsg->sa_mad.rmpp_version);
+				acm_nl_process_invalid_mad(client, acmnlmsg);
+			}
+			break;
+		default:
+			/* Not supported*/
+			acm_log(1, "WARN - invalid cls %x mtd %x\n",
+				acmnlmsg->mad.mgmt_class, acmnlmsg->mad.method);
+			acm_nl_process_invalid_mad(client, acmnlmsg);
+			break;
+		}
+	} else {
+		free(acmnlmsg);
+	}
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
+	src_addr.nl_groups = (1 << (RDMA_NL_GROUP_MAD - 1));
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
@@ -1360,12 +1568,14 @@ static void acm_server(void)
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
 
@@ -1399,7 +1609,10 @@ static void acm_server(void)
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

From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/8] rdma_xserver/client: Add new test apps
Date: Wed, 15 Jun 2011 17:47:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021332@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add new versions of the rdma_server and rdma_client tests that
support other types of connections and show how to use more
RDMA features.  We keep the existing rdma_server and rdma_client
tests as simple examples.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Yes - the man pages aren't up to date.  I'll fix that before
committing, plus I need additional man pages.

 Makefile.am             |    9 +
 examples/rdma_xclient.c |  297 ++++++++++++++++++++++++++++++++++++++
 examples/rdma_xserver.c |  370 +++++++++++++++++++++++++++++++++++++++++++++++
 man/rdma_xclient.1      |   31 ++++
 man/rdma_xserver.1      |   26 +++
 5 files changed, 732 insertions(+), 1 deletions(-)
 create mode 100644 examples/rdma_xclient.c
 create mode 100644 examples/rdma_xserver.c
 create mode 100644 man/rdma_xclient.1
 create mode 100644 man/rdma_xserver.1

diff --git a/Makefile.am b/Makefile.am
index 4e92e35..ef0b5db 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -19,7 +19,8 @@ src_librdmacm_la_LDFLAGS = -version-info 1 -export-dynamic \
 src_librdmacm_la_DEPENDENCIES =  $(srcdir)/src/librdmacm.map
 
 bin_PROGRAMS = examples/ucmatose examples/rping examples/udaddy examples/mckey \
-	       examples/rdma_client examples/rdma_server
+	       examples/rdma_client examples/rdma_server examples/rdma_xclient \
+	       examples/rdma_xserver
 examples_ucmatose_SOURCES = examples/cmatose.c
 examples_ucmatose_LDADD = $(top_builddir)/src/librdmacm.la
 examples_rping_SOURCES = examples/rping.c
@@ -32,6 +33,10 @@ examples_rdma_client_SOURCES = examples/rdma_client.c
 examples_rdma_client_LDADD = $(top_builddir)/src/librdmacm.la
 examples_rdma_server_SOURCES = examples/rdma_server.c
 examples_rdma_server_LDADD = $(top_builddir)/src/librdmacm.la
+examples_rdma_xclient_SOURCES = examples/rdma_xclient.c
+examples_rdma_xclient_LDADD = $(top_builddir)/src/librdmacm.la
+examples_rdma_xserver_SOURCES = examples/rdma_xserver.c
+examples_rdma_xserver_LDADD = $(top_builddir)/src/librdmacm.la
 
 librdmacmincludedir = $(includedir)/rdma
 infinibandincludedir = $(includedir)/infiniband
@@ -96,6 +101,8 @@ man_MANS = \
 	man/rping.1 \
 	man/rdma_server.1 \
 	man/rdma_client.1 \
+	man/rdma_xserver.1 \
+	man/rdma_xclient.1 \
 	man/rdma_cm.7
 
 EXTRA_DIST = src/cma.h src/librdmacm.map librdmacm.spec.in $(man_MANS)
diff --git a/examples/rdma_xclient.c b/examples/rdma_xclient.c
new file mode 100644
index 0000000..e192290
--- /dev/null
+++ b/examples/rdma_xclient.c
@@ -0,0 +1,297 @@
+/*
+ * Copyright (c) 2010-2011 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under the OpenIB.org BSD license
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <getopt.h>
+#include <ctype.h>
+#include <rdma/rdma_cma.h>
+#include <rdma/rdma_verbs.h>
+
+static char *server = "127.0.0.1";
+static char port[6] = "7471";
+
+static int (*run_func)() = NULL;
+struct rdma_cm_id *id;
+struct ibv_mr *mr;
+enum ibv_qp_type qpt = IBV_QPT_RC;
+
+#define MSG_SIZE 16
+uint8_t send_msg[MSG_SIZE];
+uint8_t recv_msg[MSG_SIZE];
+
+#ifdef IBV_XRC_OPS
+#define PRINT_XRC_OPT printf("\t    x - XRC: extended-reliable-connected\n")
+uint32_t srqn;
+
+/*
+ * Connect XRC SEND QP.
+ */
+static int xrc_connect_send(void)
+{
+	struct rdma_addrinfo hints, *res;
+	struct ibv_qp_init_attr attr;
+	int ret;
+
+	memset(&hints, 0, sizeof hints);
+	hints.ai_port_space = RDMA_PS_IB;
+	hints.ai_qp_type = IBV_QPT_XRC_SEND;
+	ret = rdma_getaddrinfo(server, port, &hints, &res);
+	if (ret) {
+		printf("rdma_getaddrinfo connect send %d\n", errno);
+		return ret;
+	}
+
+	memset(&attr, 0, sizeof attr);
+	attr.cap.max_send_wr = 1;
+	attr.cap.max_send_sge = 1;
+	attr.cap.max_inline_data = sizeof send_msg;
+	attr.qp_context = id;
+	attr.sq_sig_all = 1;
+	ret = rdma_create_ep(&id, res, NULL, &attr);
+	rdma_freeaddrinfo(res);
+	if (ret) {
+		printf("rdma_create_ep send qp %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_connect(id, NULL);
+	if (ret) {
+		printf("rdma_connect send qp %d\n", errno);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Resolve remote SRQ number
+ */
+static int xrc_resolve_srqn(void)
+{
+	struct rdma_addrinfo hints, *res;
+	struct rdma_cm_id *id;
+	int ret;
+
+	memset(&hints, 0, sizeof hints);
+	hints.ai_qp_type = IBV_QPT_UD; /* for now */
+	hints.ai_port_space = RDMA_PS_IB;
+	sprintf(port, "%d", atoi(port) + 1);
+	ret = rdma_getaddrinfo(server, port, &hints, &res);
+	if (ret) {
+		printf("rdma_getaddrinfo resolve srqn %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_create_ep(&id, res, NULL, NULL);
+	rdma_freeaddrinfo(res);
+	if (ret) {
+		printf("rdma_create_ep for srqn %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_connect(id, NULL);
+	if (ret) {
+		printf("rdma_connect for srqn %d\n", errno);
+		return ret;
+	}
+
+	srqn = id->event->param.ud.qp_num;
+	rdma_destroy_ep(id);
+	return 0;
+}
+
+static int xrc_test(void)
+{
+	struct ibv_send_wr wr, *bad;
+	struct ibv_sge sge;
+	struct ibv_wc wc;
+	int ret;
+
+	ret = xrc_connect_send();
+	if (ret)
+		return ret;
+
+	ret = xrc_resolve_srqn();
+	if (ret)
+		return ret;
+
+	sge.addr = (uint64_t) (uintptr_t) send_msg;
+	sge.length = (uint32_t) sizeof send_msg;
+	sge.lkey = 0;
+	wr.wr_id = (uintptr_t) NULL;
+	wr.next = NULL;
+	wr.sg_list = &sge;
+	wr.num_sge = 1;
+	wr.opcode = IBV_WR_SEND;
+	wr.send_flags = IBV_SEND_INLINE;
+	wr.wr.xrc.remote_srqn = srqn;
+
+	ret = ibv_post_send(id->qp, &wr, &bad);
+	if (ret) {
+		printf("rdma_post_send %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_get_send_comp(id, &wc);
+	if (ret <= 0) {
+		printf("rdma_get_recv_comp %d\n", ret);
+		return ret;
+	}
+
+	rdma_disconnect(id);
+	rdma_destroy_ep(id);
+	return 0;
+}
+
+static inline int set_xrc_qpt(void)
+{
+	qpt = IBV_QPT_XRC_SEND;
+	run_func = xrc_test;
+	return 0;
+}
+
+#else
+#define PRINT_XRC_OPT
+#define set_xrc_qpt() -1
+#endif /* IBV_XRC_OPS */
+
+static int rc_test(void)
+{
+	struct rdma_addrinfo hints, *res;
+	struct ibv_qp_init_attr attr;
+	struct ibv_wc wc;
+	int ret;
+
+	memset(&hints, 0, sizeof hints);
+	hints.ai_port_space = RDMA_PS_TCP;
+	ret = rdma_getaddrinfo(server, port, &hints, &res);
+	if (ret) {
+		printf("rdma_getaddrinfo %d\n", errno);
+		return ret;
+	}
+
+	memset(&attr, 0, sizeof attr);
+	attr.cap.max_send_wr = attr.cap.max_recv_wr = 1;
+	attr.cap.max_send_sge = attr.cap.max_recv_sge = 1;
+	attr.cap.max_inline_data = sizeof send_msg;
+	attr.qp_context = id;
+	attr.sq_sig_all = 1;
+	ret = rdma_create_ep(&id, res, NULL, &attr);
+	rdma_freeaddrinfo(res);
+	if (ret) {
+		printf("rdma_create_ep %d\n", errno);
+		return ret;
+	}
+
+	mr = rdma_reg_msgs(id, recv_msg, sizeof recv_msg);
+	if (!mr) {
+		printf("rdma_reg_msgs %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_post_recv(id, NULL, recv_msg, sizeof recv_msg, mr);
+	if (ret) {
+		printf("rdma_post_recv %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_connect(id, NULL);
+	if (ret) {
+		printf("rdma_connect %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_post_send(id, NULL, send_msg, sizeof send_msg, NULL, IBV_SEND_INLINE);
+	if (ret) {
+		printf("rdma_post_send %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_get_recv_comp(id, &wc);
+	if (ret <= 0) {
+		printf("rdma_get_recv_comp %d\n", ret);
+		return ret;
+	}
+
+	rdma_disconnect(id);
+	rdma_dereg_mr(mr);
+	rdma_destroy_ep(id);
+	return 0;
+}
+
+static int set_qpt(char type)
+{
+	if (type == 'r') {
+		qpt = IBV_QPT_RC;
+		return 0;
+	} else if (type == 'x') {
+		return set_xrc_qpt();
+	}
+	return -1;
+}
+
+int main(int argc, char **argv)
+{
+	int op, ret;
+
+	run_func = rc_test;
+	while ((op = getopt(argc, argv, "s:p:c:")) != -1) {
+		switch (op) {
+		case 's':
+			server = optarg;
+			break;
+		case 'p':
+			strncpy(port, optarg, sizeof port - 1);
+			break;
+		case 'c':
+			if (set_qpt(tolower(optarg[0])))
+				goto err;
+			break;
+		default:
+			goto err;
+		}
+	}
+
+	printf("%s: start\n", argv[0]);
+	ret = run_func();
+	printf("%s: end %d\n", argv[0], ret);
+	return ret;
+
+err:
+	printf("usage: %s\n", argv[0]);
+	printf("\t[-s server]\n");
+	printf("\t[-p port_number]\n");
+	printf("\t[-c communication type]\n");
+	printf("\t    r - RC: reliable-connected (default)\n");
+	PRINT_XRC_OPT;
+	exit(1);
+}
diff --git a/examples/rdma_xserver.c b/examples/rdma_xserver.c
new file mode 100644
index 0000000..48f9629
--- /dev/null
+++ b/examples/rdma_xserver.c
@@ -0,0 +1,370 @@
+/*
+ * Copyright (c) 2005-2011 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under the OpenIB.org BSD license
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <ctype.h>
+#include <netinet/in.h>
+#include <rdma/rdma_cma.h>
+#include <rdma/rdma_verbs.h>
+
+static char *port = "7471";
+
+static int (*run_func)();
+struct rdma_cm_id *listen_id, *id;
+struct ibv_mr *mr;
+enum ibv_qp_type qpt = IBV_QPT_RC;
+
+#define MSG_SIZE 16
+uint8_t send_msg[MSG_SIZE];
+uint8_t recv_msg[MSG_SIZE];
+
+
+#ifdef IBV_XRC_OPS
+#define PRINT_XRC_OPT printf("\t    x - XRC: extended-reliable-connected\n")
+struct rdma_cm_id *srq_id;
+
+/*
+ * Listen for XRC RECV QP connection request.
+ */
+static struct rdma_cm_id * xrc_listen_recv(void)
+{
+	struct rdma_addrinfo hints, *res;
+	struct rdma_cm_id *id;
+	int ret;
+
+	memset(&hints, 0, sizeof hints);
+	hints.ai_flags = RAI_PASSIVE;
+	hints.ai_port_space = RDMA_PS_IB;
+	hints.ai_qp_type = IBV_QPT_XRC_RECV;
+	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
+	if (ret) {
+		printf("rdma_getaddrinfo listen recv %d\n", errno);
+		return NULL;
+	}
+
+	ret = rdma_create_ep(&listen_id, res, NULL, NULL);
+	rdma_freeaddrinfo(res);
+	if (ret) {
+		printf("rdma_create_ep listen recv %d\n", errno);
+		return NULL;
+	}
+
+	ret = rdma_listen(listen_id, 0);
+	if (ret) {
+		printf("rdma_listen %d\n", errno);
+		return NULL;
+	}
+
+	ret = rdma_get_request(listen_id, &id);
+	if (ret) {
+		printf("rdma_get_request %d\n", errno);
+		return NULL;
+	}
+
+	return id;
+}
+
+/*
+ * Create SRQ and listen for XRC SRQN lookup request.
+ */
+static int xrc_create_srq_listen(struct sockaddr *addr, socklen_t addr_len)
+{
+	struct rdma_addrinfo rai;
+	struct sockaddr_storage ss;
+	struct ibv_srq_init_attr attr;
+	int ret;
+
+	memset(&rai, 0, sizeof rai);
+	rai.ai_flags = RAI_PASSIVE;
+	rai.ai_family = addr->sa_family;
+	rai.ai_qp_type = IBV_QPT_UD; /* for now */
+	rai.ai_port_space = RDMA_PS_IB;
+	memcpy(&ss, addr, addr_len);
+	rai.ai_src_len = addr_len;
+	rai.ai_src_addr = (struct sockaddr *) &ss;
+	((struct sockaddr_in *) &ss)->sin_port = htons((short) atoi(port) + 1);
+
+	ret = rdma_create_ep(&srq_id, &rai, NULL, NULL);
+	if (ret) {
+		printf("rdma_create_ep srq ep %d\n", errno);
+		return ret;
+	}
+
+	memset(&attr, 0, sizeof attr);
+	attr.attr.max_wr = 1;
+	attr.attr.max_sge = 1;
+	attr.srq_type = IBV_SRQT_XRC;
+
+	attr.ext.xrc.xrcd = ibv_open_xrcd(srq_id->verbs, -1, 0);
+	if (!attr.ext.xrc.xrcd) {
+		printf("Unable to open xrcd\n");
+		return -1;
+	}
+
+	ret = rdma_create_srq(srq_id, NULL, &attr);
+	if (ret) {
+		printf("Unable to create srq %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_listen(srq_id, 0);
+	if (ret) {
+		printf("rdma_listen srq id %d\n", errno);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int xrc_test(void)
+{
+	struct rdma_cm_id *conn_id, *lookup_id;
+	struct ibv_qp_init_attr attr;
+	struct rdma_conn_param param;
+	struct rdma_cm_event *event;
+	struct ibv_wc wc;
+	int ret;
+
+	conn_id = xrc_listen_recv();
+	if (!conn_id)
+		return -1;
+
+	ret = xrc_create_srq_listen(rdma_get_local_addr(conn_id),
+				    sizeof(struct sockaddr_storage));
+	if (ret)
+		return -1;
+
+	memset(&attr, 0, sizeof attr);
+	attr.qp_type = IBV_QPT_XRC_RECV;
+	attr.ext.xrc_recv.xrcd = srq_id->srq->ext.xrc.xrcd;
+	ret = rdma_create_qp(conn_id, NULL, &attr);
+	if (ret) {
+		printf("Unable to create xrc recv qp %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_accept(conn_id, NULL);
+	if (ret) {
+		printf("rdma_accept failed for xrc recv qp %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_get_request(srq_id, &lookup_id);
+	if (ret) {
+		printf("rdma_get_request %d\n", errno);
+		return ret;
+	}
+
+	mr = rdma_reg_msgs(srq_id, recv_msg, sizeof recv_msg);
+	if (!mr) {
+		printf("ibv_reg_msgs %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_post_recv(srq_id, NULL, recv_msg, sizeof recv_msg, mr);
+	if (ret) {
+		printf("rdma_post_recv %d\n", errno);
+		return ret;
+	}
+
+	memset(&param, 0, sizeof param);
+	param.qp_num = srq_id->srq->ext.xrc.srq_num;
+	ret = rdma_accept(lookup_id, &param);
+	if (ret) {
+		printf("rdma_accept failed for srqn lookup %d\n", errno);
+		return ret;
+	}
+
+	rdma_destroy_id(lookup_id);
+
+	ret = rdma_get_recv_comp(srq_id, &wc);
+	if (ret <= 0) {
+		printf("rdma_get_recv_comp %d\n", ret);
+		return ret;
+	}
+
+	ret = rdma_get_cm_event(conn_id->channel, &event);
+	if (ret || event->event != RDMA_CM_EVENT_DISCONNECTED) {
+		printf("Failed to get disconnect event\n");
+		return -1;
+	}
+
+	rdma_ack_cm_event(event);
+	rdma_disconnect(conn_id);
+	rdma_destroy_ep(conn_id);
+	rdma_dereg_mr(mr);
+	rdma_destroy_ep(srq_id);
+	rdma_destroy_ep(listen_id);
+	return 0;
+}
+
+static inline int set_xrc_qpt(void)
+{
+	qpt = IBV_QPT_XRC_RECV;
+	run_func = xrc_test;
+	return 0;
+}
+
+#else
+#define PRINT_XRC_OPT
+#define set_xrc_qpt() -1
+#endif /* IBV_XRC_OPS */
+
+
+static int rc_test(void)
+{
+	struct rdma_addrinfo hints, *res;
+	struct ibv_qp_init_attr attr;
+	struct ibv_wc wc;
+	int ret;
+
+	memset(&hints, 0, sizeof hints);
+	hints.ai_flags = RAI_PASSIVE;
+	hints.ai_port_space = RDMA_PS_TCP;
+	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
+	if (ret) {
+		printf("rdma_getaddrinfo %d\n", errno);
+		return ret;
+	}
+
+	memset(&attr, 0, sizeof attr);
+	attr.cap.max_send_wr = attr.cap.max_recv_wr = 1;
+	attr.cap.max_send_sge = attr.cap.max_recv_sge = 1;
+	attr.cap.max_inline_data = sizeof send_msg;
+	attr.sq_sig_all = 1;
+	ret = rdma_create_ep(&listen_id, res, NULL, &attr);
+	rdma_freeaddrinfo(res);
+	if (ret) {
+		printf("rdma_create_ep %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_listen(listen_id, 0);
+	if (ret) {
+		printf("rdma_listen %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_get_request(listen_id, &id);
+	if (ret) {
+		printf("rdma_get_request %d\n", errno);
+		return ret;
+	}
+
+	mr = rdma_reg_msgs(id, recv_msg, sizeof recv_msg);
+	if (!mr) {
+		printf("rdma_reg_msgs %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_post_recv(id, NULL, recv_msg, sizeof recv_msg, mr);
+	if (ret) {
+		printf("rdma_post_recv %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_accept(id, NULL);
+	if (ret) {
+		printf("rdma_accept %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_get_recv_comp(id, &wc);
+	if (ret <= 0) {
+		printf("rdma_get_recv_comp %d\n", ret);
+		return ret;
+	}
+
+	ret = rdma_post_send(id, NULL, send_msg, sizeof send_msg, NULL, IBV_SEND_INLINE);
+	if (ret) {
+		printf("rdma_post_send %d\n", errno);
+		return ret;
+	}
+
+	ret = rdma_get_send_comp(id, &wc);
+	if (ret <= 0) {
+		printf("rdma_get_send_comp %d\n", ret);
+		return ret;
+	}
+
+	rdma_disconnect(id);
+	rdma_dereg_mr(mr);
+	rdma_destroy_ep(id);
+	rdma_destroy_ep(listen_id);
+	return 0;
+}
+
+static int set_qpt(char type)
+{
+	if (type == 'r') {
+		qpt = IBV_QPT_RC;
+		return 0;
+	} else if (type == 'x') {
+		return set_xrc_qpt();
+	}
+	return -1;
+}
+
+int main(int argc, char **argv)
+{
+	int op, ret;
+
+	run_func = rc_test;
+	while ((op = getopt(argc, argv, "p:c:")) != -1) {
+		switch (op) {
+		case 'p':
+			port = optarg;
+			break;
+		case 'c':
+			if (set_qpt(tolower(optarg[0])))
+				goto err;
+			break;
+		default:
+			goto err;
+		}
+	}
+
+	printf("%s: start\n", argv[0]);
+	ret = run_func();
+	printf("%s: end %d\n", argv[0], ret);
+	return ret;
+
+err:
+	printf("usage: %s\n", argv[0]);
+	printf("\t[-p port_number]\n");
+	printf("\t[-c communication type]\n");
+	printf("\t    r - RC: reliable-connected (default)\n");
+	PRINT_XRC_OPT;
+	exit(1);
+}
diff --git a/man/rdma_xclient.1 b/man/rdma_xclient.1
new file mode 100644
index 0000000..68bfc76
--- /dev/null
+++ b/man/rdma_xclient.1
@@ -0,0 +1,31 @@
+.TH "RDMA_CLIENT" 1 "2010-07-19" "librdmacm" "librdmacm" librdmacm
+.SH NAME
+rdma_client \- simple RDMA CM connection and ping-pong test.
+.SH SYNOPSIS
+.sp
+.nf
+\fIrdma_client\fR [-s server_address] [-p server_port]
+.fi
+.SH "DESCRIPTION"
+Uses synchronous librdmam calls to establish an RDMA connection between
+two nodes.  This example is intended to provide a very simple coding
+example of how to use RDMA.
+.SH "OPTIONS"
+.TP
+\-s server_address
+Specifies the address of the system that the rdma_server is running on.
+By default, the client will attempt to connect to the server using
+127.0.0.1.
+.TP
+\-p server_port
+Specifies the port number that the server listens on.  By default the server
+listens on port 7471.
+.SH "NOTES"
+Basic usage is to start rdma_server, then connect to the server using the
+rdma_client program.
+.P
+Because this test maps RDMA resources to userspace, users must ensure
+that they have available system resources and permissions.  See the
+libibverbs README file for additional details.
+.SH "SEE ALSO"
+rdma_cm(7), udaddy(1), mckey(1), rping(1), rdma_server(1)
diff --git a/man/rdma_xserver.1 b/man/rdma_xserver.1
new file mode 100644
index 0000000..19f4860
--- /dev/null
+++ b/man/rdma_xserver.1
@@ -0,0 +1,26 @@
+.TH "RDMA_SERVER" 1 "2010-07-19" "librdmacm" "librdmacm" librdmacm
+.SH NAME
+rdma_server \- simple RDMA CM connection and ping-pong test.
+.SH SYNOPSIS
+.sp
+.nf
+\fIrdma_server\fR [-p port]
+.fi
+.SH "DESCRIPTION"
+Uses synchronous librdmam calls to establish an RDMA connections between
+two nodes.  This example is intended to provide a very simple coding
+example of how to use RDMA.
+.SH "OPTIONS"
+.TP
+\-p port
+Changes the port number that the server listens on.  By default the server
+listens on port 7471.
+.SH "NOTES"
+Basic usage is to start rdma_server, then connect to the server using the
+rdma_client program.
+.P
+Because this test maps RDMA resources to userspace, users must ensure
+that they have available system resources and permissions.  See the
+libibverbs README file for additional details.
+.SH "SEE ALSO"
+rdma_cm(7), udaddy(1), mckey(1), rping(1), rdma_client(1)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

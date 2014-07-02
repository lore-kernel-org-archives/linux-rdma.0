From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 8/8] example/rdma_xclient/server: Update XRC support in sample programs
Date: Tue,  1 Jul 2014 23:11:19 -0700
Message-ID: <1404281479-6755-9-git-send-email-sean.hefty@intel.com>
References: <1404281479-6755-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404281479-6755-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Update rdma_xclient and rdma_xserver sample programs to test
XRC data transfers.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/rdma_xclient.c |  195 ++++++--------------------------
 examples/rdma_xserver.c |  285 ++++++++---------------------------------------
 2 files changed, 86 insertions(+), 394 deletions(-)

diff --git a/examples/rdma_xclient.c b/examples/rdma_xclient.c
index e192290..6510408 100644
--- a/examples/rdma_xclient.c
+++ b/examples/rdma_xclient.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010-2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2010-2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -39,111 +39,19 @@
 static char *server = "127.0.0.1";
 static char port[6] = "7471";
 
-static int (*run_func)() = NULL;
 struct rdma_cm_id *id;
 struct ibv_mr *mr;
-enum ibv_qp_type qpt = IBV_QPT_RC;
+struct rdma_addrinfo hints;
 
-#define MSG_SIZE 16
-uint8_t send_msg[MSG_SIZE];
-uint8_t recv_msg[MSG_SIZE];
-
-#ifdef IBV_XRC_OPS
-#define PRINT_XRC_OPT printf("\t    x - XRC: extended-reliable-connected\n")
+uint8_t send_msg[16];
 uint32_t srqn;
 
-/*
- * Connect XRC SEND QP.
- */
-static int xrc_connect_send(void)
-{
-	struct rdma_addrinfo hints, *res;
-	struct ibv_qp_init_attr attr;
-	int ret;
-
-	memset(&hints, 0, sizeof hints);
-	hints.ai_port_space = RDMA_PS_IB;
-	hints.ai_qp_type = IBV_QPT_XRC_SEND;
-	ret = rdma_getaddrinfo(server, port, &hints, &res);
-	if (ret) {
-		printf("rdma_getaddrinfo connect send %d\n", errno);
-		return ret;
-	}
-
-	memset(&attr, 0, sizeof attr);
-	attr.cap.max_send_wr = 1;
-	attr.cap.max_send_sge = 1;
-	attr.cap.max_inline_data = sizeof send_msg;
-	attr.qp_context = id;
-	attr.sq_sig_all = 1;
-	ret = rdma_create_ep(&id, res, NULL, &attr);
-	rdma_freeaddrinfo(res);
-	if (ret) {
-		printf("rdma_create_ep send qp %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_connect(id, NULL);
-	if (ret) {
-		printf("rdma_connect send qp %d\n", errno);
-		return ret;
-	}
-
-	return 0;
-}
-
-/*
- * Resolve remote SRQ number
- */
-static int xrc_resolve_srqn(void)
-{
-	struct rdma_addrinfo hints, *res;
-	struct rdma_cm_id *id;
-	int ret;
-
-	memset(&hints, 0, sizeof hints);
-	hints.ai_qp_type = IBV_QPT_UD; /* for now */
-	hints.ai_port_space = RDMA_PS_IB;
-	sprintf(port, "%d", atoi(port) + 1);
-	ret = rdma_getaddrinfo(server, port, &hints, &res);
-	if (ret) {
-		printf("rdma_getaddrinfo resolve srqn %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_create_ep(&id, res, NULL, NULL);
-	rdma_freeaddrinfo(res);
-	if (ret) {
-		printf("rdma_create_ep for srqn %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_connect(id, NULL);
-	if (ret) {
-		printf("rdma_connect for srqn %d\n", errno);
-		return ret;
-	}
-
-	srqn = id->event->param.ud.qp_num;
-	rdma_destroy_ep(id);
-	return 0;
-}
-
-static int xrc_test(void)
+static int post_send(void)
 {
 	struct ibv_send_wr wr, *bad;
 	struct ibv_sge sge;
-	struct ibv_wc wc;
 	int ret;
 
-	ret = xrc_connect_send();
-	if (ret)
-		return ret;
-
-	ret = xrc_resolve_srqn();
-	if (ret)
-		return ret;
-
 	sge.addr = (uint64_t) (uintptr_t) send_msg;
 	sge.length = (uint32_t) sizeof send_msg;
 	sge.lkey = 0;
@@ -153,92 +61,64 @@ static int xrc_test(void)
 	wr.num_sge = 1;
 	wr.opcode = IBV_WR_SEND;
 	wr.send_flags = IBV_SEND_INLINE;
-	wr.wr.xrc.remote_srqn = srqn;
+	if (hints.ai_qp_type == IBV_QPT_XRC_SEND)
+		wr.qp_type.xrc.remote_srqn = srqn;
 
 	ret = ibv_post_send(id->qp, &wr, &bad);
-	if (ret) {
-		printf("rdma_post_send %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_get_send_comp(id, &wc);
-	if (ret <= 0) {
-		printf("rdma_get_recv_comp %d\n", ret);
-		return ret;
-	}
-
-	rdma_disconnect(id);
-	rdma_destroy_ep(id);
-	return 0;
-}
+	if (ret)
+		perror("rdma_post_send");
 
-static inline int set_xrc_qpt(void)
-{
-	qpt = IBV_QPT_XRC_SEND;
-	run_func = xrc_test;
-	return 0;
+	return ret;
 }
 
-#else
-#define PRINT_XRC_OPT
-#define set_xrc_qpt() -1
-#endif /* IBV_XRC_OPS */
-
-static int rc_test(void)
+static int test(void)
 {
-	struct rdma_addrinfo hints, *res;
+	struct rdma_addrinfo *res;
 	struct ibv_qp_init_attr attr;
 	struct ibv_wc wc;
 	int ret;
 
-	memset(&hints, 0, sizeof hints);
-	hints.ai_port_space = RDMA_PS_TCP;
 	ret = rdma_getaddrinfo(server, port, &hints, &res);
 	if (ret) {
-		printf("rdma_getaddrinfo %d\n", errno);
+		perror("rdma_getaddrinfo");
 		return ret;
 	}
 
 	memset(&attr, 0, sizeof attr);
 	attr.cap.max_send_wr = attr.cap.max_recv_wr = 1;
 	attr.cap.max_send_sge = attr.cap.max_recv_sge = 1;
-	attr.cap.max_inline_data = sizeof send_msg;
-	attr.qp_context = id;
 	attr.sq_sig_all = 1;
 	ret = rdma_create_ep(&id, res, NULL, &attr);
 	rdma_freeaddrinfo(res);
 	if (ret) {
-		printf("rdma_create_ep %d\n", errno);
+		perror("rdma_create_ep");
 		return ret;
 	}
 
-	mr = rdma_reg_msgs(id, recv_msg, sizeof recv_msg);
+	mr = rdma_reg_msgs(id, send_msg, sizeof send_msg);
 	if (!mr) {
-		printf("rdma_reg_msgs %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_post_recv(id, NULL, recv_msg, sizeof recv_msg, mr);
-	if (ret) {
-		printf("rdma_post_recv %d\n", errno);
+		perror("rdma_reg_msgs");
 		return ret;
 	}
 
 	ret = rdma_connect(id, NULL);
 	if (ret) {
-		printf("rdma_connect %d\n", errno);
+		perror("rdma_connect");
 		return ret;
 	}
 
-	ret = rdma_post_send(id, NULL, send_msg, sizeof send_msg, NULL, IBV_SEND_INLINE);
+	if (hints.ai_qp_type == IBV_QPT_XRC_SEND)
+		srqn = ntohl(*(uint32_t *) id->event->param.conn.private_data);
+
+	ret = post_send();
 	if (ret) {
-		printf("rdma_post_send %d\n", errno);
+		perror("post_send");
 		return ret;
 	}
 
-	ret = rdma_get_recv_comp(id, &wc);
+	ret = rdma_get_send_comp(id, &wc);
 	if (ret <= 0) {
-		printf("rdma_get_recv_comp %d\n", ret);
+		perror("rdma_get_recv_comp");
 		return ret;
 	}
 
@@ -248,22 +128,13 @@ static int rc_test(void)
 	return 0;
 }
 
-static int set_qpt(char type)
-{
-	if (type == 'r') {
-		qpt = IBV_QPT_RC;
-		return 0;
-	} else if (type == 'x') {
-		return set_xrc_qpt();
-	}
-	return -1;
-}
-
 int main(int argc, char **argv)
 {
 	int op, ret;
 
-	run_func = rc_test;
+	hints.ai_port_space = RDMA_PS_TCP;
+	hints.ai_qp_type = IBV_QPT_RC;
+
 	while ((op = getopt(argc, argv, "s:p:c:")) != -1) {
 		switch (op) {
 		case 's':
@@ -273,8 +144,16 @@ int main(int argc, char **argv)
 			strncpy(port, optarg, sizeof port - 1);
 			break;
 		case 'c':
-			if (set_qpt(tolower(optarg[0])))
+			switch (tolower(optarg[0])) {
+			case 'r':
+				break;
+			case 'x':
+				hints.ai_port_space = RDMA_PS_IB;
+				hints.ai_qp_type = IBV_QPT_XRC_SEND;
+				break;
+			default:
 				goto err;
+			}
 			break;
 		default:
 			goto err;
@@ -282,7 +161,7 @@ int main(int argc, char **argv)
 	}
 
 	printf("%s: start\n", argv[0]);
-	ret = run_func();
+	ret = test();
 	printf("%s: end %d\n", argv[0], ret);
 	return ret;
 
@@ -292,6 +171,6 @@ err:
 	printf("\t[-p port_number]\n");
 	printf("\t[-c communication type]\n");
 	printf("\t    r - RC: reliable-connected (default)\n");
-	PRINT_XRC_OPT;
+	printf("\t    x - XRC: extended-reliable-connected\n");
 	exit(1);
 }
diff --git a/examples/rdma_xserver.c b/examples/rdma_xserver.c
index df3e665..d30c88e 100644
--- a/examples/rdma_xserver.c
+++ b/examples/rdma_xserver.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005-2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -40,287 +40,100 @@
 
 static char *port = "7471";
 
-static int (*run_func)();
 struct rdma_cm_id *listen_id, *id;
 struct ibv_mr *mr;
-enum ibv_qp_type qpt = IBV_QPT_RC;
+struct rdma_addrinfo hints;
 
-#define MSG_SIZE 16
-uint8_t send_msg[MSG_SIZE];
-uint8_t recv_msg[MSG_SIZE];
+uint8_t recv_msg[16];
+uint32_t srqn;
 
-
-#ifdef IBV_XRC_OPS
-#define PRINT_XRC_OPT printf("\t    x - XRC: extended-reliable-connected\n")
-struct rdma_cm_id *srq_id;
-
-/*
- * Listen for XRC RECV QP connection request.
- */
-static struct rdma_cm_id * xrc_listen_recv(void)
-{
-	struct rdma_addrinfo hints, *res;
-	struct rdma_cm_id *id;
-	int ret;
-
-	memset(&hints, 0, sizeof hints);
-	hints.ai_flags = RAI_PASSIVE;
-	hints.ai_port_space = RDMA_PS_IB;
-	hints.ai_qp_type = IBV_QPT_XRC_RECV;
-	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
-	if (ret) {
-		printf("rdma_getaddrinfo listen recv %d\n", errno);
-		return NULL;
-	}
-
-	ret = rdma_create_ep(&listen_id, res, NULL, NULL);
-	rdma_freeaddrinfo(res);
-	if (ret) {
-		printf("rdma_create_ep listen recv %d\n", errno);
-		return NULL;
-	}
-
-	ret = rdma_listen(listen_id, 0);
-	if (ret) {
-		printf("rdma_listen %d\n", errno);
-		return NULL;
-	}
-
-	ret = rdma_get_request(listen_id, &id);
-	if (ret) {
-		printf("rdma_get_request %d\n", errno);
-		return NULL;
-	}
-
-	return id;
-}
-
-/*
- * Create SRQ and listen for XRC SRQN lookup request.
- */
-static int xrc_create_srq_listen(struct sockaddr *addr, socklen_t addr_len)
+static int create_srq(void)
 {
-	struct rdma_addrinfo rai;
-	struct sockaddr_storage ss;
 	struct ibv_srq_init_attr attr;
 	int ret;
 
-	memset(&rai, 0, sizeof rai);
-	rai.ai_flags = RAI_PASSIVE;
-	rai.ai_family = addr->sa_family;
-	rai.ai_qp_type = IBV_QPT_UD; /* for now */
-	rai.ai_port_space = RDMA_PS_IB;
-	memcpy(&ss, addr, addr_len);
-	rai.ai_src_len = addr_len;
-	rai.ai_src_addr = (struct sockaddr *) &ss;
-	((struct sockaddr_in *) &ss)->sin_port = htons((short) atoi(port) + 1);
-
-	ret = rdma_create_ep(&srq_id, &rai, NULL, NULL);
-	if (ret) {
-		printf("rdma_create_ep srq ep %d\n", errno);
-		return ret;
-	}
-
-	if (!srq_id->verbs) {
-		printf("rdma_create_ep failed to bind to device.\n");
-		printf("XRC tests cannot use loopback addressing\n");
-		return -1;
-	}
-
-	memset(&attr, 0, sizeof attr);
 	attr.attr.max_wr = 1;
 	attr.attr.max_sge = 1;
-	attr.srq_type = IBV_SRQT_XRC;
-
-	attr.ext.xrc.xrcd = ibv_open_xrcd(srq_id->verbs, -1, 0);
-	if (!attr.ext.xrc.xrcd) {
-		printf("Unable to open xrcd\n");
-		return -1;
-	}
-
-	ret = rdma_create_srq(srq_id, NULL, &attr);
-	if (ret) {
-		printf("Unable to create srq %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_listen(srq_id, 0);
-	if (ret) {
-		printf("rdma_listen srq id %d\n", errno);
-		return ret;
-	}
-
-	return 0;
-}
+	attr.attr.srq_limit = 0;
+	attr.srq_context = id;
 
-static int xrc_test(void)
-{
-	struct rdma_cm_id *conn_id, *lookup_id;
-	struct ibv_qp_init_attr attr;
-	struct rdma_conn_param param;
-	struct rdma_cm_event *event;
-	struct ibv_wc wc;
-	int ret;
-
-	conn_id = xrc_listen_recv();
-	if (!conn_id)
-		return -1;
-
-	ret = xrc_create_srq_listen(rdma_get_local_addr(conn_id),
-				    sizeof(struct sockaddr_storage));
+	ret = rdma_create_srq(id, NULL, &attr);
 	if (ret)
-		return -1;
+		perror("rdma_create_srq:");
 
-	memset(&attr, 0, sizeof attr);
-	attr.qp_type = IBV_QPT_XRC_RECV;
-	attr.ext.xrc_recv.xrcd = srq_id->srq->ext.xrc.xrcd;
-	ret = rdma_create_qp(conn_id, NULL, &attr);
-	if (ret) {
-		printf("Unable to create xrc recv qp %d\n", errno);
-		return ret;
+	if (id->srq) {
+		ibv_get_srq_num(id->srq, &srqn);
+		srqn = htonl(srqn);
 	}
-
-	ret = rdma_accept(conn_id, NULL);
-	if (ret) {
-		printf("rdma_accept failed for xrc recv qp %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_get_request(srq_id, &lookup_id);
-	if (ret) {
-		printf("rdma_get_request %d\n", errno);
-		return ret;
-	}
-
-	mr = rdma_reg_msgs(srq_id, recv_msg, sizeof recv_msg);
-	if (!mr) {
-		printf("ibv_reg_msgs %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_post_recv(srq_id, NULL, recv_msg, sizeof recv_msg, mr);
-	if (ret) {
-		printf("rdma_post_recv %d\n", errno);
-		return ret;
-	}
-
-	memset(&param, 0, sizeof param);
-	param.qp_num = srq_id->srq->ext.xrc.srq_num;
-	ret = rdma_accept(lookup_id, &param);
-	if (ret) {
-		printf("rdma_accept failed for srqn lookup %d\n", errno);
-		return ret;
-	}
-
-	rdma_destroy_id(lookup_id);
-
-	ret = rdma_get_recv_comp(srq_id, &wc);
-	if (ret <= 0) {
-		printf("rdma_get_recv_comp %d\n", ret);
-		return ret;
-	}
-
-	ret = rdma_get_cm_event(conn_id->channel, &event);
-	if (ret || event->event != RDMA_CM_EVENT_DISCONNECTED) {
-		printf("Failed to get disconnect event\n");
-		return -1;
-	}
-
-	rdma_ack_cm_event(event);
-	rdma_disconnect(conn_id);
-	rdma_destroy_ep(conn_id);
-	rdma_dereg_mr(mr);
-	rdma_destroy_ep(srq_id);
-	rdma_destroy_ep(listen_id);
-	return 0;
-}
-
-static inline int set_xrc_qpt(void)
-{
-	qpt = IBV_QPT_XRC_RECV;
-	run_func = xrc_test;
-	return 0;
+	return ret;
 }
 
-#else
-#define PRINT_XRC_OPT
-#define set_xrc_qpt() -1
-#endif /* IBV_XRC_OPS */
-
-
-static int rc_test(void)
+static int test(void)
 {
-	struct rdma_addrinfo hints, *res;
+	struct rdma_addrinfo *res;
 	struct ibv_qp_init_attr attr;
+	struct rdma_conn_param param;
 	struct ibv_wc wc;
 	int ret;
 
-	memset(&hints, 0, sizeof hints);
-	hints.ai_flags = RAI_PASSIVE;
-	hints.ai_port_space = RDMA_PS_TCP;
 	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
 	if (ret) {
-		printf("rdma_getaddrinfo %d\n", errno);
+		perror("rdma_getaddrinfo");
 		return ret;
 	}
 
 	memset(&attr, 0, sizeof attr);
 	attr.cap.max_send_wr = attr.cap.max_recv_wr = 1;
 	attr.cap.max_send_sge = attr.cap.max_recv_sge = 1;
-	attr.cap.max_inline_data = sizeof send_msg;
-	attr.sq_sig_all = 1;
 	ret = rdma_create_ep(&listen_id, res, NULL, &attr);
 	rdma_freeaddrinfo(res);
 	if (ret) {
-		printf("rdma_create_ep %d\n", errno);
+		perror("rdma_create_ep");
 		return ret;
 	}
 
 	ret = rdma_listen(listen_id, 0);
 	if (ret) {
-		printf("rdma_listen %d\n", errno);
+		perror("rdma_listen");
 		return ret;
 	}
 
 	ret = rdma_get_request(listen_id, &id);
 	if (ret) {
-		printf("rdma_get_request %d\n", errno);
+		perror("rdma_get_request");
 		return ret;
 	}
 
+	if (hints.ai_qp_type == IBV_QPT_XRC_RECV) {
+		ret = create_srq();
+		if (ret)
+			return ret;
+	}
+
 	mr = rdma_reg_msgs(id, recv_msg, sizeof recv_msg);
 	if (!mr) {
-		printf("rdma_reg_msgs %d\n", errno);
+		perror("rdma_reg_msgs");
 		return ret;
 	}
 
 	ret = rdma_post_recv(id, NULL, recv_msg, sizeof recv_msg, mr);
 	if (ret) {
-		printf("rdma_post_recv %d\n", errno);
+		perror("rdma_post_recv");
 		return ret;
 	}
 
-	ret = rdma_accept(id, NULL);
+	memset(&param, 0, sizeof param);
+	param.private_data = &srqn;
+	param.private_data_len = sizeof srqn;
+	ret = rdma_accept(id, &param);
 	if (ret) {
-		printf("rdma_accept %d\n", errno);
+		perror("rdma_accept");
 		return ret;
 	}
 
 	ret = rdma_get_recv_comp(id, &wc);
 	if (ret <= 0) {
-		printf("rdma_get_recv_comp %d\n", ret);
-		return ret;
-	}
-
-	ret = rdma_post_send(id, NULL, send_msg, sizeof send_msg, NULL, IBV_SEND_INLINE);
-	if (ret) {
-		printf("rdma_post_send %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_get_send_comp(id, &wc);
-	if (ret <= 0) {
-		printf("rdma_get_send_comp %d\n", ret);
+		perror("rdma_get_recv_comp");
 		return ret;
 	}
 
@@ -331,30 +144,30 @@ static int rc_test(void)
 	return 0;
 }
 
-static int set_qpt(char type)
-{
-	if (type == 'r') {
-		qpt = IBV_QPT_RC;
-		return 0;
-	} else if (type == 'x') {
-		return set_xrc_qpt();
-	}
-	return -1;
-}
-
 int main(int argc, char **argv)
 {
 	int op, ret;
 
-	run_func = rc_test;
+	hints.ai_flags = RAI_PASSIVE;
+	hints.ai_port_space = RDMA_PS_TCP;
+	hints.ai_qp_type = IBV_QPT_RC;
+
 	while ((op = getopt(argc, argv, "p:c:")) != -1) {
 		switch (op) {
 		case 'p':
 			port = optarg;
 			break;
 		case 'c':
-			if (set_qpt(tolower(optarg[0])))
+			switch (tolower(optarg[0])) {
+			case 'r':
+				break;
+			case 'x':
+				hints.ai_port_space = RDMA_PS_IB;
+				hints.ai_qp_type = IBV_QPT_XRC_RECV;
+				break;
+			default:
 				goto err;
+			}
 			break;
 		default:
 			goto err;
@@ -362,7 +175,7 @@ int main(int argc, char **argv)
 	}
 
 	printf("%s: start\n", argv[0]);
-	ret = run_func();
+	ret = test();
 	printf("%s: end %d\n", argv[0], ret);
 	return ret;
 
@@ -371,6 +184,6 @@ err:
 	printf("\t[-p port_number]\n");
 	printf("\t[-c communication type]\n");
 	printf("\t    r - RC: reliable-connected (default)\n");
-	PRINT_XRC_OPT;
+	printf("\t    x - XRC: extended-reliable-connected\n");
 	exit(1);
 }
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 3/3] examples: use IBV_SEND_INLINE if supported
Date: Sat, 17 Aug 2013 15:38:16 +0200
Message-ID: <9ccb81672f73533d6b4d43b07e2b322d6fd7f44f.1376746185.git.ydroneaud@opteya.com>
References: <cover.1376746185.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On QLogic InfiniPath HCA / Intel True Scale Fabric HCA,
using driver ipath (libipathverbs), module qib,
IBV_SEND_INLINE could not be used because
init_attr.cap.max_inline_data is set to 0 uppon QP creation.

rdma_client and rdma_server try to set max inline data to 16,
but don't check the value after rdma_create_ep() and rdma_get_request().

This patch adds
- check for current max inline data,
- memory registration if max inline data is less than requested,
- conditional use of IBV_SEND_INLINE.

Tested with QLE7340-CK, QL7342-CK,
on Fedora 18, Fedora 19 with kernel v3.11-rc5,
using libipathverbs 1.2,
      libibverbs 1.1.17
      librdmacm 1.0.17.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 examples/rdma_client.c  | 25 +++++++++++++++++++------
 examples/rdma_server.c  | 31 +++++++++++++++++++++++++------
 examples/rdma_xclient.c | 42 ++++++++++++++++++++++++++++++++++--------
 examples/rdma_xserver.c | 39 +++++++++++++++++++++++++++++----------
 4 files changed, 107 insertions(+), 30 deletions(-)

diff --git a/examples/rdma_client.c b/examples/rdma_client.c
index 7a59d97..830bdc2 100644
--- a/examples/rdma_client.c
+++ b/examples/rdma_client.c
@@ -39,7 +39,8 @@ static char *server = "127.0.0.1";
 static char *port = "7471";
 
 struct rdma_cm_id *id;
-struct ibv_mr *mr;
+struct ibv_mr *send_mr;
+struct ibv_mr *recv_mr;
 uint8_t send_msg[16];
 uint8_t recv_msg[16];
 
@@ -71,13 +72,13 @@ static int run(void)
 		return ret;
 	}
 
-	mr = rdma_reg_msgs(id, recv_msg, 16);
-	if (!mr) {
+	recv_mr = rdma_reg_msgs(id, recv_msg, 16);
+	if (!recv_mr) {
 		printf("rdma_reg_msgs %d\n", errno);
 		return ret;
 	}
 
-	ret = rdma_post_recv(id, NULL, recv_msg, 16, mr);
+	ret = rdma_post_recv(id, NULL, recv_msg, 16, recv_mr);
 	if (ret) {
 		printf("rdma_post_recv %d\n", errno);
 		return ret;
@@ -89,7 +90,17 @@ static int run(void)
 		return ret;
 	}
 
-	ret = rdma_post_send(id, NULL, send_msg, 16, NULL, IBV_SEND_INLINE);
+	if (attr.cap.max_inline_data < 16) {
+		send_mr = rdma_reg_msgs(id, send_msg, 16);
+		if (!send_mr) {
+			printf("rdma_reg_msgs %d\n", errno);
+			return ret;
+		}
+	}
+
+	ret = rdma_post_send(id, NULL, send_msg, 16,
+			     attr.cap.max_inline_data < 16 ? send_mr : NULL,
+			     attr.cap.max_inline_data < 16 ? 0 : IBV_SEND_INLINE);
 	if (ret) {
 		printf("rdma_post_send %d\n", errno);
 		return ret;
@@ -102,7 +113,9 @@ static int run(void)
 	}
 
 	rdma_disconnect(id);
-	rdma_dereg_mr(mr);
+	rdma_dereg_mr(recv_mr);
+	if (attr.cap.max_inline_data < 16)
+		rdma_dereg_mr(send_mr);
 	rdma_destroy_ep(id);
 	return 0;
 }
diff --git a/examples/rdma_server.c b/examples/rdma_server.c
index 5b9e16d..459cb38 100644
--- a/examples/rdma_server.c
+++ b/examples/rdma_server.c
@@ -39,7 +39,8 @@
 static char *port = "7471";
 
 struct rdma_cm_id *listen_id, *id;
-struct ibv_mr *mr;
+struct ibv_mr *send_mr;
+struct ibv_mr *recv_mr;
 uint8_t send_msg[16];
 uint8_t recv_msg[16];
 
@@ -83,13 +84,13 @@ static int run(void)
 		return ret;
 	}
 
-	mr = rdma_reg_msgs(id, recv_msg, 16);
-	if (!mr) {
+	recv_mr = rdma_reg_msgs(id, recv_msg, 16);
+	if (!recv_mr) {
 		printf("rdma_reg_msgs %d\n", errno);
 		return ret;
 	}
 
-	ret = rdma_post_recv(id, NULL, recv_msg, 16, mr);
+	ret = rdma_post_recv(id, NULL, recv_msg, 16, recv_mr);
 	if (ret) {
 		printf("rdma_post_recv %d\n", errno);
 		return ret;
@@ -107,7 +108,23 @@ static int run(void)
 		return ret;
 	}
 
-	ret = rdma_post_send(id, NULL, send_msg, 16, NULL, IBV_SEND_INLINE);
+	ret = rdma_query_qp(id, &attr);
+	if (ret) {
+		printf("rdma_query_qp %d\n", errno);
+		return ret;
+	}
+
+	if (attr.cap.max_inline_data < 16) {
+		send_mr = rdma_reg_msgs(id, send_msg, 16);
+		if (!send_mr) {
+			printf("rdma_reg_msgs %d\n", errno);
+			return ret;
+		}
+	}
+
+	ret = rdma_post_send(id, NULL, send_msg, 16,
+			     attr.cap.max_inline_data < 16 ? send_mr : NULL,
+			     attr.cap.max_inline_data < 16 ? 0 : IBV_SEND_INLINE);
 	if (ret) {
 		printf("rdma_post_send %d\n", errno);
 		return ret;
@@ -120,7 +137,9 @@ static int run(void)
 	}
 
 	rdma_disconnect(id);
-	rdma_dereg_mr(mr);
+	rdma_dereg_mr(recv_mr);
+	if (attr.cap.max_inline_data < 16)
+		rdma_dereg_mr(send_mr);
 	rdma_destroy_ep(id);
 	rdma_destroy_ep(listen_id);
 	return 0;
diff --git a/examples/rdma_xclient.c b/examples/rdma_xclient.c
index e192290..d93b40c 100644
--- a/examples/rdma_xclient.c
+++ b/examples/rdma_xclient.c
@@ -41,7 +41,8 @@ static char port[6] = "7471";
 
 static int (*run_func)() = NULL;
 struct rdma_cm_id *id;
-struct ibv_mr *mr;
+struct ibv_mr *send_mr;
+struct ibv_mr *recv_mr;
 enum ibv_qp_type qpt = IBV_QPT_RC;
 
 #define MSG_SIZE 16
@@ -131,6 +132,7 @@ static int xrc_resolve_srqn(void)
 
 static int xrc_test(void)
 {
+	struct ibv_qp_init_attr attr;
 	struct ibv_send_wr wr, *bad;
 	struct ibv_sge sge;
 	struct ibv_wc wc;
@@ -144,15 +146,25 @@ static int xrc_test(void)
 	if (ret)
 		return ret;
 
+	ret = rdma_query_qp(id, &attr);
+	if (ret)
+		return ret;
+
+	if (attr.cap.max_inline_data < sizeof send_msg) {
+		send_mr = rdma_reg_msgs(id, send_msg, sizeof send_msg);
+		if (!send_mr)
+			return -1;
+	}
+
 	sge.addr = (uint64_t) (uintptr_t) send_msg;
 	sge.length = (uint32_t) sizeof send_msg;
-	sge.lkey = 0;
+	sge.lkey = attr.cap.max_inline_data < sizeof send_msg ? send_mr->lkey : 0;
 	wr.wr_id = (uintptr_t) NULL;
 	wr.next = NULL;
 	wr.sg_list = &sge;
 	wr.num_sge = 1;
 	wr.opcode = IBV_WR_SEND;
-	wr.send_flags = IBV_SEND_INLINE;
+	wr.send_flags = attr.cap.max_inline_data < sizeof send_msg ? 0 : IBV_SEND_INLINE;
 	wr.wr.xrc.remote_srqn = srqn;
 
 	ret = ibv_post_send(id->qp, &wr, &bad);
@@ -168,6 +180,8 @@ static int xrc_test(void)
 	}
 
 	rdma_disconnect(id);
+	if (attr.cap.max_inline_data < sizeof send_msg)
+		rdma_dereg_mr(send_mr);
 	rdma_destroy_ep(id);
 	return 0;
 }
@@ -212,13 +226,13 @@ static int rc_test(void)
 		return ret;
 	}
 
-	mr = rdma_reg_msgs(id, recv_msg, sizeof recv_msg);
-	if (!mr) {
+	recv_mr = rdma_reg_msgs(id, recv_msg, sizeof recv_msg);
+	if (!recv_mr) {
 		printf("rdma_reg_msgs %d\n", errno);
 		return ret;
 	}
 
-	ret = rdma_post_recv(id, NULL, recv_msg, sizeof recv_msg, mr);
+	ret = rdma_post_recv(id, NULL, recv_msg, sizeof recv_msg, recv_mr);
 	if (ret) {
 		printf("rdma_post_recv %d\n", errno);
 		return ret;
@@ -230,7 +244,17 @@ static int rc_test(void)
 		return ret;
 	}
 
-	ret = rdma_post_send(id, NULL, send_msg, sizeof send_msg, NULL, IBV_SEND_INLINE);
+	if (attr.cap.max_inline_data < sizeof send_msg) {
+		send_mr = rdma_reg_msgs(id, send_msg, sizeof send_msg);
+		if (!send_mr) {
+			printf("rdma_reg_msgs %d\n", errno);
+			return ret;
+		}
+	}
+
+	ret = rdma_post_send(id, NULL, send_msg, sizeof send_msg,
+			     attr.cap.max_inline_data < sizeof send_msg ? send_mr : NULL,
+			     attr.cap.max_inline_data < sizeof send_msg ? 0 : IBV_SEND_INLINE);
 	if (ret) {
 		printf("rdma_post_send %d\n", errno);
 		return ret;
@@ -243,7 +267,9 @@ static int rc_test(void)
 	}
 
 	rdma_disconnect(id);
-	rdma_dereg_mr(mr);
+	rdma_dereg_mr(recv_mr);
+	if (attr.cap.max_inline_data < sizeof send_msg)
+		rdma_dereg_mr(send_mr);
 	rdma_destroy_ep(id);
 	return 0;
 }
diff --git a/examples/rdma_xserver.c b/examples/rdma_xserver.c
index df3e665..32a119a 100644
--- a/examples/rdma_xserver.c
+++ b/examples/rdma_xserver.c
@@ -42,7 +42,8 @@ static char *port = "7471";
 
 static int (*run_func)();
 struct rdma_cm_id *listen_id, *id;
-struct ibv_mr *mr;
+struct ibv_mr *send_mr;
+struct ibv_mr *recv_mr;
 enum ibv_qp_type qpt = IBV_QPT_RC;
 
 #define MSG_SIZE 16
@@ -192,13 +193,13 @@ static int xrc_test(void)
 		return ret;
 	}
 
-	mr = rdma_reg_msgs(srq_id, recv_msg, sizeof recv_msg);
-	if (!mr) {
+	recv_mr = rdma_reg_msgs(srq_id, recv_msg, sizeof recv_msg);
+	if (!recv_mr) {
 		printf("ibv_reg_msgs %d\n", errno);
 		return ret;
 	}
 
-	ret = rdma_post_recv(srq_id, NULL, recv_msg, sizeof recv_msg, mr);
+	ret = rdma_post_recv(srq_id, NULL, recv_msg, sizeof recv_msg, recv_mr);
 	if (ret) {
 		printf("rdma_post_recv %d\n", errno);
 		return ret;
@@ -229,7 +230,7 @@ static int xrc_test(void)
 	rdma_ack_cm_event(event);
 	rdma_disconnect(conn_id);
 	rdma_destroy_ep(conn_id);
-	rdma_dereg_mr(mr);
+	rdma_dereg_mr(recv_mr);
 	rdma_destroy_ep(srq_id);
 	rdma_destroy_ep(listen_id);
 	return 0;
@@ -288,13 +289,13 @@ static int rc_test(void)
 		return ret;
 	}
 
-	mr = rdma_reg_msgs(id, recv_msg, sizeof recv_msg);
-	if (!mr) {
+	recv_mr = rdma_reg_msgs(id, recv_msg, sizeof recv_msg);
+	if (!recv_mr) {
 		printf("rdma_reg_msgs %d\n", errno);
 		return ret;
 	}
 
-	ret = rdma_post_recv(id, NULL, recv_msg, sizeof recv_msg, mr);
+	ret = rdma_post_recv(id, NULL, recv_msg, sizeof recv_msg, recv_mr);
 	if (ret) {
 		printf("rdma_post_recv %d\n", errno);
 		return ret;
@@ -312,7 +313,23 @@ static int rc_test(void)
 		return ret;
 	}
 
-	ret = rdma_post_send(id, NULL, send_msg, sizeof send_msg, NULL, IBV_SEND_INLINE);
+	ret = rdma_query_qp(id, &attr);
+	if (ret) {
+		printf("rdma_query_qp %d\n", errno);
+		return ret;
+	}
+
+	if (attr.cap.max_inline_data < sizeof send_msg) {
+		send_mr = rdma_reg_msgs(id, send_msg, sizeof send_msg);
+		if (!send_mr) {
+			printf("rdma_reg_msgs %d\n", errno);
+			return ret;
+		}
+	}
+
+	ret = rdma_post_send(id, NULL, send_msg, sizeof send_msg,
+			     attr.cap.max_inline_data < sizeof send_msg ? send_mr : NULL,
+			     attr.cap.max_inline_data < sizeof send_msg ? 0 : IBV_SEND_INLINE);
 	if (ret) {
 		printf("rdma_post_send %d\n", errno);
 		return ret;
@@ -325,7 +342,9 @@ static int rc_test(void)
 	}
 
 	rdma_disconnect(id);
-	rdma_dereg_mr(mr);
+	rdma_dereg_mr(recv_mr);
+	if (attr.cap.max_inline_data < sizeof send_msg)
+		rdma_dereg_mr(send_mr);
 	rdma_destroy_ep(id);
 	rdma_destroy_ep(listen_id);
 	return 0;
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

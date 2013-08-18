From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/22] ucma: use size_t for userspace buffer input and output length
Date: Sun, 18 Aug 2013 20:28:51 +0200
Message-ID: <2ae438b696c0778b91e9498b401994a58ca65e02.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There's no reason to use a signed type for userspace buffer length.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/ucma.c | 55 +++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index c653b1e..ecc6fad 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -290,7 +290,7 @@ out:
 }
 
 static ssize_t ucma_get_event(struct ucma_file *file, const char __user *inbuf,
-			      int in_len, int out_len)
+			      size_t in_len, size_t out_len)
 {
 	struct ucma_context *ctx;
 	struct rdma_ucm_get_event cmd;
@@ -369,7 +369,7 @@ static int ucma_get_qp_type(struct rdma_ucm_create_id *cmd, enum ib_qp_type *qp_
 }
 
 static ssize_t ucma_create_id(struct ucma_file *file, const char __user *inbuf,
-			      int in_len, int out_len)
+			      size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_create_id cmd;
 	struct rdma_ucm_create_id_resp resp;
@@ -485,7 +485,7 @@ static int ucma_free_ctx(struct ucma_context *ctx)
 }
 
 static ssize_t ucma_destroy_id(struct ucma_file *file, const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_destroy_id cmd;
 	struct rdma_ucm_destroy_id_resp resp;
@@ -522,7 +522,7 @@ static ssize_t ucma_destroy_id(struct ucma_file *file, const char __user *inbuf,
 }
 
 static ssize_t ucma_bind_ip(struct ucma_file *file, const char __user *inbuf,
-			      int in_len, int out_len)
+			      size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_bind_ip cmd;
 	struct ucma_context *ctx;
@@ -544,7 +544,7 @@ static ssize_t ucma_bind_ip(struct ucma_file *file, const char __user *inbuf,
 }
 
 static ssize_t ucma_bind(struct ucma_file *file, const char __user *inbuf,
-			 int in_len, int out_len)
+			 size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_bind cmd;
 	struct sockaddr *addr;
@@ -572,7 +572,7 @@ static ssize_t ucma_bind(struct ucma_file *file, const char __user *inbuf,
 
 static ssize_t ucma_resolve_ip(struct ucma_file *file,
 			       const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_resolve_ip cmd;
 	struct ucma_context *ctx;
@@ -597,7 +597,7 @@ static ssize_t ucma_resolve_ip(struct ucma_file *file,
 
 static ssize_t ucma_resolve_addr(struct ucma_file *file,
 				 const char __user *inbuf,
-				 int in_len, int out_len)
+				 size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_resolve_addr cmd;
 	struct sockaddr *src, *dst;
@@ -627,7 +627,7 @@ static ssize_t ucma_resolve_addr(struct ucma_file *file,
 
 static ssize_t ucma_resolve_route(struct ucma_file *file,
 				  const char __user *inbuf,
-				  int in_len, int out_len)
+				  size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_resolve_route cmd;
 	struct ucma_context *ctx;
@@ -724,7 +724,7 @@ static void ucma_copy_iw_route(struct rdma_ucm_query_route_resp *resp,
 
 static ssize_t ucma_query_route(struct ucma_file *file,
 				const char __user *inbuf,
-				int in_len, int out_len)
+				size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_query cmd;
 	struct rdma_ucm_query_route_resp resp;
@@ -802,7 +802,7 @@ static void ucma_query_device_addr(struct rdma_cm_id *cm_id,
 }
 
 static ssize_t ucma_query_addr(struct ucma_context *ctx,
-			       void __user *response, int out_len)
+			       void __user *response, size_t out_len)
 {
 	struct rdma_ucm_query_addr_resp resp;
 	struct sockaddr *addr;
@@ -830,7 +830,7 @@ static ssize_t ucma_query_addr(struct ucma_context *ctx,
 }
 
 static ssize_t ucma_query_path(struct ucma_context *ctx,
-			       void __user *response, int out_len)
+			       void __user *response, size_t out_len)
 {
 	struct rdma_ucm_query_path_resp *resp;
 	int i, ret = 0;
@@ -865,7 +865,7 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
 }
 
 static ssize_t ucma_query_gid(struct ucma_context *ctx,
-			      void __user *response, int out_len)
+			      void __user *response, size_t out_len)
 {
 	struct rdma_ucm_query_addr_resp resp;
 	struct sockaddr_ib *addr;
@@ -912,7 +912,7 @@ static ssize_t ucma_query_gid(struct ucma_context *ctx,
 
 static ssize_t ucma_query(struct ucma_file *file,
 			  const char __user *inbuf,
-			  int in_len, int out_len)
+			  size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_query cmd;
 	struct ucma_context *ctx;
@@ -966,7 +966,7 @@ static void ucma_copy_conn_param(struct rdma_cm_id *id,
 }
 
 static ssize_t ucma_connect(struct ucma_file *file, const char __user *inbuf,
-			    int in_len, int out_len)
+			    size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_connect cmd;
 	struct rdma_conn_param conn_param;
@@ -993,7 +993,7 @@ static ssize_t ucma_connect(struct ucma_file *file, const char __user *inbuf,
 }
 
 static ssize_t ucma_listen(struct ucma_file *file, const char __user *inbuf,
-			   int in_len, int out_len)
+			   size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_listen cmd;
 	struct ucma_context *ctx;
@@ -1017,7 +1017,7 @@ static ssize_t ucma_listen(struct ucma_file *file, const char __user *inbuf,
 }
 
 static ssize_t ucma_accept(struct ucma_file *file, const char __user *inbuf,
-			   int in_len, int out_len)
+			   size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_accept cmd;
 	struct rdma_conn_param conn_param;
@@ -1049,7 +1049,7 @@ static ssize_t ucma_accept(struct ucma_file *file, const char __user *inbuf,
 }
 
 static ssize_t ucma_reject(struct ucma_file *file, const char __user *inbuf,
-			   int in_len, int out_len)
+			   size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_reject cmd;
 	struct ucma_context *ctx;
@@ -1071,7 +1071,7 @@ static ssize_t ucma_reject(struct ucma_file *file, const char __user *inbuf,
 }
 
 static ssize_t ucma_disconnect(struct ucma_file *file, const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_disconnect cmd;
 	struct ucma_context *ctx;
@@ -1094,7 +1094,7 @@ static ssize_t ucma_disconnect(struct ucma_file *file, const char __user *inbuf,
 
 static ssize_t ucma_init_qp_attr(struct ucma_file *file,
 				 const char __user *inbuf,
-				 int in_len, int out_len)
+				 size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_init_qp_attr cmd;
 	struct ib_uverbs_qp_attr resp;
@@ -1231,7 +1231,7 @@ static int ucma_set_option_level(struct ucma_context *ctx, int level,
 }
 
 static ssize_t ucma_set_option(struct ucma_file *file, const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_set_option cmd;
 	struct ucma_context *ctx;
@@ -1265,7 +1265,7 @@ out:
 }
 
 static ssize_t ucma_notify(struct ucma_file *file, const char __user *inbuf,
-			   int in_len, int out_len)
+			   size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_notify cmd;
 	struct ucma_context *ctx;
@@ -1287,7 +1287,7 @@ static ssize_t ucma_notify(struct ucma_file *file, const char __user *inbuf,
 }
 
 static ssize_t ucma_process_join(struct ucma_file *file,
-				 struct rdma_ucm_join_mcast *cmd,  int out_len)
+				 struct rdma_ucm_join_mcast *cmd, size_t out_len)
 {
 	struct rdma_ucm_create_id_resp resp;
 	struct ucma_context *ctx;
@@ -1347,7 +1347,7 @@ err1:
 
 static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
 				      const char __user *inbuf,
-				      int in_len, int out_len)
+				      size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_join_ip_mcast cmd;
 	struct rdma_ucm_join_mcast join_cmd;
@@ -1370,7 +1370,7 @@ static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
 
 static ssize_t ucma_join_multicast(struct ucma_file *file,
 				   const char __user *inbuf,
-				   int in_len, int out_len)
+				   size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_join_mcast cmd;
 
@@ -1385,7 +1385,7 @@ static ssize_t ucma_join_multicast(struct ucma_file *file,
 
 static ssize_t ucma_leave_multicast(struct ucma_file *file,
 				    const char __user *inbuf,
-				    int in_len, int out_len)
+				    size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_destroy_id cmd;
 	struct rdma_ucm_destroy_id_resp resp;
@@ -1469,7 +1469,7 @@ static void ucma_move_events(struct ucma_context *ctx, struct ucma_file *file)
 
 static ssize_t ucma_migrate_id(struct ucma_file *new_file,
 			       const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct rdma_ucm_migrate_id cmd;
 	struct rdma_ucm_migrate_resp resp;
@@ -1533,7 +1533,8 @@ file_put:
 
 static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 				   const char __user *inbuf,
-				   int in_len, int out_len) = {
+				   size_t in_len, size_t out_len) = {
+
 	[RDMA_USER_CM_CMD_CREATE_ID] 	 = ucma_create_id,
 	[RDMA_USER_CM_CMD_DESTROY_ID]	 = ucma_destroy_id,
 	[RDMA_USER_CM_CMD_BIND_IP]	 = ucma_bind_ip,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

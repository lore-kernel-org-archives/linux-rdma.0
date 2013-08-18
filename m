From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/22] ucm: use size_t for userspace buffer input and output length
Date: Sun, 18 Aug 2013 20:28:45 +0200
Message-ID: <5232566ded3a0270f7c1a0997a27842147da8c88.1376847403.git.ydroneaud@opteya.com>
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
 drivers/infiniband/core/ucm.c | 45 ++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 7a35520..8f8a0a8 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -383,7 +383,7 @@ err1:
 
 static ssize_t ib_ucm_event(struct ib_ucm_file *file,
 			    const char __user *inbuf,
-			    int in_len, int out_len)
+			    size_t in_len, size_t out_len)
 {
 	struct ib_ucm_context *ctx;
 	struct ib_ucm_event_get cmd;
@@ -471,7 +471,7 @@ done:
 
 static ssize_t ib_ucm_create_id(struct ib_ucm_file *file,
 				const char __user *inbuf,
-				int in_len, int out_len)
+				size_t in_len, size_t out_len)
 {
 	struct ib_ucm_create_id cmd;
 	struct ib_ucm_create_id_resp resp;
@@ -521,7 +521,7 @@ err1:
 
 static ssize_t ib_ucm_destroy_id(struct ib_ucm_file *file,
 				 const char __user *inbuf,
-				 int in_len, int out_len)
+				 size_t in_len, size_t out_len)
 {
 	struct ib_ucm_destroy_id cmd;
 	struct ib_ucm_destroy_id_resp resp;
@@ -569,7 +569,7 @@ static ssize_t ib_ucm_destroy_id(struct ib_ucm_file *file,
 
 static ssize_t ib_ucm_attr_id(struct ib_ucm_file *file,
 			      const char __user *inbuf,
-			      int in_len, int out_len)
+			      size_t in_len, size_t out_len)
 {
 	struct ib_ucm_attr_id_resp resp;
 	struct ib_ucm_attr_id cmd;
@@ -604,7 +604,7 @@ static ssize_t ib_ucm_attr_id(struct ib_ucm_file *file,
 
 static ssize_t ib_ucm_init_qp_attr(struct ib_ucm_file *file,
 				   const char __user *inbuf,
-				   int in_len, int out_len)
+				   size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_qp_attr resp;
 	struct ib_ucm_init_qp_attr cmd;
@@ -656,7 +656,7 @@ static int ucm_validate_listen(__be64 service_id, __be64 service_mask)
 
 static ssize_t ib_ucm_listen(struct ib_ucm_file *file,
 			     const char __user *inbuf,
-			     int in_len, int out_len)
+			     size_t in_len, size_t out_len)
 {
 	struct ib_ucm_listen cmd;
 	struct ib_ucm_context *ctx;
@@ -685,7 +685,7 @@ out:
 
 static ssize_t ib_ucm_notify(struct ib_ucm_file *file,
 			     const char __user *inbuf,
-			     int in_len, int out_len)
+			     size_t in_len, size_t out_len)
 {
 	struct ib_ucm_notify cmd;
 	struct ib_ucm_context *ctx;
@@ -706,7 +706,7 @@ static ssize_t ib_ucm_notify(struct ib_ucm_file *file,
 	return result;
 }
 
-static int ib_ucm_alloc_data(const void **dest, const void __user *src, u32 len)
+static int ib_ucm_alloc_data(const void **dest, const void __user *src, size_t len)
 {
 	void *data;
 
@@ -750,7 +750,7 @@ static int ib_ucm_path_get(struct ib_sa_path_rec **path, const void __user *src)
 
 static ssize_t ib_ucm_send_req(struct ib_ucm_file *file,
 			       const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct ib_cm_req_param param;
 	struct ib_ucm_context *ctx;
@@ -815,7 +815,7 @@ done:
 
 static ssize_t ib_ucm_send_rep(struct ib_ucm_file *file,
 			       const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct ib_cm_rep_param param;
 	struct ib_ucm_context *ctx;
@@ -859,7 +859,7 @@ static ssize_t ib_ucm_send_rep(struct ib_ucm_file *file,
 }
 
 static ssize_t ib_ucm_send_private_data(struct ib_ucm_file *file,
-					const char __user *inbuf, int in_len,
+					const char __user *inbuf, size_t in_len,
 					int (*func)(struct ib_cm_id *cm_id,
 						    const void *private_data,
 						    u8 private_data_len))
@@ -894,27 +894,27 @@ static ssize_t ib_ucm_send_private_data(struct ib_ucm_file *file,
 
 static ssize_t ib_ucm_send_rtu(struct ib_ucm_file *file,
 			       const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	return ib_ucm_send_private_data(file, inbuf, in_len, ib_send_cm_rtu);
 }
 
 static ssize_t ib_ucm_send_dreq(struct ib_ucm_file *file,
 				const char __user *inbuf,
-				int in_len, int out_len)
+				size_t in_len, size_t out_len)
 {
 	return ib_ucm_send_private_data(file, inbuf, in_len, ib_send_cm_dreq);
 }
 
 static ssize_t ib_ucm_send_drep(struct ib_ucm_file *file,
 				const char __user *inbuf,
-				int in_len, int out_len)
+				size_t in_len, size_t out_len)
 {
 	return ib_ucm_send_private_data(file, inbuf, in_len, ib_send_cm_drep);
 }
 
 static ssize_t ib_ucm_send_info(struct ib_ucm_file *file,
-				const char __user *inbuf, int in_len,
+				const char __user *inbuf, size_t in_len,
 				int (*func)(struct ib_cm_id *cm_id,
 					    int status,
 					    const void *info,
@@ -962,21 +962,21 @@ done:
 
 static ssize_t ib_ucm_send_rej(struct ib_ucm_file *file,
 			       const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	return ib_ucm_send_info(file, inbuf, in_len, (void *)ib_send_cm_rej);
 }
 
 static ssize_t ib_ucm_send_apr(struct ib_ucm_file *file,
 			       const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	return ib_ucm_send_info(file, inbuf, in_len, (void *)ib_send_cm_apr);
 }
 
 static ssize_t ib_ucm_send_mra(struct ib_ucm_file *file,
 			       const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct ib_ucm_context *ctx;
 	struct ib_ucm_mra cmd;
@@ -1008,7 +1008,7 @@ static ssize_t ib_ucm_send_mra(struct ib_ucm_file *file,
 
 static ssize_t ib_ucm_send_lap(struct ib_ucm_file *file,
 			       const char __user *inbuf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct ib_ucm_context *ctx;
 	struct ib_sa_path_rec *path = NULL;
@@ -1048,7 +1048,7 @@ done:
 
 static ssize_t ib_ucm_send_sidr_req(struct ib_ucm_file *file,
 				    const char __user *inbuf,
-				    int in_len, int out_len)
+				    size_t in_len, size_t out_len)
 {
 	struct ib_cm_sidr_req_param param;
 	struct ib_ucm_context *ctx;
@@ -1095,7 +1095,7 @@ done:
 
 static ssize_t ib_ucm_send_sidr_rep(struct ib_ucm_file *file,
 				    const char __user *inbuf,
-				    int in_len, int out_len)
+				    size_t in_len, size_t out_len)
 {
 	struct ib_cm_sidr_rep_param param;
 	struct ib_ucm_sidr_rep cmd;
@@ -1143,7 +1143,8 @@ done:
 
 static ssize_t (*ucm_cmd_table[])(struct ib_ucm_file *file,
 				  const char __user *inbuf,
-				  int in_len, int out_len) = {
+				  size_t in_len,
+				  size_t out_len) = {
 	[IB_USER_CM_CMD_CREATE_ID]     = ib_ucm_create_id,
 	[IB_USER_CM_CMD_DESTROY_ID]    = ib_ucm_destroy_id,
 	[IB_USER_CM_CMD_ATTR_ID]       = ib_ucm_attr_id,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 22/22] uverbs: use size_t for userspace buffer input and output length
Date: Sun, 18 Aug 2013 20:28:58 +0200
Message-ID: <6694d0ee46978a472a8da7ba382b61e4721d13ef.1376847403.git.ydroneaud@opteya.com>
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
 drivers/infiniband/core/uverbs.h      |   4 +-
 drivers/infiniband/core/uverbs_cmd.c  | 120 +++++++++++++++++-----------------
 drivers/infiniband/core/uverbs_main.c |   4 +-
 3 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b8431d6..9286fca 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -179,8 +179,8 @@ void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
 
 #define IB_UVERBS_DECLARE_CMD(name)					\
 	ssize_t ib_uverbs_##name(struct ib_uverbs_file *file,		\
-				 const char __user *buf, int in_len,	\
-				 int out_len)
+				 const char __user *buf, size_t in_len,	\
+				 size_t out_len)
 
 IB_UVERBS_DECLARE_CMD(get_context);
 IB_UVERBS_DECLARE_CMD(query_device);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index df50e81..85e4252 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -288,7 +288,7 @@ static void put_xrcd_read(struct ib_uobject *uobj)
 
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      const char __user *buf,
-			      int in_len, int out_len)
+			      size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_get_context      cmd;
 	struct ib_uverbs_get_context_resp resp;
@@ -388,7 +388,7 @@ err:
 
 ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 			       const char __user *buf,
-			       int in_len, int out_len)
+			       size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_query_device      cmd;
 	struct ib_uverbs_query_device_resp resp;
@@ -460,7 +460,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 
 ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 			     const char __user *buf,
-			     int in_len, int out_len)
+			     size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_query_port      cmd;
 	struct ib_uverbs_query_port_resp resp;
@@ -513,7 +513,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 
 ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 			   const char __user *buf,
-			   int in_len, int out_len)
+			   size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_alloc_pd      cmd;
 	struct ib_uverbs_alloc_pd_resp resp;
@@ -590,7 +590,7 @@ err:
 
 ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 			     const char __user *buf,
-			     int in_len, int out_len)
+			     size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_dealloc_pd cmd;
 	struct ib_uobject          *uobj;
@@ -712,8 +712,8 @@ static void xrcd_table_delete(struct ib_uverbs_device *dev,
 }
 
 ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+			    const char __user *buf, size_t in_len,
+			    size_t out_len)
 {
 	struct ib_uverbs_open_xrcd	cmd;
 	struct ib_uverbs_open_xrcd_resp	resp;
@@ -852,8 +852,8 @@ err_tree_mutex_unlock:
 }
 
 ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
-			     const char __user *buf, int in_len,
-			     int out_len)
+			     const char __user *buf, size_t in_len,
+			     size_t out_len)
 {
 	struct ib_uverbs_close_xrcd cmd;
 	struct ib_uobject           *uobj;
@@ -932,8 +932,8 @@ void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
 }
 
 ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
-			 const char __user *buf, int in_len,
-			 int out_len)
+			 const char __user *buf, size_t in_len,
+			 size_t out_len)
 {
 	struct ib_uverbs_reg_mr      cmd;
 	struct ib_uverbs_reg_mr_resp resp;
@@ -1036,8 +1036,8 @@ err_free:
 }
 
 ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
-			   const char __user *buf, int in_len,
-			   int out_len)
+			   const char __user *buf, size_t in_len,
+			   size_t out_len)
 {
 	struct ib_uverbs_dereg_mr cmd;
 	struct ib_mr             *mr;
@@ -1077,8 +1077,8 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
-			 const char __user *buf, int in_len,
-			 int out_len)
+			 const char __user *buf, size_t in_len,
+			 size_t out_len)
 {
 	struct ib_uverbs_alloc_mw      cmd;
 	struct ib_uverbs_alloc_mw_resp resp;
@@ -1162,8 +1162,8 @@ err_free:
 }
 
 ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
-			   const char __user *buf, int in_len,
-			   int out_len)
+			   const char __user *buf, size_t in_len,
+			   size_t out_len)
 {
 	struct ib_uverbs_dealloc_mw cmd;
 	struct ib_mw               *mw;
@@ -1203,8 +1203,8 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
-				      const char __user *buf, int in_len,
-				      int out_len)
+				      const char __user *buf, size_t in_len,
+				      size_t out_len)
 {
 	struct ib_uverbs_create_comp_channel	   cmd;
 	struct ib_uverbs_create_comp_channel_resp  resp;
@@ -1243,8 +1243,8 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+			    const char __user *buf, size_t in_len,
+			    size_t out_len)
 {
 	struct ib_uverbs_create_cq      cmd;
 	struct ib_uverbs_create_cq_resp resp;
@@ -1347,8 +1347,8 @@ err:
 }
 
 ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+			    const char __user *buf, size_t in_len,
+			    size_t out_len)
 {
 	struct ib_uverbs_resize_cq	cmd;
 	struct ib_uverbs_resize_cq_resp	resp;
@@ -1416,8 +1416,8 @@ static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
 }
 
 ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
-			  const char __user *buf, int in_len,
-			  int out_len)
+			  const char __user *buf, size_t in_len,
+			  size_t out_len)
 {
 	struct ib_uverbs_poll_cq       cmd;
 	struct ib_uverbs_poll_cq_resp  resp;
@@ -1476,8 +1476,8 @@ out_put:
 }
 
 ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
-				const char __user *buf, int in_len,
-				int out_len)
+				const char __user *buf, size_t in_len,
+				size_t out_len)
 {
 	struct ib_uverbs_req_notify_cq cmd;
 	struct ib_cq                  *cq;
@@ -1501,8 +1501,8 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
-			     const char __user *buf, int in_len,
-			     int out_len)
+			     const char __user *buf, size_t in_len,
+			     size_t out_len)
 {
 	struct ib_uverbs_destroy_cq      cmd;
 	struct ib_uverbs_destroy_cq_resp resp;
@@ -1559,8 +1559,8 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+			    const char __user *buf, size_t in_len,
+			    size_t out_len)
 {
 	struct ib_uverbs_create_qp      cmd;
 	struct ib_uverbs_create_qp_resp resp;
@@ -1757,7 +1757,7 @@ err_put:
 }
 
 ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
-			  const char __user *buf, int in_len, int out_len)
+			  const char __user *buf, size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_open_qp        cmd;
 	struct ib_uverbs_create_qp_resp resp;
@@ -1854,8 +1854,8 @@ err_put:
 }
 
 ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
-			   const char __user *buf, int in_len,
-			   int out_len)
+			   const char __user *buf, size_t in_len,
+			   size_t out_len)
 {
 	struct ib_uverbs_query_qp      cmd;
 	struct ib_uverbs_query_qp_resp resp;
@@ -1974,8 +1974,8 @@ static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
 }
 
 ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+			    const char __user *buf, size_t in_len,
+			    size_t out_len)
 {
 	struct ib_uverbs_modify_qp cmd;
 	struct ib_udata            udata;
@@ -2069,8 +2069,8 @@ out:
 }
 
 ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
-			     const char __user *buf, int in_len,
-			     int out_len)
+			     const char __user *buf, size_t in_len,
+			     size_t out_len)
 {
 	struct ib_uverbs_destroy_qp      cmd;
 	struct ib_uverbs_destroy_qp_resp resp;
@@ -2133,8 +2133,8 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+			    const char __user *buf, size_t in_len,
+			    size_t out_len)
 {
 	struct ib_uverbs_post_send      cmd;
 	struct ib_uverbs_post_send_resp resp;
@@ -2295,7 +2295,7 @@ out:
 }
 
 static struct ib_recv_wr *ib_uverbs_unmarshall_recv(const char __user *buf,
-						    int in_len,
+						    size_t in_len,
 						    u32 wr_count,
 						    u32 sge_count,
 						    u32 wqe_size)
@@ -2380,8 +2380,8 @@ err:
 }
 
 ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+			    const char __user *buf, size_t in_len,
+			    size_t out_len)
 {
 	struct ib_uverbs_post_recv      cmd;
 	struct ib_uverbs_post_recv_resp resp;
@@ -2435,8 +2435,8 @@ out:
 }
 
 ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
-				const char __user *buf, int in_len,
-				int out_len)
+				const char __user *buf, size_t in_len,
+				size_t out_len)
 {
 	struct ib_uverbs_post_srq_recv      cmd;
 	struct ib_uverbs_post_srq_recv_resp resp;
@@ -2490,8 +2490,8 @@ out:
 }
 
 ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+			    const char __user *buf, size_t in_len,
+			    size_t out_len)
 {
 	struct ib_uverbs_create_ah	 cmd;
 	struct ib_uverbs_create_ah_resp	 resp;
@@ -2583,7 +2583,7 @@ err:
 }
 
 ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
-			     const char __user *buf, int in_len, int out_len)
+			     const char __user *buf, size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_destroy_ah cmd;
 	struct ib_ah		   *ah;
@@ -2622,8 +2622,8 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
-			       const char __user *buf, int in_len,
-			       int out_len)
+			       const char __user *buf, size_t in_len,
+			       size_t out_len)
 {
 	struct ib_uverbs_attach_mcast cmd;
 	struct ib_qp                 *qp;
@@ -2672,8 +2672,8 @@ out_put:
 }
 
 ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
-			       const char __user *buf, int in_len,
-			       int out_len)
+			       const char __user *buf, size_t in_len,
+			       size_t out_len)
 {
 	struct ib_uverbs_detach_mcast cmd;
 	struct ib_uqp_object         *obj;
@@ -2845,8 +2845,8 @@ err:
 }
 
 ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
-			     const char __user *buf, int in_len,
-			     int out_len)
+			     const char __user *buf, size_t in_len,
+			     size_t out_len)
 {
 	struct ib_uverbs_create_srq      cmd;
 	struct ib_uverbs_create_xsrq     xcmd;
@@ -2883,7 +2883,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
-			      const char __user *buf, int in_len, int out_len)
+			      const char __user *buf, size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_create_xsrq     cmd;
 	struct ib_uverbs_create_srq_resp resp;
@@ -2911,8 +2911,8 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
-			     const char __user *buf, int in_len,
-			     int out_len)
+			     const char __user *buf, size_t in_len,
+			     size_t out_len)
 {
 	struct ib_uverbs_modify_srq cmd;
 	struct ib_udata             udata;
@@ -2945,7 +2945,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 
 ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 			    const char __user *buf,
-			    int in_len, int out_len)
+			    size_t in_len, size_t out_len)
 {
 	struct ib_uverbs_query_srq      cmd;
 	struct ib_uverbs_query_srq_resp resp;
@@ -2987,8 +2987,8 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
-			      const char __user *buf, int in_len,
-			      int out_len)
+			      const char __user *buf, size_t in_len,
+			      size_t out_len)
 {
 	struct ib_uverbs_destroy_srq      cmd;
 	struct ib_uverbs_destroy_srq_resp resp;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2c6f0f2..05557da 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -78,8 +78,8 @@ static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
 
 static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
-				     const char __user *buf, int in_len,
-				     int out_len) = {
+				     const char __user *buf, size_t in_len,
+				     size_t out_len) = {
 	[IB_USER_VERBS_CMD_GET_CONTEXT]		= ib_uverbs_get_context,
 	[IB_USER_VERBS_CMD_QUERY_DEVICE]	= ib_uverbs_query_device,
 	[IB_USER_VERBS_CMD_QUERY_PORT]		= ib_uverbs_query_port,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs] Fix create/destroy flow API
Date: Fri,  4 Sep 2015 17:17:38 -0400
Message-ID: <9665e46a71940f2721b30fdb4aaa0853161babc9.1441401379.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When adding this API, there had been consensus that having separate
lib_* and drv_* function pointers in the extended context struct
was not needed and should not be done.  However, that snuck in anyway.
This backs that out and takes us back to a single pointer for each
function, but does so in a way as to preserve both back and forward
compatibility.

Fixes: 389de6a6ef4e (Add receive flow steering support)
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/infiniband/verbs.h | 25 +++++++++++--------------
 src/device.c               | 22 +++++++++++++---------
 2 files changed, 24 insertions(+), 23 deletions(-)
---

This change will preserve binary ABI but will (intentionally) break
source API.  Mellanox should release an updated libmlx4 once the
libibverbs release with this patch in it goes live.

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 28e1586b0c96..6100f5200b7a 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -977,14 +977,11 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
-	int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
-	int (*lib_ibv_destroy_flow) (struct ibv_flow *flow);
-	struct ibv_flow * (*drv_ibv_create_flow) (struct ibv_qp *qp,
-						  struct ibv_flow_attr
-						  *flow_attr);
-	struct ibv_flow * (*lib_ibv_create_flow) (struct ibv_qp *qp,
-						  struct ibv_flow_attr
-						  *flow_attr);
+	int (*ibv_destroy_flow) (struct ibv_flow *flow);
+	void (*ABI_placeholder2) (void); /* DO NOT COPY THIS GARBAGE */
+	struct ibv_flow * (*ibv_create_flow) (struct ibv_qp *qp,
+					      struct ibv_flow_attr *flow_attr);
+	void (*ABI_placeholder1) (void); /* DO NOT COPY THIS GARBAGE */
 	struct ibv_qp *(*open_qp)(struct ibv_context *context,
 			struct ibv_qp_open_attr *attr);
 	struct ibv_qp *(*create_qp_ex)(struct ibv_context *context,
@@ -1137,20 +1134,20 @@ static inline struct ibv_flow *ibv_create_flow(struct ibv_qp *qp,
 					       struct ibv_flow_attr *flow)
 {
 	struct verbs_context *vctx = verbs_get_ctx_op(qp->context,
-						      lib_ibv_create_flow);
-	if (!vctx || !vctx->lib_ibv_create_flow)
+						      ibv_create_flow);
+	if (!vctx || !vctx->ibv_create_flow)
 		return NULL;
 
-	return vctx->lib_ibv_create_flow(qp, flow);
+	return vctx->ibv_create_flow(qp, flow);
 }
 
 static inline int ibv_destroy_flow(struct ibv_flow *flow_id)
 {
 	struct verbs_context *vctx = verbs_get_ctx_op(flow_id->context,
-						      lib_ibv_destroy_flow);
-	if (!vctx || !vctx->lib_ibv_destroy_flow)
+						      ibv_destroy_flow);
+	if (!vctx || !vctx->ibv_destroy_flow)
 		return -ENOSYS;
-	return vctx->lib_ibv_destroy_flow(flow_id);
+	return vctx->ibv_destroy_flow(flow_id);
 }
 
 /**
diff --git a/src/device.c b/src/device.c
index 9642eadba8d0..c6cfa950ca9a 100644
--- a/src/device.c
+++ b/src/device.c
@@ -163,16 +163,20 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 		ret = verbs_device->init_context(verbs_device, context, cmd_fd);
 		if (ret)
 			goto verbs_err;
-
-		/* initialize *all* library ops to either lib calls or
-		 * directly to provider calls.
-		 * context_ex->lib_new_func1 = __verbs_new_func1;
-		 * context_ex->lib_new_func2 = __verbs_new_func2;
+		/*
+		 * In order to maintain backward/forward binary compatibility
+		 * with libmlx4-1.0.6, which has the original version of the
+		 * flow steering patches, we need to set the two
+		 * ABI_compat_placeholder entries to match the driver
+		 * set flow entries.  This is because, in the specific instance
+		 * of using libmlx4-1.0.6 with the fixed version of
+		 * libibvberbs, the ibv_create_flow inline function already
+		 * compiled into libmlx4-1.0.6 will be loooking in the
+		 * ABI_placeholder spots for the function pointer to the
+		 * create and destroy flow verbs.
 		 */
-		 context_ex->lib_ibv_create_flow =
-			 context_ex->drv_ibv_create_flow;
-		 context_ex->lib_ibv_destroy_flow =
-			 context_ex->drv_ibv_destroy_flow;
+		context_ex->ABI_placeholder1 = (void (*)(void)) context_ex->ibv_create_flow;
+		context_ex->ABI_placeholder2 = (void (*)(void)) context_ex->ibv_destroy_flow;
 	}
 
 	context->device = device;
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

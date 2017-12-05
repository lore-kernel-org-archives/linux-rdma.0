From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 2/8] verbs: Remove duplicate NULL test from flow ops
Date: Tue,  5 Dec 2017 16:17:15 -0700
Message-ID: <20171205231721.19410-3-jgg@ziepe.ca>
References: <20171205231721.19410-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205231721.19410-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The verbs_get_ctx_op macro already checks if the op is NULL.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index b39dc30a6d2a6e..b9db76bc628707 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1832,7 +1832,7 @@ static inline struct ibv_flow *ibv_create_flow(struct ibv_qp *qp,
 {
 	struct verbs_context *vctx = verbs_get_ctx_op(qp->context,
 						      ibv_create_flow);
-	if (!vctx || !vctx->ibv_create_flow) {
+	if (!vctx) {
 		errno = ENOSYS;
 		return NULL;
 	}
@@ -1844,7 +1844,7 @@ static inline int ibv_destroy_flow(struct ibv_flow *flow_id)
 {
 	struct verbs_context *vctx = verbs_get_ctx_op(flow_id->context,
 						      ibv_destroy_flow);
-	if (!vctx || !vctx->ibv_destroy_flow)
+	if (!vctx)
 		return -ENOSYS;
 	return vctx->ibv_destroy_flow(flow_id);
 }
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

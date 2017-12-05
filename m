From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 3/8] verbs: Get rid of verbs_context->has_comp_mask
Date: Tue,  5 Dec 2017 16:17:16 -0700
Message-ID: <20171205231721.19410-4-jgg@ziepe.ca>
References: <20171205231721.19410-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205231721.19410-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This never made any sense, and was never used. Just get rid of the
vestigial remains.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h    | 11 +----------
 providers/mlx4/mlx4.c |  2 --
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index b9db76bc628707..9a3d09e27dc7f8 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1650,15 +1650,6 @@ struct ibv_values_ex {
 	struct timespec raw_clock;
 };
 
-enum verbs_context_mask {
-	VERBS_CONTEXT_XRCD	= 1 << 0,
-	VERBS_CONTEXT_SRQ	= 1 << 1,
-	VERBS_CONTEXT_QP	= 1 << 2,
-	VERBS_CONTEXT_CREATE_FLOW = 1 << 3,
-	VERBS_CONTEXT_DESTROY_FLOW = 1 << 4,
-	VERBS_CONTEXT_RESERVED	= 1 << 5
-};
-
 struct verbs_context {
 	/*  "grows up" - new fields go here */
 	int (*modify_cq)(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr);
@@ -1696,7 +1687,7 @@ struct verbs_context {
 	struct ibv_xrcd *	(*open_xrcd)(struct ibv_context *context,
 					     struct ibv_xrcd_init_attr *xrcd_init_attr);
 	int			(*close_xrcd)(struct ibv_xrcd *xrcd);
-	uint64_t has_comp_mask;
+	uint64_t _ABI_placeholder3;
 	size_t   sz;			/* Must be immediately before struct ibv_context */
 	struct ibv_context context;	/* Must be last field in the struct */
 };
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 0ed77d2c021513..1ba2b427071fcb 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -238,8 +238,6 @@ static int mlx4_init_context(struct verbs_device *v_device,
 			mlx4_map_internal_clock(dev, ibv_ctx);
 	}
 
-	verbs_ctx->has_comp_mask = VERBS_CONTEXT_XRCD | VERBS_CONTEXT_SRQ |
-					VERBS_CONTEXT_QP;
 	verbs_set_ctx_op(verbs_ctx, close_xrcd, mlx4_close_xrcd);
 	verbs_set_ctx_op(verbs_ctx, open_xrcd, mlx4_open_xrcd);
 	verbs_set_ctx_op(verbs_ctx, create_srq_ex, mlx4_create_srq_ex);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

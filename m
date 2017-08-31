From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 1/2] mlx5: Rename arm_db pointer to be cq_uar to better describe the content
Date: Thu, 31 Aug 2017 15:42:25 +0300
Message-ID: <1504183346-10742-2-git-send-email-yishaih@mellanox.com>
References: <1504183346-10742-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504183346-10742-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The arm_db field which was renamed from uar in this rdma-core release is
actually cq_uar.

Change its name before the rdma-core library is released and update man
page accordingly.

Fixes: 9b713bd703e9 ("mlx5: Fix ABI break from revising the UAR pointer")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/mlx5dv_init_obj.3 | 2 +-
 providers/mlx5/mlx5.c                | 4 ++--
 providers/mlx5/mlx5dv.h              | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/providers/mlx5/man/mlx5dv_init_obj.3 b/providers/mlx5/man/mlx5dv_init_obj.3
index 2468407..60d224a 100644
--- a/providers/mlx5/man/mlx5dv_init_obj.3
+++ b/providers/mlx5/man/mlx5dv_init_obj.3
@@ -52,7 +52,7 @@ void                    *buf;
 uint32_t                *dbrec;
 uint32_t                cqe_cnt;
 uint32_t                cqe_size;
-void                    *uar;
+void                    *cq_uar;
 uint32_t                cqn;
 uint64_t                comp_mask;
 .in -8
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index c949c0f..19e2aef 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -680,7 +680,7 @@ static int mlx5dv_get_cq(struct ibv_cq *cq_in,
 	cq_out->cqe_size  = mcq->cqe_sz;
 	cq_out->buf       = mcq->active_buf->buf;
 	cq_out->dbrec     = mcq->dbrec;
-	cq_out->arm_db	  = mctx->uar[0];
+	cq_out->cq_uar	  = mctx->uar[0];
 
 	mcq->flags	 |= MLX5_CQ_FLAGS_DV_OWNED;
 
@@ -747,7 +747,7 @@ COMPAT_SYMVER_FUNC(mlx5dv_init_obj, 1_0, "MLX5_1.0",
 		/* ABI version 1.0 returns the void ** in this memory
 		 * location
 		 */
-		obj->cq.out->arm_db = to_mctx(obj->cq.in->context)->uar;
+		obj->cq.out->cq_uar = to_mctx(obj->cq.in->context)->uar;
 	}
 	return ret;
 }
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 1a2e257..5d11625 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -129,7 +129,7 @@ struct mlx5dv_cq {
 	__be32			*dbrec;
 	uint32_t		cqe_cnt;
 	uint32_t		cqe_size;
-	void			*arm_db;
+	void			*cq_uar;
 	uint32_t		cqn;
 	uint64_t		comp_mask;
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

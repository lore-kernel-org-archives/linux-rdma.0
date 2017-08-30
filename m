From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx4: Extend mlx4dv_get_cq to return uar
Date: Wed, 30 Aug 2017 17:31:14 +0300
Message-ID: <1504103474-24345-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Extend mlx4dv_get_cq to return cq_uar to enable applications
direct access as part of arm_cq flow.

Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/203

 providers/mlx4/man/mlx4dv_init_obj.3 | 3 ++-
 providers/mlx4/mlx4.c                | 9 ++++++++-
 providers/mlx4/mlx4dv.h              | 6 ++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/providers/mlx4/man/mlx4dv_init_obj.3 b/providers/mlx4/man/mlx4dv_init_obj.3
index 7d10b93..c6d8d2b 100644
--- a/providers/mlx4/man/mlx4dv_init_obj.3
+++ b/providers/mlx4/man/mlx4dv_init_obj.3
@@ -62,7 +62,8 @@ uint32_t        *set_ci_db;
 uint32_t        *arm_db;
 int             arm_sn;
 int             cqe_size;
-uint64_t        comp_mask;
+uint64_t        comp_mask; /* Use enum mlx4dv_cq_comp_mask */
+void            *cq_uar;
 .in -8
 };
 
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index d65ef20..eecb9c7 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -375,8 +375,9 @@ static int mlx4dv_get_cq(struct ibv_cq *cq_in,
 			 struct mlx4dv_cq *cq_out)
 {
 	struct mlx4_cq *mcq = to_mcq(cq_in);
+	struct mlx4_context *mctx = to_mctx(cq_in->context);
+	uint64_t mask_out = 0;
 
-	cq_out->comp_mask = 0;
 	cq_out->buf.buf = mcq->buf.buf;
 	cq_out->buf.length = mcq->buf.length;
 	cq_out->cqn = mcq->cqn;
@@ -388,6 +389,12 @@ static int mlx4dv_get_cq(struct ibv_cq *cq_in,
 
 	mcq->flags |= MLX4_CQ_FLAGS_DV_OWNED;
 
+	if (cq_out->comp_mask & MLX4DV_CQ_MASK_UAR) {
+		cq_out->cq_uar = mctx->uar;
+		mask_out |= MLX4DV_CQ_MASK_UAR;
+	}
+
+	cq_out->comp_mask = mask_out;
 	return 0;
 }
 
diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index 16045ef..3f50d34 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -166,6 +166,10 @@ struct mlx4dv_qp {
 	uint64_t		comp_mask;
 };
 
+enum mlx4dv_cq_comp_mask {
+	MLX4DV_CQ_MASK_UAR		= 1 << 0,
+};
+
 struct mlx4dv_cq {
 	struct {
 		void			*buf;
@@ -178,7 +182,9 @@ struct mlx4dv_cq {
 	int				arm_sn;
 	int				cqe_size;
 	uint64_t			comp_mask;
+	void				*cq_uar;
 };
+
 struct mlx4dv_srq {
 	struct {
 		void			*buf;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

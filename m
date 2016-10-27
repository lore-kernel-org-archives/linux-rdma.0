From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 02/12] IB/mlx5: Fix atomic cap in indirect UMR
Date: Thu, 27 Oct 2016 16:36:37 +0300
Message-ID: <1477575407-20562-3-git-send-email-leon@kernel.org>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remove from the driver the limitation imposed by firmware check
to not allow change of atomic permissions for indirect UMRs.
In order to avoid failures on old firmware, we only ask for change
of atomic permissions if atomic operations are supported.

Fixes: 968e78dd9644 ('IB/mlx5: Enhance UMR support to allow partial page table update')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 00cffbf..5bdf20c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3071,7 +3071,7 @@ static void set_linv_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr)
 	umr->flags = MLX5_UMR_INLINE;
 }
 
-static __be64 get_umr_reg_mr_mask(void)
+static __be64 get_umr_reg_mr_mask(int atomic)
 {
 	u64 result;
 
@@ -3084,9 +3084,11 @@ static __be64 get_umr_reg_mr_mask(void)
 		 MLX5_MKEY_MASK_KEY		|
 		 MLX5_MKEY_MASK_RR		|
 		 MLX5_MKEY_MASK_RW		|
-		 MLX5_MKEY_MASK_A		|
 		 MLX5_MKEY_MASK_FREE;
 
+	if (atomic)
+		result |= MLX5_MKEY_MASK_A;
+
 	return cpu_to_be64(result);
 }
 
@@ -3147,7 +3149,7 @@ static __be64 get_umr_update_pd_mask(void)
 }
 
 static void set_reg_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
-				struct ib_send_wr *wr)
+				struct ib_send_wr *wr, int atomic)
 {
 	struct mlx5_umr_wr *umrwr = umr_wr(wr);
 
@@ -3172,7 +3174,7 @@ static void set_reg_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
 		if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_PD)
 			umr->mkey_mask |= get_umr_update_pd_mask();
 		if (!umr->mkey_mask)
-			umr->mkey_mask = get_umr_reg_mr_mask();
+			umr->mkey_mask = get_umr_reg_mr_mask(atomic);
 	} else {
 		umr->mkey_mask = get_umr_unreg_mr_mask();
 	}
@@ -4025,7 +4027,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			}
 			qp->sq.wr_data[idx] = MLX5_IB_WR_UMR;
 			ctrl->imm = cpu_to_be32(umr_wr(wr)->mkey);
-			set_reg_umr_segment(seg, wr);
+			set_reg_umr_segment(seg, wr, !!(MLX5_CAP_GEN(mdev, atomic)));
 			seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
 			size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
 			if (unlikely((seg == qend)))
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes-3.12 01/15] IB/mlx5: Fix send work queue size calculation
Date: Wed, 11 Sep 2013 16:35:22 +0300
Message-ID: <1378906536-6925-2-git-send-email-ogerlitz@mellanox.com>
References: <1378906536-6925-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378906536-6925-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elic-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

1. Make sure wqe_cnt does not exceed the limit published by firmware.
2. There is no requirement that the number of outstanding work requests will be
   a power of two. Remove the ilog2 in the calculation of sq.max_post to fix that.
3. Add case for IB_QPT_XRC_TGT in sq_overhead and return 0 as XRC target QPs do
   not have a send queue.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 045f8cd..05d53f1 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -203,7 +203,7 @@ static int sq_overhead(enum ib_qp_type qp_type)
 
 	switch (qp_type) {
 	case IB_QPT_XRC_INI:
-		size = sizeof(struct mlx5_wqe_xrc_seg);
+		size += sizeof(struct mlx5_wqe_xrc_seg);
 		/* fall through */
 	case IB_QPT_RC:
 		size += sizeof(struct mlx5_wqe_ctrl_seg) +
@@ -211,20 +211,23 @@ static int sq_overhead(enum ib_qp_type qp_type)
 			sizeof(struct mlx5_wqe_raddr_seg);
 		break;
 
+	case IB_QPT_XRC_TGT:
+		return 0;
+
 	case IB_QPT_UC:
-		size = sizeof(struct mlx5_wqe_ctrl_seg) +
+		size += sizeof(struct mlx5_wqe_ctrl_seg) +
 			sizeof(struct mlx5_wqe_raddr_seg);
 		break;
 
 	case IB_QPT_UD:
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:
-		size = sizeof(struct mlx5_wqe_ctrl_seg) +
+		size += sizeof(struct mlx5_wqe_ctrl_seg) +
 			sizeof(struct mlx5_wqe_datagram_seg);
 		break;
 
 	case MLX5_IB_QPT_REG_UMR:
-		size = sizeof(struct mlx5_wqe_ctrl_seg) +
+		size += sizeof(struct mlx5_wqe_ctrl_seg) +
 			sizeof(struct mlx5_wqe_umr_ctrl_seg) +
 			sizeof(struct mlx5_mkey_seg);
 		break;
@@ -270,7 +273,8 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 		return wqe_size;
 
 	if (wqe_size > dev->mdev.caps.max_sq_desc_sz) {
-		mlx5_ib_dbg(dev, "\n");
+		mlx5_ib_dbg(dev, "wqe_size(%d) > max_sq_desc_sz(%d)\n",
+			    wqe_size, dev->mdev.caps.max_sq_desc_sz);
 		return -EINVAL;
 	}
 
@@ -280,9 +284,15 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 
 	wq_size = roundup_pow_of_two(attr->cap.max_send_wr * wqe_size);
 	qp->sq.wqe_cnt = wq_size / MLX5_SEND_WQE_BB;
+	if (qp->sq.wqe_cnt > dev->mdev.caps.max_wqes) {
+		mlx5_ib_dbg(dev, "wqe count(%d) exceeds limits(%d)\n",
+			    qp->sq.wqe_cnt, dev->mdev.caps.max_wqes);
+		return -ENOMEM;
+	}
 	qp->sq.wqe_shift = ilog2(MLX5_SEND_WQE_BB);
 	qp->sq.max_gs = attr->cap.max_send_sge;
-	qp->sq.max_post = 1 << ilog2(wq_size / wqe_size);
+	qp->sq.max_post = wq_size / wqe_size;
+	attr->cap.max_send_wr = qp->sq.max_post;
 
 	return wq_size;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

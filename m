From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Sun, 28 May 2017 10:53:11 +0300
Message-ID: <1495957991-19223-2-git-send-email-maxg@mellanox.com>
References: <1495957991-19223-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495957991-19223-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
Cc: shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Cache the needed umr_fence and set the wqe ctrl segmennt
accordingly.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---

Changes from v1:
 - updated MLX5_FENCE_MODE_STRONG_ORDERING to be default value
   in mlx5_get_umr_fence.

---
 drivers/infiniband/hw/mlx5/main.c    |   14 ++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    1 +
 drivers/infiniband/hw/mlx5/qp.c      |   15 +++++++--------
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d45772d..83d1f9b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2979,6 +2979,18 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 	return ret;
 }
 
+static u8 mlx5_get_umr_fence(u8 umr_fence_cap)
+{
+	switch (umr_fence_cap) {
+	case MLX5_CAP_UMR_FENCE_NONE:
+		return MLX5_FENCE_MODE_NONE;
+	case MLX5_CAP_UMR_FENCE_SMALL:
+		return MLX5_FENCE_MODE_INITIATOR_SMALL;
+	default:
+		return MLX5_FENCE_MODE_STRONG_ORDERING;
+	}
+}
+
 static int create_dev_resources(struct mlx5_ib_resources *devr)
 {
 	struct ib_srq_init_attr attr;
@@ -3693,6 +3705,8 @@ static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
 
 	mlx5_ib_internal_fill_odp_caps(dev);
 
+	dev->umr_fence = mlx5_get_umr_fence(MLX5_CAP_GEN(mdev, umr_fence));
+
 	if (MLX5_CAP_GEN(mdev, imaicl)) {
 		dev->ib_dev.alloc_mw		= mlx5_ib_alloc_mw;
 		dev->ib_dev.dealloc_mw		= mlx5_ib_dealloc_mw;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 38c877b..0e08a58 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -654,6 +654,7 @@ struct mlx5_ib_dev {
 	struct mlx5_ib_port	*port;
 	struct mlx5_sq_bfreg     bfreg;
 	struct mlx5_sq_bfreg     fp_bfreg;
+	u8				umr_fence;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 93959e1..876a429 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3738,11 +3738,10 @@ static void dump_wqe(struct mlx5_ib_qp *qp, int idx, int size_16)
 	}
 }
 
-static u8 get_fence(u8 fence, struct ib_send_wr *wr)
+static u8 get_fence(u8 fence, struct ib_send_wr *wr, struct mlx5_ib_dev *dev)
 {
-	if (unlikely(wr->opcode == IB_WR_LOCAL_INV &&
-		     wr->send_flags & IB_SEND_FENCE))
-		return MLX5_FENCE_MODE_STRONG_ORDERING;
+	if (wr->opcode == IB_WR_LOCAL_INV || wr->opcode == IB_WR_REG_MR)
+		return dev->umr_fence;
 
 	if (unlikely(fence)) {
 		if (wr->send_flags & IB_SEND_FENCE)
@@ -3928,7 +3927,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				}
 
 				finish_wqe(qp, ctrl, size, idx, wr->wr_id,
-					   nreq, get_fence(fence, wr),
+					   nreq, get_fence(fence, wr, dev),
 					   next_fence, MLX5_OPCODE_UMR);
 				/*
 				 * SET_PSV WQEs are not signaled and solicited
@@ -3955,7 +3954,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				}
 
 				finish_wqe(qp, ctrl, size, idx, wr->wr_id,
-					   nreq, get_fence(fence, wr),
+					   nreq, get_fence(fence, wr, dev),
 					   next_fence, MLX5_OPCODE_SET_PSV);
 				err = begin_wqe(qp, &seg, &ctrl, wr,
 						&idx, &size, nreq);
@@ -3977,7 +3976,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				}
 
 				finish_wqe(qp, ctrl, size, idx, wr->wr_id,
-					   nreq, get_fence(fence, wr),
+					   nreq, get_fence(fence, wr, dev),
 					   next_fence, MLX5_OPCODE_SET_PSV);
 				num_sge = 0;
 				goto skip_psv;
@@ -4090,7 +4089,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		}
 
 		finish_wqe(qp, ctrl, size, idx, wr->wr_id, nreq,
-			   get_fence(fence, wr), next_fence,
+			   get_fence(fence, wr, dev), next_fence,
 			   mlx5_ib_opcode[wr->opcode]);
 skip_psv:
 		if (0)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes-3.12 09/15] IB/mlx5: Disable atomic operations
Date: Wed, 11 Sep 2013 16:35:30 +0300
Message-ID: <1378906536-6925-10-git-send-email-ogerlitz@mellanox.com>
References: <1378906536-6925-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378906536-6925-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elic-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently Atomic operations don't work properly. Disable them for the time
being.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |    5 +--
 drivers/infiniband/hw/mlx5/qp.c   |   48 +++---------------------------------
 2 files changed, 6 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e59761e..b267c65 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -301,9 +301,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_srq_sge	   = max_rq_sg - 1;
 	props->max_fast_reg_page_list_len = (unsigned int)-1;
 	props->local_ca_ack_delay  = dev->mdev.caps.local_ca_ack_delay;
-	props->atomic_cap	   = dev->mdev.caps.flags & MLX5_DEV_CAP_FLAG_ATOMIC ?
-		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
-	props->masked_atomic_cap   = IB_ATOMIC_HCA;
+	props->atomic_cap	   = IB_ATOMIC_NONE;
+	props->masked_atomic_cap   = IB_ATOMIC_NONE;
 	props->max_pkeys	   = be16_to_cpup((__be16 *)(out_mad->data + 28));
 	props->max_mcast_grp	   = 1 << dev->mdev.caps.log_max_mcg;
 	props->max_mcast_qp_attach = dev->mdev.caps.max_qp_mcg;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 05d53f1..10b077d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1661,29 +1661,6 @@ static __always_inline void set_raddr_seg(struct mlx5_wqe_raddr_seg *rseg,
 	rseg->reserved = 0;
 }
 
-static void set_atomic_seg(struct mlx5_wqe_atomic_seg *aseg, struct ib_send_wr *wr)
-{
-	if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
-		aseg->swap_add = cpu_to_be64(wr->wr.atomic.swap);
-		aseg->compare  = cpu_to_be64(wr->wr.atomic.compare_add);
-	} else if (wr->opcode == IB_WR_MASKED_ATOMIC_FETCH_AND_ADD) {
-		aseg->swap_add = cpu_to_be64(wr->wr.atomic.compare_add);
-		aseg->compare  = cpu_to_be64(wr->wr.atomic.compare_add_mask);
-	} else {
-		aseg->swap_add = cpu_to_be64(wr->wr.atomic.compare_add);
-		aseg->compare  = 0;
-	}
-}
-
-static void set_masked_atomic_seg(struct mlx5_wqe_masked_atomic_seg *aseg,
-				  struct ib_send_wr *wr)
-{
-	aseg->swap_add		= cpu_to_be64(wr->wr.atomic.swap);
-	aseg->swap_add_mask	= cpu_to_be64(wr->wr.atomic.swap_mask);
-	aseg->compare		= cpu_to_be64(wr->wr.atomic.compare_add);
-	aseg->compare_mask	= cpu_to_be64(wr->wr.atomic.compare_add_mask);
-}
-
 static void set_datagram_seg(struct mlx5_wqe_datagram_seg *dseg,
 			     struct ib_send_wr *wr)
 {
@@ -2073,28 +2050,11 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 			case IB_WR_ATOMIC_CMP_AND_SWP:
 			case IB_WR_ATOMIC_FETCH_AND_ADD:
-				set_raddr_seg(seg, wr->wr.atomic.remote_addr,
-					      wr->wr.atomic.rkey);
-				seg  += sizeof(struct mlx5_wqe_raddr_seg);
-
-				set_atomic_seg(seg, wr);
-				seg  += sizeof(struct mlx5_wqe_atomic_seg);
-
-				size += (sizeof(struct mlx5_wqe_raddr_seg) +
-					 sizeof(struct mlx5_wqe_atomic_seg)) / 16;
-				break;
-
 			case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
-				set_raddr_seg(seg, wr->wr.atomic.remote_addr,
-					      wr->wr.atomic.rkey);
-				seg  += sizeof(struct mlx5_wqe_raddr_seg);
-
-				set_masked_atomic_seg(seg, wr);
-				seg  += sizeof(struct mlx5_wqe_masked_atomic_seg);
-
-				size += (sizeof(struct mlx5_wqe_raddr_seg) +
-					 sizeof(struct mlx5_wqe_masked_atomic_seg)) / 16;
-				break;
+				mlx5_ib_warn(dev, "Atomic operations are not supported yet\n");
+				err = -ENOSYS;
+				*bad_wr = wr;
+				goto out;
 
 			case IB_WR_LOCAL_INV:
 				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

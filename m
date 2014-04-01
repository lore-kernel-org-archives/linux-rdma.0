From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next] IB/mlx5: Add block multicast loopback support
Date: Wed,  2 Apr 2014 00:10:16 +0300
Message-ID: <1396386616-17846-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Add support for the block multicast loopback QP creation flag along
the proper firmware API for that.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |    2 ++
 drivers/infiniband/hw/mlx5/qp.c   |   12 ++++++++++++
 include/linux/mlx5/device.h       |    1 +
 include/linux/mlx5/qp.h           |    1 +
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7b9c078..7470f8b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -282,6 +282,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->sig_guard_cap = IB_GUARD_T10DIF_CRC |
 				       IB_GUARD_T10DIF_CSUM;
 	}
+	if (flags & MLX5_DEV_CAP_FLAG_BLOCK_MCAST)
+		props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
 
 	props->vendor_id	   = be32_to_cpup((__be32 *)(out_mad->data + 36)) &
 		0xffffff;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ae788d2..dc930ed 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -807,6 +807,15 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	spin_lock_init(&qp->sq.lock);
 	spin_lock_init(&qp->rq.lock);
 
+	if (init_attr->create_flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
+		if (!(dev->mdev.caps.flags & MLX5_DEV_CAP_FLAG_BLOCK_MCAST)) {
+			mlx5_ib_dbg(dev, "block multicast loopback isn't supported\n");
+			return -EINVAL;
+		} else {
+			qp->flags |= MLX5_IB_QP_BLOCK_MULTICAST_LOOPBACK;
+		}
+	}
+
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		qp->sq_signal_bits = MLX5_WQE_CTRL_CQ_UPDATE;
 
@@ -878,6 +887,9 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (qp->wq_sig)
 		in->ctx.flags_pd |= cpu_to_be32(MLX5_QP_ENABLE_SIG);
 
+	if (qp->flags & MLX5_IB_QP_BLOCK_MULTICAST_LOOPBACK)
+		in->ctx.flags_pd |= cpu_to_be32(MLX5_QP_BLOCK_MCAST);
+
 	if (qp->scat_cqe && is_connected(init_attr->qp_type)) {
 		int rcqe_sz;
 		int scqe_sz;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 407bdb6..3406cfb 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -179,6 +179,7 @@ enum {
 	MLX5_DEV_CAP_FLAG_BAD_QKEY_CNTR	= 1LL <<  9,
 	MLX5_DEV_CAP_FLAG_APM		= 1LL << 17,
 	MLX5_DEV_CAP_FLAG_ATOMIC	= 1LL << 18,
+	MLX5_DEV_CAP_FLAG_BLOCK_MCAST	= 1LL << 23,
 	MLX5_DEV_CAP_FLAG_ON_DMND_PG	= 1LL << 24,
 	MLX5_DEV_CAP_FLAG_CQ_MODER	= 1LL << 29,
 	MLX5_DEV_CAP_FLAG_RESIZE_CQ	= 1LL << 30,
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index f829ad8..9709b30 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -146,6 +146,7 @@ enum {
 
 enum {
 	MLX5_QP_LAT_SENSITIVE	= 1 << 28,
+	MLX5_QP_BLOCK_MCAST	= 1 << 30,
 	MLX5_QP_ENABLE_SIG	= 1 << 31,
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

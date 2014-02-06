From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IB/mlx5: Clear block multicast capability
Date: Thu,  6 Feb 2014 17:41:25 +0200
Message-ID: <1391701285-24622-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently Connect-IB does not support block multicast so do not set
IB_DEVICE_BLOCK_MULTICAST_LOOPBACK.

Reported by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +--
 drivers/infiniband/hw/mlx5/qp.c   | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f4ef4a24d410..aa03e732b6a8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -261,8 +261,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->device_cap_flags    = IB_DEVICE_CHANGE_PHY_PORT |
 		IB_DEVICE_PORT_ACTIVE_EVENT		|
 		IB_DEVICE_SYS_IMAGE_GUID		|
-		IB_DEVICE_RC_RNR_NAK_GEN		|
-		IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
+		IB_DEVICE_RC_RNR_NAK_GEN;
 	flags = dev->mdev.caps.flags;
 	if (flags & MLX5_DEV_CAP_FLAG_BAD_PKEY_CNTR)
 		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 091576a777e9..7dfe8a1c84cf 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -665,8 +665,8 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 	int err;
 
 	uuari = &dev->mdev.priv.uuari;
-	if (init_attr->create_flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
-		qp->flags |= MLX5_IB_QP_BLOCK_MULTICAST_LOOPBACK;
+	if (init_attr->create_flags)
+		return -EINVAL;
 
 	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)
 		lc = MLX5_IB_LATENCY_CLASS_FAST_PATH;
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

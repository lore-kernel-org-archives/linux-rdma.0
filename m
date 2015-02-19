From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 22/30] IB/mlx4: Advertise RoCE support in port capabilities
Date: Fri, 20 Feb 2015 03:32:37 +0530
Message-ID: <12499507-10f3-471b-af68-82efcb7e3147@CMEXHTCAS2.ad.emulex.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424383365-19337-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The port capability flags should indicate the support in RoCE modes (V1
or V2) of the port. The mlx4 driver sets these flags according to the
capabilities reported by the HW.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c       |    6 ++++++
 drivers/net/ethernet/mellanox/mlx4/fw.c |    5 ++++-
 include/linux/mlx4/device.h             |   13 ++++++++++---
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 32cd009..bf87a95 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -359,6 +359,12 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 						IB_WIDTH_4X : IB_WIDTH_1X;
 	props->active_speed	= IB_SPEED_QDR;
 	props->port_cap_flags	= IB_PORT_CM_SUP | IB_PORT_IP_BASED_GIDS;
+
+	if (mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
+		props->port_cap_flags	|= IB_PORT_ROCE;
+	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2)
+		props->port_cap_flags	|= IB_PORT_ROCE_V2 | IB_PORT_ROCE;
+
 	props->gid_tbl_len	= mdev->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= mdev->dev->caps.max_msg_sz;
 	props->pkey_tbl_len	= 1;
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 3702fd1..d573e73 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -146,7 +146,8 @@ static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
 		[17] = "Asymmetric EQs support",
 		[18] = "More than 80 VFs support",
 		[19] = "Performance optimized for limited rule configuration flow steering support",
-		[21] = "Port Remap support"
+		[21] = "Port Remap support",
+		[22] = "RoCEv2 support"
 	};
 	int i;
 
@@ -852,6 +853,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_EQE_STRIDE;
 	MLX4_GET(dev_cap->bmme_flags, outbox,
 		 QUERY_DEV_CAP_BMME_FLAGS_OFFSET);
+	if (dev_cap->bmme_flags & MLX4_FLAG_ROCE_V1_V2)
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_ROCE_V1_V2;
 	if (dev_cap->bmme_flags & MLX4_FLAG_PORT_REMAP)
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_PORT_REMAP;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_CONFIG_DEV_OFFSET);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 9a05e73..02dd6a0 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -202,7 +202,8 @@ enum {
 	MLX4_DEV_CAP_FLAG2_SYS_EQS		= 1LL <<  17,
 	MLX4_DEV_CAP_FLAG2_80_VFS		= 1LL <<  18,
 	MLX4_DEV_CAP_FLAG2_FS_A0		= 1LL <<  19,
-	MLX4_DEV_CAP_FLAG2_PORT_REMAP		= 1LL <<  21
+	MLX4_DEV_CAP_FLAG2_PORT_REMAP		= 1LL <<  21,
++	MLX4_DEV_CAP_FLAG2_ROCE_V1_V2		= 1LL <<  22
 };
 
 enum {
@@ -250,6 +251,7 @@ enum {
 	MLX4_BMME_FLAG_TYPE_2_WIN	= 1 <<  9,
 	MLX4_BMME_FLAG_RESERVED_LKEY	= 1 << 10,
 	MLX4_BMME_FLAG_FAST_REG_WR	= 1 << 11,
+	MLX4_BMME_FLAG_ROCE_V1_V2	= 1 << 19,
 	MLX4_BMME_FLAG_PORT_REMAP	= 1 << 24,
 	MLX4_BMME_FLAG_VSD_INIT2RTR	= 1 << 28,
 };
@@ -258,6 +260,10 @@ enum {
 	MLX4_FLAG_PORT_REMAP		= MLX4_BMME_FLAG_PORT_REMAP
 };
 
+enum {
+	MLX4_FLAG_ROCE_V1_V2		= MLX4_BMME_FLAG_ROCE_V1_V2
+};
+
 enum mlx4_event {
 	MLX4_EVENT_TYPE_COMP		   = 0x00,
 	MLX4_EVENT_TYPE_PATH_MIG	   = 0x01,
@@ -888,9 +894,10 @@ struct mlx4_mad_ifc {
 		if (((dev)->caps.port_mask[port] != MLX4_PORT_TYPE_IB))
 
 #define mlx4_foreach_ib_transport_port(port, dev)                         \
-	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	  \
+	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)       \
 		if (((dev)->caps.port_mask[port] == MLX4_PORT_TYPE_IB) || \
-			((dev)->caps.flags & MLX4_DEV_CAP_FLAG_IBOE))
+			((dev)->caps.flags & MLX4_DEV_CAP_FLAG_IBOE) || \
+			((dev)->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2))
 
 #define MLX4_INVALID_SLAVE_ID	0xFF
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

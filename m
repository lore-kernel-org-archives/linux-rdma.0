From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/7] IB/mlx4: Query RoCE support
Date: Tue, 29 Dec 2015 15:24:01 +0200
Message-ID: <1451395447-5198-2-git-send-email-matanb@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Query the RoCE support from firmware using the appropriate firmware
commands. Downstream patches will read these capabilities and act
accordingly.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c   |  3 +++
 drivers/net/ethernet/mellanox/mlx4/main.c |  6 +++++-
 include/linux/mlx4/device.h               | 11 +++++++++--
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 90db94e..bdd6822 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -157,6 +157,7 @@ static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
 		[29] = "802.1ad offload support",
 		[31] = "Modifying loopback source checks using UPDATE_QP support",
 		[32] = "Loopback source checks support",
+		[33] = "RoCEv2 support"
 	};
 	int i;
 
@@ -905,6 +906,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_EQE_STRIDE;
 	MLX4_GET(dev_cap->bmme_flags, outbox,
 		 QUERY_DEV_CAP_BMME_FLAGS_OFFSET);
+	if (dev_cap->bmme_flags & MLX4_FLAG_ROCE_V1_V2)
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_ROCE_V1_V2;
 	if (dev_cap->bmme_flags & MLX4_FLAG_PORT_REMAP)
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_PORT_REMAP;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_CONFIG_DEV_OFFSET);
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 31c491e..fb4968f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -424,8 +424,12 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	if (mlx4_priv(dev)->pci_dev_data & MLX4_PCI_DEV_FORCE_SENSE_PORT)
 		dev->caps.flags |= MLX4_DEV_CAP_FLAG_SENSE_SUPPORT;
 	/* Don't do sense port on multifunction devices (for now at least) */
-	if (mlx4_is_mfunc(dev))
+	/* Don't do enable RoCE V2 on multifunction devices */
+	if (mlx4_is_mfunc(dev)) {
 		dev->caps.flags &= ~MLX4_DEV_CAP_FLAG_SENSE_SUPPORT;
+		dev_cap->flags2 &= ~MLX4_DEV_CAP_FLAG2_ROCE_V1_V2;
+		mlx4_dbg(dev, "RoCE V2 is not supported when SR-IOV is enabled\n");
+	}
 
 	if (mlx4_low_memory_profile()) {
 		dev->caps.log_num_macs  = MLX4_MIN_LOG_NUM_MAC;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index d3133be..dbf39ab 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -216,6 +216,7 @@ enum {
 	MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN	= 1LL <<  30,
 	MLX4_DEV_CAP_FLAG2_UPDATE_QP_SRC_CHECK_LB = 1ULL << 31,
 	MLX4_DEV_CAP_FLAG2_LB_SRC_CHK           = 1ULL << 32,
+	MLX4_DEV_CAP_FLAG2_ROCE_V1_V2		= 1LL <<  33,
 };
 
 enum {
@@ -267,6 +268,7 @@ enum {
 	MLX4_BMME_FLAG_TYPE_2_WIN	= 1 <<  9,
 	MLX4_BMME_FLAG_RESERVED_LKEY	= 1 << 10,
 	MLX4_BMME_FLAG_FAST_REG_WR	= 1 << 11,
+	MLX4_BMME_FLAG_ROCE_V1_V2	= 1 << 19,
 	MLX4_BMME_FLAG_PORT_REMAP	= 1 << 24,
 	MLX4_BMME_FLAG_VSD_INIT2RTR	= 1 << 28,
 };
@@ -275,6 +277,10 @@ enum {
 	MLX4_FLAG_PORT_REMAP		= MLX4_BMME_FLAG_PORT_REMAP
 };
 
+enum {
+	MLX4_FLAG_ROCE_V1_V2		= MLX4_BMME_FLAG_ROCE_V1_V2
+};
+
 enum mlx4_event {
 	MLX4_EVENT_TYPE_COMP		   = 0x00,
 	MLX4_EVENT_TYPE_PATH_MIG	   = 0x01,
@@ -984,9 +990,10 @@ struct mlx4_mad_ifc {
 		if (((dev)->caps.port_mask[port] != MLX4_PORT_TYPE_IB))
 
 #define mlx4_foreach_ib_transport_port(port, dev)                         \
-	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	  \
+	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)       \
 		if (((dev)->caps.port_mask[port] == MLX4_PORT_TYPE_IB) || \
-			((dev)->caps.flags & MLX4_DEV_CAP_FLAG_IBOE))
+			((dev)->caps.flags & MLX4_DEV_CAP_FLAG_IBOE) || \
+			((dev)->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2))
 
 #define MLX4_INVALID_SLAVE_ID	0xFF
 #define MLX4_SINK_COUNTER_INDEX(dev)	(dev->caps.max_counters - 1)
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

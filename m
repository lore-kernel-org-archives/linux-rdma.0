From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 01/12] net/mlx4: Query RoCE support
Date: Thu, 14 Jan 2016 17:50:32 +0200
Message-ID: <792b1cbe5dd121c320ba01a688ba9f9d3f8bbb78.1452780850.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Query the RoCE support from firmware using the appropriate firmware
commands. Downstream patches will read these capabilities and act
accordingly.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c | 23 +++++++++++++++++++++++
 include/linux/mlx4/device.h             | 10 +++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 2c2baab..3d05855 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -157,6 +157,7 @@ static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
 		[29] = "802.1ad offload support",
 		[31] = "Modifying loopback source checks using UPDATE_QP support",
 		[32] = "Loopback source checks support",
+		[33] = "RoCEv2 support"
 	};
 	int i;
 
@@ -626,6 +627,8 @@ out:
 	return err;
 }
 
+static void disable_unsupported_roce_caps(void *buf);
+
 int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 {
 	struct mlx4_cmd_mailbox *mailbox;
@@ -738,6 +741,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	if (err)
 		goto out;
 
+	if (mlx4_is_mfunc(dev))
+		disable_unsupported_roce_caps(outbox);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_QP_OFFSET);
 	dev_cap->reserved_qps = 1 << (field & 0xf);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_QP_OFFSET);
@@ -905,6 +910,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_EQE_STRIDE;
 	MLX4_GET(dev_cap->bmme_flags, outbox,
 		 QUERY_DEV_CAP_BMME_FLAGS_OFFSET);
+	if (dev_cap->bmme_flags & MLX4_FLAG_ROCE_V1_V2)
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_ROCE_V1_V2;
 	if (dev_cap->bmme_flags & MLX4_FLAG_PORT_REMAP)
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_PORT_REMAP;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_CONFIG_DEV_OFFSET);
@@ -1161,6 +1168,7 @@ int mlx4_QUERY_DEV_CAP_wrapper(struct mlx4_dev *dev, int slave,
 	if (err)
 		return err;
 
+	disable_unsupported_roce_caps(outbox->buf);
 	/* add port mng change event capability and disable mw type 1
 	 * unconditionally to slaves
 	 */
@@ -1258,6 +1266,21 @@ int mlx4_QUERY_DEV_CAP_wrapper(struct mlx4_dev *dev, int slave,
 	return 0;
 }
 
+static void disable_unsupported_roce_caps(void *buf)
+{
+	u32 flags;
+
+	MLX4_GET(flags, buf, QUERY_DEV_CAP_EXT_FLAGS_OFFSET);
+	flags &= ~(1UL << 31);
+	MLX4_PUT(buf, flags, QUERY_DEV_CAP_EXT_FLAGS_OFFSET);
+	MLX4_GET(flags, buf, QUERY_DEV_CAP_EXT_2_FLAGS_OFFSET);
+	flags &= ~(1UL << 24);
+	MLX4_PUT(buf, flags, QUERY_DEV_CAP_EXT_2_FLAGS_OFFSET);
+	MLX4_GET(flags, buf, QUERY_DEV_CAP_BMME_FLAGS_OFFSET);
+	flags &= ~(MLX4_FLAG_ROCE_V1_V2);
+	MLX4_PUT(buf, flags, QUERY_DEV_CAP_BMME_FLAGS_OFFSET);
+}
+
 int mlx4_QUERY_PORT_wrapper(struct mlx4_dev *dev, int slave,
 			    struct mlx4_vhcr *vhcr,
 			    struct mlx4_cmd_mailbox *inbox,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 6309ff1..2a7a0e2 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -218,6 +218,7 @@ enum {
 	MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN	= 1LL <<  30,
 	MLX4_DEV_CAP_FLAG2_UPDATE_QP_SRC_CHECK_LB = 1ULL << 31,
 	MLX4_DEV_CAP_FLAG2_LB_SRC_CHK           = 1ULL << 32,
+	MLX4_DEV_CAP_FLAG2_ROCE_V1_V2		= 1ULL <<  33,
 };
 
 enum {
@@ -269,12 +270,14 @@ enum {
 	MLX4_BMME_FLAG_TYPE_2_WIN	= 1 <<  9,
 	MLX4_BMME_FLAG_RESERVED_LKEY	= 1 << 10,
 	MLX4_BMME_FLAG_FAST_REG_WR	= 1 << 11,
+	MLX4_BMME_FLAG_ROCE_V1_V2	= 1 << 19,
 	MLX4_BMME_FLAG_PORT_REMAP	= 1 << 24,
 	MLX4_BMME_FLAG_VSD_INIT2RTR	= 1 << 28,
 };
 
 enum {
-	MLX4_FLAG_PORT_REMAP		= MLX4_BMME_FLAG_PORT_REMAP
+	MLX4_FLAG_PORT_REMAP		= MLX4_BMME_FLAG_PORT_REMAP,
+	MLX4_FLAG_ROCE_V1_V2		= MLX4_BMME_FLAG_ROCE_V1_V2
 };
 
 enum mlx4_event {
@@ -983,9 +986,10 @@ struct mlx4_mad_ifc {
 		if ((type) == (dev)->caps.port_mask[(port)])
 
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
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

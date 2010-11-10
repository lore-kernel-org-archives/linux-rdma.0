From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3] mlx4: support allocation of counters
Date: Wed, 10 Nov 2010 14:23:48 +0200
Message-ID: <20101110122348.GC12037@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CX devices support sets of counters that can be used to count packets and data
octets in receive and transmit. This patch queries the device to check support
for counters, either basic or extended, and initializes a bitmap allocator to
control allocations.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/fw.c       |   14 +++++++-
 drivers/net/mlx4/main.c     |   84 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/net/mlx4/mlx4.h     |    1 +
 include/linux/mlx4/device.h |   12 ++++++
 4 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 9e73f22..79e1b22 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -99,7 +99,9 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
 		[21] = "UD multicast support",
 		[24] = "Demand paging support",
 		[25] = "Router support",
-		[30] = "IBoE support"
+		[30] = "IBoE support",
+		[48] = "Basic counters support",
+		[49] = "Extended counters support",
 	};
 	int i;
 
@@ -214,6 +216,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_BMME_FLAGS_OFFSET		0x94
 #define QUERY_DEV_CAP_RSVD_LKEY_OFFSET		0x98
 #define QUERY_DEV_CAP_MAX_ICM_SZ_OFFSET		0xa0
+#define QUERY_DEV_CAP_MAX_BASIC_CNT_OFFSET	0x68
+#define QUERY_DEV_CAP_MAX_EXT_CNT_OFFSET	0x6c
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox))
@@ -355,6 +359,10 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		 QUERY_DEV_CAP_RSVD_LKEY_OFFSET);
 	MLX4_GET(dev_cap->max_icm_sz, outbox,
 		 QUERY_DEV_CAP_MAX_ICM_SZ_OFFSET);
+	MLX4_GET(dev_cap->max_basic_counters, outbox,
+		 QUERY_DEV_CAP_MAX_BASIC_CNT_OFFSET);
+	MLX4_GET(dev_cap->max_ext_counters, outbox,
+		 QUERY_DEV_CAP_MAX_EXT_CNT_OFFSET);
 
 	if (dev->flags & MLX4_FLAG_OLD_PORT_CMDS) {
 		for (i = 1; i <= dev_cap->num_ports; ++i) {
@@ -779,6 +787,10 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 	if (enable_qos)
 		*(inbox + INIT_HCA_FLAGS_OFFSET / 4) |= cpu_to_be32(1 << 2);
 
+	/* counters mode */
+	*(inbox + INIT_HCA_FLAGS_OFFSET / 4) |=
+		cpu_to_be32(dev->caps.counters_mode << 4);
+
 	/* QPC/EEC/CQC/EQC/RDMARC attributes */
 
 	MLX4_PUT(inbox, param->qpc_base,      INIT_HCA_QPC_BASE_OFFSET);
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 782f11d..70985d8 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -142,6 +142,20 @@ static void mlx4_set_port_mask(struct mlx4_dev *dev)
 		if (dev->caps.port_type[i] == MLX4_PORT_TYPE_IB)
 			dev->caps.port_mask |= 1 << (i - 1);
 }
+
+static u8 get_counters_mode(u64 flags)
+{
+	switch (flags >> 48 & 3) {
+	case 2:
+	case 3:
+		return MLX4_COUNTERS_EXT;
+	case 1:
+		return MLX4_COUNTERS_BASIC;
+	default:
+		return MLX4_COUNTERS_DISABLED;
+	}
+}
+
 static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 {
 	int err;
@@ -258,6 +272,10 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 
 	mlx4_set_port_mask(dev);
 
+	dev->caps.counters_mode = get_counters_mode(dev_cap->flags);
+	dev->caps.max_basic_counters = 1 << ilog2(dev_cap->max_basic_counters);
+	dev->caps.max_ext_counters = 1 << ilog2(dev_cap->max_ext_counters);
+
 	dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FW] = dev_cap->reserved_qps;
 	dev->caps.reserved_qps_cnt[MLX4_QP_REGION_ETH_ADDR] =
 		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_ADDR] =
@@ -808,6 +826,59 @@ err_stop_fw:
 	return err;
 }
 
+static int mlx4_init_counters_table(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int err;
+	int nent;
+
+	switch (dev->caps.counters_mode) {
+	case MLX4_COUNTERS_BASIC:
+		nent = dev->caps.max_basic_counters;
+		break;
+	case MLX4_COUNTERS_EXT:
+		nent = dev->caps.max_ext_counters;
+		break;
+	default:
+		return -ENOENT;
+	}
+	err = mlx4_bitmap_init(&priv->counters_bitmap, nent, nent - 1, 0, 0);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void mlx4_cleanup_counters_table(struct mlx4_dev *dev)
+{
+	switch (dev->caps.counters_mode) {
+	case MLX4_COUNTERS_BASIC:
+	case MLX4_COUNTERS_EXT:
+		mlx4_bitmap_cleanup(&mlx4_priv(dev)->counters_bitmap);
+		break;
+	default:
+		break;
+	}
+}
+
+int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	*idx = mlx4_bitmap_alloc(&priv->counters_bitmap);
+	if (*idx == -1)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_counter_alloc);
+
+void mlx4_counter_free(struct mlx4_dev *dev, u32 idx)
+{
+	mlx4_bitmap_free(&mlx4_priv(dev)->counters_bitmap, idx);
+}
+EXPORT_SYMBOL_GPL(mlx4_counter_free);
+
 static int mlx4_setup_hca(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -912,6 +983,12 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 		goto err_qp_table_free;
 	}
 
+	err = mlx4_init_counters_table(dev);
+	if (err && err != -ENOENT) {
+		mlx4_err(dev, "Failed to initialize counters table, aborting.\n");
+		goto err_mcg_table_free;
+	}
+
 	for (port = 1; port <= dev->caps.num_ports; port++) {
 		ib_port_default_caps = 0;
 		err = mlx4_get_port_ib_caps(dev, port, &ib_port_default_caps);
@@ -924,12 +1001,15 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 		if (err) {
 			mlx4_err(dev, "Failed to set port %d, aborting\n",
 				port);
-			goto err_mcg_table_free;
+			goto err_counters_table_free;
 		}
 	}
 
 	return 0;
 
+err_counters_table_free:
+	mlx4_cleanup_counters_table(dev);
+
 err_mcg_table_free:
 	mlx4_cleanup_mcg_table(dev);
 
@@ -1184,6 +1264,7 @@ err_port:
 	for (--port; port >= 1; --port)
 		mlx4_cleanup_port_info(&priv->port[port]);
 
+	mlx4_cleanup_counters_table(dev);
 	mlx4_cleanup_mcg_table(dev);
 	mlx4_cleanup_qp_table(dev);
 	mlx4_cleanup_srq_table(dev);
@@ -1241,6 +1322,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 			mlx4_CLOSE_PORT(dev, p);
 		}
 
+		mlx4_cleanup_counters_table(dev);
 		mlx4_cleanup_mcg_table(dev);
 		mlx4_cleanup_qp_table(dev);
 		mlx4_cleanup_srq_table(dev);
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 0da5bb7..4aed9c1 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -303,6 +303,7 @@ struct mlx4_priv {
 	struct mlx4_srq_table	srq_table;
 	struct mlx4_qp_table	qp_table;
 	struct mlx4_mcg_table	mcg_table;
+	struct mlx4_bitmap	counters_bitmap;
 
 	struct mlx4_catas_err	catas_err;
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index de5971a..0992434 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -176,6 +176,12 @@ enum {
 	MLX4_MAX_FAST_REG_PAGES = 511,
 };
 
+enum {
+	MLX4_COUNTERS_DISABLED,
+	MLX4_COUNTERS_BASIC,
+	MLX4_COUNTERS_EXT
+};
+
 static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 {
 	return (major << 32) | (minor << 16) | subminor;
@@ -252,6 +258,9 @@ struct mlx4_caps {
 	u8			supported_type[MLX4_MAX_PORTS + 1];
 	u32			port_mask;
 	enum mlx4_port_type	possible_type[MLX4_MAX_PORTS + 1];
+	u8			counters_mode;
+	u32			max_basic_counters;
+	u32			max_ext_counters;
 };
 
 struct mlx4_buf_list {
@@ -521,4 +530,7 @@ int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 int mlx4_SYNC_TPT(struct mlx4_dev *dev);
 int mlx4_test_interrupts(struct mlx4_dev *dev);
 
+int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx);
+void mlx4_counter_free(struct mlx4_dev *dev, u32 idx);
+
 #endif /* MLX4_DEVICE_H */
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

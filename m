From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 6/9] mlx4: add network flow counters
Date: Wed, 15 Jun 2011 17:47:14 +0300
Message-ID: <alpine.LRH.2.00.1106151745060.15844@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151733410.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CX devices support set of flow counters that can be pointed by a set
containing one or more QPs. Each such counter tracks receive and
transmit packets and bytes of these QPs. This patch queries the
device to check support for counters, handles initialization of the
HCA to enable counters, and initializes a bitmap allocator to control
counter allocations. Derived from patch by Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/fw.c       |   12 ++++++++-
 drivers/net/mlx4/fw.h       |    1
 drivers/net/mlx4/main.c     |   57 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/mlx4/mlx4.h     |    1
 include/linux/mlx4/cmd.h    |    3 ++
 include/linux/mlx4/device.h |   18 +++++++++++++
 6 files changed, 90 insertions(+), 2 deletions(-)

Index: b/drivers/net/mlx4/fw.c
===================================================================
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -104,7 +104,8 @@ static void dump_dev_cap_flags(struct ml
 		[38] = "Wake On LAN support",
 		[40] = "UDP RSS support",
 		[41] = "Unicast VEP steering support",
-		[42] = "Multicast VEP steering support"
+		[42] = "Multicast VEP steering support",
+		[48] = "Counters support",
 	};
 	int i;

@@ -203,6 +204,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 #define QUERY_DEV_CAP_MAX_MCG_OFFSET		0x63
 #define QUERY_DEV_CAP_RSVD_PD_OFFSET		0x64
 #define QUERY_DEV_CAP_MAX_PD_OFFSET		0x65
+#define QUERY_DEV_CAP_MAX_COUNTERS_OFFSET	0x68
 #define QUERY_DEV_CAP_RDMARC_ENTRY_SZ_OFFSET	0x80
 #define QUERY_DEV_CAP_QPC_ENTRY_SZ_OFFSET	0x82
 #define QUERY_DEV_CAP_AUX_ENTRY_SZ_OFFSET	0x84
@@ -355,6 +357,9 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 		 QUERY_DEV_CAP_RSVD_LKEY_OFFSET);
 	MLX4_GET(dev_cap->max_icm_sz, outbox,
 		 QUERY_DEV_CAP_MAX_ICM_SZ_OFFSET);
+	if (dev_cap->flags & MLX4_DEV_CAP_FLAG_COUNTERS)
+		MLX4_GET(dev_cap->max_counters, outbox,
+			 QUERY_DEV_CAP_MAX_COUNTERS_OFFSET);

 	if (dev->flags & MLX4_FLAG_OLD_PORT_CMDS) {
 		for (i = 1; i <= dev_cap->num_ports; ++i) {
@@ -448,6 +453,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 	mlx4_dbg(dev, "Max RQ desc size: %d, max RQ S/G: %d\n",
 		 dev_cap->max_rq_desc_sz, dev_cap->max_rq_sg);
 	mlx4_dbg(dev, "Max GSO size: %d\n", dev_cap->max_gso_sz);
+	mlx4_dbg(dev, "Max counters: %d\n", dev_cap->max_counters);

 	dump_dev_cap_flags(dev, dev_cap->flags);

@@ -780,6 +786,10 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev,
 	if (enable_qos)
 		*(inbox + INIT_HCA_FLAGS_OFFSET / 4) |= cpu_to_be32(1 << 2);

+	/* enable counters */
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_COUNTERS)
+		*(inbox + INIT_HCA_FLAGS_OFFSET / 4) |= cpu_to_be32(1 << 4);
+
 	/* QPC/EEC/CQC/EQC/RDMARC attributes */

 	MLX4_PUT(inbox, param->qpc_base,      INIT_HCA_QPC_BASE_OFFSET);
Index: b/drivers/net/mlx4/fw.h
===================================================================
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -111,6 +111,7 @@ struct mlx4_dev_cap {
 	u8  supported_port_types[MLX4_MAX_PORTS + 1];
 	u8  log_max_macs[MLX4_MAX_PORTS + 1];
 	u8  log_max_vlans[MLX4_MAX_PORTS + 1];
+	u32 max_counters;
 };

 struct mlx4_adapter {
Index: b/drivers/net/mlx4/main.c
===================================================================
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -143,6 +143,7 @@ static void mlx4_set_port_mask(struct ml
 		if (dev->caps.port_type[i] == MLX4_PORT_TYPE_IB)
 			dev->caps.port_mask |= 1 << (i - 1);
 }
+
 static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 {
 	int err;
@@ -257,6 +258,8 @@ static int mlx4_dev_cap(struct mlx4_dev

 	mlx4_set_port_mask(dev);

+	dev->caps.max_counters = 1 << ilog2(dev_cap->max_counters);
+
 	dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FW] = dev_cap->reserved_qps;
 	dev->caps.reserved_qps_cnt[MLX4_QP_REGION_ETH_ADDR] =
 		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_ADDR] =
@@ -834,6 +837,48 @@ err_stop_fw:
 	return err;
 }

+static int mlx4_init_counters_table(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int nent, err;
+
+	if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_COUNTERS))
+		return -ENOENT;
+
+	nent = dev->caps.max_counters;
+	err = mlx4_bitmap_init(&priv->counters_bitmap, nent, nent - 1, 0, 0);
+	if (err)
+		return err;
+	return 0;
+}
+
+static void mlx4_cleanup_counters_table(struct mlx4_dev *dev)
+{
+	mlx4_bitmap_cleanup(&mlx4_priv(dev)->counters_bitmap);
+}
+
+int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_COUNTERS))
+		return -ENOENT;
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
+	return;
+}
+EXPORT_SYMBOL_GPL(mlx4_counter_free);
+
 static int mlx4_setup_hca(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -938,6 +983,13 @@ static int mlx4_setup_hca(struct mlx4_de
 		goto err_qp_table_free;
 	}

+	err = mlx4_init_counters_table(dev);
+	if (err && err != -ENOENT) {
+		mlx4_err(dev, "Failed to initialize "
+				"counters table, aborting.\n");
+		goto err_counters_table_free;
+	}
+
 	for (port = 1; port <= dev->caps.num_ports; port++) {
 		enum mlx4_port_type port_type = 0;
 		mlx4_SENSE_PORT(dev, port, &port_type);
@@ -964,6 +1016,9 @@ static int mlx4_setup_hca(struct mlx4_de
 err_mcg_table_free:
 	mlx4_cleanup_mcg_table(dev);

+err_counters_table_free:
+	mlx4_cleanup_counters_table(dev);
+
 err_qp_table_free:
 	mlx4_cleanup_qp_table(dev);

@@ -1294,6 +1349,7 @@ err_port:
 	for (--port; port >= 1; --port)
 		mlx4_cleanup_port_info(&priv->port[port]);

+	mlx4_cleanup_counters_table(dev);
 	mlx4_cleanup_mcg_table(dev);
 	mlx4_cleanup_qp_table(dev);
 	mlx4_cleanup_srq_table(dev);
@@ -1354,6 +1410,7 @@ static void mlx4_remove_one(struct pci_d
 			mlx4_CLOSE_PORT(dev, p);
 		}

+		mlx4_cleanup_counters_table(dev);
 		mlx4_cleanup_mcg_table(dev);
 		mlx4_cleanup_qp_table(dev);
 		mlx4_cleanup_srq_table(dev);
Index: b/drivers/net/mlx4/mlx4.h
===================================================================
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -342,6 +342,7 @@ struct mlx4_priv {
 	struct mlx4_srq_table	srq_table;
 	struct mlx4_qp_table	qp_table;
 	struct mlx4_mcg_table	mcg_table;
+	struct mlx4_bitmap	counters_bitmap;

 	struct mlx4_catas_err	catas_err;

Index: b/include/linux/mlx4/device.h
===================================================================
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -78,7 +78,8 @@ enum {
 	MLX4_DEV_CAP_FLAG_WOL		= 1LL << 38,
 	MLX4_DEV_CAP_FLAG_UDP_RSS	= 1LL << 40,
 	MLX4_DEV_CAP_FLAG_VEP_UC_STEER	= 1LL << 41,
-	MLX4_DEV_CAP_FLAG_VEP_MC_STEER	= 1LL << 42
+	MLX4_DEV_CAP_FLAG_VEP_MC_STEER	= 1LL << 42,
+	MLX4_DEV_CAP_FLAG_COUNTERS	= 1LL << 48
 };

 enum {
@@ -274,6 +275,7 @@ struct mlx4_caps {
 	u8			supported_type[MLX4_MAX_PORTS + 1];
 	u32			port_mask;
 	enum mlx4_port_type	possible_type[MLX4_MAX_PORTS + 1];
+	u32			max_counters;
 };

 struct mlx4_buf_list {
@@ -438,6 +440,17 @@ union mlx4_ext_av {
 	struct mlx4_eth_av	eth;
 };

+struct mlx4_counter {
+	u8	reserved1[3];
+	u8	counter_mode;
+	__be32	num_ifc;
+	u32	reserved2[2];
+	__be64	rx_frames;
+	__be64	rx_bytes;
+	__be64	tx_frames;
+	__be64	tx_bytes;
+};
+
 struct mlx4_dev {
 	struct pci_dev	       *pdev;
 	unsigned long		flags;
@@ -568,4 +581,7 @@ void mlx4_release_eq(struct mlx4_dev *de
 int mlx4_wol_read(struct mlx4_dev *dev, u64 *config, int port);
 int mlx4_wol_write(struct mlx4_dev *dev, u64 config, int port);

+int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx);
+void mlx4_counter_free(struct mlx4_dev *dev, u32 idx);
+
 #endif /* MLX4_DEVICE_H */
Index: b/include/linux/mlx4/cmd.h
===================================================================
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -123,6 +123,9 @@ enum {
 	/* debug commands */
 	MLX4_CMD_QUERY_DEBUG_MSG = 0x2a,
 	MLX4_CMD_SET_DEBUG_MSG	 = 0x2b,
+
+	/* statistics commands */
+	MLX4_CMD_QUERY_IF_STAT	 = 0X54,
 };

 enum {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

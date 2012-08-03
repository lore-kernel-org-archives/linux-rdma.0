From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V2 05/22] net/mlx4_core: Add proxy and tunnel QPs to the reserved QP area
Date: Fri,  3 Aug 2012 11:40:41 +0300
Message-ID: <1343983258-6268-6-git-send-email-jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In addition, pass the proxy and tunnel QP numbers to slaves so
the driver can perform sqp paravirtualization.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   14 +++++++++
 drivers/net/ethernet/mellanox/mlx4/fw.h            |    3 ++
 drivers/net/ethernet/mellanox/mlx4/main.c          |    5 +++
 drivers/net/ethernet/mellanox/mlx4/qp.c            |   29 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    3 +-
 include/linux/mlx4/device.h                        |   13 ++++++++-
 6 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index c696484..0f557df 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -184,6 +184,8 @@ int mlx4_QUERY_FUNC_CAP_wrapper(struct mlx4_dev *dev, int slave,
 #define QUERY_FUNC_CAP_MCG_QUOTA_OFFSET		0x28
 #define QUERY_FUNC_CAP_MAX_EQ_OFFSET		0x2c
 #define QUERY_FUNC_CAP_RESERVED_EQ_OFFSET	0X30
+#define QUERY_FUNC_CAP_BASE_TUNNEL_QPN_OFFSET	0X44
+#define QUERY_FUNC_CAP_BASE_PROXY_QPN_OFFSET	0X48
 
 #define QUERY_FUNC_CAP_FMR_FLAG			0x80
 #define QUERY_FUNC_CAP_FLAG_RDMA		0x40
@@ -247,6 +249,12 @@ int mlx4_QUERY_FUNC_CAP_wrapper(struct mlx4_dev *dev, int slave,
 		size = dev->caps.num_mgms + dev->caps.num_amgms;
 		MLX4_PUT(outbox->buf, size, QUERY_FUNC_CAP_MCG_QUOTA_OFFSET);
 
+		size = dev->caps.base_tunnel_sqpn + 8 * slave;
+		MLX4_PUT(outbox->buf, size, QUERY_FUNC_CAP_BASE_TUNNEL_QPN_OFFSET);
+
+		size = dev->caps.sqp_start + 8 * slave;
+		MLX4_PUT(outbox->buf, size, QUERY_FUNC_CAP_BASE_PROXY_QPN_OFFSET);
+
 	} else
 		err = -EINVAL;
 
@@ -312,6 +320,12 @@ int mlx4_QUERY_FUNC_CAP(struct mlx4_dev *dev, struct mlx4_func_cap *func_cap)
 	MLX4_GET(size, outbox, QUERY_FUNC_CAP_MCG_QUOTA_OFFSET);
 	func_cap->mcg_quota = size & 0xFFFFFF;
 
+	MLX4_GET(size, outbox, QUERY_FUNC_CAP_BASE_TUNNEL_QPN_OFFSET);
+	func_cap->base_tunnel_qpn = size & 0xFFFFFF;
+
+	MLX4_GET(size, outbox, QUERY_FUNC_CAP_BASE_PROXY_QPN_OFFSET);
+	func_cap->base_proxy_qpn = size & 0xFFFFFF;
+
 	for (i = 1; i <= func_cap->num_ports; ++i) {
 		err = mlx4_cmd_box(dev, 0, mailbox->dma, i, 1,
 				   MLX4_CMD_QUERY_FUNC_CAP,
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.h b/drivers/net/ethernet/mellanox/mlx4/fw.h
index 83fcbbf..ced1de5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -134,6 +134,9 @@ struct mlx4_func_cap {
 	int	max_eq;
 	int	reserved_eq;
 	int	mcg_quota;
+	u32	base_qpn;
+	u32	base_tunnel_qpn;
+	u32	base_proxy_qpn;
 	u8	physical_port[MLX4_MAX_PORTS + 1];
 	u8	port_flags[MLX4_MAX_PORTS + 1];
 };
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index e8f8ebb..892f2d6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -387,6 +387,7 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_ADDR] +
 		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_EXCH];
 
+	dev->caps.sqp_demux = (mlx4_is_master(dev)) ? MLX4_MAX_NUM_SLAVES : 0;
 	return 0;
 }
 /*The function checks if there are live vf, return the num of them*/
@@ -544,6 +545,10 @@ static int mlx4_slave_cap(struct mlx4_dev *dev)
 		return -ENODEV;
 	}
 
+	/* Calculate our sqp_start */
+	dev->caps.sqp_start = func_cap.base_proxy_qpn;
+	dev->caps.base_tunnel_sqpn = func_cap.base_tunnel_qpn;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index fb2b367..b8da72b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -406,7 +406,7 @@ int mlx4_init_qp_table(struct mlx4_dev *dev)
 	 * We also reserve the MSB of the 24-bit QP number to indicate
 	 * that a QP is an XRC QP.
 	 */
-	dev->caps.sqp_start =
+	dev->caps.base_sqpn =
 		ALIGN(dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FW], 8);
 
 	{
@@ -437,13 +437,36 @@ int mlx4_init_qp_table(struct mlx4_dev *dev)
 
 	}
 
+       /* Reserve 8 real SQPs in both native and SRIOV modes.
+	* In addition, in SRIOV mode, reserve 8 proxy SQPs per function
+	* (for all PFs and VFs), and 8 corresponding tunnel QPs.
+	* Each proxy SQP works opposite its own tunnel QP.
+	*
+	* The QPs are arranged as follows:
+	* a. 8 real SQPs
+	* b. All the proxy SQPs (8 per function)
+	* c. All the tunnel QPs (8 per function)
+	*/
+
 	err = mlx4_bitmap_init(&qp_table->bitmap, dev->caps.num_qps,
-			       (1 << 23) - 1, dev->caps.sqp_start + 8,
+			       (1 << 23) - 1, dev->caps.base_sqpn + 8 +
+			       16 * MLX4_MFUNC_MAX * !!mlx4_is_master(dev),
 			       reserved_from_top);
+
+	/* In mfunc, sqp_start is the base of the proxy SQPs, since the PF also
+	 * uses paravirtualized SQPs.
+	 * In native mode, sqp_start is the base of the real SQPs. */
+	if (mlx4_is_mfunc(dev)) {
+		dev->caps.sqp_start = dev->caps.base_sqpn +
+			8 * (mlx4_master_func_num(dev) + 1);
+		dev->caps.base_tunnel_sqpn = dev->caps.sqp_start + 8 * MLX4_MFUNC_MAX;
+	} else
+		dev->caps.sqp_start = dev->caps.base_sqpn;
+
 	if (err)
 		return err;
 
-	return mlx4_CONF_SPECIAL_QP(dev, dev->caps.sqp_start);
+	return mlx4_CONF_SPECIAL_QP(dev, dev->caps.base_sqpn);
 }
 
 void mlx4_cleanup_qp_table(struct mlx4_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 94ceddd..0f36ae9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -1104,7 +1104,8 @@ static void res_end_move(struct mlx4_dev *dev, int slave,
 
 static int valid_reserved(struct mlx4_dev *dev, int slave, int qpn)
 {
-	return mlx4_is_qp_reserved(dev, qpn);
+	return mlx4_is_qp_reserved(dev, qpn) &&
+		(mlx4_is_master(dev) || mlx4_is_guest_proxy(dev, slave, qpn));
 }
 
 static int qp_alloc_res(struct mlx4_dev *dev, int slave, int op, int cmd,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 6faab99..457503b 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -693,7 +693,18 @@ static inline int mlx4_is_master(struct mlx4_dev *dev)
 
 static inline int mlx4_is_qp_reserved(struct mlx4_dev *dev, u32 qpn)
 {
-	return (qpn < dev->caps.sqp_start + 8);
+	return (qpn < dev->caps.base_sqpn + 8 +
+		16 * MLX4_MFUNC_MAX * !!mlx4_is_master(dev));
+}
+
+static inline int mlx4_is_guest_proxy(struct mlx4_dev *dev, int slave, u32 qpn)
+{
+	int base = dev->caps.sqp_start + slave * 8;
+
+	if (qpn >= base && qpn < base + 8)
+		return 1;
+
+	return 0;
 }
 
 static inline int mlx4_is_mfunc(struct mlx4_dev *dev)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

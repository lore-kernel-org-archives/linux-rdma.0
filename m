From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [FIXES for-next 3/4] mlx4_core: Adjustments to Flow Steering activation logic for SRIOV
Date: Thu,  6 Dec 2012 19:11:59 +0200
Message-ID: <1354813920-27358-4-git-send-email-ogerlitz@mellanox.com>
References: <1354813920-27358-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354813920-27358-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Separate flow steering capability detection from the decision to activate.

For the master (and for native), detect flow steering  capability in
mlx4_dev_cap, but activate the appropriate steering type in a new function
choose_flow_steering() based on detected data.

For VFs, activate flow steering based on what was actually activated
by the master, where that info is obtained via QUERY_HCA. This fixes
the current VF detection which is wrongly based on QEURY_DEV_CAP.

Also, for SRIOV mode, if flow steering may be activated, do so only if the
max number of QPs per rule is sufficient to satisfy one subscription per VF.
If not, fall back to B0 mode. This is needed to serve registrations done by
L2 network drivers such as mlx4_en and IPoIB when the network stack attempts
to join to multicast groups such as all-hosts or the IPoIB broadcast group.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c   |   15 +++++-
 drivers/net/ethernet/mellanox/mlx4/fw.h   |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c |   71 ++++++++++++++++++++---------
 3 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 9a9de51..8b3d051 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1338,6 +1338,7 @@ int mlx4_QUERY_HCA(struct mlx4_dev *dev,
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	__be32 *outbox;
+	u32 dword_field;
 	int err;
 	u8 byte_field;
 
@@ -1372,10 +1373,18 @@ int mlx4_QUERY_HCA(struct mlx4_dev *dev,
 	MLX4_GET(param->rdmarc_base,   outbox, INIT_HCA_RDMARC_BASE_OFFSET);
 	MLX4_GET(param->log_rd_per_qp, outbox, INIT_HCA_LOG_RD_OFFSET);
 
+	MLX4_GET(dword_field, outbox, INIT_HCA_FLAGS_OFFSET);
+	if (dword_field & (1 << INIT_HCA_DEVICE_MANAGED_FLOW_STEERING_EN)) {
+		param->steering_mode = MLX4_STEERING_MODE_DEVICE_MANAGED;
+	} else {
+		MLX4_GET(byte_field, outbox, INIT_HCA_UC_STEERING_OFFSET);
+		if (byte_field & 0x8)
+			param->steering_mode = MLX4_STEERING_MODE_B0;
+		else
+			param->steering_mode = MLX4_STEERING_MODE_A0;
+	}
 	/* steering attributes */
-	if (dev->caps.steering_mode ==
-	    MLX4_STEERING_MODE_DEVICE_MANAGED) {
-
+	if (param->steering_mode == MLX4_STEERING_MODE_DEVICE_MANAGED) {
 		MLX4_GET(param->mc_base, outbox, INIT_HCA_FS_BASE_OFFSET);
 		MLX4_GET(param->log_mc_entry_sz, outbox,
 			 INIT_HCA_FS_LOG_ENTRY_SZ_OFFSET);
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.h b/drivers/net/ethernet/mellanox/mlx4/fw.h
index 2c2e7ad..dbf2f69 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -172,6 +172,7 @@ struct mlx4_init_hca_param {
 	u8  log_uar_sz;
 	u8  uar_page_sz; /* log pg sz in 4k chunks */
 	u8  fs_hash_enable_bits;
+	u8  steering_mode; /* for QUERY_HCA */
 	u64 dev_cap_enabled;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 4337f68..aedb3e3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -281,28 +281,6 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev->caps.max_gso_sz	     = dev_cap->max_gso_sz;
 	dev->caps.max_rss_tbl_sz     = dev_cap->max_rss_tbl_sz;
 
-	if (dev_cap->flags2 & MLX4_DEV_CAP_FLAG2_FS_EN) {
-		dev->caps.steering_mode = MLX4_STEERING_MODE_DEVICE_MANAGED;
-		dev->caps.num_qp_per_mgm = dev_cap->fs_max_num_qp_per_entry;
-		dev->caps.fs_log_max_ucast_qp_range_size =
-			dev_cap->fs_log_max_ucast_qp_range_size;
-	} else {
-		if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER &&
-		    dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER) {
-			dev->caps.steering_mode = MLX4_STEERING_MODE_B0;
-		} else {
-			dev->caps.steering_mode = MLX4_STEERING_MODE_A0;
-
-			if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER ||
-			    dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
-				mlx4_warn(dev, "Must have UC_STEER and MC_STEER flags "
-						"set to use B0 steering. Falling back to A0 steering mode.\n");
-		}
-		dev->caps.num_qp_per_mgm = mlx4_get_qp_per_mgm(dev);
-	}
-	mlx4_dbg(dev, "Steering mode is: %s\n",
-		 mlx4_steering_mode_str(dev->caps.steering_mode));
-
 	/* Sense port always allowed on supported devices for ConnectX-1 and -2 */
 	if (mlx4_priv(dev)->pci_dev_data & MLX4_PCI_DEV_FORCE_SENSE_PORT)
 		dev->caps.flags |= MLX4_DEV_CAP_FLAG_SENSE_SUPPORT;
@@ -493,6 +471,23 @@ int mlx4_is_slave_active(struct mlx4_dev *dev, int slave)
 }
 EXPORT_SYMBOL(mlx4_is_slave_active);
 
+static void slave_adjust_steering_mode(struct mlx4_dev *dev,
+				       struct mlx4_dev_cap *dev_cap,
+				       struct mlx4_init_hca_param *hca_param)
+{
+	dev->caps.steering_mode = hca_param->steering_mode;
+	if (dev->caps.steering_mode == MLX4_STEERING_MODE_DEVICE_MANAGED) {
+		dev->caps.num_qp_per_mgm = dev_cap->fs_max_num_qp_per_entry;
+		dev->caps.fs_log_max_ucast_qp_range_size =
+			dev_cap->fs_log_max_ucast_qp_range_size;
+	} else
+		dev->caps.num_qp_per_mgm =
+			4 * ((1 << hca_param->log_mc_entry_sz)/16 - 2);
+
+	mlx4_dbg(dev, "Steering mode is: %s\n",
+		 mlx4_steering_mode_str(dev->caps.steering_mode));
+}
+
 static int mlx4_slave_cap(struct mlx4_dev *dev)
 {
 	int			   err;
@@ -635,6 +630,8 @@ static int mlx4_slave_cap(struct mlx4_dev *dev)
 		dev->caps.cqe_size   = 32;
 	}
 
+	slave_adjust_steering_mode(dev, &dev_cap, &hca_param);
+
 	return 0;
 
 err_mem:
@@ -1321,6 +1318,34 @@ static void mlx4_parav_master_pf_caps(struct mlx4_dev *dev)
 	}
 }
 
+static void choose_steering_mode(struct mlx4_dev *dev,
+				 struct mlx4_dev_cap *dev_cap)
+{
+	if (dev_cap->flags2 & MLX4_DEV_CAP_FLAG2_FS_EN &&
+	    (!mlx4_is_mfunc(dev) ||
+	     (dev_cap->fs_max_num_qp_per_entry >= (num_vfs + 1)))) {
+		dev->caps.steering_mode = MLX4_STEERING_MODE_DEVICE_MANAGED;
+		dev->caps.num_qp_per_mgm = dev_cap->fs_max_num_qp_per_entry;
+		dev->caps.fs_log_max_ucast_qp_range_size =
+			dev_cap->fs_log_max_ucast_qp_range_size;
+	} else {
+		if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER &&
+		    dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
+			dev->caps.steering_mode = MLX4_STEERING_MODE_B0;
+		else {
+			dev->caps.steering_mode = MLX4_STEERING_MODE_A0;
+
+			if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER ||
+			    dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
+				mlx4_warn(dev, "Must have both UC_STEER and MC_STEER flags "
+					  "set to use B0 steering. Falling back to A0 steering mode.\n");
+		}
+		dev->caps.num_qp_per_mgm = mlx4_get_qp_per_mgm(dev);
+	}
+	mlx4_dbg(dev, "Steering mode is: %s\n",
+		 mlx4_steering_mode_str(dev->caps.steering_mode));
+}
+
 static int mlx4_init_hca(struct mlx4_dev *dev)
 {
 	struct mlx4_priv	  *priv = mlx4_priv(dev);
@@ -1360,6 +1385,8 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 			goto err_stop_fw;
 		}
 
+		choose_steering_mode(dev, &dev_cap);
+
 		if (mlx4_is_master(dev))
 			mlx4_parav_master_pf_caps(dev);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

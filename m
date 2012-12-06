From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [FIXES for-next 4/4] mlx4_core: Allow choosing flow steering mode
Date: Thu,  6 Dec 2012 19:12:00 +0200
Message-ID: <1354813920-27358-5-git-send-email-ogerlitz@mellanox.com>
References: <1354813920-27358-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354813920-27358-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Device managed flow steering will be enabled only under administrator
directive provided through setting the existing module parameter of
log_num_mgm_entry_size to -1 where the device actually supports that.
If flow steering isn't requested or not available, the driver will use
the value of log_num_mgm_entry_size and B0 steering.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   52 ++++++++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx4/mcg.c  |    7 +---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    6 ++-
 include/linux/mlx4/device.h               |    1 +
 4 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index aedb3e3..1846d00 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -85,15 +85,15 @@ static int probe_vf;
 module_param(probe_vf, int, 0644);
 MODULE_PARM_DESC(probe_vf, "number of vfs to probe by pf driver (num_vfs > 0)");
 
-int mlx4_log_num_mgm_entry_size = 10;
+int mlx4_log_num_mgm_entry_size = MLX4_DEFAULT_MGM_LOG_ENTRY_SIZE;
 module_param_named(log_num_mgm_entry_size,
 			mlx4_log_num_mgm_entry_size, int, 0444);
 MODULE_PARM_DESC(log_num_mgm_entry_size, "log mgm size, that defines the num"
 					 " of qp per mcg, for example:"
-					 " 10 gives 248.range: 9<="
+					 " 10 gives 248.range: 7 <="
 					 " log_num_mgm_entry_size <= 12."
-					 " Not in use with device managed"
-					 " flow steering");
+					 " To activate device managed"
+					 " flow steering when available, set to -1");
 
 static bool enable_64b_cqe_eqe;
 module_param(enable_64b_cqe_eqe, bool, 0444);
@@ -1318,12 +1318,30 @@ static void mlx4_parav_master_pf_caps(struct mlx4_dev *dev)
 	}
 }
 
+static int choose_log_fs_mgm_entry_size(int qp_per_entry)
+{
+	int i = MLX4_MIN_MGM_LOG_ENTRY_SIZE;
+
+	for (i = MLX4_MIN_MGM_LOG_ENTRY_SIZE; i <= MLX4_MAX_MGM_LOG_ENTRY_SIZE;
+	      i++) {
+		if (qp_per_entry <= 4 * ((1 << i) / 16 - 2))
+			break;
+	}
+
+	return (i <= MLX4_MAX_MGM_LOG_ENTRY_SIZE) ? i : -1;
+}
+
 static void choose_steering_mode(struct mlx4_dev *dev,
 				 struct mlx4_dev_cap *dev_cap)
 {
-	if (dev_cap->flags2 & MLX4_DEV_CAP_FLAG2_FS_EN &&
+	if (mlx4_log_num_mgm_entry_size == -1 &&
+	    dev_cap->flags2 & MLX4_DEV_CAP_FLAG2_FS_EN &&
 	    (!mlx4_is_mfunc(dev) ||
-	     (dev_cap->fs_max_num_qp_per_entry >= (num_vfs + 1)))) {
+	     (dev_cap->fs_max_num_qp_per_entry >= (num_vfs + 1))) &&
+	    choose_log_fs_mgm_entry_size(dev_cap->fs_max_num_qp_per_entry) >=
+		MLX4_MIN_MGM_LOG_ENTRY_SIZE) {
+		dev->oper_log_mgm_entry_size =
+			choose_log_fs_mgm_entry_size(dev_cap->fs_max_num_qp_per_entry);
 		dev->caps.steering_mode = MLX4_STEERING_MODE_DEVICE_MANAGED;
 		dev->caps.num_qp_per_mgm = dev_cap->fs_max_num_qp_per_entry;
 		dev->caps.fs_log_max_ucast_qp_range_size =
@@ -1340,10 +1358,17 @@ static void choose_steering_mode(struct mlx4_dev *dev,
 				mlx4_warn(dev, "Must have both UC_STEER and MC_STEER flags "
 					  "set to use B0 steering. Falling back to A0 steering mode.\n");
 		}
+		dev->oper_log_mgm_entry_size =
+			mlx4_log_num_mgm_entry_size > 0 ?
+			mlx4_log_num_mgm_entry_size :
+			MLX4_DEFAULT_MGM_LOG_ENTRY_SIZE;
 		dev->caps.num_qp_per_mgm = mlx4_get_qp_per_mgm(dev);
 	}
-	mlx4_dbg(dev, "Steering mode is: %s\n",
-		 mlx4_steering_mode_str(dev->caps.steering_mode));
+	mlx4_dbg(dev, "Steering mode is: %s, oper_log_mgm_entry_size = %d, "
+		 "modparam log_num_mgm_entry_size = %d\n",
+		 mlx4_steering_mode_str(dev->caps.steering_mode),
+		 dev->oper_log_mgm_entry_size,
+		 mlx4_log_num_mgm_entry_size);
 }
 
 static int mlx4_init_hca(struct mlx4_dev *dev)
@@ -2480,6 +2505,17 @@ static int __init mlx4_verify_params(void)
 		port_type_array[0] = true;
 	}
 
+	if (mlx4_log_num_mgm_entry_size != -1 &&
+	    (mlx4_log_num_mgm_entry_size < MLX4_MIN_MGM_LOG_ENTRY_SIZE ||
+	     mlx4_log_num_mgm_entry_size > MLX4_MAX_MGM_LOG_ENTRY_SIZE)) {
+		pr_warning("mlx4_core: mlx4_log_num_mgm_entry_size (%d) not "
+			   "in legal range (-1 or %d..%d)\n",
+			   mlx4_log_num_mgm_entry_size,
+			   MLX4_MIN_MGM_LOG_ENTRY_SIZE,
+			   MLX4_MAX_MGM_LOG_ENTRY_SIZE);
+		return -1;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index e151c21..1ee4db3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -54,12 +54,7 @@ struct mlx4_mgm {
 
 int mlx4_get_mgm_entry_size(struct mlx4_dev *dev)
 {
-	if (dev->caps.steering_mode ==
-	    MLX4_STEERING_MODE_DEVICE_MANAGED)
-		return 1 << MLX4_FS_MGM_LOG_ENTRY_SIZE;
-	else
-		return min((1 << mlx4_log_num_mgm_entry_size),
-			   MLX4_MAX_MGM_ENTRY_SIZE);
+	return 1 << dev->oper_log_mgm_entry_size;
 }
 
 int mlx4_get_qp_per_mgm(struct mlx4_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 1cf4203..116c5c2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -94,8 +94,10 @@ enum {
 };
 
 enum {
-	MLX4_MAX_MGM_ENTRY_SIZE = 0x1000,
-	MLX4_MAX_QP_PER_MGM	= 4 * (MLX4_MAX_MGM_ENTRY_SIZE / 16 - 2),
+	MLX4_DEFAULT_MGM_LOG_ENTRY_SIZE = 10,
+	MLX4_MIN_MGM_LOG_ENTRY_SIZE = 7,
+	MLX4_MAX_MGM_LOG_ENTRY_SIZE = 12,
+	MLX4_MAX_QP_PER_MGM = 4 * ((1 << MLX4_MAX_MGM_LOG_ENTRY_SIZE) / 16 - 2),
 	MLX4_MTT_ENTRY_PER_SEG	= 8,
 };
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 21821da..20ea939 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -625,6 +625,7 @@ struct mlx4_dev {
 	u8			rev_id;
 	char			board_id[MLX4_BOARD_ID_LEN];
 	int			num_vfs;
+	int			oper_log_mgm_entry_size;
 	u64			regid_promisc_array[MLX4_MAX_PORTS + 1];
 	u64			regid_allmulti_array[MLX4_MAX_PORTS + 1];
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

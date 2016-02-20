From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next 2/8] net/mlx5_core: Refactor device capability function
Date: Sat, 20 Feb 2016 09:47:39 +0200
Message-ID: <1455954465-15141-3-git-send-email-leon@leon.nu>
References: <1455954465-15141-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455954465-15141-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Device capability function was called similar in all places.
It was called twice for every queried parameter, while the
difference between calls was in HCA capability mode only.

The change proposed unify these calls into one function.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   | 55 ++++----------------------
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 28 +++++++------
 include/linux/mlx5/driver.h                    |  3 +-
 3 files changed, 24 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index aa1ab47..fe6dfd8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -98,88 +98,49 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 {
 	int err;
 
-	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL, HCA_CAP_OPMOD_GET_CUR);
-	if (err)
-		return err;
-
-	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL, HCA_CAP_OPMOD_GET_MAX);
+	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
 	if (err)
 		return err;
 
 	if (MLX5_CAP_GEN(dev, eth_net_offloads)) {
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ETHERNET_OFFLOADS,
-					 HCA_CAP_OPMOD_GET_CUR);
-		if (err)
-			return err;
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ETHERNET_OFFLOADS,
-					 HCA_CAP_OPMOD_GET_MAX);
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ETHERNET_OFFLOADS);
 		if (err)
 			return err;
 	}
 
 	if (MLX5_CAP_GEN(dev, pg)) {
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ODP,
-					 HCA_CAP_OPMOD_GET_CUR);
-		if (err)
-			return err;
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ODP,
-					 HCA_CAP_OPMOD_GET_MAX);
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ODP);
 		if (err)
 			return err;
 	}
 
 	if (MLX5_CAP_GEN(dev, atomic)) {
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ATOMIC,
-					 HCA_CAP_OPMOD_GET_CUR);
-		if (err)
-			return err;
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ATOMIC,
-					 HCA_CAP_OPMOD_GET_MAX);
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ATOMIC);
 		if (err)
 			return err;
 	}
 
 	if (MLX5_CAP_GEN(dev, roce)) {
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ROCE,
-					 HCA_CAP_OPMOD_GET_CUR);
-		if (err)
-			return err;
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ROCE,
-					 HCA_CAP_OPMOD_GET_MAX);
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ROCE);
 		if (err)
 			return err;
 	}
 
 	if (MLX5_CAP_GEN(dev, nic_flow_table)) {
-		err = mlx5_core_get_caps(dev, MLX5_CAP_FLOW_TABLE,
-					 HCA_CAP_OPMOD_GET_CUR);
-		if (err)
-			return err;
-		err = mlx5_core_get_caps(dev, MLX5_CAP_FLOW_TABLE,
-					 HCA_CAP_OPMOD_GET_MAX);
+		err = mlx5_core_get_caps(dev, MLX5_CAP_FLOW_TABLE);
 		if (err)
 			return err;
 	}
 
 	if (MLX5_CAP_GEN(dev, vport_group_manager) &&
 	    MLX5_CAP_GEN(dev, eswitch_flow_table)) {
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ESWITCH_FLOW_TABLE,
-					 HCA_CAP_OPMOD_GET_CUR);
-		if (err)
-			return err;
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ESWITCH_FLOW_TABLE,
-					 HCA_CAP_OPMOD_GET_MAX);
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ESWITCH_FLOW_TABLE);
 		if (err)
 			return err;
 	}
 
 	if (MLX5_CAP_GEN(dev, eswitch_flow_table)) {
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ESWITCH,
-					 HCA_CAP_OPMOD_GET_CUR);
-		if (err)
-			return err;
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ESWITCH,
-					 HCA_CAP_OPMOD_GET_MAX);
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ESWITCH);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index b86fe50..9397768 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -341,8 +341,9 @@ static u16 to_fw_pkey_sz(u32 size)
 	}
 }
 
-int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type,
-		       enum mlx5_cap_mode cap_mode)
+static int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev,
+				   enum mlx5_cap_type cap_type,
+				   enum mlx5_cap_mode cap_mode)
 {
 	u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)];
 	int out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
@@ -392,6 +393,16 @@ query_ex:
 	return err;
 }
 
+int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type)
+{
+	int ret;
+
+	ret = mlx5_core_get_caps_mode(dev, cap_type, HCA_CAP_OPMOD_GET_CUR);
+	if (ret)
+		return ret;
+	return mlx5_core_get_caps_mode(dev, cap_type, HCA_CAP_OPMOD_GET_MAX);
+}
+
 static int set_caps(struct mlx5_core_dev *dev, void *in, int in_sz, int opmod)
 {
 	u32 out[MLX5_ST_SZ_DW(set_hca_cap_out)];
@@ -419,12 +430,7 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
 	int err;
 
 	if (MLX5_CAP_GEN(dev, atomic)) {
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ATOMIC,
-					 HCA_CAP_OPMOD_GET_CUR);
-		if (err)
-			return err;
-		err = mlx5_core_get_caps(dev, MLX5_CAP_ATOMIC,
-					 HCA_CAP_OPMOD_GET_MAX);
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ATOMIC);
 		if (err)
 			return err;
 	} else {
@@ -466,11 +472,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 	if (!set_ctx)
 		goto query_ex;
 
-	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL, HCA_CAP_OPMOD_GET_MAX);
-	if (err)
-		goto query_ex;
-
-	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL, HCA_CAP_OPMOD_GET_CUR);
+	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
 	if (err)
 		goto query_ex;
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1e3006d..1f1d971 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -706,8 +706,7 @@ void mlx5_cmd_use_events(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_polling(struct mlx5_core_dev *dev);
 int mlx5_cmd_status_to_err(struct mlx5_outbox_hdr *hdr);
 int mlx5_cmd_status_to_err_v2(void *ptr);
-int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type,
-		       enum mlx5_cap_mode cap_mode);
+int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
 int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 		  int out_size);
 int mlx5_cmd_exec_cb(struct mlx5_core_dev *dev, void *in, int in_size,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

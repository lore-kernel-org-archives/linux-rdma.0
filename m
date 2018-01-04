From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 02/14] net/mlx5: Set software owner ID during init HCA
Date: Thu,  4 Jan 2018 17:25:32 +0200
Message-ID: <20180104152544.28919-3-leon@kernel.org>
References: <20180104152544.28919-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104152544.28919-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Generate a unique 128bit identifier for each host and pass that value to
firmware in the INIT_HCA command if it reports the sw_owner_id
capability. Each device bound to the mlx5_core driver will have the same
software owner ID.

In subsequent patches mlx5_core devices will be bound via a new VPort
command so that they can operate together under a single InfiniBand
device. Only devices that have the same software owner ID can be bound,
to prevent traffic intended for one host arriving at another.

The INIT_HCA command length was expanded by 128 bytes. The command
length is provided as an input FW commands. Older FW does not have a
problem receiving this command in the new longer form.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c        | 10 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c      |  6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  2 +-
 include/linux/mlx5/device.h                         |  5 +++++
 include/linux/mlx5/mlx5_ifc.h                       |  5 ++++-
 5 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 5ef1b56b6a96..9d11e92fb541 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -195,12 +195,20 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 	return 0;
 }
 
-int mlx5_cmd_init_hca(struct mlx5_core_dev *dev)
+int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id)
 {
 	u32 out[MLX5_ST_SZ_DW(init_hca_out)] = {0};
 	u32 in[MLX5_ST_SZ_DW(init_hca_in)]   = {0};
+	int i;
 
 	MLX5_SET(init_hca_in, in, opcode, MLX5_CMD_OP_INIT_HCA);
+
+	if (MLX5_CAP_GEN(dev, sw_owner_id)) {
+		for (i = 0; i < 4; i++)
+			MLX5_ARRAY_SET(init_hca_in, in, sw_owner_id, i,
+				       sw_owner_id[i]);
+	}
+
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 1292aecb09f2..e382a3ca759e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -75,6 +75,8 @@ static unsigned int prof_sel = MLX5_DEFAULT_PROF;
 module_param_named(prof_sel, prof_sel, uint, 0444);
 MODULE_PARM_DESC(prof_sel, "profile selector. Valid range 0 - 2");
 
+static u32 sw_owner_id[4];
+
 enum {
 	MLX5_ATOMIC_REQ_MODE_BE = 0x0,
 	MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS = 0x1,
@@ -1055,7 +1057,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto reclaim_boot_pages;
 	}
 
-	err = mlx5_cmd_init_hca(dev);
+	err = mlx5_cmd_init_hca(dev, sw_owner_id);
 	if (err) {
 		dev_err(&pdev->dev, "init hca failed\n");
 		goto err_pagealloc_stop;
@@ -1577,6 +1579,8 @@ static int __init init(void)
 {
 	int err;
 
+	get_random_bytes(&sw_owner_id, sizeof(sw_owner_id));
+
 	mlx5_core_verify_params();
 	mlx5_register_debugfs();
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index ff4a0b889a6f..b05868728da7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -86,7 +86,7 @@ enum {
 
 int mlx5_query_hca_caps(struct mlx5_core_dev *dev);
 int mlx5_query_board_id(struct mlx5_core_dev *dev);
-int mlx5_cmd_init_hca(struct mlx5_core_dev *dev);
+int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id);
 int mlx5_cmd_teardown_hca(struct mlx5_core_dev *dev);
 int mlx5_cmd_force_teardown_hca(struct mlx5_core_dev *dev);
 void mlx5_core_event(struct mlx5_core_dev *dev, enum mlx5_dev_event event,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 9aee835b7393..e5258ee4e38b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -79,6 +79,11 @@
 		     << __mlx5_dw_bit_off(typ, fld))); \
 } while (0)
 
+#define MLX5_ARRAY_SET(typ, p, fld, idx, v) do { \
+	BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 32); \
+	MLX5_SET(typ, p, fld[idx], v); \
+} while (0)
+
 #define MLX5_SET_TO_ONES(typ, p, fld) do { \
 	BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);             \
 	*((__be32 *)(p) + __mlx5_dw_off(typ, fld)) = \
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 38a7577a9ce7..b1c81d7a86cb 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1066,7 +1066,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_5f8[0x3];
 	u8         log_max_xrq[0x5];
 
-	u8         reserved_at_600[0x200];
+	u8         reserved_at_600[0x1e];
+	u8	   sw_owner_id;
+	u8	   reserved_at_61f[0x1e1];
 };
 
 enum mlx5_flow_destination_type {
@@ -5531,6 +5533,7 @@ struct mlx5_ifc_init_hca_in_bits {
 	u8         op_mod[0x10];
 
 	u8         reserved_at_40[0x40];
+	u8	   sw_owner_id[4][0x20];
 };
 
 struct mlx5_ifc_init2rtr_qp_out_bits {
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

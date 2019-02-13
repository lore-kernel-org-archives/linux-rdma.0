From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 06/15] net/mlx5: Add query host params command
Date: Tue, 12 Feb 2019 22:55:37 -0800
Message-ID: <20190213065546.3013-7-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Bodong Wang <bodong@mellanox.com>, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

The QUERY_HOST_PARAMS command is used by an Embedded CPU Physical
Function (ECPF) driver to identify and retrieve information about the
PF on the host side. E.g, number of virtual functions and PCI BDF.

The number of VFs can be changed on the fly, a function is added to
query current number of VFs and will be used in downstream patches.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  2 +
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    | 27 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/ecpf.h    |  4 ++
 include/linux/mlx5/mlx5_ifc.h                 | 41 +++++++++++++++++++
 4 files changed, 74 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index a25a8c6f938e..46d70eb2d2f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -316,6 +316,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_DESTROY_GENERAL_OBJECT:
 	case MLX5_CMD_OP_DEALLOC_MEMIC:
 	case MLX5_CMD_OP_PAGE_FAULT_RESUME:
+	case MLX5_CMD_OP_QUERY_HOST_PARAMS:
 		return MLX5_CMD_STAT_OK;
 
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -627,6 +628,7 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(QUERY_MODIFY_HEADER_CONTEXT);
 	MLX5_COMMAND_STR_CASE(ALLOC_MEMIC);
 	MLX5_COMMAND_STR_CASE(DEALLOC_MEMIC);
+	MLX5_COMMAND_STR_CASE(QUERY_HOST_PARAMS);
 	default: return "unknown command opcode";
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index 1bcf8b8f9713..4746f2d28fb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -83,3 +83,30 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 
 	mlx5_peer_pf_cleanup(dev);
 }
+
+static int mlx5_query_host_params_context(struct mlx5_core_dev *dev,
+					  u32 *out, int outlen)
+{
+	u32 in[MLX5_ST_SZ_DW(query_host_params_in)] = {};
+
+	MLX5_SET(query_host_params_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_HOST_PARAMS);
+
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+}
+
+int mlx5_query_host_params_num_vfs(struct mlx5_core_dev *dev, int *num_vf)
+{
+	u32 out[MLX5_ST_SZ_DW(query_host_params_out)] = {};
+	int err;
+
+	err = mlx5_query_host_params_context(dev, out, sizeof(out));
+	if (err)
+		return err;
+
+	*num_vf = MLX5_GET(query_host_params_out, out,
+			   host_params_context.host_num_of_vfs);
+	mlx5_core_dbg(dev, "host_num_of_vfs %d\n", *num_vf);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
index d3d7a00a02ac..346372df218f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
@@ -16,6 +16,7 @@ enum {
 bool mlx5_read_embedded_cpu(struct mlx5_core_dev *dev);
 int mlx5_ec_init(struct mlx5_core_dev *dev);
 void mlx5_ec_cleanup(struct mlx5_core_dev *dev);
+int mlx5_query_host_params_num_vfs(struct mlx5_core_dev *dev, int *num_vf);
 
 #else  /* CONFIG_MLX5_ESWITCH */
 
@@ -23,6 +24,9 @@ static inline bool
 mlx5_read_embedded_cpu(struct mlx5_core_dev *dev) { return false; }
 static inline int mlx5_ec_init(struct mlx5_core_dev *dev) { return 0; }
 static inline void mlx5_ec_cleanup(struct mlx5_core_dev *dev) {}
+static inline int
+mlx5_query_host_params_num_vfs(struct mlx5_core_dev *dev, int *num_vf)
+{ return -EOPNOTSUPP; }
 
 #endif /* CONFIG_MLX5_ESWITCH */
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1b6d5a563a3a..565046830559 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -142,6 +142,7 @@ enum {
 	MLX5_CMD_OP_QUERY_XRQ_DC_PARAMS_ENTRY     = 0x725,
 	MLX5_CMD_OP_SET_XRQ_DC_PARAMS_ENTRY       = 0x726,
 	MLX5_CMD_OP_QUERY_XRQ_ERROR_PARAMS        = 0x727,
+	MLX5_CMD_OP_QUERY_HOST_PARAMS             = 0x740,
 	MLX5_CMD_OP_QUERY_VPORT_STATE             = 0x750,
 	MLX5_CMD_OP_MODIFY_VPORT_STATE            = 0x751,
 	MLX5_CMD_OP_QUERY_ESW_VPORT_CONTEXT       = 0x752,
@@ -9522,4 +9523,44 @@ struct mlx5_ifc_mtrc_ctrl_bits {
 	u8         reserved_at_80[0x180];
 };
 
+struct mlx5_ifc_host_params_context_bits {
+	u8         host_number[0x8];
+	u8         reserved_at_8[0x8];
+	u8         host_num_of_vfs[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         host_pci_bus[0x10];
+
+	u8         reserved_at_40[0x10];
+	u8         host_pci_device[0x10];
+
+	u8         reserved_at_60[0x10];
+	u8         host_pci_function[0x10];
+
+	u8         reserved_at_80[0x180];
+};
+
+struct mlx5_ifc_query_host_params_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_at_10[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x40];
+};
+
+struct mlx5_ifc_query_host_params_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+
+	struct mlx5_ifc_host_params_context_bits host_params_context;
+
+	u8         reserved_at_280[0x180];
+};
+
 #endif /* MLX5_IFC_H */
-- 
2.20.1

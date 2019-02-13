From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 05/15] net/mlx5: Update enable HCA dependency
Date: Tue, 12 Feb 2019 22:55:36 -0800
Message-ID: <20190213065546.3013-6-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Bodong Wang <bodong@mellanox.com>, Eli Cohen <eli@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

With the introduction of ECPF, we require that the ECPF driver will
aways call enable/disable HCA for that PF in the same way a PF does
this for its VFs. The PF is still responsible for calling enable and
disable HCA for its VFs.

To distinguish between the ECPF executing enable/disable HCA for
itself or for the PF, it sets the embedded CPU function bit in the
input params struct of these commands. When the bit is cleared and
function ID is zero, it refers to the peer PF.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    | 76 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/ecpf.h    |  4 +
 .../net/ethernet/mellanox/mlx5/core/main.c    | 14 ++++
 include/linux/mlx5/mlx5_ifc.h                 |  6 +-
 4 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index 28b8c5c5c8c7..1bcf8b8f9713 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -7,3 +7,79 @@ bool mlx5_read_embedded_cpu(struct mlx5_core_dev *dev)
 {
 	return (ioread32be(&dev->iseg->initializing) >> MLX5_ECPU_BIT_NUM) & 1;
 }
+
+static int mlx5_peer_pf_enable_hca(struct mlx5_core_dev *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(enable_hca_in)]   = {};
+
+	MLX5_SET(enable_hca_in, in, opcode, MLX5_CMD_OP_ENABLE_HCA);
+	MLX5_SET(enable_hca_in, in, function_id, 0);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function, 0);
+	return mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+}
+
+static int mlx5_peer_pf_disable_hca(struct mlx5_core_dev *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(disable_hca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(disable_hca_in)]   = {};
+
+	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
+	MLX5_SET(disable_hca_in, in, function_id, 0);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function, 0);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+static int mlx5_peer_pf_init(struct mlx5_core_dev *dev)
+{
+	int err;
+
+	err = mlx5_peer_pf_enable_hca(dev);
+	if (err)
+		mlx5_core_err(dev, "Failed to enable peer PF HCA err(%d)\n",
+			      err);
+
+	return err;
+}
+
+static void mlx5_peer_pf_cleanup(struct mlx5_core_dev *dev)
+{
+	int err;
+
+	err = mlx5_peer_pf_disable_hca(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to disable peer PF HCA err(%d)\n",
+			      err);
+		return;
+	}
+
+	err = mlx5_wait_for_pages(dev, &dev->priv.peer_pf_pages);
+	if (err)
+		mlx5_core_warn(dev, "Timeout reclaiming peer PF pages err(%d)\n",
+			       err);
+}
+
+int mlx5_ec_init(struct mlx5_core_dev *dev)
+{
+	int err = 0;
+
+	if (!mlx5_core_is_ecpf(dev))
+		return 0;
+
+	/* ECPF shall enable HCA for peer PF in the same way a PF
+	 * does this for its VFs.
+	 */
+	err = mlx5_peer_pf_init(dev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
+{
+	if (!mlx5_core_is_ecpf(dev))
+		return;
+
+	mlx5_peer_pf_cleanup(dev);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
index 8b684f0ab48f..d3d7a00a02ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
@@ -14,11 +14,15 @@ enum {
 };
 
 bool mlx5_read_embedded_cpu(struct mlx5_core_dev *dev);
+int mlx5_ec_init(struct mlx5_core_dev *dev);
+void mlx5_ec_cleanup(struct mlx5_core_dev *dev);
 
 #else  /* CONFIG_MLX5_ESWITCH */
 
 static inline bool
 mlx5_read_embedded_cpu(struct mlx5_core_dev *dev) { return false; }
+static inline int mlx5_ec_init(struct mlx5_core_dev *dev) { return 0; }
+static inline void mlx5_ec_cleanup(struct mlx5_core_dev *dev) {}
 
 #endif /* CONFIG_MLX5_ESWITCH */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index bf810fd91454..772dc460cfe6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -615,6 +615,8 @@ int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id)
 
 	MLX5_SET(enable_hca_in, in, opcode, MLX5_CMD_OP_ENABLE_HCA);
 	MLX5_SET(enable_hca_in, in, function_id, func_id);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function,
+		 dev->caps.embedded_cpu);
 	return mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
 }
 
@@ -625,6 +627,8 @@ int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id)
 
 	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
 	MLX5_SET(disable_hca_in, in, function_id, func_id);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function,
+		 dev->caps.embedded_cpu);
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
@@ -1074,6 +1078,12 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto err_sriov;
 	}
 
+	err = mlx5_ec_init(dev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to init embedded CPU\n");
+		goto err_ec;
+	}
+
 	if (mlx5_device_registered(dev)) {
 		mlx5_attach_device(dev);
 	} else {
@@ -1091,6 +1101,9 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	return 0;
 
 err_reg_dev:
+	mlx5_ec_cleanup(dev);
+
+err_ec:
 	mlx5_sriov_detach(dev);
 
 err_sriov:
@@ -1165,6 +1178,7 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	if (mlx5_device_registered(dev))
 		mlx5_detach_device(dev);
 
+	mlx5_ec_cleanup(dev);
 	mlx5_sriov_detach(dev);
 	mlx5_cleanup_fs(dev);
 	mlx5_accel_ipsec_cleanup(dev);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 46799b4c8859..1b6d5a563a3a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -6061,7 +6061,8 @@ struct mlx5_ifc_enable_hca_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x10];
+	u8         embedded_cpu_function[0x1];
+	u8         reserved_at_41[0xf];
 	u8         function_id[0x10];
 
 	u8         reserved_at_60[0x20];
@@ -6105,7 +6106,8 @@ struct mlx5_ifc_disable_hca_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x10];
+	u8         embedded_cpu_function[0x1];
+	u8         reserved_at_41[0xf];
 	u8         function_id[0x10];
 
 	u8         reserved_at_60[0x20];
-- 
2.20.1

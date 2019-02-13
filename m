From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 11/15] net/mlx5: E-Switch, Avoid magic numbers when initializing offloads mode
Date: Tue, 12 Feb 2019 22:55:42 -0800
Message-ID: <20190213065546.3013-12-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Bodong Wang <bodong@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

When dealing with the offloads mode initialization, driver refers to
the number of VFs and add magic number one (1) to take account of the
uplink. This is not clear and will make the code less readable after
adding other vports (e.g. host PF). As these are special vports
compared to VF vports, add a helper macro to denote such special
vports and eliminate the use of magic number.

Moreover, when creating offloads flow table and groups, the driver
reserves two more slots for UC and MC miss rules. Replace this magic
number with a helper macro as well.

This patch doesn't change any functionality.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 25 +++++++++++--------
 include/linux/mlx5/vport.h                    |  4 ++-
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 0db56b4b7009..49a9e3877d2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1638,7 +1638,7 @@ int mlx5_eswitch_enable_sriov(struct mlx5_eswitch *esw, int nvfs, int mode)
 	} else {
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
-		err = esw_offloads_init(esw, nvfs + 1);
+		err = esw_offloads_init(esw, nvfs + MLX5_SPECIAL_VPORTS);
 	}
 
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b0b1267eab07..1496e82b5108 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -46,6 +46,11 @@ enum {
 	FDB_SLOW_PATH
 };
 
+/* There are two match-all miss flows, one for unicast dst mac and
+ * one for multicast.
+ */
+#define MLX5_ESW_MISS_FLOWS (2)
+
 #define fdb_prio_table(esw, chain, prio, level) \
 	(esw)->fdb_table.offloads.fdb_prio[(chain)][(prio)][(level)]
 
@@ -904,8 +909,8 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw, int nvports)
 		esw->fdb_table.offloads.fdb_left[i] =
 			ESW_POOLS[i] <= fdb_max ? ESW_SIZE / ESW_POOLS[i] : 0;
 
-	table_size = nvports * MAX_SQ_NVPORTS + MAX_PF_SQ + 2 +
-		esw->total_vports;
+	table_size = nvports * MAX_SQ_NVPORTS + MAX_PF_SQ +
+		MLX5_ESW_MISS_FLOWS + esw->total_vports;
 
 	/* create the slow path fdb with encap set, so further table instances
 	 * can be created at run time while VFs are probed if the FW allows that.
@@ -999,7 +1004,8 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw, int nvports)
 	dmac[0] = 0x01;
 
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ix + 2);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
+		 ix + MLX5_ESW_MISS_FLOWS);
 
 	g = mlx5_create_flow_group(fdb, flow_group_in);
 	if (IS_ERR(g)) {
@@ -1048,7 +1054,7 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	esw_destroy_offloads_fast_fdb_tables(esw);
 }
 
-static int esw_create_offloads_table(struct mlx5_eswitch *esw)
+static int esw_create_offloads_table(struct mlx5_eswitch *esw, int nvports)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_core_dev *dev = esw->dev;
@@ -1062,7 +1068,7 @@ static int esw_create_offloads_table(struct mlx5_eswitch *esw)
 		return -EOPNOTSUPP;
 	}
 
-	ft_attr.max_fte = dev->priv.sriov.num_vfs + 2;
+	ft_attr.max_fte = nvports + MLX5_ESW_MISS_FLOWS;
 
 	ft_offloads = mlx5_create_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft_offloads)) {
@@ -1082,16 +1088,15 @@ static void esw_destroy_offloads_table(struct mlx5_eswitch *esw)
 	mlx5_destroy_flow_table(offloads->ft_offloads);
 }
 
-static int esw_create_vport_rx_group(struct mlx5_eswitch *esw)
+static int esw_create_vport_rx_group(struct mlx5_eswitch *esw, int nvports)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *g;
-	struct mlx5_priv *priv = &esw->dev->priv;
 	u32 *flow_group_in;
 	void *match_criteria, *misc;
 	int err = 0;
-	int nvports = priv->sriov.num_vfs + 2;
 
+	nvports = nvports + MLX5_ESW_MISS_FLOWS;
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
 		return -ENOMEM;
@@ -1407,11 +1412,11 @@ int esw_offloads_init(struct mlx5_eswitch *esw, int nvports)
 	if (err)
 		return err;
 
-	err = esw_create_offloads_table(esw);
+	err = esw_create_offloads_table(esw, nvports);
 	if (err)
 		goto create_ft_err;
 
-	err = esw_create_vport_rx_group(esw);
+	err = esw_create_vport_rx_group(esw, nvports);
 	if (err)
 		goto create_fg_err;
 
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 28f47e868fbc..3bc05449ac39 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -36,7 +36,9 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/device.h>
 
-#define MLX5_TOTAL_VPORTS(mdev)	(1 + mlx5_core_max_vfs(mdev))
+#define MLX5_VPORT_PF_PLACEHOLDER (1u)
+#define MLX5_SPECIAL_VPORTS (MLX5_VPORT_PF_PLACEHOLDER)
+#define MLX5_TOTAL_VPORTS(mdev) (MLX5_SPECIAL_VPORTS +	mlx5_core_max_vfs(mdev))
 
 #define MLX5_VPORT_MANAGER(mdev)					\
 	(MLX5_CAP_GEN(mdev, vport_group_manager) &&			\
-- 
2.20.1

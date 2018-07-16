From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH mlx5-next 02/18] net/mlx5: Export modify header alloc/dealloc functions
Date: Mon, 16 Jul 2018 11:22:49 +0300
Message-ID: <20180716082305.11744-3-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Those function will be used by the RDMA side to create modify header
actions to be attached to flow steering rules via verbs.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c    | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 5 -----
 include/linux/mlx5/fs.h                             | 6 ++++++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 1be56e2eb1c1..31f71094db9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -695,6 +695,7 @@ int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
 	kfree(in);
 	return err;
 }
+EXPORT_SYMBOL(mlx5_modify_header_alloc);

 void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev, u32 modify_header_id)
 {
@@ -709,6 +710,7 @@ void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev, u32 modify_header_id)

 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
+EXPORT_SYMBOL(mlx5_modify_header_dealloc);

 static const struct mlx5_flow_cmds mlx5_flow_cmds = {
 	.create_flow_table = mlx5_cmd_create_flow_table,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 49955117ae36..b076ce14c48c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -177,11 +177,6 @@ int mlx5_encap_alloc(struct mlx5_core_dev *dev,
 		     u32 *encap_id);
 void mlx5_encap_dealloc(struct mlx5_core_dev *dev, u32 encap_id);

-int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
-			     u8 namespace, u8 num_actions,
-			     void *modify_actions, u32 *modify_header_id);
-void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev, u32 modify_header_id);
-
 bool mlx5_lag_intf_add(struct mlx5_interface *intf, struct mlx5_priv *priv);

 int mlx5_query_mtpps(struct mlx5_core_dev *dev, u32 *mtpps, u32 mtpps_size);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index a45febcf6b51..5371373230a7 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -194,4 +194,10 @@ int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
 int mlx5_fs_add_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);
 int mlx5_fs_remove_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);

+int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
+			     u8 namespace, u8 num_actions,
+			     void *modify_actions, u32 *modify_header_id);
+void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev,
+				u32 modify_header_id);
+
 #endif

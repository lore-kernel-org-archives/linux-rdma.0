From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 03/27] net/mlx5: Export modify header alloc/dealloc functions
Date: Sun, 29 Jul 2018 15:58:41 +0300
Message-ID: <20180729125905.31989-4-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Those functions will be used by the RDMA side to create modify header
actions to be attached to flow steering rules via verbs.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c    | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 5 -----
 include/linux/mlx5/fs.h                             | 6 ++++++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 28c7301e08f4..37bea30b68ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -702,6 +702,7 @@ int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
 	kfree(in);
 	return err;
 }
+EXPORT_SYMBOL(mlx5_modify_header_alloc);
 
 void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev, u32 modify_header_id)
 {
@@ -716,6 +717,7 @@ void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev, u32 modify_header_id)
 
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
index af0592400499..245f9e80ef92 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -196,4 +196,10 @@ int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
 int mlx5_fs_add_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);
 int mlx5_fs_remove_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);
 
+int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
+			     u8 namespace, u8 num_actions,
+			     void *modify_actions, u32 *modify_header_id);
+void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev,
+				u32 modify_header_id);
+
 #endif
-- 
2.14.4

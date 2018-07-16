From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH mlx5-next 09/18] net/mlx5: Export packet reformat alloc/dealloc functions
Date: Mon, 16 Jul 2018 11:22:56 +0300
Message-ID: <20180716082305.11744-10-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

This will allow for the RDMA side to allocate packet reformat context.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c    | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 7 -------
 include/linux/mlx5/fs.h                             | 9 +++++++++
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 41958bb10f69..5795ceaddf08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -644,6 +644,7 @@ int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
 	kfree(in);
 	return err;
 }
+EXPORT_SYMBOL(mlx5_packet_reformat_alloc);

 void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
 				  u32 packet_reformat_id)
@@ -659,6 +660,7 @@ void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,

 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
+EXPORT_SYMBOL(mlx5_packet_reformat_dealloc);

 int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
 			     u8 namespace, u8 num_actions,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index e16f6e6e03e1..4b1b505b20e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -170,13 +170,6 @@ struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev);
 void mlx5_dev_list_lock(void);
 void mlx5_dev_list_unlock(void);
 int mlx5_dev_list_trylock(void);
-int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
-			       int reformat_type,
-			       size_t size,
-			       void *reformat_data,
-			       u32 *packet_reformat_id);
-void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
-				  u32 packet_reformat_id);

 bool mlx5_lag_intf_add(struct mlx5_interface *intf, struct mlx5_priv *priv);

diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 6166df1eaeac..6d89e40efc9f 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -201,4 +201,13 @@ int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
 void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev,
 				u32 modify_header_id);

+int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
+			       int reformat_type,
+			       size_t size,
+			       void *reformat_data,
+			       int namespace,
+			       u32 *packet_reformat_id);
+void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
+				  u32 packet_reformat_id);
+
 #endif

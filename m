From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v3 03/14] net/mlx5: Export flow counter related API
Date: Thu, 31 May 2018 16:43:30 +0300
Message-ID: <20180531134341.18441-4-leon@kernel.org>
References: <20180531134341.18441-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531134341.18441-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Exports counters API to be used in both IB and EN.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h     | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 3 +++
 include/linux/mlx5/fs.h                               | 3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index d589dbbc72a7..32070e5d993d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -233,8 +233,6 @@ void mlx5_fc_queue_stats_work(struct mlx5_core_dev *dev,
 			      unsigned long delay);
 void mlx5_fc_update_sampling_interval(struct mlx5_core_dev *dev,
 				      unsigned long interval);
-int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
-		  u64 *packets, u64 *bytes);
 
 int mlx5_init_fs(struct mlx5_core_dev *dev);
 void mlx5_cleanup_fs(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index f5cb3fa5d8cf..58af6be13dfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -243,6 +243,7 @@ struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging)
 
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL(mlx5_fc_create);
 
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter)
 {
@@ -260,6 +261,7 @@ void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter)
 	mlx5_cmd_fc_free(dev, counter->id);
 	kfree(counter);
 }
+EXPORT_SYMBOL(mlx5_fc_destroy);
 
 int mlx5_init_fc_stats(struct mlx5_core_dev *dev)
 {
@@ -317,6 +319,7 @@ int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
 {
 	return mlx5_cmd_fc_query(dev, counter->id, packets, bytes);
 }
+EXPORT_SYMBOL(mlx5_fc_query);
 
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 9f4d32e41c06..3b4c3298061c 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -186,6 +186,9 @@ struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging);
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter);
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse);
+int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
+		  u64 *packets, u64 *bytes);
+
 int mlx5_fs_add_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);
 int mlx5_fs_remove_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);
 
-- 
2.14.3

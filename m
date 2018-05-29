From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v2 02/13] net/mlx5: Export flow counter related API
Date: Tue, 29 May 2018 16:09:06 +0300
Message-ID: <20180529130917.13592-3-leon@kernel.org>
References: <20180529130917.13592-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180529130917.13592-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Exports counters API to be used in both IB and EN.

Tested-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  | 23 ----------------------
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  3 +++
 include/linux/mlx5/fs.h                            | 22 +++++++++++++++++++++
 3 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index b6da322a8016..40992aed1791 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -131,29 +131,6 @@ struct mlx5_flow_table {
 	struct rhltable			fgs_hash;
 };

-struct mlx5_fc_cache {
-	u64 packets;
-	u64 bytes;
-	u64 lastuse;
-};
-
-struct mlx5_fc {
-	struct rb_node node;
-	struct list_head list;
-
-	/* last{packets,bytes} members are used when calculating the delta since
-	 * last reading
-	 */
-	u64 lastpackets;
-	u64 lastbytes;
-
-	u32 id;
-	bool deleted;
-	bool aging;
-
-	struct mlx5_fc_cache cache ____cacheline_aligned_in_smp;
-};
-
 struct mlx5_ft_underlay_qp {
 	struct list_head list;
 	u32 qpn;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index b7ab929d5f8e..10f407843e03 100644
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
@@ -317,6 +319,7 @@ int mlx5_fc_query(struct mlx5_core_dev *dev, u16 id,
 {
 	return mlx5_cmd_fc_query(dev, id, packets, bytes);
 }
+EXPORT_SYMBOL(mlx5_fc_query);

 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 9f4d32e41c06..93aab0f055b4 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -186,6 +186,28 @@ struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging);
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter);
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse);
+int mlx5_fc_query(struct mlx5_core_dev *dev, u16 id,
+		  u64 *packets, u64 *bytes);
+
+struct mlx5_fc_cache {
+	u64 packets;
+	u64 bytes;
+	u64 lastuse;
+};
+
+struct mlx5_fc {
+	struct rb_node node;
+	struct list_head list;
+
+	u64 lastpackets;
+	u64 lastbytes;
+
+	u32 id;
+	bool deleted;
+	bool aging;
+	struct mlx5_fc_cache cache ____cacheline_aligned_in_smp;
+};
+
 int mlx5_fs_add_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);
 int mlx5_fs_remove_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);

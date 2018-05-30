From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH rdma-next] net/mlx5: Use flow counter pointer as input to the query function
Date: Wed, 30 May 2018 09:35:12 +0300
Message-ID: <1527662112-14904-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, raeds@mellanox.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This allows to un-expose the details of struct mlx5_fc and keep
it internal to the core driver as it used to be.

Change-Id: I780cd74863fa2beccdd52e7d0cdd1e117a5aa353
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
---

Jason,

As you asked, I am sending a fixup in case you intend to apply
V2 of the flow counter series [1], if there's going to be V3,
Leon, please apply it from the begining.

Or.

[1] https://marc.info/?l=linux-netdev&m=152759937829994&w=2

 drivers/infiniband/hw/mlx5/main.c                  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 15 ++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  | 22 +++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  4 ++--
 include/linux/mlx5/fs.h                            | 24 ++++------------------
 5 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ac99125..4b09dcd 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3151,7 +3151,7 @@ static int read_flow_counters(struct ib_device *ibdev,
 	struct mlx5_fc *fc = read_attr->hw_cntrs_hndl;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 
-	return mlx5_fc_query(dev->mdev, fc->id,
+	return mlx5_fc_query(dev->mdev, fc,
 			     &read_attr->out[IB_COUNTER_PACKETS],
 			     &read_attr->out[IB_COUNTER_BYTES]);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6cab1dd..f63dfbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2104,21 +2104,18 @@ static int mlx5_eswitch_query_vport_drop_stats(struct mlx5_core_dev *dev,
 	struct mlx5_vport *vport = &esw->vports[vport_idx];
 	u64 rx_discard_vport_down, tx_discard_vport_down;
 	u64 bytes = 0;
-	u16 idx = 0;
 	int err = 0;
 
 	if (!vport->enabled || esw->mode != SRIOV_LEGACY)
 		return 0;
 
-	if (vport->egress.drop_counter) {
-		idx = vport->egress.drop_counter->id;
-		mlx5_fc_query(dev, idx, &stats->rx_dropped, &bytes);
-	}
+	if (vport->egress.drop_counter)
+		mlx5_fc_query(dev, vport->egress.drop_counter,
+			      &stats->rx_dropped, &bytes);
 
-	if (vport->ingress.drop_counter) {
-		idx = vport->ingress.drop_counter->id;
-		mlx5_fc_query(dev, idx, &stats->tx_dropped, &bytes);
-	}
+	if (vport->ingress.drop_counter)
+		mlx5_fc_query(dev, vport->ingress.drop_counter,
+			      &stats->tx_dropped, &bytes);
 
 	if (!MLX5_CAP_GEN(dev, receive_discard_vport_down) &&
 	    !MLX5_CAP_GEN(dev, transmit_discard_vport_down))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 40992ae..0211d77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -131,6 +131,25 @@ struct mlx5_flow_table {
 	struct rhltable			fgs_hash;
 };
 
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
 struct mlx5_ft_underlay_qp {
 	struct list_head list;
 	u32 qpn;
@@ -210,9 +229,6 @@ void mlx5_fc_queue_stats_work(struct mlx5_core_dev *dev,
 			      unsigned long delay);
 void mlx5_fc_update_sampling_interval(struct mlx5_core_dev *dev,
 				      unsigned long interval);
-int mlx5_fc_query(struct mlx5_core_dev *dev, u16 id,
-		  u64 *packets, u64 *bytes);
-
 int mlx5_init_fs(struct mlx5_core_dev *dev);
 void mlx5_cleanup_fs(struct mlx5_core_dev *dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 10f4078..58af6be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -314,10 +314,10 @@ void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
 	}
 }
 
-int mlx5_fc_query(struct mlx5_core_dev *dev, u16 id,
+int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
 		  u64 *packets, u64 *bytes)
 {
-	return mlx5_cmd_fc_query(dev, id, packets, bytes);
+	return mlx5_cmd_fc_query(dev, counter->id, packets, bytes);
 }
 EXPORT_SYMBOL(mlx5_fc_query);
 
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 4612e0a..ef2f3bf 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -185,30 +185,14 @@ int mlx5_modify_rule_destination(struct mlx5_flow_handle *handler,
 struct mlx5_fc *mlx5_flow_rule_counter(struct mlx5_flow_handle *handler);
 struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging);
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter);
+
+struct mlx5_fc *counter;
+
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse);
-int mlx5_fc_query(struct mlx5_core_dev *dev, u16 id,
+int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
 		  u64 *packets, u64 *bytes);
 
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
-	u64 lastpackets;
-	u64 lastbytes;
-
-	u32 id;
-	bool deleted;
-	bool aging;
-	struct mlx5_fc_cache cache ____cacheline_aligned_in_smp;
-};
-
 int mlx5_fs_add_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);
 int mlx5_fs_remove_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qpn);
 
-- 
2.3.7

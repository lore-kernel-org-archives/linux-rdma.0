From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 11/16] net/mlx5: Export flow counter related API
Date: Thu, 19 Oct 2017 17:41:53 +0300
Message-ID: <1508424118-27205-12-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Exports counters API to be used in both IB and EN.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |  2 --
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  | 23 ----------------------
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  3 +++
 include/linux/mlx5/fs.h                            | 22 +++++++++++++++++++++
 5 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 881e2e5..58b6f2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -424,6 +424,7 @@ int mlx5_cmd_fc_query(struct mlx5_core_dev *dev, u32 id,
 	*bytes = MLX5_GET64(traffic_counter, stats, octets);
 	return 0;
 }
+EXPORT_SYMBOL(mlx5_cmd_fc_query);
 
 struct mlx5_cmd_fc_bulk {
 	u32 id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
index 71e2d0f..d413760 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -76,8 +76,6 @@ int mlx5_cmd_update_root_ft(struct mlx5_core_dev *dev,
 
 int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *id);
 int mlx5_cmd_fc_free(struct mlx5_core_dev *dev, u32 id);
-int mlx5_cmd_fc_query(struct mlx5_core_dev *dev, u32 id,
-		      u64 *packets, u64 *bytes);
 
 struct mlx5_cmd_fc_bulk;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 80f6f3c7..2789a14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -128,29 +128,6 @@ struct mlx5_flow_table {
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
index 89d1f865..f679eb0 100644
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
@@ -326,6 +328,7 @@ void mlx5_fc_query_cached(struct mlx5_fc *counter,
 	counter->lastbytes = c.bytes;
 	counter->lastpackets = c.packets;
 }
+EXPORT_SYMBOL(mlx5_fc_query_cached);
 
 void mlx5_fc_queue_stats_work(struct mlx5_core_dev *dev,
 			      struct delayed_work *dwork,
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index b25e7ba..a4a715e 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -166,6 +166,28 @@ int mlx5_modify_rule_destination(struct mlx5_flow_handle *handler,
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter);
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse);
+int mlx5_cmd_fc_query(struct mlx5_core_dev *dev, u32 id,
+		      u64 *packets, u64 *bytes);
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
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

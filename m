From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 12/16] net/mlx5: Expand mlx5_fc_query_cached to return absolute counters values
Date: Thu, 19 Oct 2017 17:41:54 +0300
Message-ID: <1508424118-27205-13-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently mlx5_fc_query_cached returns counters values since last call,
expands it to work with query flags, passing MLX5_FLOW_QUERY_CACHED_ABS
flag will makes function to return counters absolute values.

This absolute mode will be used in downstream patches in this series.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |  6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 14 ++++++++++----
 include/linux/mlx5/fs.h                               |  8 +++++++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1aa2028..37b3049 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -465,7 +465,8 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
 		list_for_each_entry(flow, &e->flows, encap) {
 			if (flow->flags & MLX5E_TC_FLOW_OFFLOADED) {
 				counter = mlx5_flow_rule_counter(flow->rule);
-				mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
+				mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse,
+						     MLX5_FLOW_QUERY_CACHED_DIFF);
 				if (time_after((unsigned long)lastuse, nhe->reported_lastuse)) {
 					neigh_used = true;
 					break;
@@ -2133,7 +2134,8 @@ int mlx5e_stats_flower(struct mlx5e_priv *priv,
 	if (!counter)
 		return 0;
 
-	mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
+	mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse,
+			     MLX5_FLOW_QUERY_CACHED_DIFF);
 
 	tcf_exts_stats_update(f->exts, bytes, packets, lastuse);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index f679eb0..2a5b2f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -315,16 +315,22 @@ void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
 }
 
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
-			  u64 *bytes, u64 *packets, u64 *lastuse)
+			  u64 *bytes, u64 *packets, u64 *lastuse,
+			  enum mlx5_flow_query_cached_flags query_flags)
 {
 	struct mlx5_fc_cache c;
 
 	c = counter->cache;
 
-	*bytes = c.bytes - counter->lastbytes;
-	*packets = c.packets - counter->lastpackets;
-	*lastuse = c.lastuse;
+	if (query_flags == MLX5_FLOW_QUERY_CACHED_ABS) {
+		*bytes = c.bytes;
+		*packets = c.packets;
+	} else {
+		*bytes = c.bytes - counter->lastbytes;
+		*packets = c.packets - counter->lastpackets;
+	}
 
+	*lastuse = c.lastuse;
 	counter->lastbytes = c.bytes;
 	counter->lastpackets = c.packets;
 }
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index a4a715e..8e0331c 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -164,8 +164,14 @@ int mlx5_modify_rule_destination(struct mlx5_flow_handle *handler,
 struct mlx5_fc *mlx5_flow_rule_counter(struct mlx5_flow_handle *handler);
 struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging);
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter);
+
+enum mlx5_flow_query_cached_flags {
+	MLX5_FLOW_QUERY_CACHED_DIFF = 0,
+	MLX5_FLOW_QUERY_CACHED_ABS = 1,
+};
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
-			  u64 *bytes, u64 *packets, u64 *lastuse);
+			  u64 *bytes, u64 *packets, u64 *lastuse,
+			  enum mlx5_flow_query_cached_flags query_flags);
 int mlx5_cmd_fc_query(struct mlx5_core_dev *dev, u32 id,
 		      u64 *packets, u64 *bytes);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

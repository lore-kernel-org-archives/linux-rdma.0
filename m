From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: [PATCH] net/mlx5: Delete unneeded function argument
Date: Wed, 15 Aug 2018 16:54:33 +0300
Message-ID: <20180815135433.23834-1-yuval.shaia@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: saeedm@mellanox.com, leon@kernel.org, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Yuval Shaia <yuval.shaia@oracle.com>
List-Id: linux-rdma@vger.kernel.org

priv argument is not used by the function, delete it.

Fixes: a89842811ea98 ("net/mlx5e: Merge per priority stats groups")

Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 1646859974ce..4c4d779dafa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -813,7 +813,7 @@ static const struct counter_desc pport_per_prio_traffic_stats_desc[] = {
 
 #define NUM_PPORT_PER_PRIO_TRAFFIC_COUNTERS	ARRAY_SIZE(pport_per_prio_traffic_stats_desc)
 
-static int mlx5e_grp_per_prio_traffic_get_num_stats(struct mlx5e_priv *priv)
+static int mlx5e_grp_per_prio_traffic_get_num_stats(void)
 {
 	return NUM_PPORT_PER_PRIO_TRAFFIC_COUNTERS * NUM_PPORT_PRIO;
 }
@@ -971,7 +971,7 @@ static int mlx5e_grp_per_prio_pfc_fill_stats(struct mlx5e_priv *priv,
 
 static int mlx5e_grp_per_prio_get_num_stats(struct mlx5e_priv *priv)
 {
-	return mlx5e_grp_per_prio_traffic_get_num_stats(priv) +
+	return mlx5e_grp_per_prio_traffic_get_num_stats() +
 		mlx5e_grp_per_prio_pfc_get_num_stats(priv);
 }
 
-- 
2.17.1

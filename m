From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 15/15] net/mlx5e: Add HW vport counters to representor ethtool stats
Date: Thu, 17 May 2018 18:22:58 -0700
Message-ID: <20180518012258.26968-16-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Adi Nissim <adin@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

Currently the representor only report the SW (slow-path) traffic
counters.

Add packet/bytes reporting of the HW counters, which account for the
total amount of traffic that was handled by the vport, both slow and
fast (offloaded) paths. The newly exposed counters are named
vport_rx/tx_packets/bytes.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Adi Nissim <adin@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 35 +++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index aa32592a54cb..c3034f58aa33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -66,18 +66,36 @@ static const struct counter_desc sw_rep_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_bytes) },
 };
 
-#define NUM_VPORT_REP_COUNTERS	ARRAY_SIZE(sw_rep_stats_desc)
+struct vport_stats {
+	u64 vport_rx_packets;
+	u64 vport_tx_packets;
+	u64 vport_rx_bytes;
+	u64 vport_tx_bytes;
+};
+
+static const struct counter_desc vport_rep_stats_desc[] = {
+	{ MLX5E_DECLARE_STAT(struct vport_stats, vport_rx_packets) },
+	{ MLX5E_DECLARE_STAT(struct vport_stats, vport_rx_bytes) },
+	{ MLX5E_DECLARE_STAT(struct vport_stats, vport_tx_packets) },
+	{ MLX5E_DECLARE_STAT(struct vport_stats, vport_tx_bytes) },
+};
+
+#define NUM_VPORT_REP_SW_COUNTERS ARRAY_SIZE(sw_rep_stats_desc)
+#define NUM_VPORT_REP_HW_COUNTERS ARRAY_SIZE(vport_rep_stats_desc)
 
 static void mlx5e_rep_get_strings(struct net_device *dev,
 				  u32 stringset, uint8_t *data)
 {
-	int i;
+	int i, j;
 
 	switch (stringset) {
 	case ETH_SS_STATS:
-		for (i = 0; i < NUM_VPORT_REP_COUNTERS; i++)
+		for (i = 0; i < NUM_VPORT_REP_SW_COUNTERS; i++)
 			strcpy(data + (i * ETH_GSTRING_LEN),
 			       sw_rep_stats_desc[i].format);
+		for (j = 0; j < NUM_VPORT_REP_HW_COUNTERS; j++, i++)
+			strcpy(data + (i * ETH_GSTRING_LEN),
+			       vport_rep_stats_desc[j].format);
 		break;
 	}
 }
@@ -140,7 +158,7 @@ static void mlx5e_rep_get_ethtool_stats(struct net_device *dev,
 					struct ethtool_stats *stats, u64 *data)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	int i;
+	int i, j;
 
 	if (!data)
 		return;
@@ -148,18 +166,23 @@ static void mlx5e_rep_get_ethtool_stats(struct net_device *dev,
 	mutex_lock(&priv->state_lock);
 	if (test_bit(MLX5E_STATE_OPENED, &priv->state))
 		mlx5e_rep_update_sw_counters(priv);
+	mlx5e_rep_update_hw_counters(priv);
 	mutex_unlock(&priv->state_lock);
 
-	for (i = 0; i < NUM_VPORT_REP_COUNTERS; i++)
+	for (i = 0; i < NUM_VPORT_REP_SW_COUNTERS; i++)
 		data[i] = MLX5E_READ_CTR64_CPU(&priv->stats.sw,
 					       sw_rep_stats_desc, i);
+
+	for (j = 0; j < NUM_VPORT_REP_HW_COUNTERS; j++, i++)
+		data[i] = MLX5E_READ_CTR64_CPU(&priv->stats.vf_vport,
+					       vport_rep_stats_desc, j);
 }
 
 static int mlx5e_rep_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
 	case ETH_SS_STATS:
-		return NUM_VPORT_REP_COUNTERS;
+		return NUM_VPORT_REP_SW_COUNTERS + NUM_VPORT_REP_HW_COUNTERS;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.0

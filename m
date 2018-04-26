From: Qing Huang <qing.huang@oracle.com>
Subject: [PATCH] net/mlx5: report persistent netdev stats across ifdown/ifup commands
Date: Thu, 26 Apr 2018 13:37:37 -0700
Message-ID: <1524775057-8012-1-git-send-email-qing.huang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc: leon@kernel.org, matanb@mellanox.com, saeedm@mellanox.com, Qing Huang <qing.huang@oracle.com>
List-Id: linux-rdma@vger.kernel.org

Current stats collecting scheme in mlx5 driver is to periodically fetch
aggregated stats from all the active mlx5 software channels associated
with the device. However when a mlx5 interface is brought down(ifdown),
all the channels will be deactivated and closed. A new set of channels
will be created when next ifup command or a similar command is called.
Unfortunately the new channels will have all stats reset to 0. So you
lose the accumulated stats information. This behavior is different from
other netdev drivers including the mlx4 driver. In order to fix it, we
now save prior mlx5 software stats into netdev stats fields, so all the
accumulated stats will survive multiple runs of ifdown/ifup commands and
be shown correctly.

Orabug: 27548610

Signed-off-by: Qing Huang <qing.huang@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 30 +++++++++++++++++++----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f1fe490..5d50e69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2621,6 +2621,23 @@ static void mlx5e_netdev_set_tcs(struct net_device *netdev)
 		netdev_set_tc_queue(netdev, tc, nch, 0);
 }
 
+static void mlx5e_netdev_save_stats(struct mlx5e_priv *priv)
+{
+	struct net_device *netdev = priv->netdev;
+
+	netdev->stats.rx_packets += priv->stats.sw.rx_packets;
+	netdev->stats.rx_bytes   += priv->stats.sw.rx_bytes;
+	netdev->stats.tx_packets += priv->stats.sw.tx_packets;
+	netdev->stats.tx_bytes   += priv->stats.sw.tx_bytes;
+	netdev->stats.tx_dropped += priv->stats.sw.tx_queue_dropped;
+
+	priv->stats.sw.rx_packets	= 0;
+	priv->stats.sw.rx_bytes		= 0;
+	priv->stats.sw.tx_packets	= 0;
+	priv->stats.sw.tx_bytes		= 0;
+	priv->stats.sw.tx_queue_dropped = 0;
+}
+
 static void mlx5e_build_channels_tx_maps(struct mlx5e_priv *priv)
 {
 	struct mlx5e_channel *c;
@@ -2691,6 +2708,7 @@ void mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 		netif_set_real_num_tx_queues(netdev, new_num_txqs);
 
 	mlx5e_deactivate_priv_channels(priv);
+	mlx5e_netdev_save_stats(priv);
 	mlx5e_close_channels(&priv->channels);
 
 	priv->channels = *new_chs;
@@ -2770,6 +2788,7 @@ int mlx5e_close_locked(struct net_device *netdev)
 
 	netif_carrier_off(priv->netdev);
 	mlx5e_deactivate_priv_channels(priv);
+	mlx5e_netdev_save_stats(priv);
 	mlx5e_close_channels(&priv->channels);
 
 	return 0;
@@ -3215,11 +3234,12 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		stats->tx_packets = PPORT_802_3_GET(pstats, a_frames_transmitted_ok);
 		stats->tx_bytes   = PPORT_802_3_GET(pstats, a_octets_transmitted_ok);
 	} else {
-		stats->rx_packets = sstats->rx_packets;
-		stats->rx_bytes   = sstats->rx_bytes;
-		stats->tx_packets = sstats->tx_packets;
-		stats->tx_bytes   = sstats->tx_bytes;
-		stats->tx_dropped = sstats->tx_queue_dropped;
+		stats->rx_packets = sstats->rx_packets + dev->stats.rx_packets;
+		stats->rx_bytes   = sstats->rx_bytes + dev->stats.rx_bytes;
+		stats->tx_packets = sstats->tx_packets + dev->stats.tx_packets;
+		stats->tx_bytes   = sstats->tx_bytes + dev->stats.tx_bytes;
+		stats->tx_dropped = sstats->tx_queue_dropped +
+				    dev->stats.tx_dropped;
 	}
 
 	stats->rx_dropped = priv->stats.qcnt.rx_out_of_buffer;
-- 
1.8.3.1

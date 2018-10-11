From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 6/7] net/mlx5e: Use non-delayed work for update stats
Date: Wed, 10 Oct 2018 18:24:43 -0700
Message-ID: <20181011012444.28194-7-saeedm@mellanox.com>
References: <20181011012444.28194-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181011012444.28194-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Convert mlx5e update stats work to a normal work structure, since it is
never used delayed.

Add a helper function to queue update stats work on demand which checks
for some conditions and reduce code duplication to have a better
abstraction.

Fixes: ed56c5193ad8 ("net/mlx5e: Update NIC HW stats on demand only")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 24 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 +--
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f6dd0254d103..0fbdd7696ec4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -673,7 +673,7 @@ struct mlx5e_priv {
 	struct work_struct         update_carrier_work;
 	struct work_struct         set_rx_mode_work;
 	struct work_struct         tx_timeout_work;
-	struct delayed_work        update_stats_work;
+	struct work_struct         update_stats_work;
 
 	struct mlx5_core_dev      *mdev;
 	struct net_device         *netdev;
@@ -927,6 +927,7 @@ void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv);
 int mlx5e_close(struct net_device *netdev);
 int mlx5e_open(struct net_device *netdev);
 
+void mlx5e_queue_update_stats(struct mlx5e_priv *priv);
 int mlx5e_bits_invert(unsigned long a, int size);
 
 typedef int (*change_hw_mtu_cb)(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d5a7bd493240..f4b11bdae879 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -274,8 +274,7 @@ static void mlx5e_update_ndo_stats(struct mlx5e_priv *priv)
 
 static void mlx5e_update_stats_work(struct work_struct *work)
 {
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct mlx5e_priv *priv = container_of(dwork, struct mlx5e_priv,
+	struct mlx5e_priv *priv = container_of(work, struct mlx5e_priv,
 					       update_stats_work);
 
 	mutex_lock(&priv->state_lock);
@@ -283,6 +282,17 @@ static void mlx5e_update_stats_work(struct work_struct *work)
 	mutex_unlock(&priv->state_lock);
 }
 
+void mlx5e_queue_update_stats(struct mlx5e_priv *priv)
+{
+	if (!priv->profile->update_stats)
+		return;
+
+	if (unlikely(test_bit(MLX5E_STATE_DESTROYING, &priv->state)))
+		return;
+
+	queue_work(priv->wq, &priv->update_stats_work);
+}
+
 static void mlx5e_async_event(struct mlx5_core_dev *mdev, void *vpriv,
 			      enum mlx5_dev_event event, unsigned long param)
 {
@@ -2957,9 +2967,7 @@ int mlx5e_open_locked(struct net_device *netdev)
 	if (priv->profile->update_carrier)
 		priv->profile->update_carrier(priv);
 
-	if (priv->profile->update_stats)
-		queue_delayed_work(priv->wq, &priv->update_stats_work, 0);
-
+	mlx5e_queue_update_stats(priv);
 	return 0;
 
 err_clear_state_opened_flag:
@@ -3441,7 +3449,7 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	struct mlx5e_pport_stats *pstats = &priv->stats.pport;
 
 	/* update HW stats in background for next time */
-	queue_delayed_work(priv->wq, &priv->update_stats_work, 0);
+	mlx5e_queue_update_stats(priv);
 
 	if (mlx5e_is_uplink_rep(priv)) {
 		stats->rx_packets = PPORT_802_3_GET(pstats, a_frames_received_ok);
@@ -4946,7 +4954,7 @@ int mlx5e_netdev_init(struct net_device *netdev,
 	INIT_WORK(&priv->update_carrier_work, mlx5e_update_carrier_work);
 	INIT_WORK(&priv->set_rx_mode_work, mlx5e_set_rx_mode_work);
 	INIT_WORK(&priv->tx_timeout_work, mlx5e_tx_timeout_work);
-	INIT_DELAYED_WORK(&priv->update_stats_work, mlx5e_update_stats_work);
+	INIT_WORK(&priv->update_stats_work, mlx5e_update_stats_work);
 
 	priv->wq = create_singlethread_workqueue("mlx5e");
 	if (!priv->wq)
@@ -5037,7 +5045,7 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 
 	profile->cleanup_rx(priv);
 	profile->cleanup_tx(priv);
-	cancel_delayed_work_sync(&priv->update_stats_work);
+	cancel_work_sync(&priv->update_stats_work);
 }
 
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 1a3efa87f557..1846edb01fd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -992,8 +992,7 @@ mlx5e_rep_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
 	/* update HW stats in background for next time */
-	queue_delayed_work(priv->wq, &priv->update_stats_work, 0);
-
+	mlx5e_queue_update_stats(priv);
 	memcpy(stats, &priv->stats.vf_vport, sizeof(*stats));
 }
 
-- 
2.17.1

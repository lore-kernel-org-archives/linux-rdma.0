From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 4/7] net/mlx5e: Always initialize update stats delayed work
Date: Wed, 10 Oct 2018 18:24:41 -0700
Message-ID: <20181011012444.28194-5-saeedm@mellanox.com>
References: <20181011012444.28194-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181011012444.28194-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Feras Daoud <ferasda@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda@mellanox.com>

mlx5e_detach_netdev cancels update_stats work which was not initialized
in ipoib netdevice profile, as a result, the following assert occurs:

ODEBUG: assert_init not available (active state 0) object type:
timer_list hint:(null)

This change moves the update stats work to be initialized for all
mlx5e netdevices.

Fixes: cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks")
Signed-off-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4b2737c613fe..59d07a6fe7c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -926,7 +926,6 @@ int mlx5e_create_tises(struct mlx5e_priv *priv);
 void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv);
 int mlx5e_close(struct net_device *netdev);
 int mlx5e_open(struct net_device *netdev);
-void mlx5e_update_stats_work(struct work_struct *work);
 
 int mlx5e_bits_invert(unsigned long a, int size);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 376197c97e3b..9cf5863b7949 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -272,7 +272,7 @@ static void mlx5e_update_ndo_stats(struct mlx5e_priv *priv)
 			mlx5e_stats_grps[i].update_stats(priv);
 }
 
-void mlx5e_update_stats_work(struct work_struct *work)
+static void mlx5e_update_stats_work(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct mlx5e_priv *priv = container_of(dwork, struct mlx5e_priv,
@@ -4582,7 +4582,6 @@ static void mlx5e_build_nic_netdev_priv(struct mlx5_core_dev *mdev,
 	INIT_WORK(&priv->update_carrier_work, mlx5e_update_carrier_work);
 	INIT_WORK(&priv->set_rx_mode_work, mlx5e_set_rx_mode_work);
 	INIT_WORK(&priv->tx_timeout_work, mlx5e_tx_timeout_work);
-	INIT_DELAYED_WORK(&priv->update_stats_work, mlx5e_update_stats_work);
 
 	mlx5e_timestamp_init(priv);
 }
@@ -4955,6 +4954,8 @@ int mlx5e_netdev_init(struct net_device *netdev, struct mlx5e_priv *priv)
 {
 	netif_carrier_off(netdev);
 
+	INIT_DELAYED_WORK(&priv->update_stats_work, mlx5e_update_stats_work);
+
 	priv->wq = create_singlethread_workqueue("mlx5e");
 	if (!priv->wq)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6176e53c8b83..bd8caac2e572 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1095,8 +1095,6 @@ static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
 	if (err)
 		return err;
 
-	INIT_DELAYED_WORK(&priv->update_stats_work, mlx5e_update_stats_work);
-
 	mutex_init(&priv->state_lock);
 
 	priv->channels.params.num_channels = profile->max_nch(mdev);
-- 
2.17.1

From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 5/7] net/mlx5e: Initialize all netdev common structures in one place
Date: Wed, 10 Oct 2018 18:24:42 -0700
Message-ID: <20181011012444.28194-6-saeedm@mellanox.com>
References: <20181011012444.28194-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181011012444.28194-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Feras Daoud <ferasda@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Move all mlx5e generic structures initializations to mlx5e_netdev_init.
The common structure new initializer function will be used to initialize
mlx5 context for netlink created netdevs such as IPoIB mlx5 accelerated
child netdevs.

Fixes: cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Feras Daoud <ferasda@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 63 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  8 +--
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 10 +--
 4 files changed, 36 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 59d07a6fe7c5..f6dd0254d103 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -961,7 +961,11 @@ int mlx5e_ethtool_flash_device(struct mlx5e_priv *priv,
 			       struct ethtool_flash *flash);
 
 /* mlx5e generic netdev management API */
-int mlx5e_netdev_init(struct net_device *netdev, struct mlx5e_priv *priv);
+int mlx5e_netdev_init(struct net_device *netdev,
+		      struct mlx5e_priv *priv,
+		      struct mlx5_core_dev *mdev,
+		      const struct mlx5e_profile *profile,
+		      void *ppriv);
 void mlx5e_netdev_cleanup(struct net_device *netdev, struct mlx5e_priv *priv);
 struct net_device*
 mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 9cf5863b7949..d5a7bd493240 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4560,32 +4560,6 @@ void mlx5e_build_nic_params(struct mlx5_core_dev *mdev,
 	mlx5e_build_rss_params(params);
 }
 
-static void mlx5e_build_nic_netdev_priv(struct mlx5_core_dev *mdev,
-					struct net_device *netdev,
-					const struct mlx5e_profile *profile,
-					void *ppriv)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	priv->mdev        = mdev;
-	priv->netdev      = netdev;
-	priv->profile     = profile;
-	priv->ppriv       = ppriv;
-	priv->msglevel    = MLX5E_MSG_LEVEL;
-	priv->max_opened_tc = 1;
-
-	mlx5e_build_nic_params(mdev, &priv->channels.params,
-			       profile->max_nch(mdev), netdev->mtu);
-
-	mutex_init(&priv->state_lock);
-
-	INIT_WORK(&priv->update_carrier_work, mlx5e_update_carrier_work);
-	INIT_WORK(&priv->set_rx_mode_work, mlx5e_set_rx_mode_work);
-	INIT_WORK(&priv->tx_timeout_work, mlx5e_tx_timeout_work);
-
-	mlx5e_timestamp_init(priv);
-}
-
 static void mlx5e_set_netdev_dev_addr(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -4756,11 +4730,15 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	int err;
 
-	err = mlx5e_netdev_init(netdev, priv);
+	err = mlx5e_netdev_init(netdev, priv, mdev, profile, ppriv);
 	if (err)
 		return err;
 
-	mlx5e_build_nic_netdev_priv(mdev, netdev, profile, ppriv);
+	mlx5e_build_nic_params(mdev, &priv->channels.params,
+			       profile->max_nch(mdev), netdev->mtu);
+
+	mlx5e_timestamp_init(priv);
+
 	err = mlx5e_ipsec_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "IPSec initialization failed, %d\n", err);
@@ -4950,16 +4928,37 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 /* mlx5e generic netdev management API (move to en_common.c) */
 
 /* mlx5e_netdev_init/cleanup must be called from profile->init/cleanup callbacks */
-int mlx5e_netdev_init(struct net_device *netdev, struct mlx5e_priv *priv)
+int mlx5e_netdev_init(struct net_device *netdev,
+		      struct mlx5e_priv *priv,
+		      struct mlx5_core_dev *mdev,
+		      const struct mlx5e_profile *profile,
+		      void *ppriv)
 {
-	netif_carrier_off(netdev);
+	/* priv init */
+	priv->mdev        = mdev;
+	priv->netdev      = netdev;
+	priv->profile     = profile;
+	priv->ppriv       = ppriv;
+	priv->msglevel    = MLX5E_MSG_LEVEL;
+	priv->max_opened_tc = 1;
 
+	mutex_init(&priv->state_lock);
+	INIT_WORK(&priv->update_carrier_work, mlx5e_update_carrier_work);
+	INIT_WORK(&priv->set_rx_mode_work, mlx5e_set_rx_mode_work);
+	INIT_WORK(&priv->tx_timeout_work, mlx5e_tx_timeout_work);
 	INIT_DELAYED_WORK(&priv->update_stats_work, mlx5e_update_stats_work);
 
 	priv->wq = create_singlethread_workqueue("mlx5e");
 	if (!priv->wq)
 		return -ENOMEM;
 
+	/* netdev init */
+	netif_carrier_off(netdev);
+
+#ifdef CONFIG_MLX5_EN_ARFS
+	netdev->rx_cpu_rmap = mdev->rmap;
+#endif
+
 	return 0;
 }
 
@@ -4984,10 +4983,6 @@ struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
 		return NULL;
 	}
 
-#ifdef CONFIG_MLX5_EN_ARFS
-	netdev->rx_cpu_rmap = mdev->rmap;
-#endif
-
 	err = profile->init(mdev, netdev, profile, ppriv);
 	if (err) {
 		mlx5_core_err(mdev, "failed to init mlx5e profile %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index bd8caac2e572..1a3efa87f557 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1086,16 +1086,10 @@ static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	int err;
 
-	priv->mdev                         = mdev;
-	priv->netdev                       = netdev;
-	priv->profile                      = profile;
-	priv->ppriv                        = ppriv;
-
-	err = mlx5e_netdev_init(netdev, priv);
+	err = mlx5e_netdev_init(netdev, priv, mdev, profile, ppriv);
 	if (err)
 		return err;
 
-	mutex_init(&priv->state_lock);
 
 	priv->channels.params.num_channels = profile->max_nch(mdev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 3f544baab9c9..ed28602c98f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -80,15 +80,7 @@ int mlx5i_init(struct mlx5_core_dev *mdev,
 	u16 max_mtu;
 	int err;
 
-	/* priv init */
-	priv->mdev        = mdev;
-	priv->netdev      = netdev;
-	priv->profile     = profile;
-	priv->ppriv       = ppriv;
-	priv->max_opened_tc = 1;
-	mutex_init(&priv->state_lock);
-
-	err = mlx5e_netdev_init(netdev, priv);
+	err = mlx5e_netdev_init(netdev, priv, mdev, profile, ppriv);
 	if (err)
 		return err;
 
-- 
2.17.1

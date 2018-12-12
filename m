From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net/mlx5e: Remove set but not used variable 'upriv'
Date: Wed, 12 Dec 2018 08:33:53 +0000
Message-ID: <1544603633-170212-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>
Cc: YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: In function 'mlx5e_vport_rep_load':
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:1490:21: warning:
 variable 'upriv' set but not used [-Wunused-but-set-variable]

drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: In function 'mlx5e_vport_rep_unload':
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:1557:21: warning:
 variable 'upriv' set but not used [-Wunused-but-set-variable]

It not used any more since commit ef381359e3a8 ("net/mlx5e: Replace egdev with
indirect block notifications"). Also remove unused variable 'uplink_rpriv'
after this change.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 85e51bd..e5230049 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1484,10 +1484,8 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 static int
 mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct mlx5e_rep_priv *rpriv;
 	struct net_device *netdev;
-	struct mlx5e_priv *upriv;
 	int nch, err;
 
 	rpriv = kzalloc(sizeof(*rpriv), GFP_KERNEL);
@@ -1522,9 +1520,6 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 		goto err_detach_netdev;
 	}
 
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(dev->priv.eswitch, REP_ETH);
-	upriv = netdev_priv(uplink_rpriv->netdev);
-
 	err = register_netdev(netdev);
 	if (err) {
 		pr_warn("Failed to register representor netdev for vport %d\n",
@@ -1552,14 +1547,9 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
 	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_rep_priv *uplink_rpriv;
 	void *ppriv = priv->ppriv;
-	struct mlx5e_priv *upriv;
 
 	unregister_netdev(netdev);
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(priv->mdev->priv.eswitch,
-						    REP_ETH);
-	upriv = netdev_priv(uplink_rpriv->netdev);
 	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_detach_netdev(priv);
 	mlx5e_destroy_netdev(priv);

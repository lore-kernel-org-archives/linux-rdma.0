From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2] net/mlx4_en: Fix an error handling path in 'mlx4_en_init_netdev()'
Date: Thu, 10 May 2018 09:06:04 +0200
Message-ID: <20180510070604.19635-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, tariqt@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

If an error occurs, 'mlx4_en_destroy_netdev()' is called.
It then calls 'mlx4_en_free_resources()' which does the needed resources
cleanup.

So, doing some explicit kfree in the error handling path would lead to
some double kfree.

Simplify code to avoid such a case.

Fixes: 67f8b1dcb9ee ("net/mlx4_en: Refactor the XDP forwarding rings scheme")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v1 -> v2 : rewrite the fix as explained by Tariq Toukan
           (this 2nd version may have been posted twice, once without the
           v2 tag. PLease ignore the first one)
---

 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index e0adac4a9a19..9670b33fc9b1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3324,12 +3324,11 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 					   MAX_TX_RINGS, GFP_KERNEL);
 		if (!priv->tx_ring[t]) {
 			err = -ENOMEM;
-			goto err_free_tx;
+			goto out;
 		}
 		priv->tx_cq[t] = kzalloc(sizeof(struct mlx4_en_cq *) *
 					 MAX_TX_RINGS, GFP_KERNEL);
 		if (!priv->tx_cq[t]) {
-			kfree(priv->tx_ring[t]);
 			err = -ENOMEM;
 			goto out;
 		}
@@ -3582,11 +3581,6 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 
 	return 0;
 
-err_free_tx:
-	while (t--) {
-		kfree(priv->tx_ring[t]);
-		kfree(priv->tx_cq[t]);
-	}
 out:
 	mlx4_en_destroy_netdev(dev);
 	return err;
-- 
2.17.0

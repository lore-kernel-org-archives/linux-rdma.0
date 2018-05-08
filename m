From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/mlx4_en: Fix an error handling path in 'mlx4_en_init_netdev()'
Date: Tue,  8 May 2018 11:34:26 +0200
Message-ID: <20180508093426.11550-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, tariqt@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

If the 2nd memory allocation of the loop fails, we must undo the
memory allocation done so far.

Fixes: 67f8b1dcb9ee ("net/mlx4_en: Refactor the XDP forwarding rings scheme")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index e0adac4a9a19..bf078244e467 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3331,7 +3331,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		if (!priv->tx_cq[t]) {
 			kfree(priv->tx_ring[t]);
 			err = -ENOMEM;
-			goto out;
+			goto err_free_tx;
 		}
 	}
 	priv->rx_ring_num = prof->rx_ring_num;
-- 
2.17.0

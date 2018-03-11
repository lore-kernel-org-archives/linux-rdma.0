From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/mlx4_en: Fix a memory leak in case of error in 'mlx4_en_init_netdev()'
Date: Sun, 11 Mar 2018 23:45:29 +0100
Message-ID: <20180311224529.4427-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tariqt@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

If 'kzalloc' fails, we must free some memory before returning.

Fixes: 67f8b1dcb9ee ("net/mlx4_en: Refactor the XDP forwarding rings scheme")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 8fc51bc29003..f9db018e858f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3327,7 +3327,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		if (!priv->tx_cq[t]) {
 			kfree(priv->tx_ring[t]);
 			err = -ENOMEM;
-			goto out;
+			goto err_free_tx;
 		}
 	}
 	priv->rx_ring_num = prof->rx_ring_num;
-- 
2.14.1


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus

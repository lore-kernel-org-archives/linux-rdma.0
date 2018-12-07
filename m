From: Tarick Bedeir <tarick@google.com>
Subject: [PATCH] net/mlx4_core: Correctly set PFC param if global pause is
 turned off.
Date: Fri,  7 Dec 2018 00:30:26 -0800
Message-ID: <20181207083026.173789-1-tarick@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Eran Ben Elisha <eranbe@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

rx_ppp and tx_ppp can be set between 0 and 255, so don't clamp to 1.

Fixes: 6e8814ceb7e8 ("net/mlx4_en: Fix mixed PFC and Global pause user control requests")
Signed-off-by: Tarick Bedeir <tarick@google.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index f11b45001cad..d290f0787dfb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1084,8 +1084,8 @@ static int mlx4_en_set_pauseparam(struct net_device *dev,
 
 	tx_pause = !!(pause->tx_pause);
 	rx_pause = !!(pause->rx_pause);
-	rx_ppp = priv->prof->rx_ppp && !(tx_pause || rx_pause);
-	tx_ppp = priv->prof->tx_ppp && !(tx_pause || rx_pause);
+	rx_ppp = (tx_pause || rx_pause) ? 0 : priv->prof->rx_ppp;
+	tx_ppp = (tx_pause || rx_pause) ? 0 : priv->prof->tx_ppp;
 
 	err = mlx4_SET_PORT_general(mdev->dev, priv->port,
 				    priv->rx_skb_size + ETH_FCS_LEN,
-- 
2.20.0.rc2.403.gdbc3b29805-goog

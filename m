From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 34/34] net/mlx4_core: Correctly set PFC param if global pause is turned off.
Date: Wed, 12 Dec 2018 23:32:00 -0500
Message-ID: <20181213043200.76295-34-sashal@kernel.org>
References: <20181213043200.76295-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181213043200.76295-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tarick Bedeir <tarick@google.com>, "David S . Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Tarick Bedeir <tarick@google.com>

[ Upstream commit bd5122cd1e0644d8bd8dd84517c932773e999766 ]

rx_ppp and tx_ppp can be set between 0 and 255, so don't clamp to 1.

Fixes: 6e8814ceb7e8 ("net/mlx4_en: Fix mixed PFC and Global pause user control requests")
Signed-off-by: Tarick Bedeir <tarick@google.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 9a4c4f8281bd..8a9a332d78b4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1027,8 +1027,8 @@ static int mlx4_en_set_pauseparam(struct net_device *dev,
 
 	tx_pause = !!(pause->tx_pause);
 	rx_pause = !!(pause->rx_pause);
-	rx_ppp = priv->prof->rx_ppp && !(tx_pause || rx_pause);
-	tx_ppp = priv->prof->tx_ppp && !(tx_pause || rx_pause);
+	rx_ppp = (tx_pause || rx_pause) ? 0 : priv->prof->rx_ppp;
+	tx_ppp = (tx_pause || rx_pause) ? 0 : priv->prof->tx_ppp;
 
 	err = mlx4_SET_PORT_general(mdev->dev, priv->port,
 				    priv->rx_skb_size + ETH_FCS_LEN,
-- 
2.19.1

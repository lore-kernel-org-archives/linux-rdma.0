From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 4/4] mlx5: use skb_vlan_tag_get_prio()
Date: Tue, 20 Nov 2018 13:20:33 +0100
Message-ID: <faddcae9d80658bb9902f54de845c733f5d98768.1542716156.git.mirq-linux@rere.qmqm.pl>
References: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, Ajit Khaparde <ajit.khaparde@broadcom.com>, devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Sathya Perla <sathya.perla@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 6dacaeba2fbf..9afdf955f2bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -127,7 +127,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	else
 #endif
 		if (skb_vlan_tag_present(skb))
-			up = skb->vlan_tci >> VLAN_PRIO_SHIFT;
+			up = skb_vlan_tag_get_prio(skb);
 
 	/* channel_ix can be larger than num_channels since
 	 * dev->num_real_tx_queues = num_channels * num_tc
-- 
2.19.1

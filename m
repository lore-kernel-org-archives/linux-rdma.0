From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 3/4] benet: use skb_vlan_tag_get_prio()
Date: Tue, 20 Nov 2018 13:20:32 +0100
Message-ID: <cf892967db0029389e2d929206f16890e3180c8c.1542716156.git.mirq-linux@rere.qmqm.pl>
References: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Sathya Perla <sathya.perla@broadcom.com>, Ajit Khaparde <ajit.khaparde@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 80b2bd3747ce..245abf0d19c0 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -796,7 +796,7 @@ static inline u16 be_get_tx_vlan_tag(struct be_adapter *adapter,
 	u16 vlan_tag;
 
 	vlan_tag = skb_vlan_tag_get(skb);
-	vlan_prio = (vlan_tag & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	vlan_prio = skb_vlan_tag_get_prio(skb);
 	/* If vlan priority provided by OS is NOT in available bmap */
 	if (!(adapter->vlan_prio_bmap & (1 << vlan_prio)))
 		vlan_tag = (vlan_tag & ~VLAN_PRIO_MASK) |
-- 
2.19.1

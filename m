From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 1/4] net/vlan: introduce skb_vlan_tag_get_cfi()
 helper
Date: Tue, 20 Nov 2018 13:20:31 +0100
Message-ID: <b0c6b89397222f6b91ff349831207d894f6ce567.1542716156.git.mirq-linux@rere.qmqm.pl>
References: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Ajit Khaparde <ajit.khaparde@broadcom.com>, devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Sathya Perla <sathya.perla@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-rdma@vger.kernel.org

Abstract CFI/DEI bit access consistently with other VLAN tag fields.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 include/linux/if_vlan.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 7a541eadf78e..4cca4da7a6de 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -65,7 +65,7 @@ static inline struct vlan_ethhdr *vlan_eth_hdr(const struct sk_buff *skb)
 
 #define VLAN_PRIO_MASK		0xe000 /* Priority Code Point */
 #define VLAN_PRIO_SHIFT		13
-#define VLAN_CFI_MASK		0x1000 /* Canonical Format Indicator */
+#define VLAN_CFI_MASK		0x1000 /* Canonical Format Indicator / Drop Eligible Indicator */
 #define VLAN_VID_MASK		0x0fff /* VLAN Identifier */
 #define VLAN_N_VID		4096
 
@@ -80,6 +80,7 @@ static inline bool is_vlan_dev(const struct net_device *dev)
 #define skb_vlan_tag_present(__skb)	((__skb)->vlan_present)
 #define skb_vlan_tag_get(__skb)		((__skb)->vlan_tci)
 #define skb_vlan_tag_get_id(__skb)	((__skb)->vlan_tci & VLAN_VID_MASK)
+#define skb_vlan_tag_get_cfi(__skb)	(!!((__skb)->vlan_tci & VLAN_CFI_MASK))
 #define skb_vlan_tag_get_prio(__skb)	(((__skb)->vlan_tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT)
 
 static inline int vlan_get_rx_ctag_filter_info(struct net_device *dev)
-- 
2.19.1

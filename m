From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 2/4] net/hyperv: use skb_vlan_tag_*() helpers
Date: Tue, 20 Nov 2018 13:20:32 +0100
Message-ID: <61f737ec45c9905d5c86fbe8492eaa604bf6549f.1542716156.git.mirq-linux@rere.qmqm.pl>
References: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, devel@linuxdriverproject.org, Ajit Khaparde <ajit.khaparde@broadcom.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Sathya Perla <sathya.perla@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
List-Id: linux-rdma@vger.kernel.org

Replace open-coded bitfield manipulation with skb_vlan_tag_*() helpers.
This also enables correctly passing of VLAN.CFI bit.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/net/hyperv/netvsc_drv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index cf36e7ff3191..85936ed9e952 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -605,9 +605,9 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 				     IEEE_8021Q_INFO);
 
 		vlan->value = 0;
-		vlan->vlanid = skb->vlan_tci & VLAN_VID_MASK;
-		vlan->pri = (skb->vlan_tci & VLAN_PRIO_MASK) >>
-				VLAN_PRIO_SHIFT;
+		vlan->vlanid = skb_vlan_tag_get_id(skb);
+		vlan->cfi = skb_vlan_tag_get_cfi(skb);
+		vlan->pri = skb_vlan_tag_get_prio(skb);
 	}
 
 	if (skb_is_gso(skb)) {
@@ -781,7 +781,8 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 	}
 
 	if (vlan) {
-		u16 vlan_tci = vlan->vlanid | (vlan->pri << VLAN_PRIO_SHIFT);
+		u16 vlan_tci = vlan->vlanid | (vlan->pri << VLAN_PRIO_SHIFT) |
+			(vlan->cfi ? VLAN_CFI_MASK : 0);
 
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       vlan_tci);
-- 
2.19.1

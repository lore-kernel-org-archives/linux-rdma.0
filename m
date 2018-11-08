From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 3/4] gianfar: remove use of VLAN_TAG_PRESENT
Date: Thu, 08 Nov 2018 18:44:50 +0100
Message-ID: <5846b048f81792971776b063687d7b62575be570.1541698641.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>, Faisal Latif <faisal.latif@intel.com>, Pravin B Shelar <pshelar@ovn.org>, Shiraz Saleem <shiraz.saleem@intel.com>, dev@openvswitch.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/net/ethernet/freescale/gianfar_ethtool.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 0d76e15cd6dd..241325c35cb4 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1134,11 +1134,9 @@ static int gfar_convert_to_filer(struct ethtool_rx_flow_spec *rule,
 		prio = vlan_tci_prio(rule);
 		prio_mask = vlan_tci_priom(rule);
 
-		if (cfi == VLAN_TAG_PRESENT && cfi_mask == VLAN_TAG_PRESENT) {
-			vlan |= RQFPR_CFI;
-			vlan_mask |= RQFPR_CFI;
-		} else if (cfi != VLAN_TAG_PRESENT &&
-			   cfi_mask == VLAN_TAG_PRESENT) {
+		if (cfi_mask) {
+			if (cfi)
+				vlan |= RQFPR_CFI;
 			vlan_mask |= RQFPR_CFI;
 		}
 	}
-- 
2.19.1

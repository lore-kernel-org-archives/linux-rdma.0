From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 2/4] cnic: remove use of VLAN_TAG_PRESENT
Date: Thu, 08 Nov 2018 18:44:50 +0100
Message-ID: <39c6d1c6e85a758b9988407ecc98883317648b38.1541698641.git.mirq-linux@rere.qmqm.pl>
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

This just removes VLAN_TAG_PRESENT use.  VLAN TCI=0 special meaning is
deeply embedded in the driver code and so is left as is.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/net/ethernet/broadcom/cnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index d83233ae4a15..510dfc1c236b 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -5731,7 +5731,7 @@ static int cnic_netdev_event(struct notifier_block *this, unsigned long event,
 		if (realdev) {
 			dev = cnic_from_netdev(realdev);
 			if (dev) {
-				vid |= VLAN_TAG_PRESENT;
+				vid |= VLAN_CFI_MASK;	/* make non-zero */
 				cnic_rcv_netevent(dev->cnic_priv, event, vid);
 				cnic_put(dev);
 			}
-- 
2.19.1

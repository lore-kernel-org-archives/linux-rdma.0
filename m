From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: fix vlan support
Date: Fri, 16 May 2014 12:42:46 -0500
Message-ID: <20140516174245.26031.80645.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RDMA connections over a vlan interface don't work due to
import_ep() not using the correct egress device.

- use the real device in import_ep()

- use rdma_vlan_dev_real_dev() in get_real_dev().

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 1f863a9..28114e6 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -47,6 +47,8 @@
 #include <net/ip6_route.h>
 #include <net/addrconf.h>
 
+#include <rdma/ib_addr.h>
+
 #include "iw_cxgb4.h"
 
 static char *states[] = {
@@ -341,10 +343,7 @@ static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
 
 static struct net_device *get_real_dev(struct net_device *egress_dev)
 {
-	struct net_device *phys_dev = egress_dev;
-	if (egress_dev->priv_flags & IFF_802_1Q_VLAN)
-		phys_dev = vlan_dev_real_dev(egress_dev);
-	return phys_dev;
+	return rdma_vlan_dev_real_dev(egress_dev) ? : egress_dev;
 }
 
 static int our_interface(struct c4iw_dev *dev, struct net_device *egress_dev)
@@ -1746,16 +1745,16 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
 		if (!ep->l2t)
 			goto out;
 		ep->mtu = dst_mtu(dst);
-		ep->tx_chan = cxgb4_port_chan(n->dev);
-		ep->smac_idx = (cxgb4_port_viid(n->dev) & 0x7F) << 1;
+		ep->tx_chan = cxgb4_port_chan(pdev);
+		ep->smac_idx = (cxgb4_port_viid(pdev) & 0x7F) << 1;
 		step = cdev->rdev.lldi.ntxq /
 			cdev->rdev.lldi.nchan;
-		ep->txq_idx = cxgb4_port_idx(n->dev) * step;
-		ep->ctrlq_idx = cxgb4_port_idx(n->dev);
+		ep->txq_idx = cxgb4_port_idx(pdev) * step;
+		ep->ctrlq_idx = cxgb4_port_idx(pdev);
 		step = cdev->rdev.lldi.nrxq /
 			cdev->rdev.lldi.nchan;
 		ep->rss_qid = cdev->rdev.lldi.rxq_ids[
-			cxgb4_port_idx(n->dev) * step];
+			cxgb4_port_idx(pdev) * step];
 
 		if (clear_mpa_v1) {
 			ep->retry_with_mpa_v1 = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

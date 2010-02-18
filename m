From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv8 06/11] ipoib: avoid ipoib over IBoE
Date: Thu, 18 Feb 2010 19:24:20 +0200
Message-ID: <20100218172420.GG12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IPoIB is an implementation of IP over Infiniband transport. In the case of
IBoE, the link layer is Ethernet so IP can work directly over Ethernet, so
disable IPoIB for none IB_LINK_LAYER_INFINIBAND ports.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 06014d2..5e6c2de 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1362,6 +1362,8 @@ static void ipoib_add_one(struct ib_device *device)
 	}
 
 	for (p = s; p <= e; ++p) {
+		if (rdma_port_link_layer(device, p) != IB_LINK_LAYER_INFINIBAND)
+			continue;
 		dev = ipoib_add_port("ib%d", device, p);
 		if (!IS_ERR(dev)) {
 			priv = netdev_priv(dev);
@@ -1383,6 +1385,9 @@ static void ipoib_remove_one(struct ib_device *device)
 	dev_list = ib_get_client_data(device, &ipoib_client);
 
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
+		if (rdma_port_link_layer(device, priv->port) != IB_LINK_LAYER_INFINIBAND)
+			continue;
+
 		ib_unregister_event_handler(&priv->event_handler);
 
 		rtnl_lock();
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

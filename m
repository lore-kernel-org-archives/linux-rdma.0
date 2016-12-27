From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 7/9] IB/ipoib: Use debug prints instead of warnings in RNR WC status
Date: Tue, 27 Dec 2016 15:39:09 +0200
Message-ID: <20161227133911.14340-8-leon@kernel.org>
References: <20161227133911.14340-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161227133911.14340-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If a receive request has not been posted to the work queue, the incoming
message is rejected and the peer will receive a receiver-not-ready (RNR)
error. In IPoIB, IB_WC_RNR_RETRY_EXC_ERR error is part of the life cycle
therefore ipoib_cm_handle_tx_wc function will print to debug instead
of warnings.

Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index a720d2d..b6444b2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -820,9 +820,12 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	    wc->status != IB_WC_WR_FLUSH_ERR) {
 		struct ipoib_neigh *neigh;
 
-		ipoib_dbg(priv, "failed cm send event "
-			   "(status=%d, wrid=%d vend_err %x)\n",
-			   wc->status, wr_id, wc->vendor_err);
+		if (wc->status != IB_WC_RNR_RETRY_EXC_ERR)
+			ipoib_warn(priv, "%s: failed cm send event (status=%d, wrid=%d vend_err %x)\n",
+				   __func__, wc->status, wr_id, wc->vendor_err);
+		else
+			ipoib_dbg(priv, "%s: failed cm send event (status=%d, wrid=%d vend_err %x)\n",
+				  __func__, wc->status, wr_id, wc->vendor_err);
 
 		spin_lock_irqsave(&priv->lock, flags);
 		neigh = tx->neigh;
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

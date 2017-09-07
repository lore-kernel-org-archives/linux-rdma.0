From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/ipoib: Suppress the retry related completion errors
Date: Thu,  7 Sep 2017 13:38:18 +0300
Message-ID: <20170907103818.5303-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

IPoIB doesn't support transport/rnr retry schemes as per
RFC so those errors are expected. No need to flood the
log files with them.

Tested-by: Michael Nowak <michael.nowak-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Rafael Alejandro Peralez <rafael.peralez-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Liwen Huang <liwen.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Hong Liu <hong.x.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reported-by: Rajiv Raja <rajiv.raja-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 14b62f7472b4..7774654c2ccb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -823,12 +823,18 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	    wc->status != IB_WC_WR_FLUSH_ERR) {
 		struct ipoib_neigh *neigh;
 
-		if (wc->status != IB_WC_RNR_RETRY_EXC_ERR)
-			ipoib_warn(priv, "failed cm send event (status=%d, wrid=%d vend_err %x)\n",
-				   wc->status, wr_id, wc->vendor_err);
+		/* IB_WC[_RNR]_RETRY_EXC_ERR error is part of the life cycle,
+		 * so don't make waves.
+		 */
+		if (wc->status == IB_WC_RNR_RETRY_EXC_ERR ||
+		    wc->status == IB_WC_RETRY_EXC_ERR)
+			ipoib_dbg(priv,
+				  "%s: failed cm send event (status=%d, wrid=%d vend_err 0x%x)\n",
+				   __func__, wc->status, wr_id, wc->vendor_err);
 		else
-			ipoib_dbg(priv, "failed cm send event (status=%d, wrid=%d vend_err %x)\n",
-				  wc->status, wr_id, wc->vendor_err);
+			ipoib_warn(priv,
+				    "%s: failed cm send event (status=%d, wrid=%d vend_err 0x%x)\n",
+				   __func__, wc->status, wr_id, wc->vendor_err);
 
 		spin_lock_irqsave(&priv->lock, flags);
 		neigh = tx->neigh;
-- 
2.13.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

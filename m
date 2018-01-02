From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/ipoib: Fix for notify send CQ failure messages
Date: Tue, 02 Jan 2018 16:04:20 -0500
Message-ID: <20180102210419.26104.32513.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If IB_CQ_REPORT_MISSED_EVENTS flag is passed in ib_req_notify_cq()
it may return positive value indicating non-empty CQ.
If return code not verified the log might be flooded with false
warning messages "request notify on send CQ failed".

Fixes: commit 8966e28d2e40 ("IB/ipoib: Use NAPI in UD/TX flows")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   10 ++++++----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 2c13123..8152724 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -766,12 +766,14 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 	skb_orphan(skb);
 	skb_dst_drop(skb);
 
-	if (netif_queue_stopped(dev))
-		if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP |
-				     IB_CQ_REPORT_MISSED_EVENTS)) {
+	if (netif_queue_stopped(dev)) {
+		rc = ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP |
+				      IB_CQ_REPORT_MISSED_EVENTS);
+		if (unlikely(rc < 0))
 			ipoib_warn(priv, "IPoIB/CM:request notify on send CQ failed\n");
+		else if (rc)
 			napi_schedule(&priv->send_napi);
-		}
+	}
 
 	rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1), tx_req);
 	if (unlikely(rc)) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index e6151a2..2865808 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -644,7 +644,7 @@ int ipoib_send(struct net_device *dev, struct sk_buff *skb,
 
 	if (netif_queue_stopped(dev))
 		if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP |
-				     IB_CQ_REPORT_MISSED_EVENTS))
+				     IB_CQ_REPORT_MISSED_EVENTS) < 0)
 			ipoib_warn(priv, "request notify on send CQ failed\n");
 
 	rc = post_send(priv, priv->tx_head & (ipoib_sendq_size - 1),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

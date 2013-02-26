From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/ipoib: correct tx lockup patch
Date: Tue, 26 Feb 2013 10:46:27 -0500
Message-ID: <20130226154627.3775.35111.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit f0dc117 ("IPoIB: Fix TX queue lockup with mixed UD/CM traffic")
attempts to solve an issue were unprocessed UD send cq completions
can deadlock the netdev.

The patch doesn't fully resolve the issue because if more than
half the tx_outstanding's were UD and all of the destinations
are RC reachable, arming the CQ doesn't solve the issue.

This patch uses the IB_CQ_REPORT_MISSED_EVENTS on the
ib_req_notify_cq().   If the rc is above 0, the UD send cq
completion callback is called directly to re-arm the send
completion timer.

This issue is seen in very large parallel filesystem deployments
and has been show to correct the issue.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 67b0c1d..1ef880d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -758,9 +758,13 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 		if (++priv->tx_outstanding == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 				  tx->qp->qp_num);
-			if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP))
-				ipoib_warn(priv, "request notify on send CQ failed\n");
 			netif_stop_queue(dev);
+			rc = ib_req_notify_cq(priv->send_cq,
+				IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
+			if (rc < 0)
+				ipoib_warn(priv, "request notify on send CQ failed\n");
+			else if (rc)
+				ipoib_send_comp_handler(priv->send_cq, dev);
 		}
 	}
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

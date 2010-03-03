From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] ipoib: Fix lockup of the tx queue
Date: Wed, 3 Mar 2010 14:27:52 +0200
Message-ID: <20100303122752.GA29784@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ipoib UD QP reports send completions to priv->send_cq which is unarmed
generally; it only gets armed when the number of outstanding send requests
(e.g. those for which a completion was not polled yet) reaches the size of the
tx queue. This arming (done using ib_req_notify_cq()) is done only in the send
path for the UD QP. However, when sending CM packets, the net queue may be
stopped for the same reasons but no measures are taken to recover the UD path
from a lockup.
Consider this scenario: a host sends high rate of both CM and UD packets.
Suppose also that the tx queue length is N. If at some time the number of
outstanding UD packets is more than N/2 and the overall outstanding packets is
N-1, and now CM sends a packet making the number of outstanding equal N, the tx
queue will be stopped. When all the CM packets will complete, the number of
outstanding packets will still be higher than N/2 so the tx queue will not be
enabled.
Fix this by calling ib_req_notify_cq() when the queue is stopped in the CM
path.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 30bdf42..f8302c2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -752,6 +752,8 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 		if (++priv->tx_outstanding == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 				  tx->qp->qp_num);
+			if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP))
+				ipoib_warn(priv, "request notify on send CQ failed\n");
 			netif_stop_queue(dev);
 		}
 	}
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 3/4] RDMA/cxgb4: Set/Reset the EP timer inside EP lock.
Date: Fri, 23 Jul 2010 14:12:37 -0500
Message-ID: <20100723191237.15832.57689.stgit@build.ogc.int>
References: <20100723191221.15832.79704.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100723191221.15832.79704.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Endpoint timer manipulation needs to be done inside the lock.  Otherwise
we can get into a situation where a timer is stopped before it is started,
which hits the WARN_ON() in stop_ep_timer().

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |   34 ++++++++--------------------------
 1 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 6e480cd..bc3f9f0 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1484,8 +1484,6 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 	int closing = 0;
 	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(hdr);
-	int start_timer = 0;
-	int stop_timer = 0;
 
 	ep = lookup_tid(t, tid);
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
@@ -1522,7 +1520,7 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 		wake_up(&ep->com.waitq);
 		break;
 	case FPDU_MODE:
-		start_timer = 1;
+		start_ep_timer(ep);
 		__state_set(&ep->com, CLOSING);
 		closing = 1;
 		peer_close_upcall(ep);
@@ -1535,7 +1533,7 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 		disconnect = 0;
 		break;
 	case MORIBUND:
-		stop_timer = 1;
+		stop_ep_timer(ep);
 		if (ep->com.cm_id && ep->com.qp) {
 			attrs.next_state = C4IW_QP_STATE_IDLE;
 			c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
@@ -1558,10 +1556,6 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
 			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
 	}
-	if (start_timer)
-		start_ep_timer(ep);
-	if (stop_timer)
-		stop_ep_timer(ep);
 	if (disconnect)
 		c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
 	if (release)
@@ -1590,7 +1584,6 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 	unsigned long flags;
 	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(req);
-	int stop_timer = 0;
 
 	ep = lookup_tid(t, tid);
 	if (is_neg_adv_abort(req->status)) {
@@ -1605,10 +1598,10 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 	case CONNECTING:
 		break;
 	case MPA_REQ_WAIT:
-		stop_timer = 1;
+		stop_ep_timer(ep);
 		break;
 	case MPA_REQ_SENT:
-		stop_timer = 1;
+		stop_ep_timer(ep);
 		connect_reply_upcall(ep, -ECONNRESET);
 		break;
 	case MPA_REP_SENT:
@@ -1632,7 +1625,7 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		break;
 	case MORIBUND:
 	case CLOSING:
-		stop_timer = 1;
+		stop_ep_timer(ep);
 		/*FALLTHROUGH*/
 	case FPDU_MODE:
 		if (ep->com.cm_id && ep->com.qp) {
@@ -1678,8 +1671,6 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 	rpl->cmd = CPL_ABORT_NO_RST;
 	c4iw_ofld_send(&ep->com.dev->rdev, rpl_skb);
 out:
-	if (stop_timer)
-		stop_ep_timer(ep);
 	if (release)
 		release_ep_resources(ep);
 	return 0;
@@ -1694,7 +1685,6 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	int release = 0;
 	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(rpl);
-	int stop_timer = 0;
 
 	ep = lookup_tid(t, tid);
 
@@ -1708,7 +1698,7 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 		__state_set(&ep->com, MORIBUND);
 		break;
 	case MORIBUND:
-		stop_timer = 1;
+		stop_ep_timer(ep);
 		if ((ep->com.cm_id) && (ep->com.qp)) {
 			attrs.next_state = C4IW_QP_STATE_IDLE;
 			c4iw_modify_qp(ep->com.qp->rhp,
@@ -1728,8 +1718,6 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 		break;
 	}
 	spin_unlock_irqrestore(&ep->com.lock, flags);
-	if (stop_timer)
-		stop_ep_timer(ep);
 	if (release)
 		release_ep_resources(ep);
 	return 0;
@@ -2108,8 +2096,6 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 	int close = 0;
 	int fatal = 0;
 	struct c4iw_rdev *rdev;
-	int start_timer = 0;
-	int stop_timer = 0;
 
 	spin_lock_irqsave(&ep->com.lock, flags);
 
@@ -2133,7 +2119,7 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 			ep->com.state = ABORTING;
 		else {
 			ep->com.state = CLOSING;
-			start_timer = 1;
+			start_ep_timer(ep);
 		}
 		set_bit(CLOSE_SENT, &ep->com.flags);
 		break;
@@ -2141,7 +2127,7 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 		if (!test_and_set_bit(CLOSE_SENT, &ep->com.flags)) {
 			close = 1;
 			if (abrupt) {
-				stop_timer = 1;
+				stop_ep_timer(ep);
 				ep->com.state = ABORTING;
 			} else
 				ep->com.state = MORIBUND;
@@ -2159,10 +2145,6 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 	}
 
 	spin_unlock_irqrestore(&ep->com.lock, flags);
-	if (start_timer)
-		start_ep_timer(ep);
-	if (stop_timer)
-		stop_ep_timer(ep);
 	if (close) {
 		if (abrupt)
 			ret = abort_connection(ep, NULL, gfp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

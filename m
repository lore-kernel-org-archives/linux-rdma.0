From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] RDMA/cxgb4: abort fixes
Date: Tue, 14 Jun 2011 15:59:27 -0500
Message-ID: <20110614205926.13310.68941.stgit@build.ogc.int>
References: <20110614205921.13310.85951.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110614205921.13310.85951.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: root <root-2d+91cRUWdi82J0KkYAwCt2OpvIVB1A/0E9HWUfgJXw@public.gmane.org>

- fixed race where the driver could end up sending a close_con_req after
an abort_rpl.  In c4iw_ep_disconnect(), send abort or close request with
the ep mutex held.

- fixed hang where driver fails to wake up when a connection is reset
during a normal close.  Wake up any waiters in the interrupt path, and
correctly cleanup after rdma_fini() failures.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |   46 +++++++++++++++++++++++++++++++-------
 drivers/infiniband/hw/cxgb4/qp.c |    5 +---
 2 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index f660cd0..31fb440 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1463,9 +1463,9 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct c4iw_qp_attributes attrs;
 	int disconnect = 1;
 	int release = 0;
-	int abort = 0;
 	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(hdr);
+	int ret;
 
 	ep = lookup_tid(t, tid);
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
@@ -1501,10 +1501,12 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 		start_ep_timer(ep);
 		__state_set(&ep->com, CLOSING);
 		attrs.next_state = C4IW_QP_STATE_CLOSING;
-		abort = c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
+		ret = c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
 				       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
-		peer_close_upcall(ep);
-		disconnect = 1;
+		if (ret != -ECONNRESET) {
+			peer_close_upcall(ep);
+			disconnect = 1;
+		}
 		break;
 	case ABORTING:
 		disconnect = 0;
@@ -2109,15 +2111,16 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 		break;
 	}
 
-	mutex_unlock(&ep->com.mutex);
 	if (close) {
-		if (abrupt)
-			ret = abort_connection(ep, NULL, gfp);
-		else
+		if (abrupt) {
+			close_complete_upcall(ep);
+			ret = send_abort(ep, NULL, gfp);
+		} else
 			ret = send_halfclose(ep, gfp);
 		if (ret)
 			fatal = 1;
 	}
+	mutex_unlock(&ep->com.mutex);
 	if (fatal)
 		release_ep_resources(ep);
 	return ret;
@@ -2301,6 +2304,31 @@ static int fw6_msg(struct c4iw_dev *dev, struct sk_buff *skb)
 	return 0;
 }
 
+static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
+{
+	struct cpl_abort_req_rss *req = cplhdr(skb);
+	struct c4iw_ep *ep;
+	struct tid_info *t = dev->rdev.lldi.tids;
+	unsigned int tid = GET_TID(req);
+
+	ep = lookup_tid(t, tid);
+	if (is_neg_adv_abort(req->status)) {
+		PDBG("%s neg_adv_abort ep %p tid %u\n", __func__, ep,
+		     ep->hwtid);
+		kfree_skb(skb);
+		return 0;
+	}
+	PDBG("%s ep %p tid %u state %u\n", __func__, ep, ep->hwtid,
+	     ep->com.state);
+
+	/*
+	 * Wake up any threads in rdma_init() or rdma_fini().
+	 */
+	c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
+	sched(dev, skb);
+	return 0;
+}
+
 /*
  * Most upcalls from the T4 Core go to sched() to
  * schedule the processing on a work queue.
@@ -2317,7 +2345,7 @@ c4iw_handler_func c4iw_handlers[NUM_CPL_CMDS] = {
 	[CPL_PASS_ESTABLISH] = sched,
 	[CPL_PEER_CLOSE] = sched,
 	[CPL_CLOSE_CON_RPL] = sched,
-	[CPL_ABORT_REQ_RSS] = sched,
+	[CPL_ABORT_REQ_RSS] = peer_abort_intr,
 	[CPL_RDMA_TERMINATE] = sched,
 	[CPL_FW4_ACK] = sched,
 	[CPL_SET_TCB_RPL] = set_tcb_rpl,
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 3b773b0..a41578e 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1207,11 +1207,8 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 				c4iw_get_ep(&qhp->ep->com);
 			}
 			ret = rdma_fini(rhp, qhp, ep);
-			if (ret) {
-				if (internal)
-					c4iw_get_ep(&qhp->ep->com);
+			if (ret)
 				goto err;
-			}
 			break;
 		case C4IW_QP_STATE_TERMINATE:
 			set_state(qhp, C4IW_QP_STATE_TERMINATE);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

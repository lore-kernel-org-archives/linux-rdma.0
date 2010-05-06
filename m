From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 4/7] RDMA/cxgb4: Use proper gfp_t values based on thread
	context
Date: Thu, 06 May 2010 18:06:36 -0500
Message-ID: <20100506230636.25362.83463.stgit@build.ogc.int>
References: <20100506230619.25362.97591.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506230619.25362.97591.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: root <root-m5ktC/4JIOOIE2W2IvP7LA@public.gmane.org>

Calls from post_qp_event() are in the interrupt context, so use GFP_ATOMIC
as necessary.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/ev.c |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index 1bd6a3e..ca05b5b 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -60,7 +60,7 @@ static void post_qp_event(struct c4iw_dev *dev, struct c4iw_cq *chp,
 	if (qhp->attr.state == C4IW_QP_STATE_RTS) {
 		attrs.next_state = C4IW_QP_STATE_TERMINATE;
 		c4iw_modify_qp(qhp->rhp, qhp, C4IW_QP_ATTR_NEXT_STATE,
-			       &attrs, 0);
+			       &attrs, 1);
 	}
 
 	event.event = ib_event;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 7ff6aea..83a01dc 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -856,7 +856,8 @@ int c4iw_post_zb_read(struct c4iw_qp *qhp)
 	return c4iw_ofld_send(&qhp->rhp->rdev, skb);
 }
 
-int c4iw_post_terminate(struct c4iw_qp *qhp, struct t4_cqe *err_cqe)
+static void post_terminate(struct c4iw_qp *qhp, struct t4_cqe *err_cqe,
+			   gfp_t gfp)
 {
 	struct fw_ri_wr *wqe;
 	struct sk_buff *skb;
@@ -865,9 +866,9 @@ int c4iw_post_terminate(struct c4iw_qp *qhp, struct t4_cqe *err_cqe)
 	PDBG("%s qhp %p qid 0x%x tid %u\n", __func__, qhp, qhp->wq.sq.qid,
 	     qhp->ep->hwtid);
 
-	skb = alloc_skb(sizeof *wqe, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(sizeof *wqe, gfp);
 	if (!skb)
-		return -ENOMEM;
+		return;
 	set_wr_txq(skb, CPL_PRIORITY_DATA, qhp->ep->txq_idx);
 
 	wqe = (struct fw_ri_wr *)__skb_put(skb, sizeof(*wqe));
@@ -881,7 +882,7 @@ int c4iw_post_terminate(struct c4iw_qp *qhp, struct t4_cqe *err_cqe)
 	wqe->u.terminate.immdlen = cpu_to_be32(sizeof *term);
 	term = (struct terminate_message *)wqe->u.terminate.termmsg;
 	build_term_codes(err_cqe, &term->layer_etype, &term->ecode);
-	return c4iw_ofld_send(&qhp->rhp->rdev, skb);
+	c4iw_ofld_send(&qhp->rhp->rdev, skb);
 }
 
 /*
@@ -1215,12 +1216,10 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 			qhp->attr.state = C4IW_QP_STATE_TERMINATE;
 			if (qhp->ibqp.uobject)
 				t4_set_wq_in_error(&qhp->wq);
-			if (!internal) {
-				ep = qhp->ep;
-				c4iw_get_ep(&ep->com);
-				terminate = 1;
-				disconnect = 1;
-			}
+			ep = qhp->ep;
+			c4iw_get_ep(&ep->com);
+			terminate = 1;
+			disconnect = 1;
 			break;
 		case C4IW_QP_STATE_ERROR:
 			qhp->attr.state = C4IW_QP_STATE_ERROR;
@@ -1301,7 +1300,7 @@ out:
 	spin_unlock_irqrestore(&qhp->lock, flag);
 
 	if (terminate)
-		c4iw_post_terminate(qhp, NULL);
+		post_terminate(qhp, NULL, internal ? GFP_ATOMIC : GFP_KERNEL);
 
 	/*
 	 * If disconnect is 1, then we need to initiate a disconnect
@@ -1309,7 +1308,8 @@ out:
 	 * an abnormal close (RTS/CLOSING->ERROR).
 	 */
 	if (disconnect) {
-		c4iw_ep_disconnect(ep, abort, GFP_KERNEL);
+		c4iw_ep_disconnect(ep, abort, internal ? GFP_ATOMIC :
+							 GFP_KERNEL);
 		c4iw_put_ep(&ep->com);
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

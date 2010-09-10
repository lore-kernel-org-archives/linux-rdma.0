From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 05/11] RDMA/cxgb4: Handle CPL_RDMA_TERMINATE messages.
Date: Fri, 10 Sep 2010 11:15:09 -0500
Message-ID: <20100910161509.6829.55098.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

T4 FW sends up CPL_RDMA_TERMINATE to indicate a peer TERM.  This triggers
the QP moving to TERMINATE state.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |   25 +++++++++++++------------
 drivers/infiniband/hw/cxgb4/ev.c |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c |    3 ++-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d548167..0227c13 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1725,23 +1725,24 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 
 static int terminate(struct c4iw_dev *dev, struct sk_buff *skb)
 {
-	struct c4iw_ep *ep;
-	struct cpl_rdma_terminate *term = cplhdr(skb);
+	struct cpl_rdma_terminate *rpl = cplhdr(skb);
 	struct tid_info *t = dev->rdev.lldi.tids;
-	unsigned int tid = GET_TID(term);
+	unsigned int tid = GET_TID(rpl);
+	struct c4iw_ep *ep;
+	struct c4iw_qp_attributes attrs;
 
 	ep = lookup_tid(t, tid);
+	BUG_ON(!ep);
 
-	if (state_read(&ep->com) != FPDU_MODE)
-		return 0;
+	if (ep->com.qp) {
+		printk(KERN_WARNING MOD "TERM received tid %u qpid %u\n", tid,
+		       ep->com.qp->wq.sq.qid);
+		attrs.next_state = C4IW_QP_STATE_TERMINATE;
+		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
+			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
+	} else
+		printk(KERN_WARNING MOD "TERM received tid %u no qp\n", tid);
 
-	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
-	skb_pull(skb, sizeof *term);
-	PDBG("%s saving %d bytes of term msg\n", __func__, skb->len);
-	skb_copy_from_linear_data(skb, ep->com.qp->attr.terminate_buffer,
-				  skb->len);
-	ep->com.qp->attr.terminate_msg_len = skb->len;
-	ep->com.qp->attr.is_terminate_local = 0;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index 491e76a..c13041a 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -60,7 +60,7 @@ static void post_qp_event(struct c4iw_dev *dev, struct c4iw_cq *chp,
 	if (qhp->attr.state == C4IW_QP_STATE_RTS) {
 		attrs.next_state = C4IW_QP_STATE_TERMINATE;
 		c4iw_modify_qp(qhp->rhp, qhp, C4IW_QP_ATTR_NEXT_STATE,
-			       &attrs, 1);
+			       &attrs, 0);
 	}
 
 	event.event = ib_event;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index c92259f..7756d44 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1238,7 +1238,8 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 				t4_set_wq_in_error(&qhp->wq);
 			ep = qhp->ep;
 			c4iw_get_ep(&ep->com);
-			terminate = 1;
+			if (!internal)
+				terminate = 1;
 			disconnect = 1;
 			break;
 		case C4IW_QP_STATE_ERROR:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

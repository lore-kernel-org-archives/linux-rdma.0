From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 05/11] RDMA/cxgb4: Always log async errors.
Date: Mon,  7 Jan 2013 18:41:54 +0530
Message-ID: <1357564320-15022-6-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Log AEs even if the QP isn't in RTS.  It is useful
information.

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |    6 +++---
 drivers/infiniband/hw/cxgb4/ev.c |    8 +++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index ebcdb3f..5989991 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1419,9 +1419,9 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 		BUG_ON(!ep->com.qp);
 		if (ep->com.qp->attr.state == C4IW_QP_STATE_RTS)
 			pr_err("%s Unexpected streaming data." \
-			       " ep %p state %d tid %u status %d\n",
-			       __func__, ep, state_read(&ep->com),
-			       ep->hwtid, status);
+			       " qpid %u ep %p state %d tid %u status %d\n",
+			       __func__, ep->com.qp->wq.sq.qid, ep,
+			       state_read(&ep->com), ep->hwtid, status);
 		attrs.next_state = C4IW_QP_STATE_ERROR;
 		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
 			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index cf2f6b4..1a840b2 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -46,9 +46,11 @@ static void post_qp_event(struct c4iw_dev *dev, struct c4iw_cq *chp,
 
 	if ((qhp->attr.state == C4IW_QP_STATE_ERROR) ||
 	    (qhp->attr.state == C4IW_QP_STATE_TERMINATE)) {
-		PDBG("%s AE received after RTS - "
-		     "qp state %d qpid 0x%x status 0x%x\n", __func__,
-		     qhp->attr.state, qhp->wq.sq.qid, CQE_STATUS(err_cqe));
+		pr_err("%s AE after RTS - qpid 0x%x opcode %d status 0x%x "\
+		       "type %d wrid.hi 0x%x wrid.lo 0x%x\n",
+		       __func__, CQE_QPID(err_cqe), CQE_OPCODE(err_cqe),
+		       CQE_STATUS(err_cqe), CQE_TYPE(err_cqe),
+		       CQE_WRID_HI(err_cqe), CQE_WRID_LOW(err_cqe));
 		return;
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

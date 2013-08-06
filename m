From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/8] RDMA/cxgb4: Handle newer firmware changes
Date: Tue,  6 Aug 2013 21:04:34 +0530
Message-ID: <1375803280-7916-3-git-send-email-vipul@chelsio.com>
References: <1375803280-7916-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375803280-7916-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Move QP to TERMINATE instead to allow the peer to get the TERM message. This
bug wasn't detectable until newer FW that moves connections out of RDMA mode as
soon as an error is detected.

QP can exit RTS before the last AE arrives. This was introduced by changes in
the FW to kick connections out of RDMA mode as soon as an error is detected. A
side effect of this is that the driver can move the QP out of RTS before the AE
causing the connection to get kicked out of RDMA mode is processed. Fix for
this is to always post async errors even if the QP is out of RTS.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |  5 ++---
 drivers/infiniband/hw/cxgb4/ev.c | 10 ----------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 31dee27..1b0fd72 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1568,10 +1568,9 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 			       " qpid %u ep %p state %d tid %u status %d\n",
 			       __func__, ep->com.qp->wq.sq.qid, ep,
 			       state_read(&ep->com), ep->hwtid, status);
-		attrs.next_state = C4IW_QP_STATE_ERROR;
+		attrs.next_state = C4IW_QP_STATE_TERMINATE;
 		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
-			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
-		c4iw_ep_disconnect(ep, 1, GFP_KERNEL);
+			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 0);
 		break;
 	}
 	default:
diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index 1a840b2..d61d0a1 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -44,16 +44,6 @@ static void post_qp_event(struct c4iw_dev *dev, struct c4iw_cq *chp,
 	struct c4iw_qp_attributes attrs;
 	unsigned long flag;
 
-	if ((qhp->attr.state == C4IW_QP_STATE_ERROR) ||
-	    (qhp->attr.state == C4IW_QP_STATE_TERMINATE)) {
-		pr_err("%s AE after RTS - qpid 0x%x opcode %d status 0x%x "\
-		       "type %d wrid.hi 0x%x wrid.lo 0x%x\n",
-		       __func__, CQE_QPID(err_cqe), CQE_OPCODE(err_cqe),
-		       CQE_STATUS(err_cqe), CQE_TYPE(err_cqe),
-		       CQE_WRID_HI(err_cqe), CQE_WRID_LOW(err_cqe));
-		return;
-	}
-
 	printk(KERN_ERR MOD "AE qpid 0x%x opcode %d status 0x%x "
 	       "type %d wrid.hi 0x%x wrid.lo 0x%x\n",
 	       CQE_QPID(err_cqe), CQE_OPCODE(err_cqe),
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

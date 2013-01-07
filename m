From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 03/11] RDMA/cxgb4: Display streaming mode error only if detected in RTS.
Date: Mon,  7 Jan 2013 18:41:52 +0530
Message-ID: <1357564320-15022-4-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With later firmware, the chances of getting streaming mode data after
we exit RTS is likely, so we don't need to warn for it.  The only real
case where we don't expect it is when the QP is in RTS.

move QP to ERROR when streaming mode data received.

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 3dce47a..31d1fac 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1403,21 +1403,23 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 		ep->rcv_seq += dlen;
 		process_mpa_request(ep, skb);
 		break;
-	default:
-		pr_err("%s Unexpected streaming data." \
-		       " ep %p state %d tid %u status %d\n",
-		       __func__, ep, state_read(&ep->com), ep->hwtid, status);
-
-		if (ep->com.qp) {
-			struct c4iw_qp_attributes attrs;
-
-			attrs.next_state = C4IW_QP_STATE_ERROR;
-			c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
-				       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
-		}
+	case FPDU_MODE: {
+		struct c4iw_qp_attributes attrs;
+		BUG_ON(!ep->com.qp);
+		if (ep->com.qp->attr.state == C4IW_QP_STATE_RTS)
+			pr_err("%s Unexpected streaming data." \
+			       " ep %p state %d tid %u status %d\n",
+			       __func__, ep, state_read(&ep->com),
+			       ep->hwtid, status);
+		attrs.next_state = C4IW_QP_STATE_ERROR;
+		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
+			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
 		c4iw_ep_disconnect(ep, 1, GFP_KERNEL);
 		break;
 	}
+	default:
+		break;
+	}
 	return 0;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

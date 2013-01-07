From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 01/11] RDMA/cxgb4: abort connections that receive unexpected streaming mode data
Date: Mon,  7 Jan 2013 18:41:50 +0530
Message-ID: <1357564320-15022-2-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This error means the rdma connection was knocked out of rdma mode probably due
to an error on the connection.

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c13745c..9cab6a6 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1391,30 +1391,31 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 	skb_pull(skb, sizeof(*hdr));
 	skb_trim(skb, dlen);
 
-	ep->rcv_seq += dlen;
-	BUG_ON(ep->rcv_seq != (ntohl(hdr->seq) + dlen));
-
 	/* update RX credits */
 	update_rx_credits(ep, dlen);
 
 	switch (state_read(&ep->com)) {
 	case MPA_REQ_SENT:
+		ep->rcv_seq += dlen;
 		process_mpa_reply(ep, skb);
 		break;
 	case MPA_REQ_WAIT:
+		ep->rcv_seq += dlen;
 		process_mpa_request(ep, skb);
 		break;
-	case MPA_REP_SENT:
-		break;
 	default:
 		pr_err("%s Unexpected streaming data." \
 		       " ep %p state %d tid %u status %d\n",
 		       __func__, ep, state_read(&ep->com), ep->hwtid, status);
 
-		/*
-		 * The ep will timeout and inform the ULP of the failure.
-		 * See ep_timeout().
-		 */
+		if (ep->com.qp) {
+			struct c4iw_qp_attributes attrs;
+
+			attrs.next_state = C4IW_QP_STATE_ERROR;
+			c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
+				       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
+		}
+		c4iw_ep_disconnect(ep, 1, GFP_KERNEL);
 		break;
 	}
 	return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

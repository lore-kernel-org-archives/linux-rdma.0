From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 3/3] iw_cxgb4: do not send RX_DATA_ACK CPLs after close/abort
Date: Thu, 22 Dec 2016 07:40:37 -0800
Message-ID: <aab18ef715752548bfbdc88eaeb4329cf7bc745e.1482442436.git.swise@opengridcomputing.com>
References: <68eb584a0cf57442ca6b2be97f915ab03c9b4293.1482442436.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <68eb584a0cf57442ca6b2be97f915ab03c9b4293.1482442436.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Function rx_data(), which handles ingress CPL_RX_DATA messages, was
always sending an RX_DATA_ACK with the goal of updating the credits.
However, if the RDMA connection is moved out of FPDU mode abruptly,
then it is possible for iw_cxgb4 to process queued RX_DATA CPLs after HW
has aborted the connection.  These CPLs should not trigger RX_DATA_ACKS.
If they do, HW can see a READ after DELETE of the DB_LE hash entry for
the tid and post a LE_DB HashTblMemCrcError.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index f1510cc..9398143 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1804,20 +1804,21 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 	skb_trim(skb, dlen);
 	mutex_lock(&ep->com.mutex);
 
-	/* update RX credits */
-	update_rx_credits(ep, dlen);
-
 	switch (ep->com.state) {
 	case MPA_REQ_SENT:
+		update_rx_credits(ep, dlen);
 		ep->rcv_seq += dlen;
 		disconnect = process_mpa_reply(ep, skb);
 		break;
 	case MPA_REQ_WAIT:
+		update_rx_credits(ep, dlen);
 		ep->rcv_seq += dlen;
 		disconnect = process_mpa_request(ep, skb);
 		break;
 	case FPDU_MODE: {
 		struct c4iw_qp_attributes attrs;
+
+		update_rx_credits(ep, dlen);
 		BUG_ON(!ep->com.qp);
 		if (status)
 			pr_err("%s Unexpected streaming data." \
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

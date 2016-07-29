From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/2] iw_cxgb4: stop MPA_REPLY timer when disconnecting
Date: Fri, 29 Jul 2016 08:38:44 -0700
Message-ID: <fd768f36ff1747803c3f560d3007dc5764d4cc85.1469824142.git.swise@opengridcomputing.com>
References: <cover.1469824142.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1469824142.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There exists a race where the application can setup a connection
and then disconnect it before iw_cxgb4 processes the fw4_ack
message.  For passive side connections, the fw4_ack message is
used to know when to stop the ep timer for MPA_REPLY messages.

If the application disconnects before the fw4_ack is handled then
c4iw_ep_disconnect() needs to clean up the timer state and stop the
timer before restarting it for the disconnect timer.  Failure to do this
results in a "timer already started" message and a premature stopping
of the disconnect timer.

Fixes: e4b76a2 ("RDMA/iw_cxgb4: stop_ep_timer() after MPA negotiation")

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a3a6721..be00c4b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3011,9 +3011,9 @@ static int fw4_ack(struct c4iw_dev *dev, struct sk_buff *skb)
 		PDBG("%s last streaming msg ack ep %p tid %u state %u "
 		     "initiator %u freeing skb\n", __func__, ep, ep->hwtid,
 		     state_read(&ep->com), ep->mpa_attr.initiator ? 1 : 0);
+		mutex_lock(&ep->com.mutex);
 		kfree_skb(ep->mpa_skb);
 		ep->mpa_skb = NULL;
-		mutex_lock(&ep->com.mutex);
 		if (test_bit(STOP_MPA_TIMER, &ep->com.flags))
 			stop_ep_timer(ep);
 		mutex_unlock(&ep->com.mutex);
@@ -3582,6 +3582,16 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 			ep->com.state = ABORTING;
 		else {
 			ep->com.state = CLOSING;
+
+			/*
+			 * if we close before we see the fw4_ack() then we fix
+			 * up the timer state since we're reusing it.
+			 */
+			if (ep->mpa_skb &&
+			    test_bit(STOP_MPA_TIMER, &ep->com.flags)) {
+				clear_bit(STOP_MPA_TIMER, &ep->com.flags);
+				stop_ep_timer(ep);
+			}
 			start_ep_timer(ep);
 		}
 		set_bit(CLOSE_SENT, &ep->com.flags);
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

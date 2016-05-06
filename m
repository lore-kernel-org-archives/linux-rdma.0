From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 06/17] RDMA/iw_cxgb4: stop_ep_timer() after MPA negotiation
Date: Fri,  6 May 2016 22:17:59 +0530
Message-ID: <1462553290-16422-7-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

->Stop the ep timer after MPA negotiation so that the arp failures
during send_mpa_reply/reject will be handled by process_timeout() after
the ep timer expires.
->Added case MPA_REP_SENT in process_timeout().
->For MPA reject, c4iw_ep_disconnect tries to start an already started
timer, which leads to warning message "timer already started".
-> In case of mpa reject stop the timer and call send_mpa_reject().
-> Added new ep flag STOP_MPA_TIMER to tell fw4_ack() to stop the timer
only for send_mpa_reply(), which is set in c4iw_accept_cr().

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c       | 39 +++++++++++++++++-----------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  1 +
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c7b3d5751963..410154c86061 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1047,7 +1047,6 @@ static int send_mpa_reject(struct c4iw_ep *ep, const void *pdata, u8 plen)
 	 */
 	skb_get(skb);
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ep->txq_idx);
-	t4_set_arp_err_handler(skb, NULL, arp_failure_discard);
 	BUG_ON(ep->mpa_skb);
 	ep->mpa_skb = skb;
 	ep->snd_seq += mpalen;
@@ -1132,7 +1131,6 @@ static int send_mpa_reply(struct c4iw_ep *ep, const void *pdata, u8 plen)
 	 * Function fw4_ack() will deref it.
 	 */
 	skb_get(skb);
-	t4_set_arp_err_handler(skb, NULL, arp_failure_discard);
 	ep->mpa_skb = skb;
 	__state_set(&ep->com, MPA_REP_SENT);
 	ep->snd_seq += mpalen;
@@ -1744,25 +1742,17 @@ static int process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 	     ep->mpa_attr.xmit_marker_enabled, ep->mpa_attr.version,
 	     ep->mpa_attr.p2p_type);
 
-	/*
-	 * If the endpoint timer already expired, then we ignore
-	 * the start request.  process_timeout() will abort
-	 * the connection.
-	 */
-	if (!stop_ep_timer(ep)) {
-		__state_set(&ep->com, MPA_REQ_RCVD);
-
-		/* drive upcall */
-		mutex_lock_nested(&ep->parent_ep->com.mutex,
-				  SINGLE_DEPTH_NESTING);
-		if (ep->parent_ep->com.state != DEAD) {
-			if (connect_request_upcall(ep))
-				goto err_unlock_parent;
-		} else {
+	__state_set(&ep->com, MPA_REQ_RCVD);
+
+	/* drive upcall */
+	mutex_lock_nested(&ep->parent_ep->com.mutex, SINGLE_DEPTH_NESTING);
+	if (ep->parent_ep->com.state != DEAD) {
+		if (connect_request_upcall(ep))
 			goto err_unlock_parent;
-		}
-		mutex_unlock(&ep->parent_ep->com.mutex);
+	} else {
+		goto err_unlock_parent;
 	}
+	mutex_unlock(&ep->parent_ep->com.mutex);
 	return 0;
 
 err_unlock_parent:
@@ -2926,6 +2916,10 @@ static int fw4_ack(struct c4iw_dev *dev, struct sk_buff *skb)
 		     state_read(&ep->com), ep->mpa_attr.initiator ? 1 : 0);
 		kfree_skb(ep->mpa_skb);
 		ep->mpa_skb = NULL;
+		mutex_lock(&ep->com.mutex);
+		if (test_bit(STOP_MPA_TIMER, &ep->com.flags))
+			stop_ep_timer(ep);
+		mutex_unlock(&ep->com.mutex);
 	}
 	return 0;
 }
@@ -2952,8 +2946,10 @@ int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 		disconnect = 1;
 	}
 	mutex_unlock(&ep->com.mutex);
-	if (disconnect)
+	if (disconnect) {
+		stop_ep_timer(ep);
 		err = c4iw_ep_disconnect(ep, disconnect == 2, GFP_KERNEL);
+	}
 	c4iw_put_ep(&ep->com);
 	return 0;
 }
@@ -3047,6 +3043,8 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 			     ep->com.qp, mask, &attrs, 1);
 	if (err)
 		goto err_deref_cm_id;
+
+	set_bit(STOP_MPA_TIMER, &ep->com.flags);
 	err = send_mpa_reply(ep, conn_param->private_data,
 			     conn_param->private_data_len);
 	if (err)
@@ -3968,6 +3966,7 @@ static void process_timeout(struct c4iw_ep *ep)
 		connect_reply_upcall(ep, -ETIMEDOUT);
 		break;
 	case MPA_REQ_WAIT:
+	case MPA_REP_SENT:
 		__state_set(&ep->com, ABORTING);
 		break;
 	case CLOSING:
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 67710aeeb4f2..d4e2b519a192 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -755,6 +755,7 @@ enum c4iw_ep_flags {
 	CLOSE_SENT		= 3,
 	TIMEOUT                 = 4,
 	QP_REFERENCED           = 5,
+	STOP_MPA_TIMER		= 7,
 };
 
 enum c4iw_ep_history {
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 6/8] iw_cxgb4: lock around accept/reject downcalls
Date: Fri, 21 Mar 2014 20:40:35 +0530
Message-ID: <1395414637-8298-7-git-send-email-hariprasad@chelsio.com>
References: <1395414637-8298-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395414637-8298-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

There is a race between ULP threads doing an accept/reject, and the
ingress processing thread handling close/abort for the same connection.
The accept/reject path needs to hold the lock to serialize these paths.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a1bc41d..b8f9e75 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -760,7 +760,7 @@ static void send_mpa_req(struct c4iw_ep *ep, struct sk_buff *skb,
 	ep->mpa_skb = skb;
 	c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
 	start_ep_timer(ep);
-	state_set(&ep->com, MPA_REQ_SENT);
+	__state_set(&ep->com, MPA_REQ_SENT);
 	ep->mpa_attr.initiator = 1;
 	ep->snd_seq += mpalen;
 	return;
@@ -926,7 +926,7 @@ static int send_mpa_reply(struct c4iw_ep *ep, const void *pdata, u8 plen)
 	skb_get(skb);
 	t4_set_arp_err_handler(skb, NULL, arp_failure_discard);
 	ep->mpa_skb = skb;
-	state_set(&ep->com, MPA_REP_SENT);
+	__state_set(&ep->com, MPA_REP_SENT);
 	ep->snd_seq += mpalen;
 	return c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
 }
@@ -944,6 +944,7 @@ static int act_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	PDBG("%s ep %p tid %u snd_isn %u rcv_isn %u\n", __func__, ep, tid,
 	     be32_to_cpu(req->snd_isn), be32_to_cpu(req->rcv_isn));
 
+	mutex_lock(&ep->com.mutex);
 	dst_confirm(ep->dst);
 
 	/* setup the hwtid for this connection */
@@ -967,7 +968,7 @@ static int act_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 		send_mpa_req(ep, skb, 1);
 	else
 		send_mpa_req(ep, skb, mpa_rev);
-
+	mutex_unlock(&ep->com.mutex);
 	return 0;
 }
 
@@ -2511,22 +2512,28 @@ static int fw4_ack(struct c4iw_dev *dev, struct sk_buff *skb)
 
 int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 {
-	int err;
+	int err = 0;
+	int disconnect = 0;
 	struct c4iw_ep *ep = to_ep(cm_id);
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 
-	if (state_read(&ep->com) == DEAD) {
+
+	mutex_lock(&ep->com.mutex);
+	if (ep->com.state == DEAD) {
 		c4iw_put_ep(&ep->com);
 		return -ECONNRESET;
 	}
 	set_bit(ULP_REJECT, &ep->com.history);
-	BUG_ON(state_read(&ep->com) != MPA_REQ_RCVD);
+	BUG_ON(ep->com.state != MPA_REQ_RCVD);
 	if (mpa_rev == 0)
 		abort_connection(ep, NULL, GFP_KERNEL);
 	else {
 		err = send_mpa_reject(ep, pdata, pdata_len);
-		err = c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
+		disconnect = 1;
 	}
+	mutex_unlock(&ep->com.mutex);
+	if (disconnect)
+		err = c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
 	c4iw_put_ep(&ep->com);
 	return 0;
 }
@@ -2541,12 +2548,14 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct c4iw_qp *qp = get_qhp(h, conn_param->qpn);
 
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
-	if (state_read(&ep->com) == DEAD) {
+
+	mutex_lock(&ep->com.mutex);
+	if (ep->com.state == DEAD) {
 		err = -ECONNRESET;
 		goto err;
 	}
 
-	BUG_ON(state_read(&ep->com) != MPA_REQ_RCVD);
+	BUG_ON(ep->com.state != MPA_REQ_RCVD);
 	BUG_ON(!qp);
 
 	set_bit(ULP_ACCEPT, &ep->com.history);
@@ -2615,14 +2624,16 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (err)
 		goto err1;
 
-	state_set(&ep->com, FPDU_MODE);
+	__state_set(&ep->com, FPDU_MODE);
 	established_upcall(ep);
+	mutex_unlock(&ep->com.mutex);
 	c4iw_put_ep(&ep->com);
 	return 0;
 err1:
 	ep->com.cm_id = NULL;
 	cm_id->rem_ref(cm_id);
 err:
+	mutex_unlock(&ep->com.mutex);
 	c4iw_put_ep(&ep->com);
 	return err;
 }
-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

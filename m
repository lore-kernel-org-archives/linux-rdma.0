From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 5/9] RDMA/iw_cxgb4: free resources when send_flowc() fails
Date: Thu,  5 May 2016 01:27:33 +0530
Message-ID: <1462391857-20939-6-git-send-email-hariprasad@chelsio.com>
References: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462391857-20939-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c4ce707d210b..864da9dec9f6 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -519,7 +519,7 @@ static void abort_arp_failure(void *handle, struct sk_buff *skb)
 	c4iw_ofld_send(rdev, skb);
 }
 
-static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
+static int send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
 {
 	unsigned int flowclen = 80;
 	struct fw_flowc_wr *flowc;
@@ -575,7 +575,7 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
 	}
 
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ep->txq_idx);
-	c4iw_ofld_send(&ep->com.dev->rdev, skb);
+	return c4iw_ofld_send(&ep->com.dev->rdev, skb);
 }
 
 static int send_halfclose(struct c4iw_ep *ep, gfp_t gfp)
@@ -1119,6 +1119,7 @@ static int act_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	unsigned int tid = GET_TID(req);
 	unsigned int atid = TID_TID_G(ntohl(req->tos_atid));
 	struct tid_info *t = dev->rdev.lldi.tids;
+	int ret;
 
 	ep = lookup_atid(t, atid);
 
@@ -1144,13 +1145,20 @@ static int act_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	set_bit(ACT_ESTAB, &ep->com.history);
 
 	/* start MPA negotiation */
-	send_flowc(ep, NULL);
+	ret = send_flowc(ep, NULL);
+	if (ret)
+		goto err;
 	if (ep->retry_with_mpa_v1)
 		send_mpa_req(ep, skb, 1);
 	else
 		send_mpa_req(ep, skb, mpa_rev);
 	mutex_unlock(&ep->com.mutex);
 	return 0;
+err:
+	mutex_unlock(&ep->com.mutex);
+	connect_reply_upcall(ep, -ENOMEM);
+	c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
+	return 0;
 }
 
 static void close_complete_upcall(struct c4iw_ep *ep, int status)
@@ -2548,6 +2556,7 @@ static int pass_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct cpl_pass_establish *req = cplhdr(skb);
 	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(req);
+	int ret;
 
 	ep = lookup_tid(t, tid);
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
@@ -2560,10 +2569,14 @@ static int pass_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	set_emss(ep, ntohs(req->tcp_opt));
 
 	dst_confirm(ep->dst);
-	state_set(&ep->com, MPA_REQ_WAIT);
+	mutex_lock(&ep->com.mutex);
+	ep->com.state = MPA_REQ_WAIT;
 	start_ep_timer(ep);
-	send_flowc(ep, skb);
 	set_bit(PASS_ESTAB, &ep->com.history);
+	ret = send_flowc(ep, skb);
+	mutex_unlock(&ep->com.mutex);
+	if (ret)
+		c4iw_ep_disconnect(ep, 1, GFP_KERNEL);
 
 	return 0;
 }
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

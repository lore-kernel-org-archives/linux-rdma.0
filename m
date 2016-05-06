From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 04/17] RDMA/iw_cxgb4: parent_ep has to be dereferenced in case of passive accept failure
Date: Fri,  6 May 2016 22:17:57 +0530
Message-ID: <1462553290-16422-5-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

-> On passive side of connection parent_ep referenced during connection
request has to be dereferenced during the passive accept failure.
-> As passive accept failure error handlinglogic runs in atomic context,
the parent ep is dereferenced by scheduling work request.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e953f8fd36a0..cae1794cef83 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -453,8 +453,9 @@ static void arp_failure_discard(void *handle, struct sk_buff *skb)
 }
 
 enum {
-	NUM_FAKE_CPLS = 1,
+	NUM_FAKE_CPLS = 2,
 	FAKE_CPL_PUT_EP_SAFE = NUM_CPL_CMDS + 0,
+	FAKE_CPL_PASS_PUT_EP_SAFE = NUM_CPL_CMDS + 1,
 };
 
 static int _put_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
@@ -466,18 +467,29 @@ static int _put_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
 	return 0;
 }
 
+static int _put_pass_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
+{
+	struct c4iw_ep *ep;
+
+	ep = *((struct c4iw_ep **)(skb->cb + 2 * sizeof(void *)));
+	c4iw_put_ep(&ep->parent_ep->com);
+	release_ep_resources(ep);
+	return 0;
+}
+
 /*
  * Fake up a special CPL opcode and call sched() so process_work() will call
  * _put_ep_safe() in a safe context to free the ep resources.  This is needed
  * because ARP error handlers are called in an ATOMIC context, and
  * _c4iw_free_ep() needs to block.
  */
-static void queue_arp_failure_cpl(struct c4iw_ep *ep, struct sk_buff *skb)
+static void queue_arp_failure_cpl(struct c4iw_ep *ep, struct sk_buff *skb,
+				  int cpl)
 {
 	struct cpl_act_establish *rpl = cplhdr(skb);
 
 	/* Set our special ARP_FAILURE opcode */
-	rpl->ot.opcode = FAKE_CPL_PUT_EP_SAFE;
+	rpl->ot.opcode = cpl;
 
 	/*
 	 * Save ep in the skb->cb area, after where sched() will save the dev
@@ -496,7 +508,7 @@ static void pass_accept_rpl_arp_failure(void *handle, struct sk_buff *skb)
 	       ep->hwtid);
 
 	__state_set(&ep->com, DEAD);
-	queue_arp_failure_cpl(ep, skb);
+	queue_arp_failure_cpl(ep, skb, FAKE_CPL_PASS_PUT_EP_SAFE);
 }
 
 /*
@@ -517,7 +529,7 @@ static void act_open_req_arp_failure(void *handle, struct sk_buff *skb)
 	}
 	remove_handle(ep->com.dev, &ep->com.dev->atid_idr, ep->atid);
 	cxgb4_free_atid(ep->com.dev->rdev.lldi.tids, ep->atid);
-	queue_arp_failure_cpl(ep, skb);
+	queue_arp_failure_cpl(ep, skb, FAKE_CPL_PUT_EP_SAFE);
 }
 
 /*
@@ -3935,7 +3947,8 @@ static c4iw_handler_func work_handlers[NUM_CPL_CMDS + NUM_FAKE_CPLS] = {
 	[CPL_FW4_ACK] = fw4_ack,
 	[CPL_FW6_MSG] = deferred_fw6_msg,
 	[CPL_RX_PKT] = rx_pkt,
-	[FAKE_CPL_PUT_EP_SAFE] = _put_ep_safe
+	[FAKE_CPL_PUT_EP_SAFE] = _put_ep_safe,
+	[FAKE_CPL_PASS_PUT_EP_SAFE] = _put_pass_ep_safe
 };
 
 static void process_timeout(struct c4iw_ep *ep)
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

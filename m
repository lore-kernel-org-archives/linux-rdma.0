From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 1/9] RDMA/iw_cxgb4: release ep resources on accept arp failure
Date: Thu,  5 May 2016 01:27:29 +0530
Message-ID: <1462391857-20939-2-git-send-email-hariprasad@chelsio.com>
References: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462391857-20939-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If ARP fails before the CPL_PASS_ACCEPT_RPL is seen by hardware, the tid
will be stuck in SYN_PEND and never released.  So create an arp failure
handler specifically for this message to release the endpoint resources.

In pass_accept_rpl_arp_failure(), put the parent endpoint so it will
be freed when destroyed.  Also we don't need to call release_tid() here
because _c4iw_free_ep() calls cxgb4_remove_tid() which releases the
hwtid.

If we get an ABORT_REQ_RSS instead of a PASS_ESTABLISH (because the
peer's ACK to our SYN is never received), then put the parent as well
in peer_abort().

Treat accept_cr() failures just like arp failures: put the parent ep
and release the ep resources destroying the tid

The ARP failure handlers are called in an atomic context, so we need to
schedule some of the processing which might block.  Namely _c4iw_free_ep()
which needs a mutex.  So create a "special" CPL opcode and handler and
schedule it via sched() to be run by process_work() in a blockable context.

Also rework the active open arp failure handler to make use of
release_ep_resources().  This allows both the active and passive arp
failure handlers to use the same deferred cleanup function.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 82 ++++++++++++++++++++++++++++++++--------
 1 file changed, 66 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 651711370d55..49784a40d1d1 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -145,6 +145,7 @@ static struct sk_buff_head rxq;
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp);
 static void ep_timeout(unsigned long arg);
 static void connect_reply_upcall(struct c4iw_ep *ep, int status);
+static int sched(struct c4iw_dev *dev, struct sk_buff *skb);
 
 static LIST_HEAD(timeout_list);
 static spinlock_t timeout_lock;
@@ -295,7 +296,7 @@ void _c4iw_free_ep(struct kref *kref)
 	struct c4iw_ep *ep;
 
 	ep = container_of(kref, struct c4iw_ep, com.kref);
-	PDBG("%s ep %p state %s\n", __func__, ep, states[state_read(&ep->com)]);
+	PDBG("%s ep %p state %s\n", __func__, ep, states[ep->com.state]);
 	if (test_bit(QP_REFERENCED, &ep->com.flags))
 		deref_qp(ep);
 	if (test_bit(RELEASE_RESOURCES, &ep->com.flags)) {
@@ -432,10 +433,57 @@ static struct dst_entry *find_route(struct c4iw_dev *dev, __be32 local_ip,
 
 static void arp_failure_discard(void *handle, struct sk_buff *skb)
 {
-	PDBG("%s c4iw_dev %p\n", __func__, handle);
+	pr_err(MOD "ARP failure\n");
 	kfree_skb(skb);
 }
 
+enum {
+	NUM_FAKE_CPLS = 1,
+	FAKE_CPL_PUT_EP_SAFE = NUM_CPL_CMDS + 0,
+};
+
+static int _put_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
+{
+	struct c4iw_ep *ep;
+
+	ep = *((struct c4iw_ep **)(skb->cb + 2 * sizeof(void *)));
+	release_ep_resources(ep);
+	return 0;
+}
+
+/*
+ * Fake up a special CPL opcode and call sched() so process_work() will call
+ * _put_ep_safe() in a safe context to free the ep resources.  This is needed
+ * because ARP error handlers are called in an ATOMIC context, and
+ * _c4iw_free_ep() needs to block.
+ */
+static void queue_arp_failure_cpl(struct c4iw_ep *ep, struct sk_buff *skb)
+{
+	struct cpl_act_establish *rpl = cplhdr(skb);
+
+	/* Set our special ARP_FAILURE opcode */
+	rpl->ot.opcode = FAKE_CPL_PUT_EP_SAFE;
+
+	/*
+	 * Save ep in the skb->cb area, after where sched() will save the dev
+	 * ptr.
+	 */
+	*((struct c4iw_ep **)(skb->cb + 2 * sizeof(void *))) = ep;
+	sched(ep->com.dev, skb);
+}
+
+/* Handle an ARP failure for an accept */
+static void pass_accept_rpl_arp_failure(void *handle, struct sk_buff *skb)
+{
+	struct c4iw_ep *ep = handle;
+
+	pr_err(MOD "ARP failure during accept - tid %u -dropping connection\n",
+	       ep->hwtid);
+
+	__state_set(&ep->com, DEAD);
+	queue_arp_failure_cpl(ep, skb);
+}
+
 /*
  * Handle an ARP failure for an active open.
  */
@@ -444,9 +492,8 @@ static void act_open_req_arp_failure(void *handle, struct sk_buff *skb)
 	struct c4iw_ep *ep = handle;
 
 	printk(KERN_ERR MOD "ARP failure during connect\n");
-	kfree_skb(skb);
 	connect_reply_upcall(ep, -EHOSTUNREACH);
-	state_set(&ep->com, DEAD);
+	__state_set(&ep->com, DEAD);
 	if (ep->com.remote_addr.ss_family == AF_INET6) {
 		struct sockaddr_in6 *sin6 =
 			(struct sockaddr_in6 *)&ep->com.local_addr;
@@ -455,9 +502,7 @@ static void act_open_req_arp_failure(void *handle, struct sk_buff *skb)
 	}
 	remove_handle(ep->com.dev, &ep->com.dev->atid_idr, ep->atid);
 	cxgb4_free_atid(ep->com.dev->rdev.lldi.tids, ep->atid);
-	dst_release(ep->dst);
-	cxgb4_l2t_release(ep->l2t);
-	c4iw_put_ep(&ep->com);
+	queue_arp_failure_cpl(ep, skb);
 }
 
 /*
@@ -2198,8 +2243,8 @@ static int close_listsrv_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	return 0;
 }
 
-static void accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
-		      struct cpl_pass_accept_req *req)
+static int accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
+		     struct cpl_pass_accept_req *req)
 {
 	struct cpl_pass_accept_rpl *rpl;
 	unsigned int mtu_idx;
@@ -2287,10 +2332,9 @@ static void accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 	rpl->opt0 = cpu_to_be64(opt0);
 	rpl->opt2 = cpu_to_be32(opt2);
 	set_wr_txq(skb, CPL_PRIORITY_SETUP, ep->ctrlq_idx);
-	t4_set_arp_err_handler(skb, NULL, arp_failure_discard);
-	c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
+	t4_set_arp_err_handler(skb, ep, pass_accept_rpl_arp_failure);
 
-	return;
+	return c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
 }
 
 static void reject_cr(struct c4iw_dev *dev, u32 hwtid, struct sk_buff *skb)
@@ -2469,8 +2513,12 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	init_timer(&child_ep->timer);
 	cxgb4_insert_tid(t, child_ep, hwtid);
 	insert_handle(dev, &dev->hwtid_idr, child_ep, child_ep->hwtid);
-	accept_cr(child_ep, skb, req);
-	set_bit(PASS_ACCEPT_REQ, &child_ep->com.history);
+	if (accept_cr(child_ep, skb, req)) {
+		c4iw_put_ep(&parent_ep->com);
+		release_ep_resources(child_ep);
+	} else {
+		set_bit(PASS_ACCEPT_REQ, &child_ep->com.history);
+	}
 	if (iptype == 6) {
 		sin6 = (struct sockaddr_in6 *)&child_ep->com.local_addr;
 		cxgb4_clip_get(child_ep->com.dev->rdev.lldi.ports[0],
@@ -2633,6 +2681,7 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 	mutex_lock(&ep->com.mutex);
 	switch (ep->com.state) {
 	case CONNECTING:
+		c4iw_put_ep(&ep->parent_ep->com);
 		break;
 	case MPA_REQ_WAIT:
 		(void)stop_ep_timer(ep);
@@ -3809,7 +3858,7 @@ reject:
  * These are the real handlers that are called from a
  * work queue.
  */
-static c4iw_handler_func work_handlers[NUM_CPL_CMDS] = {
+static c4iw_handler_func work_handlers[NUM_CPL_CMDS + NUM_FAKE_CPLS] = {
 	[CPL_ACT_ESTABLISH] = act_establish,
 	[CPL_ACT_OPEN_RPL] = act_open_rpl,
 	[CPL_RX_DATA] = rx_data,
@@ -3825,7 +3874,8 @@ static c4iw_handler_func work_handlers[NUM_CPL_CMDS] = {
 	[CPL_RDMA_TERMINATE] = terminate,
 	[CPL_FW4_ACK] = fw4_ack,
 	[CPL_FW6_MSG] = deferred_fw6_msg,
-	[CPL_RX_PKT] = rx_pkt
+	[CPL_RX_PKT] = rx_pkt,
+	[FAKE_CPL_PUT_EP_SAFE] = _put_ep_safe
 };
 
 static void process_timeout(struct c4iw_ep *ep)
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: Shrink .text with compile-time init of handlers arrays
Date: Wed, 28 Apr 2010 12:10:21 -0700
Message-ID: <adaiq7b1jhe.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Steve,

What do you think about this for the next merge window?  I think it
arguably makes the source cleaner, and it definitely makes the compiled
code better:

add/remove: 0/1 grow/shrink: 4/3 up/down: 4/-1682 (-1678)
function                                     old     new   delta
tx_ack                                       167     168      +1
state_set                                     55      56      +1
start_ep_timer                                99     100      +1
pass_establish                               177     178      +1
act_open_req_arp_failure                      39      38      -1
sched                                         84      82      -2
iwch_cm_init                                 442      91    -351
work_handlers                               1328       -   -1328
---
 drivers/infiniband/hw/cxgb3/iwch.c    |    2 -
 drivers/infiniband/hw/cxgb3/iwch_cm.c |  131 +++++++++++++++++----------------
 2 files changed, 67 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index 63f975f..8e77dc5 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -47,8 +47,6 @@ MODULE_DESCRIPTION("Chelsio T3 RDMA Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(DRV_VERSION);
 
-cxgb3_cpl_handler_func t3c_handlers[NUM_CPL_CMDS];
-
 static void open_rnic_dev(struct t3cdev *);
 static void close_rnic_dev(struct t3cdev *);
 static void iwch_event_handler(struct t3cdev *, u32, u32);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index cfd6db0..f2d2c29 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -102,12 +102,9 @@ static unsigned int cong_flavor = 1;
 module_param(cong_flavor, uint, 0644);
 MODULE_PARM_DESC(cong_flavor, "TCP Congestion control flavor (default=1)");
 
-static void process_work(struct work_struct *work);
 static struct workqueue_struct *workq;
-static DECLARE_WORK(skb_work, process_work);
 
 static struct sk_buff_head rxq;
-static cxgb3_cpl_handler_func work_handlers[NUM_CPL_CMDS];
 
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp);
 static void ep_timeout(unsigned long arg);
@@ -302,27 +299,6 @@ static void release_ep_resources(struct iwch_ep *ep)
 	put_ep(&ep->com);
 }
 
-static void process_work(struct work_struct *work)
-{
-	struct sk_buff *skb = NULL;
-	void *ep;
-	struct t3cdev *tdev;
-	int ret;
-
-	while ((skb = skb_dequeue(&rxq))) {
-		ep = *((void **) (skb->cb));
-		tdev = *((struct t3cdev **) (skb->cb + sizeof(void *)));
-		ret = work_handlers[G_OPCODE(ntohl((__force __be32)skb->csum))](tdev, skb, ep);
-		if (ret & CPL_RET_BUF_DONE)
-			kfree_skb(skb);
-
-		/*
-		 * ep was referenced in sched(), and is freed here.
-		 */
-		put_ep((struct iwch_ep_common *)ep);
-	}
-}
-
 static int status2errno(int status)
 {
 	switch (status) {
@@ -2158,6 +2134,50 @@ int iwch_ep_redirect(void *ctx, struct dst_entry *old, struct dst_entry *new,
 /*
  * All the CM events are handled on a work queue to have a safe context.
  */
+/*
+ * These are the real handlers that are called from a work queue.
+ */
+static const cxgb3_cpl_handler_func work_handlers[NUM_CPL_CMDS] = {
+	[CPL_ACT_ESTABLISH]	= act_establish,
+	[CPL_ACT_OPEN_RPL]	= act_open_rpl,
+	[CPL_RX_DATA]		= rx_data,
+	[CPL_TX_DMA_ACK]	= tx_ack,
+	[CPL_ABORT_RPL_RSS]	= abort_rpl,
+	[CPL_ABORT_RPL]		= abort_rpl,
+	[CPL_PASS_OPEN_RPL]	= pass_open_rpl,
+	[CPL_CLOSE_LISTSRV_RPL]	= close_listsrv_rpl,
+	[CPL_PASS_ACCEPT_REQ]	= pass_accept_req,
+	[CPL_PASS_ESTABLISH]	= pass_establish,
+	[CPL_PEER_CLOSE]	= peer_close,
+	[CPL_ABORT_REQ_RSS]	= peer_abort,
+	[CPL_CLOSE_CON_RPL]	= close_con_rpl,
+	[CPL_RDMA_TERMINATE]	= terminate,
+	[CPL_RDMA_EC_STATUS]	= ec_status,
+};
+
+static void process_work(struct work_struct *work)
+{
+	struct sk_buff *skb = NULL;
+	void *ep;
+	struct t3cdev *tdev;
+	int ret;
+
+	while ((skb = skb_dequeue(&rxq))) {
+		ep = *((void **) (skb->cb));
+		tdev = *((struct t3cdev **) (skb->cb + sizeof(void *)));
+		ret = work_handlers[G_OPCODE(ntohl((__force __be32)skb->csum))](tdev, skb, ep);
+		if (ret & CPL_RET_BUF_DONE)
+			kfree_skb(skb);
+
+		/*
+		 * ep was referenced in sched(), and is freed here.
+		 */
+		put_ep((struct iwch_ep_common *)ep);
+	}
+}
+
+static DECLARE_WORK(skb_work, process_work);
+
 static int sched(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 {
 	struct iwch_ep_common *epc = ctx;
@@ -2189,6 +2209,29 @@ static int set_tcb_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	return CPL_RET_BUF_DONE;
 }
 
+/*
+ * All upcalls from the T3 Core go to sched() to schedule the
+ * processing on a work queue.
+ */
+cxgb3_cpl_handler_func t3c_handlers[NUM_CPL_CMDS] = {
+	[CPL_ACT_ESTABLISH]	= sched,
+	[CPL_ACT_OPEN_RPL]	= sched,
+	[CPL_RX_DATA]		= sched,
+	[CPL_TX_DMA_ACK]	= sched,
+	[CPL_ABORT_RPL_RSS]	= sched,
+	[CPL_ABORT_RPL]		= sched,
+	[CPL_PASS_OPEN_RPL]	= sched,
+	[CPL_CLOSE_LISTSRV_RPL]	= sched,
+	[CPL_PASS_ACCEPT_REQ]	= sched,
+	[CPL_PASS_ESTABLISH]	= sched,
+	[CPL_PEER_CLOSE]	= sched,
+	[CPL_CLOSE_CON_RPL]	= sched,
+	[CPL_ABORT_REQ_RSS]	= sched,
+	[CPL_RDMA_TERMINATE]	= sched,
+	[CPL_RDMA_EC_STATUS]	= sched,
+	[CPL_SET_TCB_RPL]	= set_tcb_rpl,
+};
+
 int __init iwch_cm_init(void)
 {
 	skb_queue_head_init(&rxq);
@@ -2197,46 +2240,6 @@ int __init iwch_cm_init(void)
 	if (!workq)
 		return -ENOMEM;
 
-	/*
-	 * All upcalls from the T3 Core go to sched() to
-	 * schedule the processing on a work queue.
-	 */
-	t3c_handlers[CPL_ACT_ESTABLISH] = sched;
-	t3c_handlers[CPL_ACT_OPEN_RPL] = sched;
-	t3c_handlers[CPL_RX_DATA] = sched;
-	t3c_handlers[CPL_TX_DMA_ACK] = sched;
-	t3c_handlers[CPL_ABORT_RPL_RSS] = sched;
-	t3c_handlers[CPL_ABORT_RPL] = sched;
-	t3c_handlers[CPL_PASS_OPEN_RPL] = sched;
-	t3c_handlers[CPL_CLOSE_LISTSRV_RPL] = sched;
-	t3c_handlers[CPL_PASS_ACCEPT_REQ] = sched;
-	t3c_handlers[CPL_PASS_ESTABLISH] = sched;
-	t3c_handlers[CPL_PEER_CLOSE] = sched;
-	t3c_handlers[CPL_CLOSE_CON_RPL] = sched;
-	t3c_handlers[CPL_ABORT_REQ_RSS] = sched;
-	t3c_handlers[CPL_RDMA_TERMINATE] = sched;
-	t3c_handlers[CPL_RDMA_EC_STATUS] = sched;
-	t3c_handlers[CPL_SET_TCB_RPL] = set_tcb_rpl;
-
-	/*
-	 * These are the real handlers that are called from a
-	 * work queue.
-	 */
-	work_handlers[CPL_ACT_ESTABLISH] = act_establish;
-	work_handlers[CPL_ACT_OPEN_RPL] = act_open_rpl;
-	work_handlers[CPL_RX_DATA] = rx_data;
-	work_handlers[CPL_TX_DMA_ACK] = tx_ack;
-	work_handlers[CPL_ABORT_RPL_RSS] = abort_rpl;
-	work_handlers[CPL_ABORT_RPL] = abort_rpl;
-	work_handlers[CPL_PASS_OPEN_RPL] = pass_open_rpl;
-	work_handlers[CPL_CLOSE_LISTSRV_RPL] = close_listsrv_rpl;
-	work_handlers[CPL_PASS_ACCEPT_REQ] = pass_accept_req;
-	work_handlers[CPL_PASS_ESTABLISH] = pass_establish;
-	work_handlers[CPL_PEER_CLOSE] = peer_close;
-	work_handlers[CPL_ABORT_REQ_RSS] = peer_abort;
-	work_handlers[CPL_CLOSE_CON_RPL] = close_con_rpl;
-	work_handlers[CPL_RDMA_TERMINATE] = terminate;
-	work_handlers[CPL_RDMA_EC_STATUS] = ec_status;
 	return 0;
 }
 

-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/7] RDMA/cxgb4: shrink .text with compile-time init of
	handlers arrays
Date: Thu, 06 May 2010 18:06:25 -0500
Message-ID: <20100506230625.25362.70354.stgit@build.ogc.int>
References: <20100506230619.25362.97591.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506230619.25362.97591.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |  189 +++++++++++++++++++-------------------
 1 files changed, 96 insertions(+), 93 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index cf6dbf4..85418f3 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -117,13 +117,9 @@ static int snd_win = 32 * 1024;
 module_param(snd_win, int, 0644);
 MODULE_PARM_DESC(snd_win, "TCP send window in bytes (default=32KB)");
 
-static void process_work(struct work_struct *work);
 static struct workqueue_struct *workq;
-static DECLARE_WORK(skb_work, process_work);
 
 static struct sk_buff_head rxq;
-static c4iw_handler_func work_handlers[NUM_CPL_CMDS];
-c4iw_handler_func c4iw_handlers[NUM_CPL_CMDS];
 
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp);
 static void ep_timeout(unsigned long arg);
@@ -275,26 +271,6 @@ static void release_ep_resources(struct c4iw_ep *ep)
 	c4iw_put_ep(&ep->com);
 }
 
-static void process_work(struct work_struct *work)
-{
-	struct sk_buff *skb = NULL;
-	struct c4iw_dev *dev;
-	struct cpl_act_establish *rpl = cplhdr(skb);
-	unsigned int opcode;
-	int ret;
-
-	while ((skb = skb_dequeue(&rxq))) {
-		rpl = cplhdr(skb);
-		dev = *((struct c4iw_dev **) (skb->cb + sizeof(void *)));
-		opcode = rpl->ot.opcode;
-
-		BUG_ON(!work_handlers[opcode]);
-		ret = work_handlers[opcode](dev, skb);
-		if (!ret)
-			kfree_skb(skb);
-	}
-}
-
 static int status2errno(int status)
 {
 	switch (status) {
@@ -1799,36 +1775,6 @@ static int fw4_ack(struct c4iw_dev *dev, struct sk_buff *skb)
 	return 0;
 }
 
-static int fw6_msg(struct c4iw_dev *dev, struct sk_buff *skb)
-{
-	struct cpl_fw6_msg *rpl = cplhdr(skb);
-	struct c4iw_wr_wait *wr_waitp;
-	int ret;
-
-	PDBG("%s type %u\n", __func__, rpl->type);
-
-	switch (rpl->type) {
-	case 1:
-		ret = (int)((be64_to_cpu(rpl->data[0]) >> 8) & 0xff);
-		wr_waitp = (__force struct c4iw_wr_wait *)rpl->data[1];
-		PDBG("%s wr_waitp %p ret %u\n", __func__, wr_waitp, ret);
-		if (wr_waitp) {
-			wr_waitp->ret = ret;
-			wr_waitp->done = 1;
-			wake_up(&wr_waitp->wait);
-		}
-		break;
-	case 2:
-		c4iw_ev_dispatch(dev, (struct t4_cqe *)&rpl->data[0]);
-		break;
-	default:
-		printk(KERN_ERR MOD "%s unexpected fw6 msg type %u\n", __func__,
-		       rpl->type);
-		break;
-	}
-	return 0;
-}
-
 static void ep_timeout(unsigned long arg)
 {
 	struct c4iw_ep *ep = (struct c4iw_ep *)arg;
@@ -2253,6 +2199,49 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 }
 
 /*
+ * These are the real handlers that are called from a
+ * work queue.
+ */
+static c4iw_handler_func work_handlers[NUM_CPL_CMDS] = {
+	[CPL_ACT_ESTABLISH] = act_establish,
+	[CPL_ACT_OPEN_RPL] = act_open_rpl,
+	[CPL_RX_DATA] = rx_data,
+	[CPL_ABORT_RPL_RSS] = abort_rpl,
+	[CPL_ABORT_RPL] = abort_rpl,
+	[CPL_PASS_OPEN_RPL] = pass_open_rpl,
+	[CPL_CLOSE_LISTSRV_RPL] = close_listsrv_rpl,
+	[CPL_PASS_ACCEPT_REQ] = pass_accept_req,
+	[CPL_PASS_ESTABLISH] = pass_establish,
+	[CPL_PEER_CLOSE] = peer_close,
+	[CPL_ABORT_REQ_RSS] = peer_abort,
+	[CPL_CLOSE_CON_RPL] = close_con_rpl,
+	[CPL_RDMA_TERMINATE] = terminate,
+	[CPL_FW4_ACK] = fw4_ack
+};
+
+static void process_work(struct work_struct *work)
+{
+	struct sk_buff *skb = NULL;
+	struct c4iw_dev *dev;
+	struct cpl_act_establish *rpl = cplhdr(skb);
+	unsigned int opcode;
+	int ret;
+
+	while ((skb = skb_dequeue(&rxq))) {
+		rpl = cplhdr(skb);
+		dev = *((struct c4iw_dev **) (skb->cb + sizeof(void *)));
+		opcode = rpl->ot.opcode;
+
+		BUG_ON(!work_handlers[opcode]);
+		ret = work_handlers[opcode](dev, skb);
+		if (!ret)
+			kfree_skb(skb);
+	}
+}
+
+static DECLARE_WORK(skb_work, process_work);
+
+/*
  * All the CM events are handled on a work queue to have a safe context.
  */
 static int sched(struct c4iw_dev *dev, struct sk_buff *skb)
@@ -2282,6 +2271,59 @@ static int set_tcb_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	return 0;
 }
 
+static int fw6_msg(struct c4iw_dev *dev, struct sk_buff *skb)
+{
+	struct cpl_fw6_msg *rpl = cplhdr(skb);
+	struct c4iw_wr_wait *wr_waitp;
+	int ret;
+
+	PDBG("%s type %u\n", __func__, rpl->type);
+
+	switch (rpl->type) {
+	case 1:
+		ret = (int)((be64_to_cpu(rpl->data[0]) >> 8) & 0xff);
+		wr_waitp = (__force struct c4iw_wr_wait *)rpl->data[1];
+		PDBG("%s wr_waitp %p ret %u\n", __func__, wr_waitp, ret);
+		if (wr_waitp) {
+			wr_waitp->ret = ret;
+			wr_waitp->done = 1;
+			wake_up(&wr_waitp->wait);
+		}
+		break;
+	case 2:
+		c4iw_ev_dispatch(dev, (struct t4_cqe *)&rpl->data[0]);
+		break;
+	default:
+		printk(KERN_ERR MOD "%s unexpected fw6 msg type %u\n", __func__,
+		       rpl->type);
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Most upcalls from the T4 Core go to sched() to
+ * schedule the processing on a work queue.
+ */
+c4iw_handler_func c4iw_handlers[NUM_CPL_CMDS] = {
+	[CPL_ACT_ESTABLISH] = sched,
+	[CPL_ACT_OPEN_RPL] = sched,
+	[CPL_RX_DATA] = sched,
+	[CPL_ABORT_RPL_RSS] = sched,
+	[CPL_ABORT_RPL] = sched,
+	[CPL_PASS_OPEN_RPL] = sched,
+	[CPL_CLOSE_LISTSRV_RPL] = sched,
+	[CPL_PASS_ACCEPT_REQ] = sched,
+	[CPL_PASS_ESTABLISH] = sched,
+	[CPL_PEER_CLOSE] = sched,
+	[CPL_CLOSE_CON_RPL] = sched,
+	[CPL_ABORT_REQ_RSS] = sched,
+	[CPL_RDMA_TERMINATE] = sched,
+	[CPL_FW4_ACK] = sched,
+	[CPL_SET_TCB_RPL] = set_tcb_rpl,
+	[CPL_FW6_MSG] = fw6_msg
+};
+
 int __init c4iw_cm_init(void)
 {
 	skb_queue_head_init(&rxq);
@@ -2290,45 +2332,6 @@ int __init c4iw_cm_init(void)
 	if (!workq)
 		return -ENOMEM;
 
-	/*
-	 * Most upcalls from the T4 Core go to sched() to
-	 * schedule the processing on a work queue.
-	 */
-	c4iw_handlers[CPL_ACT_ESTABLISH] = sched;
-	c4iw_handlers[CPL_ACT_OPEN_RPL] = sched;
-	c4iw_handlers[CPL_RX_DATA] = sched;
-	c4iw_handlers[CPL_ABORT_RPL_RSS] = sched;
-	c4iw_handlers[CPL_ABORT_RPL] = sched;
-	c4iw_handlers[CPL_PASS_OPEN_RPL] = sched;
-	c4iw_handlers[CPL_CLOSE_LISTSRV_RPL] = sched;
-	c4iw_handlers[CPL_PASS_ACCEPT_REQ] = sched;
-	c4iw_handlers[CPL_PASS_ESTABLISH] = sched;
-	c4iw_handlers[CPL_PEER_CLOSE] = sched;
-	c4iw_handlers[CPL_CLOSE_CON_RPL] = sched;
-	c4iw_handlers[CPL_ABORT_REQ_RSS] = sched;
-	c4iw_handlers[CPL_RDMA_TERMINATE] = sched;
-	c4iw_handlers[CPL_FW4_ACK] = sched;
-	c4iw_handlers[CPL_SET_TCB_RPL] = set_tcb_rpl;
-	c4iw_handlers[CPL_FW6_MSG] = fw6_msg;
-
-	/*
-	 * These are the real handlers that are called from a
-	 * work queue.
-	 */
-	work_handlers[CPL_ACT_ESTABLISH] = act_establish;
-	work_handlers[CPL_ACT_OPEN_RPL] = act_open_rpl;
-	work_handlers[CPL_RX_DATA] = rx_data;
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
-	work_handlers[CPL_FW4_ACK] = fw4_ack;
 	return 0;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

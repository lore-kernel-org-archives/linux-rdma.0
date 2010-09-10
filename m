From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 10/11] RDMA/cxgb4: Use a mutex for QP and EP state
	transitions.
Date: Fri, 10 Sep 2010 11:15:36 -0500
Message-ID: <20100910161535.6829.33660.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move the connection setup/teardown paths to the workq thread removing
spin lock/irq disable requirements for these paths.  This allows calls
down to the LLD for EP and QP state transition actions to be atomic
with respect to processing CPL messages coming up from the HW.  Namely,
calls to rdma_init() and rdma_fini() can now be called with the mutex
held avoiding many race conditions with the abort path.

The QP spinlock is still used but only to manipulate the qp state.  This
allows the fastpaths, poll, post_send, and pos_recv, to run in the
irq context.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |   87 +++++++++++++++----------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    4 +
 drivers/infiniband/hw/cxgb4/qp.c       |   90 +++++++++++++++-----------------
 3 files changed, 88 insertions(+), 93 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 5547b49..3e6234c 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -219,12 +219,11 @@ static void set_emss(struct c4iw_ep *ep, u16 opt)
 
 static enum c4iw_ep_state state_read(struct c4iw_ep_common *epc)
 {
-	unsigned long flags;
 	enum c4iw_ep_state state;
 
-	spin_lock_irqsave(&epc->lock, flags);
+	mutex_lock(&epc->mutex);
 	state = epc->state;
-	spin_unlock_irqrestore(&epc->lock, flags);
+	mutex_unlock(&epc->mutex);
 	return state;
 }
 
@@ -235,12 +234,10 @@ static void __state_set(struct c4iw_ep_common *epc, enum c4iw_ep_state new)
 
 static void state_set(struct c4iw_ep_common *epc, enum c4iw_ep_state new)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&epc->lock, flags);
+	mutex_lock(&epc->mutex);
 	PDBG("%s - %s -> %s\n", __func__, states[epc->state], states[new]);
 	__state_set(epc, new);
-	spin_unlock_irqrestore(&epc->lock, flags);
+	mutex_unlock(&epc->mutex);
 	return;
 }
 
@@ -251,7 +248,7 @@ static void *alloc_ep(int size, gfp_t gfp)
 	epc = kzalloc(size, gfp);
 	if (epc) {
 		kref_init(&epc->kref);
-		spin_lock_init(&epc->lock);
+		mutex_init(&epc->mutex);
 		c4iw_init_wr_wait(&epc->wr_wait);
 	}
 	PDBG("%s alloc ep %p\n", __func__, epc);
@@ -1131,7 +1128,6 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 {
 	struct c4iw_ep *ep;
 	struct cpl_abort_rpl_rss *rpl = cplhdr(skb);
-	unsigned long flags;
 	int release = 0;
 	unsigned int tid = GET_TID(rpl);
 	struct tid_info *t = dev->rdev.lldi.tids;
@@ -1139,7 +1135,7 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	ep = lookup_tid(t, tid);
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 	BUG_ON(!ep);
-	spin_lock_irqsave(&ep->com.lock, flags);
+	mutex_lock(&ep->com.mutex);
 	switch (ep->com.state) {
 	case ABORTING:
 		__state_set(&ep->com, DEAD);
@@ -1150,7 +1146,7 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 		     __func__, ep, ep->com.state);
 		break;
 	}
-	spin_unlock_irqrestore(&ep->com.lock, flags);
+	mutex_unlock(&ep->com.mutex);
 
 	if (release)
 		release_ep_resources(ep);
@@ -1478,7 +1474,6 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct cpl_peer_close *hdr = cplhdr(skb);
 	struct c4iw_ep *ep;
 	struct c4iw_qp_attributes attrs;
-	unsigned long flags;
 	int disconnect = 1;
 	int release = 0;
 	int closing = 0;
@@ -1489,7 +1484,7 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 	dst_confirm(ep->dst);
 
-	spin_lock_irqsave(&ep->com.lock, flags);
+	mutex_lock(&ep->com.mutex);
 	switch (ep->com.state) {
 	case MPA_REQ_WAIT:
 		__state_set(&ep->com, CLOSING);
@@ -1550,7 +1545,7 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 	default:
 		BUG_ON(1);
 	}
-	spin_unlock_irqrestore(&ep->com.lock, flags);
+	mutex_unlock(&ep->com.mutex);
 	if (closing) {
 		attrs.next_state = C4IW_QP_STATE_CLOSING;
 		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
@@ -1581,7 +1576,6 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct c4iw_qp_attributes attrs;
 	int ret;
 	int release = 0;
-	unsigned long flags;
 	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(req);
 
@@ -1591,9 +1585,17 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		     ep->hwtid);
 		return 0;
 	}
-	spin_lock_irqsave(&ep->com.lock, flags);
 	PDBG("%s ep %p tid %u state %u\n", __func__, ep, ep->hwtid,
 	     ep->com.state);
+
+	/*
+	 * Wake up any threads in rdma_init() or rdma_fini().
+	 */
+	ep->com.wr_wait.done = 1;
+	ep->com.wr_wait.ret = -ECONNRESET;
+	wake_up(&ep->com.wr_wait.wait);
+
+	mutex_lock(&ep->com.mutex);
 	switch (ep->com.state) {
 	case CONNECTING:
 		break;
@@ -1605,23 +1607,8 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		connect_reply_upcall(ep, -ECONNRESET);
 		break;
 	case MPA_REP_SENT:
-		ep->com.wr_wait.done = 1;
-		ep->com.wr_wait.ret = -ECONNRESET;
-		PDBG("waking up ep %p\n", ep);
-		wake_up(&ep->com.wr_wait.wait);
 		break;
 	case MPA_REQ_RCVD:
-
-		/*
-		 * We're gonna mark this puppy DEAD, but keep
-		 * the reference on it until the ULP accepts or
-		 * rejects the CR. Also wake up anyone waiting
-		 * in rdma connection migration (see c4iw_accept_cr()).
-		 */
-		ep->com.wr_wait.done = 1;
-		ep->com.wr_wait.ret = -ECONNRESET;
-		PDBG("waking up ep %p tid %u\n", ep, ep->hwtid);
-		wake_up(&ep->com.wr_wait.wait);
 		break;
 	case MORIBUND:
 	case CLOSING:
@@ -1644,7 +1631,7 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		break;
 	case DEAD:
 		PDBG("%s PEER_ABORT IN DEAD STATE!!!!\n", __func__);
-		spin_unlock_irqrestore(&ep->com.lock, flags);
+		mutex_unlock(&ep->com.mutex);
 		return 0;
 	default:
 		BUG_ON(1);
@@ -1655,7 +1642,7 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		__state_set(&ep->com, DEAD);
 		release = 1;
 	}
-	spin_unlock_irqrestore(&ep->com.lock, flags);
+	mutex_unlock(&ep->com.mutex);
 
 	rpl_skb = get_skb(skb, sizeof(*rpl), GFP_KERNEL);
 	if (!rpl_skb) {
@@ -1681,7 +1668,6 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct c4iw_ep *ep;
 	struct c4iw_qp_attributes attrs;
 	struct cpl_close_con_rpl *rpl = cplhdr(skb);
-	unsigned long flags;
 	int release = 0;
 	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(rpl);
@@ -1692,7 +1678,7 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	BUG_ON(!ep);
 
 	/* The cm_id may be null if we failed to connect */
-	spin_lock_irqsave(&ep->com.lock, flags);
+	mutex_lock(&ep->com.mutex);
 	switch (ep->com.state) {
 	case CLOSING:
 		__state_set(&ep->com, MORIBUND);
@@ -1717,7 +1703,7 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 		BUG_ON(1);
 		break;
 	}
-	spin_unlock_irqrestore(&ep->com.lock, flags);
+	mutex_unlock(&ep->com.mutex);
 	if (release)
 		release_ep_resources(ep);
 	return 0;
@@ -2093,12 +2079,11 @@ done:
 int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 {
 	int ret = 0;
-	unsigned long flags;
 	int close = 0;
 	int fatal = 0;
 	struct c4iw_rdev *rdev;
 
-	spin_lock_irqsave(&ep->com.lock, flags);
+	mutex_lock(&ep->com.mutex);
 
 	PDBG("%s ep %p state %s, abrupt %d\n", __func__, ep,
 	     states[ep->com.state], abrupt);
@@ -2145,7 +2130,7 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 		break;
 	}
 
-	spin_unlock_irqrestore(&ep->com.lock, flags);
+	mutex_unlock(&ep->com.mutex);
 	if (close) {
 		if (abrupt)
 			ret = abort_connection(ep, NULL, gfp);
@@ -2159,6 +2144,13 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 	return ret;
 }
 
+static int async_event(struct c4iw_dev *dev, struct sk_buff *skb)
+{
+	struct cpl_fw6_msg *rpl = cplhdr(skb);
+	c4iw_ev_dispatch(dev, (struct t4_cqe *)&rpl->data[0]);
+	return 0;
+}
+
 /*
  * These are the real handlers that are called from a
  * work queue.
@@ -2177,7 +2169,8 @@ static c4iw_handler_func work_handlers[NUM_CPL_CMDS] = {
 	[CPL_ABORT_REQ_RSS] = peer_abort,
 	[CPL_CLOSE_CON_RPL] = close_con_rpl,
 	[CPL_RDMA_TERMINATE] = terminate,
-	[CPL_FW4_ACK] = fw4_ack
+	[CPL_FW4_ACK] = fw4_ack,
+	[CPL_FW6_MSG] = async_event
 };
 
 static void process_timeout(struct c4iw_ep *ep)
@@ -2185,7 +2178,7 @@ static void process_timeout(struct c4iw_ep *ep)
 	struct c4iw_qp_attributes attrs;
 	int abort = 1;
 
-	spin_lock_irq(&ep->com.lock);
+	mutex_lock(&ep->com.mutex);
 	PDBG("%s ep %p tid %u state %d\n", __func__, ep, ep->hwtid,
 	     ep->com.state);
 	switch (ep->com.state) {
@@ -2212,7 +2205,7 @@ static void process_timeout(struct c4iw_ep *ep)
 		WARN_ON(1);
 		abort = 0;
 	}
-	spin_unlock_irq(&ep->com.lock);
+	mutex_unlock(&ep->com.mutex);
 	if (abort)
 		abort_connection(ep, NULL, GFP_KERNEL);
 	c4iw_put_ep(&ep->com);
@@ -2296,6 +2289,7 @@ static int set_tcb_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 		printk(KERN_ERR MOD "Unexpected SET_TCB_RPL status %u "
 		       "for tid %u\n", rpl->status, GET_TID(rpl));
 	}
+	kfree_skb(skb);
 	return 0;
 }
 
@@ -2313,17 +2307,22 @@ static int fw6_msg(struct c4iw_dev *dev, struct sk_buff *skb)
 		wr_waitp = (__force struct c4iw_wr_wait *)rpl->data[1];
 		PDBG("%s wr_waitp %p ret %u\n", __func__, wr_waitp, ret);
 		if (wr_waitp) {
-			wr_waitp->ret = ret;
+			if (ret)
+				wr_waitp->ret = -ret;
+			else
+				wr_waitp->ret = 0;
 			wr_waitp->done = 1;
 			wake_up(&wr_waitp->wait);
 		}
+		kfree_skb(skb);
 		break;
 	case 2:
-		c4iw_ev_dispatch(dev, (struct t4_cqe *)&rpl->data[0]);
+		sched(dev, skb);
 		break;
 	default:
 		printk(KERN_ERR MOD "%s unexpected fw6 msg type %u\n", __func__,
 		       rpl->type);
+		kfree_skb(skb);
 		break;
 	}
 	return 0;
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 1c26922..16032cd 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -46,6 +46,7 @@
 #include <linux/timer.h>
 #include <linux/io.h>
 #include <linux/kfifo.h>
+#include <linux/mutex.h>
 
 #include <asm/byteorder.h>
 
@@ -353,6 +354,7 @@ struct c4iw_qp {
 	struct c4iw_qp_attributes attr;
 	struct t4_wq wq;
 	spinlock_t lock;
+	struct mutex mutex;
 	atomic_t refcnt;
 	wait_queue_head_t wait;
 	struct timer_list timer;
@@ -605,7 +607,7 @@ struct c4iw_ep_common {
 	struct c4iw_dev *dev;
 	enum c4iw_ep_state state;
 	struct kref kref;
-	spinlock_t lock;
+	struct mutex mutex;
 	struct sockaddr_in local_addr;
 	struct sockaddr_in remote_addr;
 	struct c4iw_wr_wait wr_wait;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index e0f433f..44ad386 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -35,6 +35,14 @@ static int ocqp_support;
 module_param(ocqp_support, int, 0644);
 MODULE_PARM_DESC(ocqp_support, "Support on-chip SQs (default=0)");
 
+static void set_state(struct c4iw_qp *qhp, enum c4iw_qp_state state)
+{
+	unsigned long flag;
+	spin_lock_irqsave(&qhp->lock, flag);
+	qhp->attr.state = state;
+	spin_unlock_irqrestore(&qhp->lock, flag);
+}
+
 static void dealloc_oc_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
 {
 	c4iw_ocqp_pool_free(rdev, sq->dma_addr, sq->memsize);
@@ -949,46 +957,38 @@ static void post_terminate(struct c4iw_qp *qhp, struct t4_cqe *err_cqe,
  * Assumes qhp lock is held.
  */
 static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
-		       struct c4iw_cq *schp, unsigned long *flag)
+		       struct c4iw_cq *schp)
 {
 	int count;
 	int flushed;
+	unsigned long flag;
 
 	PDBG("%s qhp %p rchp %p schp %p\n", __func__, qhp, rchp, schp);
-	/* take a ref on the qhp since we must release the lock */
-	atomic_inc(&qhp->refcnt);
-	spin_unlock_irqrestore(&qhp->lock, *flag);
 
 	/* locking hierarchy: cq lock first, then qp lock. */
-	spin_lock_irqsave(&rchp->lock, *flag);
+	spin_lock_irqsave(&rchp->lock, flag);
 	spin_lock(&qhp->lock);
 	c4iw_flush_hw_cq(&rchp->cq);
 	c4iw_count_rcqes(&rchp->cq, &qhp->wq, &count);
 	flushed = c4iw_flush_rq(&qhp->wq, &rchp->cq, count);
 	spin_unlock(&qhp->lock);
-	spin_unlock_irqrestore(&rchp->lock, *flag);
+	spin_unlock_irqrestore(&rchp->lock, flag);
 	if (flushed)
 		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
 
 	/* locking hierarchy: cq lock first, then qp lock. */
-	spin_lock_irqsave(&schp->lock, *flag);
+	spin_lock_irqsave(&schp->lock, flag);
 	spin_lock(&qhp->lock);
 	c4iw_flush_hw_cq(&schp->cq);
 	c4iw_count_scqes(&schp->cq, &qhp->wq, &count);
 	flushed = c4iw_flush_sq(&qhp->wq, &schp->cq, count);
 	spin_unlock(&qhp->lock);
-	spin_unlock_irqrestore(&schp->lock, *flag);
+	spin_unlock_irqrestore(&schp->lock, flag);
 	if (flushed)
 		(*schp->ibcq.comp_handler)(&schp->ibcq, schp->ibcq.cq_context);
-
-	/* deref */
-	if (atomic_dec_and_test(&qhp->refcnt))
-		wake_up(&qhp->wait);
-
-	spin_lock_irqsave(&qhp->lock, *flag);
 }
 
-static void flush_qp(struct c4iw_qp *qhp, unsigned long *flag)
+static void flush_qp(struct c4iw_qp *qhp)
 {
 	struct c4iw_cq *rchp, *schp;
 
@@ -1002,7 +1002,7 @@ static void flush_qp(struct c4iw_qp *qhp, unsigned long *flag)
 			t4_set_cq_in_error(&schp->cq);
 		return;
 	}
-	__flush_qp(qhp, rchp, schp, flag);
+	__flush_qp(qhp, rchp, schp);
 }
 
 static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
@@ -1010,7 +1010,6 @@ static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 {
 	struct fw_ri_wr *wqe;
 	int ret;
-	struct c4iw_wr_wait wr_wait;
 	struct sk_buff *skb;
 
 	PDBG("%s qhp %p qid 0x%x tid %u\n", __func__, qhp, qhp->wq.sq.qid,
@@ -1029,15 +1028,15 @@ static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 	wqe->flowid_len16 = cpu_to_be32(
 		FW_WR_FLOWID(ep->hwtid) |
 		FW_WR_LEN16(DIV_ROUND_UP(sizeof *wqe, 16)));
-	wqe->cookie = (u64)&wr_wait;
+	wqe->cookie = (u64)&ep->com.wr_wait;
 
 	wqe->u.fini.type = FW_RI_TYPE_FINI;
-	c4iw_init_wr_wait(&wr_wait);
+	c4iw_init_wr_wait(&ep->com.wr_wait);
 	ret = c4iw_ofld_send(&rhp->rdev, skb);
 	if (ret)
 		goto out;
 
-	ret = c4iw_wait_for_reply(&rhp->rdev, &wr_wait, qhp->ep->hwtid,
+	ret = c4iw_wait_for_reply(&rhp->rdev, &ep->com.wr_wait, qhp->ep->hwtid,
 			     qhp->wq.sq.qid, __func__);
 out:
 	PDBG("%s ret %d\n", __func__, ret);
@@ -1072,7 +1071,6 @@ static int rdma_init(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 {
 	struct fw_ri_wr *wqe;
 	int ret;
-	struct c4iw_wr_wait wr_wait;
 	struct sk_buff *skb;
 
 	PDBG("%s qhp %p qid 0x%x tid %u\n", __func__, qhp, qhp->wq.sq.qid,
@@ -1092,7 +1090,7 @@ static int rdma_init(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 		FW_WR_FLOWID(qhp->ep->hwtid) |
 		FW_WR_LEN16(DIV_ROUND_UP(sizeof *wqe, 16)));
 
-	wqe->cookie = (u64)&wr_wait;
+	wqe->cookie = (u64)&qhp->ep->com.wr_wait;
 
 	wqe->u.init.type = FW_RI_TYPE_INIT;
 	wqe->u.init.mpareqbit_p2ptype =
@@ -1129,13 +1127,13 @@ static int rdma_init(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 	if (qhp->attr.mpa_attr.initiator)
 		build_rtr_msg(qhp->attr.mpa_attr.p2p_type, &wqe->u.init);
 
-	c4iw_init_wr_wait(&wr_wait);
+	c4iw_init_wr_wait(&qhp->ep->com.wr_wait);
 	ret = c4iw_ofld_send(&rhp->rdev, skb);
 	if (ret)
 		goto out;
 
-	ret = c4iw_wait_for_reply(&rhp->rdev, &wr_wait, qhp->ep->hwtid,
-			     qhp->wq.sq.qid, __func__);
+	ret = c4iw_wait_for_reply(&rhp->rdev, &qhp->ep->com.wr_wait,
+				  qhp->ep->hwtid, qhp->wq.sq.qid, __func__);
 out:
 	PDBG("%s ret %d\n", __func__, ret);
 	return ret;
@@ -1148,7 +1146,6 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 {
 	int ret = 0;
 	struct c4iw_qp_attributes newattr = qhp->attr;
-	unsigned long flag;
 	int disconnect = 0;
 	int terminate = 0;
 	int abort = 0;
@@ -1159,7 +1156,7 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 	     qhp, qhp->wq.sq.qid, qhp->wq.rq.qid, qhp->ep, qhp->attr.state,
 	     (mask & C4IW_QP_ATTR_NEXT_STATE) ? attrs->next_state : -1);
 
-	spin_lock_irqsave(&qhp->lock, flag);
+	mutex_lock(&qhp->mutex);
 
 	/* Process attr changes if in IDLE */
 	if (mask & C4IW_QP_ATTR_VALID_MODIFY) {
@@ -1210,7 +1207,7 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 			qhp->attr.mpa_attr = attrs->mpa_attr;
 			qhp->attr.llp_stream_handle = attrs->llp_stream_handle;
 			qhp->ep = qhp->attr.llp_stream_handle;
-			qhp->attr.state = C4IW_QP_STATE_RTS;
+			set_state(qhp, C4IW_QP_STATE_RTS);
 
 			/*
 			 * Ref the endpoint here and deref when we
@@ -1219,15 +1216,13 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 			 * transition.
 			 */
 			c4iw_get_ep(&qhp->ep->com);
-			spin_unlock_irqrestore(&qhp->lock, flag);
 			ret = rdma_init(rhp, qhp);
-			spin_lock_irqsave(&qhp->lock, flag);
 			if (ret)
 				goto err;
 			break;
 		case C4IW_QP_STATE_ERROR:
-			qhp->attr.state = C4IW_QP_STATE_ERROR;
-			flush_qp(qhp, &flag);
+			set_state(qhp, C4IW_QP_STATE_ERROR);
+			flush_qp(qhp);
 			break;
 		default:
 			ret = -EINVAL;
@@ -1238,39 +1233,38 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 		switch (attrs->next_state) {
 		case C4IW_QP_STATE_CLOSING:
 			BUG_ON(atomic_read(&qhp->ep->com.kref.refcount) < 2);
-			qhp->attr.state = C4IW_QP_STATE_CLOSING;
+			set_state(qhp, C4IW_QP_STATE_CLOSING);
 			ep = qhp->ep;
 			if (!internal) {
 				abort = 0;
 				disconnect = 1;
-				c4iw_get_ep(&ep->com);
+				c4iw_get_ep(&qhp->ep->com);
 			}
-			spin_unlock_irqrestore(&qhp->lock, flag);
 			ret = rdma_fini(rhp, qhp, ep);
-			spin_lock_irqsave(&qhp->lock, flag);
 			if (ret) {
-				c4iw_get_ep(&ep->com);
+				if (internal)
+					c4iw_get_ep(&qhp->ep->com);
 				disconnect = abort = 1;
 				goto err;
 			}
 			break;
 		case C4IW_QP_STATE_TERMINATE:
-			qhp->attr.state = C4IW_QP_STATE_TERMINATE;
+			set_state(qhp, C4IW_QP_STATE_TERMINATE);
 			if (qhp->ibqp.uobject)
 				t4_set_wq_in_error(&qhp->wq);
 			ep = qhp->ep;
-			c4iw_get_ep(&ep->com);
 			if (!internal)
 				terminate = 1;
 			disconnect = 1;
+			c4iw_get_ep(&qhp->ep->com);
 			break;
 		case C4IW_QP_STATE_ERROR:
-			qhp->attr.state = C4IW_QP_STATE_ERROR;
+			set_state(qhp, C4IW_QP_STATE_ERROR);
 			if (!internal) {
 				abort = 1;
 				disconnect = 1;
 				ep = qhp->ep;
-				c4iw_get_ep(&ep->com);
+				c4iw_get_ep(&qhp->ep->com);
 			}
 			goto err;
 			break;
@@ -1286,8 +1280,8 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 		}
 		switch (attrs->next_state) {
 		case C4IW_QP_STATE_IDLE:
-			flush_qp(qhp, &flag);
-			qhp->attr.state = C4IW_QP_STATE_IDLE;
+			flush_qp(qhp);
+			set_state(qhp, C4IW_QP_STATE_IDLE);
 			qhp->attr.llp_stream_handle = NULL;
 			c4iw_put_ep(&qhp->ep->com);
 			qhp->ep = NULL;
@@ -1309,7 +1303,7 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 			ret = -EINVAL;
 			goto out;
 		}
-		qhp->attr.state = C4IW_QP_STATE_IDLE;
+		set_state(qhp, C4IW_QP_STATE_IDLE);
 		break;
 	case C4IW_QP_STATE_TERMINATE:
 		if (!internal) {
@@ -1335,13 +1329,13 @@ err:
 	if (!ep)
 		ep = qhp->ep;
 	qhp->ep = NULL;
-	qhp->attr.state = C4IW_QP_STATE_ERROR;
+	set_state(qhp, C4IW_QP_STATE_ERROR);
 	free = 1;
 	wake_up(&qhp->wait);
 	BUG_ON(!ep);
-	flush_qp(qhp, &flag);
+	flush_qp(qhp);
 out:
-	spin_unlock_irqrestore(&qhp->lock, flag);
+	mutex_unlock(&qhp->mutex);
 
 	if (terminate)
 		post_terminate(qhp, NULL, internal ? GFP_ATOMIC : GFP_KERNEL);
@@ -1363,7 +1357,6 @@ out:
 	 */
 	if (free)
 		c4iw_put_ep(&ep->com);
-
 	PDBG("%s exit state %d\n", __func__, qhp->attr.state);
 	return ret;
 }
@@ -1478,6 +1471,7 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	qhp->attr.max_ord = 1;
 	qhp->attr.max_ird = 1;
 	spin_lock_init(&qhp->lock);
+	mutex_init(&qhp->mutex);
 	init_waitqueue_head(&qhp->wait);
 	atomic_set(&qhp->refcnt, 1);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

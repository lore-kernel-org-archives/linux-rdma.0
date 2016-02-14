From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/16] staging/rdma/hfi1: Adaptive PIO for short messages
Date: Sun, 14 Feb 2016 12:45:36 -0800
Message-ID: <20160214204532.29247.56963.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The change requires a new pio_busy field in the iowait structure to
track the number of outstanding pios.  The new counter together
with the sdma counter serve as the basis for a packet by packet decision
as to which egress mechanism to use.  Since packets given to different
egress mechanisms are not ordered, this scheme will preserve the order.

The iowait drain/wait mechanisms are extended for a pio case.  An
additional qp wait flag is added for the PIO drain wait case.

Currently the only pio wait is for buffers, so the no_bufs_available()
routine name is changed to pio_wait() and a third argument is passed
with one of the two pio wait flags to generalize the routine.  A module
parameter is added to hold a configurable threshold. For now, the
module parameter is zero.

A heuristic routine is added to return the func pointer of the proper
egress routine to use.

The heuristic is as follows:
- SMI always uses pio
- GSI,UD qps <= threshold use pio
- UD qps > threadhold use sdma
  o No coordination with sdma is required because order is not required
    and this qp pio count is not maintained for UD
- RC/UC ONLY packets <= threshold chose as follows:
  o If sdmas pending, use SDMA
  o Otherwise use pio and enable the pio tracking count at
    the time the pio buffer is allocated
- RC/UC ONLY packets > threshold use SDMA
  o If pio's are pending the pio_wait with the new wait flag is
    called to delay for pios to drain

The threshold is potentially reduced by the QP's mtu.

The sc_buffer_alloc() has two additional args (a callback, a void *)
which are exploited by the RC/UC cases to pass a new complete routine
and a qp *.

When the shadow ring completes the credit associated with a packet,
the new complete routine is called.  The verbs_pio_complete() will then
decrement the busy count and trigger any drain waiters in qp destroy
or reset.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c        |   10 +++
 drivers/staging/rdma/hfi1/chip.h        |    1 
 drivers/staging/rdma/hfi1/hfi.h         |    7 +-
 drivers/staging/rdma/hfi1/iowait.h      |   89 ++++++++++++++++++++++
 drivers/staging/rdma/hfi1/pio.c         |    3 +
 drivers/staging/rdma/hfi1/qp.c          |   25 ++++++
 drivers/staging/rdma/hfi1/rc.c          |   17 ++++
 drivers/staging/rdma/hfi1/sdma.c        |   14 ++--
 drivers/staging/rdma/hfi1/uc.c          |   10 ++-
 drivers/staging/rdma/hfi1/ud.c          |    4 +
 drivers/staging/rdma/hfi1/verbs.c       |  123 +++++++++++++++++++++++--------
 drivers/staging/rdma/hfi1/verbs.h       |   16 ++++
 drivers/staging/rdma/hfi1/verbs_txreq.h |    5 +
 include/rdma/rdmavt_qp.h                |   22 +++---
 14 files changed, 286 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 1294617..36e8e3e 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1588,6 +1588,14 @@ static u64 access_sw_pio_wait(const struct cntr_entry *entry,
 	return dd->verbs_dev.n_piowait;
 }
 
+static u64 access_sw_pio_drain(const struct cntr_entry *entry,
+			       void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->verbs_dev.n_piodrain;
+}
+
 static u64 access_sw_vtx_wait(const struct cntr_entry *entry,
 			      void *context, int vl, int mode, u64 data)
 {
@@ -4129,6 +4137,8 @@ static struct cntr_entry dev_cntrs[DEV_CNTR_LAST] = {
 			    access_sw_vtx_wait),
 [C_SW_PIO_WAIT] = CNTR_ELEM("PioWait", 0, 0, CNTR_NORMAL,
 			    access_sw_pio_wait),
+[C_SW_PIO_DRAIN] = CNTR_ELEM("PioDrain", 0, 0, CNTR_NORMAL,
+			    access_sw_pio_drain),
 [C_SW_KMEM_WAIT] = CNTR_ELEM("KmemWait", 0, 0, CNTR_NORMAL,
 			    access_sw_kmem_wait),
 [C_SW_SEND_SCHED] = CNTR_ELEM("SendSched", 0, 0, CNTR_NORMAL,
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index b86c220..6c581e0 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -800,6 +800,7 @@ enum {
 	C_SW_CPU_RCV_LIM,
 	C_SW_VTX_WAIT,
 	C_SW_PIO_WAIT,
+	C_SW_PIO_DRAIN,
 	C_SW_KMEM_WAIT,
 	C_SW_SEND_SCHED,
 	C_SDMA_DESC_FETCHED_CNT,
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 702723b..43d4861 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -811,6 +811,7 @@ struct sdma_vl_map;
 #define BOARD_VERS_MAX 96 /* how long the version string can be */
 #define SERIAL_MAX 16 /* length of the serial number */
 
+typedef int (*send_routine)(struct rvt_qp *, struct hfi1_pkt_state *, u64);
 struct hfi1_devdata {
 	struct hfi1_ibdev verbs_dev;     /* must be first */
 	struct list_head list;
@@ -1121,10 +1122,8 @@ struct hfi1_devdata {
 	 * Handlers for outgoing data so that snoop/capture does not
 	 * have to have its hooks in the send path
 	 */
-	int (*process_pio_send)(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
-				u64 pbc);
-	int (*process_dma_send)(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
-				u64 pbc);
+	send_routine process_pio_send;
+	send_routine process_dma_send;
 	void (*pio_inline_send)(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 				u64 pbc, const void *from, size_t count);
 
diff --git a/drivers/staging/rdma/hfi1/iowait.h b/drivers/staging/rdma/hfi1/iowait.h
index e007eb8..b5eb1e0 100644
--- a/drivers/staging/rdma/hfi1/iowait.h
+++ b/drivers/staging/rdma/hfi1/iowait.h
@@ -55,6 +55,7 @@
 #include <linux/sched.h>
 
 #include "sdma_txreq.h"
+
 /*
  * typedef (*restart_t)() - restart callback
  * @work: pointer to work structure
@@ -71,6 +72,7 @@ struct sdma_engine;
  * @wakeup: space callback
  * @iowork: workqueue overhead
  * @wait_dma: wait for sdma_busy == 0
+ * @wait_pio: wait for pio_busy == 0
  * @sdma_busy: # of packets in flight
  * @count: total number of descriptors in tx_head'ed list
  * @tx_limit: limit for overflow queuing
@@ -104,7 +106,9 @@ struct iowait {
 	void (*wakeup)(struct iowait *wait, int reason);
 	struct work_struct iowork;
 	wait_queue_head_t wait_dma;
+	wait_queue_head_t wait_pio;
 	atomic_t sdma_busy;
+	atomic_t pio_busy;
 	u32 count;
 	u32 tx_limit;
 	u32 tx_count;
@@ -141,7 +145,9 @@ static inline void iowait_init(
 	INIT_LIST_HEAD(&wait->tx_head);
 	INIT_WORK(&wait->iowork, func);
 	init_waitqueue_head(&wait->wait_dma);
+	init_waitqueue_head(&wait->wait_pio);
 	atomic_set(&wait->sdma_busy, 0);
+	atomic_set(&wait->pio_busy, 0);
 	wait->tx_limit = tx_limit;
 	wait->sleep = sleep;
 	wait->wakeup = wakeup;
@@ -175,6 +181,88 @@ static inline void iowait_sdma_drain(struct iowait *wait)
 }
 
 /**
+ * iowait_sdma_pending() - return sdma pending count
+ *
+ * @wait: iowait structure
+ *
+ */
+static inline int iowait_sdma_pending(struct iowait *wait)
+{
+	return atomic_read(&wait->sdma_busy);
+}
+
+/**
+ * iowait_sdma_inc - note sdma io pending
+ * @wait: iowait structure
+ */
+static inline void iowait_sdma_inc(struct iowait *wait)
+{
+	atomic_inc(&wait->sdma_busy);
+}
+
+/**
+ * iowait_sdma_add - add count to pending
+ * @wait: iowait structure
+ */
+static inline void iowait_sdma_add(struct iowait *wait, int count)
+{
+	atomic_add(count, &wait->sdma_busy);
+}
+
+/**
+ * iowait_sdma_dec - note sdma complete
+ * @wait: iowait structure
+ */
+static inline int iowait_sdma_dec(struct iowait *wait)
+{
+	return atomic_dec_and_test(&wait->sdma_busy);
+}
+
+/**
+ * iowait_pio_drain() - wait for pios to drain
+ *
+ * @wait: iowait structure
+ *
+ * This will delay until the iowait pios have
+ * completed.
+ */
+static inline void iowait_pio_drain(struct iowait *wait)
+{
+	wait_event_timeout(wait->wait_pio,
+			   !atomic_read(&wait->pio_busy),
+			   HZ);
+}
+
+/**
+ * iowait_pio_pending() - return pio pending count
+ *
+ * @wait: iowait structure
+ *
+ */
+static inline int iowait_pio_pending(struct iowait *wait)
+{
+	return atomic_read(&wait->pio_busy);
+}
+
+/**
+ * iowait_pio_inc - note pio pending
+ * @wait: iowait structure
+ */
+static inline void iowait_pio_inc(struct iowait *wait)
+{
+	atomic_inc(&wait->pio_busy);
+}
+
+/**
+ * iowait_sdma_dec - note pio complete
+ * @wait: iowait structure
+ */
+static inline int iowait_pio_dec(struct iowait *wait)
+{
+	return atomic_dec_and_test(&wait->pio_busy);
+}
+
+/**
  * iowait_drain_wakeup() - trigger iowait_drain() waiter
  *
  * @wait: iowait structure
@@ -184,6 +272,7 @@ static inline void iowait_sdma_drain(struct iowait *wait)
 static inline void iowait_drain_wakeup(struct iowait *wait)
 {
 	wake_up(&wait->wait_dma);
+	wake_up(&wait->wait_pio);
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index be0dcc3..f5aab0e 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -1564,7 +1564,8 @@ full:
 	write_sequnlock_irqrestore(&dev->iowait_lock, flags);
 
 	for (i = 0; i < n; i++)
-		hfi1_qp_wakeup(qps[i], RVT_S_WAIT_PIO);
+		hfi1_qp_wakeup(qps[i],
+			       RVT_S_WAIT_PIO | RVT_S_WAIT_PIO_DRAIN);
 }
 
 /* translate a send credit update to a bit code of reasons */
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index b81dc50..045da1b 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -359,6 +359,25 @@ void _hfi1_schedule_send(struct rvt_qp *qp)
 			cpumask_first(cpumask_of_node(dd->node)));
 }
 
+static void qp_pio_drain(struct rvt_qp *qp)
+{
+	struct hfi1_ibdev *dev;
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	if (!priv->s_sendcontext)
+		return;
+	dev = to_idev(qp->ibqp.device);
+	while (iowait_pio_pending(&priv->s_iowait)) {
+		write_seqlock_irq(&dev->iowait_lock);
+		hfi1_sc_wantpiobuf_intr(priv->s_sendcontext, 1);
+		write_sequnlock_irq(&dev->iowait_lock);
+		iowait_pio_drain(&priv->s_iowait);
+		write_seqlock_irq(&dev->iowait_lock);
+		hfi1_sc_wantpiobuf_intr(priv->s_sendcontext, 0);
+		write_sequnlock_irq(&dev->iowait_lock);
+	}
+}
+
 /**
  * hfi1_schedule_send - schedule progress
  * @qp: the QP
@@ -620,7 +639,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 	send_context = qp_to_send_context(qp, priv->s_sc);
 	seq_printf(s,
-		   "N %d %s QP%u R %u %s %u %u %u f=%x %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) QP%u LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p\n",
+		   "N %d %s QP%x R %u %s %u %u %u f=%x %u %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) QP%x LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
@@ -630,7 +649,8 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   wqe ? wqe->wr.opcode : 0,
 		   qp->s_hdrwords,
 		   qp->s_flags,
-		   atomic_read(&priv->s_iowait.sdma_busy),
+		   iowait_sdma_pending(&priv->s_iowait),
+		   iowait_pio_pending(&priv->s_iowait),
 		   !list_empty(&priv->s_iowait.list),
 		   qp->timeout,
 		   wqe ? wqe->ssn : 0,
@@ -740,6 +760,7 @@ void quiesce_qp(struct rvt_qp *qp)
 	struct hfi1_qp_priv *priv = qp->priv;
 
 	iowait_sdma_drain(&priv->s_iowait);
+	qp_pio_drain(qp);
 	flush_tx_list(qp);
 }
 
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 2704287..443fda8 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -181,6 +181,18 @@ void hfi1_del_timers_sync(struct rvt_qp *qp)
 	del_timer_sync(&priv->s_rnr_timer);
 }
 
+/* only opcode mask for adaptive pio */
+const u32 rc_only_opcode =
+	BIT(OP(SEND_ONLY) & 0x1f) |
+	BIT(OP(SEND_ONLY_WITH_IMMEDIATE & 0x1f)) |
+	BIT(OP(RDMA_WRITE_ONLY & 0x1f)) |
+	BIT(OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE & 0x1f)) |
+	BIT(OP(RDMA_READ_REQUEST & 0x1f)) |
+	BIT(OP(ACKNOWLEDGE & 0x1f)) |
+	BIT(OP(ATOMIC_ACKNOWLEDGE & 0x1f)) |
+	BIT(OP(COMPARE_SWAP & 0x1f)) |
+	BIT(OP(FETCH_ADD & 0x1f));
+
 static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 		       u32 psn, u32 pmtu)
 {
@@ -217,6 +229,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 	u32 bth2;
 	int middle = 0;
 	u32 pmtu = qp->pmtu;
+	struct hfi1_qp_priv *priv = qp->priv;
 
 	/* Don't send an ACK if we aren't supposed to. */
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
@@ -350,6 +363,7 @@ normal:
 	qp->s_hdrwords = hwords;
 	/* pbc */
 	ps->s_txreq->hdr_dwords = hwords + 2;
+	ps->s_txreq->sde = priv->s_sde;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0, bth2, middle, ps);
 	return 1;
@@ -413,7 +427,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		if (qp->s_last == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
-		if (atomic_read(&priv->s_iowait.sdma_busy)) {
+		if (iowait_sdma_pending(&priv->s_iowait)) {
 			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
@@ -754,6 +768,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	qp->s_hdrwords = hwords;
 	/* pbc */
 	ps->s_txreq->hdr_dwords = hwords + 2;
+	ps->s_txreq->sde = priv->s_sde;
 	qp->s_cur_sge = ss;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index ff1d2cd..49e567a 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -410,7 +410,7 @@ static void sdma_flush(struct sdma_engine *sde)
 #endif
 		sdma_txclean(sde->dd, txp);
 		if (wait)
-			drained = atomic_dec_and_test(&wait->sdma_busy);
+			drained = iowait_sdma_dec(wait);
 		if (txp->complete)
 			(*txp->complete)(txp, SDMA_TXREQ_S_ABORTED, drained);
 		if (wait && drained)
@@ -584,7 +584,7 @@ static void sdma_flush_descq(struct sdma_engine *sde)
 			/* remove from list */
 			sde->tx_ring[sde->tx_head++ & sde->sdma_mask] = NULL;
 			if (wait)
-				drained = atomic_dec_and_test(&wait->sdma_busy);
+				drained = iowait_sdma_dec(wait);
 #ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
 			trace_hfi1_sdma_out_sn(sde, txp->sn);
 			if (WARN_ON_ONCE(sde->head_sn != txp->sn))
@@ -1499,7 +1499,7 @@ retry:
 			/* remove from list */
 			sde->tx_ring[sde->tx_head++ & sde->sdma_mask] = NULL;
 			if (wait)
-				drained = atomic_dec_and_test(&wait->sdma_busy);
+				drained = iowait_sdma_dec(wait);
 #ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
 			trace_hfi1_sdma_out_sn(sde, txp->sn);
 			if (WARN_ON_ONCE(sde->head_sn != txp->sn))
@@ -2093,14 +2093,14 @@ retry:
 		goto nodesc;
 	tail = submit_tx(sde, tx);
 	if (wait)
-		atomic_inc(&wait->sdma_busy);
+		iowait_sdma_inc(wait);
 	sdma_update_tail(sde, tail);
 unlock:
 	spin_unlock_irqrestore(&sde->tail_lock, flags);
 	return ret;
 unlock_noconn:
 	if (wait)
-		atomic_inc(&wait->sdma_busy);
+		iowait_sdma_inc(wait);
 	tx->next_descq_idx = 0;
 #ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
 	tx->sn = sde->tail_sn++;
@@ -2182,7 +2182,7 @@ retry:
 	}
 update_tail:
 	if (wait)
-		atomic_add(count, &wait->sdma_busy);
+		iowait_sdma_add(wait, count);
 	if (tail != INVALID_TAIL)
 		sdma_update_tail(sde, tail);
 	spin_unlock_irqrestore(&sde->tail_lock, flags);
@@ -2193,7 +2193,7 @@ unlock_noconn:
 		tx->wait = wait;
 		list_del_init(&tx->list);
 		if (wait)
-			atomic_inc(&wait->sdma_busy);
+			iowait_sdma_inc(wait);
 		tx->next_descq_idx = 0;
 #ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
 		tx->sn = sde->tail_sn++;
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 3270561..e58ec15 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -55,6 +55,13 @@
 /* cut down ridiculously long IB macro names */
 #define OP(x) IB_OPCODE_UC_##x
 
+/* only opcode mask for adaptive pio */
+const u32 uc_only_opcode =
+	BIT(OP(SEND_ONLY) & 0x1f) |
+	BIT(OP(SEND_ONLY_WITH_IMMEDIATE & 0x1f)) |
+	BIT(OP(RDMA_WRITE_ONLY & 0x1f)) |
+	BIT(OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE & 0x1f));
+
 /**
  * hfi1_make_uc_req - construct a request packet (SEND, RDMA write)
  * @qp: a pointer to the QP
@@ -86,7 +93,7 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		if (qp->s_last == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
-		if (atomic_read(&priv->s_iowait.sdma_busy)) {
+		if (iowait_sdma_pending(&priv->s_iowait)) {
 			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
@@ -237,6 +244,7 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	qp->s_hdrwords = hwords;
 	/* pbc */
 	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
+	ps->s_txreq->sde = priv->s_sde;
 	qp->s_cur_sge = &qp->s_sge;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24),
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index bae5ccd..da4e465 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -294,7 +294,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		if (qp->s_last == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
-		if (atomic_read(&priv->s_iowait.sdma_busy)) {
+		if (iowait_sdma_pending(&priv->s_iowait)) {
 			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
@@ -331,7 +331,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			 * Instead of waiting, we could queue a
 			 * zero length descriptor so we get a callback.
 			 */
-			if (atomic_read(&priv->s_iowait.sdma_busy)) {
+			if (iowait_sdma_pending(&priv->s_iowait)) {
 				qp->s_flags |= RVT_S_WAIT_DMA;
 				goto bail;
 			}
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index a4f8b26..d900374 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -124,11 +124,20 @@ unsigned int hfi1_max_srq_wrs = 0x1FFFF;
 module_param_named(max_srq_wrs, hfi1_max_srq_wrs, uint, S_IRUGO);
 MODULE_PARM_DESC(max_srq_wrs, "Maximum number of SRQ WRs support");
 
+unsigned short piothreshold;
+module_param(piothreshold, ushort, S_IRUGO);
+MODULE_PARM_DESC(piothreshold, "size used to determine sdma vs. pio");
+
 static void verbs_sdma_complete(
 	struct sdma_txreq *cookie,
 	int status,
 	int drained);
 
+static int pio_wait(struct rvt_qp *qp,
+		    struct send_context *sc,
+		    struct hfi1_pkt_state *ps,
+		    u32 flag);
+
 /* Length of buffer to create verbs txreq cache name */
 #define TXREQ_NAME_LEN 24
 
@@ -742,9 +751,10 @@ bail_build:
  * If we are now in the error state, return zero to flush the
  * send work request.
  */
-static int no_bufs_available(struct rvt_qp *qp,
-			     struct send_context *sc,
-			     struct hfi1_pkt_state *ps)
+static int pio_wait(struct rvt_qp *qp,
+		    struct send_context *sc,
+		    struct hfi1_pkt_state *ps,
+		    u32 flag)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_devdata *dd = sc->dd;
@@ -767,8 +777,10 @@ static int no_bufs_available(struct rvt_qp *qp,
 			struct hfi1_ibdev *dev = &dd->verbs_dev;
 			int was_empty;
 
+			dev->n_piowait += !!(flag & RVT_S_WAIT_PIO);
+			dev->n_piodrain += !!(flag & RVT_S_WAIT_PIO_DRAIN);
 			dev->n_piowait++;
-			qp->s_flags |= RVT_S_WAIT_PIO;
+			qp->s_flags |= flag;
 			was_empty = list_empty(&sc->piowait);
 			list_add_tail(&priv->s_iowait.list, &sc->piowait);
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_PIO);
@@ -797,6 +809,15 @@ struct send_context *qp_to_send_context(struct rvt_qp *qp, u8 sc5)
 	return dd->vld[vl].sc;
 }
 
+static void verbs_pio_complete(void *arg, int code)
+{
+	struct rvt_qp *qp = (struct rvt_qp *)arg;
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	if (iowait_pio_dec(&priv->s_iowait))
+		iowait_drain_wakeup(&priv->s_iowait);
+}
+
 int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			u64 pbc)
 {
@@ -815,6 +836,17 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	struct pio_buf *pbuf;
 	int wc_status = IB_WC_SUCCESS;
 	int ret = 0;
+	pio_release_cb cb = NULL;
+
+	/* only RC/UC use complete */
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_RC:
+	case IB_QPT_UC:
+		cb = verbs_pio_complete;
+		break;
+	default:
+		break;
+	}
 
 	/* vl15 special case taken care of in ud.c */
 	sc5 = priv->s_sc;
@@ -830,8 +862,12 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		pbc_flags |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
 		pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
 	}
-	pbuf = sc_buffer_alloc(sc, plen, NULL, NULL);
+	if (cb)
+		iowait_pio_inc(&priv->s_iowait);
+	pbuf = sc_buffer_alloc(sc, plen, cb, qp);
 	if (unlikely(pbuf == NULL)) {
+		if (cb)
+			verbs_pio_complete(qp, 0);
 		if (ppd->host_link_state != HLS_UP_ACTIVE) {
 			/*
 			 * If we have filled the PIO buffers to capacity and are
@@ -851,8 +887,9 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			 * so lets continue to queue the request.
 			 */
 			hfi1_cdbg(PIO, "alloc failed. state active, queuing");
-			ret = no_bufs_available(qp, sc, ps);
+			ret = pio_wait(qp, sc, ps, RVT_S_WAIT_PIO);
 			if (!ret)
+				/* txreq not queued - free */
 				goto bail;
 			/* tx consumed in wait */
 			return ret;
@@ -985,6 +1022,48 @@ bad:
 }
 
 /**
+ * get_send_routine - choose an egress routine
+ *
+ * Choose an egress routine based on QP type
+ * and size
+ */
+static inline send_routine get_send_routine(struct rvt_qp *qp,
+					    struct hfi1_ib_header *h)
+{
+	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	if (unlikely(!(dd->flags & HFI1_HAS_SEND_DMA)))
+		return dd->process_pio_send;
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_SMI:
+		return dd->process_pio_send;
+	case IB_QPT_GSI:
+	case IB_QPT_UD:
+		if (piothreshold && qp->s_cur_size <= piothreshold)
+			return dd->process_pio_send;
+		break;
+	case IB_QPT_RC:
+		if (piothreshold &&
+		    qp->s_cur_size <= min(piothreshold, qp->pmtu) &&
+		    (BIT(get_opcode(h) & 0x1f) & rc_only_opcode) &&
+		    iowait_sdma_pending(&priv->s_iowait) == 0)
+			return dd->process_pio_send;
+		break;
+	case IB_QPT_UC:
+		if (piothreshold &&
+		    qp->s_cur_size <= min(piothreshold, qp->pmtu) &&
+		    (BIT(get_opcode(h) & 0x1f) & uc_only_opcode) &&
+		    iowait_sdma_pending(&priv->s_iowait) == 0)
+			return dd->process_pio_send;
+		break;
+	default:
+		break;
+	}
+	return dd->process_dma_send;
+}
+
+/**
  * hfi1_verbs_send - send a packet
  * @qp: the QP to send on
  * @ps: the state of the packet to send
@@ -995,19 +1074,10 @@ bad:
 int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+	send_routine sr;
 	int ret;
-	int pio = 0;
-	unsigned long flags = 0;
-
-	/*
-	 * VL15 packets (IB_QPT_SMI) will always use PIO, so we
-	 * can defer SDMA restart until link goes ACTIVE without
-	 * worrying about just how we got there.
-	 */
-	if ((qp->ibqp.qp_type == IB_QPT_SMI) ||
-	    !(dd->flags & HFI1_HAS_SEND_DMA))
-		pio = 1;
 
+	sr = get_send_routine(qp, &ps->s_txreq->phdr.hdr);
 	ret = egress_pkey_check(dd->pport, &ps->s_txreq->phdr.hdr, qp);
 	if (unlikely(ret)) {
 		/*
@@ -1018,7 +1088,9 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		 * mechanism for handling the errors. So for SDMA we can just
 		 * return.
 		 */
-		if (pio) {
+		if (sr == dd->process_pio_send) {
+			unsigned long flags;
+
 			hfi1_cdbg(PIO, "%s() Failed. Completing with err",
 				  __func__);
 			spin_lock_irqsave(&qp->s_lock, flags);
@@ -1027,20 +1099,7 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		}
 		return -EINVAL;
 	}
-
-	if (pio) {
-		ret = dd->process_pio_send(qp, ps, 0);
-	} else {
-#ifdef CONFIG_SDMA_VERBOSITY
-		dd_dev_err(dd, "CONFIG SDMA %s:%d %s()\n",
-			   slashstrip(__FILE__), __LINE__, __func__);
-		dd_dev_err(dd, "SDMA hdrwords = %u, len = %u\n", qp->s_hdrwords,
-			   qp->s_cur_size);
-#endif
-		ret = dd->process_dma_send(qp, ps, 0);
-	}
-
-	return ret;
+	return sr(qp, ps, 0);
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 3d25ad4..8f1fde8 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -265,6 +265,7 @@ struct hfi1_ibdev {
 	struct timer_list mem_timer;
 
 	u64 n_piowait;
+	u64 n_piodrain;
 	u64 n_txwait;
 	u64 n_kmem_wait;
 
@@ -425,6 +426,19 @@ void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 
 int hfi1_check_send_wqe(struct rvt_qp *qp, struct rvt_swqe *wqe);
 
+extern const u32 rc_only_opcode;
+extern const u32 uc_only_opcode;
+
+static inline u8 get_opcode(struct hfi1_ib_header *h)
+{
+	u16 lnh = be16_to_cpu(h->lrh[0]) & 3;
+
+	if (lnh == IB_LNH_IBA_LOCAL)
+		return be32_to_cpu(h->u.oth.bth[0]) >> 24;
+	else
+		return be32_to_cpu(h->u.l.oth.bth[0]) >> 24;
+}
+
 int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 		       int has_grh, struct rvt_qp *qp, u32 bth0);
 
@@ -494,6 +508,8 @@ extern unsigned int hfi1_max_srq_sges;
 
 extern unsigned int hfi1_max_srq_wrs;
 
+extern unsigned short piothreshold;
+
 extern const u32 ib_hfi1_rnr_table[];
 
 #endif                          /* HFI1_VERBS_H */
diff --git a/drivers/staging/rdma/hfi1/verbs_txreq.h b/drivers/staging/rdma/hfi1/verbs_txreq.h
index f56149e..1cf69b2 100644
--- a/drivers/staging/rdma/hfi1/verbs_txreq.h
+++ b/drivers/staging/rdma/hfi1/verbs_txreq.h
@@ -93,6 +93,11 @@ static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
 	return tx;
 }
 
+static inline struct sdma_txreq *get_sdma_txreq(struct verbs_txreq *tx)
+{
+	return &tx->txreq;
+}
+
 static inline struct verbs_txreq *get_waiting_verbs_txreq(struct rvt_qp *qp)
 {
 	struct sdma_txreq *stx;
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 5c307ed..f2f4df0 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -82,6 +82,7 @@
  * RVT_S_WAIT_DMA - waiting for send DMA queue to drain before generating
  *                  next send completion entry not via send DMA
  * RVT_S_WAIT_PIO - waiting for a send buffer to be available
+ * RVT_S_WAIT_PIO_DRAIN - waiting for a qp to drain pio packets
  * RVT_S_WAIT_TX - waiting for a struct verbs_txreq to be available
  * RVT_S_WAIT_DMA_DESC - waiting for DMA descriptors to be available
  * RVT_S_WAIT_KMEM - waiting for kernel memory to be available
@@ -101,16 +102,17 @@
 #define RVT_S_WAIT_SSN_CREDIT	0x0100
 #define RVT_S_WAIT_DMA		0x0200
 #define RVT_S_WAIT_PIO		0x0400
-#define RVT_S_WAIT_TX		0x0800
-#define RVT_S_WAIT_DMA_DESC	0x1000
-#define RVT_S_WAIT_KMEM		0x2000
-#define RVT_S_WAIT_PSN		0x4000
-#define RVT_S_WAIT_ACK		0x8000
-#define RVT_S_SEND_ONE		0x10000
-#define RVT_S_UNLIMITED_CREDIT	0x20000
-#define RVT_S_AHG_VALID		0x40000
-#define RVT_S_AHG_CLEAR		0x80000
-#define RVT_S_ECN		0x100000
+#define RVT_S_WAIT_PIO_DRAIN    0x0800
+#define RVT_S_WAIT_TX		0x1000
+#define RVT_S_WAIT_DMA_DESC	0x2000
+#define RVT_S_WAIT_KMEM		0x4000
+#define RVT_S_WAIT_PSN		0x8000
+#define RVT_S_WAIT_ACK		0x10000
+#define RVT_S_SEND_ONE		0x20000
+#define RVT_S_UNLIMITED_CREDIT	0x40000
+#define RVT_S_AHG_VALID		0x80000
+#define RVT_S_AHG_CLEAR		0x100000
+#define RVT_S_ECN		0x200000
 
 /*
  * Wait flags that would prevent any packet type from being sent.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

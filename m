From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/13] IB/hfi1: Serve the most starved iowait entry
 first
Date: Mon, 24 Jul 2017 07:45:37 -0700
Message-ID: <20170724144536.10034.90186.stgit@scvm10.sc.intel.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When an egress resource(SDMA descriptors, pio credits) is not available,
a sending thread will be put on the resource's wait queue. When the
resource becomes available again, up to a fixed number of sending threads
can be awakened sequentially and removed from the wait queue, depending
on the number of waiting threads and the number of free resources. Since
each awakened sending thread will send as many packets as possible, it
is highly likely that the first sending thread will consume all the
egress resources. Subsequently, it will be put back to the end of the wait
queue. Depending on the timing when the later sending threads wake up,
they may not be able to send any packet and be again put back to the end
of the wait queue sequentially, right behind the first sending thread.
This starvation cycle continues until some sending threads exceed their
retry limit and consequently fail.

This patch fixes the issue by two simple approaches:
(1) Any starved sending thread will be put to the head of the wait queue
while a served sending thread will be put to the tail;
(2) The most starved sending thread will be served first.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/iowait.h    |   70 +++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/hfi1/pio.c       |   13 +++++-
 drivers/infiniband/hw/hfi1/qp.c        |    9 +++-
 drivers/infiniband/hw/hfi1/ruc.c       |    5 ++
 drivers/infiniband/hw/hfi1/sdma.c      |   34 +++++++++++-----
 drivers/infiniband/hw/hfi1/sdma.h      |    3 +
 drivers/infiniband/hw/hfi1/user_sdma.c |    8 ++--
 drivers/infiniband/hw/hfi1/verbs.c     |    6 ++-
 drivers/infiniband/hw/hfi1/verbs.h     |    1 
 drivers/infiniband/hw/hfi1/vnic.h      |    1 
 drivers/infiniband/hw/hfi1/vnic_sdma.c |   14 +++++-
 11 files changed, 136 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/iowait.h b/drivers/infiniband/hw/hfi1/iowait.h
index d9740dd..591697d 100644
--- a/drivers/infiniband/hw/hfi1/iowait.h
+++ b/drivers/infiniband/hw/hfi1/iowait.h
@@ -106,7 +106,9 @@ struct iowait {
 		struct sdma_engine *sde,
 		struct iowait *wait,
 		struct sdma_txreq *tx,
-		unsigned seq);
+		uint seq,
+		bool pkts_sent
+		);
 	void (*wakeup)(struct iowait *wait, int reason);
 	void (*sdma_drained)(struct iowait *wait);
 	seqlock_t *lock;
@@ -118,6 +120,7 @@ struct iowait {
 	u32 count;
 	u32 tx_limit;
 	u32 tx_count;
+	u8 starved_cnt;
 };
 
 #define SDMA_AVAIL_REASON 0
@@ -143,7 +146,8 @@ static inline void iowait_init(
 		struct sdma_engine *sde,
 		struct iowait *wait,
 		struct sdma_txreq *tx,
-		unsigned seq),
+		uint seq,
+		bool pkts_sent),
 	void (*wakeup)(struct iowait *wait, int reason),
 	void (*sdma_drained)(struct iowait *wait))
 {
@@ -305,4 +309,66 @@ static inline void iowait_drain_wakeup(struct iowait *wait)
 	return tx;
 }
 
+/**
+ * iowait_queue - Put the iowait on a wait queue
+ * @pkts_sent: have some packets been sent before queuing?
+ * @w: the iowait struct
+ * @wait_head: the wait queue
+ *
+ * This function is called to insert an iowait struct into a
+ * wait queue after a resource (eg, sdma decriptor or pio
+ * buffer) is run out.
+ */
+static inline void iowait_queue(bool pkts_sent, struct iowait *w,
+				struct list_head *wait_head)
+{
+	/*
+	 * To play fair, insert the iowait at the tail of the wait queue if it
+	 * has already sent some packets; Otherwise, put it at the head.
+	 */
+	if (pkts_sent) {
+		list_add_tail(&w->list, wait_head);
+		w->starved_cnt = 0;
+	} else {
+		list_add(&w->list, wait_head);
+		w->starved_cnt++;
+	}
+}
+
+/**
+ * iowait_starve_clear - clear the wait queue's starve count
+ * @pkts_sent: have some packets been sent?
+ * @w: the iowait struct
+ *
+ * This function is called to clear the starve count. If no
+ * packets have been sent, the starve count will not be cleared.
+ */
+static inline void iowait_starve_clear(bool pkts_sent, struct iowait *w)
+{
+	if (pkts_sent)
+		w->starved_cnt = 0;
+}
+
+/**
+ * iowait_starve_find_max - Find the maximum of the starve count
+ * @w: the iowait struct
+ * @max: a variable containing the max starve count
+ * @idx: the index of the current iowait in an array
+ * @max_idx: a variable containing the array index for the
+ *         iowait entry that has the max starve count
+ *
+ * This function is called to compare the starve count of a
+ * given iowait with the given max starve count. The max starve
+ * count and the index will be updated if the iowait's start
+ * count is larger.
+ */
+static inline void iowait_starve_find_max(struct iowait *w, u8 *max,
+					  uint idx, uint *max_idx)
+{
+	if (w->starved_cnt > *max) {
+		*max = w->starved_cnt;
+		*max_idx = idx;
+	}
+}
+
 #endif
diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index ed72b5a..adb6a4d 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1568,7 +1568,8 @@ static void sc_piobufavail(struct send_context *sc)
 	struct rvt_qp *qp;
 	struct hfi1_qp_priv *priv;
 	unsigned long flags;
-	unsigned i, n = 0;
+	uint i, n = 0, max_idx = 0;
+	u8 max_starved_cnt = 0;
 
 	if (dd->send_contexts[sc->sw_index].type != SC_KERNEL &&
 	    dd->send_contexts[sc->sw_index].type != SC_VL15)
@@ -1591,6 +1592,7 @@ static void sc_piobufavail(struct send_context *sc)
 		priv = qp->priv;
 		list_del_init(&priv->s_iowait.list);
 		priv->s_iowait.lock = NULL;
+		iowait_starve_find_max(wait, &max_starved_cnt, n, &max_idx);
 		/* refcount held until actual wake up */
 		qps[n++] = qp;
 	}
@@ -1605,9 +1607,14 @@ static void sc_piobufavail(struct send_context *sc)
 	}
 	write_sequnlock_irqrestore(&dev->iowait_lock, flags);
 
-	for (i = 0; i < n; i++)
-		hfi1_qp_wakeup(qps[i],
+	/* Wake up the most starved one first */
+	if (n)
+		hfi1_qp_wakeup(qps[max_idx],
 			       RVT_S_WAIT_PIO | RVT_S_WAIT_PIO_DRAIN);
+	for (i = 0; i < n; i++)
+		if (i != max_idx)
+			hfi1_qp_wakeup(qps[i],
+				       RVT_S_WAIT_PIO | RVT_S_WAIT_PIO_DRAIN);
 }
 
 /* translate a send credit update to a bit code of reasons */
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 806d166..b801d84 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -68,7 +68,8 @@ static int iowait_sleep(
 	struct sdma_engine *sde,
 	struct iowait *wait,
 	struct sdma_txreq *stx,
-	unsigned seq);
+	unsigned int seq,
+	bool pkts_sent);
 static void iowait_wakeup(struct iowait *wait, int reason);
 static void iowait_sdma_drained(struct iowait *wait);
 static void qp_pio_drain(struct rvt_qp *qp);
@@ -371,7 +372,8 @@ static int iowait_sleep(
 	struct sdma_engine *sde,
 	struct iowait *wait,
 	struct sdma_txreq *stx,
-	unsigned seq)
+	uint seq,
+	bool pkts_sent)
 {
 	struct verbs_txreq *tx = container_of(stx, struct verbs_txreq, txreq);
 	struct rvt_qp *qp;
@@ -402,7 +404,8 @@ static int iowait_sleep(
 
 			ibp->rvp.n_dmawait++;
 			qp->s_flags |= RVT_S_WAIT_DMA_DESC;
-			list_add_tail(&priv->s_iowait.list, &sde->dmawait);
+			iowait_queue(pkts_sent, &priv->s_iowait,
+				     &sde->dmawait);
 			priv->s_iowait.lock = &dev->iowait_lock;
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_DMA_DESC);
 			rvt_get_qp(qp);
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 9cf506a..f13ddb2 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -811,6 +811,8 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 static bool schedule_send_yield(struct rvt_qp *qp,
 				struct hfi1_pkt_state *ps)
 {
+	ps->pkts_sent = true;
+
 	if (unlikely(time_after(jiffies, ps->timeout))) {
 		if (!ps->in_thread ||
 		    workqueue_congested(ps->cpu, ps->ppd->hfi1_wq)) {
@@ -907,6 +909,7 @@ void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 	ps.timeout = jiffies + ps.timeout_int;
 	ps.cpu = priv->s_sde ? priv->s_sde->cpu :
 			cpumask_first(cpumask_of_node(ps.ppd->dd->node));
+	ps.pkts_sent = false;
 
 	/* insure a pre-built packet is handled  */
 	ps.s_txreq = get_waiting_verbs_txreq(qp);
@@ -929,7 +932,7 @@ void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 			spin_lock_irqsave(&qp->s_lock, ps.flags);
 		}
 	} while (make_req(qp, &ps));
-
+	iowait_starve_clear(ps.pkts_sent, &priv->s_iowait);
 	spin_unlock_irqrestore(&qp->s_lock, ps.flags);
 }
 
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index d82ff57..71b4258 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -246,7 +246,7 @@ static void __sdma_process_event(
 	enum sdma_events event);
 static void dump_sdma_state(struct sdma_engine *sde);
 static void sdma_make_progress(struct sdma_engine *sde, u64 status);
-static void sdma_desc_avail(struct sdma_engine *sde, unsigned avail);
+static void sdma_desc_avail(struct sdma_engine *sde, uint avail);
 static void sdma_flush_descq(struct sdma_engine *sde);
 
 /**
@@ -1762,13 +1762,14 @@ static inline u16 sdma_gethead(struct sdma_engine *sde)
  *
  * This is called with head_lock held.
  */
-static void sdma_desc_avail(struct sdma_engine *sde, unsigned avail)
+static void sdma_desc_avail(struct sdma_engine *sde, uint avail)
 {
 	struct iowait *wait, *nw;
 	struct iowait *waits[SDMA_WAIT_BATCH_SIZE];
-	unsigned i, n = 0, seq;
+	uint i, n = 0, seq, max_idx = 0;
 	struct sdma_txreq *stx;
 	struct hfi1_ibdev *dev = &sde->dd->verbs_dev;
+	u8 max_starved_cnt = 0;
 
 #ifdef CONFIG_SDMA_VERBOSITY
 	dd_dev_err(sde->dd, "CONFIG SDMA(%u) %s:%d %s()\n", sde->this_idx,
@@ -1803,6 +1804,9 @@ static void sdma_desc_avail(struct sdma_engine *sde, unsigned avail)
 				if (num_desc > avail)
 					break;
 				avail -= num_desc;
+				/* Find the most starved wait memeber */
+				iowait_starve_find_max(wait, &max_starved_cnt,
+						       n, &max_idx);
 				list_del_init(&wait->list);
 				waits[n++] = wait;
 			}
@@ -1811,8 +1815,13 @@ static void sdma_desc_avail(struct sdma_engine *sde, unsigned avail)
 		}
 	} while (read_seqretry(&dev->iowait_lock, seq));
 
+	/* Schedule the most starved one first */
+	if (n)
+		waits[max_idx]->wakeup(waits[max_idx], SDMA_AVAIL_REASON);
+
 	for (i = 0; i < n; i++)
-		waits[i]->wakeup(waits[i], SDMA_AVAIL_REASON);
+		if (i != max_idx)
+			waits[i]->wakeup(waits[i], SDMA_AVAIL_REASON);
 }
 
 /* head_lock must be held */
@@ -2349,7 +2358,8 @@ static inline u16 submit_tx(struct sdma_engine *sde, struct sdma_txreq *tx)
 static int sdma_check_progress(
 	struct sdma_engine *sde,
 	struct iowait *wait,
-	struct sdma_txreq *tx)
+	struct sdma_txreq *tx,
+	bool pkts_sent)
 {
 	int ret;
 
@@ -2362,7 +2372,7 @@ static int sdma_check_progress(
 
 		seq = raw_seqcount_begin(
 			(const seqcount_t *)&sde->head_lock.seqcount);
-		ret = wait->sleep(sde, wait, tx, seq);
+		ret = wait->sleep(sde, wait, tx, seq, pkts_sent);
 		if (ret == -EAGAIN)
 			sde->desc_avail = sdma_descq_freecnt(sde);
 	} else {
@@ -2376,6 +2386,7 @@ static int sdma_check_progress(
  * @sde: sdma engine to use
  * @wait: wait structure to use when full (may be NULL)
  * @tx: sdma_txreq to submit
+ * @pkts_sent: has any packet been sent yet?
  *
  * The call submits the tx into the ring.  If a iowait structure is non-NULL
  * the packet will be queued to the list in wait.
@@ -2387,7 +2398,8 @@ static int sdma_check_progress(
  */
 int sdma_send_txreq(struct sdma_engine *sde,
 		    struct iowait *wait,
-		    struct sdma_txreq *tx)
+		    struct sdma_txreq *tx,
+		    bool pkts_sent)
 {
 	int ret = 0;
 	u16 tail;
@@ -2429,7 +2441,7 @@ int sdma_send_txreq(struct sdma_engine *sde,
 	ret = -ECOMM;
 	goto unlock;
 nodesc:
-	ret = sdma_check_progress(sde, wait, tx);
+	ret = sdma_check_progress(sde, wait, tx, pkts_sent);
 	if (ret == -EAGAIN) {
 		ret = 0;
 		goto retry;
@@ -2498,8 +2510,10 @@ int sdma_send_txlist(struct sdma_engine *sde, struct iowait *wait,
 	}
 update_tail:
 	total_count = submit_count + flush_count;
-	if (wait)
+	if (wait) {
 		iowait_sdma_add(wait, total_count);
+		iowait_starve_clear(submit_count > 0, wait);
+	}
 	if (tail != INVALID_TAIL)
 		sdma_update_tail(sde, tail);
 	spin_unlock_irqrestore(&sde->tail_lock, flags);
@@ -2527,7 +2541,7 @@ int sdma_send_txlist(struct sdma_engine *sde, struct iowait *wait,
 	ret = -ECOMM;
 	goto update_tail;
 nodesc:
-	ret = sdma_check_progress(sde, wait, tx);
+	ret = sdma_check_progress(sde, wait, tx, submit_count > 0);
 	if (ret == -EAGAIN) {
 		ret = 0;
 		goto retry;
diff --git a/drivers/infiniband/hw/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
index 64f10b8..107011d 100644
--- a/drivers/infiniband/hw/hfi1/sdma.h
+++ b/drivers/infiniband/hw/hfi1/sdma.h
@@ -852,7 +852,8 @@ static inline int sdma_txadd_kvaddr(
 
 int sdma_send_txreq(struct sdma_engine *sde,
 		    struct iowait *wait,
-		    struct sdma_txreq *tx);
+		    struct sdma_txreq *tx,
+		    bool pkts_sent);
 int sdma_send_txlist(struct sdma_engine *sde,
 		     struct iowait *wait,
 		     struct list_head *tx_list,
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 8f7cfdd..ea2993f 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -272,7 +272,8 @@ static int defer_packet_queue(
 	struct sdma_engine *sde,
 	struct iowait *wait,
 	struct sdma_txreq *txreq,
-	unsigned int seq);
+	uint seq,
+	bool pkts_sent);
 static void activate_packet_queue(struct iowait *wait, int reason);
 static bool sdma_rb_filter(struct mmu_rb_node *node, unsigned long addr,
 			   unsigned long len);
@@ -294,7 +295,8 @@ static int defer_packet_queue(
 	struct sdma_engine *sde,
 	struct iowait *wait,
 	struct sdma_txreq *txreq,
-	unsigned seq)
+	uint seq,
+	bool pkts_sent)
 {
 	struct hfi1_user_sdma_pkt_q *pq =
 		container_of(wait, struct hfi1_user_sdma_pkt_q, busy);
@@ -314,7 +316,7 @@ static int defer_packet_queue(
 	xchg(&pq->state, SDMA_PKT_Q_DEFERRED);
 	write_seqlock(&dev->iowait_lock);
 	if (list_empty(&pq->busy.list))
-		list_add_tail(&pq->busy.list, &sde->dmawait);
+		iowait_queue(pkts_sent, &pq->busy, &sde->dmawait);
 	write_sequnlock(&dev->iowait_lock);
 	return -EBUSY;
 eagain:
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 720e71d..3c3a01b 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -864,7 +864,8 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		if (unlikely(ret))
 			goto bail_build;
 	}
-	ret =  sdma_send_txreq(tx->sde, &priv->s_iowait, &tx->txreq);
+	ret =  sdma_send_txreq(tx->sde, &priv->s_iowait, &tx->txreq,
+			       ps->pkts_sent);
 	if (unlikely(ret < 0)) {
 		if (ret == -ECOMM)
 			goto bail_ecomm;
@@ -921,7 +922,8 @@ static int pio_wait(struct rvt_qp *qp,
 			dev->n_piodrain += !!(flag & RVT_S_WAIT_PIO_DRAIN);
 			qp->s_flags |= flag;
 			was_empty = list_empty(&sc->piowait);
-			list_add_tail(&priv->s_iowait.list, &sc->piowait);
+			iowait_queue(ps->pkts_sent, &priv->s_iowait,
+				     &sc->piowait);
 			priv->s_iowait.lock = &dev->iowait_lock;
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_PIO);
 			rvt_get_qp(qp);
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index fdf1e1f..34267c7 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -143,6 +143,7 @@ struct hfi1_pkt_state {
 	unsigned long timeout_int;
 	int cpu;
 	bool in_thread;
+	bool pkts_sent;
 };
 
 #define HFI1_PSN_CREDIT  16
diff --git a/drivers/infiniband/hw/hfi1/vnic.h b/drivers/infiniband/hw/hfi1/vnic.h
index 4a621cd..eec7c14 100644
--- a/drivers/infiniband/hw/hfi1/vnic.h
+++ b/drivers/infiniband/hw/hfi1/vnic.h
@@ -103,6 +103,7 @@ struct hfi1_vnic_sdma {
 	struct sdma_txreq stx;
 	unsigned int state;
 	u8 q_idx;
+	bool pkts_sent;
 };
 
 /**
diff --git a/drivers/infiniband/hw/hfi1/vnic_sdma.c b/drivers/infiniband/hw/hfi1/vnic_sdma.c
index 51a817d..7815d74 100644
--- a/drivers/infiniband/hw/hfi1/vnic_sdma.c
+++ b/drivers/infiniband/hw/hfi1/vnic_sdma.c
@@ -198,11 +198,16 @@ int hfi1_vnic_send_dma(struct hfi1_devdata *dd, u8 q_idx,
 		goto free_desc;
 	tx->retry_count = 0;
 
-	ret = sdma_send_txreq(sde, &vnic_sdma->wait, &tx->txreq);
+	ret = sdma_send_txreq(sde, &vnic_sdma->wait, &tx->txreq,
+			      vnic_sdma->pkts_sent);
 	/* When -ECOMM, sdma callback will be called with ABORT status */
 	if (unlikely(ret && unlikely(ret != -ECOMM)))
 		goto free_desc;
 
+	if (!ret) {
+		vnic_sdma->pkts_sent = true;
+		iowait_starve_clear(vnic_sdma->pkts_sent, &vnic_sdma->wait);
+	}
 	return ret;
 
 free_desc:
@@ -211,6 +216,8 @@ int hfi1_vnic_send_dma(struct hfi1_devdata *dd, u8 q_idx,
 tx_err:
 	if (ret != -EBUSY)
 		dev_kfree_skb_any(skb);
+	else
+		vnic_sdma->pkts_sent = false;
 	return ret;
 }
 
@@ -225,7 +232,8 @@ int hfi1_vnic_send_dma(struct hfi1_devdata *dd, u8 q_idx,
 static int hfi1_vnic_sdma_sleep(struct sdma_engine *sde,
 				struct iowait *wait,
 				struct sdma_txreq *txreq,
-				unsigned int seq)
+				uint seq,
+				bool pkts_sent)
 {
 	struct hfi1_vnic_sdma *vnic_sdma =
 		container_of(wait, struct hfi1_vnic_sdma, wait);
@@ -239,7 +247,7 @@ static int hfi1_vnic_sdma_sleep(struct sdma_engine *sde,
 	vnic_sdma->state = HFI1_VNIC_SDMA_Q_DEFERRED;
 	write_seqlock(&dev->iowait_lock);
 	if (list_empty(&vnic_sdma->wait.list))
-		list_add_tail(&vnic_sdma->wait.list, &sde->dmawait);
+		iowait_queue(pkts_sent, wait, &sde->dmawait);
 	write_sequnlock(&dev->iowait_lock);
 	return -EBUSY;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

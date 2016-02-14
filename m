From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/16] staging/rdma/hfi: fix CQ completion order issue
Date: Sun, 14 Feb 2016 12:45:53 -0800
Message-ID: <20160214204549.29247.97900.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The current implementation of the sdma_wait variable
has a timing hole that can cause a completion Q entry
to be returned from a pio send prior to an older
sdma packets completion queue entry.

The sdma_wait variable used to be decremented prior to
calling the packet complete routine.  The hole is between decrement
and the verbs completion where send engine using pio could return
a out of order completion in that window.

This patch closes the hole by allowing an API option to
specify an sdma_drained callback.   The atomic dec
is positioned after the complete callback to avoid the
window as long as the pio path doesn't execute when
there is a non-zero sdma count.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/iowait.h     |   12 +++-
 drivers/staging/rdma/hfi1/qp.c         |   20 ++++++-
 drivers/staging/rdma/hfi1/sdma.c       |   94 ++++++++++----------------------
 drivers/staging/rdma/hfi1/sdma.h       |    4 +
 drivers/staging/rdma/hfi1/sdma_txreq.h |    2 -
 drivers/staging/rdma/hfi1/user_sdma.c  |    7 +-
 drivers/staging/rdma/hfi1/verbs.c      |   18 +-----
 7 files changed, 65 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/iowait.h b/drivers/staging/rdma/hfi1/iowait.h
index b5eb1e0..2cb3f04 100644
--- a/drivers/staging/rdma/hfi1/iowait.h
+++ b/drivers/staging/rdma/hfi1/iowait.h
@@ -69,7 +69,8 @@ struct sdma_engine;
  * @list: used to add/insert into QP/PQ wait lists
  * @tx_head: overflow list of sdma_txreq's
  * @sleep: no space callback
- * @wakeup: space callback
+ * @wakeup: space callback wakeup
+ * @sdma_drained: sdma count drained
  * @iowork: workqueue overhead
  * @wait_dma: wait for sdma_busy == 0
  * @wait_pio: wait for pio_busy == 0
@@ -104,6 +105,7 @@ struct iowait {
 		struct sdma_txreq *tx,
 		unsigned seq);
 	void (*wakeup)(struct iowait *wait, int reason);
+	void (*sdma_drained)(struct iowait *wait);
 	struct work_struct iowork;
 	wait_queue_head_t wait_dma;
 	wait_queue_head_t wait_pio;
@@ -122,7 +124,7 @@ struct iowait {
  * @tx_limit: limit for overflow queuing
  * @func: restart function for workqueue
  * @sleep: sleep function for no space
- * @wakeup: wakeup function for no space
+ * @resume: wakeup function for no space
  *
  * This function initializes the iowait
  * structure embedded in the QP or PQ.
@@ -138,7 +140,8 @@ static inline void iowait_init(
 		struct iowait *wait,
 		struct sdma_txreq *tx,
 		unsigned seq),
-	void (*wakeup)(struct iowait *wait, int reason))
+	void (*wakeup)(struct iowait *wait, int reason),
+	void (*sdma_drained)(struct iowait *wait))
 {
 	wait->count = 0;
 	INIT_LIST_HEAD(&wait->list);
@@ -151,6 +154,7 @@ static inline void iowait_init(
 	wait->tx_limit = tx_limit;
 	wait->sleep = sleep;
 	wait->wakeup = wakeup;
+	wait->sdma_drained = sdma_drained;
 }
 
 /**
@@ -273,6 +277,8 @@ static inline void iowait_drain_wakeup(struct iowait *wait)
 {
 	wake_up(&wait->wait_dma);
 	wake_up(&wait->wait_pio);
+	if (wait->sdma_drained)
+		wait->sdma_drained(wait);
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index e699b6a..ead7aed 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -73,6 +73,7 @@ static int iowait_sleep(
 	struct sdma_txreq *stx,
 	unsigned seq);
 static void iowait_wakeup(struct iowait *wait, int reason);
+static void iowait_sdma_drained(struct iowait *wait);
 static void qp_pio_drain(struct rvt_qp *qp);
 
 static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
@@ -509,6 +510,22 @@ static void iowait_wakeup(struct iowait *wait, int reason)
 	hfi1_qp_wakeup(qp, RVT_S_WAIT_DMA_DESC);
 }
 
+static void iowait_sdma_drained(struct iowait *wait)
+{
+	struct rvt_qp *qp = iowait_to_qp(wait);
+
+	/*
+	 * This happens when the send engine notes
+	 * a QP in the error state and cannot
+	 * do the flush work until that QP's
+	 * sdma work has finished.
+	 */
+	if (qp->s_flags & RVT_S_WAIT_DMA) {
+		qp->s_flags &= ~RVT_S_WAIT_DMA;
+		hfi1_schedule_send(qp);
+	}
+}
+
 /**
  *
  * qp_to_sdma_engine - map a qp to a send engine
@@ -774,7 +791,8 @@ void notify_qp_reset(struct rvt_qp *qp)
 		1,
 		_hfi1_do_send,
 		iowait_sleep,
-		iowait_wakeup);
+		iowait_wakeup,
+		iowait_sdma_drained);
 	priv->r_adefered = 0;
 	clear_ahg(qp);
 }
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 49e567a..3f29f0a 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -361,6 +361,28 @@ static inline void sdma_set_desc_cnt(struct sdma_engine *sde, unsigned cnt)
 	write_sde_csr(sde, SD(DESC_CNT), reg);
 }
 
+static inline void complete_tx(struct sdma_engine *sde,
+			       struct sdma_txreq *tx,
+			       int res)
+{
+	/* protect against complete modifying */
+	struct iowait *wait = tx->wait;
+	callback_t complete = tx->complete;
+
+#ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
+	trace_hfi1_sdma_out_sn(sde, txp->sn);
+	if (WARN_ON_ONCE(sde->head_sn != txp->sn))
+		dd_dev_err(sde->dd, "expected %llu got %llu\n",
+			   sde->head_sn, txp->sn);
+	sde->head_sn++;
+#endif
+	sdma_txclean(sde->dd, tx);
+	if (complete)
+		(*complete)(tx, res);
+	if (iowait_sdma_dec(wait) && wait)
+		iowait_drain_wakeup(wait);
+}
+
 /*
  * Complete all the sdma requests with a SDMA_TXREQ_S_ABORTED status
  *
@@ -395,27 +417,8 @@ static void sdma_flush(struct sdma_engine *sde)
 	}
 	spin_unlock_irqrestore(&sde->flushlist_lock, flags);
 	/* flush from flush list */
-	list_for_each_entry_safe(txp, txp_next, &flushlist, list) {
-		int drained = 0;
-		/* protect against complete modifying */
-		struct iowait *wait = txp->wait;
-
-		list_del_init(&txp->list);
-#ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
-		trace_hfi1_sdma_out_sn(sde, txp->sn);
-		if (WARN_ON_ONCE(sde->head_sn != txp->sn))
-			dd_dev_err(sde->dd, "expected %llu got %llu\n",
-				sde->head_sn, txp->sn);
-		sde->head_sn++;
-#endif
-		sdma_txclean(sde->dd, txp);
-		if (wait)
-			drained = iowait_sdma_dec(wait);
-		if (txp->complete)
-			(*txp->complete)(txp, SDMA_TXREQ_S_ABORTED, drained);
-		if (wait && drained)
-			iowait_drain_wakeup(wait);
-	}
+	list_for_each_entry_safe(txp, txp_next, &flushlist, list)
+		complete_tx(sde, txp, SDMA_TXREQ_S_ABORTED);
 }
 
 /*
@@ -577,31 +580,10 @@ static void sdma_flush_descq(struct sdma_engine *sde)
 		head = ++sde->descq_head & sde->sdma_mask;
 		/* if now past this txp's descs, do the callback */
 		if (txp && txp->next_descq_idx == head) {
-			int drained = 0;
-			/* protect against complete modifying */
-			struct iowait *wait = txp->wait;
-
 			/* remove from list */
 			sde->tx_ring[sde->tx_head++ & sde->sdma_mask] = NULL;
-			if (wait)
-				drained = iowait_sdma_dec(wait);
-#ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
-			trace_hfi1_sdma_out_sn(sde, txp->sn);
-			if (WARN_ON_ONCE(sde->head_sn != txp->sn))
-				dd_dev_err(sde->dd, "expected %llu got %llu\n",
-					sde->head_sn, txp->sn);
-			sde->head_sn++;
-#endif
-			sdma_txclean(sde->dd, txp);
+			complete_tx(sde, txp, SDMA_TXREQ_S_ABORTED);
 			trace_hfi1_sdma_progress(sde, head, tail, txp);
-			if (txp->complete)
-				(*txp->complete)(
-					txp,
-					SDMA_TXREQ_S_ABORTED,
-					drained);
-			if (wait && drained)
-				iowait_drain_wakeup(wait);
-			/* see if there is another txp */
 			txp = get_txhead(sde);
 		}
 		progress++;
@@ -1471,7 +1453,7 @@ static void sdma_make_progress(struct sdma_engine *sde, u64 status)
 {
 	struct sdma_txreq *txp = NULL;
 	int progress = 0;
-	u16 hwhead, swhead, swtail;
+	u16 hwhead, swhead;
 	int idle_check_done = 0;
 
 	hwhead = sdma_gethead(sde);
@@ -1492,29 +1474,9 @@ retry:
 
 		/* if now past this txp's descs, do the callback */
 		if (txp && txp->next_descq_idx == swhead) {
-			int drained = 0;
-			/* protect against complete modifying */
-			struct iowait *wait = txp->wait;
-
 			/* remove from list */
 			sde->tx_ring[sde->tx_head++ & sde->sdma_mask] = NULL;
-			if (wait)
-				drained = iowait_sdma_dec(wait);
-#ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
-			trace_hfi1_sdma_out_sn(sde, txp->sn);
-			if (WARN_ON_ONCE(sde->head_sn != txp->sn))
-				dd_dev_err(sde->dd, "expected %llu got %llu\n",
-					sde->head_sn, txp->sn);
-			sde->head_sn++;
-#endif
-			sdma_txclean(sde->dd, txp);
-			if (txp->complete)
-				(*txp->complete)(
-					txp,
-					SDMA_TXREQ_S_OK,
-					drained);
-			if (wait && drained)
-				iowait_drain_wakeup(wait);
+			complete_tx(sde, txp, SDMA_TXREQ_S_OK);
 			/* see if there is another txp */
 			txp = get_txhead(sde);
 		}
@@ -1532,6 +1494,8 @@ retry:
 	 * of sdma_make_progress(..) which is ensured by idle_check_done flag
 	 */
 	if ((status & sde->idle_mask) && !idle_check_done) {
+		u16 swtail;
+
 		swtail = ACCESS_ONCE(sde->descq_tail) & sde->sdma_mask;
 		if (swtail != hwhead) {
 			hwhead = (u16)read_sde_csr(sde, SD(HEAD));
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 76ed215..f24b5a1 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -555,7 +555,7 @@ static inline int sdma_txinit_ahg(
 	u8 num_ahg,
 	u32 *ahg,
 	u8 ahg_hlen,
-	void (*cb)(struct sdma_txreq *, int, int))
+	void (*cb)(struct sdma_txreq *, int))
 {
 	if (tlen == 0)
 		return -ENODATA;
@@ -618,7 +618,7 @@ static inline int sdma_txinit(
 	struct sdma_txreq *tx,
 	u16 flags,
 	u16 tlen,
-	void (*cb)(struct sdma_txreq *, int, int))
+	void (*cb)(struct sdma_txreq *, int))
 {
 	return sdma_txinit_ahg(tx, flags, tlen, 0, 0, NULL, 0, cb);
 }
diff --git a/drivers/staging/rdma/hfi1/sdma_txreq.h b/drivers/staging/rdma/hfi1/sdma_txreq.h
index 2effb35..bf7d777 100644
--- a/drivers/staging/rdma/hfi1/sdma_txreq.h
+++ b/drivers/staging/rdma/hfi1/sdma_txreq.h
@@ -93,7 +93,7 @@ struct sdma_desc {
 #define SDMA_TXREQ_F_USE_AHG      0x0004
 
 struct sdma_txreq;
-typedef void (*callback_t)(struct sdma_txreq *, int, int);
+typedef void (*callback_t)(struct sdma_txreq *, int);
 
 struct iowait;
 struct sdma_txreq {
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index ac90309..dfa9ef2 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -273,7 +273,7 @@ struct user_sdma_txreq {
 
 static int user_sdma_send_pkts(struct user_sdma_request *, unsigned);
 static int num_user_pages(const struct iovec *);
-static void user_sdma_txreq_cb(struct sdma_txreq *, int, int);
+static void user_sdma_txreq_cb(struct sdma_txreq *, int);
 static inline void pq_update(struct hfi1_user_sdma_pkt_q *);
 static void user_sdma_free_request(struct user_sdma_request *, bool);
 static int pin_vector_pages(struct user_sdma_request *,
@@ -388,7 +388,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	init_waitqueue_head(&pq->wait);
 
 	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
-		    activate_packet_queue);
+		    activate_packet_queue, NULL);
 	pq->reqidx = 0;
 	snprintf(buf, 64, "txreq-kmem-cache-%u-%u-%u", dd->unit, uctxt->ctxt,
 		 fd->subctxt);
@@ -1341,8 +1341,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
  * tx request have been processed by the DMA engine. Called in
  * interrupt context.
  */
-static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status,
-			       int drain)
+static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status)
 {
 	struct user_sdma_txreq *tx =
 		container_of(txreq, struct user_sdma_txreq, txreq);
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index d900374..3141966 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -130,8 +130,7 @@ MODULE_PARM_DESC(piothreshold, "size used to determine sdma vs. pio");
 
 static void verbs_sdma_complete(
 	struct sdma_txreq *cookie,
-	int status,
-	int drained);
+	int status);
 
 static int pio_wait(struct rvt_qp *qp,
 		    struct send_context *sc,
@@ -523,8 +522,7 @@ void update_sge(struct rvt_sge_state *ss, u32 length)
 /* New API */
 static void verbs_sdma_complete(
 	struct sdma_txreq *cookie,
-	int status,
-	int drained)
+	int status)
 {
 	struct verbs_txreq *tx =
 		container_of(cookie, struct verbs_txreq, txreq);
@@ -539,18 +537,6 @@ static void verbs_sdma_complete(
 		hdr = &tx->phdr.hdr;
 		hfi1_rc_send_complete(qp, hdr);
 	}
-	if (drained) {
-		/*
-		 * This happens when the send engine notes
-		 * a QP in the error state and cannot
-		 * do the flush work until that QP's
-		 * sdma work has finished.
-		 */
-		if (qp->s_flags & RVT_S_WAIT_DMA) {
-			qp->s_flags &= ~RVT_S_WAIT_DMA;
-			hfi1_schedule_send(qp);
-		}
-	}
 	spin_unlock(&qp->s_lock);
 
 	hfi1_put_txreq(tx);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 04/14] cxgb4: Update to use new udma write barriers
Date: Thu, 16 Feb 2017 12:22:59 -0700
Message-ID: <1487272989-8215-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Based on help from Steve the barriers here are change to consistently
bracket WC memory writes with wc_wmb() like other drivers do.

This allows some of the wc_wmb() calls that were not related to WC
memory be downgraded to wmb().

The driver was probably correct (at least for x86-64) but did not
follow the idiom established by the other drivers for working with
WC memry.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/cxgb4/qp.c    | 20 ++++++++++++++++++--
 providers/cxgb4/t4.h    | 48 +++++++++++++++++++++++++++++++++++-------------
 providers/cxgb4/verbs.c |  2 ++
 3 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/providers/cxgb4/qp.c b/providers/cxgb4/qp.c
index 700fe02c77c269..45eaca45029e60 100644
--- a/providers/cxgb4/qp.c
+++ b/providers/cxgb4/qp.c
@@ -52,7 +52,12 @@ static void copy_wr_to_sq(struct t4_wq *wq, union t4_wr *wqe, u8 len16)
 	dst = (u64 *)((u8 *)wq->sq.queue + wq->sq.wq_pidx * T4_EQ_ENTRY_SIZE);
 	if (t4_sq_onchip(wq)) {
 		len16 = align(len16, 4);
-		wc_wmb();
+
+		/* In onchip mode the copy below will be made to WC memory and
+		 * could trigger DMA. In offchip mode the copy below only
+		 * queues the WQE, DMA cannot start until t4_ring_sq_db
+		 * happens */
+		mmio_wc_start();
 	}
 	while (len16) {
 		*dst++ = *src++;
@@ -62,7 +67,13 @@ static void copy_wr_to_sq(struct t4_wq *wq, union t4_wr *wqe, u8 len16)
 		if (dst == (u64 *)&wq->sq.queue[wq->sq.size])
 			dst = (u64 *)wq->sq.queue;
 		len16--;
+
+		/* NOTE len16 cannot be large enough to write to the
+		   same sq.queue memory twice in this loop */
 	}
+
+	if (t4_sq_onchip(wq))
+		mmio_flush_writes();
 }
 
 static void copy_wr_to_rq(struct t4_wq *wq, union t4_recv_wr *wqe, u8 len16)
@@ -274,7 +285,9 @@ static void ring_kernel_db(struct c4iw_qp *qhp, u32 qid, u16 idx)
 	int mask;
 	int __attribute__((unused)) ret;
 
-	wc_wmb();
+	/* FIXME: Why do we need this barrier if the kernel is going to
+	   trigger the DMA? */
+	udma_to_device_barrier();
 	if (qid == qhp->wq.sq.qid) {
 		attr.sq_psn = idx;
 		mask = IBV_QP_SQ_PSN;
@@ -385,8 +398,11 @@ int c4iw_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			      len16, wqe);
 	} else
 		ring_kernel_db(qhp, qhp->wq.sq.qid, idx);
+	/* This write is only for debugging, the value does not matter for DMA
+	 */
 	qhp->wq.sq.queue[qhp->wq.sq.size].status.host_wq_pidx = \
 			(qhp->wq.sq.wq_pidx);
+
 	pthread_spin_unlock(&qhp->lock);
 	return err;
 }
diff --git a/providers/cxgb4/t4.h b/providers/cxgb4/t4.h
index a457e2f2921727..a845a367cfbb8c 100644
--- a/providers/cxgb4/t4.h
+++ b/providers/cxgb4/t4.h
@@ -317,9 +317,12 @@ enum {
 };
 
 struct t4_sq {
+	/* queue is either host memory or WC MMIO memory if
+	 * t4_sq_onchip(). */
 	union t4_wr *queue;
 	struct t4_swsqe *sw_sq;
 	struct t4_swsqe *oldest_read;
+	/* udb is either UC or WC MMIO memory depending on device version. */
 	volatile u32 *udb;
 	size_t memsize;
 	u32 qid;
@@ -367,12 +370,6 @@ struct t4_wq {
 	u8 *db_offp;
 };
 
-static inline void t4_ma_sync(struct t4_wq *wq, int page_size)
-{
-	wc_wmb();
-	*((volatile u32 *)wq->sq.ma_sync) = 1;
-}
-
 static inline int t4_rqes_posted(struct t4_wq *wq)
 {
 	return wq->rq.in_use;
@@ -444,8 +441,11 @@ static inline void t4_sq_produce(struct t4_wq *wq, u8 len16)
 	wq->sq.wq_pidx += DIV_ROUND_UP(len16*16, T4_EQ_ENTRY_SIZE);
 	if (wq->sq.wq_pidx >= wq->sq.size * T4_SQ_NUM_SLOTS)
 		wq->sq.wq_pidx %= wq->sq.size * T4_SQ_NUM_SLOTS;
-	if (!wq->error)
+	if (!wq->error) {
+		/* This write is only for debugging, the value does not matter
+		 * for DMA */
 		wq->sq.queue[wq->sq.size].status.host_pidx = (wq->sq.pidx);
+	}
 }
 
 static inline void t4_sq_consume(struct t4_wq *wq)
@@ -457,10 +457,14 @@ static inline void t4_sq_consume(struct t4_wq *wq)
 	if (++wq->sq.cidx == wq->sq.size)
 		wq->sq.cidx = 0;
 	assert((wq->sq.cidx != wq->sq.pidx) || wq->sq.in_use == 0);
-	if (!wq->error)
+	if (!wq->error){
+		/* This write is only for debugging, the value does not matter
+		 * for DMA */
 		wq->sq.queue[wq->sq.size].status.host_cidx = wq->sq.cidx;
+	}
 }
 
+/* Copies to WC MMIO memory */
 static void copy_wqe_to_udb(volatile u32 *udb_offset, void *wqe)
 {
 	u64 *src, *dst;
@@ -482,8 +486,8 @@ extern int t5_en_wc;
 static inline void t4_ring_sq_db(struct t4_wq *wq, u16 inc, u8 t4, u8 len16,
 				 union t4_wr *wqe)
 {
-	wc_wmb();
 	if (!t4) {
+		mmio_wc_start();
 		if (t5_en_wc && inc == 1 && wq->sq.wc_reg_available) {
 			PDBG("%s: WC wq->sq.pidx = %d; len16=%d\n",
 			     __func__, wq->sq.pidx, len16);
@@ -494,30 +498,45 @@ static inline void t4_ring_sq_db(struct t4_wq *wq, u16 inc, u8 t4, u8 len16,
 			writel(QID_V(wq->sq.bar2_qid) | PIDX_T5_V(inc),
 			       wq->sq.udb);
 		}
-		wc_wmb();
+		/* udb is WC for > t4 devices */
+		mmio_flush_writes();
 		return;
 	}
+
+	udma_to_device_barrier();
 	if (ma_wr) {
 		if (t4_sq_onchip(wq)) {
 			int i;
+
+			mmio_wc_start();
 			for (i = 0; i < 16; i++)
 				*(volatile u32 *)&wq->sq.queue[wq->sq.size].flits[2+i] = i;
+			mmio_flush_writes();
 		}
 	} else {
 		if (t4_sq_onchip(wq)) {
 			int i;
+
+			mmio_wc_start();
 			for (i = 0; i < 16; i++)
+				/* FIXME: What is this supposed to be doing?
+				 * Writing to the same address multiple times
+				 * with WC memory is not guarenteed to
+				 * generate any more than one TLP. Why isn't
+				 * writing to WC memory marked volatile? */
 				*(u32 *)&wq->sq.queue[wq->sq.size].flits[2] = i;
+			mmio_flush_writes();
 		}
 	}
+	/* udb is UC for t4 devices */
 	writel(QID_V(wq->sq.qid & wq->qid_mask) | PIDX_V(inc), wq->sq.udb);
 }
 
 static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc, u8 t4, u8 len16,
 				 union t4_recv_wr *wqe)
 {
-	wc_wmb();
 	if (!t4) {
+		mmio_wc_start();
 		if (t5_en_wc && inc == 1 && wq->sq.wc_reg_available) {
 			PDBG("%s: WC wq->rq.pidx = %d; len16=%d\n",
 			     __func__, wq->rq.pidx, len16);
@@ -528,9 +547,12 @@ static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc, u8 t4, u8 len16,
 			writel(QID_V(wq->rq.bar2_qid) | PIDX_T5_V(inc),
 			       wq->rq.udb);
 		}
-		wc_wmb();
+		/* udb is WC for > t4 devices */
+		mmio_flush_writes();
 		return;
 	}
+	/* udb is UC for t4 devices */
+	udma_to_device_barrier();
 	writel(QID_V(wq->rq.qid & wq->qid_mask) | PIDX_V(inc), wq->rq.udb);
 }
 
@@ -655,7 +677,7 @@ static inline int t4_next_hw_cqe(struct t4_cq *cq, struct t4_cqe **cqe)
 		cq->error = 1;
 		assert(0);
 	} else if (t4_valid_cqe(cq, &cq->queue[cq->cidx])) {
-		rmb();
+		udma_from_device_barrier();
 		*cqe = &cq->queue[cq->cidx];
 		ret = 0;
 	} else
diff --git a/providers/cxgb4/verbs.c b/providers/cxgb4/verbs.c
index 32ed44c63d8402..e7620dc02ae0a7 100644
--- a/providers/cxgb4/verbs.c
+++ b/providers/cxgb4/verbs.c
@@ -573,6 +573,8 @@ static void reset_qp(struct c4iw_qp *qhp)
 	qhp->wq.rq.cidx = qhp->wq.rq.pidx = qhp->wq.rq.in_use = 0;
 	qhp->wq.sq.oldest_read = NULL;
 	memset(qhp->wq.sq.queue, 0, qhp->wq.sq.memsize);
+	if (t4_sq_onchip(&qhp->wq))
+		mmio_flush_writes();
 	memset(qhp->wq.rq.queue, 0, qhp->wq.rq.memsize);
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

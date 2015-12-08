From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 5/5] staging/rdma/hfi1: Add page lock limit check for SDMA requests
Date: Tue,  8 Dec 2015 17:10:13 -0500
Message-ID: <1449612613-6616-6-git-send-email-ira.weiny@intel.com>
References: <1449612613-6616-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449612613-6616-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The driver pins pages on behalf of user processes in two
separate instances - when the process has submitted a
SDMA transfer and when the process programs an expected
receive buffer.

When pinning pages, the driver is required to observe the
locked page limit set by the system administrator and refuse
to lock more pages than allowed. Such a check was done for
expected receives but was missing from the SDMA transfer
code path.

This commit adds the missing check for SDMA transfers. As of
this commit, user SDMA or expected receive requests will be
rejected if the number of pages required to be pinned will
exceed the set limit.

Due to the fact that the driver needs to take the MM semaphore
in order to update the locked page count (which can sleep), this
cannot be done by the callback function as it [the callback] is
executed in interrupt context. Therefore, it is necessary to put
all the completed SDMA tx requests onto a separate list (txcmp) and
offload the actual clean-up and unpinning work to a workqueue.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	Fix off by 1 error

 drivers/staging/rdma/hfi1/user_sdma.c | 276 ++++++++++++++++++++--------------
 drivers/staging/rdma/hfi1/user_sdma.h |   2 +
 2 files changed, 169 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 3033df5596f3..d3de771a0770 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -214,12 +214,6 @@ struct user_sdma_request {
 	 */
 	u8 omfactor;
 	/*
-	 * pointer to the user's task_struct. We are going to
-	 * get a reference to it so we can process io vectors
-	 * at a later time.
-	 */
-	struct task_struct *user_proc;
-	/*
 	 * pointer to the user's mm_struct. We are going to
 	 * get a reference to it so it doesn't get freed
 	 * since we might not be in process context when we
@@ -245,9 +239,13 @@ struct user_sdma_request {
 	u16 tididx;
 	u32 sent;
 	u64 seqnum;
-	spinlock_t list_lock;
 	struct list_head txps;
+	spinlock_t txcmp_lock;  /* protect txcmp list */
+	struct list_head txcmp;
 	unsigned long flags;
+	/* status of the last txreq completed */
+	int status;
+	struct work_struct worker;
 };
 
 /*
@@ -260,6 +258,7 @@ struct user_sdma_txreq {
 	/* Packet header for the txreq */
 	struct hfi1_pkt_header hdr;
 	struct sdma_txreq txreq;
+	struct list_head list;
 	struct user_sdma_request *req;
 	struct {
 		struct user_sdma_iovec *vec;
@@ -282,10 +281,12 @@ struct user_sdma_txreq {
 static int user_sdma_send_pkts(struct user_sdma_request *, unsigned);
 static int num_user_pages(const struct iovec *);
 static void user_sdma_txreq_cb(struct sdma_txreq *, int, int);
+static void user_sdma_delayed_completion(struct work_struct *);
 static void user_sdma_free_request(struct user_sdma_request *);
 static int pin_vector_pages(struct user_sdma_request *,
 			    struct user_sdma_iovec *);
-static void unpin_vector_pages(struct user_sdma_iovec *);
+static void unpin_vector_pages(struct user_sdma_request *,
+			       struct user_sdma_iovec *);
 static int check_header_template(struct user_sdma_request *,
 				 struct hfi1_pkt_header *, u32, u32);
 static int set_txreq_header(struct user_sdma_request *,
@@ -391,6 +392,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	pq->n_max_reqs = hfi1_sdma_comp_ring_size;
 	pq->state = SDMA_PKT_Q_INACTIVE;
 	atomic_set(&pq->n_reqs, 0);
+	init_waitqueue_head(&pq->wait);
 
 	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
 		    activate_packet_queue);
@@ -451,26 +453,16 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 		  uctxt->ctxt, fd->subctxt);
 	pq = fd->pq;
 	if (pq) {
-		u16 i, j;
-
 		spin_lock_irqsave(&uctxt->sdma_qlock, flags);
 		if (!list_empty(&pq->list))
 			list_del_init(&pq->list);
 		spin_unlock_irqrestore(&uctxt->sdma_qlock, flags);
 		iowait_sdma_drain(&pq->busy);
-		if (pq->reqs) {
-			for (i = 0, j = 0; i < atomic_read(&pq->n_reqs) &&
-				     j < pq->n_max_reqs; j++) {
-				struct user_sdma_request *req = &pq->reqs[j];
-
-				if (test_bit(SDMA_REQ_IN_USE, &req->flags)) {
-					set_comp_state(req, ERROR, -ECOMM);
-					user_sdma_free_request(req);
-					i++;
-				}
-			}
-			kfree(pq->reqs);
-		}
+		/* Wait until all requests have been freed. */
+		wait_event_interruptible(
+			pq->wait,
+			(ACCESS_ONCE(pq->state) == SDMA_PKT_Q_INACTIVE));
+		kfree(pq->reqs);
 		kmem_cache_destroy(pq->txreq_cache);
 		kfree(pq);
 		fd->pq = NULL;
@@ -540,8 +532,12 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	req->data_iovs = req_iovcnt(info.ctrl) - 1;
 	req->pq = pq;
 	req->cq = cq;
+	req->status = -1;
 	INIT_LIST_HEAD(&req->txps);
-	spin_lock_init(&req->list_lock);
+	INIT_LIST_HEAD(&req->txcmp);
+	INIT_WORK(&req->worker, user_sdma_delayed_completion);
+
+	spin_lock_init(&req->txcmp_lock);
 	memcpy(&req->info, &info, sizeof(info));
 
 	if (req_opcode(info.ctrl) == EXPECTED)
@@ -680,18 +676,16 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	sent = user_sdma_send_pkts(req, pcount);
 	if (unlikely(sent < 0)) {
 		if (sent != -EBUSY) {
-			ret = sent;
-			goto send_err;
+			req->status = sent;
+			set_comp_state(req, ERROR, req->status);
+			return sent;
 		} else
 			sent = 0;
 	}
 	atomic_inc(&pq->n_reqs);
+	xchg(&pq->state, SDMA_PKT_Q_ACTIVE);
 
 	if (sent < req->info.npkts) {
-		/* Take the references to the user's task and mm_struct */
-		get_task_struct(current);
-		req->user_proc = current;
-
 		/*
 		 * This is a somewhat blocking send implementation.
 		 * The driver will block the caller until all packets of the
@@ -701,8 +695,10 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		while (!test_bit(SDMA_REQ_SEND_DONE, &req->flags)) {
 			ret = user_sdma_send_pkts(req, pcount);
 			if (ret < 0) {
-				if (ret != -EBUSY)
-					goto send_err;
+				if (ret != -EBUSY) {
+					req->status = ret;
+					return ret;
+				}
 				wait_event_interruptible_timeout(
 					pq->busy.wait_dma,
 					(pq->state == SDMA_PKT_Q_ACTIVE),
@@ -712,14 +708,10 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		}
 
 	}
-	ret = 0;
 	*count += idx;
-	goto done;
-send_err:
-	set_comp_state(req, ERROR, ret);
+	return 0;
 free_req:
 	user_sdma_free_request(req);
-done:
 	return ret;
 }
 
@@ -822,6 +814,7 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		tx->req = req;
 		tx->busycount = 0;
 		tx->idx = -1;
+		INIT_LIST_HEAD(&tx->list);
 		memset(tx->iovecs, 0, sizeof(tx->iovecs));
 
 		if (req->seqnum == req->info.npkts - 1)
@@ -946,9 +939,8 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 			if (ret) {
 				int i;
 
-				dd_dev_err(pq->dd,
-					   "SDMA txreq add page failed %d\n",
-					   ret);
+				SDMA_DBG(req, "SDMA txreq add page failed %d\n",
+					 ret);
 				/* Mark all assigned vectors as complete so they
 				 * are unpinned in the callback. */
 				for (i = tx->idx; i >= 0; i--) {
@@ -1042,52 +1034,58 @@ static inline int num_user_pages(const struct iovec *iov)
 
 static int pin_vector_pages(struct user_sdma_request *req,
 			    struct user_sdma_iovec *iovec) {
-	int ret = 0;
-	unsigned pinned;
+	int pinned, npages;
 
-	iovec->npages = num_user_pages(&iovec->iov);
-	iovec->pages = kcalloc(iovec->npages, sizeof(*iovec->pages),
-			       GFP_KERNEL);
+	npages = num_user_pages(&iovec->iov);
+	iovec->pages = kcalloc(npages, sizeof(*iovec->pages), GFP_KERNEL);
 	if (!iovec->pages) {
 		SDMA_DBG(req, "Failed page array alloc");
-		ret = -ENOMEM;
-		goto done;
+		return -ENOMEM;
 	}
-	/* If called by the kernel thread, use the user's mm */
-	if (current->flags & PF_KTHREAD)
-		use_mm(req->user_proc->mm);
-	pinned = get_user_pages_fast(
-		(unsigned long)iovec->iov.iov_base,
-		iovec->npages, 0, iovec->pages);
-	/* If called by the kernel thread, unuse the user's mm */
-	if (current->flags & PF_KTHREAD)
-		unuse_mm(req->user_proc->mm);
-	if (pinned != iovec->npages) {
-		SDMA_DBG(req, "Failed to pin pages (%u/%u)", pinned,
-			 iovec->npages);
-		ret = -EFAULT;
-		goto pfree;
+
+	/*
+	 * Get a reference to the process's mm so we can use it when
+	 * unpinning the io vectors.
+	 */
+	req->pq->user_mm = get_task_mm(current);
+
+	pinned = hfi1_acquire_user_pages((unsigned long)iovec->iov.iov_base,
+					 npages, 0, iovec->pages);
+
+	if (pinned < 0)
+		return pinned;
+
+	iovec->npages = pinned;
+	if (pinned != npages) {
+		SDMA_DBG(req, "Failed to pin pages (%d/%u)", pinned, npages);
+		unpin_vector_pages(req, iovec);
+		return -EFAULT;
 	}
-	goto done;
-pfree:
-	unpin_vector_pages(iovec);
-done:
-	return ret;
+	return 0;
 }
 
-static void unpin_vector_pages(struct user_sdma_iovec *iovec)
+static void unpin_vector_pages(struct user_sdma_request *req,
+			       struct user_sdma_iovec *iovec)
 {
-	unsigned i;
+	/*
+	 * Unpinning is done through the workqueue so use the
+	 * process's mm if we have a reference to it.
+	 */
+	if ((current->flags & PF_KTHREAD) && req->pq->user_mm)
+		use_mm(req->pq->user_mm);
 
-	if (ACCESS_ONCE(iovec->offset) != iovec->iov.iov_len) {
-		hfi1_cdbg(SDMA,
-			  "the complete vector has not been sent yet %llu %zu",
-			  iovec->offset, iovec->iov.iov_len);
-		return;
+	hfi1_release_user_pages(iovec->pages, iovec->npages, 0);
+
+	/*
+	 * Unuse the user's mm (see above) and release the
+	 * reference to it.
+	 */
+	if (req->pq->user_mm) {
+		if (current->flags & PF_KTHREAD)
+			unuse_mm(req->pq->user_mm);
+		mmput(req->pq->user_mm);
 	}
-	for (i = 0; i < iovec->npages; i++)
-		if (iovec->pages[i])
-			put_page(iovec->pages[i]);
+
 	kfree(iovec->pages);
 	iovec->pages = NULL;
 	iovec->npages = 0;
@@ -1355,54 +1353,116 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 	return diff;
 }
 
+/*
+ * SDMA tx request completion callback. Called when the SDMA progress
+ * state machine gets notification that the SDMA descriptors for this
+ * tx request have been processed by the DMA engine. Called in
+ * interrupt context.
+ */
 static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status,
 			       int drain)
 {
 	struct user_sdma_txreq *tx =
 		container_of(txreq, struct user_sdma_txreq, txreq);
-	struct user_sdma_request *req = tx->req;
-	struct hfi1_user_sdma_pkt_q *pq = req ? req->pq : NULL;
-	u64 tx_seqnum;
+	struct user_sdma_request *req;
+	bool defer;
+	int i;
 
-	if (unlikely(!req || !pq))
+	if (!tx->req)
 		return;
 
-	/* If we have any io vectors associated with this txreq,
-	 * check whether they need to be 'freed'. */
-	if (tx->idx != -1) {
-		int i;
+	req = tx->req;
+	/*
+	 * If this is the callback for the last packet of the request,
+	 * queue up the request for clean up.
+	 */
+	defer = (tx->seqnum == req->info.npkts - 1);
 
-		for (i = tx->idx; i >= 0; i--) {
-			if (tx->iovecs[i].flags & TXREQ_FLAGS_IOVEC_LAST_PKT)
-				unpin_vector_pages(tx->iovecs[i].vec);
+	/*
+	 * If we have any io vectors associated with this txreq,
+	 * check whether they need to be 'freed'. We can't free them
+	 * here because the unpin function needs to be able to sleep.
+	 */
+	for (i = tx->idx; i >= 0; i--) {
+		if (tx->iovecs[i].flags & TXREQ_FLAGS_IOVEC_LAST_PKT) {
+			defer = true;
+			break;
 		}
 	}
 
-	tx_seqnum = tx->seqnum;
-	kmem_cache_free(pq->txreq_cache, tx);
-
+	req->status = status;
 	if (status != SDMA_TXREQ_S_OK) {
-		dd_dev_err(pq->dd, "SDMA completion with error %d", status);
-		set_comp_state(req, ERROR, status);
+		SDMA_DBG(req, "SDMA completion with error %d",
+			 status);
 		set_bit(SDMA_REQ_HAS_ERROR, &req->flags);
-		/* Do not free the request until the sender loop has ack'ed
-		 * the error and we've seen all txreqs. */
-		if (tx_seqnum == ACCESS_ONCE(req->seqnum) &&
-		    test_bit(SDMA_REQ_DONE_ERROR, &req->flags)) {
-			atomic_dec(&pq->n_reqs);
-			user_sdma_free_request(req);
-		}
+		defer = true;
+	}
+
+	/*
+	 * Defer the clean up of the iovectors and the request until later
+	 * so it can be done outside of interrupt context.
+	 */
+	if (defer) {
+		spin_lock(&req->txcmp_lock);
+		list_add_tail(&tx->list, &req->txcmp);
+		spin_unlock(&req->txcmp_lock);
+		schedule_work(&req->worker);
 	} else {
-		if (tx_seqnum == req->info.npkts - 1) {
-			/* We've sent and completed all packets in this
-			 * request. Signal completion to the user */
-			atomic_dec(&pq->n_reqs);
-			set_comp_state(req, COMPLETE, 0);
-			user_sdma_free_request(req);
+		kmem_cache_free(req->pq->txreq_cache, tx);
+	}
+}
+
+static void user_sdma_delayed_completion(struct work_struct *work)
+{
+	struct user_sdma_request *req =
+		container_of(work, struct user_sdma_request, worker);
+	struct hfi1_user_sdma_pkt_q *pq = req->pq;
+	struct user_sdma_txreq *tx = NULL;
+	unsigned long flags;
+	u64 seqnum;
+	int i;
+
+	while (1) {
+		spin_lock_irqsave(&req->txcmp_lock, flags);
+		if (!list_empty(&req->txcmp)) {
+			tx = list_first_entry(&req->txcmp,
+					      struct user_sdma_txreq, list);
+			list_del(&tx->list);
+		}
+		spin_unlock_irqrestore(&req->txcmp_lock, flags);
+		if (!tx)
+			break;
+
+		for (i = tx->idx; i >= 0; i--)
+			if (tx->iovecs[i].flags & TXREQ_FLAGS_IOVEC_LAST_PKT)
+				unpin_vector_pages(req, tx->iovecs[i].vec);
+
+		seqnum = tx->seqnum;
+		kmem_cache_free(pq->txreq_cache, tx);
+		tx = NULL;
+
+		if (req->status != SDMA_TXREQ_S_OK) {
+			if (seqnum == ACCESS_ONCE(req->seqnum) &&
+			    test_bit(SDMA_REQ_DONE_ERROR, &req->flags)) {
+				atomic_dec(&pq->n_reqs);
+				set_comp_state(req, ERROR, req->status);
+				user_sdma_free_request(req);
+				break;
+			}
+		} else {
+			if (seqnum == req->info.npkts - 1) {
+				atomic_dec(&pq->n_reqs);
+				set_comp_state(req, COMPLETE, 0);
+				user_sdma_free_request(req);
+				break;
+			}
 		}
 	}
-	if (!atomic_read(&pq->n_reqs))
+
+	if (!atomic_read(&pq->n_reqs)) {
 		xchg(&pq->state, SDMA_PKT_Q_INACTIVE);
+		wake_up(&pq->wait);
+	}
 }
 
 static void user_sdma_free_request(struct user_sdma_request *req)
@@ -1423,10 +1483,8 @@ static void user_sdma_free_request(struct user_sdma_request *req)
 
 		for (i = 0; i < req->data_iovs; i++)
 			if (req->iovs[i].npages && req->iovs[i].pages)
-				unpin_vector_pages(&req->iovs[i]);
+				unpin_vector_pages(req, &req->iovs[i]);
 	}
-	if (req->user_proc)
-		put_task_struct(req->user_proc);
 	kfree(req->tids);
 	clear_bit(SDMA_REQ_IN_USE, &req->flags);
 }
diff --git a/drivers/staging/rdma/hfi1/user_sdma.h b/drivers/staging/rdma/hfi1/user_sdma.h
index 0046ffa774fe..0afa28508a8a 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.h
+++ b/drivers/staging/rdma/hfi1/user_sdma.h
@@ -68,6 +68,8 @@ struct hfi1_user_sdma_pkt_q {
 	struct user_sdma_request *reqs;
 	struct iowait busy;
 	unsigned state;
+	wait_queue_head_t wait;
+	struct mm_struct *user_mm;
 };
 
 struct hfi1_user_sdma_comp_q {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

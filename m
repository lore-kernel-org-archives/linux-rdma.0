From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 32/54] staging/rdma/hfi1: Improve performance of SDMA
 transfers
Date: Wed, 03 Feb 2016 14:35:06 -0800
Message-ID: <20160203223503.5923.12298.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Commit a0d406934a46 ("staging/rdma/hfi1: Add page lock limit
check for SDMA requests") added a mechanism to
delay the clean-up of user SDMA requests in order to facilitate
proper locked page counting.

This delayed processing was done using a kernel workqueue, which
meant that a kernel thread would have to spin up and take CPU
cycles to do the clean-up.

This proved detrimental to performance because now there are two
execution threads (the kernel workqueue and the user process)
needing cycles on the same CPU.

Performance-wise, it is much better to do as much of the clean-up
as can be done in interrupt context (during the callback) and do
the remaining work in-line during subsequent calls of the user
process into the driver.

The changes required to implement the above also significantly
simplify the entire SDMA completion processing code and eliminate
a memory corruption causing the following observed crash:

    [ 2881.703362] BUG: unable to handle kernel NULL pointer dereference at        (null)
    [ 2881.703389] IP: [<ffffffffa02897e4>] user_sdma_send_pkts+0xcd4/0x18e0 [hfi1]
    [ 2881.703422] PGD 7d4d25067 PUD 77d96d067 PMD 0
    [ 2881.703427] Oops: 0000 [#1] SMP
    [ 2881.703431] Modules linked in:
    [ 2881.703504] CPU: 28 PID: 6668 Comm: mpi_stress Tainted: G           OENX 3.12.28-4-default #1
    [ 2881.703508] Hardware name: Intel Corporation S2600KP/S2600KP, BIOS SE5C610.86B.11.01.0044.090
    [ 2881.703512] task: ffff88077da8e0c0 ti: ffff880856772000 task.ti: ffff880856772000
    [ 2881.703515] RIP: 0010:[<ffffffffa02897e4>]  [<ffffffffa02897e4>] user_sdma_send_pkts+0xcd4/0x
    [ 2881.703529] RSP: 0018:ffff880856773c48  EFLAGS: 00010287
    [ 2881.703531] RAX: 0000000000000000 RBX: 0000000000001000 RCX: 0000000000002000
    [ 2881.703534] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000002000
    [ 2881.703537] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
    [ 2881.703540] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
    [ 2881.703543] R13: 0000000000000000 R14: ffff88071e782e68 R15: ffff8810532955c0
    [ 2881.703546] FS:  00007f9c4375e700(0000) GS:ffff88107eec0000(0000) knlGS:0000000000000000
    [ 2881.703549] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [ 2881.703551] CR2: 0000000000000000 CR3: 00000007d4cba000 CR4: 00000000003407e0
    [ 2881.703554] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    [ 2881.703556] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    [ 2881.703558] Stack:
    [ 2881.703559]  ffffffff00002000 ffff881000001800 ffffffff00000000 00000000000080d0
    [ 2881.703570]  0000000000000000 0000200000000000 0000000000000000 ffff88071e782db8
    [ 2881.703580]  ffff8807d4d08d80 ffff881053295600 0000000000000008 ffff88071e782fc8
    [ 2881.703589] Call Trace:
    [ 2881.703691]  [<ffffffffa028b5da>] hfi1_user_sdma_process_request+0x84a/0xab0 [hfi1]
    [ 2881.703777]  [<ffffffffa0255412>] hfi1_aio_write+0xd2/0x110 [hfi1]
    [ 2881.703828]  [<ffffffff8119e3d8>] do_sync_readv_writev+0x48/0x80
    [ 2881.703837]  [<ffffffff8119f78b>] do_readv_writev+0xbb/0x230
    [ 2881.703843]  [<ffffffff8119fab8>] SyS_writev+0x48/0xc0

This commit also addresses issues related to notification of user
processes of SDMA request slot availability. The slot should be
cleaned up first before the user processes is notified of its
availability.

Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c |  293 ++++++++++++++-------------------
 drivers/staging/rdma/hfi1/user_sdma.h |    3 
 2 files changed, 128 insertions(+), 168 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index d3de771..2d238f3 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -147,6 +147,8 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
 
 /* Last packet in the request */
 #define TXREQ_FLAGS_REQ_LAST_PKT BIT(0)
+
+/* Last packet that uses a particular io vector */
 #define TXREQ_FLAGS_IOVEC_LAST_PKT BIT(0)
 
 #define SDMA_REQ_IN_USE     0
@@ -171,6 +173,7 @@ static unsigned initial_pkt_count = 8;
 #define SDMA_IOWAIT_TIMEOUT 1000 /* in milliseconds */
 
 struct user_sdma_iovec {
+	struct list_head list;
 	struct iovec iov;
 	/* number of pages in this vector */
 	unsigned npages;
@@ -214,15 +217,6 @@ struct user_sdma_request {
 	 */
 	u8 omfactor;
 	/*
-	 * pointer to the user's mm_struct. We are going to
-	 * get a reference to it so it doesn't get freed
-	 * since we might not be in process context when we
-	 * are processing the iov's.
-	 * Using this mm_struct, we can get vma based on the
-	 * iov's address (find_vma()).
-	 */
-	struct mm_struct *user_mm;
-	/*
 	 * We copy the iovs for this request (based on
 	 * info.iovcnt). These are only the data vectors
 	 */
@@ -239,13 +233,13 @@ struct user_sdma_request {
 	u16 tididx;
 	u32 sent;
 	u64 seqnum;
+	u64 seqcomp;
 	struct list_head txps;
 	spinlock_t txcmp_lock;  /* protect txcmp list */
 	struct list_head txcmp;
 	unsigned long flags;
 	/* status of the last txreq completed */
 	int status;
-	struct work_struct worker;
 };
 
 /*
@@ -281,20 +275,20 @@ struct user_sdma_txreq {
 static int user_sdma_send_pkts(struct user_sdma_request *, unsigned);
 static int num_user_pages(const struct iovec *);
 static void user_sdma_txreq_cb(struct sdma_txreq *, int, int);
-static void user_sdma_delayed_completion(struct work_struct *);
-static void user_sdma_free_request(struct user_sdma_request *);
+static inline void pq_update(struct hfi1_user_sdma_pkt_q *);
+static void user_sdma_free_request(struct user_sdma_request *, bool);
 static int pin_vector_pages(struct user_sdma_request *,
 			    struct user_sdma_iovec *);
-static void unpin_vector_pages(struct user_sdma_request *,
-			       struct user_sdma_iovec *);
+static void unpin_vector_pages(struct user_sdma_iovec *);
 static int check_header_template(struct user_sdma_request *,
 				 struct hfi1_pkt_header *, u32, u32);
 static int set_txreq_header(struct user_sdma_request *,
 			    struct user_sdma_txreq *, u32);
 static int set_txreq_header_ahg(struct user_sdma_request *,
 				struct user_sdma_txreq *, u32);
-static inline void set_comp_state(struct user_sdma_request *,
-					enum hfi1_sdma_comp_state, int);
+static inline void set_comp_state(struct hfi1_user_sdma_pkt_q *,
+				  struct hfi1_user_sdma_comp_q *,
+				  u16, enum hfi1_sdma_comp_state, int);
 static inline u32 set_pkt_bth_psn(__be32, u8, u32);
 static inline u32 get_lrh_len(struct hfi1_pkt_header, u32 len);
 
@@ -381,17 +375,19 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 		goto pq_nomem;
 
 	memsize = sizeof(*pq->reqs) * hfi1_sdma_comp_ring_size;
-	pq->reqs = kmalloc(memsize, GFP_KERNEL);
+	pq->reqs = kzalloc(memsize, GFP_KERNEL);
 	if (!pq->reqs)
 		goto pq_reqs_nomem;
 
 	INIT_LIST_HEAD(&pq->list);
+	INIT_LIST_HEAD(&pq->iovec_list);
 	pq->dd = dd;
 	pq->ctxt = uctxt->ctxt;
 	pq->subctxt = fd->subctxt;
 	pq->n_max_reqs = hfi1_sdma_comp_ring_size;
 	pq->state = SDMA_PKT_Q_INACTIVE;
 	atomic_set(&pq->n_reqs, 0);
+	spin_lock_init(&pq->iovec_lock);
 	init_waitqueue_head(&pq->wait);
 
 	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
@@ -447,6 +443,7 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_user_sdma_pkt_q *pq;
+	struct user_sdma_iovec *iov;
 	unsigned long flags;
 
 	hfi1_cdbg(SDMA, "[%u:%u:%u] Freeing user SDMA queues", uctxt->dd->unit,
@@ -462,6 +459,15 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 		wait_event_interruptible(
 			pq->wait,
 			(ACCESS_ONCE(pq->state) == SDMA_PKT_Q_INACTIVE));
+		/* Unpin any left over buffers. */
+		while (!list_empty(&pq->iovec_list)) {
+			spin_lock_irqsave(&pq->iovec_lock, flags);
+			iov = list_first_entry(&pq->iovec_list,
+					       struct user_sdma_iovec, list);
+			list_del_init(&iov->list);
+			spin_unlock_irqrestore(&pq->iovec_lock, flags);
+			unpin_vector_pages(iov);
+		}
 		kfree(pq->reqs);
 		kmem_cache_destroy(pq->txreq_cache);
 		kfree(pq);
@@ -479,16 +485,17 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 				   unsigned long dim, unsigned long *count)
 {
-	int ret = 0, i = 0, sent;
+	int ret = 0, i = 0;
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
 	struct hfi1_user_sdma_comp_q *cq = fd->cq;
 	struct hfi1_devdata *dd = pq->dd;
-	unsigned long idx = 0;
+	unsigned long idx = 0, flags;
 	u8 pcount = initial_pkt_count;
 	struct sdma_req_info info;
 	struct user_sdma_request *req;
+	struct user_sdma_iovec *ioptr;
 	u8 opcode, sc, vl;
 
 	if (iovec[idx].iov_len < sizeof(info) + sizeof(req->hdr)) {
@@ -505,9 +512,21 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 			  dd->unit, uctxt->ctxt, fd->subctxt, ret);
 		return -EFAULT;
 	}
+
+	/* Process any completed vectors */
+	while (!list_empty(&pq->iovec_list)) {
+		spin_lock_irqsave(&pq->iovec_lock, flags);
+		ioptr = list_first_entry(&pq->iovec_list,
+					 struct user_sdma_iovec, list);
+		list_del_init(&ioptr->list);
+		spin_unlock_irqrestore(&pq->iovec_lock, flags);
+		unpin_vector_pages(ioptr);
+	}
+
 	trace_hfi1_sdma_user_reqinfo(dd, uctxt->ctxt, fd->subctxt,
 				     (u16 *)&info);
-	if (cq->comps[info.comp_idx].status == QUEUED) {
+	if (cq->comps[info.comp_idx].status == QUEUED ||
+	    test_bit(SDMA_REQ_IN_USE, &pq->reqs[info.comp_idx].flags)) {
 		hfi1_cdbg(SDMA, "[%u:%u:%u] Entry %u is in QUEUED state",
 			  dd->unit, uctxt->ctxt, fd->subctxt,
 			  info.comp_idx);
@@ -534,10 +553,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	req->cq = cq;
 	req->status = -1;
 	INIT_LIST_HEAD(&req->txps);
-	INIT_LIST_HEAD(&req->txcmp);
-	INIT_WORK(&req->worker, user_sdma_delayed_completion);
 
-	spin_lock_init(&req->txcmp_lock);
 	memcpy(&req->info, &info, sizeof(info));
 
 	if (req_opcode(info.ctrl) == EXPECTED)
@@ -606,6 +622,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 
 	/* Save all the IO vector structures */
 	while (i < req->data_iovs) {
+		INIT_LIST_HEAD(&req->iovs[i].list);
 		memcpy(&req->iovs[i].iov, iovec + idx++, sizeof(struct iovec));
 		req->iovs[i].offset = 0;
 		req->data_len += req->iovs[i++].iov.iov_len;
@@ -671,47 +688,52 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		}
 	}
 
-	set_comp_state(req, QUEUED, 0);
+	set_comp_state(pq, cq, info.comp_idx, QUEUED, 0);
+	atomic_inc(&pq->n_reqs);
 	/* Send the first N packets in the request to buy us some time */
-	sent = user_sdma_send_pkts(req, pcount);
-	if (unlikely(sent < 0)) {
-		if (sent != -EBUSY) {
-			req->status = sent;
-			set_comp_state(req, ERROR, req->status);
-			return sent;
-		} else
-			sent = 0;
+	ret = user_sdma_send_pkts(req, pcount);
+	if (unlikely(ret < 0 && ret != -EBUSY)) {
+		req->status = ret;
+		atomic_dec(&pq->n_reqs);
+		goto free_req;
 	}
-	atomic_inc(&pq->n_reqs);
-	xchg(&pq->state, SDMA_PKT_Q_ACTIVE);
 
-	if (sent < req->info.npkts) {
-		/*
-		 * This is a somewhat blocking send implementation.
-		 * The driver will block the caller until all packets of the
-		 * request have been submitted to the SDMA engine. However, it
-		 * will not wait for send completions.
-		 */
-		while (!test_bit(SDMA_REQ_SEND_DONE, &req->flags)) {
-			ret = user_sdma_send_pkts(req, pcount);
-			if (ret < 0) {
-				if (ret != -EBUSY) {
-					req->status = ret;
-					return ret;
-				}
-				wait_event_interruptible_timeout(
-					pq->busy.wait_dma,
-					(pq->state == SDMA_PKT_Q_ACTIVE),
-					msecs_to_jiffies(
-						SDMA_IOWAIT_TIMEOUT));
+	/*
+	 * It is possible that the SDMA engine would have processed all the
+	 * submitted packets by the time we get here. Therefore, only set
+	 * packet queue state to ACTIVE if there are still uncompleted
+	 * requests.
+	 */
+	if (atomic_read(&pq->n_reqs))
+		xchg(&pq->state, SDMA_PKT_Q_ACTIVE);
+
+	/*
+	 * This is a somewhat blocking send implementation.
+	 * The driver will block the caller until all packets of the
+	 * request have been submitted to the SDMA engine. However, it
+	 * will not wait for send completions.
+	 */
+	while (!test_bit(SDMA_REQ_SEND_DONE, &req->flags)) {
+		ret = user_sdma_send_pkts(req, pcount);
+		if (ret < 0) {
+			if (ret != -EBUSY) {
+				req->status = ret;
+				set_bit(SDMA_REQ_DONE_ERROR, &req->flags);
+				return ret;
 			}
+			wait_event_interruptible_timeout(
+				pq->busy.wait_dma,
+				(pq->state == SDMA_PKT_Q_ACTIVE),
+				msecs_to_jiffies(
+					SDMA_IOWAIT_TIMEOUT));
 		}
 
 	}
 	*count += idx;
 	return 0;
 free_req:
-	user_sdma_free_request(req);
+	user_sdma_free_request(req, true);
+	set_comp_state(pq, cq, info.comp_idx, ERROR, req->status);
 	return ret;
 }
 
@@ -937,16 +959,8 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 					      iovec->pages[pageidx],
 					      offset, len);
 			if (ret) {
-				int i;
-
 				SDMA_DBG(req, "SDMA txreq add page failed %d\n",
 					 ret);
-				/* Mark all assigned vectors as complete so they
-				 * are unpinned in the callback. */
-				for (i = tx->idx; i >= 0; i--) {
-					tx->iovecs[i].flags |=
-						TXREQ_FLAGS_IOVEC_LAST_PKT;
-				}
 				goto free_txreq;
 			}
 			iov_offset += len;
@@ -1043,12 +1057,6 @@ static int pin_vector_pages(struct user_sdma_request *req,
 		return -ENOMEM;
 	}
 
-	/*
-	 * Get a reference to the process's mm so we can use it when
-	 * unpinning the io vectors.
-	 */
-	req->pq->user_mm = get_task_mm(current);
-
 	pinned = hfi1_acquire_user_pages((unsigned long)iovec->iov.iov_base,
 					 npages, 0, iovec->pages);
 
@@ -1058,34 +1066,20 @@ static int pin_vector_pages(struct user_sdma_request *req,
 	iovec->npages = pinned;
 	if (pinned != npages) {
 		SDMA_DBG(req, "Failed to pin pages (%d/%u)", pinned, npages);
-		unpin_vector_pages(req, iovec);
+		unpin_vector_pages(iovec);
 		return -EFAULT;
 	}
+	/*
+	 * Get a reference to the process's mm so we can use it when
+	 * unpinning the io vectors.
+	 */
 	return 0;
 }
 
-static void unpin_vector_pages(struct user_sdma_request *req,
-			       struct user_sdma_iovec *iovec)
+static void unpin_vector_pages(struct user_sdma_iovec *iovec)
 {
-	/*
-	 * Unpinning is done through the workqueue so use the
-	 * process's mm if we have a reference to it.
-	 */
-	if ((current->flags & PF_KTHREAD) && req->pq->user_mm)
-		use_mm(req->pq->user_mm);
-
 	hfi1_release_user_pages(iovec->pages, iovec->npages, 0);
 
-	/*
-	 * Unuse the user's mm (see above) and release the
-	 * reference to it.
-	 */
-	if (req->pq->user_mm) {
-		if (current->flags & PF_KTHREAD)
-			unuse_mm(req->pq->user_mm);
-		mmput(req->pq->user_mm);
-	}
-
 	kfree(iovec->pages);
 	iovec->pages = NULL;
 	iovec->npages = 0;
@@ -1365,18 +1359,17 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status,
 	struct user_sdma_txreq *tx =
 		container_of(txreq, struct user_sdma_txreq, txreq);
 	struct user_sdma_request *req;
-	bool defer;
+	struct hfi1_user_sdma_pkt_q *pq;
+	struct hfi1_user_sdma_comp_q *cq;
+	u16 idx;
 	int i;
 
 	if (!tx->req)
 		return;
 
 	req = tx->req;
-	/*
-	 * If this is the callback for the last packet of the request,
-	 * queue up the request for clean up.
-	 */
-	defer = (tx->seqnum == req->info.npkts - 1);
+	pq = req->pq;
+	cq = req->cq;
 
 	/*
 	 * If we have any io vectors associated with this txreq,
@@ -1385,87 +1378,52 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status,
 	 */
 	for (i = tx->idx; i >= 0; i--) {
 		if (tx->iovecs[i].flags & TXREQ_FLAGS_IOVEC_LAST_PKT) {
-			defer = true;
-			break;
+			spin_lock(&pq->iovec_lock);
+			list_add_tail(&tx->iovecs[i].vec->list,
+				      &pq->iovec_list);
+			spin_unlock(&pq->iovec_lock);
 		}
 	}
 
-	req->status = status;
 	if (status != SDMA_TXREQ_S_OK) {
 		SDMA_DBG(req, "SDMA completion with error %d",
 			 status);
 		set_bit(SDMA_REQ_HAS_ERROR, &req->flags);
-		defer = true;
 	}
 
-	/*
-	 * Defer the clean up of the iovectors and the request until later
-	 * so it can be done outside of interrupt context.
-	 */
-	if (defer) {
-		spin_lock(&req->txcmp_lock);
-		list_add_tail(&tx->list, &req->txcmp);
-		spin_unlock(&req->txcmp_lock);
-		schedule_work(&req->worker);
+	req->seqcomp = tx->seqnum;
+	kmem_cache_free(pq->txreq_cache, tx);
+	tx = NULL;
+
+	idx = req->info.comp_idx;
+	if (req->status == -1 && status == SDMA_TXREQ_S_OK) {
+		if (req->seqcomp == req->info.npkts - 1) {
+			req->status = 0;
+			user_sdma_free_request(req, false);
+			pq_update(pq);
+			set_comp_state(pq, cq, idx, COMPLETE, 0);
+		}
 	} else {
-		kmem_cache_free(req->pq->txreq_cache, tx);
+		if (status != SDMA_TXREQ_S_OK)
+			req->status = status;
+		if (req->seqcomp == ACCESS_ONCE(req->seqnum) &&
+		    test_bit(SDMA_REQ_DONE_ERROR, &req->flags)) {
+			user_sdma_free_request(req, false);
+			pq_update(pq);
+			set_comp_state(pq, cq, idx, ERROR, req->status);
+		}
 	}
 }
 
-static void user_sdma_delayed_completion(struct work_struct *work)
+static inline void pq_update(struct hfi1_user_sdma_pkt_q *pq)
 {
-	struct user_sdma_request *req =
-		container_of(work, struct user_sdma_request, worker);
-	struct hfi1_user_sdma_pkt_q *pq = req->pq;
-	struct user_sdma_txreq *tx = NULL;
-	unsigned long flags;
-	u64 seqnum;
-	int i;
-
-	while (1) {
-		spin_lock_irqsave(&req->txcmp_lock, flags);
-		if (!list_empty(&req->txcmp)) {
-			tx = list_first_entry(&req->txcmp,
-					      struct user_sdma_txreq, list);
-			list_del(&tx->list);
-		}
-		spin_unlock_irqrestore(&req->txcmp_lock, flags);
-		if (!tx)
-			break;
-
-		for (i = tx->idx; i >= 0; i--)
-			if (tx->iovecs[i].flags & TXREQ_FLAGS_IOVEC_LAST_PKT)
-				unpin_vector_pages(req, tx->iovecs[i].vec);
-
-		seqnum = tx->seqnum;
-		kmem_cache_free(pq->txreq_cache, tx);
-		tx = NULL;
-
-		if (req->status != SDMA_TXREQ_S_OK) {
-			if (seqnum == ACCESS_ONCE(req->seqnum) &&
-			    test_bit(SDMA_REQ_DONE_ERROR, &req->flags)) {
-				atomic_dec(&pq->n_reqs);
-				set_comp_state(req, ERROR, req->status);
-				user_sdma_free_request(req);
-				break;
-			}
-		} else {
-			if (seqnum == req->info.npkts - 1) {
-				atomic_dec(&pq->n_reqs);
-				set_comp_state(req, COMPLETE, 0);
-				user_sdma_free_request(req);
-				break;
-			}
-		}
-	}
-
-	if (!atomic_read(&pq->n_reqs)) {
+	if (atomic_dec_and_test(&pq->n_reqs)) {
 		xchg(&pq->state, SDMA_PKT_Q_INACTIVE);
 		wake_up(&pq->wait);
 	}
 }
 
-static void user_sdma_free_request(struct user_sdma_request *req)
+static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 {
 	if (!list_empty(&req->txps)) {
 		struct sdma_txreq *t, *p;
@@ -1478,26 +1436,27 @@ static void user_sdma_free_request(struct user_sdma_request *req)
 			kmem_cache_free(req->pq->txreq_cache, tx);
 		}
 	}
-	if (req->data_iovs) {
+	if (req->data_iovs && unpin) {
 		int i;
 
 		for (i = 0; i < req->data_iovs; i++)
 			if (req->iovs[i].npages && req->iovs[i].pages)
-				unpin_vector_pages(req, &req->iovs[i]);
+				unpin_vector_pages(&req->iovs[i]);
 	}
 	kfree(req->tids);
 	clear_bit(SDMA_REQ_IN_USE, &req->flags);
 }
 
-static inline void set_comp_state(struct user_sdma_request *req,
-					enum hfi1_sdma_comp_state state,
-					int ret)
+static inline void set_comp_state(struct hfi1_user_sdma_pkt_q *pq,
+				  struct hfi1_user_sdma_comp_q *cq,
+				  u16 idx, enum hfi1_sdma_comp_state state,
+				  int ret)
 {
-	SDMA_DBG(req, "Setting completion status %u %d", state, ret);
-	req->cq->comps[req->info.comp_idx].status = state;
+	hfi1_cdbg(SDMA, "[%u:%u:%u:%u] Setting completion status %u %d",
+		  pq->dd->unit, pq->ctxt, pq->subctxt, idx, state, ret);
+	cq->comps[idx].status = state;
 	if (state == ERROR)
-		req->cq->comps[req->info.comp_idx].errcode = -ret;
-	trace_hfi1_sdma_user_completion(req->pq->dd, req->pq->ctxt,
-					req->pq->subctxt, req->info.comp_idx,
-					state, ret);
+		cq->comps[idx].errcode = -ret;
+	trace_hfi1_sdma_user_completion(pq->dd, pq->ctxt, pq->subctxt,
+					idx, state, ret);
 }
diff --git a/drivers/staging/rdma/hfi1/user_sdma.h b/drivers/staging/rdma/hfi1/user_sdma.h
index 0afa285..317f0e8 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.h
+++ b/drivers/staging/rdma/hfi1/user_sdma.h
@@ -69,7 +69,8 @@ struct hfi1_user_sdma_pkt_q {
 	struct iowait busy;
 	unsigned state;
 	wait_queue_head_t wait;
-	struct mm_struct *user_mm;
+	struct list_head iovec_list;
+	spinlock_t iovec_lock;   /* protect iovec_list */
 };
 
 struct hfi1_user_sdma_comp_q {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

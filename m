From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 04/13] IB/hfi1: Remove unused user context data
 members
Date: Mon, 24 Jul 2017 07:45:49 -0700
Message-ID: <20170724144548.10034.30185.stgit@scvm10.sc.intel.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Several data members of the user context have become unused over time.
Cleaning them up.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c  |    6 ------
 drivers/infiniband/hw/hfi1/hfi.h       |   24 ------------------------
 drivers/infiniband/hw/hfi1/user_sdma.c |   11 -----------
 drivers/infiniband/hw/hfi1/user_sdma.h |    1 -
 4 files changed, 0 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index d36e177..e10f526 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -809,10 +809,6 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	hfi1_free_ctxt_rcv_groups(uctxt);
 	hfi1_clear_ctxt_pkey(dd, uctxt);
 
-	uctxt->rcvwait_to = 0;
-	uctxt->piowait_to = 0;
-	uctxt->rcvnowait = 0;
-	uctxt->pionowait = 0;
 	uctxt->event_flags = 0;
 	mutex_unlock(&hfi1_mutex);
 
@@ -1067,8 +1063,6 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 	strlcpy(uctxt->comm, current->comm, sizeof(uctxt->comm));
 	memcpy(uctxt->uuid, uinfo->uuid, sizeof(uctxt->uuid));
 	uctxt->jkey = generate_jkey(current_uid());
-	INIT_LIST_HEAD(&uctxt->sdma_queues);
-	spin_lock_init(&uctxt->sdma_qlock);
 	hfi1_stats.sps_ctxts++;
 	/*
 	 * Disable ASPM when there are open user/PSM contexts to avoid
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 2e5137b..7877ebc 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -243,24 +243,10 @@ struct hfi1_ctxtdata {
 
 	/* lock protecting all Expected TID data */
 	struct mutex exp_lock;
-	/* number of pio bufs for this ctxt (all procs, if shared) */
-	u32 piocnt;
-	/* first pio buffer for this ctxt */
-	u32 pio_base;
-	/* chip offset of PIO buffers for this ctxt */
-	u32 piobufs;
 	/* per-context configuration flags */
 	unsigned long flags;
 	/* per-context event flags for fileops/intr communication */
 	unsigned long event_flags;
-	/* WAIT_RCV that timed out, no interrupt */
-	u32 rcvwait_to;
-	/* WAIT_PIO that timed out, no interrupt */
-	u32 piowait_to;
-	/* WAIT_RCV already happened, no wait */
-	u32 rcvnowait;
-	/* WAIT_PIO already happened, no wait */
-	u32 pionowait;
 	/* total number of polled urgent packets */
 	u32 urgent;
 	/* saved total number of polled urgent packets for poll edge trigger */
@@ -290,7 +276,6 @@ struct hfi1_ctxtdata {
 	u8 redirect_seq_cnt;
 	/* ctxt rcvhdrq head offset */
 	u32 head;
-	u32 pkt_count;
 	/* QPs waiting for context processing */
 	struct list_head qp_wait_list;
 	/* interrupt handling */
@@ -299,15 +284,6 @@ struct hfi1_ctxtdata {
 	unsigned numa_id; /* numa node of this context */
 	/* verbs stats per CTX */
 	struct hfi1_opcode_stats_perctx *opstats;
-	/*
-	 * This is the kernel thread that will keep making
-	 * progress on the user sdma requests behind the scenes.
-	 * There is one per context (shared contexts use the master's).
-	 */
-	struct task_struct *progress;
-	struct list_head sdma_queues;
-	/* protect sdma queues */
-	spinlock_t sdma_qlock;
 
 	/* Is ASPM interrupt supported for this context */
 	bool aspm_intr_supported;
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index ea2993f..64d31eb 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -346,7 +346,6 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 	struct hfi1_devdata *dd;
 	struct hfi1_user_sdma_comp_q *cq;
 	struct hfi1_user_sdma_pkt_q *pq;
-	unsigned long flags;
 
 	if (!uctxt || !fd)
 		return -EBADF;
@@ -360,7 +359,6 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 	if (!pq)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&pq->list);
 	pq->dd = dd;
 	pq->ctxt = uctxt->ctxt;
 	pq->subctxt = fd->subctxt;
@@ -421,10 +419,6 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 	fd->pq = pq;
 	fd->cq = cq;
 
-	spin_lock_irqsave(&uctxt->sdma_qlock, flags);
-	list_add(&pq->list, &uctxt->sdma_queues);
-	spin_unlock_irqrestore(&uctxt->sdma_qlock, flags);
-
 	return 0;
 
 pq_mmu_fail:
@@ -447,7 +441,6 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_user_sdma_pkt_q *pq;
-	unsigned long flags;
 
 	hfi1_cdbg(SDMA, "[%u:%u:%u] Freeing user SDMA queues", uctxt->dd->unit,
 		  uctxt->ctxt, fd->subctxt);
@@ -455,10 +448,6 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 	if (pq) {
 		if (pq->handler)
 			hfi1_mmu_rb_unregister(pq->handler);
-		spin_lock_irqsave(&uctxt->sdma_qlock, flags);
-		if (!list_empty(&pq->list))
-			list_del_init(&pq->list);
-		spin_unlock_irqrestore(&uctxt->sdma_qlock, flags);
 		iowait_sdma_drain(&pq->busy);
 		/* Wait until all requests have been freed. */
 		wait_event_interruptible(
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index e5b10ae..161fdfd 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -56,7 +56,6 @@
 extern uint extended_psn;
 
 struct hfi1_user_sdma_pkt_q {
-	struct list_head list;
 	unsigned ctxt;
 	u16 subctxt;
 	u16 n_max_reqs;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

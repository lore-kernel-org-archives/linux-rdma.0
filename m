From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 46/54] staging/rdma/hfi1: Improve performance of user SDMA
Date: Wed, 03 Feb 2016 14:37:06 -0800
Message-ID: <20160203223703.5923.8090.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

To facilitate locked page counting, the user SDMA
routines would maintain a list of io vectors, which
were freed in the completion callback and then unpin
the associated pages during the next call into the
kernel.

Since the size of this list was unbounded, doing this
was bad for performance because the driver ended up
spending too much time freeing the io vectors.

This commit changes how the io vector freeing is done
by moving the actual page unpinning in the callback and
maintaining a count of unpinned pages. This count can
then be used during the next call into the kernel to
update the mm->pinned_vm variable (since that requires
process context and the ability to sleep.)

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c |   55 +++++++++++----------------------
 drivers/staging/rdma/hfi1/user_sdma.h |    7 ++--
 2 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 0c32eaf..55c7e6a 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -236,8 +236,6 @@ struct user_sdma_request {
 	u64 seqcomp;
 	u64 seqsubmitted;
 	struct list_head txps;
-	spinlock_t txcmp_lock;  /* protect txcmp list */
-	struct list_head txcmp;
 	unsigned long flags;
 	/* status of the last txreq completed */
 	int status;
@@ -381,14 +379,12 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 		goto pq_reqs_nomem;
 
 	INIT_LIST_HEAD(&pq->list);
-	INIT_LIST_HEAD(&pq->iovec_list);
 	pq->dd = dd;
 	pq->ctxt = uctxt->ctxt;
 	pq->subctxt = fd->subctxt;
 	pq->n_max_reqs = hfi1_sdma_comp_ring_size;
 	pq->state = SDMA_PKT_Q_INACTIVE;
 	atomic_set(&pq->n_reqs, 0);
-	spin_lock_init(&pq->iovec_lock);
 	init_waitqueue_head(&pq->wait);
 
 	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
@@ -444,7 +440,6 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_user_sdma_pkt_q *pq;
-	struct user_sdma_iovec *iov;
 	unsigned long flags;
 
 	hfi1_cdbg(SDMA, "[%u:%u:%u] Freeing user SDMA queues", uctxt->dd->unit,
@@ -460,15 +455,6 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 		wait_event_interruptible(
 			pq->wait,
 			(ACCESS_ONCE(pq->state) == SDMA_PKT_Q_INACTIVE));
-		/* Unpin any left over buffers. */
-		while (!list_empty(&pq->iovec_list)) {
-			spin_lock_irqsave(&pq->iovec_lock, flags);
-			iov = list_first_entry(&pq->iovec_list,
-					       struct user_sdma_iovec, list);
-			list_del_init(&iov->list);
-			spin_unlock_irqrestore(&pq->iovec_lock, flags);
-			unpin_vector_pages(iov);
-		}
 		kfree(pq->reqs);
 		kmem_cache_destroy(pq->txreq_cache);
 		kfree(pq);
@@ -492,11 +478,10 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
 	struct hfi1_user_sdma_comp_q *cq = fd->cq;
 	struct hfi1_devdata *dd = pq->dd;
-	unsigned long idx = 0, flags;
+	unsigned long idx = 0, unpinned;
 	u8 pcount = initial_pkt_count;
 	struct sdma_req_info info;
 	struct user_sdma_request *req;
-	struct user_sdma_iovec *ioptr;
 	u8 opcode, sc, vl;
 
 	if (iovec[idx].iov_len < sizeof(info) + sizeof(req->hdr)) {
@@ -515,13 +500,11 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	}
 
 	/* Process any completed vectors */
-	while (!list_empty(&pq->iovec_list)) {
-		spin_lock_irqsave(&pq->iovec_lock, flags);
-		ioptr = list_first_entry(&pq->iovec_list,
-					 struct user_sdma_iovec, list);
-		list_del_init(&ioptr->list);
-		spin_unlock_irqrestore(&pq->iovec_lock, flags);
-		unpin_vector_pages(ioptr);
+	unpinned = xchg(&pq->unpinned, 0);
+	if (unpinned) {
+		down_write(&current->mm->mmap_sem);
+		current->mm->pinned_vm -= unpinned;
+		up_write(&current->mm->mmap_sem);
 	}
 
 	trace_hfi1_sdma_user_reqinfo(dd, uctxt->ctxt, fd->subctxt,
@@ -1075,10 +1058,6 @@ static int pin_vector_pages(struct user_sdma_request *req,
 		unpin_vector_pages(iovec);
 		return -EFAULT;
 	}
-	/*
-	 * Get a reference to the process's mm so we can use it when
-	 * unpinning the io vectors.
-	 */
 	return 0;
 }
 
@@ -1368,7 +1347,7 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status,
 	struct hfi1_user_sdma_pkt_q *pq;
 	struct hfi1_user_sdma_comp_q *cq;
 	u16 idx;
-	int i;
+	int i, j;
 
 	if (!tx->req)
 		return;
@@ -1379,15 +1358,19 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status,
 
 	/*
 	 * If we have any io vectors associated with this txreq,
-	 * check whether they need to be 'freed'. We can't free them
-	 * here because the unpin function needs to be able to sleep.
+	 * check whether they need to be 'freed'.
 	 */
 	for (i = tx->idx; i >= 0; i--) {
 		if (tx->iovecs[i].flags & TXREQ_FLAGS_IOVEC_LAST_PKT) {
-			spin_lock(&pq->iovec_lock);
-			list_add_tail(&tx->iovecs[i].vec->list,
-				      &pq->iovec_list);
-			spin_unlock(&pq->iovec_lock);
+			struct user_sdma_iovec *vec =
+				tx->iovecs[i].vec;
+
+			for (j = 0; j < vec->npages; j++)
+				put_page(vec->pages[j]);
+			xadd(&pq->unpinned, vec->npages);
+			kfree(vec->pages);
+			vec->pages = NULL;
+			vec->npages = 0;
 		}
 	}
 
diff --git a/drivers/staging/rdma/hfi1/user_sdma.h b/drivers/staging/rdma/hfi1/user_sdma.h
index 317f0e8..7ef31a6 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.h
+++ b/drivers/staging/rdma/hfi1/user_sdma.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -69,8 +69,7 @@ struct hfi1_user_sdma_pkt_q {
 	struct iowait busy;
 	unsigned state;
 	wait_queue_head_t wait;
-	struct list_head iovec_list;
-	spinlock_t iovec_lock;   /* protect iovec_list */
+	unsigned long unpinned;
 };
 
 struct hfi1_user_sdma_comp_q {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

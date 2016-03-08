From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/16] IB/hfi1: Implement SDMA-side buffer caching
Date: Tue, 08 Mar 2016 11:15:22 -0800
Message-ID: <20160308191521.30542.18932.stgit@scvm10.sc.intel.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160308191210.30542.91885.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add support for caching of user buffers used for SDMA
transfers. This change improves performance by
avoiding repeatedly pinning the pages of buffers, which
are being re-used by the application.

While the cost of the pinning operation has been made
heavier by adding the extra code to search the cache tree,
re-allocate pages arrays, and future cache evictions,
that cost will be amortized against the savings when the
same buffer is re-used. It is also worth noting that in
most cases, the cost of pinning should be much lower due
to the buffer already being in the cache.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |  255 +++++++++++++++++++-------------
 drivers/infiniband/hw/hfi1/user_sdma.h |    1 
 2 files changed, 155 insertions(+), 101 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 14fe079..a53edb9 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -68,6 +68,7 @@
 #include "verbs.h"  /* for the headers */
 #include "common.h" /* for struct hfi1_tid_info */
 #include "trace.h"
+#include "mmu_rb.h"
 
 static uint hfi1_sdma_comp_ring_size = 128;
 module_param_named(sdma_comp_size, hfi1_sdma_comp_ring_size, uint, S_IRUGO);
@@ -145,9 +146,6 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
 /* Last packet in the request */
 #define TXREQ_FLAGS_REQ_LAST_PKT BIT(0)
 
-/* Last packet that uses a particular io vector */
-#define TXREQ_FLAGS_IOVEC_LAST_PKT BIT(0)
-
 #define SDMA_REQ_IN_USE     0
 #define SDMA_REQ_FOR_THREAD 1
 #define SDMA_REQ_SEND_DONE  2
@@ -183,6 +181,13 @@ struct user_sdma_iovec {
 	u64 offset;
 };
 
+struct sdma_mmu_node {
+	struct mmu_rb_node rb;
+	atomic_t refcount;
+	struct page **pages;
+	unsigned npages;
+};
+
 struct user_sdma_request {
 	struct sdma_req_info info;
 	struct hfi1_user_sdma_pkt_q *pq;
@@ -252,11 +257,6 @@ struct user_sdma_txreq {
 	struct sdma_txreq txreq;
 	struct list_head list;
 	struct user_sdma_request *req;
-	struct {
-		struct user_sdma_iovec *vec;
-		u8 flags;
-	} iovecs[3];
-	int idx;
 	u16 flags;
 	unsigned busycount;
 	u64 seqnum;
@@ -277,7 +277,7 @@ static inline void pq_update(struct hfi1_user_sdma_pkt_q *);
 static void user_sdma_free_request(struct user_sdma_request *, bool);
 static int pin_vector_pages(struct user_sdma_request *,
 			    struct user_sdma_iovec *);
-static void unpin_vector_pages(struct user_sdma_iovec *);
+static void unpin_vector_pages(struct page **, unsigned);
 static int check_header_template(struct user_sdma_request *,
 				 struct hfi1_pkt_header *, u32, u32);
 static int set_txreq_header(struct user_sdma_request *,
@@ -296,6 +296,17 @@ static int defer_packet_queue(
 	struct sdma_txreq *,
 	unsigned seq);
 static void activate_packet_queue(struct iowait *, int);
+static bool sdma_rb_filter(struct mmu_rb_node *, unsigned long, unsigned long);
+static int sdma_rb_insert(struct rb_root *, struct mmu_rb_node *);
+static void sdma_rb_remove(struct rb_root *, struct mmu_rb_node *, bool);
+static int sdma_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
+
+static struct mmu_rb_ops sdma_rb_ops = {
+	.filter = sdma_rb_filter,
+	.insert = sdma_rb_insert,
+	.remove = sdma_rb_remove,
+	.invalidate = sdma_rb_invalidate
+};
 
 static int defer_packet_queue(
 	struct sdma_engine *sde,
@@ -385,6 +396,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	pq->state = SDMA_PKT_Q_INACTIVE;
 	atomic_set(&pq->n_reqs, 0);
 	init_waitqueue_head(&pq->wait);
+	pq->sdma_rb_root = RB_ROOT;
 
 	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
 		    activate_packet_queue, NULL);
@@ -415,6 +427,12 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	cq->nentries = hfi1_sdma_comp_ring_size;
 	fd->cq = cq;
 
+	ret = hfi1_mmu_rb_register(&pq->sdma_rb_root, &sdma_rb_ops);
+	if (ret) {
+		dd_dev_err(dd, "Failed to register with MMU %d", ret);
+		goto done;
+	}
+
 	spin_lock_irqsave(&uctxt->sdma_qlock, flags);
 	list_add(&pq->list, &uctxt->sdma_queues);
 	spin_unlock_irqrestore(&uctxt->sdma_qlock, flags);
@@ -444,6 +462,7 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 	hfi1_cdbg(SDMA, "[%u:%u:%u] Freeing user SDMA queues", uctxt->dd->unit,
 		  uctxt->ctxt, fd->subctxt);
 	pq = fd->pq;
+	hfi1_mmu_rb_unregister(&pq->sdma_rb_root);
 	if (pq) {
 		spin_lock_irqsave(&uctxt->sdma_qlock, flags);
 		if (!list_empty(&pq->list))
@@ -477,7 +496,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
 	struct hfi1_user_sdma_comp_q *cq = fd->cq;
 	struct hfi1_devdata *dd = pq->dd;
-	unsigned long idx = 0, unpinned;
+	unsigned long idx = 0;
 	u8 pcount = initial_pkt_count;
 	struct sdma_req_info info;
 	struct user_sdma_request *req;
@@ -498,14 +517,6 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		return -EFAULT;
 	}
 
-	/* Process any completed vectors */
-	unpinned = xchg(&pq->unpinned, 0);
-	if (unpinned) {
-		down_write(&current->mm->mmap_sem);
-		current->mm->pinned_vm -= unpinned;
-		up_write(&current->mm->mmap_sem);
-	}
-
 	trace_hfi1_sdma_user_reqinfo(dd, uctxt->ctxt, fd->subctxt,
 				     (u16 *)&info);
 	if (cq->comps[info.comp_idx].status == QUEUED ||
@@ -609,7 +620,11 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	while (i < req->data_iovs) {
 		INIT_LIST_HEAD(&req->iovs[i].list);
 		memcpy(&req->iovs[i].iov, iovec + idx++, sizeof(struct iovec));
-		req->iovs[i].offset = 0;
+		ret = pin_vector_pages(req, &req->iovs[i]);
+		if (ret) {
+			req->status = ret;
+			goto free_req;
+		}
 		req->data_len += req->iovs[i++].iov.iov_len;
 	}
 	SDMA_DBG(req, "total data length %u", req->data_len);
@@ -827,9 +842,7 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		tx->flags = 0;
 		tx->req = req;
 		tx->busycount = 0;
-		tx->idx = -1;
 		INIT_LIST_HEAD(&tx->list);
-		memset(tx->iovecs, 0, sizeof(tx->iovecs));
 
 		if (req->seqnum == req->info.npkts - 1)
 			tx->flags |= TXREQ_FLAGS_REQ_LAST_PKT;
@@ -850,18 +863,6 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 				WARN_ON(iovec->offset);
 			}
 
-			/*
-			 * This request might include only a header and no user
-			 * data, so pin pages only if there is data and it the
-			 * pages have not been pinned already.
-			 */
-			if (unlikely(!iovec->pages && iovec->iov.iov_len)) {
-				ret = pin_vector_pages(req, iovec);
-				if (ret)
-					goto free_tx;
-			}
-
-			tx->iovecs[++tx->idx].vec = iovec;
 			datalen = compute_data_length(req, tx);
 			if (!datalen) {
 				SDMA_DBG(req,
@@ -960,19 +961,10 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 			data_sent += len;
 			if (unlikely(queued < datalen &&
 				     pageidx == iovec->npages &&
-				     req->iov_idx < req->data_iovs - 1 &&
-				     tx->idx < ARRAY_SIZE(tx->iovecs))) {
+				     req->iov_idx < req->data_iovs - 1)) {
 				iovec->offset += iov_offset;
-				tx->iovecs[tx->idx].flags |=
-					TXREQ_FLAGS_IOVEC_LAST_PKT;
 				iovec = &req->iovs[++req->iov_idx];
-				if (!iovec->pages) {
-					ret = pin_vector_pages(req, iovec);
-					if (ret)
-						goto free_txreq;
-				}
 				iov_offset = 0;
-				tx->iovecs[++tx->idx].vec = iovec;
 			}
 		}
 		/*
@@ -983,18 +975,8 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		if (req_opcode(req->info.ctrl) == EXPECTED)
 			req->tidoffset += datalen;
 		req->sent += data_sent;
-		if (req->data_len) {
-			tx->iovecs[tx->idx].vec->offset += iov_offset;
-			/*
-			 * If we've reached the end of the io vector, mark it
-			 * so the callback can unpin the pages and free it.
-			 */
-			if (tx->iovecs[tx->idx].vec->offset ==
-			    tx->iovecs[tx->idx].vec->iov.iov_len)
-				tx->iovecs[tx->idx].flags |=
-					TXREQ_FLAGS_IOVEC_LAST_PKT;
-		}
-
+		if (req->data_len)
+			iovec->offset += iov_offset;
 		list_add_tail(&tx->txreq.list, &req->txps);
 		/*
 		 * It is important to increment this here as it is used to
@@ -1047,38 +1029,78 @@ static inline int num_user_pages(const struct iovec *iov)
 
 static int pin_vector_pages(struct user_sdma_request *req,
 			    struct user_sdma_iovec *iovec) {
-	int pinned, npages;
+	int ret = 0, pinned, npages;
+	struct page **pages;
+	struct hfi1_user_sdma_pkt_q *pq = req->pq;
+	struct sdma_mmu_node *node = NULL;
+	struct mmu_rb_node *rb_node;
+
+	rb_node = hfi1_mmu_rb_search(&pq->sdma_rb_root,
+				     (unsigned long)iovec->iov.iov_base,
+				     iovec->iov.iov_len);
+	if (rb_node)
+		node = container_of(rb_node, struct sdma_mmu_node, rb);
+
+	if (!node) {
+		node = kzalloc(sizeof(*node), GFP_KERNEL);
+		if (!node)
+			return -ENOMEM;
 
-	npages = num_user_pages(&iovec->iov);
-	iovec->pages = kcalloc(npages, sizeof(*iovec->pages), GFP_KERNEL);
-	if (!iovec->pages) {
-		SDMA_DBG(req, "Failed page array alloc");
-		return -ENOMEM;
+		node->rb.addr = (unsigned long)iovec->iov.iov_base;
+		node->rb.len = iovec->iov.iov_len;
+		atomic_set(&node->refcount, 0);
 	}
 
-	pinned = hfi1_acquire_user_pages((unsigned long)iovec->iov.iov_base,
-					 npages, 0, iovec->pages);
-
-	if (pinned < 0)
-		return pinned;
+	npages = num_user_pages(&iovec->iov);
+	if (node->npages < npages) {
+		pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
+		if (!pages) {
+			SDMA_DBG(req, "Failed page array alloc");
+			ret = -ENOMEM;
+			goto bail;
+		}
+		memcpy(pages, node->pages, node->npages * sizeof(*pages));
+
+		npages -= node->npages;
+		pinned = hfi1_acquire_user_pages(
+			((unsigned long)iovec->iov.iov_base +
+			 (node->npages * PAGE_SIZE)), npages, 0,
+			pages + node->npages);
+		if (pinned < 0) {
+			kfree(pages);
+			ret = pinned;
+			goto bail;
+		}
+		if (pinned != npages) {
+			unpin_vector_pages(pages, pinned);
+			ret = -EFAULT;
+			goto bail;
+		}
+		kfree(node->pages);
+		node->pages = pages;
+		node->npages += pinned;
+		npages = node->npages;
+	}
+	iovec->pages = node->pages;
+	iovec->npages = npages;
 
-	iovec->npages = pinned;
-	if (pinned != npages) {
-		SDMA_DBG(req, "Failed to pin pages (%d/%u)", pinned, npages);
-		unpin_vector_pages(iovec);
-		return -EFAULT;
+	if (!rb_node) {
+		if (hfi1_mmu_rb_insert(&req->pq->sdma_rb_root, &node->rb))
+			goto bail;
+	} else {
+		atomic_inc(&node->refcount);
 	}
 	return 0;
+bail:
+	if (!rb_node)
+		kfree(node);
+	return ret;
 }
 
-static void unpin_vector_pages(struct user_sdma_iovec *iovec)
+static void unpin_vector_pages(struct page **pages, unsigned npages)
 {
-	hfi1_release_user_pages(iovec->pages, iovec->npages, 0);
-
-	kfree(iovec->pages);
-	iovec->pages = NULL;
-	iovec->npages = 0;
-	iovec->offset = 0;
+	hfi1_release_user_pages(pages, npages, 0);
+	kfree(pages);
 }
 
 static int check_header_template(struct user_sdma_request *req,
@@ -1360,7 +1382,6 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status)
 	struct hfi1_user_sdma_pkt_q *pq;
 	struct hfi1_user_sdma_comp_q *cq;
 	u16 idx;
-	int i, j;
 
 	if (!tx->req)
 		return;
@@ -1369,24 +1390,6 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status)
 	pq = req->pq;
 	cq = req->cq;
 
-	/*
-	 * If we have any io vectors associated with this txreq,
-	 * check whether they need to be 'freed'.
-	 */
-	for (i = tx->idx; i >= 0; i--) {
-		if (tx->iovecs[i].flags & TXREQ_FLAGS_IOVEC_LAST_PKT) {
-			struct user_sdma_iovec *vec =
-				tx->iovecs[i].vec;
-
-			for (j = 0; j < vec->npages; j++)
-				put_page(vec->pages[j]);
-			xadd(&pq->unpinned, vec->npages);
-			kfree(vec->pages);
-			vec->pages = NULL;
-			vec->npages = 0;
-		}
-	}
-
 	if (status != SDMA_TXREQ_S_OK) {
 		SDMA_DBG(req, "SDMA completion with error %d",
 			 status);
@@ -1439,12 +1442,26 @@ static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 			kmem_cache_free(req->pq->txreq_cache, tx);
 		}
 	}
-	if (req->data_iovs && unpin) {
+	if (req->data_iovs) {
+		struct sdma_mmu_node *node;
+		struct mmu_rb_node *mnode;
 		int i;
 
-		for (i = 0; i < req->data_iovs; i++)
-			if (req->iovs[i].npages && req->iovs[i].pages)
-				unpin_vector_pages(&req->iovs[i]);
+		for (i = 0; i < req->data_iovs; i++) {
+			mnode = hfi1_mmu_rb_search(
+				&req->pq->sdma_rb_root,
+				(unsigned long)req->iovs[i].iov.iov_base,
+				req->iovs[i].iov.iov_len);
+			if (!mnode)
+				continue;
+
+			node = container_of(mnode, struct sdma_mmu_node, rb);
+			if (unpin)
+				hfi1_mmu_rb_remove(&req->pq->sdma_rb_root,
+						   &node->rb);
+			else
+				atomic_dec(&node->refcount);
+		}
 	}
 	kfree(req->tids);
 	clear_bit(SDMA_REQ_IN_USE, &req->flags);
@@ -1463,3 +1480,39 @@ static inline void set_comp_state(struct hfi1_user_sdma_pkt_q *pq,
 	trace_hfi1_sdma_user_completion(pq->dd, pq->ctxt, pq->subctxt,
 					idx, state, ret);
 }
+
+static bool sdma_rb_filter(struct mmu_rb_node *node, unsigned long addr,
+			   unsigned long len)
+{
+	return (bool)(node->addr == addr);
+}
+
+static int sdma_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
+{
+	struct sdma_mmu_node *node =
+		container_of(mnode, struct sdma_mmu_node, rb);
+
+	atomic_inc(&node->refcount);
+	return 0;
+}
+
+static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
+			   bool notifier)
+{
+	struct sdma_mmu_node *node =
+		container_of(mnode, struct sdma_mmu_node, rb);
+
+	if (!notifier)
+		unpin_vector_pages(node->pages, node->npages);
+	kfree(node);
+}
+
+static int sdma_rb_invalidate(struct rb_root *root, struct mmu_rb_node *mnode)
+{
+	struct sdma_mmu_node *node =
+		container_of(mnode, struct sdma_mmu_node, rb);
+
+	if (!atomic_read(&node->refcount))
+		return 1;
+	return 0;
+}
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index e0d0fe0..39866b5 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -67,6 +67,7 @@ struct hfi1_user_sdma_pkt_q {
 	unsigned state;
 	wait_queue_head_t wait;
 	unsigned long unpinned;
+	struct rb_root sdma_rb_root;
 };
 
 struct hfi1_user_sdma_comp_q {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

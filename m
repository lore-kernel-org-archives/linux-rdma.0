From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/16] IB/hfi1: Add SDMA cache eviction algorithm
Date: Tue, 08 Mar 2016 11:15:44 -0800
Message-ID: <20160308191544.30542.11590.stgit@scvm10.sc.intel.com>
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

This commit adds a cache eviction algorithm for the SDMA
user buffer cache.

Besides the interval RB tree used for node lookup, the cache
nodes are also arranged in a doubly-linked list. When a node is
used, it is put at the beginning of the list. Less frequently
used nodes naturally move to the tail of the list.

When the cache limit is reached, the eviction code starts
traversing the linked list in reverse, freeing buffers until
enough space has been freed to fit the new user buffer. This
guarantees that only the least used cache nodes will be removed
from the cache.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   61 +++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/hfi1/user_sdma.h |    3 ++
 2 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index bf55a41..46e254d 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -183,6 +183,8 @@ struct user_sdma_iovec {
 
 struct sdma_mmu_node {
 	struct mmu_rb_node rb;
+	struct list_head list;
+	struct hfi1_user_sdma_pkt_q *pq;
 	atomic_t refcount;
 	struct page **pages;
 	unsigned npages;
@@ -397,6 +399,8 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	atomic_set(&pq->n_reqs, 0);
 	init_waitqueue_head(&pq->wait);
 	pq->sdma_rb_root = RB_ROOT;
+	INIT_LIST_HEAD(&pq->evict);
+	spin_lock_init(&pq->evict_lock);
 
 	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
 		    activate_packet_queue, NULL);
@@ -1027,9 +1031,33 @@ static inline int num_user_pages(const struct iovec *iov)
 	return 1 + ((epage - spage) >> PAGE_SHIFT);
 }
 
+/* Caller must hold pq->evict_lock */
+static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
+{
+	u32 cleared = 0;
+	struct sdma_mmu_node *node, *ptr;
+
+	list_for_each_entry_safe_reverse(node, ptr, &pq->evict, list) {
+		/* Make sure that no one is still using the node. */
+		if (!atomic_read(&node->refcount)) {
+			/*
+			 * Need to use the page count now as the remove callback
+			 * will free the node.
+			 */
+			cleared += node->npages;
+			spin_unlock(&pq->evict_lock);
+			hfi1_mmu_rb_remove(&pq->sdma_rb_root, &node->rb);
+			spin_lock(&pq->evict_lock);
+			if (cleared >= npages)
+				break;
+		}
+	}
+	return cleared;
+}
+
 static int pin_vector_pages(struct user_sdma_request *req,
 			    struct user_sdma_iovec *iovec) {
-	int ret = 0, pinned, npages;
+	int ret = 0, pinned, npages, cleared;
 	struct page **pages;
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
 	struct sdma_mmu_node *node = NULL;
@@ -1048,7 +1076,9 @@ static int pin_vector_pages(struct user_sdma_request *req,
 
 		node->rb.addr = (unsigned long)iovec->iov.iov_base;
 		node->rb.len = iovec->iov.iov_len;
+		node->pq = pq;
 		atomic_set(&node->refcount, 0);
+		INIT_LIST_HEAD(&node->list);
 	}
 
 	npages = num_user_pages(&iovec->iov);
@@ -1062,6 +1092,14 @@ static int pin_vector_pages(struct user_sdma_request *req,
 		memcpy(pages, node->pages, node->npages * sizeof(*pages));
 
 		npages -= node->npages;
+retry:
+		if (!hfi1_can_pin_pages(pq->dd, pq->n_locked, npages)) {
+			spin_lock(&pq->evict_lock);
+			cleared = sdma_cache_evict(pq, npages);
+			spin_unlock(&pq->evict_lock);
+			if (cleared >= npages)
+				goto retry;
+		}
 		pinned = hfi1_acquire_user_pages(
 			((unsigned long)iovec->iov.iov_base +
 			 (node->npages * PAGE_SIZE)), npages, 0,
@@ -1080,13 +1118,27 @@ static int pin_vector_pages(struct user_sdma_request *req,
 		node->pages = pages;
 		node->npages += pinned;
 		npages = node->npages;
+		spin_lock(&pq->evict_lock);
+		if (!rb_node)
+			list_add(&node->list, &pq->evict);
+		else
+			list_move(&node->list, &pq->evict);
+		pq->n_locked += pinned;
+		spin_unlock(&pq->evict_lock);
 	}
 	iovec->pages = node->pages;
 	iovec->npages = npages;
 
 	if (!rb_node) {
-		if (hfi1_mmu_rb_insert(&req->pq->sdma_rb_root, &node->rb))
+		ret = hfi1_mmu_rb_insert(&req->pq->sdma_rb_root, &node->rb);
+		if (ret) {
+			spin_lock(&pq->evict_lock);
+			list_del(&node->list);
+			pq->n_locked -= node->npages;
+			spin_unlock(&pq->evict_lock);
+			ret = 0;
 			goto bail;
+		}
 	} else {
 		atomic_inc(&node->refcount);
 	}
@@ -1503,6 +1555,11 @@ static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
 
+	spin_lock(&node->pq->evict_lock);
+	list_del(&node->list);
+	node->pq->n_locked -= node->npages;
+	spin_unlock(&node->pq->evict_lock);
+
 	unpin_vector_pages(notifier ? NULL : current->mm, node->pages,
 			   node->npages);
 	/*
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 39866b5..b9240e3 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -68,6 +68,9 @@ struct hfi1_user_sdma_pkt_q {
 	wait_queue_head_t wait;
 	unsigned long unpinned;
 	struct rb_root sdma_rb_root;
+	u32 n_locked;
+	struct list_head evict;
+	spinlock_t evict_lock; /* protect evict and n_locked */
 };
 
 struct hfi1_user_sdma_comp_q {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

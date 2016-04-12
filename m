From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/12] IB/hfi1: Fix buffer cache races which may cause
 corruption
Date: Tue, 12 Apr 2016 10:46:53 -0700
Message-ID: <20160412174652.19295.28697.stgit@scvm10.sc.intel.com>
References: <20160412173504.19295.7241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412173504.19295.7241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There are two possible causes for node/memory corruption both
of which are related to the cache eviction algorithm. One way
to cause corruption is due to the asynchronous nature of the
MMU invalidation and the locking used when invalidating node.

The MMU invalidation routine would temporarily release the
RB tree lock to avoid a deadlock. However, this would allow
the eviction function to take the lock resulting in the removal
of cache nodes.

If the node being removed by the eviction code is the same as
the node being invalidated, the result is use after free.

The same is true in the other direction due to the temporary
release of the eviction list lock in the eviction loop.

Another corner case exists when dealing with the SDMA buffer
cache that could cause memory corruption of kernel memory.
The most common way, in which this corruption exhibits itself
is a linked list node corruption. In that case, the kernel will
complain that a node with poisoned pointers is being removed.
The fact that the pointers are already poisoned means that the
node has already been removed from the list.

To root cause of this corruption was a mishandling of the
eviction list maintained by the driver. In order for this
to happen four conditions need to be satisfied:

   1. A node describing a user buffer already exists in the
      interval RB tree,
   2. The beginning of the current user buffer matches that
      node but is bigger. This will cause the node to be
      extended.
   3. The amount of cached buffers is close or at the limit
      of the buffer cache size.
   4. The node has dropped close to the end of the eviction
      list. This will cause the node to be considered for
      eviction.

If all of the above conditions have been satisfied, it is
possible for the eviction algorithm to evict the current node,
which will free the node without the driver knowing.

To solve both issues described above:
   - the locking around the MMU invalidation loop and cache
     eviction loop has been improved so locks are not released in
     the loop body,
   - a new RB function is introduced which will "atomically" find
     and remove the matching node from the RB tree, preventing the
     MMU invalidation loop from touching it, and
   - the node being extended by the pin_vector_pages() function is
     removed from the eviction list prior to calling the eviction
     function.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mmu_rb.c    |    6 ++--
 drivers/staging/rdma/hfi1/user_sdma.c |   56 +++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mmu_rb.c b/drivers/staging/rdma/hfi1/mmu_rb.c
index 03f360a..2b0e91d 100644
--- a/drivers/staging/rdma/hfi1/mmu_rb.c
+++ b/drivers/staging/rdma/hfi1/mmu_rb.c
@@ -316,9 +316,9 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		hfi1_cdbg(MMU, "Invalidating node addr 0x%llx, len %u",
 			  node->addr, node->len);
 		if (handler->ops->invalidate(root, node)) {
-			spin_unlock_irqrestore(&handler->lock, flags);
-			__mmu_rb_remove(handler, node, mm);
-			spin_lock_irqsave(&handler->lock, flags);
+			__mmu_int_rb_remove(node, root);
+			if (handler->ops->remove)
+				handler->ops->remove(root, node, mm);
 		}
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index f7e2fe7..635ddf8 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -180,6 +180,8 @@ struct user_sdma_iovec {
 	u64 offset;
 };
 
+#define SDMA_CACHE_NODE_EVICT BIT(0)
+
 struct sdma_mmu_node {
 	struct mmu_rb_node rb;
 	struct list_head list;
@@ -187,6 +189,7 @@ struct sdma_mmu_node {
 	atomic_t refcount;
 	struct page **pages;
 	unsigned npages;
+	unsigned long flags;
 };
 
 struct user_sdma_request {
@@ -1030,27 +1033,29 @@ static inline int num_user_pages(const struct iovec *iov)
 	return 1 + ((epage - spage) >> PAGE_SHIFT);
 }
 
-/* Caller must hold pq->evict_lock */
 static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
 {
 	u32 cleared = 0;
 	struct sdma_mmu_node *node, *ptr;
+	struct list_head to_evict = LIST_HEAD_INIT(to_evict);
 
+	spin_lock(&pq->evict_lock);
 	list_for_each_entry_safe_reverse(node, ptr, &pq->evict, list) {
 		/* Make sure that no one is still using the node. */
 		if (!atomic_read(&node->refcount)) {
-			/*
-			 * Need to use the page count now as the remove callback
-			 * will free the node.
-			 */
+			set_bit(SDMA_CACHE_NODE_EVICT, &node->flags);
+			list_del_init(&node->list);
+			list_add(&node->list, &to_evict);
 			cleared += node->npages;
-			spin_unlock(&pq->evict_lock);
-			hfi1_mmu_rb_remove(&pq->sdma_rb_root, &node->rb);
-			spin_lock(&pq->evict_lock);
 			if (cleared >= npages)
 				break;
 		}
 	}
+	spin_unlock(&pq->evict_lock);
+
+	list_for_each_entry_safe(node, ptr, &to_evict, list)
+		hfi1_mmu_rb_remove(&pq->sdma_rb_root, &node->rb);
+
 	return cleared;
 }
 
@@ -1092,11 +1097,25 @@ static int pin_vector_pages(struct user_sdma_request *req,
 		memcpy(pages, node->pages, node->npages * sizeof(*pages));
 
 		npages -= node->npages;
+
+		/*
+		 * If rb_node is NULL, it means that this is brand new node
+		 * and, therefore not on the eviction list.
+		 * If, however, the rb_node is non-NULL, it means that the
+		 * node is already in RB tree and, therefore on the eviction
+		 * list (nodes are unconditionally inserted in the eviction
+		 * list). In that case, we have to remove the node prior to
+		 * calling the eviction function in order to prevent it from
+		 * freeing this node.
+		 */
+		if (rb_node) {
+			spin_lock(&pq->evict_lock);
+			list_del_init(&node->list);
+			spin_unlock(&pq->evict_lock);
+		}
 retry:
 		if (!hfi1_can_pin_pages(pq->dd, pq->n_locked, npages)) {
-			spin_lock(&pq->evict_lock);
 			cleared = sdma_cache_evict(pq, npages);
-			spin_unlock(&pq->evict_lock);
 			if (cleared >= npages)
 				goto retry;
 		}
@@ -1121,10 +1140,7 @@ retry:
 		node->npages += pinned;
 		npages = node->npages;
 		spin_lock(&pq->evict_lock);
-		if (!rb_node)
-			list_add(&node->list, &pq->evict);
-		else
-			list_move(&node->list, &pq->evict);
+		list_add(&node->list, &pq->evict);
 		pq->n_locked += pinned;
 		spin_unlock(&pq->evict_lock);
 	}
@@ -1555,6 +1571,18 @@ static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
 		container_of(mnode, struct sdma_mmu_node, rb);
 
 	spin_lock(&node->pq->evict_lock);
+	/*
+	 * We've been called by the MMU notifier but this node has been
+	 * scheduled for eviction. The eviction function will take care
+	 * of freeing this node.
+	 * We have to take the above lock first because we are racing
+	 * against the setting of the bit in the eviction function.
+	 */
+	if (mm && test_bit(SDMA_CACHE_NODE_EVICT, &node->flags)) {
+		spin_unlock(&node->pq->evict_lock);
+		return;
+	}
+
 	if (!list_empty(&node->list))
 		list_del(&node->list);
 	node->pq->n_locked -= node->npages;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

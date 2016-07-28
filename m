From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 12/16] IB/hfi1: Use evict mmu rb operation
Date: Thu, 28 Jul 2016 15:21:23 -0400
Message-ID: <1469733687-31738-13-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the new cache evict operation in the SDMA code.  This allows the cache
to properly coordinate evicts and removes, preventing any race.  With this
change, the separate list, lock, and race flag are not needed.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 116 +++++++++++++--------------------
 drivers/infiniband/hw/hfi1/user_sdma.h |   4 +-
 2 files changed, 47 insertions(+), 73 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 8be095e1a538..3d76222d1aac 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -183,16 +183,18 @@ struct user_sdma_iovec {
 	struct sdma_mmu_node *node;
 };
 
-#define SDMA_CACHE_NODE_EVICT 0
-
 struct sdma_mmu_node {
 	struct mmu_rb_node rb;
-	struct list_head list;
 	struct hfi1_user_sdma_pkt_q *pq;
 	atomic_t refcount;
 	struct page **pages;
 	unsigned npages;
-	unsigned long flags;
+};
+
+/* evict operation argument */
+struct evict_data {
+	u32 cleared;	/* count evicted so far */
+	u32 target;	/* target count to evict */
 };
 
 struct user_sdma_request {
@@ -306,6 +308,8 @@ static int defer_packet_queue(
 static void activate_packet_queue(struct iowait *, int);
 static bool sdma_rb_filter(struct mmu_rb_node *, unsigned long, unsigned long);
 static int sdma_rb_insert(void *, struct mmu_rb_node *);
+static int sdma_rb_evict(void *arg, struct mmu_rb_node *mnode,
+			 void *arg2, bool *stop);
 static void sdma_rb_remove(void *, struct mmu_rb_node *,
 			   struct mm_struct *);
 static int sdma_rb_invalidate(void *, struct mmu_rb_node *);
@@ -313,6 +317,7 @@ static int sdma_rb_invalidate(void *, struct mmu_rb_node *);
 static struct mmu_rb_ops sdma_rb_ops = {
 	.filter = sdma_rb_filter,
 	.insert = sdma_rb_insert,
+	.evict = sdma_rb_evict,
 	.remove = sdma_rb_remove,
 	.invalidate = sdma_rb_invalidate
 };
@@ -410,8 +415,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	pq->state = SDMA_PKT_Q_INACTIVE;
 	atomic_set(&pq->n_reqs, 0);
 	init_waitqueue_head(&pq->wait);
-	INIT_LIST_HEAD(&pq->evict);
-	spin_lock_init(&pq->evict_lock);
+	atomic_set(&pq->n_locked, 0);
 	pq->mm = fd->mm;
 
 	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
@@ -1126,28 +1130,12 @@ static inline int num_user_pages(const struct iovec *iov)
 
 static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
 {
-	u32 cleared = 0;
-	struct sdma_mmu_node *node, *ptr;
-	struct list_head to_evict = LIST_HEAD_INIT(to_evict);
-
-	spin_lock(&pq->evict_lock);
-	list_for_each_entry_safe_reverse(node, ptr, &pq->evict, list) {
-		/* Make sure that no one is still using the node. */
-		if (!atomic_read(&node->refcount)) {
-			set_bit(SDMA_CACHE_NODE_EVICT, &node->flags);
-			list_del_init(&node->list);
-			list_add(&node->list, &to_evict);
-			cleared += node->npages;
-			if (cleared >= npages)
-				break;
-		}
-	}
-	spin_unlock(&pq->evict_lock);
+	struct evict_data evict_data;
 
-	list_for_each_entry_safe(node, ptr, &to_evict, list)
-		hfi1_mmu_rb_remove(pq->handler, &node->rb);
-
-	return cleared;
+	evict_data.cleared = 0;
+	evict_data.target = npages;
+	hfi1_mmu_rb_evict(pq->handler, &evict_data);
+	return evict_data.cleared;
 }
 
 static int pin_vector_pages(struct user_sdma_request *req,
@@ -1175,7 +1163,6 @@ static int pin_vector_pages(struct user_sdma_request *req,
 		node->rb.addr = (unsigned long)iovec->iov.iov_base;
 		node->pq = pq;
 		atomic_set(&node->refcount, 0);
-		INIT_LIST_HEAD(&node->list);
 	}
 
 	npages = num_user_pages(&iovec->iov);
@@ -1190,23 +1177,9 @@ static int pin_vector_pages(struct user_sdma_request *req,
 
 		npages -= node->npages;
 
-		/*
-		 * If rb_node is NULL, it means that this is brand new node
-		 * and, therefore not on the eviction list.
-		 * If, however, the rb_node is non-NULL, it means that the
-		 * node is already in RB tree and, therefore on the eviction
-		 * list (nodes are unconditionally inserted in the eviction
-		 * list). In that case, we have to remove the node prior to
-		 * calling the eviction function in order to prevent it from
-		 * freeing this node.
-		 */
-		if (rb_node) {
-			spin_lock(&pq->evict_lock);
-			list_del_init(&node->list);
-			spin_unlock(&pq->evict_lock);
-		}
 retry:
-		if (!hfi1_can_pin_pages(pq->dd, pq->mm, pq->n_locked, npages)) {
+		if (!hfi1_can_pin_pages(pq->dd, pq->mm,
+					atomic_read(&pq->n_locked), npages)) {
 			cleared = sdma_cache_evict(pq, npages);
 			if (cleared >= npages)
 				goto retry;
@@ -1231,10 +1204,7 @@ retry:
 		node->pages = pages;
 		node->npages += pinned;
 		npages = node->npages;
-		spin_lock(&pq->evict_lock);
-		list_add(&node->list, &pq->evict);
-		pq->n_locked += pinned;
-		spin_unlock(&pq->evict_lock);
+		atomic_add(pinned, &pq->n_locked);
 	}
 	iovec->pages = node->pages;
 	iovec->npages = npages;
@@ -1242,11 +1212,7 @@ retry:
 
 	ret = hfi1_mmu_rb_insert(req->pq->handler, &node->rb);
 	if (ret) {
-		spin_lock(&pq->evict_lock);
-		if (!list_empty(&node->list))
-			list_del(&node->list);
-		pq->n_locked -= node->npages;
-		spin_unlock(&pq->evict_lock);
+		atomic_sub(node->npages, &pq->n_locked);
 		iovec->node = NULL;
 		goto bail;
 	}
@@ -1651,29 +1617,39 @@ static int sdma_rb_insert(void *arg, struct mmu_rb_node *mnode)
 	return 0;
 }
 
+/*
+ * Return 1 to remove the node from the rb tree and call the remove op.
+ *
+ * Called with the rb tree lock held.
+ */
+static int sdma_rb_evict(void *arg, struct mmu_rb_node *mnode,
+			 void *evict_arg, bool *stop)
+{
+	struct sdma_mmu_node *node =
+		container_of(mnode, struct sdma_mmu_node, rb);
+	struct evict_data *evict_data = evict_arg;
+
+	/* is this node still being used? */
+	if (atomic_read(&node->refcount))
+		return 0; /* keep this node */
+
+	/* this node will be evicted, add its pages to our count */
+	evict_data->cleared += node->npages;
+
+	/* have enough pages been cleared? */
+	if (evict_data->cleared >= evict_data->target)
+		*stop = true;
+
+	return 1; /* remove this node */
+}
+
 static void sdma_rb_remove(void *arg, struct mmu_rb_node *mnode,
 			   struct mm_struct *mm)
 {
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
 
-	spin_lock(&node->pq->evict_lock);
-	/*
-	 * We've been called by the MMU notifier but this node has been
-	 * scheduled for eviction. The eviction function will take care
-	 * of freeing this node.
-	 * We have to take the above lock first because we are racing
-	 * against the setting of the bit in the eviction function.
-	 */
-	if (mm && test_bit(SDMA_CACHE_NODE_EVICT, &node->flags)) {
-		spin_unlock(&node->pq->evict_lock);
-		return;
-	}
-
-	if (!list_empty(&node->list))
-		list_del(&node->list);
-	node->pq->n_locked -= node->npages;
-	spin_unlock(&node->pq->evict_lock);
+	atomic_sub(node->npages, &node->pq->n_locked);
 
 	/*
 	 * If mm is set, we are being called by the MMU notifier and we
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index bcdc9e8ae1f0..39001714f551 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -69,9 +69,7 @@ struct hfi1_user_sdma_pkt_q {
 	wait_queue_head_t wait;
 	unsigned long unpinned;
 	struct mmu_rb_handler *handler;
-	u32 n_locked;
-	struct list_head evict;
-	spinlock_t evict_lock; /* protect evict and n_locked */
+	atomic_t n_locked;
 	struct mm_struct *mm;
 };
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

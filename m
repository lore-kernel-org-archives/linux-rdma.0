From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/12] IB/hfi1: Extract and reinsert MMU RB node on lookup
Date: Tue, 12 Apr 2016 10:46:47 -0700
Message-ID: <20160412174646.19295.34030.stgit@scvm10.sc.intel.com>
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

The page pinning function, which also maintains the pin cache,
behaves one of two ways when an exact buffer match is not found:
  1. If no node is not found (a buffer with the same starting address
     is not found in the cache), a new node is created, the buffer
     pages are pinned, and the node is inserted into the RB tree, or
  2. If a node is found but the buffer in that node is a subset of
     the new user buffer, the node is extended with the new buffer
     pages.

Both modes of operation require (re-)insertion into the interval RB
tree.

When the node being inserted is a new node, the operations are pretty
simple. However, when the node is already existing and is being
extended, special care must be taken.

First, we want to guard against an asynchronous attempt to
delete the node by the MMU invalidation notifier. The simplest way to
do this is to remove the node from the RB tree, preventing the search
algorithm from finding it.

Second, the node needs to be re-inserted so it lands in the proper place
in the tree and the tree is correctly re-balanced. This also requires
the node to be removed from the RB tree.

This commit adds the hfi1_mmu_rb_extract() function, which will search
for a node in the interval RB tree matching an address and length and
remove it from the RB tree if found. This allows for both of the above
special cases be handled in a single step.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mmu_rb.c    |   19 +++++++++++++++++++
 drivers/staging/rdma/hfi1/mmu_rb.h    |    2 ++
 drivers/staging/rdma/hfi1/user_sdma.c |   33 ++++++++++++++-------------------
 3 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mmu_rb.c b/drivers/staging/rdma/hfi1/mmu_rb.c
index a1aaaea..03f360a 100644
--- a/drivers/staging/rdma/hfi1/mmu_rb.c
+++ b/drivers/staging/rdma/hfi1/mmu_rb.c
@@ -239,6 +239,25 @@ struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *root, unsigned long addr,
 	return node;
 }
 
+struct mmu_rb_node *hfi1_mmu_rb_extract(struct rb_root *root,
+					unsigned long addr, unsigned long len)
+{
+	struct mmu_rb_handler *handler = find_mmu_handler(root);
+	struct mmu_rb_node *node;
+	unsigned long flags;
+
+	if (!handler)
+		return ERR_PTR(-EINVAL);
+
+	spin_lock_irqsave(&handler->lock, flags);
+	node = __mmu_rb_search(handler, addr, len);
+	if (node)
+		__mmu_int_rb_remove(node, handler->root);
+	spin_unlock_irqrestore(&handler->lock, flags);
+
+	return node;
+}
+
 void hfi1_mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
 {
 	struct mmu_rb_handler *handler = find_mmu_handler(root);
diff --git a/drivers/staging/rdma/hfi1/mmu_rb.h b/drivers/staging/rdma/hfi1/mmu_rb.h
index 19a306e..7a57b9c 100644
--- a/drivers/staging/rdma/hfi1/mmu_rb.h
+++ b/drivers/staging/rdma/hfi1/mmu_rb.h
@@ -70,5 +70,7 @@ int hfi1_mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
 void hfi1_mmu_rb_remove(struct rb_root *, struct mmu_rb_node *);
 struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *, unsigned long,
 				       unsigned long);
+struct mmu_rb_node *hfi1_mmu_rb_extract(struct rb_root *, unsigned long,
+					unsigned long);
 
 #endif /* _HFI1_MMU_RB_H */
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index d1645d9..f7e2fe7 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -1062,9 +1062,9 @@ static int pin_vector_pages(struct user_sdma_request *req,
 	struct sdma_mmu_node *node = NULL;
 	struct mmu_rb_node *rb_node;
 
-	rb_node = hfi1_mmu_rb_search(&pq->sdma_rb_root,
-				     (unsigned long)iovec->iov.iov_base,
-				     iovec->iov.iov_len);
+	rb_node = hfi1_mmu_rb_extract(&pq->sdma_rb_root,
+				      (unsigned long)iovec->iov.iov_base,
+				      iovec->iov.iov_len);
 	if (rb_node && !IS_ERR(rb_node))
 		node = container_of(rb_node, struct sdma_mmu_node, rb);
 	else
@@ -1131,25 +1131,20 @@ retry:
 	iovec->pages = node->pages;
 	iovec->npages = npages;
 
-	if (!rb_node) {
-		ret = hfi1_mmu_rb_insert(&req->pq->sdma_rb_root, &node->rb);
-		if (ret) {
-			spin_lock(&pq->evict_lock);
-			if (!list_empty(&node->list))
-				list_del(&node->list);
-			pq->n_locked -= node->npages;
-			spin_unlock(&pq->evict_lock);
-			unpin_vector_pages(current->mm, node->pages, 0,
-					   node->npages);
-			goto bail;
-		}
-	} else {
-		atomic_inc(&node->refcount);
+	ret = hfi1_mmu_rb_insert(&req->pq->sdma_rb_root, &node->rb);
+	if (ret) {
+		spin_lock(&pq->evict_lock);
+		if (!list_empty(&node->list))
+			list_del(&node->list);
+		pq->n_locked -= node->npages;
+		spin_unlock(&pq->evict_lock);
+		goto bail;
 	}
 	return 0;
 bail:
-	if (!rb_node)
-		kfree(node);
+	if (rb_node)
+		unpin_vector_pages(current->mm, node->pages, 0, node->npages);
+	kfree(node);
 	return ret;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

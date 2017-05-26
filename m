From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/9] IB/hfi1: Don't remove RB entry when not needed.
Date: Fri, 26 May 2017 05:35:12 -0700
Message-ID: <20170526123510.8158.86788.stgit@scvm10.sc.intel.com>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170526123257.8158.23943.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

An RB tree is used for the SDMA pinning cache. Cache
entries are extracted and reinserted from the tree
in case the address range for it changes. However,
if the address range for the entry doesn't change,
deleting the entry from the RB tree is not necessary.

This affects performance since the tree needs to be
rebalanced for each insertion, and this happens in
the hot path. Optimize RB search by not removing
entries when it's not needed.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c    |   14 ++++++++++----
 drivers/infiniband/hw/hfi1/mmu_rb.h    |    5 +++--
 drivers/infiniband/hw/hfi1/user_sdma.c |   23 ++++++++++++++++-------
 3 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index ccbf52c..d41fd87 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -217,21 +217,27 @@ int hfi1_mmu_rb_insert(struct mmu_rb_handler *handler,
 	return node;
 }
 
-struct mmu_rb_node *hfi1_mmu_rb_extract(struct mmu_rb_handler *handler,
-					unsigned long addr, unsigned long len)
+bool hfi1_mmu_rb_remove_unless_exact(struct mmu_rb_handler *handler,
+				     unsigned long addr, unsigned long len,
+				     struct mmu_rb_node **rb_node)
 {
 	struct mmu_rb_node *node;
 	unsigned long flags;
+	bool ret = false;
 
 	spin_lock_irqsave(&handler->lock, flags);
 	node = __mmu_rb_search(handler, addr, len);
 	if (node) {
+		if (node->addr == addr && node->len == len)
+			goto unlock;
 		__mmu_int_rb_remove(node, &handler->root);
 		list_del(&node->list); /* remove from LRU list */
+		ret = true;
 	}
+unlock:
 	spin_unlock_irqrestore(&handler->lock, flags);
-
-	return node;
+	*rb_node = node;
+	return ret;
 }
 
 void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index 754f6eb..f04cec1 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -81,7 +81,8 @@ int hfi1_mmu_rb_insert(struct mmu_rb_handler *handler,
 void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg);
 void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 			struct mmu_rb_node *mnode);
-struct mmu_rb_node *hfi1_mmu_rb_extract(struct mmu_rb_handler *handler,
-					unsigned long addr, unsigned long len);
+bool hfi1_mmu_rb_remove_unless_exact(struct mmu_rb_handler *handler,
+				     unsigned long addr, unsigned long len,
+				     struct mmu_rb_node **rb_node);
 
 #endif /* _HFI1_MMU_RB_H */
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 16fd519..79450cf 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1165,14 +1165,23 @@ static int pin_vector_pages(struct user_sdma_request *req,
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
 	struct sdma_mmu_node *node = NULL;
 	struct mmu_rb_node *rb_node;
-
-	rb_node = hfi1_mmu_rb_extract(pq->handler,
-				      (unsigned long)iovec->iov.iov_base,
-				      iovec->iov.iov_len);
-	if (rb_node)
+	bool extracted;
+
+	extracted =
+		hfi1_mmu_rb_remove_unless_exact(pq->handler,
+						(unsigned long)
+						iovec->iov.iov_base,
+						iovec->iov.iov_len, &rb_node);
+	if (rb_node) {
 		node = container_of(rb_node, struct sdma_mmu_node, rb);
-	else
-		rb_node = NULL;
+		if (!extracted) {
+			atomic_inc(&node->refcount);
+			iovec->pages = node->pages;
+			iovec->npages = node->npages;
+			iovec->node = node;
+			return 0;
+		}
+	}
 
 	if (!node) {
 		node = kzalloc(sizeof(*node), GFP_KERNEL);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

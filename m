From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 10/16] IB/hfi1: Fix the bail out code in
 pin_vector_pages() function
Date: Mon, 21 Aug 2017 18:27:09 -0700
Message-ID: <20170822012708.32701.86094.stgit@scvm10.sc.intel.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822011657.32701.22207.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In pin_vector_pages() function, if there is any error while pinning the
pages or while adding a pinned buffer to the cache, the bail out code
needs to unpin any pinned pages that are not in the cache and adjust the
n_locked counter that counts the total pages pinned. The current bail
out code doesn't seem to be doing it right in two cases:

1. Before pinning required pages for a buffer, the SDMA pinned buffer
cache is searched to see if the virtual address range that needs to be
pinned is already pinned. If there isn't a hit in the cache, a new node
is created for the buffer and is added to the cache after the buffer is
pinned. If adding the new node to the cache fails, the n_locked count is
decremented properly but the pinned pages are not freed. This commit
fixes this issue.

2. If there is a hit in the SDMA cache, but the cached buffer doesn't
have enough pages to cover the entire address range that needs to be
pinned, the node for the cached buffer is extracted from the cache,
remaining pages needed are pinned and added to the node. The node is
finally added back into the cache. If there is an error pinning the
extra pages, the bail out code frees all the pages in the node but the
n_locked count is not being decremented by the no of pages in the node
that are freed. This commit fixes this issue.

This commit fixes the above two issues by creating a new function that
frees the pages in a node and decrements the n_locked count by the
number of pages freed.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 6f26253..a3a9925 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1167,6 +1167,14 @@ static int pin_sdma_pages(struct user_sdma_request *req,
 	return pinned;
 }
 
+static void unpin_sdma_pages(struct sdma_mmu_node *node)
+{
+	if (node->npages) {
+		unpin_vector_pages(node->pq->mm, node->pages, 0, node->npages);
+		atomic_sub(node->npages, &node->pq->n_locked);
+	}
+}
+
 static int pin_vector_pages(struct user_sdma_request *req,
 			    struct user_sdma_iovec *iovec)
 {
@@ -1218,14 +1226,12 @@ static int pin_vector_pages(struct user_sdma_request *req,
 
 	ret = hfi1_mmu_rb_insert(req->pq->handler, &node->rb);
 	if (ret) {
-		atomic_sub(node->npages, &pq->n_locked);
 		iovec->node = NULL;
 		goto bail;
 	}
 	return 0;
 bail:
-	if (rb_node)
-		unpin_vector_pages(pq->mm, node->pages, 0, node->npages);
+	unpin_sdma_pages(node);
 	kfree(node);
 	return ret;
 }
@@ -1671,10 +1677,7 @@ static void sdma_rb_remove(void *arg, struct mmu_rb_node *mnode)
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
 
-	atomic_sub(node->npages, &node->pq->n_locked);
-
-	unpin_vector_pages(node->pq->mm, node->pages, 0, node->npages);
-
+	unpin_sdma_pages(node);
 	kfree(node);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

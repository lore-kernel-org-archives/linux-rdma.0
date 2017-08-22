From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 09/16] IB/hfi1: Clean up pin_vector_pages() function
Date: Mon, 21 Aug 2017 18:27:03 -0700
Message-ID: <20170822012702.32701.90032.stgit@scvm10.sc.intel.com>
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

Clean up pin_vector_pages() function by moving page pinning related code
to a separate function since it really stands on its own.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   79 ++++++++++++++++++--------------
 1 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index d5a2572..6f26253 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1124,11 +1124,53 @@ static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
 	return evict_data.cleared;
 }
 
+static int pin_sdma_pages(struct user_sdma_request *req,
+			  struct user_sdma_iovec *iovec,
+			  struct sdma_mmu_node *node,
+			  int npages)
+{
+	int pinned, cleared;
+	struct page **pages;
+	struct hfi1_user_sdma_pkt_q *pq = req->pq;
+
+	pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages) {
+		SDMA_DBG(req, "Failed page array alloc");
+		return -ENOMEM;
+	}
+	memcpy(pages, node->pages, node->npages * sizeof(*pages));
+
+	npages -= node->npages;
+retry:
+	if (!hfi1_can_pin_pages(pq->dd, pq->mm,
+				atomic_read(&pq->n_locked), npages)) {
+		cleared = sdma_cache_evict(pq, npages);
+		if (cleared >= npages)
+			goto retry;
+	}
+	pinned = hfi1_acquire_user_pages(pq->mm,
+					 ((unsigned long)iovec->iov.iov_base +
+					 (node->npages * PAGE_SIZE)), npages, 0,
+					 pages + node->npages);
+	if (pinned < 0) {
+		kfree(pages);
+		return pinned;
+	}
+	if (pinned != npages) {
+		unpin_vector_pages(pq->mm, pages, node->npages, pinned);
+		return -EFAULT;
+	}
+	kfree(node->pages);
+	node->rb.len = iovec->iov.iov_len;
+	node->pages = pages;
+	atomic_add(pinned, &pq->n_locked);
+	return pinned;
+}
+
 static int pin_vector_pages(struct user_sdma_request *req,
 			    struct user_sdma_iovec *iovec)
 {
-	int ret = 0, pinned, npages, cleared;
-	struct page **pages;
+	int ret = 0, pinned, npages;
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
 	struct sdma_mmu_node *node = NULL;
 	struct mmu_rb_node *rb_node;
@@ -1162,44 +1204,13 @@ static int pin_vector_pages(struct user_sdma_request *req,
 
 	npages = num_user_pages(&iovec->iov);
 	if (node->npages < npages) {
-		pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
-		if (!pages) {
-			SDMA_DBG(req, "Failed page array alloc");
-			ret = -ENOMEM;
-			goto bail;
-		}
-		memcpy(pages, node->pages, node->npages * sizeof(*pages));
-
-		npages -= node->npages;
-
-retry:
-		if (!hfi1_can_pin_pages(pq->dd, pq->mm,
-					atomic_read(&pq->n_locked), npages)) {
-			cleared = sdma_cache_evict(pq, npages);
-			if (cleared >= npages)
-				goto retry;
-		}
-		pinned = hfi1_acquire_user_pages(pq->mm,
-			((unsigned long)iovec->iov.iov_base +
-			 (node->npages * PAGE_SIZE)), npages, 0,
-			pages + node->npages);
+		pinned = pin_sdma_pages(req, iovec, node, npages);
 		if (pinned < 0) {
-			kfree(pages);
 			ret = pinned;
 			goto bail;
 		}
-		if (pinned != npages) {
-			unpin_vector_pages(pq->mm, pages, node->npages,
-					   pinned);
-			ret = -EFAULT;
-			goto bail;
-		}
-		kfree(node->pages);
-		node->rb.len = iovec->iov.iov_len;
-		node->pages = pages;
 		node->npages += pinned;
 		npages = node->npages;
-		atomic_add(pinned, &pq->n_locked);
 	}
 	iovec->pages = node->pages;
 	iovec->npages = npages;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

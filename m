From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/12] IB/hfi1: Correctly compute node interval
Date: Tue, 12 Apr 2016 10:46:41 -0700
Message-ID: <20160412174640.19295.72873.stgit@scvm10.sc.intel.com>
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

The computation of the interval of an interval RB node
was incorrect leading to data corruption due to the RB
search algorithm not properly finding the all RB nodes
in an MMU invalidation interval.

The problem stemmed from the fact that the beginning
address of the node's range was being aligned to a page
boundary. For certain buffer sizes, this would lead to
a end address calculation that was off by 1 page.

An important aspect of keeping the RB same is also
updating the node's range in the case it's being extended.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mmu_rb.c    |    2 +-
 drivers/staging/rdma/hfi1/user_sdma.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mmu_rb.c b/drivers/staging/rdma/hfi1/mmu_rb.c
index 72b6d70..a1aaaea 100644
--- a/drivers/staging/rdma/hfi1/mmu_rb.c
+++ b/drivers/staging/rdma/hfi1/mmu_rb.c
@@ -91,7 +91,7 @@ static unsigned long mmu_node_start(struct mmu_rb_node *node)
 
 static unsigned long mmu_node_last(struct mmu_rb_node *node)
 {
-	return PAGE_ALIGN((node->addr & PAGE_MASK) + node->len) - 1;
+	return PAGE_ALIGN(node->addr + node->len) - 1;
 }
 
 int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 044d337..d1645d9 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -1076,7 +1076,6 @@ static int pin_vector_pages(struct user_sdma_request *req,
 			return -ENOMEM;
 
 		node->rb.addr = (unsigned long)iovec->iov.iov_base;
-		node->rb.len = iovec->iov.iov_len;
 		node->pq = pq;
 		atomic_set(&node->refcount, 0);
 		INIT_LIST_HEAD(&node->list);
@@ -1117,6 +1116,7 @@ retry:
 			goto bail;
 		}
 		kfree(node->pages);
+		node->rb.len = iovec->iov.iov_len;
 		node->pages = pages;
 		node->npages += pinned;
 		npages = node->npages;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

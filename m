From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 1/5] staging/rdma/hfi1: Convert to use get_user_pages_fast
Date: Tue,  8 Dec 2015 17:10:09 -0500
Message-ID: <1449612613-6616-2-git-send-email-ira.weiny@intel.com>
References: <1449612613-6616-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449612613-6616-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Convert hfi1_get_user_pages() to use get_user_pages_fast(),
which is much fatster. The mm semaphore is still taken to
update the pinned page count but is for a much shorter
amount of time.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c   |  8 +--
 drivers/staging/rdma/hfi1/hfi.h        |  4 +-
 drivers/staging/rdma/hfi1/user_pages.c | 97 +++++++++-------------------------
 3 files changed, 32 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 22037ce984c8..76580030f514 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1670,8 +1670,8 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 		 * Now that we know how many free RcvArray entries we have,
 		 * we can pin that many user pages.
 		 */
-		ret = hfi1_get_user_pages(vaddr + (mapped * PAGE_SIZE),
-					  pinned, pages);
+		ret = hfi1_acquire_user_pages(vaddr + (mapped * PAGE_SIZE),
+					      pinned, true, pages);
 		if (ret) {
 			/*
 			 * We can't continue because the pages array won't be
@@ -1840,7 +1840,7 @@ static int exp_tid_free(struct file *fp, struct hfi1_tid_info *tinfo)
 				}
 			}
 			flush_wc();
-			hfi1_release_user_pages(pshadow, pcount);
+			hfi1_release_user_pages(pshadow, pcount, true);
 			clear_bit(bitidx, &uctxt->tidusemap[idx]);
 			map &= ~(1ULL<<bitidx);
 		}
@@ -1869,7 +1869,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt)
 		uctxt->physshadow[tid] = 0;
 		uctxt->tid_pg_list[tid] = NULL;
 		pci_unmap_page(dd->pcidev, phys, PAGE_SIZE, PCI_DMA_FROMDEVICE);
-		hfi1_release_user_pages(&p, 1);
+		hfi1_release_user_pages(&p, 1, true);
 	}
 }
 
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 54ed6b36c1a7..467e1a9f8ed2 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1551,8 +1551,8 @@ void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int val);
  */
 #define DEFAULT_RCVHDR_ENTSIZE 32
 
-int hfi1_get_user_pages(unsigned long, size_t, struct page **);
-void hfi1_release_user_pages(struct page **, size_t);
+int hfi1_acquire_user_pages(unsigned long, size_t, bool, struct page **);
+void hfi1_release_user_pages(struct page **, size_t, bool);
 
 static inline void clear_rcvhdrtail(const struct hfi1_ctxtdata *rcd)
 {
diff --git a/drivers/staging/rdma/hfi1/user_pages.c b/drivers/staging/rdma/hfi1/user_pages.c
index 9071afbd7bf4..692de658f0dc 100644
--- a/drivers/staging/rdma/hfi1/user_pages.c
+++ b/drivers/staging/rdma/hfi1/user_pages.c
@@ -49,59 +49,11 @@
  */
 
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/device.h>
 
 #include "hfi.h"
 
-static void __hfi1_release_user_pages(struct page **p, size_t num_pages,
-				      int dirty)
-{
-	size_t i;
-
-	for (i = 0; i < num_pages; i++) {
-		if (dirty)
-			set_page_dirty_lock(p[i]);
-		put_page(p[i]);
-	}
-}
-
-/*
- * Call with current->mm->mmap_sem held.
- */
-static int __hfi1_get_user_pages(unsigned long start_page, size_t num_pages,
-				 struct page **p)
-{
-	unsigned long lock_limit;
-	size_t got;
-	int ret;
-
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if (num_pages > lock_limit && !capable(CAP_IPC_LOCK)) {
-		ret = -ENOMEM;
-		goto bail;
-	}
-
-	for (got = 0; got < num_pages; got += ret) {
-		ret = get_user_pages(current, current->mm,
-				     start_page + got * PAGE_SIZE,
-				     num_pages - got, 1, 1,
-				     p + got, NULL);
-		if (ret < 0)
-			goto bail_release;
-	}
-
-	current->mm->pinned_vm += num_pages;
-
-	ret = 0;
-	goto bail;
-
-bail_release:
-	__hfi1_release_user_pages(p, got, 0);
-bail:
-	return ret;
-}
-
 /**
  * hfi1_map_page - a safety wrapper around pci_map_page()
  *
@@ -116,41 +68,44 @@ dma_addr_t hfi1_map_page(struct pci_dev *hwdev, struct page *page,
 	return phys;
 }
 
-/**
- * hfi1_get_user_pages - lock user pages into memory
- * @start_page: the start page
- * @num_pages: the number of pages
- * @p: the output page structures
- *
- * This function takes a given start page (page aligned user virtual
- * address) and pins it and the following specified number of pages.  For
- * now, num_pages is always 1, but that will probably change at some point
- * (because caller is doing expected sends on a single virtually contiguous
- * buffer, so we can do all pages at once).
- */
-int hfi1_get_user_pages(unsigned long start_page, size_t num_pages,
-			struct page **p)
+int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
+			    struct page **pages)
 {
+	unsigned long pinned, lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	bool can_lock = capable(CAP_IPC_LOCK);
 	int ret;
 
-	down_write(&current->mm->mmap_sem);
+	down_read(&current->mm->mmap_sem);
+	pinned = current->mm->pinned_vm;
+	up_read(&current->mm->mmap_sem);
 
-	ret = __hfi1_get_user_pages(start_page, num_pages, p);
+	if (pinned + npages > lock_limit && !can_lock)
+		return -ENOMEM;
 
+	ret = get_user_pages_fast(vaddr, npages, writable, pages);
+	if (ret < 0)
+		return ret;
+
+	down_write(&current->mm->mmap_sem);
+	current->mm->pinned_vm += ret;
 	up_write(&current->mm->mmap_sem);
 
 	return ret;
 }
 
-void hfi1_release_user_pages(struct page **p, size_t num_pages)
+void hfi1_release_user_pages(struct page **p, size_t npages, bool dirty)
 {
-	if (current->mm) /* during close after signal, mm can be NULL */
-		down_write(&current->mm->mmap_sem);
+	size_t i;
 
-	__hfi1_release_user_pages(p, num_pages, 1);
+	for (i = 0; i < npages; i++) {
+		if (dirty)
+			set_page_dirty_lock(p[i]);
+		put_page(p[i]);
+	}
 
-	if (current->mm) {
-		current->mm->pinned_vm -= num_pages;
+	if (current->mm) { /* during close after signal, mm can be NULL */
+		down_write(&current->mm->mmap_sem);
+		current->mm->pinned_vm -= npages;
 		up_write(&current->mm->mmap_sem);
 	}
 }
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

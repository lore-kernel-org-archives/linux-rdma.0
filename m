From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 3/6] drivers/IB,qib: do not use mmap_sem
Date: Mon, 21 Jan 2019 09:42:17 -0800
Message-ID: <20190121174220.10583-4-dave@stgolabs.net>
References: <20190121174220.10583-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190121174220.10583-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: dledford@redhat.com, jgg@mellanox.com, jack@suse.de, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave@stgolabs.net, dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

The driver uses mmap_sem for both pinned_vm accounting and
get_user_pages(). By using gup_fast() and letting the mm handle
the lock if needed, we can no longer rely on the semaphore and
simplify the whole thing as the pinning is decoupled from the lock.

This also fixes a bug that __qib_get_user_pages was not taking into
account the current value of pinned_vm.

Cc: dennis.dalessandro@intel.com
Cc: mike.marciniszyn@intel.com
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/infiniband/hw/qib/qib_user_pages.c | 67 ++++++++++--------------------
 1 file changed, 22 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
index 602387bf98e7..e4114aad4a2f 100644
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -49,43 +49,6 @@ static void __qib_release_user_pages(struct page **p, size_t num_pages,
 	}
 }
 
-/*
- * Call with current->mm->mmap_sem held.
- */
-static int __qib_get_user_pages(unsigned long start_page, size_t num_pages,
-				struct page **p)
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
-		ret = get_user_pages(start_page + got * PAGE_SIZE,
-				     num_pages - got,
-				     FOLL_WRITE | FOLL_FORCE,
-				     p + got, NULL);
-		if (ret < 0)
-			goto bail_release;
-	}
-
-	atomic64_add(num_pages, &current->mm->pinned_vm);
-
-	ret = 0;
-	goto bail;
-
-bail_release:
-	__qib_release_user_pages(p, got, 0);
-bail:
-	return ret;
-}
-
 /**
  * qib_map_page - a safety wrapper around pci_map_page()
  *
@@ -137,26 +100,40 @@ int qib_map_page(struct pci_dev *hwdev, struct page *page, dma_addr_t *daddr)
 int qib_get_user_pages(unsigned long start_page, size_t num_pages,
 		       struct page **p)
 {
+	unsigned long locked, lock_limit;
+	size_t got;
 	int ret;
 
-	down_write(&current->mm->mmap_sem);
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	locked = atomic64_add_return(num_pages, &current->mm->pinned_vm);
 
-	ret = __qib_get_user_pages(start_page, num_pages, p);
+	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
+		ret = -ENOMEM;
+		goto bail;
+	}
 
-	up_write(&current->mm->mmap_sem);
+	for (got = 0; got < num_pages; got += ret) {
+		ret = get_user_pages_fast(start_page + got * PAGE_SIZE,
+				     num_pages - got,
+				     FOLL_WRITE | FOLL_FORCE,
+				     p + got);
+		if (ret < 0)
+			goto bail_release;
+	}
 
+	return 0;
+bail_release:
+	__qib_release_user_pages(p, got, 0);
+bail:
+	atomic64_sub(num_pages, &current->mm->pinned_vm);
 	return ret;
 }
 
 void qib_release_user_pages(struct page **p, size_t num_pages)
 {
-	if (current->mm) /* during close after signal, mm can be NULL */
-		down_write(&current->mm->mmap_sem);
-
 	__qib_release_user_pages(p, num_pages, 1);
 
-	if (current->mm) {
+	if (current->mm) { /* during close after signal, mm can be NULL */
 		atomic64_sub(num_pages, &current->mm->pinned_vm);
-		up_write(&current->mm->mmap_sem);
 	}
 }
-- 
2.16.4

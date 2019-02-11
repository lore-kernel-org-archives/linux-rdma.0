From: ira.weiny@intel.com
Subject: [PATCH 2/3] mm/gup: Introduce get_user_pages_fast_longterm()
Date: Mon, 11 Feb 2019 12:16:42 -0800
Message-ID: <20190211201643.7599-3-ira.weiny@intel.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211201643.7599-1-ira.weiny@intel.com>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, netdev@vger.kernel.org
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Users of get_user_pages_fast are not protected against mapping
pages within FS DAX.  Introduce a call which protects them.

We do this by checking for DEVMAP pages during the fast walk and
falling back to the longterm gup call to check for FS DAX if needed.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 include/linux/mm.h |   8 ++++
 mm/gup.c           | 102 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 88 insertions(+), 22 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 80bb6408fe73..8f831c823630 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1540,6 +1540,8 @@ long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
 			    unsigned int gup_flags, struct page **pages,
 			    struct vm_area_struct **vmas);
+int get_user_pages_fast_longterm(unsigned long start, int nr_pages, bool write,
+				 struct page **pages);
 #else
 static inline long get_user_pages_longterm(unsigned long start,
 		unsigned long nr_pages, unsigned int gup_flags,
@@ -1547,6 +1549,11 @@ static inline long get_user_pages_longterm(unsigned long start,
 {
 	return get_user_pages(start, nr_pages, gup_flags, pages, vmas);
 }
+static inline int get_user_pages_fast_longterm(unsigned long start, int nr_pages,
+					       bool write, struct page **pages)
+{
+	return get_user_pages_fast(start, nr_pages, write, pages);
+}
 #endif /* CONFIG_FS_DAX */
 
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
@@ -2615,6 +2622,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
 #define FOLL_COW	0x4000	/* internal GUP flag */
 #define FOLL_ANON	0x8000	/* don't do file mappings */
+#define FOLL_LONGTERM	0x10000	/* mapping is intended for a long term pin */
 
 static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 894ab014bd1e..f7d86a304405 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1190,6 +1190,21 @@ long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
 EXPORT_SYMBOL(get_user_pages_longterm);
 #endif /* CONFIG_FS_DAX */
 
+static long get_user_pages_longterm_unlocked(unsigned long start,
+					     unsigned long nr_pages,
+					     struct page **pages,
+					     unsigned int gup_flags)
+{
+	struct mm_struct *mm = current->mm;
+	long ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages_longterm(start, nr_pages, gup_flags, pages, NULL);
+	up_read(&mm->mmap_sem);
+
+	return ret;
+}
+
 /**
  * populate_vma_page_range() -  populate a range of pages in the vma.
  * @vma:   target vma
@@ -1417,6 +1432,9 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			goto pte_unmap;
 
 		if (pte_devmap(pte)) {
+			if (flags & FOLL_LONGTERM)
+				goto pte_unmap;
+
 			pgmap = get_dev_pagemap(pte_pfn(pte), pgmap);
 			if (unlikely(!pgmap)) {
 				undo_dev_pagemap(nr, nr_start, pages);
@@ -1556,8 +1574,12 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
-	if (pmd_devmap(orig))
+	if (pmd_devmap(orig)) {
+		if (flags & FOLL_LONGTERM)
+			return 0;
+
 		return __gup_device_huge_pmd(orig, pmdp, addr, end, pages, nr);
+	}
 
 	refs = 0;
 	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
@@ -1837,24 +1859,9 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	return nr;
 }
 
-/**
- * get_user_pages_fast() - pin user pages in memory
- * @start:	starting user address
- * @nr_pages:	number of pages from start to pin
- * @write:	whether pages will be written to
- * @pages:	array that receives pointers to the pages pinned.
- *		Should be at least nr_pages long.
- *
- * Attempt to pin user pages in memory without taking mm->mmap_sem.
- * If not successful, it will fall back to taking the lock and
- * calling get_user_pages().
- *
- * Returns number of pages pinned. This may be fewer than the number
- * requested. If nr_pages is 0 or negative, returns 0. If no pages
- * were pinned, returns -errno.
- */
-int get_user_pages_fast(unsigned long start, int nr_pages, int write,
-			struct page **pages)
+static int __get_user_pages_fast_flags(unsigned long start, int nr_pages,
+				       unsigned int gup_flags,
+				       struct page **pages)
 {
 	unsigned long addr, len, end;
 	int nr = 0, ret = 0;
@@ -1872,7 +1879,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	if (gup_fast_permitted(start, nr_pages)) {
 		local_irq_disable();
-		gup_pgd_range(addr, end, write ? FOLL_WRITE : 0, pages, &nr);
+		gup_pgd_range(addr, end, gup_flags, pages, &nr);
 		local_irq_enable();
 		ret = nr;
 	}
@@ -1882,8 +1889,14 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		ret = get_user_pages_unlocked(start, nr_pages - nr, pages,
-				write ? FOLL_WRITE : 0);
+		if (gup_flags & FOLL_LONGTERM)
+			ret = get_user_pages_longterm_unlocked(start,
+							       nr_pages - nr,
+							       pages,
+							       gup_flags);
+		else
+			ret = get_user_pages_unlocked(start, nr_pages - nr,
+						      pages, gup_flags);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
@@ -1897,4 +1910,49 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	return ret;
 }
 
+/**
+ * get_user_pages_fast() - pin user pages in memory
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @write:	whether pages will be written to
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long.
+ *
+ * Attempt to pin user pages in memory without taking mm->mmap_sem.
+ * If not successful, it will fall back to taking the lock and
+ * calling get_user_pages().
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno.
+ */
+int get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			struct page **pages)
+{
+	return __get_user_pages_fast_flags(start, nr_pages,
+					   write ? FOLL_WRITE : 0,
+					   pages);
+}
+
+#ifdef CONFIG_FS_DAX
+/**
+ * get_user_pages_fast_longterm() - pin user pages in memory
+ *
+ * Exactly the same semantics as get_user_pages_fast() except fails mappings
+ * device mapped pages (such as DAX pages) which then fall back to checking for
+ * FS DAX pages with get_user_pages_longterm().
+ */
+int get_user_pages_fast_longterm(unsigned long start, int nr_pages, bool write,
+				 struct page **pages)
+{
+	unsigned int gup_flags = FOLL_LONGTERM;
+
+	if (write)
+		gup_flags |= FOLL_WRITE;
+
+	return __get_user_pages_fast_flags(start, nr_pages, gup_flags, pages);
+}
+EXPORT_SYMBOL(get_user_pages_fast_longterm);
+#endif /* CONFIG_FS_DAX */
+
 #endif /* CONFIG_HAVE_GENERIC_GUP */
-- 
2.20.1

From: ira.weiny@intel.com
Subject: [PATCH 1/3] mm/gup: Change "write" parameter to flags
Date: Mon, 11 Feb 2019 12:16:41 -0800
Message-ID: <20190211201643.7599-2-ira.weiny@intel.com>
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

In order to support more options in the GUP fast walk, change the
write parameter to flags throughout the call stack.

This patch does not change functionality and passes FOLL_WRITE
where write was previously used.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 mm/gup.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b63e88eca31b..894ab014bd1e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1395,7 +1395,7 @@ static void undo_dev_pagemap(int *nr, int nr_start, struct page **pages)
 
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
-			 int write, struct page **pages, int *nr)
+			 unsigned int flags, struct page **pages, int *nr)
 {
 	struct dev_pagemap *pgmap = NULL;
 	int nr_start = *nr, ret = 0;
@@ -1413,7 +1413,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 		if (pte_protnone(pte))
 			goto pte_unmap;
 
-		if (!pte_access_permitted(pte, write))
+		if (!pte_access_permitted(pte, flags & FOLL_WRITE))
 			goto pte_unmap;
 
 		if (pte_devmap(pte)) {
@@ -1465,7 +1465,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
  * useful to have gup_huge_pmd even if we can't operate on ptes.
  */
 static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
-			 int write, struct page **pages, int *nr)
+			 unsigned int flags, struct page **pages, int *nr)
 {
 	return 0;
 }
@@ -1548,12 +1548,12 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
 #endif
 
 static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
+		unsigned long end, unsigned int flags, struct page **pages, int *nr)
 {
 	struct page *head, *page;
 	int refs;
 
-	if (!pmd_access_permitted(orig, write))
+	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
 	if (pmd_devmap(orig))
@@ -1586,12 +1586,12 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 }
 
 static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
+		unsigned long end, unsigned int flags, struct page **pages, int *nr)
 {
 	struct page *head, *page;
 	int refs;
 
-	if (!pud_access_permitted(orig, write))
+	if (!pud_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
 	if (pud_devmap(orig))
@@ -1624,13 +1624,13 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
 }
 
 static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
-			unsigned long end, int write,
+			unsigned long end, unsigned int flags,
 			struct page **pages, int *nr)
 {
 	int refs;
 	struct page *head, *page;
 
-	if (!pgd_access_permitted(orig, write))
+	if (!pgd_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
 	BUILD_BUG_ON(pgd_devmap(orig));
@@ -1661,7 +1661,7 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
 }
 
 static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
-		int write, struct page **pages, int *nr)
+		unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pmd_t *pmdp;
@@ -1683,7 +1683,7 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 			if (pmd_protnone(pmd))
 				return 0;
 
-			if (!gup_huge_pmd(pmd, pmdp, addr, next, write,
+			if (!gup_huge_pmd(pmd, pmdp, addr, next, flags,
 				pages, nr))
 				return 0;
 
@@ -1693,9 +1693,9 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 			 * pmd format and THP pmd format
 			 */
 			if (!gup_huge_pd(__hugepd(pmd_val(pmd)), addr,
-					 PMD_SHIFT, next, write, pages, nr))
+					 PMD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pte_range(pmd, addr, next, write, pages, nr))
+		} else if (!gup_pte_range(pmd, addr, next, flags, pages, nr))
 			return 0;
 	} while (pmdp++, addr = next, addr != end);
 
@@ -1703,7 +1703,7 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 }
 
 static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
-			 int write, struct page **pages, int *nr)
+			 unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pud_t *pudp;
@@ -1716,14 +1716,14 @@ static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
 		if (pud_none(pud))
 			return 0;
 		if (unlikely(pud_huge(pud))) {
-			if (!gup_huge_pud(pud, pudp, addr, next, write,
+			if (!gup_huge_pud(pud, pudp, addr, next, flags,
 					  pages, nr))
 				return 0;
 		} else if (unlikely(is_hugepd(__hugepd(pud_val(pud))))) {
 			if (!gup_huge_pd(__hugepd(pud_val(pud)), addr,
-					 PUD_SHIFT, next, write, pages, nr))
+					 PUD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pmd_range(pud, addr, next, write, pages, nr))
+		} else if (!gup_pmd_range(pud, addr, next, flags, pages, nr))
 			return 0;
 	} while (pudp++, addr = next, addr != end);
 
@@ -1731,7 +1731,7 @@ static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
 }
 
 static int gup_p4d_range(pgd_t pgd, unsigned long addr, unsigned long end,
-			 int write, struct page **pages, int *nr)
+			 unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	p4d_t *p4dp;
@@ -1746,9 +1746,9 @@ static int gup_p4d_range(pgd_t pgd, unsigned long addr, unsigned long end,
 		BUILD_BUG_ON(p4d_huge(p4d));
 		if (unlikely(is_hugepd(__hugepd(p4d_val(p4d))))) {
 			if (!gup_huge_pd(__hugepd(p4d_val(p4d)), addr,
-					 P4D_SHIFT, next, write, pages, nr))
+					 P4D_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pud_range(p4d, addr, next, write, pages, nr))
+		} else if (!gup_pud_range(p4d, addr, next, flags, pages, nr))
 			return 0;
 	} while (p4dp++, addr = next, addr != end);
 
@@ -1756,7 +1756,7 @@ static int gup_p4d_range(pgd_t pgd, unsigned long addr, unsigned long end,
 }
 
 static void gup_pgd_range(unsigned long addr, unsigned long end,
-		int write, struct page **pages, int *nr)
+		unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pgd_t *pgdp;
@@ -1769,14 +1769,14 @@ static void gup_pgd_range(unsigned long addr, unsigned long end,
 		if (pgd_none(pgd))
 			return;
 		if (unlikely(pgd_huge(pgd))) {
-			if (!gup_huge_pgd(pgd, pgdp, addr, next, write,
+			if (!gup_huge_pgd(pgd, pgdp, addr, next, flags,
 					  pages, nr))
 				return;
 		} else if (unlikely(is_hugepd(__hugepd(pgd_val(pgd))))) {
 			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
-					 PGDIR_SHIFT, next, write, pages, nr))
+					 PGDIR_SHIFT, next, flags, pages, nr))
 				return;
-		} else if (!gup_p4d_range(pgd, addr, next, write, pages, nr))
+		} else if (!gup_p4d_range(pgd, addr, next, flags, pages, nr))
 			return;
 	} while (pgdp++, addr = next, addr != end);
 }
@@ -1830,7 +1830,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	if (gup_fast_permitted(start, nr_pages)) {
 		local_irq_save(flags);
-		gup_pgd_range(start, end, write, pages, &nr);
+		gup_pgd_range(start, end, write ? FOLL_WRITE : 0, pages, &nr);
 		local_irq_restore(flags);
 	}
 
@@ -1872,7 +1872,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	if (gup_fast_permitted(start, nr_pages)) {
 		local_irq_disable();
-		gup_pgd_range(addr, end, write, pages, &nr);
+		gup_pgd_range(addr, end, write ? FOLL_WRITE : 0, pages, &nr);
 		local_irq_enable();
 		ret = nr;
 	}
-- 
2.20.1

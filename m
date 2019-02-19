From: jglisse@redhat.com
Subject: [PATCH v5 5/9] mm/mmu_notifier: contextual information for event triggering invalidation v2
Date: Tue, 19 Feb 2019 15:04:26 -0500
Message-ID: <20190219200430.11130-6-jglisse@redhat.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219200430.11130-1-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

CPU page table update can happens for many reasons, not only as a result
of a syscall (munmap(), mprotect(), mremap(), madvise(), ...) but also
as a result of kernel activities (memory compression, reclaim, migration,
...).

Users of mmu notifier API track changes to the CPU page table and take
specific action for them. While current API only provide range of virtual
address affected by the change, not why the changes is happening.

This patchset do the initial mechanical convertion of all the places that
calls mmu_notifier_range_init to also provide the default MMU_NOTIFY_UNMAP
event as well as the vma if it is know (most invalidation happens against
a given vma). Passing down the vma allows the users of mmu notifier to
inspect the new vma page protection.

The MMU_NOTIFY_UNMAP is always the safe default as users of mmu notifier
should assume that every for the range is going away when that event
happens. A latter patch do convert mm call path to use a more appropriate
events for each call.

Changes since v1:
    - add the flags parameter to init range flags

This is done as 2 patches so that no call site is forgotten especialy
as it uses this following coccinelle patch:

%<----------------------------------------------------------------------
@@
identifier I1, I2, I3, I4;
@@
static inline void mmu_notifier_range_init(struct mmu_notifier_range *I1,
+enum mmu_notifier_event event,
+unsigned flags,
+struct vm_area_struct *vma,
struct mm_struct *I2, unsigned long I3, unsigned long I4) { ... }

@@
@@
-#define mmu_notifier_range_init(range, mm, start, end)
+#define mmu_notifier_range_init(range, event, flags, vma, mm, start, end)

@@
expression E1, E3, E4;
identifier I1;
@@
<...
mmu_notifier_range_init(E1,
+MMU_NOTIFY_UNMAP, 0, I1,
I1->vm_mm, E3, E4)
...>

@@
expression E1, E2, E3, E4;
identifier FN, VMA;
@@
FN(..., struct vm_area_struct *VMA, ...) {
<...
mmu_notifier_range_init(E1,
+MMU_NOTIFY_UNMAP, 0, VMA,
E2, E3, E4)
...> }

@@
expression E1, E2, E3, E4;
identifier FN, VMA;
@@
FN(...) {
struct vm_area_struct *VMA;
<...
mmu_notifier_range_init(E1,
+MMU_NOTIFY_UNMAP, 0, VMA,
E2, E3, E4)
...> }

@@
expression E1, E2, E3, E4;
identifier FN;
@@
FN(...) {
<...
mmu_notifier_range_init(E1,
+MMU_NOTIFY_UNMAP, 0, NULL,
E2, E3, E4)
...> }
---------------------------------------------------------------------->%

Applied with:
spatch --all-includes --sp-file mmu-notifier.spatch fs/proc/task_mmu.c --in-place
spatch --sp-file mmu-notifier.spatch --dir kernel/events/ --in-place
spatch --sp-file mmu-notifier.spatch --dir mm --in-place

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kvm@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-rdma@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
---
 fs/proc/task_mmu.c           |  3 ++-
 include/linux/mmu_notifier.h |  5 ++++-
 kernel/events/uprobes.c      |  3 ++-
 mm/huge_memory.c             | 12 ++++++++----
 mm/hugetlb.c                 | 12 ++++++++----
 mm/khugepaged.c              |  3 ++-
 mm/ksm.c                     |  6 ++++--
 mm/madvise.c                 |  3 ++-
 mm/memory.c                  | 25 ++++++++++++++++---------
 mm/migrate.c                 |  5 ++++-
 mm/mprotect.c                |  3 ++-
 mm/mremap.c                  |  3 ++-
 mm/oom_kill.c                |  3 ++-
 mm/rmap.c                    |  6 ++++--
 14 files changed, 62 insertions(+), 30 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 92a91e7816d8..fcbd0e574917 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1151,7 +1151,8 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				break;
 			}
 
-			mmu_notifier_range_init(&range, mm, 0, -1UL);
+			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
+						NULL, mm, 0, -1UL);
 			mmu_notifier_invalidate_range_start(&range);
 		}
 		walk_page_range(0, mm->highest_vm_end, &clear_refs_walk);
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 2386e71ac1b8..62f94cd85455 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -356,6 +356,9 @@ static inline void mmu_notifier_mm_destroy(struct mm_struct *mm)
 
 
 static inline void mmu_notifier_range_init(struct mmu_notifier_range *range,
+					   enum mmu_notifier_event event,
+					   unsigned flags,
+					   struct vm_area_struct *vma,
 					   struct mm_struct *mm,
 					   unsigned long start,
 					   unsigned long end)
@@ -491,7 +494,7 @@ static inline void _mmu_notifier_range_init(struct mmu_notifier_range *range,
 	range->end = end;
 }
 
-#define mmu_notifier_range_init(range, mm, start, end) \
+#define mmu_notifier_range_init(range,event,flags,vma,mm,start,end)  \
 	_mmu_notifier_range_init(range, start, end)
 
 static inline bool
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index affa830a198c..46f546bdba00 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -161,7 +161,8 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	struct mmu_notifier_range range;
 	struct mem_cgroup *memcg;
 
-	mmu_notifier_range_init(&range, mm, addr, addr + PAGE_SIZE);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, addr,
+				addr + PAGE_SIZE);
 
 	VM_BUG_ON_PAGE(PageTransHuge(old_page), old_page);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d4847026d4b1..c9d638f1b34e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1184,7 +1184,8 @@ static vm_fault_t do_huge_pmd_wp_page_fallback(struct vm_fault *vmf,
 		cond_resched();
 	}
 
-	mmu_notifier_range_init(&range, vma->vm_mm, haddr,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				haddr,
 				haddr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -1348,7 +1349,8 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
 				    vma, HPAGE_PMD_NR);
 	__SetPageUptodate(new_page);
 
-	mmu_notifier_range_init(&range, vma->vm_mm, haddr,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				haddr,
 				haddr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -2026,7 +2028,8 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
 
-	mmu_notifier_range_init(&range, vma->vm_mm, address & HPAGE_PUD_MASK,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				address & HPAGE_PUD_MASK,
 				(address & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	ptl = pud_lock(vma->vm_mm, pud);
@@ -2244,7 +2247,8 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
 
-	mmu_notifier_range_init(&range, vma->vm_mm, address & HPAGE_PMD_MASK,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				address & HPAGE_PMD_MASK,
 				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	ptl = pmd_lock(vma->vm_mm, pmd);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1c5219193b9e..d9e5c5a4c004 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3250,7 +3250,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
 	if (cow) {
-		mmu_notifier_range_init(&range, src, vma->vm_start,
+		mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, src,
+					vma->vm_start,
 					vma->vm_end);
 		mmu_notifier_invalidate_range_start(&range);
 	}
@@ -3362,7 +3363,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	/*
 	 * If sharing possible, alert mmu notifiers of worst case.
 	 */
-	mmu_notifier_range_init(&range, mm, start, end);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
+				end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
 	mmu_notifier_invalidate_range_start(&range);
 	address = start;
@@ -3629,7 +3631,8 @@ static vm_fault_t hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
 
-	mmu_notifier_range_init(&range, mm, haddr, haddr + huge_page_size(h));
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, haddr,
+				haddr + huge_page_size(h));
 	mmu_notifier_invalidate_range_start(&range);
 
 	/*
@@ -4354,7 +4357,8 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	 * start/end.  Set range.start/range.end to cover the maximum possible
 	 * range if PMD sharing is possible.
 	 */
-	mmu_notifier_range_init(&range, mm, start, end);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
+				end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
 
 	BUG_ON(address >= end);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 449044378782..e7944f5e6258 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1016,7 +1016,8 @@ static void collapse_huge_page(struct mm_struct *mm,
 	pte = pte_offset_map(pmd, address);
 	pte_ptl = pte_lockptr(mm, pmd);
 
-	mmu_notifier_range_init(&range, mm, address, address + HPAGE_PMD_SIZE);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, NULL, mm,
+				address, address + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
diff --git a/mm/ksm.c b/mm/ksm.c
index fa78626da9f0..2ea25fc0befb 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1066,7 +1066,8 @@ static int write_protect_page(struct vm_area_struct *vma, struct page *page,
 
 	BUG_ON(PageTransCompound(page));
 
-	mmu_notifier_range_init(&range, mm, pvmw.address,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm,
+				pvmw.address,
 				pvmw.address + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -1154,7 +1155,8 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	if (!pmd)
 		goto out;
 
-	mmu_notifier_range_init(&range, mm, addr, addr + PAGE_SIZE);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, addr,
+				addr + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
 	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
diff --git a/mm/madvise.c b/mm/madvise.c
index 21a7881a2db4..c617f53a9c09 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -472,7 +472,8 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 	range.end = min(vma->vm_end, end_addr);
 	if (range.end <= vma->vm_start)
 		return -EINVAL;
-	mmu_notifier_range_init(&range, mm, range.start, range.end);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm,
+				range.start, range.end);
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm, range.start, range.end);
diff --git a/mm/memory.c b/mm/memory.c
index 34ced1369883..4565f636cca3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1010,7 +1010,8 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	is_cow = is_cow_mapping(vma->vm_flags);
 
 	if (is_cow) {
-		mmu_notifier_range_init(&range, src_mm, addr, end);
+		mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma,
+					src_mm, addr, end);
 		mmu_notifier_invalidate_range_start(&range);
 	}
 
@@ -1334,7 +1335,8 @@ void unmap_vmas(struct mmu_gather *tlb,
 {
 	struct mmu_notifier_range range;
 
-	mmu_notifier_range_init(&range, vma->vm_mm, start_addr, end_addr);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				start_addr, end_addr);
 	mmu_notifier_invalidate_range_start(&range);
 	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next)
 		unmap_single_vma(tlb, vma, start_addr, end_addr, NULL);
@@ -1356,7 +1358,8 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
 	struct mmu_gather tlb;
 
 	lru_add_drain();
-	mmu_notifier_range_init(&range, vma->vm_mm, start, start + size);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				start, start + size);
 	tlb_gather_mmu(&tlb, vma->vm_mm, start, range.end);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1382,7 +1385,8 @@ static void zap_page_range_single(struct vm_area_struct *vma, unsigned long addr
 	struct mmu_gather tlb;
 
 	lru_add_drain();
-	mmu_notifier_range_init(&range, vma->vm_mm, address, address + size);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				address, address + size);
 	tlb_gather_mmu(&tlb, vma->vm_mm, address, range.end);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
@@ -2278,7 +2282,8 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 
 	__SetPageUptodate(new_page);
 
-	mmu_notifier_range_init(&range, mm, vmf->address & PAGE_MASK,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm,
+				vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -4100,8 +4105,9 @@ static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 			goto out;
 
 		if (range) {
-			mmu_notifier_range_init(range, mm, address & PMD_MASK,
-					     (address & PMD_MASK) + PMD_SIZE);
+			mmu_notifier_range_init(range, MMU_NOTIFY_UNMAP, 0,
+						NULL, mm, address & PMD_MASK,
+						(address & PMD_MASK) + PMD_SIZE);
 			mmu_notifier_invalidate_range_start(range);
 		}
 		*ptlp = pmd_lock(mm, pmd);
@@ -4118,8 +4124,9 @@ static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 		goto out;
 
 	if (range) {
-		mmu_notifier_range_init(range, mm, address & PAGE_MASK,
-				     (address & PAGE_MASK) + PAGE_SIZE);
+		mmu_notifier_range_init(range, MMU_NOTIFY_UNMAP, 0, NULL, mm,
+					address & PAGE_MASK,
+					(address & PAGE_MASK) + PAGE_SIZE);
 		mmu_notifier_invalidate_range_start(range);
 	}
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
diff --git a/mm/migrate.c b/mm/migrate.c
index 76517bf03621..81eb307b2b5b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2340,7 +2340,8 @@ static void migrate_vma_collect(struct migrate_vma *migrate)
 	mm_walk.mm = migrate->vma->vm_mm;
 	mm_walk.private = migrate;
 
-	mmu_notifier_range_init(&range, mm_walk.mm, migrate->start,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, NULL, mm_walk.mm,
+				migrate->start,
 				migrate->end);
 	mmu_notifier_invalidate_range_start(&range);
 	walk_page_range(migrate->start, migrate->end, &mm_walk);
@@ -2748,6 +2749,8 @@ static void migrate_vma_pages(struct migrate_vma *migrate)
 				notified = true;
 
 				mmu_notifier_range_init(&range,
+							MMU_NOTIFY_UNMAP, 0,
+							NULL,
 							migrate->vma->vm_mm,
 							addr, migrate->end);
 				mmu_notifier_invalidate_range_start(&range);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 028c724dcb1a..b10984052ae9 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -185,7 +185,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 
 		/* invoke the mmu notifier if the pmd is populated */
 		if (!range.start) {
-			mmu_notifier_range_init(&range, vma->vm_mm, addr, end);
+			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
+						vma, vma->vm_mm, addr, end);
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
diff --git a/mm/mremap.c b/mm/mremap.c
index 3320616ed93f..364e79bcc1ff 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -249,7 +249,8 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
-	mmu_notifier_range_init(&range, vma->vm_mm, old_addr, old_end);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				old_addr, old_end);
 	mmu_notifier_invalidate_range_start(&range);
 
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3a2484884cfd..539c91d0b26a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -531,7 +531,8 @@ bool __oom_reap_task_mm(struct mm_struct *mm)
 			struct mmu_notifier_range range;
 			struct mmu_gather tlb;
 
-			mmu_notifier_range_init(&range, mm, vma->vm_start,
+			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
+						vma, mm, vma->vm_start,
 						vma->vm_end);
 			tlb_gather_mmu(&tlb, mm, range.start, range.end);
 			if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
diff --git a/mm/rmap.c b/mm/rmap.c
index 0454ecc29537..c6535a6ec850 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -896,7 +896,8 @@ static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
 	 * We have to assume the worse case ie pmd for invalidation. Note that
 	 * the page can not be free from this function.
 	 */
-	mmu_notifier_range_init(&range, vma->vm_mm, address,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				address,
 				min(vma->vm_end, address +
 				    (PAGE_SIZE << compound_order(page))));
 	mmu_notifier_invalidate_range_start(&range);
@@ -1371,7 +1372,8 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	 * Note that the page can not be free in this function as call of
 	 * try_to_unmap() must hold a reference on the page.
 	 */
-	mmu_notifier_range_init(&range, vma->vm_mm, address,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				address,
 				min(vma->vm_end, address +
 				    (PAGE_SIZE << compound_order(page))));
 	if (PageHuge(page)) {
-- 
2.17.2

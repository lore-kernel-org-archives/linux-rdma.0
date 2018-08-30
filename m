From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v6 1/2] mm: migration: fix migration of huge PMD shared
 pages
Date: Thu, 30 Aug 2018 12:56:16 +0200
Message-ID: <20180830105616.GD2656@dhcp22.suse.cz>
References: <20180823205917.16297-1-mike.kravetz@oracle.com>
 <20180823205917.16297-2-mike.kravetz@oracle.com>
 <20180824084157.GD29735@dhcp22.suse.cz>
 <6063f215-a5c8-2f0c-465a-2c515ddc952d@oracle.com>
 <20180827074645.GB21556@dhcp22.suse.cz>
 <20180827134633.GB3930@redhat.com>
 <9209043d-3240-105b-72a3-b4cd30f1b1f1@oracle.com>
 <20180829181424.GB3784@redhat.com>
 <20180829183906.GF10223@dhcp22.suse.cz>
 <20180829211106.GC3784@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180829211106.GC3784@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Davidlohr Bueso <dave@stgolabs.net>, Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org, linux-rdma@vger.kernel.org, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Dimitri Sivanich <sivanich@sgi.com>
List-Id: linux-rdma@vger.kernel.org

On Wed 29-08-18 17:11:07, Jerome Glisse wrote:
> On Wed, Aug 29, 2018 at 08:39:06PM +0200, Michal Hocko wrote:
> > On Wed 29-08-18 14:14:25, Jerome Glisse wrote:
> > > On Wed, Aug 29, 2018 at 10:24:44AM -0700, Mike Kravetz wrote:
> > [...]
> > > > What would be the best mmu notifier interface to use where there are no
> > > > start/end calls?
> > > > Or, is the best solution to add the start/end calls as is done in later
> > > > versions of the code?  If that is the suggestion, has there been any change
> > > > in invalidate start/end semantics that we should take into account?
> > > 
> > > start/end would be the one to add, 4.4 seems broken in respect to THP
> > > and mmu notification. Another solution is to fix user of mmu notifier,
> > > they were only a handful back then. For instance properly adjust the
> > > address to match first address covered by pmd or pud and passing down
> > > correct page size to mmu_notifier_invalidate_page() would allow to fix
> > > this easily.
> > > 
> > > This is ok because user of try_to_unmap_one() replace the pte/pmd/pud
> > > with an invalid one (either poison, migration or swap) inside the
> > > function. So anyone racing would synchronize on those special entry
> > > hence why it is fine to delay mmu_notifier_invalidate_page() to after
> > > dropping the page table lock.
> > > 
> > > Adding start/end might the solution with less code churn as you would
> > > only need to change try_to_unmap_one().
> > 
> > What about dependencies? 369ea8242c0fb sounds like it needs work for all
> > notifiers need to be updated as well.
> 
> This commit remove mmu_notifier_invalidate_page() hence why everything
> need to be updated. But in 4.4 you can get away with just adding start/
> end and keep around mmu_notifier_invalidate_page() to minimize disruption.

OK, this is really interesting. I was really worried to change the
semantic of the mmu notifiers in stable kernels because this is really
a hard to review change and high risk for anybody running those old
kernels. If we can keep the mmu_notifier_invalidate_page and wrap them
into the range scope API then this sounds like the best way forward.

So just to make sure we are at the same page. Does this sounds goo for
stable 4.4. backport? Mike's hugetlb pmd shared fixup can be applied on
top. What do you think?


>From 70a2285b058073eeb2971b94b7e6c8067d2d161a Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Date: Thu, 31 Aug 2017 17:17:27 -0400
Subject: [PATCH] mm/rmap: update to new mmu_notifier semantic v2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit 369ea8242c0fb5239b4ddf0dc568f694bd244de4 upstrea.

Please note that this patch differs from the mainline because we do not
really replace mmu_notifier_invalidate_page by mmu_notifier_invalidate_range
because that requires changes to most of existing mmu notifiers. We also
do not want to change the semantic of this API in old kernels. Anyway
Jerome has suggested that it should be sufficient to simply wrap
mmu_notifier_invalidate_page by *_invalidate_range_start()/end() to fix
invalidation of larger than pte mappings (e.g. THP/hugetlb pages during
migration). We need this change to handle large (hugetlb/THP) pages
migration properly.

Note that because we can not presume the pmd value or pte value we have
to assume the worst and unconditionaly report an invalidation as
happening.

Changed since v2:
  - try_to_unmap_one() only one call to mmu_notifier_invalidate_range()
  - compute end with PAGE_SIZE << compound_order(page)
  - fix PageHuge() case in try_to_unmap_one()

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Bernhard Held <berny156@gmx.de>
Cc: Adam Borowski <kilobyte@angband.pl>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Wanpeng Li <kernellwp@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: axie <axie@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Michal Hocko <mhocko@suse.com> # backport to 4.4
---
 mm/rmap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1bceb49aa214..364d245e6411 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1324,6 +1324,7 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	pte_t pteval;
 	spinlock_t *ptl;
 	int ret = SWAP_AGAIN;
+	unsigned long start = address, end;
 	enum ttu_flags flags = (enum ttu_flags)arg;
 
 	/* munlock has nothing to gain from examining un-locked vmas */
@@ -1356,6 +1357,14 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		}
   	}
 
+	/*
+	 * We have to assume the worse case ie pmd for invalidation. Note that
+	 * the page can not be free in this function as call of try_to_unmap()
+	 * must hold a reference on the page.
+	 */
+	end = min(vma->vm_end, start + (PAGE_SIZE << compound_order(page)));
+	mmu_notifier_invalidate_range_start(vma->vm_mm, start, end);
+
 	/* Nuke the page table entry. */
 	flush_cache_page(vma, address, page_to_pfn(page));
 	if (should_defer_flush(mm, flags)) {
@@ -1449,6 +1458,7 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	pte_unmap_unlock(pte, ptl);
 	if (ret != SWAP_FAIL && ret != SWAP_MLOCK && !(flags & TTU_MUNLOCK))
 		mmu_notifier_invalidate_page(mm, address);
+	mmu_notifier_invalidate_range_end(vma->vm_mm, start, end);
 out:
 	return ret;
 }
-- 
2.18.0

-- 
Michal Hocko
SUSE Labs

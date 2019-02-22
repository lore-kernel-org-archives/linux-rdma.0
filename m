From: Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [PATCH v5 6/9] mm/mmu_notifier: use correct mmu_notifier events
 for each invalidation
Date: Fri, 22 Feb 2019 14:07:05 -0800
Message-ID: <a4c95ffc-e5e8-a4e9-77e2-9d8ae8f7ff79@nvidia.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
 <20190219200430.11130-7-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219200430.11130-7-jglisse@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-rdma@vger.kernel.org


On 2/19/19 12:04 PM, jglisse@redhat.com wrote:
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>=20
> This update each existing invalidation to use the correct mmu notifier
> event that represent what is happening to the CPU page table. See the
> patch which introduced the events to see the rational behind this.
>=20
> Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Ross Zwisler <zwisler@kernel.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: kvm@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-rdma@vger.kernel.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>   fs/proc/task_mmu.c      |  4 ++--
>   kernel/events/uprobes.c |  2 +-
>   mm/huge_memory.c        | 14 ++++++--------
>   mm/hugetlb.c            |  8 ++++----
>   mm/khugepaged.c         |  2 +-
>   mm/ksm.c                |  4 ++--
>   mm/madvise.c            |  2 +-
>   mm/memory.c             | 14 +++++++-------
>   mm/migrate.c            |  4 ++--
>   mm/mprotect.c           |  5 +++--
>   mm/rmap.c               |  6 +++---
>   11 files changed, 32 insertions(+), 33 deletions(-)
>=20
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index fcbd0e574917..3b93ce496dd4 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1151,8 +1151,8 @@ static ssize_t clear_refs_write(struct file *file, =
const char __user *buf,
>   				break;
>   			}
>  =20
> -			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
> -						NULL, mm, 0, -1UL);
> +			mmu_notifier_range_init(&range, MMU_NOTIFY_SOFT_DIRTY,
> +						0, NULL, mm, 0, -1UL);
>   			mmu_notifier_invalidate_range_start(&range);
>   		}
>   		walk_page_range(0, mm->highest_vm_end, &clear_refs_walk);
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 46f546bdba00..8e8342080013 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -161,7 +161,7 @@ static int __replace_page(struct vm_area_struct *vma,=
 unsigned long addr,
>   	struct mmu_notifier_range range;
>   	struct mem_cgroup *memcg;
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, addr,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, addr,
>   				addr + PAGE_SIZE);
>  =20
>   	VM_BUG_ON_PAGE(PageTransHuge(old_page), old_page);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c9d638f1b34e..1da6ca0f0f6d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1184,9 +1184,8 @@ static vm_fault_t do_huge_pmd_wp_page_fallback(stru=
ct vm_fault *vmf,
>   		cond_resched();
>   	}
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> -				haddr,
> -				haddr + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> +				haddr, haddr + HPAGE_PMD_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
>  =20
>   	vmf->ptl =3D pmd_lock(vma->vm_mm, vmf->pmd);
> @@ -1349,9 +1348,8 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf=
, pmd_t orig_pmd)
>   				    vma, HPAGE_PMD_NR);
>   	__SetPageUptodate(new_page);
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> -				haddr,
> -				haddr + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> +				haddr, haddr + HPAGE_PMD_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
>  =20
>   	spin_lock(vmf->ptl);
> @@ -2028,7 +2026,7 @@ void __split_huge_pud(struct vm_area_struct *vma, p=
ud_t *pud,
>   	spinlock_t *ptl;
>   	struct mmu_notifier_range range;
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
>   				address & HPAGE_PUD_MASK,
>   				(address & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
> @@ -2247,7 +2245,7 @@ void __split_huge_pmd(struct vm_area_struct *vma, p=
md_t *pmd,
>   	spinlock_t *ptl;
>   	struct mmu_notifier_range range;
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
>   				address & HPAGE_PMD_MASK,
>   				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d9e5c5a4c004..a58115c6b0a3 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3250,7 +3250,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, =
struct mm_struct *src,
>   	cow =3D (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) =3D=3D VM_MAYWRITE=
;
>  =20
>   	if (cow) {
> -		mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, src,
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, src,
>   					vma->vm_start,
>   					vma->vm_end);
>   		mmu_notifier_invalidate_range_start(&range);
> @@ -3631,7 +3631,7 @@ static vm_fault_t hugetlb_cow(struct mm_struct *mm,=
 struct vm_area_struct *vma,
>   			    pages_per_huge_page(h));
>   	__SetPageUptodate(new_page);
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, haddr,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, haddr,
>   				haddr + huge_page_size(h));
>   	mmu_notifier_invalidate_range_start(&range);
>  =20
> @@ -4357,8 +4357,8 @@ unsigned long hugetlb_change_protection(struct vm_a=
rea_struct *vma,
>   	 * start/end.  Set range.start/range.end to cover the maximum possible
>   	 * range if PMD sharing is possible.
>   	 */
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
> -				end);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA,
> +				0, vma, mm, start, end);
>   	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
>  =20
>   	BUG_ON(address >=3D end);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e7944f5e6258..579699d2b347 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1016,7 +1016,7 @@ static void collapse_huge_page(struct mm_struct *mm=
,
>   	pte =3D pte_offset_map(pmd, address);
>   	pte_ptl =3D pte_lockptr(mm, pmd);
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, NULL, mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm,

The vma is revalidated so you can s/NULL/vma here.

>   				address, address + HPAGE_PMD_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
>   	pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2ea25fc0befb..b782fadade8f 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1066,7 +1066,7 @@ static int write_protect_page(struct vm_area_struct=
 *vma, struct page *page,
>  =20
>   	BUG_ON(PageTransCompound(page));
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
>   				pvmw.address,
>   				pvmw.address + PAGE_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
> @@ -1155,7 +1155,7 @@ static int replace_page(struct vm_area_struct *vma,=
 struct page *page,
>   	if (!pmd)
>   		goto out;
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, addr,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, addr,
>   				addr + PAGE_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
>  =20
> diff --git a/mm/madvise.c b/mm/madvise.c
> index c617f53a9c09..a692d2a893b5 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -472,7 +472,7 @@ static int madvise_free_single_vma(struct vm_area_str=
uct *vma,
>   	range.end =3D min(vma->vm_end, end_addr);
>   	if (range.end <=3D vma->vm_start)
>   		return -EINVAL;
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
>   				range.start, range.end);
>  =20
>   	lru_add_drain();
> diff --git a/mm/memory.c b/mm/memory.c
> index 4565f636cca3..45dbc174a88c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1010,8 +1010,8 @@ int copy_page_range(struct mm_struct *dst_mm, struc=
t mm_struct *src_mm,
>   	is_cow =3D is_cow_mapping(vma->vm_flags);
>  =20
>   	if (is_cow) {
> -		mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma,
> -					src_mm, addr, end);
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
> +					0, vma, src_mm, addr, end);
>   		mmu_notifier_invalidate_range_start(&range);
>   	}
>  =20
> @@ -1358,7 +1358,7 @@ void zap_page_range(struct vm_area_struct *vma, uns=
igned long start,
>   	struct mmu_gather tlb;
>  =20
>   	lru_add_drain();
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
>   				start, start + size);
>   	tlb_gather_mmu(&tlb, vma->vm_mm, start, range.end);
>   	update_hiwater_rss(vma->vm_mm);
> @@ -1385,7 +1385,7 @@ static void zap_page_range_single(struct vm_area_st=
ruct *vma, unsigned long addr
>   	struct mmu_gather tlb;
>  =20
>   	lru_add_drain();
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
>   				address, address + size);
>   	tlb_gather_mmu(&tlb, vma->vm_mm, address, range.end);
>   	update_hiwater_rss(vma->vm_mm);
> @@ -2282,7 +2282,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf=
)
>  =20
>   	__SetPageUptodate(new_page);
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
>   				vmf->address & PAGE_MASK,
>   				(vmf->address & PAGE_MASK) + PAGE_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
> @@ -4105,7 +4105,7 @@ static int __follow_pte_pmd(struct mm_struct *mm, u=
nsigned long address,
>   			goto out;
>  =20
>   		if (range) {
> -			mmu_notifier_range_init(range, MMU_NOTIFY_UNMAP, 0,
> +			mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0,
>   						NULL, mm, address & PMD_MASK,
>   						(address & PMD_MASK) + PMD_SIZE);
>   			mmu_notifier_invalidate_range_start(range);
> @@ -4124,7 +4124,7 @@ static int __follow_pte_pmd(struct mm_struct *mm, u=
nsigned long address,
>   		goto out;
>  =20
>   	if (range) {
> -		mmu_notifier_range_init(range, MMU_NOTIFY_UNMAP, 0, NULL, mm,
> +		mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
>   					address & PAGE_MASK,
>   					(address & PAGE_MASK) + PAGE_SIZE);
>   		mmu_notifier_invalidate_range_start(range);
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 81eb307b2b5b..8e6d00541b3c 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2340,7 +2340,7 @@ static void migrate_vma_collect(struct migrate_vma =
*migrate)
>   	mm_walk.mm =3D migrate->vma->vm_mm;
>   	mm_walk.private =3D migrate;
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, NULL, mm_walk.mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm_walk.mm,

You can s/NULL/mm_walk.vma here.

>   				migrate->start,
>   				migrate->end);
>   	mmu_notifier_invalidate_range_start(&range);
> @@ -2749,7 +2749,7 @@ static void migrate_vma_pages(struct migrate_vma *m=
igrate)
>   				notified =3D true;
>  =20
>   				mmu_notifier_range_init(&range,
> -							MMU_NOTIFY_UNMAP, 0,
> +							MMU_NOTIFY_CLEAR, 0,
>   							NULL,

You can s/NULL/migrate->vma here.

>   							migrate->vma->vm_mm,
>   							addr, migrate->end);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index b10984052ae9..65242f1e4457 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -185,8 +185,9 @@ static inline unsigned long change_pmd_range(struct v=
m_area_struct *vma,
>  =20
>   		/* invoke the mmu notifier if the pmd is populated */
>   		if (!range.start) {
> -			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
> -						vma, vma->vm_mm, addr, end);
> +			mmu_notifier_range_init(&range,
> +				MMU_NOTIFY_PROTECTION_VMA, 0,
> +				vma, vma->vm_mm, addr, end);
>   			mmu_notifier_invalidate_range_start(&range);
>   		}
>  =20

The call to mmu_notifier_range_init(MMU_NOTIFY_UNMAP) in mm/remap.c
move_page_tables() should probably be
mmu_notifier_range_init(MMU_NOTIFY_CLEAR) since
do_munmap() is called a bit later in move_vma().

> diff --git a/mm/rmap.c b/mm/rmap.c
> index c6535a6ec850..627b38ad5052 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -896,8 +896,8 @@ static bool page_mkclean_one(struct page *page, struc=
t vm_area_struct *vma,
>   	 * We have to assume the worse case ie pmd for invalidation. Note that
>   	 * the page can not be free from this function.
>   	 */
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> -				address,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
> +				0, vma, vma->vm_mm, address,
>   				min(vma->vm_end, address +
>   				    (PAGE_SIZE << compound_order(page))));
>   	mmu_notifier_invalidate_range_start(&range);
> @@ -1372,7 +1372,7 @@ static bool try_to_unmap_one(struct page *page, str=
uct vm_area_struct *vma,
>   	 * Note that the page can not be free in this function as call of
>   	 * try_to_unmap() must hold a reference on the page.
>   	 */
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
>   				address,
>   				min(vma->vm_end, address +
>   				    (PAGE_SIZE << compound_order(page))));
>=20

Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

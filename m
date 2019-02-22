From: Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [PATCH v5 9/9] mm/mmu_notifier: set MMU_NOTIFIER_USE_CHANGE_PTE
 flag where appropriate v2
Date: Fri, 22 Feb 2019 15:01:16 -0800
Message-ID: <af766eb9-c8a4-a8f7-6aad-f56845d514ce@nvidia.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
 <20190219200430.11130-10-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219200430.11130-10-jglisse@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-rdma@vger.kernel.org


On 2/19/19 12:04 PM, jglisse@redhat.com wrote:
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>=20
> When notifying change for a range use MMU_NOTIFIER_USE_CHANGE_PTE flag
> for page table update that use set_pte_at_notify() and where the we are
> going either from read and write to read only with same pfn or read only
> to read and write with new pfn.
>=20
> Note that set_pte_at_notify() itself should only be use in rare cases
> ie we do not want to use it when we are updating a significant range of
> virtual addresses and thus a significant number of pte. Instead for
> those cases the event provided to mmu notifer invalidate_range_start()
> callback should be use for optimization.
>=20
> Changes since v1:
>      - Use the new unsigned flags field in struct mmu_notifier_range
>      - Use the new flags parameter to mmu_notifier_range_init()
>      - Explicitly list all the patterns where we can use change_pte()
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
>   include/linux/mmu_notifier.h | 34 ++++++++++++++++++++++++++++++++--
>   mm/ksm.c                     | 11 ++++++-----
>   mm/memory.c                  |  5 +++--
>   3 files changed, 41 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index b6c004bd9f6a..0230a4b06b46 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -40,6 +40,26 @@ enum mmu_notifier_event {
>   	MMU_NOTIFY_SOFT_DIRTY,
>   };
>  =20
> +/*
> + * @MMU_NOTIFIER_RANGE_BLOCKABLE: can the mmu notifier range_start/range=
_end
> + * callback block or not ? If set then the callback can block.
> + *
> + * @MMU_NOTIFIER_USE_CHANGE_PTE: only set when the page table it updated=
 with
> + * the set_pte_at_notify() the valid patterns for this are:
> + *      - pte read and write to read only same pfn
> + *      - pte read only to read and write (pfn can change or stay the sa=
me)
> + *      - pte read only to read only with different pfn
> + * It is illegal to set in any other circumstances.
> + *
> + * Note that set_pte_at_notify() should not be use outside of the above =
cases.
> + * When updating a range in batch (like write protecting a range) it is =
better
> + * to rely on invalidate_range_start() and struct mmu_notifier_range to =
infer
> + * the kind of update that is happening (as an example you can look at t=
he
> + * mmu_notifier_range_update_to_read_only() function).
> + */
> +#define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
> +#define MMU_NOTIFIER_USE_CHANGE_PTE (1 << 1)
> +
>   #ifdef CONFIG_MMU_NOTIFIER
>  =20
>   /*
> @@ -55,8 +75,6 @@ struct mmu_notifier_mm {
>   	spinlock_t lock;
>   };
>  =20
> -#define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
> -
>   struct mmu_notifier_range {
>   	struct vm_area_struct *vma;
>   	struct mm_struct *mm;
> @@ -268,6 +286,12 @@ mmu_notifier_range_blockable(const struct mmu_notifi=
er_range *range)
>   	return (range->flags & MMU_NOTIFIER_RANGE_BLOCKABLE);
>   }
>  =20
> +static inline bool
> +mmu_notifier_range_use_change_pte(const struct mmu_notifier_range *range=
)
> +{
> +	return (range->flags & MMU_NOTIFIER_USE_CHANGE_PTE);
> +}
> +
>   static inline void mmu_notifier_release(struct mm_struct *mm)
>   {
>   	if (mm_has_notifiers(mm))
> @@ -509,6 +533,12 @@ mmu_notifier_range_blockable(const struct mmu_notifi=
er_range *range)
>   	return true;
>   }
>  =20
> +static inline bool
> +mmu_notifier_range_use_change_pte(const struct mmu_notifier_range *range=
)
> +{
> +	return false;
> +}
> +
>   static inline int mm_has_notifiers(struct mm_struct *mm)
>   {
>   	return 0;
> diff --git a/mm/ksm.c b/mm/ksm.c
> index b782fadade8f..41e51882f999 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1066,9 +1066,9 @@ static int write_protect_page(struct vm_area_struct=
 *vma, struct page *page,
>  =20
>   	BUG_ON(PageTransCompound(page));
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
> -				pvmw.address,
> -				pvmw.address + PAGE_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR,
> +				MMU_NOTIFIER_USE_CHANGE_PTE, vma, mm,
> +				pvmw.address, pvmw.address + PAGE_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
>  =20
>   	if (!page_vma_mapped_walk(&pvmw))
> @@ -1155,8 +1155,9 @@ static int replace_page(struct vm_area_struct *vma,=
 struct page *page,
>   	if (!pmd)
>   		goto out;
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, addr,
> -				addr + PAGE_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR,
> +				MMU_NOTIFIER_USE_CHANGE_PTE,
> +				vma, mm, addr, addr + PAGE_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
>  =20
>   	ptep =3D pte_offset_map_lock(mm, pmd, addr, &ptl);
> diff --git a/mm/memory.c b/mm/memory.c
> index 45dbc174a88c..cb71d3ff1b97 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2282,8 +2282,9 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf=
)
>  =20
>   	__SetPageUptodate(new_page);
>  =20
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
> -				vmf->address & PAGE_MASK,
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR,
> +				MMU_NOTIFIER_USE_CHANGE_PTE,
> +				vma, mm, vmf->address & PAGE_MASK,
>   				(vmf->address & PAGE_MASK) + PAGE_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
>  =20
>=20

Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

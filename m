From: Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [PATCH v5 8/9] mm/mmu_notifier:
 mmu_notifier_range_update_to_read_only() helper
Date: Fri, 22 Feb 2019 14:42:08 -0800
Message-ID: <9da5e3b9-7f4a-49ee-bf80-024e5aed20a1@nvidia.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
 <20190219200430.11130-9-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219200430.11130-9-jglisse@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-rdma@vger.kernel.org


On 2/19/19 12:04 PM, jglisse@redhat.com wrote:
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>=20
> Helper to test if a range is updated to read only (it is still valid
> to read from the range). This is useful for device driver or anyone
> who wish to optimize out update when they know that they already have
> the range map read only.
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
>   include/linux/mmu_notifier.h |  4 ++++
>   mm/mmu_notifier.c            | 10 ++++++++++
>   2 files changed, 14 insertions(+)
>=20
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 0379956fff23..b6c004bd9f6a 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -259,6 +259,8 @@ extern void __mmu_notifier_invalidate_range_end(struc=
t mmu_notifier_range *r,
>   				  bool only_end);
>   extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
>   				  unsigned long start, unsigned long end);
> +extern bool
> +mmu_notifier_range_update_to_read_only(const struct mmu_notifier_range *=
range);
>  =20
>   static inline bool
>   mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
> @@ -568,6 +570,8 @@ static inline void mmu_notifier_mm_destroy(struct mm_=
struct *mm)
>   {
>   }
>  =20
> +#define mmu_notifier_range_update_to_read_only(r) false
> +
>   #define ptep_clear_flush_young_notify ptep_clear_flush_young
>   #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>   #define ptep_clear_young_notify ptep_test_and_clear_young
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index abd88c466eb2..ee36068077b6 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -395,3 +395,13 @@ void mmu_notifier_unregister_no_release(struct mmu_n=
otifier *mn,
>   	mmdrop(mm);
>   }
>   EXPORT_SYMBOL_GPL(mmu_notifier_unregister_no_release);
> +
> +bool
> +mmu_notifier_range_update_to_read_only(const struct mmu_notifier_range *=
range)
> +{
> +	if (!range->vma || range->event !=3D MMU_NOTIFY_PROTECTION_VMA)
> +		return false;
> +	/* Return true if the vma still have the read flag set. */
> +	return range->vma->vm_flags & VM_READ;
> +}
> +EXPORT_SYMBOL_GPL(mmu_notifier_range_update_to_read_only);
>=20

Don't you have to check for !WRITE & READ?
mprotect() can change the permissions from R/O to RW and
end up calling mmu_notifier_range_init() and=20
mmu_notifier_invalidate_range_start()/end().

I'm not sure how useful this is since only applies to the
MMU_NOTIFY_PROTECTION_VMA case.
Anyway, you can add

Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

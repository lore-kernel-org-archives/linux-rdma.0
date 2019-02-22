From: Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [PATCH v5 4/9] mm/mmu_notifier: contextual information for event
 enums
Date: Fri, 22 Feb 2019 11:26:09 -0800
Message-ID: <49d6489c-31b4-511b-2504-bc7aa5d44673@nvidia.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
 <20190219200430.11130-5-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219200430.11130-5-jglisse@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-rdma@vger.kernel.org


On 2/19/19 12:04 PM, jglisse@redhat.com wrote:
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>=20
> CPU page table update can happens for many reasons, not only as a result

s/update/updates
s/happens/happen

> of a syscall (munmap(), mprotect(), mremap(), madvise(), ...) but also
> as a result of kernel activities (memory compression, reclaim, migration,
> ...).
>=20
> This patch introduce a set of enums that can be associated with each of

s/introduce/introduces

> the events triggering a mmu notifier. Latter patches take advantages of
> those enum values.

s/advantages/advantage

>=20
>      - UNMAP: munmap() or mremap()
>      - CLEAR: page table is cleared (migration, compaction, reclaim, ...)
>      - PROTECTION_VMA: change in access protections for the range
>      - PROTECTION_PAGE: change in access protections for page in the rang=
e
>      - SOFT_DIRTY: soft dirtyness tracking
>=20

s/dirtyness/dirtiness

> Being able to identify munmap() and mremap() from other reasons why the
> page table is cleared is important to allow user of mmu notifier to
> update their own internal tracking structure accordingly (on munmap or
> mremap it is not longer needed to track range of virtual address as it
> becomes invalid).
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
>   include/linux/mmu_notifier.h | 30 ++++++++++++++++++++++++++++++
>   1 file changed, 30 insertions(+)
>=20
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index c8672c366f67..2386e71ac1b8 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -10,6 +10,36 @@
>   struct mmu_notifier;
>   struct mmu_notifier_ops;
>  =20
> +/**
> + * enum mmu_notifier_event - reason for the mmu notifier callback
> + * @MMU_NOTIFY_UNMAP: either munmap() that unmap the range or a mremap()=
 that
> + * move the range

I would say something about the VMA for the notifier range
is being deleted.
MMU notifier clients can then use this case to remove any policy or
access counts associated with the range.
Just changing the PTE to "no access" as in the CLEAR case
doesn't mean a policy which prefers device private memory
over system memory should be cleared.

> + *
> + * @MMU_NOTIFY_CLEAR: clear page table entry (many reasons for this like
> + * madvise() or replacing a page by another one, ...).
> + *
> + * @MMU_NOTIFY_PROTECTION_VMA: update is due to protection change for th=
e range
> + * ie using the vma access permission (vm_page_prot) to update the whole=
 range
> + * is enough no need to inspect changes to the CPU page table (mprotect(=
)
> + * syscall)
> + *
> + * @MMU_NOTIFY_PROTECTION_PAGE: update is due to change in read/write fl=
ag for
> + * pages in the range so to mirror those changes the user must inspect t=
he CPU
> + * page table (from the end callback).
> + *
> + * @MMU_NOTIFY_SOFT_DIRTY: soft dirty accounting (still same page and sa=
me
> + * access flags). User should soft dirty the page in the end callback to=
 make
> + * sure that anyone relying on soft dirtyness catch pages that might be =
written
> + * through non CPU mappings.
> + */
> +enum mmu_notifier_event {
> +	MMU_NOTIFY_UNMAP =3D 0,
> +	MMU_NOTIFY_CLEAR,
> +	MMU_NOTIFY_PROTECTION_VMA,
> +	MMU_NOTIFY_PROTECTION_PAGE,
> +	MMU_NOTIFY_SOFT_DIRTY,
> +};
> +
>   #ifdef CONFIG_MMU_NOTIFIER
>  =20
>   /*
>=20

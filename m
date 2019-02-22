From: Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [PATCH v5 5/9] mm/mmu_notifier: contextual information for event
 triggering invalidation v2
Date: Fri, 22 Feb 2019 13:25:03 -0800
Message-ID: <ff09d22f-8eb8-ea19-0a65-7f5b38928cea@nvidia.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
 <20190219200430.11130-6-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219200430.11130-6-jglisse@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-rdma@vger.kernel.org


On 2/19/19 12:04 PM, jglisse@redhat.com wrote:
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>=20
> CPU page table update can happens for many reasons, not only as a result
> of a syscall (munmap(), mprotect(), mremap(), madvise(), ...) but also
> as a result of kernel activities (memory compression, reclaim, migration,
> ...).
>=20
> Users of mmu notifier API track changes to the CPU page table and take
> specific action for them. While current API only provide range of virtual
> address affected by the change, not why the changes is happening.
>=20
> This patchset do the initial mechanical convertion of all the places that
> calls mmu_notifier_range_init to also provide the default MMU_NOTIFY_UNMA=
P
> event as well as the vma if it is know (most invalidation happens against
> a given vma). Passing down the vma allows the users of mmu notifier to
> inspect the new vma page protection.
>=20
> The MMU_NOTIFY_UNMAP is always the safe default as users of mmu notifier
> should assume that every for the range is going away when that event
> happens. A latter patch do convert mm call path to use a more appropriate
> events for each call.
>=20
> Changes since v1:
>      - add the flags parameter to init range flags
>=20
> This is done as 2 patches so that no call site is forgotten especialy
> as it uses this following coccinelle patch:
>=20
> %<----------------------------------------------------------------------
> @@
> identifier I1, I2, I3, I4;
> @@
> static inline void mmu_notifier_range_init(struct mmu_notifier_range *I1,
> +enum mmu_notifier_event event,
> +unsigned flags,
> +struct vm_area_struct *vma,
> struct mm_struct *I2, unsigned long I3, unsigned long I4) { ... }
>=20
> @@
> @@
> -#define mmu_notifier_range_init(range, mm, start, end)
> +#define mmu_notifier_range_init(range, event, flags, vma, mm, start, end=
)
>=20
> @@
> expression E1, E3, E4;
> identifier I1;
> @@
> <...
> mmu_notifier_range_init(E1,
> +MMU_NOTIFY_UNMAP, 0, I1,
> I1->vm_mm, E3, E4)
> ...>
>=20
> @@
> expression E1, E2, E3, E4;
> identifier FN, VMA;
> @@
> FN(..., struct vm_area_struct *VMA, ...) {
> <...
> mmu_notifier_range_init(E1,
> +MMU_NOTIFY_UNMAP, 0, VMA,
> E2, E3, E4)
> ...> }
>=20
> @@
> expression E1, E2, E3, E4;
> identifier FN, VMA;
> @@
> FN(...) {
> struct vm_area_struct *VMA;
> <...
> mmu_notifier_range_init(E1,
> +MMU_NOTIFY_UNMAP, 0, VMA,
> E2, E3, E4)
> ...> }
>=20
> @@
> expression E1, E2, E3, E4;
> identifier FN;
> @@
> FN(...) {
> <...
> mmu_notifier_range_init(E1,
> +MMU_NOTIFY_UNMAP, 0, NULL,
> E2, E3, E4)
> ...> }
> ---------------------------------------------------------------------->%
>=20
> Applied with:
> spatch --all-includes --sp-file mmu-notifier.spatch fs/proc/task_mmu.c --=
in-place
> spatch --sp-file mmu-notifier.spatch --dir kernel/events/ --in-place
> spatch --sp-file mmu-notifier.spatch --dir mm --in-place
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

Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

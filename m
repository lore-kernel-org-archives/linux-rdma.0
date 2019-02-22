From: Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [PATCH v5 1/9] mm/mmu_notifier: helper to test if a range
 invalidation is blockable
Date: Fri, 22 Feb 2019 11:01:01 -0800
Message-ID: <db289f99-3b47-1af6-cbfb-a15155c382c6@nvidia.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
 <20190219200430.11130-2-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219200430.11130-2-jglisse@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, Arnd
List-Id: linux-rdma@vger.kernel.org


On 2/19/19 12:04 PM, jglisse@redhat.com wrote:
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>=20
> Simple helpers to test if range invalidation is blockable. Latter
> patches use cocinnelle to convert all direct dereference of range->
> blockable to use this function instead so that we can convert the
> blockable field to an unsigned for more flags.
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
> Cc: Andrew Morton <akpm@linux-foundation.org>
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
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>   include/linux/mmu_notifier.h | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>=20
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 4050ec1c3b45..e630def131ce 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -226,6 +226,12 @@ extern void __mmu_notifier_invalidate_range_end(stru=
ct mmu_notifier_range *r,
>   extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
>   				  unsigned long start, unsigned long end);
>  =20
> +static inline bool
> +mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
> +{
> +	return range->blockable;
> +}
> +
>   static inline void mmu_notifier_release(struct mm_struct *mm)
>   {
>   	if (mm_has_notifiers(mm))
> @@ -455,6 +461,11 @@ static inline void _mmu_notifier_range_init(struct m=
mu_notifier_range *range,
>   #define mmu_notifier_range_init(range, mm, start, end) \
>   	_mmu_notifier_range_init(range, start, end)
>  =20
> +static inline bool
> +mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
> +{
> +	return true;
> +}
>  =20
>   static inline int mm_has_notifiers(struct mm_struct *mm)
>   {

Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

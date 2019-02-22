From: Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [PATCH v5 2/9] mm/mmu_notifier: convert user range->blockable to
 helper function
Date: Fri, 22 Feb 2019 11:02:13 -0800
Message-ID: <f09609c2-79f0-4b15-9eaa-23982c039e1a@nvidia.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
 <20190219200430.11130-3-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219200430.11130-3-jglisse@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-rdma@vger.kernel.org


On 2/19/19 12:04 PM, jglisse@redhat.com wrote:
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>=20
> Use the mmu_notifier_range_blockable() helper function instead of
> directly dereferencing the range->blockable field. This is done to
> make it easier to change the mmu_notifier range field.
>=20
> This patch is the outcome of the following coccinelle patch:
>=20
> %<-------------------------------------------------------------------
> @@
> identifier I1, FN;
> @@
> FN(..., struct mmu_notifier_range *I1, ...) {
> <...
> -I1->blockable
> +mmu_notifier_range_blockable(I1)
> ...>
> }
> ------------------------------------------------------------------->%
>=20
> spatch --in-place --sp-file blockable.spatch --dir .
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
>   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c  | 8 ++++----
>   drivers/gpu/drm/i915/i915_gem_userptr.c | 2 +-
>   drivers/gpu/drm/radeon/radeon_mn.c      | 4 ++--
>   drivers/infiniband/core/umem_odp.c      | 5 +++--
>   drivers/xen/gntdev.c                    | 6 +++---
>   mm/hmm.c                                | 6 +++---
>   mm/mmu_notifier.c                       | 2 +-
>   virt/kvm/kvm_main.c                     | 3 ++-
>   8 files changed, 19 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c b/drivers/gpu/drm/amd=
/amdgpu/amdgpu_mn.c
> index 3e6823fdd939..58ed401c5996 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
> @@ -256,14 +256,14 @@ static int amdgpu_mn_invalidate_range_start_gfx(str=
uct mmu_notifier *mn,
>   	/* TODO we should be able to split locking for interval tree and
>   	 * amdgpu_mn_invalidate_node
>   	 */
> -	if (amdgpu_mn_read_lock(amn, range->blockable))
> +	if (amdgpu_mn_read_lock(amn, mmu_notifier_range_blockable(range)))
>   		return -EAGAIN;
>  =20
>   	it =3D interval_tree_iter_first(&amn->objects, range->start, end);
>   	while (it) {
>   		struct amdgpu_mn_node *node;
>  =20
> -		if (!range->blockable) {
> +		if (!mmu_notifier_range_blockable(range)) {
>   			amdgpu_mn_read_unlock(amn);
>   			return -EAGAIN;
>   		}
> @@ -299,7 +299,7 @@ static int amdgpu_mn_invalidate_range_start_hsa(struc=
t mmu_notifier *mn,
>   	/* notification is exclusive, but interval is inclusive */
>   	end =3D range->end - 1;
>  =20
> -	if (amdgpu_mn_read_lock(amn, range->blockable))
> +	if (amdgpu_mn_read_lock(amn, mmu_notifier_range_blockable(range)))
>   		return -EAGAIN;
>  =20
>   	it =3D interval_tree_iter_first(&amn->objects, range->start, end);
> @@ -307,7 +307,7 @@ static int amdgpu_mn_invalidate_range_start_hsa(struc=
t mmu_notifier *mn,
>   		struct amdgpu_mn_node *node;
>   		struct amdgpu_bo *bo;
>  =20
> -		if (!range->blockable) {
> +		if (!mmu_notifier_range_blockable(range)) {
>   			amdgpu_mn_read_unlock(amn);
>   			return -EAGAIN;
>   		}
> diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/drm/i9=
15/i915_gem_userptr.c
> index 1d3f9a31ad61..777b3f8727e7 100644
> --- a/drivers/gpu/drm/i915/i915_gem_userptr.c
> +++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
> @@ -122,7 +122,7 @@ userptr_mn_invalidate_range_start(struct mmu_notifier=
 *_mn,
>   	while (it) {
>   		struct drm_i915_gem_object *obj;
>  =20
> -		if (!range->blockable) {
> +		if (!mmu_notifier_range_blockable(range)) {
>   			ret =3D -EAGAIN;
>   			break;
>   		}
> diff --git a/drivers/gpu/drm/radeon/radeon_mn.c b/drivers/gpu/drm/radeon/=
radeon_mn.c
> index b3019505065a..c9bd1278f573 100644
> --- a/drivers/gpu/drm/radeon/radeon_mn.c
> +++ b/drivers/gpu/drm/radeon/radeon_mn.c
> @@ -133,7 +133,7 @@ static int radeon_mn_invalidate_range_start(struct mm=
u_notifier *mn,
>   	/* TODO we should be able to split locking for interval tree and
>   	 * the tear down.
>   	 */
> -	if (range->blockable)
> +	if (mmu_notifier_range_blockable(range))
>   		mutex_lock(&rmn->lock);
>   	else if (!mutex_trylock(&rmn->lock))
>   		return -EAGAIN;
> @@ -144,7 +144,7 @@ static int radeon_mn_invalidate_range_start(struct mm=
u_notifier *mn,
>   		struct radeon_bo *bo;
>   		long r;
>  =20
> -		if (!range->blockable) {
> +		if (!mmu_notifier_range_blockable(range)) {
>   			ret =3D -EAGAIN;
>   			goto out_unlock;
>   		}
> diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core=
/umem_odp.c
> index 012044f16d1c..3a3f1538d295 100644
> --- a/drivers/infiniband/core/umem_odp.c
> +++ b/drivers/infiniband/core/umem_odp.c
> @@ -151,7 +151,7 @@ static int ib_umem_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>   	struct ib_ucontext_per_mm *per_mm =3D
>   		container_of(mn, struct ib_ucontext_per_mm, mn);
>  =20
> -	if (range->blockable)
> +	if (mmu_notifier_range_blockable(range))
>   		down_read(&per_mm->umem_rwsem);
>   	else if (!down_read_trylock(&per_mm->umem_rwsem))
>   		return -EAGAIN;
> @@ -169,7 +169,8 @@ static int ib_umem_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>   	return rbt_ib_umem_for_each_in_range(&per_mm->umem_tree, range->start,
>   					     range->end,
>   					     invalidate_range_start_trampoline,
> -					     range->blockable, NULL);
> +					     mmu_notifier_range_blockable(range),
> +					     NULL);
>   }
>  =20
>   static int invalidate_range_end_trampoline(struct ib_umem_odp *item, u6=
4 start,
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index 5efc5eee9544..9da8f7192f46 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -526,20 +526,20 @@ static int mn_invl_range_start(struct mmu_notifier =
*mn,
>   	struct gntdev_grant_map *map;
>   	int ret =3D 0;
>  =20
> -	if (range->blockable)
> +	if (mmu_notifier_range_blockable(range))
>   		mutex_lock(&priv->lock);
>   	else if (!mutex_trylock(&priv->lock))
>   		return -EAGAIN;
>  =20
>   	list_for_each_entry(map, &priv->maps, next) {
>   		ret =3D unmap_if_in_range(map, range->start, range->end,
> -					range->blockable);
> +					mmu_notifier_range_blockable(range));
>   		if (ret)
>   			goto out_unlock;
>   	}
>   	list_for_each_entry(map, &priv->freeable_maps, next) {
>   		ret =3D unmap_if_in_range(map, range->start, range->end,
> -					range->blockable);
> +					mmu_notifier_range_blockable(range));
>   		if (ret)
>   			goto out_unlock;
>   	}
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 3c9781037918..a03b5083d880 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -205,9 +205,9 @@ static int hmm_invalidate_range_start(struct mmu_noti=
fier *mn,
>   	update.start =3D nrange->start;
>   	update.end =3D nrange->end;
>   	update.event =3D HMM_UPDATE_INVALIDATE;
> -	update.blockable =3D nrange->blockable;
> +	update.blockable =3D mmu_notifier_range_blockable(nrange);
>  =20
> -	if (nrange->blockable)
> +	if (mmu_notifier_range_blockable(nrange))
>   		mutex_lock(&hmm->lock);
>   	else if (!mutex_trylock(&hmm->lock)) {
>   		ret =3D -EAGAIN;
> @@ -222,7 +222,7 @@ static int hmm_invalidate_range_start(struct mmu_noti=
fier *mn,
>   	}
>   	mutex_unlock(&hmm->lock);
>  =20
> -	if (nrange->blockable)
> +	if (mmu_notifier_range_blockable(nrange))
>   		down_read(&hmm->mirrors_sem);
>   	else if (!down_read_trylock(&hmm->mirrors_sem)) {
>   		ret =3D -EAGAIN;
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index 9c884abc7850..abd88c466eb2 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -180,7 +180,7 @@ int __mmu_notifier_invalidate_range_start(struct mmu_=
notifier_range *range)
>   			if (_ret) {
>   				pr_info("%pS callback failed with %d in %sblockable context.\n",
>   					mn->ops->invalidate_range_start, _ret,
> -					!range->blockable ? "non-" : "");
> +					!mmu_notifier_range_blockable(range) ? "non-" : "");
>   				ret =3D _ret;
>   			}
>   		}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 38df17b7760e..629760c0fb95 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -386,7 +386,8 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>   	spin_unlock(&kvm->mmu_lock);
>  =20
>   	ret =3D kvm_arch_mmu_notifier_invalidate_range(kvm, range->start,
> -					range->end, range->blockable);
> +					range->end,
> +					mmu_notifier_range_blockable(range));
>  =20
>   	srcu_read_unlock(&kvm->srcu, idx);
>  =20
>=20

Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v2 1/3] mm/mmu_notifier: use structure for
 invalidate_range_start/end callback
Date: Wed, 5 Dec 2018 18:04:13 -0500
Message-ID: <20181205230413.GN3536@redhat.com>
References: <20181205053628.3210-1-jglisse@redhat.com>
 <20181205053628.3210-2-jglisse@redhat.com>
 <b76dfbdd-a017-4032-d8a1-860ff62dfb59@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b76dfbdd-a017-4032-d8a1-860ff62dfb59@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kuehling, Felix" <Felix.Kuehling@amd.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <zwisler@kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, "Koenig, Christian" <Christian.Koenig@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 05, 2018 at 09:42:45PM +0000, Kuehling, Felix wrote:
> The amdgpu part looks good to me.
> 
> A minor nit-pick in mmu_notifier.c (inline).
> 
> Either way, the series is Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> 
> On 2018-12-05 12:36 a.m., jglisse@redhat.com wrote:
> > From: Jérôme Glisse <jglisse@redhat.com>
> >
> > To avoid having to change many callback definition everytime we want
> > to add a parameter use a structure to group all parameters for the
> > mmu_notifier invalidate_range_start/end callback. No functional changes
> > with this patch.
> >
> > Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Matthew Wilcox <mawilcox@microsoft.com>
> > Cc: Ross Zwisler <zwisler@kernel.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Krčmář <rkrcmar@redhat.com>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Christian Koenig <christian.koenig@amd.com>
> > Cc: Felix Kuehling <felix.kuehling@amd.com>
> > Cc: Ralph Campbell <rcampbell@nvidia.com>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: kvm@vger.kernel.org
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linux-rdma@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > ---
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c  | 43 +++++++++++--------------
> >  drivers/gpu/drm/i915/i915_gem_userptr.c | 14 ++++----
> >  drivers/gpu/drm/radeon/radeon_mn.c      | 16 ++++-----
> >  drivers/infiniband/core/umem_odp.c      | 20 +++++-------
> >  drivers/infiniband/hw/hfi1/mmu_rb.c     | 13 +++-----
> >  drivers/misc/mic/scif/scif_dma.c        | 11 ++-----
> >  drivers/misc/sgi-gru/grutlbpurge.c      | 14 ++++----
> >  drivers/xen/gntdev.c                    | 12 +++----
> >  include/linux/mmu_notifier.h            | 14 +++++---
> >  mm/hmm.c                                | 23 ++++++-------
> >  mm/mmu_notifier.c                       | 21 ++++++++++--
> >  virt/kvm/kvm_main.c                     | 14 +++-----
> >  12 files changed, 102 insertions(+), 113 deletions(-)
> >
> [snip]
> > diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> > index 5119ff846769..5f6665ae3ee2 100644
> > --- a/mm/mmu_notifier.c
> > +++ b/mm/mmu_notifier.c
> > @@ -178,14 +178,20 @@ int __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
> >  				  unsigned long start, unsigned long end,
> >  				  bool blockable)
> >  {
> > +	struct mmu_notifier_range _range, *range = &_range;
> 
> I'm not sure why you need to access _range indirectly through a pointer.
> See below.
> 
> 
> >  	struct mmu_notifier *mn;
> >  	int ret = 0;
> >  	int id;
> >  
> > +	range->blockable = blockable;
> > +	range->start = start;
> > +	range->end = end;
> > +	range->mm = mm;
> 
> This could just assign _range.blockable, _range.start, etc. without the
> indirection. Or you could even use an initializer instead:
> 
> struct mmu_notifier_range range = {
>     .blockable = blockable,
>     .start = start,
>     ...
> };
> 
> 
> > +
> >  	id = srcu_read_lock(&srcu);
> >  	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
> >  		if (mn->ops->invalidate_range_start) {
> > -			int _ret = mn->ops->invalidate_range_start(mn, mm, start, end, blockable);
> > +			int _ret = mn->ops->invalidate_range_start(mn, range);
> 
> This could just use &_range without the indirection.
> 
> Same in ..._invalidate_range_end below.

So explaination is that this is a temporary step all this code is
remove in the second patch. It was done this way in this patch to
minimize the diff within the next patch.

I did this because i wanted to do the convertion in 2 steps the
first step i convert all the listener of mmu notifier and in the
second step i convert all the call site that trigger a mmu notifer.

I did that to help people reviewing only the part they care about.

Apparently it end up confusing people more than it helped :)

Do people have strong feeling about getting this code that is
deleted in the second patch fix in the first patch anyway ?

I can respin if so but i don't see much value in formating code
that is deleted in the serie.

Thank you for reviewing

Cheers,
Jérôme

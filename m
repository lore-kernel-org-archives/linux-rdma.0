From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v4 9/9] RDMA/umem_odp: optimize out the case when a range
 is updated to read only
Date: Wed, 23 Jan 2019 17:46:40 -0500
Message-ID: <20190123224640.GA1257@redhat.com>
References: <20190123222315.1122-1-jglisse@redhat.com>
 <20190123222315.1122-10-jglisse@redhat.com>
 <20190123223153.GP8986@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190123223153.GP8986@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Jan Kara <jack@suse.cz>, Felix Kuehling <Felix.Kuehling@amd.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 23, 2019 at 10:32:00PM +0000, Jason Gunthorpe wrote:
> On Wed, Jan 23, 2019 at 05:23:15PM -0500, jglisse@redhat.com wrote:
> > From: Jérôme Glisse <jglisse@redhat.com>
> > 
> > When range of virtual address is updated read only and corresponding
> > user ptr object are already read only it is pointless to do anything.
> > Optimize this case out.
> > 
> > Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> > Cc: Christian König <christian.koenig@amd.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> > Cc: Jason Gunthorpe <jgg@mellanox.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Matthew Wilcox <mawilcox@microsoft.com>
> > Cc: Ross Zwisler <zwisler@kernel.org>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Krčmář <rkrcmar@redhat.com>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Ralph Campbell <rcampbell@nvidia.com>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: kvm@vger.kernel.org
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linux-rdma@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: Arnd Bergmann <arnd@arndb.de>
> >  drivers/infiniband/core/umem_odp.c | 22 +++++++++++++++++++---
> >  include/rdma/ib_umem_odp.h         |  1 +
> >  2 files changed, 20 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
> > index a4ec43093cb3..fa4e7fdcabfc 100644
> > +++ b/drivers/infiniband/core/umem_odp.c
> > @@ -140,8 +140,15 @@ static void ib_umem_notifier_release(struct mmu_notifier *mn,
> >  static int invalidate_range_start_trampoline(struct ib_umem_odp *item,
> >  					     u64 start, u64 end, void *cookie)
> >  {
> > +	bool update_to_read_only = *((bool *)cookie);
> > +
> >  	ib_umem_notifier_start_account(item);
> > -	item->umem.context->invalidate_range(item, start, end);
> > +	/*
> > +	 * If it is already read only and we are updating to read only then we
> > +	 * do not need to change anything. So save time and skip this one.
> > +	 */
> > +	if (!update_to_read_only || !item->read_only)
> > +		item->umem.context->invalidate_range(item, start, end);
> >  	return 0;
> >  }
> >  
> > @@ -150,6 +157,7 @@ static int ib_umem_notifier_invalidate_range_start(struct mmu_notifier *mn,
> >  {
> >  	struct ib_ucontext_per_mm *per_mm =
> >  		container_of(mn, struct ib_ucontext_per_mm, mn);
> > +	bool update_to_read_only;
> >  
> >  	if (range->blockable)
> >  		down_read(&per_mm->umem_rwsem);
> > @@ -166,10 +174,13 @@ static int ib_umem_notifier_invalidate_range_start(struct mmu_notifier *mn,
> >  		return 0;
> >  	}
> >  
> > +	update_to_read_only = mmu_notifier_range_update_to_read_only(range);
> > +
> >  	return rbt_ib_umem_for_each_in_range(&per_mm->umem_tree, range->start,
> >  					     range->end,
> >  					     invalidate_range_start_trampoline,
> > -					     range->blockable, NULL);
> > +					     range->blockable,
> > +					     &update_to_read_only);
> >  }
> >  
> >  static int invalidate_range_end_trampoline(struct ib_umem_odp *item, u64 start,
> > @@ -363,6 +374,9 @@ struct ib_umem_odp *ib_alloc_odp_umem(struct ib_ucontext_per_mm *per_mm,
> >  		goto out_odp_data;
> >  	}
> >  
> > +	/* Assume read only at first, each time GUP is call this is updated. */
> > +	odp_data->read_only = true;
> > +
> >  	odp_data->dma_list =
> >  		vzalloc(array_size(pages, sizeof(*odp_data->dma_list)));
> >  	if (!odp_data->dma_list) {
> > @@ -619,8 +633,10 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
> >  		goto out_put_task;
> >  	}
> >  
> > -	if (access_mask & ODP_WRITE_ALLOWED_BIT)
> > +	if (access_mask & ODP_WRITE_ALLOWED_BIT) {
> > +		umem_odp->read_only = false;
> 
> No locking?

The mmu notitfier exclusion will ensure that it is not missed
ie it will be false before any mmu notifier might be call on
page GUPed with write flag which is what matter here. So lock
are useless here.

> 
> >  		flags |= FOLL_WRITE;
> > +	}
> >  
> >  	start_idx = (user_virt - ib_umem_start(umem)) >> page_shift;
> >  	k = start_idx;
> > diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
> > index 0b1446fe2fab..8256668c6170 100644
> > +++ b/include/rdma/ib_umem_odp.h
> > @@ -76,6 +76,7 @@ struct ib_umem_odp {
> >  	struct completion	notifier_completion;
> >  	int			dying;
> >  	struct work_struct	work;
> > +	bool read_only;
> >  };
> 
> The ib_umem already has a writeable flag. This reflects if the user
> asked for write permission to be granted.. The tracking here is if any
> remote fault thus far has requested write, is this an important
> difference to justify the new flag?

I did that patch couple week ago and now i do not remember why
i did not use that, i remember thinking about it ... damm i need
to keep better notes. I will review the code again.

Cheers,
Jérôme

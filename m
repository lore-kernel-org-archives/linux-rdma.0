From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v2 1/3] mm/mmu_notifier: use structure for
 invalidate_range_start/end callback
Date: Wed, 5 Dec 2018 11:40:52 -0500
Message-ID: <20181205164052.GE3536@redhat.com>
References: <20181205053628.3210-1-jglisse@redhat.com>
 <20181205053628.3210-2-jglisse@redhat.com>
 <20181205163520.GG30615@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181205163520.GG30615@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Christian Koenig <christian.koenig@amd.com>, Felix Kuehling <felix.kuehling@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 05, 2018 at 05:35:20PM +0100, Jan Kara wrote:
> On Wed 05-12-18 00:36:26, jglisse@redhat.com wrote:
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
> Why these games with two variables?

This is a temporary step i dediced to do the convertion in 2 steps,
first i convert the callback to use the structure so that people
having mmu notifier callback only have to review this patch and do
not get distracted by the second step which update all the mm call
site that trigger invalidation.

In the final result this code disappear. I did it that way to make
the thing more reviewable. Sorry if that is a bit confusing.

> 
> >  	struct mmu_notifier *mn;
> >  	int ret = 0;
> >  	int id;
> >  
> > +	range->blockable = blockable;
> > +	range->start = start;
> > +	range->end = end;
> > +	range->mm = mm;
> > +
> 
> Use your init function for this?

This get remove in the next patch, i can respawn with the init
function but this is a temporary step like explain above.

> 
> >  	id = srcu_read_lock(&srcu);
> >  	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
> >  		if (mn->ops->invalidate_range_start) {
> > -			int _ret = mn->ops->invalidate_range_start(mn, mm, start, end, blockable);
> > +			int _ret = mn->ops->invalidate_range_start(mn, range);
> >  			if (_ret) {
> >  				pr_info("%pS callback failed with %d in %sblockable context.\n",
> >  						mn->ops->invalidate_range_start, _ret,
> > @@ -205,9 +211,20 @@ void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
> >  					 unsigned long end,
> >  					 bool only_end)
> >  {
> > +	struct mmu_notifier_range _range, *range = &_range;
> >  	struct mmu_notifier *mn;
> >  	int id;
> >  
> > +	/*
> > +	 * The end call back will never be call if the start refused to go
> > +	 * through because of blockable was false so here assume that we
> > +	 * can block.
> > +	 */
> > +	range->blockable = true;
> > +	range->start = start;
> > +	range->end = end;
> > +	range->mm = mm;
> > +
> 
> The same as above.
> 
> Otherwise the patch looks good to me.

Thank you for reviewing.

Cheers,
Jérôme

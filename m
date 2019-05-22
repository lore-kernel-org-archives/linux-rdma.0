From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 0/1] Use HMM for ODP v4
Date: Wed, 22 May 2019 19:43:20 -0300
Message-ID: <20190522224320.GB15389@ziepe.ca>
References: <20190411181314.19465-1-jglisse@redhat.com>
 <20190506195657.GA30261@ziepe.ca>
 <20190521205321.GC3331@redhat.com>
 <20190522005225.GA30819@ziepe.ca>
 <20190522174852.GA23038@redhat.com>
 <20190522192219.GF6054@ziepe.ca>
 <20190522214917.GA20179@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190522214917.GA20179@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-mm@kvack.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 22, 2019 at 05:49:18PM -0400, Jerome Glisse wrote:
> > > > So why is mm suddenly guarenteed valid? It was a bug report that
> > > > triggered the race the mmget_not_zero is fixing, so I need a better
> > > > explanation why it is now safe. From what I see the hmm_range_fault
> > > > is doing stuff like find_vma without an active mmget??
> > > 
> > > So the mm struct can not go away as long as we hold a reference on
> > > the hmm struct and we hold a reference on it through both hmm_mirror
> > > and hmm_range struct. So struct mm can not go away and thus it is
> > > safe to try to take its mmap_sem.
> > 
> > This was always true here, though, so long as the umem_odp exists the
> > the mm has a grab on it. But a grab is not a get..
> > 
> > The point here was the old code needed an mmget() in order to do
> > get_user_pages_remote()
> > 
> > If hmm does not need an external mmget() then fine, we delete this
> > stuff and rely on hmm.
> > 
> > But I don't think that is true as we have:
> > 
> >           CPU 0                                           CPU1
> >                                                        mmput()
> >                        				        __mmput()
> > 							 exit_mmap()
> > down_read(&mm->mmap_sem);
> > hmm_range_dma_map(range, device,..
> >   ret = hmm_range_fault(range, block);
> >      if (hmm->mm == NULL || hmm->dead)
> > 							   mmu_notifier_release()
> > 							     hmm->dead = true
> >      vma = find_vma(hmm->mm, start);
> >         .. rb traversal ..                                 while (vma) remove_vma()
> > 
> > *goes boom*
> > 
> > I think this is violating the basic constraint of the mm by acting on
> > a mm's VMA's without holding a mmget() to prevent concurrent
> > destruction.
> > 
> > In other words, mmput() destruction does not respect the mmap_sem - so
> > holding the mmap sem alone is not enough locking.
> > 
> > The unlucked hmm->dead simply can't save this. Frankly every time I
> > look a struct with 'dead' in it, I find races like this.
> > 
> > Thus we should put the mmget_notzero back in.
> 
> So for some reason i thought exit_mmap() was setting the mm_rb
> to empty node and flushing vmacache so that find_vma() would
> fail.

It would still be racy without locks.

> Note that right before find_vma() there is also range->valid
> check which will also intercept mm release.

There is no locking on range->valid so it is just moves the race
around. You can't solve races with unlocked/non-atomic variables.

> Anyway the easy fix is to get ref on mm user in range_register.

Yes a mmget_not_zero inside range_register would be fine.

How do you want to handle that patch?

> > I saw some other funky looking stuff in hmm as well..
> > 
> > > Hence it is safe to take mmap_sem and it is safe to call in hmm, if
> > > mm have been kill it will return EFAULT and this will propagate to
> > > RDMA.
> >  
> > > As per_mm i removed the per_mm->mm = NULL from release so that it is
> > > always safe to use that field even in face of racing mm "killing".
> > 
> > Yes, that certainly wasn't good.
> > 
> > > > > -	 * An array of the pages included in the on-demand paging umem.
> > > > > -	 * Indices of pages that are currently not mapped into the device will
> > > > > -	 * contain NULL.
> > > > > +	 * An array of the pages included in the on-demand paging umem. Indices
> > > > > +	 * of pages that are currently not mapped into the device will contain
> > > > > +	 * 0.
> > > > >  	 */
> > > > > -	struct page		**page_list;
> > > > > +	uint64_t *pfns;
> > > > 
> > > > Are these actually pfns, or are they mangled with some shift? (what is range->pfn_shift?)
> > > 
> > > They are not pfns they have flags (hence range->pfn_shift) at the
> > > bottoms i just do not have a better name for this.
> > 
> > I think you need to have a better name then
> 
> Suggestion ? i have no idea for a better name, it has pfn value
> in it.

pfn_flags?

Jason

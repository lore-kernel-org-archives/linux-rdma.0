From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 0/6] mm: make pinned_vm atomic and simplify users
Date: Thu, 7 Feb 2019 13:12:52 -0700
Message-ID: <20190207201252.GA29842@ziepe.ca>
References: <20190206175920.31082-1-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190206175920.31082-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, dledford@redhat.com, jack@suse.cz, willy@infradead.org, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 09:59:14AM -0800, Davidlohr Bueso wrote:
> Changes from v2 (https://patchwork.kernel.org/cover/10774255/):
>  - Added more reviews for patch 1 and also fixed mm/debug.c to
>    use llx insted of lx so gcc doesn't complain.
> 
>  - Re did patch 3 (qib rdma) such that we still have to take
>    mmap_sem as it now uses gup_longterm(). gup_fast() conversion
>    remains for patch 2 which is not infiniband.
> 
>  - Rebased for rdma tree.
>  
> Changes from v1 (https://patchwork.kernel.org/cover/10764923/):
>  - Converted pinned_vm to atomic64 instead of atomic_long such that
>    infiniband need not worry about overflows.
> 
>  - Rebased patch 1 and added Ira's reviews as well as Parvi's review
>    for patch 5 (thanks!).
>    
> --------
> 
> Hi,
> 
> The following patches aim to provide cleanups to users that pin pages
> (mostly infiniband) by converting the counter to atomic -- note that
> Daniel Jordan also has patches[1] for the locked_vm counterpart and vfio.
> 
> Apart from removing a source of mmap_sem writer, we benefit in that
> we can get rid of a lot of code that defers work when the lock cannot
> be acquired, as well as drivers avoiding mmap_sem altogether by also
> converting gup to gup_fast() and letting the mm handle it. Users
> that do the gup_longterm() remain of course under at least reader mmap_sem.
> 
> Everything has been compile-tested _only_ so I hope I didn't do anything
> too stupid. Please consider for v5.1.
> 
> On a similar topic and potential follow up, it would be nice to resurrect
> Peter's VM_PINNED idea in that the broken semantics that occurred after
> bc3e53f682 ("mm: distinguish between mlocked and pinned pages") are still
> present. Also encapsulating internal mm logic via mm[un]pin() instead of
> drivers having to know about internals and playing nice with compaction are
> all wins.
> 
> Applies against rdma's for-next branch.
> 
> Thanks!
> 
> [1] https://lkml.org/lkml/2018/11/5/854
> 
> Davidlohr Bueso (6):
>   mm: make mm->pinned_vm an atomic64 counter
>   drivers/mic/scif: do not use mmap_sem
>   drivers/IB,qib: optimize mmap_sem usage
>   drivers/IB,hfi1: do not se mmap_sem
>   drivers/IB,usnic: reduce scope of mmap_sem
>   drivers/IB,core: reduce scope of mmap_sem

The surprise 7th patch was mangled, but I recreated it by hand

Otherwise applied to rdma for-next

Thanks,
Jason

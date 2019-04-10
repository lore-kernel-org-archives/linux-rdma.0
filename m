From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v6 0/8] mmu notifier provide context informations
Date: Wed, 10 Apr 2019 12:06:27 -0400
Message-ID: <20190410160626.GA3273@redhat.com>
References: <20190326164747.24405-1-jglisse@redhat.com>
 <20190409150855.a6cfee7e7c5698a9cd8ecb7c@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190409150855.a6cfee7e7c5698a9cd8ecb7c@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Alex Deucher <alexander.deucher@amd.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ben Skeggs <bskeggs@redhat.com>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidi>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 09, 2019 at 03:08:55PM -0700, Andrew Morton wrote:
> On Tue, 26 Mar 2019 12:47:39 -0400 jglisse@redhat.com wrote:
> 
> > From: Jérôme Glisse <jglisse@redhat.com>
> > 
> > (Andrew this apply on top of my HMM patchset as otherwise you will have
> >  conflict with changes to mm/hmm.c)
> > 
> > Changes since v5:
> >     - drop KVM bits waiting for KVM people to express interest if they
> >       do not then i will post patchset to remove change_pte_notify as
> >       without the changes in v5 change_pte_notify is just useless (it
> >       it is useless today upstream it is just wasting cpu cycles)
> >     - rebase on top of lastest Linus tree
> > 
> > Previous cover letter with minor update:
> > 
> > 
> > Here i am not posting users of this, they already have been posted to
> > appropriate mailing list [6] and will be merge through the appropriate
> > tree once this patchset is upstream.
> > 
> > Note that this serie does not change any behavior for any existing
> > code. It just pass down more information to mmu notifier listener.
> > 
> > The rational for this patchset:
> > 
> > CPU page table update can happens for many reasons, not only as a
> > result of a syscall (munmap(), mprotect(), mremap(), madvise(), ...)
> > but also as a result of kernel activities (memory compression, reclaim,
> > migration, ...).
> > 
> > This patch introduce a set of enums that can be associated with each
> > of the events triggering a mmu notifier:
> > 
> >     - UNMAP: munmap() or mremap()
> >     - CLEAR: page table is cleared (migration, compaction, reclaim, ...)
> >     - PROTECTION_VMA: change in access protections for the range
> >     - PROTECTION_PAGE: change in access protections for page in the range
> >     - SOFT_DIRTY: soft dirtyness tracking
> > 
> > Being able to identify munmap() and mremap() from other reasons why the
> > page table is cleared is important to allow user of mmu notifier to
> > update their own internal tracking structure accordingly (on munmap or
> > mremap it is not longer needed to track range of virtual address as it
> > becomes invalid). Without this serie, driver are force to assume that
> > every notification is an munmap which triggers useless trashing within
> > drivers that associate structure with range of virtual address. Each
> > driver is force to free up its tracking structure and then restore it
> > on next device page fault. With this serie we can also optimize device
> > page table update [6].
> > 
> > More over this can also be use to optimize out some page table updates
> > like for KVM where we can update the secondary MMU directly from the
> > callback instead of clearing it.
> 
> We seem to be rather short of review input on this patchset.  ie: there
> is none.

I forgot to update the review tag but Ralph did review v5:
https://lkml.org/lkml/2019/2/22/564
https://lkml.org/lkml/2019/2/22/561
https://lkml.org/lkml/2019/2/22/558
https://lkml.org/lkml/2019/2/22/710
https://lkml.org/lkml/2019/2/22/711
https://lkml.org/lkml/2019/2/22/695
https://lkml.org/lkml/2019/2/22/738
https://lkml.org/lkml/2019/2/22/757

and since this v6 is a rebase just with better comments here and
there i believe those reviews holds.

> 
> > ACKS AMD/RADEON https://lkml.org/lkml/2019/2/1/395
> 
> OK, kind of ackish, but not a review.
> 
> > ACKS RDMA https://lkml.org/lkml/2018/12/6/1473
> 
> This actually acks the infiniband part of a patch which isn't in this
> series.

This to show that they are end user and that those end user are
wanted. Also obviously i will be using this within HMM and thus
it will be use by mlx5, nouveau and amdgpu (which are all the
HMM user that are either upstream or queue up for 5.2 or 5.3).

> So we have some work to do, please.  Who would be suitable reviewers?

Anyone willing to review mmu notifier code. I believe this patchset is
not that hard to review this is about giving contextual informations
on why mmu notifier are happening it does not change the logic of any-
thing. They are no maintainers for the mmu notifier so i don't have a
person i can single out for review, thought given i have been the one
doing most changes in that area it could fall on me ...

Cheers,
Jérôme

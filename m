From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Tue, 12 Feb 2019 13:53:28 -0800
Message-ID: <CAPcyv4gKJ3=LhdO8Bnx2f-fnT_7H5D4FxvJDCEDEpcz1udnY_g@mail.gmail.com>
References: <20190206220828.GJ12227@ziepe.ca> <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <bfe0fdd5400d41d223d8d30142f56a9c8efc033d.camel@redhat.com>
 <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com>
 <20190208044302.GA20493@dastard> <20190208111028.GD6353@quack2.suse.cz>
 <CAPcyv4iVtBfO8zWZU3LZXLqv-dha1NSG+2+7MvgNy9TibCy4Cw@mail.gmail.com>
 <20190211102402.GF19029@quack2.suse.cz> <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com>
 <20190212160707.GA19076@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190212160707.GA19076@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 12, 2019 at 8:07 AM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 11-02-19 09:22:58, Dan Williams wrote:
> > On Mon, Feb 11, 2019 at 2:24 AM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Fri 08-02-19 12:50:37, Dan Williams wrote:
> > > > On Fri, Feb 8, 2019 at 3:11 AM Jan Kara <jack@suse.cz> wrote:
> > > > >
> > > > > On Fri 08-02-19 15:43:02, Dave Chinner wrote:
> > > > > > On Thu, Feb 07, 2019 at 04:55:37PM +0000, Christopher Lameter wrote:
> > > > > > > One approach that may be a clean way to solve this:
> > > > > > > 3. Filesystems that allow bypass of the page cache (like XFS / DAX) will
> > > > > > >    provide the virtual mapping when the PIN is done and DO NO OPERATIONS
> > > > > > >    on the longterm pinned range until the long term pin is removed.
> > > > > >
> > > > > > So, ummm, how do we do block allocation then, which is done on
> > > > > > demand during writes?
> > > > > >
> > > > > > IOWs, this requires the application to set up the file in the
> > > > > > correct state for the filesystem to lock it down so somebody else
> > > > > > can write to it.  That means the file can't be sparse, it can't be
> > > > > > preallocated (i.e. can't contain unwritten extents), it must have zeroes
> > > > > > written to it's full size before being shared because otherwise it
> > > > > > exposes stale data to the remote client (secure sites are going to
> > > > > > love that!), they can't be extended, etc.
> > > > > >
> > > > > > IOWs, once the file is prepped and leased out for RDMA, it becomes
> > > > > > an immutable for the purposes of local access.
> > > > > >
> > > > > > Which, essentially we can already do. Prep the file, map it
> > > > > > read/write, mark it immutable, then pin it via the longterm gup
> > > > > > interface which can do the necessary checks.
> > > > >
> > > > > Hum, and what will you do if the immutable file that is target for RDMA
> > > > > will be a source of reflink? That seems to be currently allowed for
> > > > > immutable files but RDMA store would be effectively corrupting the data of
> > > > > the target inode. But we could treat it similarly as swapfiles - those also
> > > > > have to deal with writes to blocks beyond filesystem control. In fact the
> > > > > similarity seems to be quite large there. What do you think?
> > > >
> > > > This sounds so familiar...
> > > >
> > > >     https://lwn.net/Articles/726481/
> > > >
> > > > I'm not opposed to trying again, but leases was what crawled out
> > > > smoking crater when this last proposal was nuked.
> > >
> > > Umm, don't think this is that similar to daxctl() discussion. We are not
> > > speaking about providing any new userspace API for this.
> >
> > I thought explicit userspace API was one of the outcomes, i.e. that we
> > can't depend on this behavior being an implicit side effect of a page
> > pin?
>
> I was thinking an implicit sideeffect of gup_longterm() call. Similarly as
> swapon(2) does not require the file to be marked in any special way. But
> OTOH I agree that RDMA is a less controlled usage than swapon so it is
> questionable. I'd still require something like CAP_LINUX_IMMUTABLE at least
> for gup_longterm() calls that end up pinning the file.
>
> Inspired by Christoph's idea you reference in [2], maybe gup_longterm()
> will succeed only if there is FL_LAYOUT lease for the range being pinned
> and we don't allow the lease to be released until there's a pinned page in
> the range. And we make the file protected (i.e. treat it like swapfile) if
> there's any such lease in it. But this is just a rough sketch and needs more
> thinking.
>
> > > Also I think the
> > > situation about leases has somewhat cleared up with this discussion - ODP
> > > hardware does not need leases since it can use MMU notifiers, for non-ODP
> > > hardware it is difficult to handle leases as such hardware has only one big
> > > kill-everything call and using that would effectively mean lot of work on
> > > the userspace side to resetup everything to make things useful if workable
> > > at all.
> > >
> > > So my proposal would be:
> > >
> > > 1) ODP hardward uses gup_fast() like direct IO and uses MMU notifiers to do
> > > its teardown when fs needs it.
> > >
> > > 2) Hardware not capable of tearing down pins from MMU notifiers will have
> > > to use gup_longterm() (we may actually rename it to a more suitable name).
> > > FS may just refuse such calls (for normal page cache backed file, it will
> > > just return success but for DAX file it will do sanity checks whether the
> > > file is fully allocated etc. like we currently do for swapfiles) but if
> > > gup_longterm() returns success, it will provide the same guarantees as for
> > > swapfiles. So the only thing that we need is some call from gup_longterm()
> > > to a filesystem callback to tell it - this file is going to be used by a
> > > third party as an IO buffer, don't touch it. And we can (and should)
> > > probably refactor the handling to be shared between swapfiles and
> > > gup_longterm().
> >
> > Yes, lets pursue this. At the risk of "arguing past 'yes'" this is a
> > solution I thought we dax folks walked away from in the original
> > MAP_DIRECT discussion [1]. Here is where leases were the response to
> > MAP_DIRECT [2]. ...and here is where we had tame discussions about
> > implications of notifying memory-registrations of lease break events
> > [3].
>
> Yeah, thanks for the references.
>
> > I honestly don't like the idea that random subsystems can pin down
> > file blocks as a side effect of gup on the result of mmap. Recall that
> > it's not just RDMA that wants this guarantee. It seems safer to have
> > the file be in an explicit block-allocation-immutable-mode so that the
> > fallocate man page can describe this error case. Otherwise how would
> > you describe the scenarios under which FALLOC_FL_PUNCH_HOLE fails?
>
> So with requiring lease for gup_longterm() to succeed (and the
> FALLOC_FL_PUNCH_HOLE failure being keyed from the existence of such lease),
> does it look more reasonable to you?

That sounds reasonable to me, just the small matter of teaching the
non-ODP RDMA ecosystem to take out FL_LAYOUT leases and do something
reasonable when the lease needs to be recalled.

I would hope that RDMA-to-FSDAX-PMEM support is enough motivation to
either make the necessary application changes, or switch to an
ODP-capable adapter.

Note that I think we need FL_LAYOUT regardless of whether the
legacy-RDMA stack ever takes advantage of it. VFIO device passthrough
to a guest that has a host DAX file mapped as physical PMEM in the
guest needs guarantees that the guest will be killed and DMA force
blocked by the IOMMU if someone punches a hole in memory in use by a
guest, or otherwise have a paravirtualized driver in the guest to
coordinate what effectively looks like a physical memory unplug event.

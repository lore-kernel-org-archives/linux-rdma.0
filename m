From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 14:52:58 +1100
Message-ID: <20190207035258.GD6173@dastard>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz>
 <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard>
 <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 05:24:50PM -0500, Doug Ledford wrote:
> On Wed, 2019-02-06 at 15:08 -0700, Jason Gunthorpe wrote:
> > On Thu, Feb 07, 2019 at 08:03:56AM +1100, Dave Chinner wrote:
> > > On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wrote:
> > > > On Wed, 6 Feb 2019, Doug Ledford wrote:
> > > > 
> > > > > > Most of the cases we want revoke for are things like truncate().
> > > > > > Shouldn't happen with a sane system, but we're trying to avoid users
> > > > > > doing awful things like being able to DMA to pages that are now part of
> > > > > > a different file.
> > > > > 
> > > > > Why is the solution revoke then?  Is there something besides truncate
> > > > > that we have to worry about?  I ask because EBUSY is not currently
> > > > > listed as a return value of truncate, so extending the API to include
> > > > > EBUSY to mean "this file has pinned pages that can not be freed" is not
> > > > > (or should not be) totally out of the question.
> > > > > 
> > > > > Admittedly, I'm coming in late to this conversation, but did I miss the
> > > > > portion where that alternative was ruled out?
> > > > 
> > > > Coming in late here too but isnt the only DAX case that we are concerned
> > > > about where there was an mmap with the O_DAX option to do direct write
> > > > though? If we only allow this use case then we may not have to worry about
> > > > long term GUP because DAX mapped files will stay in the physical location
> > > > regardless.
> > > 
> > > No, that is not guaranteed. Soon as we have reflink support on XFS,
> > > writes will physically move the data to a new physical location.
> > > This is non-negotiatiable, and cannot be blocked forever by a gup
> > > pin.
> > > 
> > > IOWs, DAX on RDMA requires a) page fault capable hardware so that
> > > the filesystem can move data physically on write access, and b)
> > > revokable file leases so that the filesystem can kick userspace out
> > > of the way when it needs to.
> > 
> > Why do we need both? You want to have leases for normal CPU mmaps too?

We don't need them for normal CPU mmaps because that's locally
addressable page fault capable hardware. i.e. if we need to
serialise something, we just use kernel locks, etc. When it's a
remote entity (such as RDMA) we have to get that remote entity to
release it's reference/access so the kernel has exclusive access
to the resource it needs to act on.

IOWs, file layout leases are required for remote access to local
filesystem controlled storage. That's the access arbitration model
the pNFS implementation hooked into XFS uses and it seems to work
just fine. Local access just hooks in to the kernel XFS paths and
triggers lease/delegation recalls through the NFS server when
required.

If your argument is that "existing RDMA apps don't have a recall
mechanism" then that's what they are going to need to implement to
work with DAX+RDMA. Reliable remote access arbitration is required
for DAX+RDMA, regardless of what filesysetm the data is hosted on.
Anything less is a potential security hole.

> > > yesterday!), and that means DAX+RDMA needs to work with storage that
> > > can change physical location at any time.
> > 
> > Then we must continue to ban longterm pin with DAX..
> > 
> > Nobody is going to want to deploy a system where revoke can happen at
> > any time and if you don't respond fast enough your system either locks
> > with some kind of FS meltdown or your process gets SIGKILL. 
> > 
> > I don't really see a reason to invest so much design work into
> > something that isn't production worthy.
> > 
> > It *almost* made sense with ftruncate, because you could architect to
> > avoid ftruncate.. But just any FS op might reallocate? Naw.
> > 
> > Dave, you said the FS is responsible to arbitrate access to the
> > physical pages..
> > 
> > Is it possible to have a filesystem for DAX that is more suited to
> > this environment? Ie designed to not require block reallocation (no
> > COW, no reflinks, different approach to ftruncate, etc)
> 
> Can someone give me a real world scenario that someone is *actually*
> asking for with this?  Are DAX users demanding xfs, or is it just the
> filesystem of convenience?

I had a conference call last week with a room full of people who
want reflink functionality on DAX ASAP. They have customers that are
asking them to provide it, and the only vehicle they have to
delivery that functionality in any reasonable timeframe is XFS.

> Do they need to stick with xfs?  Are they
> really trying to do COW backed mappings for the RDMA targets?

I have no idea if they want RDMA. It is also irrelevant to the
requirement of and timeframe to support reflink on XFS w/ DAX.

Especially because:

# mkfs.xfs -f -m reflink=0 /dev/pmem1

And now you have an XFS fileysetm configuration that does not
support dynamic moving of physical storage on write. You have to do
this anyway to use DAX right now, so it's hardly an issue to
require this for non-ODP capable RDMA hardware.

---

I think people are missing the point of LSFMM here - it is to work
out what we need to do to support all the functionality that both
users want and that the hardware provides in the medium term.

Once we have reflink on DAX, somebody is going to ask for
no-compromise RDMA support on these filesystems (e.g. NFSv4 file
server on pmem/FS-DAX that allows server side clones and clients use
RDMA access) and we're going to have to work out how to support it.
Rather than shouting at the messenger (XFS) that reports the hard
problems we have to solve, how about we work out exactly what we
need to do to support this functionality because it is coming and
people want it.

Requiring ODP capable hardware and applications that control RDMA
access to use file leases and be able to cancel/recall client side
delegations (like NFS is already able to do!) seems like a pretty
solid way forward here. We've already solved this "remote direct
physical accesses to local fileystem storage arbitration" problem
with NFSv4, we have both a server and a client in the kernel, so
maybe that should be the first application we aim to support with
DAX+RDMA?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

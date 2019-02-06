From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 08:03:56 +1100
Message-ID: <20190206210356.GZ6173@dastard>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz>
 <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wrote:
> On Wed, 6 Feb 2019, Doug Ledford wrote:
> 
> > > Most of the cases we want revoke for are things like truncate().
> > > Shouldn't happen with a sane system, but we're trying to avoid users
> > > doing awful things like being able to DMA to pages that are now part of
> > > a different file.
> >
> > Why is the solution revoke then?  Is there something besides truncate
> > that we have to worry about?  I ask because EBUSY is not currently
> > listed as a return value of truncate, so extending the API to include
> > EBUSY to mean "this file has pinned pages that can not be freed" is not
> > (or should not be) totally out of the question.
> >
> > Admittedly, I'm coming in late to this conversation, but did I miss the
> > portion where that alternative was ruled out?
> 
> Coming in late here too but isnt the only DAX case that we are concerned
> about where there was an mmap with the O_DAX option to do direct write
> though? If we only allow this use case then we may not have to worry about
> long term GUP because DAX mapped files will stay in the physical location
> regardless.

No, that is not guaranteed. Soon as we have reflink support on XFS,
writes will physically move the data to a new physical location.
This is non-negotiatiable, and cannot be blocked forever by a gup
pin.

IOWs, DAX on RDMA requires a) page fault capable hardware so that
the filesystem can move data physically on write access, and b)
revokable file leases so that the filesystem can kick userspace out
of the way when it needs to.

Truncate is a red herring. It's definitely a case for revokable
leases, but it's the rare case rather than the one we actually care
about. We really care about making copy-on-write capable filesystems like
XFS work with DAX (we've got people asking for it to be supported
yesterday!), and that means DAX+RDMA needs to work with storage that
can change physical location at any time.

> Maybe we can solve the long term GUP problem through the requirement that
> user space acquires some sort of means to pin the pages? In the DAX case
> this is given by the filesystem and the hardware will basically take care
> of writeback.

That's what the revokable file leases provide (it's basically the
same thing as a NFSv4 delegation). We already have all the
infrastructure in the filesystems for triggering revokes when
needed (implemented for pNFS a few years ago), and DAX already
piggy-backs on that infrastructureuses that infrastructure to wait
on gup pinned pages. See dax_layout_busy_page() and BREAK_UNMAP.

The problem is that dax_layout_busy_page can block forever when
userspace pins the file for RDMA. It's not just truncate - it's any
filesystem operation that needs to manipulate the underlying file
layout without doing data IO. i.e. any fallocate() operation, and
when we add reflink support it will include anythign that
shares or de-shares extents between files, too.

The revokable file leases are necessary because access to file data,
internal metadata and the storage is arbitrated by the filesystem,
not the mm/ subsystem and physical pages. i.e. FS-DAX means that the
*filesystem* is managing access to physical pages, not the mm/
subsystem. And we can't just ignore the filesystem in this case
because allowing access to the physical storage outside of the
filesystem's visibility and/or direct control is a potential
security vulnerability, data corruption or filesystem corruption
vector.

And that's the real problem we need to solve here. RDMA has no trust
model other than "I'm userspace, I pinned you, trust me!". That's
not good enough for FS-DAX+RDMA....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

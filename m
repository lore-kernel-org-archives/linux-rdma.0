From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
Date: Wed, 26 Oct 2016 08:19:03 +1100
Message-ID: <20161025211903.GD14023@dastard>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
 <20161019184814.GC16550@cgy1-donard.priv.deltatee.com>
 <20161020232239.GQ23194@dastard>
 <20161021095714.GA12209@infradead.org>
 <20161021111253.GQ14023@dastard>
 <20161025115043.GA14986@cgy1-donard.priv.deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161025115043.GA14986@cgy1-donard.priv.deltatee.com>
Sender: linux-block-owner@vger.kernel.org
To: Stephen Bates <sbates@raithlin.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, linux-rdma@vger.kernel.org, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, Jens Axboe <axboe@fb.com>, Jonathan Corbet <corbet@lwn.net>, jim.macdonald@everspin.com, sbates@raithin.com, Logan Gunthorpe <logang@deltatee.com>, David Woodhouse <dwmw2@infradead.org>, "Raj, Ashok" <ashok.raj@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 25, 2016 at 05:50:43AM -0600, Stephen Bates wrote:
> Hi Dave and Christoph
> 
> On Fri, Oct 21, 2016 at 10:12:53PM +1100, Dave Chinner wrote:
> > On Fri, Oct 21, 2016 at 02:57:14AM -0700, Christoph Hellwig wrote:
> > > On Fri, Oct 21, 2016 at 10:22:39AM +1100, Dave Chinner wrote:
> > > > You do realise that local filesystems can silently change the
> > > > location of file data at any point in time, so there is no such
> > > > thing as a "stable mapping" of file data to block device addresses
> > > > in userspace?
> > > >
> > > > If you want remote access to the blocks owned and controlled by a
> > > > filesystem, then you need to use a filesystem with a remote locking
> > > > mechanism to allow co-ordinated, coherent access to the data in
> > > > those blocks. Anything else is just asking for ongoing, unfixable
> > > > filesystem corruption or data leakage problems (i.e.  security
> > > > issues).
> > >
> 
> Dave are you saying that even for local mappings of files on a DAX
> capable system it is possible for the mappings to move on you unless
> the FS supports locking?

Yes.

> Does that not mean DAX on such FS is
> inherently broken?

No. DAX is accessed through a virtual mapping layer that abstracts
the physical location from userspace applications.

Example: think copy-on-write overwrites. It occurs atomically from
the perspective of userspace and starts by invalidating any current
mappings userspace has of that physical location. The location is
changes, the data copied in, and then when the locks are released
userspace can fault in a new page table mapping on the next
access....

> > > And at least for XFS we have such a mechanism :)  E.g. I have a
> > > prototype of a pNFS layout that uses XFS+DAX to allow clients to do
> > > RDMA directly to XFS files, with the same locking mechanism we use
> > > for the current block and scsi layout in xfs_pnfs.c.
> 
> Thanks for fixing this issue on XFS Christoph! I assume this problem
> continues to exist on the other DAX capable FS?

Yes, but it they implement the exportfs API that supplies this
capability, they'll be able to use pNFS, too.

> One more reason to consider a move to /dev/dax I guess ;-)...

That doesn't get rid of the need for sane access control arbitration
across all machines that are directly accessing the storage. That's
the problem pNFS solves, regardless of whether your direct access
target is a filesystem, a block device or object storage...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

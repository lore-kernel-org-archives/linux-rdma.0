From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
Date: Fri, 21 Oct 2016 22:12:53 +1100
Message-ID: <20161021111253.GQ14023@dastard>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
 <20161019184814.GC16550@cgy1-donard.priv.deltatee.com>
 <20161020232239.GQ23194@dastard>
 <20161021095714.GA12209@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161021095714.GA12209@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Bates <sbates@raithlin.com>, Dan Williams <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, linux-rdma@vger.kernel.org, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, Jens Axboe <axboe@fb.com>, Jonathan Corbet <corbet@lwn.net>, jim.macdonald@everspin.com, sbates@raithin.com, Logan Gunthorpe <logang@deltatee.com>, David Woodhouse <dwmw2@infradead.org>, "Raj, Ashok" <ashok.raj@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 21, 2016 at 02:57:14AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 21, 2016 at 10:22:39AM +1100, Dave Chinner wrote:
> > You do realise that local filesystems can silently change the
> > location of file data at any point in time, so there is no such
> > thing as a "stable mapping" of file data to block device addresses
> > in userspace?
> > 
> > If you want remote access to the blocks owned and controlled by a
> > filesystem, then you need to use a filesystem with a remote locking
> > mechanism to allow co-ordinated, coherent access to the data in
> > those blocks. Anything else is just asking for ongoing, unfixable
> > filesystem corruption or data leakage problems (i.e.  security
> > issues).
> 
> And at least for XFS we have such a mechanism :)  E.g. I have a
> prototype of a pNFS layout that uses XFS+DAX to allow clients to do
> RDMA directly to XFS files, with the same locking mechanism we use
> for the current block and scsi layout in xfs_pnfs.c.

Oh, that's good to know - pNFS over XFS was exactly what I was
thinking of when I wrote my earlier reply. A few months ago someone
else was trying to use file mappings in userspace for direct remote
client access on fabric connected devices. I told them "pNFS on XFS
and write an efficient transport for you hardware"....

Now that I know we've got RDMA support for pNFS on XFS in the
pipeline, I can just tell them "just write an rdma driver for your
hardware" instead. :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

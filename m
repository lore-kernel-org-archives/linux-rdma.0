From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Wed, 16 Jan 2019 10:24:36 -0700
Message-ID: <20190116172436.GM22045@ziepe.ca>
References: <20190104223531.GA1705@ziepe.ca>
 <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <20190115212501.GE22045@ziepe.ca>
 <20190116161134.GA29041@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190116161134.GA29041@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "syeh@vmware.com" <syeh@vmware.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "imre.deak@intel.com" <imre.deak@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 16, 2019 at 05:11:34PM +0100, hch@lst.de wrote:
> On Tue, Jan 15, 2019 at 02:25:01PM -0700, Jason Gunthorpe wrote:
> > RDMA needs something similar as well, in this case drivers take a
> > struct page * from get_user_pages() and need to have the DMA map fail
> > if the platform can't DMA map in a way that does not require any
> > additional DMA API calls to ensure coherence. (think Userspace RDMA
> > MR's)
> 
> Any time you dma map pages you need to do further DMA API calls to
> ensure coherent, that is the way it is implemented.  These calls
> just happen to be no-ops sometimes.
> 
> > Today we just do the normal DMA map and when it randomly doesn't work
> > and corrupts data tell those people their platforms don't support RDMA
> > - it would be nice to have a safer API base solution..
> 
> Now that all these drivers are consolidated in rdma-core you can fix
> the code to actually do the right thing.  It isn't that userspace DMA
> coherent is any harder than in-kernel DMA coherenence.  It just is
> that no one bothered to do it properly.

If I recall we actually can't.. libverbs presents an API to the user
that does not consider this possibility. 

ie consider post_recv - the driver has no idea what user buffers
received data and can't possibly flush them transparently. The user
would have to call some special DMA syncing API, which we don't have.

It is the same reason the kernel API makes the ULP handle dma sync,
not the driver.

The fact is there is 0 industry interest in using RDMA on platforms
that can't do HW DMA cache coherency - the kernel syscalls required to
do the cache flushing on the IO path would just destroy performance to
the point of making RDMA pointless. Better to use netdev on those
platforms.

VFIO is in a similar boat. Their user API can't handle cache syncing
either, so they would use the same API too.

.. and the GPU-compute systems (ie OpenCL/CUDA) are like verbs, they
were never designed with incoherent DMA in mind, and don't have the
API design to support it.

The reality is that *all* the subsytems doing DMA kernel bypass are
ignoring the DMA mapping rules, I think we should support this better,
and just accept that user space DMA will not be using syncing. Block
access in cases when this is required, otherwise let it work as is
today.

Jason

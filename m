From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Tue, 15 Jan 2019 14:25:01 -0700
Message-ID: <20190115212501.GE22045@ziepe.ca>
References: <20190104223531.GA1705@ziepe.ca>
 <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "syeh@vmware.com" <syeh@vmware.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "imre.deak@intel.com" <imre.deak@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 15, 2019 at 02:17:26PM +0000, Thomas Hellstrom wrote:
> Hi, Christoph,
> 
> On Mon, 2019-01-14 at 10:48 +0100, Christoph Hellwig wrote:
> > On Thu, Jan 10, 2019 at 04:42:18PM -0700, Jason Gunthorpe wrote:
> > > > Changes since the RFC:
> > > > - Rework vmwgfx too [CH]
> > > > - Use a distinct type for the DMA page iterator [CH]
> > > > - Do not have a #ifdef [CH]
> > > 
> > > ChristophH: Will you ack?
> > 
> > This looks generally fine.
> > 
> > > Are you still OK with the vmwgfx reworking, or should we go back to
> > > the original version that didn't have the type safety so this
> > > driver
> > > can be left broken?
> > 
> > I think the map method in vmgfx that just does virt_to_phys is
> > pretty broken.  Thomas, can you check if you see any performance
> > difference with just doing the proper dma mapping, as that gets the
> > driver out of interface abuse land?
> 
> The performance difference is not really the main problem here. The
> problem is that even though we utilize the streaming DMA interface, we
> use it only since we have to for DMA-Remapping and assume that the
> memory is coherent. To be able to be as compliant as possible and ditch
> the virt-to-phys mode, we *need* a DMA interface flag that tells us
> when the dma_sync_for_xxx are no-ops. If they aren't we'll refuse to
> load for now. I'm not sure, but I think also nouveau and radeon suffer
> from the same issue.

RDMA needs something similar as well, in this case drivers take a
struct page * from get_user_pages() and need to have the DMA map fail
if the platform can't DMA map in a way that does not require any
additional DMA API calls to ensure coherence. (think Userspace RDMA
MR's)

Today we just do the normal DMA map and when it randomly doesn't work
and corrupts data tell those people their platforms don't support RDMA
- it would be nice to have a safer API base solution..

Jason

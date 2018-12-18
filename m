From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Tue, 18 Dec 2018 10:12:46 -0700
Message-ID: <20181218171246.GC21992@ziepe.ca>
References: <20181214233254.5860-1-swarren@wwwdotorg.org>
 <20181218163202.GJ21949@mellanox.com>
 <498653b9-5006-2153-fa53-3bc217626303@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <498653b9-5006-2153-fa53-3bc217626303@wwwdotorg.org>
Sender: netdev-owner@vger.kernel.org
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 18, 2018 at 10:08:56AM -0700, Stephen Warren wrote:
> On 12/18/18 9:32 AM, Jason Gunthorpe wrote:
> > On Fri, Dec 14, 2018 at 04:32:54PM -0700, Stephen Warren wrote:
> > > From: Stephen Warren <swarren@nvidia.com>
> > > 
> > > This is a port of commit 378efe798ecf ("RDMA/hns: Get rid of page
> > > operation after dma_alloc_coherent") to the mlx4 driver. That change was
> > > described as:
> > > 
> > > > In general, dma_alloc_coherent() returns a CPU virtual address and
> > > > a DMA address, and we have no guarantee that the underlying memory
> > > > even has an associated struct page at all.
> > > > 
> > > > This patch gets rid of the page operation after dma_alloc_coherent,
> > > > and records the VA returned form dma_alloc_coherent in the struct
> > > > of hem in hns RoCE driver.
> > > 
> > > Differences in this port relative to the hns patch:
> > > 
> > > 1) The hns patch only needed to fix a dma_alloc_coherent path, but this
> > > patch also needs to fix an alloc_pages path. This appears to be simple
> > > except for the next point.
> > > 
> > > 2) The hns patch converted a bunch of code to consistently use
> > > sg_dma_len(mem) rather than a mix of that and mem->length However, it
> > > seems that sg_dma_len(mem) can be modified or zeroed at runtime, and so
> > > using it when calling e.g. __free_pages is problematic.
> > 
> > dma_len should only ever be used when programming a HW device to do
> > DMA. It certainly should never be used for anything else, so I'm not
> > sure why this description veered off into talking about alloc_pages?
> > 
> > If pages were allocated and described in a sg list then the CPU side
> > must use the pages/len part of the SGL to walk that list of pages.
> > 
> > I also don't really see a practical problem with putting the virtual
> > address pointer of DMA coherent memory in the SGL, so long as it is
> > never used in a DMA map operation or otherwise.
> > 
> > .. so again, what is it this is actually trying to fix in mlx4?
> 
> The same thing that the original hns patch fixed, and in the exact same way.
> Namely a crash during driver unload or system shutdown in the path that
> frees allocated memory contained in the sg list.
> 
> The reason is that the allocation does:
> 
> static int mlx4_alloc_icm_coherent(...
> ...
>         void *buf = dma_alloc_coherent(dev, PAGE_SIZE << order,
>                                        &sg_dma_address(mem), gfp_mask);
> ...
>         sg_set_buf(mem, buf, PAGE_SIZE << order);
>         sg_dma_len(mem) = PAGE_SIZE << order;
> 
> And free does:
> 
> static void mlx4_free_icm_coherent(...
> ...
>     dma_free_coherent(&dev->persist->pdev->dev,
>                       chunk->mem[i].length,
>                       lowmem_page_address(sg_page(&chunk->mem[i])),
> 
> However, there's no guarantee that dma_alloc_coherent() returned memory for
> which a struct page exists

> and hence the call to sg_page() and/or lowmem_page_address() can
> fail.

This is a much better explanation than what was in the patch commit
message, please revise it.

> To fix this, we add a second field to the mlx4 table struct which
> holds the return value from dma_alloc_coherent() so that value can
> be passed to dma_free_coherent() directly, rather than trying to
> re-derive the value in mlx4_free_icm_coherent().

That seems reasonable, but why did the commit message start talking
about alloc_pages then?

Jason

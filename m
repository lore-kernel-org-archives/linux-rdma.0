From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 02/37] IB/rdmavt: Consolidate dma ops in rdmavt.
Date: Fri, 11 Dec 2015 06:10:40 -0800
Message-ID: <20151211141040.GA22596@infradead.org>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204305.8144.7038.stgit@phlsvslse11.ph.intel.com>
 <20151208060821.GD7313@leon.nu>
 <20151210161708.GA13412@phlsvsds.ph.intel.com>
 <20151210174413.GB21482@obsidianresearch.com>
 <20151210234112.GA15546@infradead.org>
 <20151211002950.GA5964@obsidianresearch.com>
 <20151211004624.GA9994@infradead.org>
 <20151211060202.GA16513@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151211060202.GA16513-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 11:02:02PM -0700, Jason Gunthorpe wrote:
> > FYI, I have a patch series in linux-next to switches all remaining
> > architectures to use get_dma_ops, and there are plans to allow generic
> > per-device dma_ops based on that.
> 
> Great, so once that is merged we can drop the ib_* versions of all
> this and just have qib/etc customize get_dma_ops? Other than the
> dma_addr_t size issue that sounds great..

I'm not sure the per-device ops are a done deal, as there has been
vocal opposition to it everytime it came up.  But at least we have
the infrastructure for it now.

Other than that I think we're getting ready to actually remove
dma mapping from the ULPs.  Sagi's MR API that takes a scatterlist
is a first step, as it would allow for trivially moving the
dma_map_sg into the core helpes.  For the client side we now just
need to switch FMRs to use that API as well (given that it seems
like we can't get rid of them) and provide an API to "map" a
scatterlist using the DMA MR for those drivers playing fast and
loose.  On the server side I have a first draft of a R/W API that
does RDMA READ/WRITE requests and handles the required registration
and invalidation internally.  It again takes a scatterlist and handles
dma mapping internal.  Now all the dma mapping will be in the core,
which means they are only one step away from the driver.  Now if the
per-device dma_ops don't work out we can simply have a flag in
struct ib_device that it doesn't need dma mapping and can avoid
the indirection through another set of ops at least.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

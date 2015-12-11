From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 02/37] IB/rdmavt: Consolidate dma ops in rdmavt.
Date: Thu, 10 Dec 2015 17:29:50 -0700
Message-ID: <20151211002950.GA5964@obsidianresearch.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204305.8144.7038.stgit@phlsvslse11.ph.intel.com>
 <20151208060821.GD7313@leon.nu>
 <20151210161708.GA13412@phlsvsds.ph.intel.com>
 <20151210174413.GB21482@obsidianresearch.com>
 <20151210234112.GA15546@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151210234112.GA15546-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 03:41:12PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 10, 2015 at 10:44:13AM -0700, Jason Gunthorpe wrote:
> > > the signature of the function in struct ib_dma_mapping_ops.
> > 
> > It is supposed to be a dma_addr_t 'cookie' not a u64.
> > 
> > A patch to cleanup the core in this area would be appreciated.
> 
> I walked through the ib_dma_* mess in detail, and sadly speaking it
> has to be a u64.  This is due to the drivers being consolidated into
> rdmavt in fact.

> Those drivers use the addr field in struct ib_sge to point to a kernel
> virtual address, not to a DMA address.  In Linux u64 is the safe
> superset for a dma_addr_t and a pointer so we'll need to go with that.

Hrm.. sizeof(void *) > sizeof(dma_addr_t) seemed pretty obscure to me,
here is the original discussion:

https://lkml.org/lkml/2006/12/13/245

Sounds like someone was worried about sparc64. I doubt it is an actual
issue today, but granted the u64 did make some sense.

I probably would have just banned compiling qib on such a platform,
and kept the dma_addr_t annotations..

> Now these drivers will end up dma mapping these virtual addresses later,
> so we might want figure out a) why the qib & co drivers even need the
> virtual address, and b) see if we maybe should always do the dma_map
> in the callers anyway, and just have an additional virtual address field
> for those drivers if absolutely needed.

So, I *believe* the issue is that linux has (had?) no approved way to
convert from a device specific dma_addr_t to a virtual address.

I always understood that there was some kind of path in qib where it
needed to memcpy with the CPU the 'dma' data, so if it only had a
dma_addr then there was no way to make it work.

Certainly a future generic soft-rocee driver will need to cpu memcpy from
'dma' memory to a skb..

It is really too bad we can't just use get_dma_ops to handle this case
and instead require our own infrastructure.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

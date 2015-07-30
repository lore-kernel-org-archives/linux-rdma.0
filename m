From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 30 Jul 2015 10:36:31 -0600
Message-ID: <20150730163631.GB16659@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
 <55B4AA73.3090803@dev.mellanox.co.il>
 <20150727170459.GA18348@obsidianresearch.com>
 <55B9CE85.40007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B9CE85.40007-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 10:13:09AM +0300, Sagi Grimberg wrote:

> >Basically, swiotlb realigns everything that passes through it.
> 
> So this won't ever happen if the ULP will DMA map the SG and check
> for gaps right?

Once mapped the physical address isn't going to change - but at some
point we must check the physical address directly.

> Also, is it interesting to support swiotlb even if we don't have
> any devices that require it (and should we expect one to ever exist)?

swiotlb is an obvious example, and totally uninteresting to support,
but we must correctly use the DMA API.

> >The DMA API allows this, so ultimately, code has to check the dma
> >physical address when concerned about alignment.. But we should not
> >expect this to commonly fail.
> >
> >So, something like..
> >
> >   if (!ib_does_sgl_fit_in_mr(mr,sg))
> >      .. bounce buffer ..
> 
> I don't understand the need for this is we do the same thing
> if the actual mapping fails...

Just performance. DMA mapping is potentially very expensive, the
common case to detect will be a sg that is virtually unaligned.

This virtual scan could be bundled insde the map, but if a ULP knows
it is page aligned already then that is just creating overhead..

I'm ambivalent..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

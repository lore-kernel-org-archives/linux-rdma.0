From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Wed, 19 Aug 2015 11:37:51 -0600
Message-ID: <20150819173751.GB22646@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
 <55D46EE8.4060701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55D46EE8.4060701-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 19, 2015 at 02:56:24PM +0300, Sagi Grimberg wrote:
> On 7/23/2015 8:55 PM, Jason Gunthorpe wrote:
> >On Thu, Jul 23, 2015 at 01:15:16PM +0300, Sagi Grimberg wrote:
> >>>I was hoping we'd move the DMA flush and translate into here and make
> >>>it mandatory. Is there any reason not to do that?
> >>
> >>The reason I didn't added it in was so the ULPs can make sure they meet
> >>the restrictions of ib_map_mr_sg(). Allow SRP to iterate on his
> >>SG list set partials and iSER to detect gaps (they need to dma map
> >>for that).
> >
> >The ULP can always get the sg list's virtual address to check for
> >gaps. Page aligned gaps are always OK.
> 
> So I had a go with moving the DMA mapping into ib_map_mr_sg() and
> it turns out mapping somewhat poorly if the ULP _may_ register memory
> or just send sg_lists (like storage targets over IB/iWARP). So the ULP
> will sometimes use the DMA mapping and sometimes it won't... feels
> kinda off to me...

You need to split the rkey and lkey API flows to pull this off - the
rkey side never needs to touch a sg, while the lkey side should always
try and use a sg first. I keep saying this: they have
fundamentally different ULP usages.

> 1. if register - call ib_map_mr_sg (which calls dma_map_sg)
>    else do dma_map_sg
> 2. if registered - call ib_dma_unmap_sg (which calles dma_unmap_sg)
>    else do dma_unmap_sg

>From what I've seen in the ULPs the flow control is generally such
that the MR is 'consumed' even if it isn't used by a send.

So lkey usage is simply split into things that absolutely don't need a
MR, and things that maybe do. The maybe side can go ahead and always
consume the MR resource, but optimize the implementation to a SG list
to avoid a performance hit.

Then the whole API becomes symmetric. The ULP says, 'here is a
scatterlist list and a lkey MR, make me a ib_sg list' and the core
either packes it as is into the sg, or it spins up the MR and packs
that.

This lets the unmap be symmetric, as the core always dma_unmaps, but
only tears down the MR if it was used.

The cost is the lkey MR slot is always consumed, which should be OK
because SQE flow control bounds the number of concurrent MRs required,
so consuming a SQE but not a MR doesn't provide an advantage.

> Also, at the moment, when ULPs are doing either FRWR or FMRs
> its a pain to get a non-intrusive conversion.

Without FMR sharing API entry points it is going to be hard to unify
them..

ie the map and alloc API side certainly could be shared..

> I'm thinking we should keep dma_map_sg out of ib_map_mr_sg, and leave
> it to the ULP like it does today (at least in the first stage...)

I'm fine with first stage, but we still really do need to figure how
how to get better code sharing in our API here..

Maybe we can do the rkey side right away until we can figure out how
to harmonize the rkey sg/mr usage?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

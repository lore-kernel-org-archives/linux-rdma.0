From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 23 Jul 2015 11:55:35 -0600
Message-ID: <20150723175535.GE25174@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B0BEB4.9080702-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 01:15:16PM +0300, Sagi Grimberg wrote:
> >I was hoping we'd move the DMA flush and translate into here and make
> >it mandatory. Is there any reason not to do that?
> 
> The reason I didn't added it in was so the ULPs can make sure they meet
> the restrictions of ib_map_mr_sg(). Allow SRP to iterate on his
> SG list set partials and iSER to detect gaps (they need to dma map
> for that).

The ULP can always get the sg list's virtual address to check for
gaps. Page aligned gaps are always OK.

BTW, the logic in ib_sg_to_pages should be checking that directly, as
coded, it won't work with swiotlb:

// Only the first SG entry can start unaligned
if (i && page_addr != dma_addr)
    return EINVAL;
// Only the last SG entry can end unaligned
if ((page_addr + dma_len) & PAGE_MASK != end_dma_addr)
 if (!is_last)
     return EINVAL;

Don't use sg->offset after dma mapping.

The biggest problem with checking the virtual address is
swiotlb. However, if swiotlb is used this API is basically broken as
swiotlb downgrades everything to a 2k alignment, which means we only
ever get 1 s/g entry.

To efficiently support swiotlb we'd need to see the driver be able to
work with a page size of IO_TLB_SEGSIZE (2k) so it can handle the
de-alignment that happens during bouncing.

My biggest problem with pushing the dma address up to the ULP is
basically that: The ULP has no idea what the driver can handle, maybe
the driver can handle the 2k pages.

So, that leaves a flow where the ULP does a basic sanity check on the
virtual side, then asks the IB core to map it. The mapping could still
fail because of swiotlb.

If the mapping fails, then the ULP has to bounce buffer, or MR split,
or totally fail.

For bounce buffer, all solutions have a DMA map/unmap cost, so it
doesn't matter if ib_map_mr_sg does that internally.

For MR fragment, the DMA mapping is still usable. Maybe we do need a
slightly different core API to help MR fragmentation? Sounds like NFS
uses this too?

 num_mrs = ib_mr_fragment_sg(&scatterlist);
 while (..)
   ib_map_fragment_sg(mr[i++],&scatterlist,&offset);

Perhaps?

Maybe that is even better because something like iser could do
the parallel:
 ib_mr_needs_fragment_sg(reference_mr,&scatterlist)

Which hides all the various restrictions in driver code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Mon, 27 Jul 2015 11:04:59 -0600
Message-ID: <20150727170459.GA18348@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
 <55B4AA73.3090803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B4AA73.3090803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 26, 2015 at 12:37:55PM +0300, Sagi Grimberg wrote:
> I guess I can pull DMA mapping in there, but we will need an opposite
> routine ib_umap_mr_sg() since it'll be weird if the ULP will do dma
> unmap without doing the map...

Yes, and ideally it would help ULPs to order these operations
properly. eg we shouldn't be abusing the DMA API and unmapping before
invalidate completes by default. That breaks obscure stuff in various
ways...

> >The biggest problem with checking the virtual address is
> >swiotlb. However, if swiotlb is used this API is basically broken as
> >swiotlb downgrades everything to a 2k alignment, which means we only
> >ever get 1 s/g entry.
> 
> Can you explain what do you mean by "downgrades everything to a 2k
> alignment"? If the ULP is responsible for a PAGE_SIZE alignment than
> how would this get out of alignment with swiotlb?

swiotlb copies all DMA maps to a shared buffer below 4G so it can be
used with 32 bit devices.

The shared buffer is managed in a way that copies each s/g element to
a continuous 2k aligned subsection of the buffer.

Basically, swiotlb realigns everything that passes through it.

The DMA API allows this, so ultimately, code has to check the dma
physical address when concerned about alignment.. But we should not
expect this to commonly fail.

So, something like..

  if (!ib_does_sgl_fit_in_mr(mr,sg))
     .. bounce buffer ..
     
  if (!ib_map_mr_sg(mr,sg)) // does dma mapping and checks it
     .. bounce buffer ..
     
  .. post ..
  .. send invalidate ..
  .. catch invalidate completion ...

  ib_unmap_mr(mr); // does dma unmap

?
 
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

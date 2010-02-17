From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: is it possible to avoid syncing after an rdma write?
Date: Tue, 16 Feb 2010 17:58:27 -0700
Message-ID: <20100217005827.GF16490@obsidianresearch.com>
References: <4B7B2A6C.80101@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B7B2A6C.80101-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 16, 2010 at 03:29:48PM -0800, Andy Grover wrote:
> Right now, RDS follows each RDMA write op with a Send op, which 1)
> causes an interrupt and 2) includes the info we need to call
> ib_dma_sync_sg_for_cpu() for the target of the rdma write.
> 
> We want to omit the Send. If we don't do the sync on the machine that is
> the target of the RDMA write, the result is... what exactly? I assume
> the write to memory is snooped by CPUs, so their cachelines will be
> properly invalidated. However, Linux DMA-API docs seem pretty clear in
> insisting on the sync.

I'm curious about this too, but I will point out that at least the
user RDMA interface has no match for the kernel DMA calls, so in
practice RDMA does not work on systems that require them. That means
bounce buffering is not used and IO/CPU caches are coherent.

Though, I guess, the kernel could use weaker memory ordering types in
kernel mode that do require the DMA api calls.

> Is the issue IOMMUs? Or for compatibility with bounce buffering?

As long as the memory is registered the IOMMU should remain
configured.

What do you intend to replace the SEND with? spin on last byte? There
are other issues to consider like ordering within the PCI-E fabric..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

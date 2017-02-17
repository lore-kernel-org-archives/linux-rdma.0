From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 02/14] Provide new names for the CPU barriers
 related to DMA
Date: Fri, 17 Feb 2017 09:37:50 -0700
Message-ID: <20170217163750.GA30677@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <067401d288a1$1f90c820$5eb25860$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <067401d288a1$1f90c820$5eb25860$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 16, 2017 at 04:07:54PM -0600, Steve Wise wrote:
> > 
> > Broadly speaking, providers are not using the existing macros
> > consistently and the existing macros are very poorly defined.
> > 
> > Due to this poor definition we struggled to implement a sensible
> > barrier for ARM64 and just went with the strongest barriers instead.
> > 
> > Split wmb/wmb_wc into several cases:
> >  udma_to_device_barrier - Think dma_map(TO_DEVICE) in kernel terms
> >  udma_ordering_write_barrier - Weaker than wmb() in the kernel
> >  mmio_flush_writes - Special to help work with WC memory
> >  mmio_wc_start - Special to help work with WC memory
> 
> I think you left out the mmio_wc_start() implementation?

Oops, that hunk ended up in  patch 14. I've fixed it thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

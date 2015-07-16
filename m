From: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Thu, 16 Jul 2015 01:04:02 -0700
Message-ID: <20150716080402.GC9093@infradead.org>
References: <20150710161108.GA19042@obsidianresearch.com>
 <CCB6E837-88FF-4DBB-976D-4CF56396A1A1@ogc.us>
 <55A24571.60902@dev.mellanox.co.il>
 <00e201d0be6a$e49bc910$add35b30$@opengridcomputing.com>
 <20150714192941.GA26292@obsidianresearch.com>
 <00e401d0be6b$d3952750$7abf75f0$@opengridcomputing.com>
 <20150714195511.GB7716@infradead.org>
 <20150714202943.GB26927@obsidianresearch.com>
 <20150715065057.GA22113@infradead.org>
 <20150715191257.GF23588@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150715191257.GF23588-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Steve Wise' <swise-/Yg/VP3ZvrM@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 15, 2015 at 01:12:57PM -0600, Jason Gunthorpe wrote:
> > This looks perfect to me.  After this we can get rid of the
> > ib_get_dma_mr calls outside of ib_alloc_pd, and eventuall move
> > setting up ->local_dma_lkey into the HW driver and kill of
> > ib_get_dma_mr, IB_DEVICE_LOCAL_DMA_LKEY and device->local_dma_lkey.
> 
> Just for clarity, again, we can never do this.
> 
> device->local_dma_lkey requires dedicated hardware support. We cannot
> create it in software on old hardware. The only option I see is the
> different-for-every-PD solution in my patch.

I don't see how my sentence above contradicts this.

One we use pd->local_dma_lkey everywhere, we can kill of
device->local_dma_lkey as an API - drivers either stick it straight
into pd->local_dma_lkey or do the internal equivalent of ib_get_dma_mr.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

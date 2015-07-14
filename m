From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 14:44:42 -0600
Message-ID: <20150714204442.GD26927@obsidianresearch.com>
References: <559FC710.1050307@talpey.com>
 <20150710161108.GA19042@obsidianresearch.com>
 <CCB6E837-88FF-4DBB-976D-4CF56396A1A1@ogc.us>
 <55A24571.60902@dev.mellanox.co.il>
 <00e201d0be6a$e49bc910$add35b30$@opengridcomputing.com>
 <20150714192941.GA26292@obsidianresearch.com>
 <00e401d0be6b$d3952750$7abf75f0$@opengridcomputing.com>
 <20150714195511.GB7716@infradead.org>
 <20150714202943.GB26927@obsidianresearch.com>
 <010a01d0be75$5e60d600$1b228200$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <010a01d0be75$5e60d600$1b228200$@opengridcomputing.com>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 14, 2015 at 03:40:49PM -0500, Steve Wise wrote:
> > local_dma_lkey appears to be global, it works with any PD.
> > 
> > ib_get_dma_mr is tied to a PD, so it cannot replace local_dma_lkey at
> > the struct device level.
> > 
> > ib_alloc_pd is the in-kernel entry point, the UAPI calls
> > device->alloc_pd directly.. So how about the below patch as a starting
> >        >point?
> > 
> > (Steve the goal of step #1 would be to remove ib_get_dma_mr from ULPs
> >  Follow on patches would be to convert all ULPs to use this API change.)

> I'm not seeing the benefit of adding pd->local_dma_lkey?
> pd->device->local_dma_lkey is there for core and ULP use, and we
> could have old drivers that don't currently have support for
> local_dma_lkey allocate their own private pd/dma_mr (via their
> private functions for doing this) with only LOCAL_WRITE access
> flags, and export that lkey as the device->local_dma_lkey.  Wouldn't
> that be simpler?

It would be, but AFAIK that can't work?

My understanding is if you create a QP against a PD then only lkeys
and rkeys (and local_dma_rkey) created against that PD are valid for
use with that QP.

I can't use an lkey from a PD not associated with the QP.

Am I wrong on this?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

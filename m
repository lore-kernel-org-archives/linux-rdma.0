From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: kernel memory registration (was: RDMA/core:
 Transport-independent access flags)
Date: Fri, 10 Jul 2015 10:35:11 -0600
Message-ID: <20150710163511.GB19042@obsidianresearch.com>
References: <20150707161751.GA623@obsidianresearch.com>
 <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <559D983D.6000804@talpey.com>
 <20150708233604.GA20765@obsidianresearch.com>
 <559E54AB.2010905@dev.mellanox.co.il>
 <20150709170142.GA21921@obsidianresearch.com>
 <559F8881.7070308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <559F8881.7070308-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 10, 2015 at 11:55:29AM +0300, Sagi Grimberg wrote:

> IMHO, memory registration is memory registration. The fact that we are
> distinguishing between local and remote might be a sign that this might
> be a wrong direction to take. Sorry.

I belive they are very different, yes, if you sit at the level of the
specification or maybe even a HCA design, they are nice and similar,
but for someone writing a ULP - local is not helping.

> What if a ULP has a pre-allocated pool of large buffers that it knows
> it is going to use for its entire lifetime? silent driver driven FRWRs
> would perform a lot worse than pre-registering these buffers.

Okay, so I think you've gone too far down the path here. I am
proposing an API direction that hides the lkey entirely and provides
common posting path for ULPs that needs dynamic short term on the fly
MR creation. This is basically every ULP in the kernel today.

I'm not saying we should rip out all of the lkey stuff and hobble
ib_post_send, only that this new API, aimed *specifically* at
simplifying our *current* universe of ULPs should do that.

> Or what if the ULP wants to register the memory region with data
> integrity (signature) parameters?

Then it calls rdma_post_write_dif(..)/etc. Is that not good enough?

> If there is one thing worse than a complicated API, it is a restrictive
> one. I'd much rather ULPs just having a simple API for registering
> memory.

No, strongly disagree. A restrictive API that solves exactly the
problem our ULPs today face is *exactly* what we need here.

This is in-kernel. It isn't a UAPI. It isn't an industry standard. We
can change and revise it next year if we need.

> >I'm not really seeing anything here that screams out this is
> >impossible, or performance is impacted, or it is too messy on either
> >the ULP or driver side.
> 
> I think it is possible (at the moment). But I don't know if we should
> have the drivers abusing the send/completion queues like that.
> 
> I can't say I'm fully on board with the idea of silent send-queue
> posting and silent completion consuming.

I'm not sure I'd call it silent, it tells the ULP how many slots it
will use.

> >I expect all these calls would be function pointers, and each driver
> >would provide a function pointer that is optimal for it's use. Eg mlx4
> >would provide a pointer that used the S/G list, then falls back to
> >FRMR if the S/G list is exhausted. The core code would provide a
> >toolbox of common functions the drivers can use here.
> 
> Maybe it's just me, but I can't help but wander if this is facilitating
> an atmosphere where drivers will keep finding new ways to abuse even
> the most simple operations.

Maybe, I'm not sure. Being restrictive with the API certainly prevents
alot of 'creative' uses. It is hard to argue about what
rdma_post_rdma_read should do, it can be made quite narrowly defined.

If mlx4 implements this with a FRMR call and mlx5 uses Indirect MR,
and qib implements it with a non-standard extended scatter list - do I
care? Not really.

But it does seem provide a much saner way for vendors to add
extensions, ie I think I'd rather see a rdma_post_write_dif than a
bunch of non-standard extensions in FRMR flags and WR attributes.

> I need more time to comprehend.

Please think about it, I'm pretty sure the iWarp guys *have* to go
down this road, it is a good way for them to implement their
quirk on RDMA READ across many ULPs.

Understand the iWarp problem is that they cannot use a phys dma MR for
their RDMA READ lkey - this is a major difference from IB.

The issue is larger than just memory registration.

> My intention is to improve FRWR API and gradually remove the other APIs
> from the kernel (i.e. FMR/FMR_POOL/MW). As I said, I don't think that
> striving to an API that implicitly chooses how to register memory is a
> good idea.

Can you explain why? And I mean specifically - how will
NFS/ISER/SRP/Lustre specifically be impacted if we move that choice
into the core/driver layer?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

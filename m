From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Kernel fast memory registration API proposal [RFC]
Date: Tue, 14 Jul 2015 13:07:19 -0500
Message-ID: <00c301d0be5f$ecf4c860$c6de5920$@opengridcomputing.com>
References: <559F8BD1.9080308@dev.mellanox.co.il> <20150713163015.GA23832@obsidianresearch.com> <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org> <20150714155340.GA7399@obsidianresearch.com> <55A53CFA.7070509@dev.mellanox.co.il> <20150714170808.GA19814@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714170808.GA19814-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Tuesday, July 14, 2015 12:08 PM
> To: Sagi Grimberg
> Cc: Christoph Hellwig; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Steve Wise; Or Gerlitz; Oren Duer; Chuck Lever; Bart Van Assche; Liran Liss;
Hefty,
> Sean; Doug Ledford; Tom Talpey
> Subject: Re: Kernel fast memory registration API proposal [RFC]
> 
> On Tue, Jul 14, 2015 at 07:46:50PM +0300, Sagi Grimberg wrote:
> > >I'm really disappointed by the negative emails on this subject..
> 
> > I'm really not trying to be negative. I'm hearing you out, and I agree
> > with a lot of what you have to say. I just don't agree with all of it.
> 
> Sure, I just find it hard to be constructive against "I don't like it" :)
> 
> > Which drivers doesn't support FRWR that we need to do other things?
> > ipath - depracated
> 
> We have permission to move this to staging and then RM it, so yay!
> 
> > mthca - soon to be deprecated
> 
> This one I have a problem with. There is alot of mthca hardware out
> there, it feels wrong to nuke it.. If we can continue to support the
> FMR scheme it uses transparently, that would be excellent.
> 
> I'm not hearing a strong reason why that shouldn't be the case...
> 
> > ehca - Not sure what is going on there. they only have phys_mr
> >        anyway, which just lost its only caller in the kernel
> 
> I thought it supported fmr:
> 
> drivers/infiniband/hw/ehca/ehca_main.c: shca->ib_device.alloc_fmr           = ehca_alloc_fmr;
> drivers/infiniband/hw/ehca/ehca_main.c: shca->ib_device.map_phys_fmr        = ehca_map_phys_fmr;
> drivers/infiniband/hw/ehca/ehca_main.c: shca->ib_device.unmap_fmr           = ehca_unmap_fmr;
> drivers/infiniband/hw/ehca/ehca_main.c: shca->ib_device.dealloc_fmr         = ehca_dealloc_fmr;
> 
> ?
> 
> I'm not sure what the status of ehca is, but I somehow suspect any
> remaining users are going to be on an old vendor kernel forever..
> 
> > amso1100 - git log shows almost zero activity with this driver
> 
> IIRC, this card was already/nearly discountinued and obsolete when the driver
> was added, I certainly wouldn't object to remove it, or totally break
> it for kernel storage ULPs - Steve?
>

We can remove it or stage it then remove.
 
> > usnic - who is completely not interesting to the kernel ULPs because:
> 
> Right.
> 
> > So my point is, it's a great deal of effort to combine these
> > in any API that we come up with for a bunch of esoteric drivers.
> > Let's just let them die on their own, please.
> 
> If amso110 is the only iWarp driver that needs phys_mr, I'd be happy
> to drop it and drop the requirement to support that. Is that right Steve?
> 


Yes.

> But mthca, I have a hard time calling that esoteric.. Heck, even I
> still have various mthca cards around here that are regularly used for
> SDR/DDR/CX4 testing on modern kernels..
> 
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

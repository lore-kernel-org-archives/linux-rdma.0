From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] RDMA/cxgb3: fail get_dma_mr if the memory footprint can exceed 32b
Date: Thu, 23 Jul 2015 17:47:14 -0500
Message-ID: <00d501d0c599$84afdb50$8e0f91f0$@opengridcomputing.com>
References: <20150722191417.9306.17387.stgit@build2.ogc.int> <55B15D7D.3090601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B15D7D.3090601-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Thursday, July 23, 2015 4:33 PM
> To: Steve Wise
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] RDMA/cxgb3: fail get_dma_mr if the memory footprint can exceed 32b
> 
> On 07/22/2015 03:14 PM, Steve Wise wrote:
> > T3 HW only supports MRs of length < 4GB.  If the system can have more
> > than that we need to fail dma mr allocation so we con't create a MR that
> > cannot span the entire possible memory space.
> >
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> >
> >  drivers/infiniband/hw/cxgb3/iwch_provider.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> > index b1b7323..bbbe018 100644
> > --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> > +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> > @@ -736,6 +736,10 @@ static struct ib_mr *iwch_get_dma_mr(struct ib_pd *pd, int acc)
> >  	/*
> >  	 * T3 only supports 32 bits of size.
> >  	 */
> > +	if (sizeof(phys_addr_t) > 4) {
> > +		pr_warn_once(MOD "Cannot support dma_mrs on this platform.\n");
> > +		return ERR_PTR(-ENOTSUPP);
> > +	}
> >  	bl.size = 0xffffffff;
> >  	bl.addr = 0;
> >  	kva = 0;
> 
> Should this be a static check of the pointer size versus installed
> memory?  Would it be possible to have this work for machines with less
> than 4GB of physical memory even if they have 64bit pointers, or are you
> concerned that hotplug memory could take us over the limit after
> registration and cause problems?

NFSRDMA doesn't need dma-mrs for T3 since it has FRMR + local dma lkey support.  And since the deficiency really can cause problems on 64b systems if the memory grows > 4GB after dma-mr allocation, I decided to just not allow them for potential large memory systems.

Steve

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Common infrastructure for auto loading
 rdma modules
Date: Thu, 27 Jul 2017 16:18:50 -0600
Message-ID: <20170727221850.GB16986@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1500929067-1583-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501002916.8931.4.camel@wdc.com>
 <20170725173947.GA10905@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170725173947.GA10905-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org" <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 11:39:47AM -0600, Jason Gunthorpe wrote:
> > > +# Hardware that supports RoCE
> > > +DRIVERS=="be2net", ENV{ID_RDMA_ROCE}="1"
> > > +DRIVERS=="bnxt_en", ENV{ID_RDMA_ROCE}="1"
> > > +DRIVERS=="hns", ENV{ID_RDMA_ROCE}="1"
> > > +DRIVERS=="i40e", ENV{ID_RDMA_ROCE}="1"
> > > +DRIVERS=="mlx4_core", ENV{ID_RDMA_ROCE}="1"
> > > +DRIVERS=="mlx5_core", ENV{ID_RDMA_ROCE}="1"
> > > +DRIVERS=="qede", ENV{ID_RDMA_ROCE}="1"
> > 
> > Should the "rdma_rxe" driver be added to this list?
> 
> No.. I need to figure out something else for rxe. We have no way in
> RDMA to determine the driver binding to the RDMA device (eg like

This looks like a good bet for now:

DEVPATH=="*/infiniband/rxe*", ATTR{parent}=="*", ENV{ID_RDMA_ROCE}="1"

Now that I'm looking at rxe I notice that srp_daemon starts
automatically for roce ports.

I assume this is not desired?

This is going to be a bit harder to fix..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

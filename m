From: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: mlx4: IB_EVENT_PATH_MIG not generated on path migration
Date: Thu, 12 Feb 2015 09:20:36 +0100
Message-ID: <20150212082036.GG492@fholler.de>
References: <20150210155643.GB13690@fholler.de>
 <20150210180039.GD7427@obsidianresearch.com>
 <20150211092136.GB492@fholler.de>
 <20150211173837.GA20243@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150211173837.GA20243-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

On Wed, Feb 11, 2015 at 10:38:38AM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 11, 2015 at 10:21:36AM +0100, Fabian Holler wrote:
> > Hello Jason,
> > 
> > thanks for your answer.
> > 
> > On Tue, Feb 10, 2015 at 11:00:39AM -0700, Jason Gunthorpe wrote:
> > > On Tue, Feb 10, 2015 at 04:56:43PM +0100, Fabian Holler wrote:
> > > 
> > > > Does anybody have an idea what could be wrong?
> > > > Are the PATH_MIG* notifications with mlx4 drivers are working for somebody?
> > > 
> > > IIRC rdmacm does not forward these events.
> > > 
> > > There is a lot missing to support APM with RDMA CM, it doesn't do any
> > > of the CM state machine operations to coordinate loading alternate
> > > paths, for instance.
> > 
> > Alternate paths can be set directly at the QP.
> 
> APM requires a certain amount of synchronization between the local and
> remote QP state, particularly if you want it to work more than
> once. That is supposed to be done with CMA mads.

Ok, we discovered functions to configure APM in ib_cm.h.
We will investigate if we can use them to setup APM.

> > The event handler specified in the struct ib_qp_init_attr * parameter of 
> > rdma_create_qp() is registered as QP event handler.
> > rdma_create_qp() calls ib_create_qp() and sets qp->event_handler to
> > ib_qp_init_attr->event_handler.
> 
> Okay, right, I was thinking of something else.
> 
> We had exactly this working a few months ago for a demo, in kernel
> using Lustre and RDMA CM. I checked the patches we made and yes, the
> event_handler was being properly called with IB_EVENT_PATH_MIG on
> mlx4 and qib cards.
> 
> IIRC we may have needed the latest firmware on the mlx side.

We will also try a firmware upgrade.


thanks a lot!

Fabian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

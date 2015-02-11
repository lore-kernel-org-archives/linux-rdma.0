From: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: mlx4: IB_EVENT_PATH_MIG not generated on path migration
Date: Wed, 11 Feb 2015 10:21:36 +0100
Message-ID: <20150211092136.GB492@fholler.de>
References: <20150210155643.GB13690@fholler.de>
 <20150210180039.GD7427@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150210180039.GD7427-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Jason,

thanks for your answer.

On Tue, Feb 10, 2015 at 11:00:39AM -0700, Jason Gunthorpe wrote:
> On Tue, Feb 10, 2015 at 04:56:43PM +0100, Fabian Holler wrote:
> 
> > Does anybody have an idea what could be wrong?
> > Are the PATH_MIG* notifications with mlx4 drivers are working for somebody?
> 
> IIRC rdmacm does not forward these events.
> 
> There is a lot missing to support APM with RDMA CM, it doesn't do any
> of the CM state machine operations to coordinate loading alternate
> paths, for instance.

Alternate paths can be set directly at the QP.

> > As soon as the migration happens I expect that a IB_EVENT_PATH_MIG* is
> > generated on the QP event handler, but I don't receive any QP events.
> 
> qp_event_handler is a RDMA CM event handler, it handles
> RDMA_CM_EVENT_* and there is no RDMA_CM_EVENT_PATH_MIGRATED.
> You'd need to listen to the verbs level events directly, I don't
> recall if this is possible with RDMA CM or not, sorry.

The RDMA CM event handler is registered by the rdma_create_id() call.

The event handler specified in the struct ib_qp_init_attr * parameter of
rdma_create_qp() is registered as QP event handler.
rdma_create_qp() calls ib_create_qp() and sets qp->event_handler to
ib_qp_init_attr->event_handler.


Fabian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

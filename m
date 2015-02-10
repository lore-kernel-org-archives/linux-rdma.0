From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4: IB_EVENT_PATH_MIG not generated on path migration
Date: Tue, 10 Feb 2015 22:26:46 +0100
Message-ID: <CAD+HZHX6hHwcWbT-W5kVi5-MPkzouyF1UR0BxzK__m73X3hdqw@mail.gmail.com>
References: <20150210155643.GB13690@fholler.de>
	<20150210180039.GD7427@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150210180039.GD7427-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2015-02-10 19:00 GMT+01:00 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>:
> On Tue, Feb 10, 2015 at 04:56:43PM +0100, Fabian Holler wrote:
>
>> Does anybody have an idea what could be wrong?
>> Are the PATH_MIG* notifications with mlx4 drivers are working for somebody?
>
> IIRC rdmacm does not forward these events.
Thanks Jason for reply.

We are working in kernel module, we subscribe qp_event_handler when
create qp, we've checked mlx4 driver(mlx4_core & mlx4_ib), looks they
do report qp event. But strangely we never receive the call in our
callback function.

Forgot to mention, the switch is from Qlogic, in case it matters.

Regards,
Jack

>
> There is a lot missing to support APM with RDMA CM, it doesn't do any
> of the CM state machine operations to coordinate loading alternate
> paths, for instance.
>
>> As soon as the migration happens I expect that a IB_EVENT_PATH_MIG* is
>> generated on the QP event handler, but I don't receive any QP events.
>
> qp_event_handler is a RDMA CM event handler, it handles
> RDMA_CM_EVENT_* and there is no RDMA_CM_EVENT_PATH_MIGRATED.
>
> You'd need to listen to the verbs level events directly, I don't
> recall if this is possible with RDMA CM or not, sorry.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

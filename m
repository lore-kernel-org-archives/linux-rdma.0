From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Deadlock on device removal event for NVMeF target
Date: Tue, 27 Jun 2017 14:31:57 -0500
Message-ID: <20170627193157.GA29768@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170626225920.GA11700@ssaleem-MOBL4.amr.corp.intel.com>
 <56030fcd-b8a0-fc0e-18e5-985ebf16a82e@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56030fcd-b8a0-fc0e-18e5-985ebf16a82e-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 27, 2017 at 12:37:51AM -0600, Sagi Grimberg wrote:
> > Hi Sagi/Christoph,
> 
> Hi Shiraz,
> 
> Please CC linux-nvme for nvme-rdma related stuff.
OK.

> > I am seeing a deadlock for a device removal event on NVMeF target.
> > 
> > The sequence of events leading to the deadlock are as follows,
> > 
> > 1. i40iw posts IW_CM_EVENT_CLOSE events for all QPs causing the corresponding
> > NVMet RDMA Queues to disconnect and schedule release of any pending work on WQ
> > 2. i40iw triggers device removal
> > 	ib_unregister_device
> > 	[..]
> > 	cma_remove_id_dev (takes a handler lock before calling the event handler)
> > 	nvmet_rdma_cm_handler
> > 	nvmet_rdma_device_removal (queue->state = NVMET_RDMA_Q_DISCONNECTING due to 1.)
> > 	flush_scheduled_work (blocks till all scheduled work is drained from WQ)
> > 	nvmet_rdma_release_queue_work (queue->state = NVMET_RDMA_Q_DISCONNECTING)
> > 	rdma_destroy_id (waits on the same handler lock as cma_remove_id_dev causing the deadlock)
> >       
> > So this problem can occur when there is a device removal event while the queue is in
> > disconnect state with the some oustanding work that hasnt been drained from the WQ at the
> > time flush_scheduled_work is called.
> 
> This indeed looks like a bug (thanks for reporting!). We indeed don't
> have sufficient information on where the queue release procedure is by
> only looking at the queue state, we can't tell if rdma_destroy_id was
> invoked and we can deadlock with rdma_destroy_id.
> 

 
> How about the (untested) alternative below:
> --
> [PATCH] nvmet-rdma: register ib_client to not deadlock in device
>   removal
> 
> We can deadlock in case we got to a device removal
> event on a queue which is already in the process of
> destroying the cm_id is this is blocking until all
> events on this cm_id will drain. On the other hand
> we cannot guarantee that rdma_destroy_id was invoked
> as we only have indication that the queue disconnect
> flow has been queued (the queue state is updated before
> the realease work has been queued).
> 
> So, we leave all the queue removal to a separate ib_client
> to avoid this deadlock as ib_client device removal is in
> a different context than the cm_id itself.
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---

Yes. This patch fixes the problem I am seeing.

Shiraz
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

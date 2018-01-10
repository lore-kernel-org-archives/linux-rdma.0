From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Wed, 10 Jan 2018 12:17:58 -0700
Message-ID: <20180110191758.GL4518@ziepe.ca>
References: <5a5016c0.4c0a620a.ed2b3.60da@mx.google.com>
 <fcc3f226-848d-abc4-2a81-f4fd821761c9@wdc.com>
 <1515528956.3919.3.camel@redhat.com>
 <1515529869.3919.4.camel@redhat.com>
 <1515531079.2721.26.camel@wdc.com>
 <1515531652.26021.1.camel@redhat.com>
 <1515537614.26021.3.camel@redhat.com>
 <1515591723.26021.6.camel@redhat.com>
 <20180110182648.GI4518@ziepe.ca>
 <1515609623.2745.20.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515609623.2745.20.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 06:40:25PM +0000, Bart Van Assche wrote:
> On Wed, 2018-01-10 at 11:26 -0700, Jason Gunthorpe wrote:
> > On Wed, Jan 10, 2018 at 08:42:03AM -0500, Laurence Oberman wrote:
> > 
> > > [  946.647514] kernel tried to execute NX-protected page - exploit
> > > attempt? (uid: 0)
> > > [  946.691954] BUG: unable to handle kernel paging request at
> > > 00000000a2129b93
> > > [  947.889552] Call Trace:
> > > [  947.903724]  ? __ib_process_cq+0x55/0xa0 [ib_core]
> > > [  947.931179]  ? ib_cq_poll_work+0x1b/0x60 [ib_core]
> > > [  947.958153]  ? process_one_work+0x141/0x340
> > > [  947.981362]  ? worker_thread+0x47/0x3e0
> > > [  948.002102]  ? kthread+0xf5/0x130
> > > [  948.020538]  ? rescuer_thread+0x380/0x380
> > > [  948.043180]  ? kthread_associate_blkcg+0x90/0x90
> > > [  948.070184]  ? ret_from_fork+0x1f/0x30
> > 
> > These oops's you have are very suggestive that ib_wc->wr_cqe
> > is garbage..
> > 
> > Did SRP free its wr_cqe data before completion somehow?
> > 
> > Turn on slab poisoning to confirm?
> 
> It's easy to see in drivers/infiniband/core/cq.c that polling is
> stopped before a completion queue is destroyed (see also the
> cancel_work_sync(&cq->work) and the cq->device->destroy_cq(cq) calls
> in ib_free_cq()).

But that has nothing directly to do with the lifetime of, say, struct
srp_request which contains ib_wc->wr_cqe?

eg freeing struct srp_request before the wrid has passed through the
CQ poll would produce these sorts of symptoms...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

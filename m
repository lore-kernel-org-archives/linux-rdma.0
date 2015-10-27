From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/sa: replace GFP_KERNEL with GFP_ATOMIC
Date: Tue, 27 Oct 2015 18:56:50 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB18571E3F@CRSMSX101.amr.corp.intel.com>
References: <saurabh.truth@gmail.com>
 <1445960860-3396-1-git-send-email-saurabh.truth@gmail.com>
 <20151027181235.GA27038@phlsvsds.ph.intel.com>
 <20151027181652.GA6879@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151027181652.GA6879-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Tuesday, October 27, 2015 2:17 PM
> To: Weiny, Ira
> Cc: Saurabh Sengar; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Hefty, Sean;
> hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org; Wan, Kaike; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] IB/sa: replace GFP_KERNEL with GFP_ATOMIC
> 
> On Tue, Oct 27, 2015 at 02:12:36PM -0400, ira.weiny wrote:
> > On Tue, Oct 27, 2015 at 09:17:40PM +0530, Saurabh Sengar wrote:
> > > replace GFP_KERNEL with GFP_ATOMIC, as code while holding a spinlock
> > > should be atomic GFP_KERNEL may sleep and can cause deadlock, where
> > > as GFP_ATOMIC may fail but certainly avoids deadlock
> >
> > Great catch.  Thanks!
> >
> > However, gfp_t is passed to send_mad and we should pass that down and
> use it.
> 
> >         spin_lock_irqsave(&ib_nl_request_lock, flags);
> > -       ret = ib_nl_send_msg(query);
> > +       ret = ib_nl_send_msg(query, gfp_mask);
> 
> A spin lock is guarenteed held around ib_nl_send_msg, so it's allocations
> have to be atomic, can't use gfp_mask here..
> 
> I do wonder if it is a good idea to call ib_nl_send_msg with a spinlock held
> though.. Would be nice to see that go away.

We have to hold the lock to protect against a race condition that a quick response will try to free the request from the ib_nl_request_list before we even put it on the list.

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

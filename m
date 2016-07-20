From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 0/3] iwarp device removal deadlock fix
Date: Wed, 20 Jul 2016 08:49:06 -0500
Message-ID: <027201d1e28d$7be227a0$73a676e0$@opengridcomputing.com>
References: <cover.1468879135.git.swise@opengridcomputing.com> <578F3A90.1000208@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <578F3A90.1000208-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > This RFC series attempts to address the deadlock issue discovered
> > while testing nvmf/rdma handling rdma device removal events from
> > the rdma_cm.
> 
> Thanks for doing this Steve!
> 
> > For a discussion of the deadlock that can happen, see
> >
> > http://lists.infradead.org/pipermail/linux-nvme/2016-July/005440.html.
> >
> > For my description of the deadlock itself, see this post in the above
thread:
> >
> > http://lists.infradead.org/pipermail/linux-nvme/2016-July/005465.html
> >
> > In a nutshell, iw_cxgb4 and the iw_cm block during qp/cm_id destruction
> > until all references are removed.  This combined with the iwarp CM passing
> > disconnect events up to the rdma_cm during disconnect and/or qp/cm_id
> destruction
> > leads to a deadlock.
> >
> > My proposed solution is to remove the need for iw_cxgb4 and iw_cm to
> > block during object destruction for the recnts to reach 0, but rather to
> > let the freeing of the object memory be deferred when the last deref is
> > done. This allows all the qps/cm_ids to be destroyed without blocking, and
> > all the object memory freeing ends up happinging when the application's
> > device_remove event handler function returns to the rdma_cm.
> 
> This sounds like a very good approach moving forward.
> 
> > Sean, I was hoping you could have a look at the iwcm.c patch particularly,
> > to tell my why its broken. :)  I spent some time trying to figure out
> > why we really need the CALLBACK_DESTROY flag, but I concluded it really
> > isn't needed.  The one side effect I see with my change, is that the
> > application could possibly get a cm_id event after it has destroyed the
> > cm_id.  There probably is a way to discard events that have a reference
> > on the cm_id but get processed after the app has destoyed the cm_id by
> > having a new flag indicating "destroyed by app".
> 

By the way, I think Sean is on sabbatical until 9/12. 

> That sounds easy enough. Does this mean that iwcm relies on the driver
> to do this or is it inter-operable with the existing logic? If not this
> will need to take care of all the iWARP drivers.

This can be handled all in the iw_cm module.  In fact, I'm testing a new version
of the iw_cm patch now.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

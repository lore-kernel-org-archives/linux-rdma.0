From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: use IB_CQ_REPORT_MISSED_EVENTS to avoid missed CQ callbacks
Date: Wed, 31 Mar 2010 17:12:05 -0700
Message-ID: <ada4ojwghey.fsf@roland-alpha.cisco.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
	<20100331175747.24522.88472.stgit@chromite.mv.qlogic.com>
	<ada4ojwjqz7.fsf@roland-alpha.cisco.com>
	<1270063245.4192.299.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1270063245.4192.299.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Wed, 31 Mar 2010 12:20:45 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The way I understand the sequence of events w/o the
 > patch is:
 > 
 > ib_req_notify_cq(IB_CQ_NEXT_COMP)
 > CQE 1 added to queue
 > 	callback scheduled via tasklet
 > 	future callbacks disarmed
 > callback function calls ib_req_notify_cq(IB_CQ_NEXT_COMP)
 > callback function calls ib_poll_cq() and gets CQE 1
 > callback function calls ib_poll_cq() and gets none
 > CQE 2 added to queue via IRQ
 > 	callback scheduled via tasklet
 > 	future callbacks disarmed
 > callback function returns
 > some time later, tasklet runs and calls CQ callback function.
 > callback function calls ib_req_notify_cq(IB_CQ_NEXT_COMP)
 > callback function calls ib_poll_cq() and gets CQE 2
 > 
 > Since a tasklet or workqueue can be scheduled in the
 > callback function, the second CQE isn't "missed" but
 > there is a scheduling delay before the callback happens
 > and sees CQE 2.

Sure but a tasklet at least is likely to have pretty low latency.  And
maybe there's a better chance of batching completion processing by
introducing a little delay there.  So maybe it helps, maybe it doesn't.

 > I'm willing to withdraw the 1-3 patches.
 > 
 > I still don't understand why the timing difference matters
 > to RDS.

I'd like to have some data showing an improvement before making this
change.  And as I already said it would be good to know what's really
going on with RDS before we change that.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

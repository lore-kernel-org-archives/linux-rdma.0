From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [NEW PATCH] IB/mad: Fix possible lock-lock-timer deadlock
Date: Mon, 07 Sep 2009 21:21:37 -0700
Message-ID: <adaskeym5gu.fsf@cisco.com>
References: <adaws4an4uh.fsf@cisco.com>
	<e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260909071327o7f521876s60d643b455e7c6ec-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Mon, 7 Sep 2009 22:27:14 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > With 2.6.31-rc9 + patch 4e49627b9bc29a14b393c480e8c979e3bc922ef7 + the
 > patch you posted at the start of this thread the following lockdep
 > complaint was triggered on the SRP initiator system during SRP login:
 > 
 > ======================================================
 > [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
 > 2.6.31-rc9 #2
 > ------------------------------------------------------
 > ibsrpdm/4290 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 >  (&(&rmpp_recv->cleanup_work)->timer){+.-...}, at:
 > [<ffffffff802559f0>] del_timer_sync+0x0/0xa0
 > 
 > and this task is already holding:
 >  (&mad_agent_priv->lock){..-...}, at: [<ffffffffa03c6de8>]
 > ib_cancel_rmpp_recvs+0x28/0x118 [ib_mad]
 > which would create a new lock dependency:
 >  (&mad_agent_priv->lock){..-...} -> (&(&rmpp_recv->cleanup_work)->timer){+.-...}

And this report doesn't happen with the older patch?  (Did you do the
same testing with the older patch that triggered this)

Because this looks like a *different* incarnation of the same
lock->lock->delayed work/timer that we're trying to fix here -- the
delayed work is now rmpp_recv->cleanup_work in this case instead of
mad_agent_priv->timed_work as it was before.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

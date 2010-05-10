From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 33/52] IB/qib: Add qib_sd7220.c
Date: Mon, 10 May 2010 15:50:16 -0700
Message-ID: <adahbmfxtg7.fsf@roland-alpha.cisco.com>
References: <20100506235849.3441.85930.stgit@chromite.mv.qlogic.com>
	<20100507000145.3441.59808.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100507000145.3441.59808.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 06 May 2010 17:01:45 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I don't think this is really a merge-blocker, but this code seems to
have faith in the talismanic power of atomic_t to avoid races in nearby
code.  The following anti-pattern appears in a few other variants in the
driver as well (just search for atomic_inc_return).

 > +		if (atomic_inc_return(&irp->relock_timer_active) == 1) {
 > +			init_timer(&irp->relock_timer);
 > +			irp->relock_timer.function = qib_run_relock;
 > +			irp->relock_timer.data = (unsigned long) dd;
 > +			irp->relock_interval = timeout;
 > +			irp->relock_timer.expires = jiffies + timeout;
 > +			add_timer(&irp->relock_timer);
 > +		} else {
 > +			irp->relock_interval = timeout;
 > +			mod_timer(&irp->relock_timer, jiffies + timeout);
 > +			atomic_dec(&irp->relock_timer_active);
 > +		}

Think about if two threads hit this code at the same time:

	if (atomic_inc_return(&active) == 1) {
		/* yep, first time through */

					if (atomic_inc_return(&active) == 1) {
						/* nope, go to else */
					} else {
						irp->relock_interval = timeout;
						/* err, who set up this timer? */
						mod_timer(&irp->relock_timer, jiffies + timeout);
						atomic_dec(&irp->relock_timer_active);
					}


		/* a bit too late, the timer might already have run */
		init_timer(&irp->relock_timer);
		irp->relock_timer.function = qib_run_relock;
		irp->relock_timer.data = (unsigned long) dd;
		irp->relock_interval = timeout;
		irp->relock_timer.expires = jiffies + timeout;
		add_timer(&irp->relock_timer);

Now, maybe this is safe because the code is actually never running
concurrently, but using this atomic_t relock_timer_active makes it
really hard to see that this code is safe.  Why not just use a proper
lock for this, since it doesn't look particularly performance critical
(and an atomic_t is really the same cost as a spinlock anyway)?

As I said, not a merge-blocker but it would be nice to get this fixed
someday before everyone loses interest in this driver.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

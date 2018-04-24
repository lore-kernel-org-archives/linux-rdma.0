From: Thomas Gleixner <tglx@linutronix.de>
Subject: RE: hrtimer (rdmavt RNR timer) was lost
Date: Tue, 24 Apr 2018 16:54:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1804241637390.1679@nanos.tec.linutronix.de>
References: <3F128C9216C9B84BB6ED23EF16290AFB634C8C87@CRSMSX101.amr.corp.intel.com> <alpine.DEB.2.21.1804231355570.2077@nanos.tec.linutronix.de> <3F128C9216C9B84BB6ED23EF16290AFB634C9420@CRSMSX101.amr.corp.intel.com>
 <alpine.DEB.2.21.1804231528130.2077@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1804231528130.2077@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wan, Kaike" <kaike.wan@intel.com>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Fleck, John" <john.fleck@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Apr 2018, Thomas Gleixner wrote:
> On Mon, 23 Apr 2018, Wan, Kaike wrote:
> > > Can you apply the following debug patch and enable the hrtimer_start trace
> > > point and send me the full trace or upload it somewhere?
> > 
> > The original trace was about 29GB and I filtered it with
> > "0000000066dda1ea" (the offending base) to generate a 1.4GB file that I
> > could open and investigate.  I am not sure how I can send them to you. Do
> > you have somewhere I can upload to?
> >
> > I can try your debug patch and again I am anticipating a big trace file.
> 
> Well, you can find the spot where the fail happens and then extract the
> full thing from 2s before that point to 1s after. That should be reasonably
> small and good enough. Let me know when you have it and how big it is
> (compressed) and we'll figure something out how to transport it.

Thanks for the more complete data which actually let me decode the wreckage.

So you have NO_HZ enabled and looking at the trace then this is related:

          <idle>-0     [003] dN.. 3598605307236: hrtimer_start: hrtimer=0000000004346740 function=tick_sched_timer expires=712171000000 softexpires=712171000000mode=ABS|PINNED base=0000000066dda1ea next=00000000708914d7
          <idle>-0     [003] dN.. 3598605307601: hrtimer_post_add: hrtimer=0000000004346740 function=tick_sched_timer base=0000000066dda1ea next=0000000004346740
	  
          <idle>-0     [002] d.h. 3598605313255: hrtimer_start: hrtimer=00000000662d2dd8 function=rvt_rc_rnr_retry [rdmavt] expires=712172915662 softexpires=712172915662mode=REL base=0000000066dda1ea next=0000000004346740
          <idle>-0     [002] d.h. 3599538740786: hrtimer_post_add: hrtimer=00000000662d2dd8 function=rvt_rc_rnr_retry [rdmavt] base=0000000066dda1ea next=00000000662d2dd8

          <idle>-0     [003] dn.. 3599538742242: hrtimer_pre_remove: hrtimer=0000000004346740 function=tick_sched_timer base=0000000066dda1ea next=00000000662d2dd8
          <idle>-0     [003] dn.. 3599538743084: hrtimer_post_remove: hrtimer=0000000004346740 function=tick_sched_timer base=0000000066dda1ea next=00000000662d2dd8
  
          <idle>-0     [003] dn.. 3599538743830: hrtimer_start: hrtimer=0000000004346740 function=tick_sched_timer expires=716767000000 softexpires=716767000000mode=ABS|PINNED base=0000000066dda1ea next=00000000662d2dd8
          <idle>-0     [003] dn.. 3599538744560: hrtimer_post_add: hrtimer=0000000004346740 function=tick_sched_timer base=0000000066dda1ea next=00000000662d2dd8

And staring at the NOHZ code I'm pretty sure, I know what happens.

CPU 3						CPU 2

idle
start tick_sched_timer 712171000000
						start rdmavt timer 712172915662
						lock(base)
tick_nohz_stop_tick()
tick = 716767000000				timerqueue_add(tmr)

hrtimer_set_expires(&ts->sched_timer, tick); <---- FAIL

						    if (tmr->exp < queue->next->exp)
hrtimer_start(sched_timer)			        queue->next = tmr;
lock(base)
						unlock(base)
timerqueue_remove()
timerqueue_add()
....

So ts->sched_timer is still queued and queue->next is pointing to it, but
then expires is modified. So the other side sees the new expiry time and
makes the rdmavt timer the new queue->next. All f*cked from there.

The problem was introduced with:

  d4af6d933ccf ("nohz: Fix spurious warning when hrtimer and clockevent get out of sync")

The changelog is not really helpful, but I can't see why the expiry time of
ts->sched_timer should be updated before the timer is [re]started in case
of HIGHRES + NOHZ. hrtimer_start() sets the expiry time, so that should be
sufficient. Of course the tick needs to be stored in ts->sched_timer for
the !HIGHRES + HOHZ case, but that's trivial enough to do. Patch against
Linus tree below. It's easy to backport in case you want to run it against
the kernel which made the observation simpler.

I need to come up with integration of hrtimer_set_expires() into debug
objects to catch this kind of horrors. Groan....

Thanks,

	tglx

8<-----------
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -804,12 +804,12 @@ static void tick_nohz_stop_tick(struct t
 		return;
 	}
 
-	hrtimer_set_expires(&ts->sched_timer, tick);
-
-	if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
-		hrtimer_start_expires(&ts->sched_timer, HRTIMER_MODE_ABS_PINNED);
-	else
+	if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
+		hrtimer_start(&ts->sched_timer, tick, HRTIMER_MODE_ABS_PINNED);
+	} else {
+		hrtimer_set_expires(&ts->sched_timer, tick);
 		tick_program_event(tick, 1);
+	}
 }
 
 static void tick_nohz_retain_tick(struct tick_sched *ts)

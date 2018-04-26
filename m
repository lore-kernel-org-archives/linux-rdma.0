From: "Wan, Kaike" <kaike.wan@intel.com>
Subject: RE: [PATCH] tick/sched: Do not mess with an enqueued hrtimer
Date: Thu, 26 Apr 2018 12:56:11 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB634CACE9@CRSMSX101.amr.corp.intel.com>
References: <alpine.DEB.2.21.1804242119210.1597@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1804242119210.1597@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Fleck, John" <john.fleck@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Thomas Gleixner
> Sent: Tuesday, April 24, 2018 3:22 PM
> To: Frederic Weisbecker <frederic@kernel.org>
> Cc: Wan, Kaike <kaike.wan@intel.com>; Marciniszyn, Mike
> <mike.marciniszyn@intel.com>; Dalessandro, Dennis
> <dennis.dalessandro@intel.com>; Weiny, Ira <ira.weiny@intel.com>; Fleck,
> John <john.fleck@intel.com>; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; Peter Zijlstra <peterz@infradead.org>; Anna-Maria
> Gleixner <anna-maria@linutronix.de>; Frederic Weisbecker
> <fweisbec@gmail.com>; Ingo Molnar <mingo@kernel.org>
> Subject: [PATCH] tick/sched: Do not mess with an enqueued hrtimer
> 
> Kaike reported that in tests rdma hrtimers occasionaly stopped working. He
> did great debugging, which provided enough context to decode the problem.
> 
> CPU 3			     	      	     CPU 2
> 
> idle
> start sched_timer expires = 712171000000  queue->next = sched_timer
> 					    start rdmavt timer. expires =
> 712172915662
> 					    lock(baseof(CPU3))
> tick_nohz_stop_tick()
> tick = 716767000000			    timerqueue_add(tmr)
> 
> hrtimer_set_expires(sched_timer, tick);
>   sched_timer->expires = 716767000000  <---- FAIL
> 					     if (tmr->expires < queue->next-
> >expires)
> hrtimer_start(sched_timer)		          queue->next = tmr;
> lock(baseof(CPU3))
> 					     unlock(baseof(CPU3))
> timerqueue_remove()
> timerqueue_add()
> 
> ts->sched_timer is queued and queue->next is pointing to it, but then
> ts->sched_timer.expires is modified.
> 
> This not only corrupts the ordering of the timerqueue RB tree, it also makes
> CPU2 see the new expiry time of timerqueue->next->expires when checking
> whether timerqueue->next needs to be updated. So CPU2 sees that the
> rdma timer is earlier than timerqueue->next and sets the rdma timer as new
> next.
> 
> Depending on whether it had also seen the new time at RB tree enqueue, it
> might have queued the rdma timer at the wrong place and then after
> removing the sched_timer the RB tree is completely hosed.
> 
> The problem was introduced with a commit which tried to solve
> inconsistency between the hrtimer in the tick_sched data and the underlying
> hardware clockevent. It split out hrtimer_set_expires() to store the new tick
> time in both the NOHZ and the NOHZ + HIGHRES case, but missed the fact
> that in the NOHZ + HIGHRES case the hrtimer might still be queued.
> 
> Use hrtimer_start(timer, tick...) for the NOHZ + HIGHRES case which sets
> timer->expires after canceling the timer and move the
> timer->hrtimer_set_expires()
> invocation into the NOHZ only code path which is not affected as it merily
> uses the hrtimer as next event storage so code pathes can be shared with
> the NOHZ + HIGHRES case.
> 
> Fixes: d4af6d933ccf ("nohz: Fix spurious warning when hrtimer and
> clockevent get out of sync")
> Reported-by: "Wan Kaike" <kaike.wan@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: "Marciniszyn Mike" <mike.marciniszyn@intel.com>
> Cc: Anna-Maria Gleixner <anna-maria@linutronix.de>
> Cc: linux-rdma@vger.kernel.org
> Cc: "Dalessandro Dennis" <dennis.dalessandro@intel.com>
> Cc: "Fleck John" <john.fleck@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: "Weiny Ira" <ira.weiny@intel.com>
> Cc: "linux-rdma@vger.kernel.org"
> Cc: stable@vger.kernel.org
> Link:
> https://lkml.kernel.org/r/alpine.DEB.2.21.1804241637390.1679@nanos.tec.lin
> utronix.de
> 
> ---
>  kernel/time/tick-sched.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -804,12 +804,12 @@ static void tick_nohz_stop_tick(struct t
>  		return;
>  	}
> 
> -	hrtimer_set_expires(&ts->sched_timer, tick);
> -
> -	if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
> -		hrtimer_start_expires(&ts->sched_timer,
> HRTIMER_MODE_ABS_PINNED);
> -	else
> +	if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
> +		hrtimer_start(&ts->sched_timer, tick,
> HRTIMER_MODE_ABS_PINNED);
> +	} else {
> +		hrtimer_set_expires(&ts->sched_timer, tick);
>  		tick_program_event(tick, 1);
> +	}
>  }
> 
>  static void tick_nohz_retain_tick(struct tick_sched *ts)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


Tested-by: Kaike Wan <Kaike.wan@intel.com>

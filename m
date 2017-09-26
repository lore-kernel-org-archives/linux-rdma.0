From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Tue, 26 Sep 2017 10:56:50 -0400
Message-ID: <20170926105650.43314134@vmware.local.home>
References: <20170925144949.GP29668@kernel.org>
        <20170925211447.GL29872@jcartwri.amer.corp.natinst.com>
        <32E1700B9017364D9B60AED9960492BC3441B3BD@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC3441B3BD-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Julia Cartwright <julia-acOepvfBmUk@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Andrzej Siewior <sebastian.siewior-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 26 Sep 2017 14:10:52 +0000
"Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > My first question would be: is disabling preemption here really
> > necessary?
> >   
> 
> The motivation for the preempt manipulation has nothing to do with
> the counter.
> 
> The buffer allocation returns a set of ringed write-combining 64B
> MMIO buffers.   The allocate lock is then dropped right after
> allocation to allow parallel allocates.
> 
> The hardware keeps track of the buffer fill across multiple CPUs, so
> that after the oldest buffer is copied the ring is advanced.
> 
> The idea was to minimize the time from the drop of the allocate lock
> to the end of the copy to insure the highest rate of copy to the ring
> from multiple cores.
> 
> > AFAICT, preemption is only disabled to protect the access of the
> > 'buffers_allocated' percpu counters, nothing else.
> >
> > However, because these counters are only observed in aggregate,
> > across CPUs (see get_buffers_allocated()), the sum will be the
> > same, regardless of a thread is migrated between a
> > this_cpu_inc(buffers_allocated) and a
> > this_cpu_dec(buffers_allocated). 
> 
> The counter exists purely as a hot path optimization to avoid an
> atomic.
> 
> The only time an accurate counter is required is during reset
> sequences to wait for allocate/copy pairs to finish and we don't care
> if the closing decrement is on the same core.
> 
> The percpu refcount might be a better choice, but I don't think it
> existed at the time the code was written.
> 
> > If that's the case, perhaps the fix is as easy as removing the
> > preempt_disable() and preempt_enable()?
> >   
> 
> That would certainly be the easiest solution, but would compromise
> performance if a migration occurs after the allocate lock is dropped.

local_lock() disables migration. It's currently only in the -rt patch.
It's made to allow preemption to occur as much as possible, as -rt
cares about reaction time more than performance (although, we would
love to keep performance as well).

> 
> We have been looking at the patch that was submitted for using the
> raw spin lock and we share Arnaldo's concern, particularly mixing
> lock types.
> 
> Other locks can be procured in the timeout case in
> sc_wait_for_packet_egress() inside queue_work() and
> dd_dev_err()/printk().
> 

A raw_spin_lock sacrifices reaction time, which goes against the goal
of -rt. When PREEMPT_RT is disabled, the local_lock becomes
preempt_disable, so it has no affect on the vanilla kernel.

-- Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

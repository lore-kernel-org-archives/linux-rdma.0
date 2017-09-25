From: Julia Cartwright <julia-acOepvfBmUk@public.gmane.org>
Subject: Re: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Mon, 25 Sep 2017 16:14:47 -0500
Message-ID: <20170925211447.GL29872@jcartwri.amer.corp.natinst.com>
References: <20170925144949.GP29668@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170925144949.GP29668-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Andrzej Siewior <sebastian.siewior-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 25, 2017 at 11:49:49AM -0300, Arnaldo Carvalho de Melo wrote:
> Hi,
> 
> 	I'm trying to get an Infiniband test case working with the RT
> kernel, and ended over tripping over this case:
> 
> 	In drivers/infiniband/hw/hfi1/pio.c sc_buffer_alloc() disables
> preemption that will be reenabled by either pio_copy() or
> seg_pio_copy_end().

Perhaps it's worth revisiting why this design decision was chosen in the
first place?  The introducing commit, a054374f15428cbc1
("staging/rdma/hfi1: convert buffers allocated atomic to per cpu")
mentions the previous atomic as being expensive, but the usage of
preempt_disable()/preempt_enable() is also expensive, albeit in a
different way.

My first question would be: is disabling preemption here really
necessary?

AFAICT, preemption is only disabled to protect the access of the
'buffers_allocated' percpu counters, nothing else.

However, because these counters are only observed in aggregate, across
CPUs (see get_buffers_allocated()), the sum will be the same, regardless
of a thread is migrated between a this_cpu_inc(buffers_allocated) and a
this_cpu_dec(buffers_allocated).

If that's the case, perhaps the fix is as easy as removing the
preempt_disable() and preempt_enable()?

   Julia

PS. Perhaps a longer term approach would be to investigate whether the
usage of percpu_ref or percpu_counter is a better fit for this driver.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

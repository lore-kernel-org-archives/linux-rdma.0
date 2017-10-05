From: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Thu, 5 Oct 2017 13:53:05 -0300
Message-ID: <20171005165305.GN25388@kernel.org>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-2-acme@kernel.org>
 <20171005141744.GC21185@jcartwri.amer.corp.natinst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171005141744.GC21185-ew3lsbMjNqt5wtABiV/Xjqyly8cj88Ttqxv4g6HH51o@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Cartwright <julia-acOepvfBmUk@public.gmane.org>
Cc: bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Andrzej Siewior <sebastian.siewior-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Em Thu, Oct 05, 2017 at 09:17:44AM -0500, Julia Cartwright escreveu:
> On Tue, Oct 03, 2017 at 12:49:19PM -0300, Arnaldo Carvalho de Melo wrote:
> > +++ b/drivers/infiniband/hw/hfi1/pio.c
> > @@ -1421,7 +1421,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,

> >  	/* there is enough room */

> > -	preempt_disable();
> > +	preempt_disable_nort();
> >  	this_cpu_inc(*sc->buffers_allocated);

> Have you tried this on RT w/ CONFIG_DEBUG_PREEMPT?

No

> I believe that the this_cpu_* operations perform a preemption check, which we'd trip.

Humm, looking at include/linux/percpu-defs.h on v4.11.12-rt14 I see
(trimmed to what we're discussing here):

#ifdef CONFIG_DEBUG_PREEMPT
extern void __this_cpu_preempt_check(const char *op);
#else
static inline void __this_cpu_preempt_check(const char *op) { }
#endif

#define __this_cpu_add(pcp, val)					\
({									\
	__this_cpu_preempt_check("add");				\
	raw_cpu_add(pcp, val);						\
})
#define __this_cpu_inc(pcp)		__this_cpu_add(pcp, 1)

/*
 * Operations with implied preemption/interrupt protection.  These
 * operations can be used without worrying about preemption or interrupt.
 */
#define this_cpu_add(pcp, val)          __pcpu_size_call(this_cpu_add_, pcp, val)
#define this_cpu_inc(pcp)               this_cpu_add(pcp, 1)
 
> You may also have to change these to the non-preempt checked variants.

So __this_cpu_inc() checks preemption but this_cpu_inc() doesn't and
thus we're ok here? Or am I getting lost in this maze of defines? :-)

- Arnaldo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

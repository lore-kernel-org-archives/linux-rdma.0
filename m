From: Julia Cartwright <julia@ni.com>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Thu, 5 Oct 2017 13:29:00 -0500
Message-ID: <20171005182900.GK647@jcartwri.amer.corp.natinst.com>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-2-acme@kernel.org>
 <20171005141744.GC21185@jcartwri.amer.corp.natinst.com>
 <20171005165305.GN25388@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171005165305.GN25388@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: bigeasy@linutronix.de, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 05, 2017 at 01:53:05PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 05, 2017 at 09:17:44AM -0500, Julia Cartwright escreveu:
> > On Tue, Oct 03, 2017 at 12:49:19PM -0300, Arnaldo Carvalho de Melo wrote:
> > > +++ b/drivers/infiniband/hw/hfi1/pio.c
> > > @@ -1421,7 +1421,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
> 
> > >  	/* there is enough room */
> 
> > > -	preempt_disable();
> > > +	preempt_disable_nort();
> > >  	this_cpu_inc(*sc->buffers_allocated);
> 
> > Have you tried this on RT w/ CONFIG_DEBUG_PREEMPT?
> 
> No
> 
> > I believe that the this_cpu_* operations perform a preemption check, which we'd trip.
>
> Humm, looking at include/linux/percpu-defs.h on v4.11.12-rt14 I see
> (trimmed to what we're discussing here):
>
> #ifdef CONFIG_DEBUG_PREEMPT
> extern void __this_cpu_preempt_check(const char *op);
> #else
> static inline void __this_cpu_preempt_check(const char *op) { }
> #endif
>
> #define __this_cpu_add(pcp, val)					\
> ({									\
> 	__this_cpu_preempt_check("add");				\
> 	raw_cpu_add(pcp, val);						\
> })
> #define __this_cpu_inc(pcp)		__this_cpu_add(pcp, 1)
>
> /*
>  * Operations with implied preemption/interrupt protection.  These
>  * operations can be used without worrying about preemption or interrupt.
>  */
> #define this_cpu_add(pcp, val)          __pcpu_size_call(this_cpu_add_, pcp, val)
> #define this_cpu_inc(pcp)               this_cpu_add(pcp, 1)
>
> > You may also have to change these to the non-preempt checked variants.
>
> So __this_cpu_inc() checks preemption but this_cpu_inc() doesn't and
> thus we're ok here? Or am I getting lost in this maze of defines? :-)

I think I was the one lost in the maze.  You are correct.  Sorry for the
confusion.

My mind expected that the __ prefixed versions would be the "raw"
versions that are free of checks, with the checks made in the non
prefixed versions, but it is the other way around.

I'm happy to accept that the bug is within my mind.

   Julia

From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Thu, 5 Oct 2017 18:16:23 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1710051808280.2083@nanos>
References: <20171003154920.31566-1-acme@kernel.org> <20171003154920.31566-2-acme@kernel.org> <20171005141744.GC21185@jcartwri.amer.corp.natinst.com> <alpine.DEB.2.20.1710051726490.2083@nanos> <20171005153759.GG647@jcartwri.amer.corp.natinst.com>
 <20171005115539.7daafb66@gandalf.local.home> <20171005160535.GI647@jcartwri.amer.corp.natinst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171005160535.GI647@jcartwri.amer.corp.natinst.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Cartwright <julia@ni.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, bigeasy@linutronix.de, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, 5 Oct 2017, Julia Cartwright wrote:

> On Thu, Oct 05, 2017 at 11:55:39AM -0400, Steven Rostedt wrote:
> > On Thu, 5 Oct 2017 10:37:59 -0500
> > Julia Cartwright <julia@ni.com> wrote:
> > 
> > > On Thu, Oct 05, 2017 at 05:27:30PM +0200, Thomas Gleixner wrote:
> > > > On Thu, 5 Oct 2017, Julia Cartwright wrote:  
> > > > > On Tue, Oct 03, 2017 at 12:49:19PM -0300, Arnaldo Carvalho de Melo wrote:  
> > > > > > -	preempt_disable();
> > > > > > +	preempt_disable_nort();
> > > > > >  	this_cpu_inc(*sc->buffers_allocated);  
> > > > > 
> > > > > Have you tried this on RT w/ CONFIG_DEBUG_PREEMPT?  I believe that the
> > > > > this_cpu_* operations perform a preemption check, which we'd trip.  
> > > > 
> > > > Good point. Changing this to migrate_disable() would do the trick.  
> > > 
> > > Wouldn't we still trip the preempt check even with migration disabled?
> > > In another thread I asked the same question: should the preemption
> > > checks here be converted to migration-checks in RT?
> > 
> > Is it a "preemption check"?
> 
> Sorry if I was unclear, more precisely: the this_cpu_* family of
> accessors, w/ CONFIG_DEBUG_PREEMPT currently spits out a warning when
> the caller is invoked in a context where preemption is enabled.
> 
> The check is shared w/ the smp_processor_id() check, as implemented in
> lib/smp_processor_id.c.  It effectively boils down to a check of
> preempt_count() and irqs_disabled().

Except that on RT that check cares about the migrate disable state. You can
invoke this_cpu_* and smp_processor_id() in preemptible/interruptible
context because of:

	if (cpumask_equal(current->cpus_ptr, cpumask_of(this_cpu)))
		goto out;

That's true even on mainline.

But you are right that this check needs some update because
migrate_disable() does not immediately update the allowed cpumask IIRC.

Thanks,

	tglx

From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Tue, 26 Sep 2017 14:10:52 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC3441B3BD@fmsmsx120.amr.corp.intel.com>
References: <20170925144949.GP29668@kernel.org>
 <20170925211447.GL29872@jcartwri.amer.corp.natinst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20170925211447.GL29872@jcartwri.amer.corp.natinst.com>
Content-Language: en-US
Sender: linux-rt-users-owner@vger.kernel.org
To: Julia Cartwright <julia@ni.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>, "Luick, Dean" <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, "Wan, Kaike" <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, "Sanchez, Sebastian" <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> > Hi,
> >
> > 	I'm trying to get an Infiniband test case working with the RT
> > kernel, and ended over tripping over this case:
> >
> > 	In drivers/infiniband/hw/hfi1/pio.c sc_buffer_alloc() disables
> > preemption that will be reenabled by either pio_copy() or
> > seg_pio_copy_end().
> 
> Perhaps it's worth revisiting why this design decision was chosen in the
> first place?  The introducing commit, a054374f15428cbc1
> ("staging/rdma/hfi1: convert buffers allocated atomic to per cpu")
> mentions the previous atomic as being expensive, but the usage of
> preempt_disable()/preempt_enable() is also expensive, albeit in a
> different way.
> 
> My first question would be: is disabling preemption here really
> necessary?
> 

The motivation for the preempt manipulation has nothing to do with the counter.

The buffer allocation returns a set of ringed write-combining 64B MMIO buffers.   The allocate lock is then dropped right after allocation to allow parallel allocates.

The hardware keeps track of the buffer fill across multiple CPUs, so that after the oldest buffer is copied the ring is advanced.

The idea was to minimize the time from the drop of the allocate lock to the end of the copy to insure the highest rate of copy to the ring from multiple cores.

> AFAICT, preemption is only disabled to protect the access of the
> 'buffers_allocated' percpu counters, nothing else.
>
> However, because these counters are only observed in aggregate, across
> CPUs (see get_buffers_allocated()), the sum will be the same, regardless
> of a thread is migrated between a this_cpu_inc(buffers_allocated) and a
> this_cpu_dec(buffers_allocated).
> 

The counter exists purely as a hot path optimization to avoid an atomic.

The only time an accurate counter is required is during reset sequences to wait for allocate/copy pairs to finish and we don't care if the closing decrement is on the same core.

The percpu refcount might be a better choice, but I don't think it existed at the time the code was written.

> If that's the case, perhaps the fix is as easy as removing the
> preempt_disable() and preempt_enable()?
> 

That would certainly be the easiest solution, but would compromise performance if a migration occurs after the allocate lock is dropped.

We have been looking at the patch that was submitted for using the raw spin lock and we share Arnaldo's concern, particularly mixing lock types.

Other locks can be procured in the timeout case in sc_wait_for_packet_egress() inside queue_work() and dd_dev_err()/printk().

Mike
 

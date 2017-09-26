From: Julia Cartwright <julia@ni.com>
Subject: Re: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Tue, 26 Sep 2017 16:00:45 -0500
Message-ID: <20170926210045.GO29872@jcartwri.amer.corp.natinst.com>
References: <20170925144949.GP29668@kernel.org>
 <20170925211447.GL29872@jcartwri.amer.corp.natinst.com>
 <32E1700B9017364D9B60AED9960492BC3441B3BD@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC3441B3BD@fmsmsx120.amr.corp.intel.com>
Sender: linux-rt-users-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>, "Luick, Dean" <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, "Wan, Kaike" <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, "Sanchez, Sebastian" <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 26, 2017 at 02:10:52PM +0000, Marciniszyn, Mike wrote:
> > > Hi,
> > >
> > > 	I'm trying to get an Infiniband test case working with the RT
> > > kernel, and ended over tripping over this case:
> > >
> > > 	In drivers/infiniband/hw/hfi1/pio.c sc_buffer_alloc() disables
> > > preemption that will be reenabled by either pio_copy() or
> > > seg_pio_copy_end().
> > 
> > Perhaps it's worth revisiting why this design decision was chosen in the
> > first place?  The introducing commit, a054374f15428cbc1
> > ("staging/rdma/hfi1: convert buffers allocated atomic to per cpu")
> > mentions the previous atomic as being expensive, but the usage of
> > preempt_disable()/preempt_enable() is also expensive, albeit in a
> > different way.
> > 
> > My first question would be: is disabling preemption here really
> > necessary?
> > 
>
> The motivation for the preempt manipulation has nothing to do with the counter.
>
> The buffer allocation returns a set of ringed write-combining 64B MMIO
> buffers.   The allocate lock is then dropped right after allocation to
> allow parallel allocates.
>
> The hardware keeps track of the buffer fill across multiple CPUs, so
> that after the oldest buffer is copied the ring is advanced.
>
> The idea was to minimize the time from the drop of the allocate lock
> to the end of the copy to insure the highest rate of copy to the ring
> from multiple cores.

Okay, so to be clear, disabling preemption here is strictly a
performance consideration, not a correctness one?

> > If that's the case, perhaps the fix is as easy as removing the
> > preempt_disable() and preempt_enable()?
> > 
> 
> That would certainly be the easiest solution, but would compromise
> performance if a migration occurs after the allocate lock is dropped.

Given this response, I'm assuming that to be the case.

Disabling preemption to avoid "compromising performance", presumes a
very specific definition of "performance" that does not apply _in
general_, and certainly does not apply for RT users, who care more for
"response time" (as Steven put it).

Instead, the kernel already directly provides tools for _users_ to make
decisions about what the relative portions of their workloads are,
namely scheduling parameters, CPU affinities, isolcpus, etc.  Why are
these not sufficient in this case?

In addition, the use of local locks is a waste here, they provide more
guarantees than is actually necessary; this driver will function fine if
more than two threads on the same CPU are within this "critical
section".  If you want to maintain preempt_disable()/_enable() in
non-RT, then whatever, use the preempt_disable_nort()/_enable_nort()
varieties.

   Julia

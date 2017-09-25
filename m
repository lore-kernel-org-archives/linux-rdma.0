From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Mon, 25 Sep 2017 16:45:13 -0300
Message-ID: <20170925194513.GA25735@kernel.org>
References: <20170925144949.GP29668@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170925144949.GP29668@kernel.org>
Sender: linux-rt-users-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, Jubin John <jubin.john@intel.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Peter Zijlstra <peterz@infradead.org>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Em Mon, Sep 25, 2017 at 11:49:49AM -0300, Arnaldo Carvalho de Melo escreveu:
> 	I'm trying to get an Infiniband test case working with the RT
> kernel, and ended over tripping over this case:
> 
> 	In drivers/infiniband/hw/hfi1/pio.c sc_buffer_alloc() disables
> preemption that will be reenabled by either pio_copy() or
> seg_pio_copy_end().
> 
> 	But before disabling preemption it grabs a spin lock that will
> be dropped after it disables preemption, which ends up triggering a
> warning in migrate_disable() later on.
> 
>   spin_lock_irqsave(&sc->alloc_lock)
>     migrate_disable() ++p->migrate_disable -> 2
>   preempt_disable()
>   spin_unlock_irqrestore(&sc->alloc_lock)
>     migrate_enable() in_atomic(), so just returns, migrate_disable stays at 2
>   spin_lock_irqsave(some other lock) -> b00m

Sebastian, perhaps use local locks like you did for the random.c case?
I'll study to see if that is possible...

I mean this patch:

https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/commit/drivers/char/random.c?h=linux-4.11.y-rt&id=4bed11300e24d5178829758e535cc4996490b7c8

-------------
random: avoid preempt_disable()ed section
extract_crng() will use sleeping locks while in a preempt_disable()
section due to get_cpu_var().
Work around it with local_locks.

Cc: stable-rt@vger.kernel.org # where it applies to
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
-------------

- Arnaldo

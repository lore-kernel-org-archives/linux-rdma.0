From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Mon, 25 Sep 2017 16:15:28 -0400
Message-ID: <20170925161528.52d34769@vmware.local.home>
References: <20170925144949.GP29668@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170925144949.GP29668-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Andrzej Siewior <sebastian.siewior-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 25 Sep 2017 11:49:49 -0300
Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hi,
> 
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
> 
>     And the WARN_ON code ends up tripping over this over and over in
>     log_store().
>     
>     Sequence captured via ftrace_dump_on_oops + crash utility 'dmesg'
>     command.
>     
>     [512258.613862] sm-3297 16 .....11 359465349134644: sc_buffer_alloc <-hfi1_verbs_send_pio
>     [512258.613876] sm-3297 16 .....11 359465349134719: migrate_disable <-sc_buffer_alloc
>     [512258.613890] sm-3297 16 .....12 359465349134798: rt_spin_lock <-sc_buffer_alloc
>     [512258.613903] sm-3297 16 ....112 359465349135481: rt_spin_unlock <-sc_buffer_alloc
>     [512258.613916] sm-3297 16 ....112 359465349135556: migrate_enable <-sc_buffer_alloc
>     [512258.613935] sm-3297 16 ....112 359465349135788: seg_pio_copy_start <-hfi1_verbs_send_pio
>     [512258.613954] sm-3297 16 ....112 359465349136273: update_sge <-hfi1_verbs_send_pio
>     [512258.613981] sm-3297 16 ....112 359465349136373: seg_pio_copy_mid <-hfi1_verbs_send_pio
>     [512258.613999] sm-3297 16 ....112 359465349136873: update_sge <-hfi1_verbs_send_pio
>     [512258.614017] sm-3297 16 ....112 359465349136956: seg_pio_copy_mid <-hfi1_verbs_send_pio
>     [512258.614035] sm-3297 16 ....112 359465349137221: seg_pio_copy_end <-hfi1_verbs_send_pio
>     [512258.614048] sm-3297 16 .....12 359465349137360: migrate_disable <-hfi1_verbs_send_pio
>     [512258.614065] sm-3297 16 .....12 359465349137476: warn_slowpath_null <-migrate_disable
>     [512258.614081] sm-3297 16 .....12 359465349137564: __warn <-warn_slowpath_null
>     [512258.614088] sm-3297 16 .....12 359465349137958: printk <-__warn
>     [512258.614096] sm-3297 16 .....12 359465349138055: vprintk_default <-printk
>     [512258.614104] sm-3297 16 .....12 359465349138144: vprintk_emit <-vprintk_default
>     [512258.614111] sm-3297 16 d....12 359465349138312: _raw_spin_lock <-vprintk_emit
>     [512258.614119] sm-3297 16 d...112 359465349138789: log_store <-vprintk_emit
>     [512258.614127] sm-3297 16 .....12 359465349139068: migrate_disable <-vprintk_emit
> 
> I'm wondering if turning this sc->alloc_lock to a raw_spin_lock is the
> right solution, which I'm afraid its not, as there are places where it
> is held and then the code goes on to grab other non-raw spinlocks...

No, the correct solution is to convert the preempt_disable into a
local_lock(), which will be a preempt_disable when PREEMPT_RT is not
set. Look for other patches that convert preempt_disable() into
local_lock()s for examples.

-- Steve

> 
> I got this patch in my test branch and it makes the test case go further
> before splatting on other problems with infiniband + PREEMPT_RT_FULL,
> but as I said, I fear its not the right solution, ideas?
> 
> The kernel I'm seing this is RHEL's + the PREEMPT_RT_FULL patch:
> 
> Linux version 3.10.0-709.rt56.636.test.el7.x86_64 (acme@seventh) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC) ) #
> 1 SMP PREEMPT RT Wed Sep 20 18:04:55 -03 2017
> 
> I will try and build with the latest PREEMPT_RT_FULL patch, but the
> infiniband codebase in RHEL seems to be up to what is upstream and
> I just looked at patches-4.11.12-rt14/add_migrate_disable.patch and that
> WARN_ON_ONCE(p->migrate_disable_atomic) is still there :-\
> 
> - Arnaldo
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

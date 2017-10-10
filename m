From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Tue, 10 Oct 2017 14:59:18 -0400
Message-ID: <1d06a3da-426f-c887-1da7-64b760c53425@intel.com>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-2-acme@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171003154920.31566-2-acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Cc: linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Andrzej Siewior <sebastian.siewior-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/3/2017 11:49 AM, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> sc_buffer_alloc() disables preemption that will be reenabled by either
> pio_copy() or seg_pio_copy_end(). But before disabling preemption it
> grabs a spin lock that will be dropped after it disables preemption,
> which ends up triggering a warning in migrate_disable() later on.
> 
>      spin_lock_irqsave(&sc->alloc_lock)
>        migrate_disable() ++p->migrate_disable -> 2
>      preempt_disable()
>      spin_unlock_irqrestore(&sc->alloc_lock)
>        migrate_enable() in_atomic(), so just returns, migrate_disable stays at 2
>      spin_lock_irqsave(some other lock) -> b00m
> 
> And the WARN_ON code ends up tripping over this over and over in
> log_store().
> 
> Sequence captured via ftrace_dump_on_oops + crash utility 'dmesg'
> command.
> 
> [512258.613862] sm-3297 16 .....11 359465349134644: sc_buffer_alloc <-hfi1_verbs_send_pio
> [512258.613876] sm-3297 16 .....11 359465349134719: migrate_disable <-sc_buffer_alloc
> [512258.613890] sm-3297 16 .....12 359465349134798: rt_spin_lock <-sc_buffer_alloc
> [512258.613903] sm-3297 16 ....112 359465349135481: rt_spin_unlock <-sc_buffer_alloc
> [512258.613916] sm-3297 16 ....112 359465349135556: migrate_enable <-sc_buffer_alloc
> [512258.613935] sm-3297 16 ....112 359465349135788: seg_pio_copy_start <-hfi1_verbs_send_pio
> [512258.613954] sm-3297 16 ....112 359465349136273: update_sge <-hfi1_verbs_send_pio
> [512258.613981] sm-3297 16 ....112 359465349136373: seg_pio_copy_mid <-hfi1_verbs_send_pio
> [512258.613999] sm-3297 16 ....112 359465349136873: update_sge <-hfi1_verbs_send_pio
> [512258.614017] sm-3297 16 ....112 359465349136956: seg_pio_copy_mid <-hfi1_verbs_send_pio
> [512258.614035] sm-3297 16 ....112 359465349137221: seg_pio_copy_end <-hfi1_verbs_send_pio
> [512258.614048] sm-3297 16 .....12 359465349137360: migrate_disable <-hfi1_verbs_send_pio
> [512258.614065] sm-3297 16 .....12 359465349137476: warn_slowpath_null <-migrate_disable
> [512258.614081] sm-3297 16 .....12 359465349137564: __warn <-warn_slowpath_null
> [512258.614088] sm-3297 16 .....12 359465349137958: printk <-__warn
> [512258.614096] sm-3297 16 .....12 359465349138055: vprintk_default <-printk
> [512258.614104] sm-3297 16 .....12 359465349138144: vprintk_emit <-vprintk_default
> [512258.614111] sm-3297 16 d....12 359465349138312: _raw_spin_lock <-vprintk_emit
> [512258.614119] sm-3297 16 d...112 359465349138789: log_store <-vprintk_emit
> [512258.614127] sm-3297 16 .....12 359465349139068: migrate_disable <-vprintk_emit
> 
> According to a discussion (see Link: below) on the linux-rt-users
> mailing list, this locking is done for performance reasons, not for
> correctness, so use the _nort() variants to avoid the above problem.
> 
> Suggested-by: Julia Cartwright <julia-acOepvfBmUk@public.gmane.org>
> Cc: Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Sebastian Andrzej Siewior <sebastian.siewior-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Link: http://lkml.kernel.org/r/20170926210045.GO29872-ew3lsbMjNqt5wtABiV/Xjqyly8cj88Ttqxv4g6HH51o@public.gmane.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I assume you are not asking for Doug to pick this up for linux-rdma and 
that this more of an RFC sort of deal and the intended destination is 
the -rt tree? Anyway, for this patch:

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

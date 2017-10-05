From: Julia Cartwright <julia@ni.com>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Thu, 5 Oct 2017 09:17:44 -0500
Message-ID: <20171005141744.GC21185@jcartwri.amer.corp.natinst.com>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-2-acme@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171003154920.31566-2-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: bigeasy@linutronix.de, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 03, 2017 at 12:49:19PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> sc_buffer_alloc() disables preemption that will be reenabled by either
> pio_copy() or seg_pio_copy_end(). But before disabling preemption it
> grabs a spin lock that will be dropped after it disables preemption,
> which ends up triggering a warning in migrate_disable() later on.
> 
>     spin_lock_irqsave(&sc->alloc_lock)
>       migrate_disable() ++p->migrate_disable -> 2
>     preempt_disable()
>     spin_unlock_irqrestore(&sc->alloc_lock)
>       migrate_enable() in_atomic(), so just returns, migrate_disable stays at 2
>     spin_lock_irqsave(some other lock) -> b00m
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
> Suggested-by: Julia Cartwright <julia@ni.com>
> Cc: Clark Williams <williams@redhat.com>
> Cc: Dean Luick <dean.luick@intel.com>
> Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Kaike Wan <kaike.wan@intel.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>
> Cc: Sebastian Sanchez <sebastian.sanchez@intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_20170926210045.GO29872-40jcartwri.amer.corp.natinst.com&d=DwIBaQ&c=I_0YwoKy7z5LMTVdyO6YCiE2uzI1jjZZuIPelcSjixA&r=cAXq_8W9Othb2h8ZcWv8Vw&m=zzKtWJ595HB0jyuiFic0ZEkpmmjvGRXJHkGF27oyvCI&s=J4_Al0cbvQ9PCM3VbqzJ6apmpSZI9Xx7eq6Gcfucp24&e= 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  drivers/infiniband/hw/hfi1/pio.c      | 2 +-
>  drivers/infiniband/hw/hfi1/pio_copy.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
> index 615be68e40b3..3a30bde9a07b 100644
> --- a/drivers/infiniband/hw/hfi1/pio.c
> +++ b/drivers/infiniband/hw/hfi1/pio.c
> @@ -1421,7 +1421,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
>  
>  	/* there is enough room */
>  
> -	preempt_disable();
> +	preempt_disable_nort();
>  	this_cpu_inc(*sc->buffers_allocated);

Have you tried this on RT w/ CONFIG_DEBUG_PREEMPT?  I believe that the
this_cpu_* operations perform a preemption check, which we'd trip.

You may also have to change these to the non-preempt checked variants.

   Julia

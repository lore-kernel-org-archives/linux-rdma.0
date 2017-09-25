From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Mon, 25 Sep 2017 11:49:49 -0300
Message-ID: <20170925144949.GP29668@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-rt-users-owner@vger.kernel.org
To: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, Jubin John <jubin.john@intel.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,

	I'm trying to get an Infiniband test case working with the RT
kernel, and ended over tripping over this case:

	In drivers/infiniband/hw/hfi1/pio.c sc_buffer_alloc() disables
preemption that will be reenabled by either pio_copy() or
seg_pio_copy_end().

	But before disabling preemption it grabs a spin lock that will
be dropped after it disables preemption, which ends up triggering a
warning in migrate_disable() later on.

  spin_lock_irqsave(&sc->alloc_lock)
    migrate_disable() ++p->migrate_disable -> 2
  preempt_disable()
  spin_unlock_irqrestore(&sc->alloc_lock)
    migrate_enable() in_atomic(), so just returns, migrate_disable stays at 2
  spin_lock_irqsave(some other lock) -> b00m

    And the WARN_ON code ends up tripping over this over and over in
    log_store().
    
    Sequence captured via ftrace_dump_on_oops + crash utility 'dmesg'
    command.
    
    [512258.613862] sm-3297 16 .....11 359465349134644: sc_buffer_alloc <-hfi1_verbs_send_pio
    [512258.613876] sm-3297 16 .....11 359465349134719: migrate_disable <-sc_buffer_alloc
    [512258.613890] sm-3297 16 .....12 359465349134798: rt_spin_lock <-sc_buffer_alloc
    [512258.613903] sm-3297 16 ....112 359465349135481: rt_spin_unlock <-sc_buffer_alloc
    [512258.613916] sm-3297 16 ....112 359465349135556: migrate_enable <-sc_buffer_alloc
    [512258.613935] sm-3297 16 ....112 359465349135788: seg_pio_copy_start <-hfi1_verbs_send_pio
    [512258.613954] sm-3297 16 ....112 359465349136273: update_sge <-hfi1_verbs_send_pio
    [512258.613981] sm-3297 16 ....112 359465349136373: seg_pio_copy_mid <-hfi1_verbs_send_pio
    [512258.613999] sm-3297 16 ....112 359465349136873: update_sge <-hfi1_verbs_send_pio
    [512258.614017] sm-3297 16 ....112 359465349136956: seg_pio_copy_mid <-hfi1_verbs_send_pio
    [512258.614035] sm-3297 16 ....112 359465349137221: seg_pio_copy_end <-hfi1_verbs_send_pio
    [512258.614048] sm-3297 16 .....12 359465349137360: migrate_disable <-hfi1_verbs_send_pio
    [512258.614065] sm-3297 16 .....12 359465349137476: warn_slowpath_null <-migrate_disable
    [512258.614081] sm-3297 16 .....12 359465349137564: __warn <-warn_slowpath_null
    [512258.614088] sm-3297 16 .....12 359465349137958: printk <-__warn
    [512258.614096] sm-3297 16 .....12 359465349138055: vprintk_default <-printk
    [512258.614104] sm-3297 16 .....12 359465349138144: vprintk_emit <-vprintk_default
    [512258.614111] sm-3297 16 d....12 359465349138312: _raw_spin_lock <-vprintk_emit
    [512258.614119] sm-3297 16 d...112 359465349138789: log_store <-vprintk_emit
    [512258.614127] sm-3297 16 .....12 359465349139068: migrate_disable <-vprintk_emit

I'm wondering if turning this sc->alloc_lock to a raw_spin_lock is the
right solution, which I'm afraid its not, as there are places where it
is held and then the code goes on to grab other non-raw spinlocks...

I got this patch in my test branch and it makes the test case go further
before splatting on other problems with infiniband + PREEMPT_RT_FULL,
but as I said, I fear its not the right solution, ideas?

The kernel I'm seing this is RHEL's + the PREEMPT_RT_FULL patch:

Linux version 3.10.0-709.rt56.636.test.el7.x86_64 (acme@seventh) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC) ) #
1 SMP PREEMPT RT Wed Sep 20 18:04:55 -03 2017

I will try and build with the latest PREEMPT_RT_FULL patch, but the
infiniband codebase in RHEL seems to be up to what is upstream and
I just looked at patches-4.11.12-rt14/add_migrate_disable.patch and that
WARN_ON_ONCE(p->migrate_disable_atomic) is still there :-\

- Arnaldo

commit 7ec7d80c7f46bb04da5f39836096de4c0ddde71a
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Wed Sep 6 10:30:08 2017 -0300

    infiniband: Convert per-NUMA send_context->alloc_lock to a raw spinlock

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 615be68e40b3..8f28f8fe842d 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -744,7 +744,7 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 	sc->dd = dd;
 	sc->node = numa;
 	sc->type = type;
-	spin_lock_init(&sc->alloc_lock);
+	raw_spin_lock_init(&sc->alloc_lock);
 	spin_lock_init(&sc->release_lock);
 	spin_lock_init(&sc->credit_ctrl_lock);
 	INIT_LIST_HEAD(&sc->piowait);
@@ -929,13 +929,13 @@ void sc_disable(struct send_context *sc)
 		return;
 
 	/* do all steps, even if already disabled */
-	spin_lock_irqsave(&sc->alloc_lock, flags);
+	raw_spin_lock_irqsave(&sc->alloc_lock, flags);
 	reg = read_kctxt_csr(sc->dd, sc->hw_context, SC(CTRL));
 	reg &= ~SC(CTRL_CTXT_ENABLE_SMASK);
 	sc->flags &= ~SCF_ENABLED;
 	sc_wait_for_packet_egress(sc, 1);
 	write_kctxt_csr(sc->dd, sc->hw_context, SC(CTRL), reg);
-	spin_unlock_irqrestore(&sc->alloc_lock, flags);
+	raw_spin_unlock_irqrestore(&sc->alloc_lock, flags);
 
 	/*
 	 * Flush any waiters.  Once the context is disabled,
@@ -1232,7 +1232,7 @@ int sc_enable(struct send_context *sc)
 	 * worry about locking since the releaser will not do anything
 	 * if the context accounting values have not changed.
 	 */
-	spin_lock_irqsave(&sc->alloc_lock, flags);
+	raw_spin_lock_irqsave(&sc->alloc_lock, flags);
 	sc_ctrl = read_kctxt_csr(dd, sc->hw_context, SC(CTRL));
 	if ((sc_ctrl & SC(CTRL_CTXT_ENABLE_SMASK)))
 		goto unlock; /* already enabled */
@@ -1303,7 +1303,7 @@ int sc_enable(struct send_context *sc)
 	sc->flags |= SCF_ENABLED;
 
 unlock:
-	spin_unlock_irqrestore(&sc->alloc_lock, flags);
+	raw_spin_unlock_irqrestore(&sc->alloc_lock, flags);
 
 	return ret;
 }
@@ -1361,9 +1361,9 @@ void sc_stop(struct send_context *sc, int flag)
 	sc->flags |= flag;
 
 	/* stop buffer allocations */
-	spin_lock_irqsave(&sc->alloc_lock, flags);
+	raw_spin_lock_irqsave(&sc->alloc_lock, flags);
 	sc->flags &= ~SCF_ENABLED;
-	spin_unlock_irqrestore(&sc->alloc_lock, flags);
+	raw_spin_unlock_irqrestore(&sc->alloc_lock, flags);
 	wake_up(&sc->halt_wait);
 }
 
@@ -1391,9 +1391,9 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
 	int trycount = 0;
 	u32 head, next;
 
-	spin_lock_irqsave(&sc->alloc_lock, flags);
+	raw_spin_lock_irqsave(&sc->alloc_lock, flags);
 	if (!(sc->flags & SCF_ENABLED)) {
-		spin_unlock_irqrestore(&sc->alloc_lock, flags);
+		raw_spin_unlock_irqrestore(&sc->alloc_lock, flags);
 		goto done;
 	}
 
@@ -1402,7 +1402,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
 	if (blocks > avail) {
 		/* not enough room */
 		if (unlikely(trycount))	{ /* already tried to get more room */
-			spin_unlock_irqrestore(&sc->alloc_lock, flags);
+			raw_spin_unlock_irqrestore(&sc->alloc_lock, flags);
 			goto done;
 		}
 		/* copy from receiver cache line and recalculate */
@@ -1458,7 +1458,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
 	 */
 	smp_wmb();
 	sc->sr_head = next;
-	spin_unlock_irqrestore(&sc->alloc_lock, flags);
+	raw_spin_unlock_irqrestore(&sc->alloc_lock, flags);
 
 	/* finish filling in the buffer outside the lock */
 	pbuf->start = sc->base_addr + fill_wrap * PIO_BLOCK_SIZE;
diff --git a/drivers/infiniband/hw/hfi1/pio.h b/drivers/infiniband/hw/hfi1/pio.h
index 867e5ffc3595..06dfc6f81fd5 100644
--- a/drivers/infiniband/hw/hfi1/pio.h
+++ b/drivers/infiniband/hw/hfi1/pio.h
@@ -112,7 +112,7 @@ struct send_context {
 	u8  group;			/* credit return group */
 
 	/* allocator fields */
-	spinlock_t alloc_lock ____cacheline_aligned_in_smp;
+	raw_spinlock_t alloc_lock ____cacheline_aligned_in_smp;
 	u32 sr_head;			/* shadow ring head */
 	unsigned long fill;		/* official alloc count */
 	unsigned long alloc_free;	/* copy of free (less cache thrash) */

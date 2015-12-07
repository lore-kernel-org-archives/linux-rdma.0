From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH] staging/rdma/hfi1: convert buffers allocated atomic to per
 cpu
Date: Mon, 07 Dec 2015 15:39:22 -0500
Message-ID: <20151207203922.8009.36069.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, linux-next@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Profiling has shown the the atomic is a performance issue
for the pio hot path.

If multiple cpus allocated an sc's buffer, the cacheline
containing the atomic will bounce from L0 to L0.

Convert the atomic to a percpu variable.

Reviewed-by: Jubin John <jubin.john@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
---
 drivers/staging/rdma/hfi1/pio.c      |   40 ++++++++++++++++++++++++++++++----
 drivers/staging/rdma/hfi1/pio.h      |    2 +-
 drivers/staging/rdma/hfi1/pio_copy.c |    6 +++--
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index eab58c1..ed8043b 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -660,6 +660,24 @@ void set_pio_integrity(struct send_context *sc)
 	write_kctxt_csr(dd, hw_context, SC(CHECK_ENABLE), reg);
 }
 
+static u32 get_buffers_allocated(struct send_context *sc)
+{
+	int cpu;
+	u32 ret = 0;
+
+	for_each_possible_cpu(cpu)
+		ret += *per_cpu_ptr(sc->buffers_allocated, cpu);
+	return ret;
+}
+
+static void reset_buffers_allocated(struct send_context *sc)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		(*per_cpu_ptr(sc->buffers_allocated, cpu)) = 0;
+}
+
 /*
  * Allocate a NUMA relative send context structure of the given type along
  * with a HW context.
@@ -668,7 +686,7 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 			      uint hdrqentsize, int numa)
 {
 	struct send_context_info *sci;
-	struct send_context *sc;
+	struct send_context *sc = NULL;
 	dma_addr_t pa;
 	unsigned long flags;
 	u64 reg;
@@ -686,10 +704,20 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 	if (!sc)
 		return NULL;
 
+	sc->buffers_allocated = alloc_percpu(u32);
+	if (!sc->buffers_allocated) {
+		kfree(sc);
+		dd_dev_err(dd,
+			   "Cannot allocate buffers_allocated per cpu counters\n"
+			  );
+		return NULL;
+	}
+
 	spin_lock_irqsave(&dd->sc_lock, flags);
 	ret = sc_hw_alloc(dd, type, &sw_index, &hw_context);
 	if (ret) {
 		spin_unlock_irqrestore(&dd->sc_lock, flags);
+		free_percpu(sc->buffers_allocated);
 		kfree(sc);
 		return NULL;
 	}
@@ -705,7 +733,6 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 	spin_lock_init(&sc->credit_ctrl_lock);
 	INIT_LIST_HEAD(&sc->piowait);
 	INIT_WORK(&sc->halt_work, sc_halted);
-	atomic_set(&sc->buffers_allocated, 0);
 	init_waitqueue_head(&sc->halt_wait);
 
 	/* grouping is always single context for now */
@@ -866,6 +893,7 @@ void sc_free(struct send_context *sc)
 	spin_unlock_irqrestore(&dd->sc_lock, flags);
 
 	kfree(sc->sr);
+	free_percpu(sc->buffers_allocated);
 	kfree(sc);
 }
 
@@ -1029,7 +1057,7 @@ int sc_restart(struct send_context *sc)
 		/* kernel context */
 		loop = 0;
 		while (1) {
-			count = atomic_read(&sc->buffers_allocated);
+			count = get_buffers_allocated(sc);
 			if (count == 0)
 				break;
 			if (loop > 100) {
@@ -1197,7 +1225,8 @@ int sc_enable(struct send_context *sc)
 	sc->sr_head = 0;
 	sc->sr_tail = 0;
 	sc->flags = 0;
-	atomic_set(&sc->buffers_allocated, 0);
+	/* the alloc lock insures no fast path allocation */
+	reset_buffers_allocated(sc);
 
 	/*
 	 * Clear all per-context errors.  Some of these will be set when
@@ -1373,7 +1402,8 @@ retry:
 
 	/* there is enough room */
 
-	atomic_inc(&sc->buffers_allocated);
+	preempt_disable();
+	this_cpu_inc(*sc->buffers_allocated);
 
 	/* read this once */
 	head = sc->sr_head;
diff --git a/drivers/staging/rdma/hfi1/pio.h b/drivers/staging/rdma/hfi1/pio.h
index 0bb885c..53d3e0a 100644
--- a/drivers/staging/rdma/hfi1/pio.h
+++ b/drivers/staging/rdma/hfi1/pio.h
@@ -130,7 +130,7 @@ struct send_context {
 	spinlock_t credit_ctrl_lock ____cacheline_aligned_in_smp;
 	u64 credit_ctrl;		/* cache for credit control */
 	u32 credit_intr_count;		/* count of credit intr users */
-	atomic_t buffers_allocated;	/* count of buffers allocated */
+	u32 __percpu *buffers_allocated;/* count of buffers allocated */
 	wait_queue_head_t halt_wait;    /* wait until kernel sees interrupt */
 };
 
diff --git a/drivers/staging/rdma/hfi1/pio_copy.c b/drivers/staging/rdma/hfi1/pio_copy.c
index 8972bbc..ebb0baf 100644
--- a/drivers/staging/rdma/hfi1/pio_copy.c
+++ b/drivers/staging/rdma/hfi1/pio_copy.c
@@ -160,7 +160,8 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
 	}
 
 	/* finished with this buffer */
-	atomic_dec(&pbuf->sc->buffers_allocated);
+	this_cpu_dec(*pbuf->sc->buffers_allocated);
+	preempt_enable();
 }
 
 /* USE_SHIFTS is faster in user-space tests on a Xeon X5570 @ 2.93GHz */
@@ -854,5 +855,6 @@ void seg_pio_copy_end(struct pio_buf *pbuf)
 	}
 
 	/* finished with this buffer */
-	atomic_dec(&pbuf->sc->buffers_allocated);
+	this_cpu_dec(*pbuf->sc->buffers_allocated);
+	preempt_enable();
 }

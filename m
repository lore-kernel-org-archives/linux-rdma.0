From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v4 8/9] staging/rdma/hfi1: Use parallel workqueue for SDMA engines
Date: Fri, 30 Oct 2015 18:58:47 -0400
Message-ID: <1446245928-12675-9-git-send-email-ira.weiny@intel.com>
References: <1446245928-12675-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446245928-12675-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The workqueue is currently single threaded per port which for a small number of
SDMA engines is ok.

For hfi1, the there are up to 16 SDMA engines that can be fed descriptors in
parallel.

Use alloc_workqueue with a workqueue limit of the number of sdma engines and
with WQ_CPU_INTENSIVE and WQ_HIGHPRI specified.

Then change send to use the new scheduler which no longer needs to get the
s_lock

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from v3:
	Split patch out code refactoring and separate functionality

 drivers/staging/rdma/hfi1/chip.c   |  1 +
 drivers/staging/rdma/hfi1/init.c   | 13 ++++++-------
 drivers/staging/rdma/hfi1/iowait.h |  6 ++++--
 drivers/staging/rdma/hfi1/qp.h     | 35 +++++++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/sdma.c   |  8 +++++---
 drivers/staging/rdma/hfi1/sdma.h   |  8 +++++---
 drivers/staging/rdma/hfi1/verbs.c  | 20 ++++----------------
 drivers/staging/rdma/hfi1/verbs.h  |  1 -
 8 files changed, 60 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e48981994b10..b7c7d1cac4e1 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9018,6 +9018,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 		if (handler == sdma_interrupt) {
 			dd_dev_info(dd, "sdma engine %d cpu %d\n",
 				sde->this_idx, sdma_cpu);
+			sde->cpu = sdma_cpu;
 			cpumask_set_cpu(sdma_cpu, dd->msix_entries[i].mask);
 			sdma_cpu = cpumask_next(sdma_cpu, def);
 			if (sdma_cpu >= nr_cpu_ids)
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 060ab566856a..3f6166b9c59f 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -601,20 +601,19 @@ static int create_workqueues(struct hfi1_devdata *dd)
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
 		if (!ppd->hfi1_wq) {
-			char wq_name[8]; /* 3 + 2 + 1 + 1 + 1 */
-
-			snprintf(wq_name, sizeof(wq_name), "hfi%d_%d",
-				 dd->unit, pidx);
 			ppd->hfi1_wq =
-				create_singlethread_workqueue(wq_name);
+				alloc_workqueue(
+				    "hfi%d_%d",
+				    WQ_SYSFS | WQ_HIGHPRI | WQ_CPU_INTENSIVE,
+				    dd->num_sdma,
+				    dd->unit, pidx);
 			if (!ppd->hfi1_wq)
 				goto wq_error;
 		}
 	}
 	return 0;
 wq_error:
-	pr_err("create_singlethread_workqueue failed for port %d\n",
-		pidx + 1);
+	pr_err("alloc_workqueue failed for port %d\n", pidx + 1);
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
 		if (ppd->hfi1_wq) {
diff --git a/drivers/staging/rdma/hfi1/iowait.h b/drivers/staging/rdma/hfi1/iowait.h
index fa361b405851..e8ba5606d08d 100644
--- a/drivers/staging/rdma/hfi1/iowait.h
+++ b/drivers/staging/rdma/hfi1/iowait.h
@@ -150,12 +150,14 @@ static inline void iowait_init(
  * iowait_schedule() - initialize wait structure
  * @wait: wait struct to schedule
  * @wq: workqueue for schedule
+ * @cpu: cpu
  */
 static inline void iowait_schedule(
 	struct iowait *wait,
-	struct workqueue_struct *wq)
+	struct workqueue_struct *wq,
+	int cpu)
 {
-	queue_work(wq, &wait->iowork);
+	queue_work_on(cpu, wq, &wait->iowork);
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index bacfa9c5e8a8..ca70a0e662d0 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -247,6 +247,41 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter);
  */
 void qp_comm_est(struct hfi1_qp *qp);
 
+/**
+ * _hfi1_schedule_send - schedule progress
+ * @qp: the QP
+ *
+ * This schedules qp progress w/o regard to the s_flags.
+ *
+ * It is only used in the post send, which doesn't hold
+ * the s_lock.
+ */
+static inline void _hfi1_schedule_send(struct hfi1_qp *qp)
+{
+	struct hfi1_ibport *ibp =
+		to_iport(qp->ibqp.device, qp->port_num);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+
+	iowait_schedule(&qp->s_iowait, ppd->hfi1_wq,
+		qp->s_sde ?
+			qp->s_sde->cpu :
+			cpumask_first(cpumask_of_node(dd->assigned_node_id)));
+}
+
+/**
+ * hfi1_schedule_send - schedule progress
+ * @qp: the QP
+ *
+ * This schedules qp progress and caller should hold
+ * the s_lock.
+ */
+static inline void hfi1_schedule_send(struct hfi1_qp *qp)
+{
+	if (hfi1_send_ok(qp))
+		_hfi1_schedule_send(qp);
+}
+
 void hfi1_migrate_qp(struct hfi1_qp *qp);
 
 #endif /* _QP_H */
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 2a1da2189900..ddef98d7e6ac 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -778,18 +778,19 @@ struct sdma_engine *sdma_select_engine_vl(
 	struct sdma_engine *rval;
 
 	if (WARN_ON(vl > 8))
-		return NULL;
+		return &dd->per_sdma[0];
 
 	rcu_read_lock();
 	m = rcu_dereference(dd->sdma_map);
 	if (unlikely(!m)) {
 		rcu_read_unlock();
-		return NULL;
+		return &dd->per_sdma[0];
 	}
 	e = m->map[vl & m->mask];
 	rval = e->sde[selector & e->mask];
 	rcu_read_unlock();
 
+	rval =  !rval ? &dd->per_sdma[0] : rval;
 	trace_hfi1_sdma_engine_select(dd, selector, vl, rval->this_idx);
 	return rval;
 }
@@ -1874,7 +1875,7 @@ static void dump_sdma_state(struct sdma_engine *sde)
 }
 
 #define SDE_FMT \
-	"SDE %u STE %s C 0x%llx S 0x%016llx E 0x%llx T(HW) 0x%llx T(SW) 0x%x H(HW) 0x%llx H(SW) 0x%x H(D) 0x%llx DM 0x%llx GL 0x%llx R 0x%llx LIS 0x%llx AHGI 0x%llx TXT %u TXH %u DT %u DH %u FLNE %d DQF %u SLC 0x%llx\n"
+	"SDE %u CPU %d STE %s C 0x%llx S 0x%016llx E 0x%llx T(HW) 0x%llx T(SW) 0x%x H(HW) 0x%llx H(SW) 0x%x H(D) 0x%llx DM 0x%llx GL 0x%llx R 0x%llx LIS 0x%llx AHGI 0x%llx TXT %u TXH %u DT %u DH %u FLNE %d DQF %u SLC 0x%llx\n"
 /**
  * sdma_seqfile_dump_sde() - debugfs dump of sde
  * @s: seq file
@@ -1894,6 +1895,7 @@ void sdma_seqfile_dump_sde(struct seq_file *s, struct sdma_engine *sde)
 	head = sde->descq_head & sde->sdma_mask;
 	tail = ACCESS_ONCE(sde->descq_tail) & sde->sdma_mask;
 	seq_printf(s, SDE_FMT, sde->this_idx,
+		sde->cpu,
 		sdma_state_name(sde->state.current_state),
 		(unsigned long long)read_sde_csr(sde, SD(CTRL)),
 		(unsigned long long)read_sde_csr(sde, SD(STATUS)),
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index cc22d2ee2054..85701eed1585 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -410,8 +410,6 @@ struct sdma_engine {
 	u64 idle_mask;
 	u64 progress_mask;
 	/* private: */
-	struct workqueue_struct *wq;
-	/* private: */
 	volatile __le64      *head_dma; /* DMA'ed by chip */
 	/* private: */
 	dma_addr_t            head_phys;
@@ -426,6 +424,8 @@ struct sdma_engine {
 	u32 sdma_mask;
 	/* private */
 	struct sdma_state state;
+	/* private */
+	int cpu;
 	/* private: */
 	u8 sdma_shift;
 	/* private: */
@@ -990,7 +990,9 @@ static inline void sdma_iowait_schedule(
 	struct sdma_engine *sde,
 	struct iowait *wait)
 {
-	iowait_schedule(wait, sde->wq);
+	struct hfi1_pportdata *ppd = sde->dd->pport;
+
+	iowait_schedule(wait, ppd->hfi1_wq, sde->cpu);
 }
 
 /* for use by interrupt handling */
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index a13a2b135365..f43a8646af1b 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -162,6 +162,8 @@ static inline struct hfi1_ucontext *to_iucontext(struct ib_ucontext
 	return container_of(ibucontext, struct hfi1_ucontext, ibucontext);
 }
 
+static inline void _hfi1_schedule_send(struct hfi1_qp *qp);
+
 /*
  * Translate ib_wr_opcode into ib_wc_opcode.
  */
@@ -497,9 +499,9 @@ static int post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		nreq++;
 	}
 bail:
-	if (nreq && !call_send)
-		hfi1_schedule_send(qp);
 	spin_unlock_irqrestore(&qp->s_lock, flags);
+	if (nreq && !call_send)
+		_hfi1_schedule_send(qp);
 	if (nreq && call_send)
 		hfi1_do_send(&qp->s_iowait.iowork);
 	return err;
@@ -2125,20 +2127,6 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 	vfree(dev->lk_table.table);
 }
 
-/*
- * This must be called with s_lock held.
- */
-void hfi1_schedule_send(struct hfi1_qp *qp)
-{
-	if (hfi1_send_ok(qp)) {
-		struct hfi1_ibport *ibp =
-			to_iport(qp->ibqp.device, qp->port_num);
-		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-
-		iowait_schedule(&qp->s_iowait, ppd->hfi1_wq);
-	}
-}
-
 void hfi1_cnp_rcv(struct hfi1_packet *packet)
 {
 	struct hfi1_ibport *ibp = &packet->rcd->ppd->ibport_data;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 9555aab51530..fb8ea5c892c6 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -841,7 +841,6 @@ static inline int hfi1_send_ok(struct hfi1_qp *qp)
 /*
  * This must be called with s_lock held.
  */
-void hfi1_schedule_send(struct hfi1_qp *qp);
 void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
 		    u32 qp1, u32 qp2, __be16 lid1, __be16 lid2);
 void hfi1_cap_mask_chg(struct hfi1_ibport *ibp);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

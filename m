From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 18/22] staging/rdma/hfi: modify workqueue for parallelism
Date: Mon, 19 Oct 2015 22:11:33 -0400
Message-ID: <1445307097-8244-19-git-send-email-ira.weiny@intel.com>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445307097-8244-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The workqueue is currently single threaded per port which for a small number of
SDMA engines is ok.

For hfi1, the there are up to 16 SDMA engines that can be fed descriptors in
parallel.

This patch:
- Converts to use alloc_workqueue
- Changes the workqueue limit from 1 to num_sdma
- Makes the queue WQ_CPU_INTENSIVE and WQ_HIGHPRI
- The sdma_engine now has a cpu that is initialized
  as the MSI-X vectors are setup
- Adjusts the post send logic to call a new scheduler
  that doesn't get the s_lock
- The new and old workqueue schedule now pass a
  cpu
- post send now uses the new scheduler
- RC/UC QPs now pre-compute the sc, sde
- The sde wq is eliminated since the new hfi1_wq is
  multi-threaded

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c   |  1 +
 drivers/staging/rdma/hfi1/init.c   | 13 +++++------
 drivers/staging/rdma/hfi1/iowait.h |  6 +++--
 drivers/staging/rdma/hfi1/qp.c     | 47 +++++++++++++++++++++++++++++++++-----
 drivers/staging/rdma/hfi1/qp.h     | 38 +++++++++++++++++++++++++++++-
 drivers/staging/rdma/hfi1/ruc.c    | 30 ++----------------------
 drivers/staging/rdma/hfi1/sdma.c   |  8 ++++---
 drivers/staging/rdma/hfi1/sdma.h   |  8 ++++---
 drivers/staging/rdma/hfi1/ud.c     |  1 +
 drivers/staging/rdma/hfi1/verbs.c  | 34 ++++++---------------------
 drivers/staging/rdma/hfi1/verbs.h  |  6 ++---
 11 files changed, 111 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 352b0d089ae1..af1b3bb10ecb 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9021,6 +9021,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
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
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index df1fa56eaf85..87aa49227bf6 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -617,7 +617,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	int mig = 0;
 	int ret;
 	u32 pmtu = 0; /* for gcc warning only */
-	struct hfi1_devdata *dd;
+	struct hfi1_devdata *dd = dd_from_dev(dev);
 
 	spin_lock_irq(&qp->r_lock);
 	spin_lock(&qp->s_lock);
@@ -631,23 +631,35 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto inval;
 
 	if (attr_mask & IB_QP_AV) {
+		u8 sc;
+
 		if (attr->ah_attr.dlid >= HFI1_MULTICAST_LID_BASE)
 			goto inval;
 		if (hfi1_check_ah(qp->ibqp.device, &attr->ah_attr))
 			goto inval;
+		sc = ah_to_sc(ibqp->device, &attr->ah_attr);
+		if (!qp_to_sdma_engine(qp, sc) &&
+				dd->flags & HFI1_HAS_SEND_DMA)
+			goto inval;
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
+		u8 sc;
+
 		if (attr->alt_ah_attr.dlid >= HFI1_MULTICAST_LID_BASE)
 			goto inval;
 		if (hfi1_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
 			goto inval;
-		if (attr->alt_pkey_index >= hfi1_get_npkeys(dd_from_dev(dev)))
+		if (attr->alt_pkey_index >= hfi1_get_npkeys(dd))
+			goto inval;
+		sc = ah_to_sc(ibqp->device, &attr->alt_ah_attr);
+		if (!qp_to_sdma_engine(qp, sc) &&
+				dd->flags & HFI1_HAS_SEND_DMA)
 			goto inval;
 	}
 
 	if (attr_mask & IB_QP_PKEY_INDEX)
-		if (attr->pkey_index >= hfi1_get_npkeys(dd_from_dev(dev)))
+		if (attr->pkey_index >= hfi1_get_npkeys(dd))
 			goto inval;
 
 	if (attr_mask & IB_QP_MIN_RNR_TIMER)
@@ -792,6 +804,8 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		qp->remote_ah_attr = attr->ah_attr;
 		qp->s_srate = attr->ah_attr.static_rate;
 		qp->srate_mbps = ib_rate_to_mbps(qp->s_srate);
+		qp->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
+		qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
@@ -806,6 +820,8 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			qp->port_num = qp->alt_ah_attr.port_num;
 			qp->s_pkey_index = qp->s_alt_pkey_index;
 			qp->s_flags |= HFI1_S_AHG_CLEAR;
+			qp->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
+			qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
 		}
 	}
 
@@ -1528,9 +1544,6 @@ struct sdma_engine *qp_to_sdma_engine(struct hfi1_qp *qp, u8 sc5)
 	if (!(dd->flags & HFI1_HAS_SEND_DMA))
 		return NULL;
 	switch (qp->ibqp.qp_type) {
-	case IB_QPT_UC:
-	case IB_QPT_RC:
-		break;
 	case IB_QPT_SMI:
 		return NULL;
 	default:
@@ -1685,3 +1698,25 @@ void qp_comm_est(struct hfi1_qp *qp)
 		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
 	}
 }
+
+/*
+ * Switch to alternate path.
+ * The QP s_lock should be held and interrupts disabled.
+ */
+void hfi1_migrate_qp(struct hfi1_qp *qp)
+{
+	struct ib_event ev;
+
+	qp->s_mig_state = IB_MIG_MIGRATED;
+	qp->remote_ah_attr = qp->alt_ah_attr;
+	qp->port_num = qp->alt_ah_attr.port_num;
+	qp->s_pkey_index = qp->s_alt_pkey_index;
+	qp->s_flags |= HFI1_S_AHG_CLEAR;
+	qp->s_sc = ah_to_sc(qp->ibqp.device, &qp->remote_ah_attr);
+	qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
+
+	ev.device = qp->ibqp.device;
+	ev.element.qp = &qp->ibqp;
+	ev.event = IB_EVENT_PATH_MIG;
+	qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
+}
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index b9c1575990aa..5e1def523f61 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -128,7 +128,6 @@ static inline void clear_ahg(struct hfi1_qp *qp)
 	if (qp->s_sde && qp->s_ahgidx >= 0)
 		sdma_ahg_free(qp->s_sde, qp->s_ahgidx);
 	qp->s_ahgidx = -1;
-	qp->s_sde = NULL;
 }
 
 /**
@@ -247,4 +246,41 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter);
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
+void hfi1_migrate_qp(struct hfi1_qp *qp);
+
 #endif /* _QP_H */
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 8614b070545c..7b11c61ac5d6 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -241,26 +241,6 @@ bail:
 	return ret;
 }
 
-/*
- * Switch to alternate path.
- * The QP s_lock should be held and interrupts disabled.
- */
-void hfi1_migrate_qp(struct hfi1_qp *qp)
-{
-	struct ib_event ev;
-
-	qp->s_mig_state = IB_MIG_MIGRATED;
-	qp->remote_ah_attr = qp->alt_ah_attr;
-	qp->port_num = qp->alt_ah_attr.port_num;
-	qp->s_pkey_index = qp->s_alt_pkey_index;
-	qp->s_flags |= HFI1_S_AHG_CLEAR;
-
-	ev.device = qp->ibqp.device;
-	ev.element.qp = &qp->ibqp;
-	ev.event = IB_EVENT_PATH_MIG;
-	qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
-}
-
 static __be64 get_sguid(struct hfi1_ibport *ibp, unsigned index)
 {
 	if (!index) {
@@ -714,11 +694,8 @@ static inline void build_ahg(struct hfi1_qp *qp, u32 npsn)
 		clear_ahg(qp);
 	if (!(qp->s_flags & HFI1_S_AHG_VALID)) {
 		/* first middle that needs copy  */
-		if (qp->s_ahgidx < 0) {
-			if (!qp->s_sde)
-				qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
+		if (qp->s_ahgidx < 0)
 			qp->s_ahgidx = sdma_ahg_alloc(qp->s_sde);
-		}
 		if (qp->s_ahgidx >= 0) {
 			qp->s_ahgpsn = npsn;
 			qp->s_hdr->tx_flags |= SDMA_TXREQ_F_AHG_COPY;
@@ -761,7 +738,6 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 	u16 lrh0;
 	u32 nwords;
 	u32 extra_bytes;
-	u8 sc5;
 	u32 bth1;
 
 	/* Construct the header. */
@@ -775,9 +751,7 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 		lrh0 = HFI1_LRH_GRH;
 		middle = 0;
 	}
-	sc5 = ibp->sl_to_sc[qp->remote_ah_attr.sl];
-	lrh0 |= (sc5 & 0xf) << 12 | (qp->remote_ah_attr.sl & 0xf) << 4;
-	qp->s_sc = sc5;
+	lrh0 |= (qp->s_sc & 0xf) << 12 | (qp->remote_ah_attr.sl & 0xf) << 4;
 	/*
 	 * reset s_hdr/AHG fields
 	 *
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 16b1edf2a5cc..6aad23ca1908 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -777,18 +777,19 @@ struct sdma_engine *sdma_select_engine_vl(
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
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index d40d1a1e10aa..d6b4ba8a811e 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -383,6 +383,7 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 		lrh0 |= (sc5 & 0xf) << 12;
 		qp->s_sc = sc5;
 	}
+	qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
 	qp->s_hdr->ibh.lrh[0] = cpu_to_be16(lrh0);
 	qp->s_hdr->ibh.lrh[1] = cpu_to_be16(ah_attr->dlid);  /* DEST LID */
 	qp->s_hdr->ibh.lrh[2] =
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index ce408f584e98..cac3f4a30741 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -159,6 +159,8 @@ static inline struct hfi1_ucontext *to_iucontext(struct ib_ucontext
 	return container_of(ibucontext, struct hfi1_ucontext, ibucontext);
 }
 
+static inline void _hfi1_schedule_send(struct hfi1_qp *qp);
+
 /*
  * Translate ib_wr_opcode into ib_wc_opcode.
  */
@@ -494,9 +496,9 @@ static int post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
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
@@ -994,7 +996,6 @@ int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 	struct verbs_txreq *tx;
 	struct sdma_txreq *stx;
 	u64 pbc_flags = 0;
-	struct sdma_engine *sde;
 	u8 sc5 = qp->s_sc;
 	int ret;
 
@@ -1015,12 +1016,7 @@ int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 	if (IS_ERR(tx))
 		goto bail_tx;
 
-	if (!qp->s_hdr->sde) {
-		tx->sde = sde = qp_to_sdma_engine(qp, sc5);
-		if (!sde)
-			goto bail_no_sde;
-	} else
-		tx->sde = sde = qp->s_hdr->sde;
+	tx->sde = qp->s_sde;
 
 	if (likely(pbc == 0)) {
 		u32 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
@@ -1035,17 +1031,15 @@ int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 	if (qp->s_rdma_mr)
 		qp->s_rdma_mr = NULL;
 	tx->hdr_dwords = hdrwords + 2;
-	ret = build_verbs_tx_desc(sde, ss, len, tx, ahdr, pbc);
+	ret = build_verbs_tx_desc(tx->sde, ss, len, tx, ahdr, pbc);
 	if (unlikely(ret))
 		goto bail_build;
 	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device), &ahdr->ibh);
-	ret =  sdma_send_txreq(sde, &qp->s_iowait, &tx->txreq);
+	ret =  sdma_send_txreq(tx->sde, &qp->s_iowait, &tx->txreq);
 	if (unlikely(ret == -ECOMM))
 		goto bail_ecomm;
 	return ret;
 
-bail_no_sde:
-	hfi1_put_txreq(tx);
 bail_ecomm:
 	/* The current one got "sent" */
 	return 0;
@@ -2120,20 +2114,6 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
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
index e4a8a0d4ccf8..62c6e38cca45 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -436,7 +436,8 @@ struct hfi1_qp {
 	struct hfi1_swqe *s_wq;  /* send work queue */
 	struct hfi1_mmap_info *ip;
 	struct ahg_ib_header *s_hdr;     /* next packet header to send */
-	u8 s_sc;			/* SC[0..4] for next packet */
+	/* sc for UC/RC QPs - based on ah for UD */
+	u8 s_sc;
 	unsigned long timeout_jiffies;  /* computed from timeout */
 
 	enum ib_mtu path_mtu;
@@ -841,7 +842,6 @@ static inline int hfi1_send_ok(struct hfi1_qp *qp)
 /*
  * This must be called with s_lock held.
  */
-void hfi1_schedule_send(struct hfi1_qp *qp);
 void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
 		    u32 qp1, u32 qp2, __be16 lid1, __be16 lid2);
 void hfi1_cap_mask_chg(struct hfi1_ibport *ibp);
@@ -1071,8 +1071,6 @@ int hfi1_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 int hfi1_get_rwqe(struct hfi1_qp *qp, int wr_id_only);
 
-void hfi1_migrate_qp(struct hfi1_qp *qp);
-
 int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 		       int has_grh, struct hfi1_qp *qp, u32 bth0);
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

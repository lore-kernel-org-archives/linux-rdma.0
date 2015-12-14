From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [RFC PATCH 06/15] IB/hfi1: Remove driver specific members from hfi1
 qp type
Date: Mon, 14 Dec 2015 12:28:33 -0500
Message-ID: <20151214172831.11576.60381.stgit@phlsvslse11.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

In preparation for moving the queue pair data structure to rdmavt the
members of the driver specific queue pairs which are not common need to be
pushed off to a private driver structure. This structure will be available
in the queue pair once moved to rdmavt as a void pointer. This patch while
not adding a lot of value in and of itself is a prerequisite to move the
queue pair out of the drivers and into rdmavt.

The driver specific, private queue pair data structure should condense as
more of the send side code moves to rdmavt.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/diag.c  |    3 +
 drivers/staging/rdma/hfi1/pio.c   |    6 ++-
 drivers/staging/rdma/hfi1/qp.c    |   76 ++++++++++++++++++++++++-------------
 drivers/staging/rdma/hfi1/qp.h    |    9 +++-
 drivers/staging/rdma/hfi1/rc.c    |    7 ++-
 drivers/staging/rdma/hfi1/ruc.c   |   46 ++++++++++++----------
 drivers/staging/rdma/hfi1/uc.c    |    7 ++-
 drivers/staging/rdma/hfi1/ud.c    |   37 +++++++++---------
 drivers/staging/rdma/hfi1/verbs.c |   54 ++++++++++++++++----------
 drivers/staging/rdma/hfi1/verbs.h |   26 ++++++++++---
 10 files changed, 166 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 0cf324d..e172f2a 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1634,7 +1634,8 @@ int snoop_send_dma_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
 int snoop_send_pio_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
 			   u64 pbc)
 {
-	struct ahg_ib_header *ahdr = qp->s_hdr;
+	struct hfi1_qp_priv *priv = qp->priv;
+	struct ahg_ib_header *ahdr = priv->s_hdr;
 	u32 hdrwords = qp->s_hdrwords;
 	struct hfi1_sge_state *ss = qp->s_cur_sge;
 	u32 len = qp->s_cur_size;
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index eab58c1..b5bce5e 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -1498,6 +1498,7 @@ static void sc_piobufavail(struct send_context *sc)
 	struct list_head *list;
 	struct hfi1_qp *qps[PIO_WAIT_BATCH_SIZE];
 	struct hfi1_qp *qp;
+	struct hfi1_qp_priv *priv;
 	unsigned long flags;
 	unsigned i, n = 0;
 
@@ -1517,8 +1518,9 @@ static void sc_piobufavail(struct send_context *sc)
 		if (n == ARRAY_SIZE(qps))
 			goto full;
 		wait = list_first_entry(list, struct iowait, list);
-		qp = container_of(wait, struct hfi1_qp, s_iowait);
-		list_del_init(&qp->s_iowait.list);
+		qp = iowait_to_qp(wait);
+		priv = qp->priv;
+		list_del_init(&priv->s_iowait.list);
 		/* refcount held until actual wake up */
 		qps[n++] = qp;
 	}
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index bb447b5..d49b1e9 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -349,11 +349,12 @@ bail:
  */
 static void reset_qp(struct hfi1_qp *qp, enum ib_qp_type type)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	qp->remote_qpn = 0;
 	qp->qkey = 0;
 	qp->qp_access_flags = 0;
 	iowait_init(
-		&qp->s_iowait,
+		&priv->s_iowait,
 		1,
 		hfi1_do_send,
 		iowait_sleep,
@@ -460,6 +461,7 @@ static void clear_mr_refs(struct hfi1_qp *qp, int clr_sends)
 int hfi1_error_qp(struct hfi1_qp *qp, enum ib_wc_status err)
 {
 	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct ib_wc wc;
 	int ret = 0;
 
@@ -477,9 +479,9 @@ int hfi1_error_qp(struct hfi1_qp *qp, enum ib_wc_status err)
 		qp->s_flags &= ~HFI1_S_ANY_WAIT_SEND;
 
 	write_seqlock(&dev->iowait_lock);
-	if (!list_empty(&qp->s_iowait.list) && !(qp->s_flags & HFI1_S_BUSY)) {
+	if (!list_empty(&priv->s_iowait.list) && !(qp->s_flags & HFI1_S_BUSY)) {
 		qp->s_flags &= ~HFI1_S_ANY_WAIT_IO;
-		list_del_init(&qp->s_iowait.list);
+		list_del_init(&priv->s_iowait.list);
 		if (atomic_dec_and_test(&qp->refcount))
 			wake_up(&qp->wait);
 	}
@@ -544,11 +546,13 @@ bail:
 
 static void flush_tx_list(struct hfi1_qp *qp)
 {
-	while (!list_empty(&qp->s_iowait.tx_head)) {
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	while (!list_empty(&priv->s_iowait.tx_head)) {
 		struct sdma_txreq *tx;
 
 		tx = list_first_entry(
-			&qp->s_iowait.tx_head,
+			&priv->s_iowait.tx_head,
 			struct sdma_txreq,
 			list);
 		list_del_init(&tx->list);
@@ -559,12 +563,13 @@ static void flush_tx_list(struct hfi1_qp *qp)
 
 static void flush_iowait(struct hfi1_qp *qp)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
 	unsigned long flags;
 
 	write_seqlock_irqsave(&dev->iowait_lock, flags);
-	if (!list_empty(&qp->s_iowait.list)) {
-		list_del_init(&qp->s_iowait.list);
+	if (!list_empty(&priv->s_iowait.list)) {
+		list_del_init(&priv->s_iowait.list);
 		if (atomic_dec_and_test(&qp->refcount))
 			wake_up(&qp->wait);
 	}
@@ -612,6 +617,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 {
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
 	struct hfi1_qp *qp = to_iqp(ibqp);
+	struct hfi1_qp_priv *priv = qp->priv;
 	enum ib_qp_state cur_state, new_state;
 	struct ib_event ev;
 	int lastwqe = 0;
@@ -738,9 +744,9 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			spin_unlock(&qp->s_lock);
 			spin_unlock_irq(&qp->r_lock);
 			/* Stop the sending work queue and retry timer */
-			cancel_work_sync(&qp->s_iowait.iowork);
+			cancel_work_sync(&priv->s_iowait.iowork);
 			del_timer_sync(&qp->s_timer);
-			iowait_sdma_drain(&qp->s_iowait);
+			iowait_sdma_drain(&priv->s_iowait);
 			flush_tx_list(qp);
 			remove_qp(dev, qp);
 			wait_event(qp->wait, !atomic_read(&qp->refcount));
@@ -805,8 +811,8 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		qp->remote_ah_attr = attr->ah_attr;
 		qp->s_srate = attr->ah_attr.static_rate;
 		qp->srate_mbps = ib_rate_to_mbps(qp->s_srate);
-		qp->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
-		qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
+		priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
+		qp->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
@@ -821,8 +827,8 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			qp->port_num = qp->alt_ah_attr.port_num;
 			qp->s_pkey_index = qp->s_alt_pkey_index;
 			qp->s_flags |= HFI1_S_AHG_CLEAR;
-			qp->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
-			qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
+			priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
+			qp->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
 		}
 	}
 
@@ -1031,6 +1037,7 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 			     struct ib_udata *udata)
 {
 	struct hfi1_qp *qp;
+	struct hfi1_qp_priv *priv;
 	int err;
 	struct hfi1_swqe *swq = NULL;
 	struct hfi1_ibdev *dev;
@@ -1098,11 +1105,18 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 			goto bail_swq;
 		}
 		RCU_INIT_POINTER(qp->next, NULL);
-		qp->s_hdr = kzalloc(sizeof(*qp->s_hdr), GFP_KERNEL);
-		if (!qp->s_hdr) {
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+		if (!priv) {
+			ret = ERR_PTR(-ENOMEM);
+			goto bail_qp_priv;
+		}
+		priv->owner = qp;
+		priv->s_hdr = kzalloc(sizeof(*priv->s_hdr), GFP_KERNEL);
+		if (!priv->s_hdr) {
 			ret = ERR_PTR(-ENOMEM);
 			goto bail_qp;
 		}
+		qp->priv = priv;
 		qp->timeout_jiffies =
 			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
 				1000UL);
@@ -1245,7 +1259,9 @@ bail_ip:
 		vfree(qp->r_rq.wq);
 	free_qpn(&dev->qp_dev->qpn_table, qp->ibqp.qp_num);
 bail_qp:
-	kfree(qp->s_hdr);
+	kfree(priv->s_hdr);
+	kfree(priv);
+bail_qp_priv:
 	kfree(qp);
 bail_swq:
 	vfree(swq);
@@ -1266,6 +1282,7 @@ int hfi1_destroy_qp(struct ib_qp *ibqp)
 {
 	struct hfi1_qp *qp = to_iqp(ibqp);
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
+	struct hfi1_qp_priv *priv = qp->priv;
 
 	/* Make sure HW and driver activity is stopped. */
 	spin_lock_irq(&qp->r_lock);
@@ -1276,9 +1293,9 @@ int hfi1_destroy_qp(struct ib_qp *ibqp)
 		qp->s_flags &= ~(HFI1_S_TIMER | HFI1_S_ANY_WAIT);
 		spin_unlock(&qp->s_lock);
 		spin_unlock_irq(&qp->r_lock);
-		cancel_work_sync(&qp->s_iowait.iowork);
+		cancel_work_sync(&priv->s_iowait.iowork);
 		del_timer_sync(&qp->s_timer);
-		iowait_sdma_drain(&qp->s_iowait);
+		iowait_sdma_drain(&priv->s_iowait);
 		flush_tx_list(qp);
 		remove_qp(dev, qp);
 		wait_event(qp->wait, !atomic_read(&qp->refcount));
@@ -1301,7 +1318,8 @@ int hfi1_destroy_qp(struct ib_qp *ibqp)
 	else
 		vfree(qp->r_rq.wq);
 	vfree(qp->s_wq);
-	kfree(qp->s_hdr);
+	kfree(priv->s_hdr);
+	kfree(priv);
 	kfree(qp);
 	return 0;
 }
@@ -1422,11 +1440,13 @@ static int iowait_sleep(
 {
 	struct verbs_txreq *tx = container_of(stx, struct verbs_txreq, txreq);
 	struct hfi1_qp *qp;
+	struct hfi1_qp_priv *priv;
 	unsigned long flags;
 	int ret = 0;
 	struct hfi1_ibdev *dev;
 
 	qp = tx->qp;
+	priv = qp->priv;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK) {
@@ -1442,13 +1462,13 @@ static int iowait_sleep(
 		write_seqlock(&dev->iowait_lock);
 		if (sdma_progress(sde, seq, stx))
 			goto eagain;
-		if (list_empty(&qp->s_iowait.list)) {
+		if (list_empty(&priv->s_iowait.list)) {
 			struct hfi1_ibport *ibp =
 				to_iport(qp->ibqp.device, qp->port_num);
 
 			ibp->n_dmawait++;
 			qp->s_flags |= HFI1_S_WAIT_DMA_DESC;
-			list_add_tail(&qp->s_iowait.list, &sde->dmawait);
+			list_add_tail(&priv->s_iowait.list, &sde->dmawait);
 			trace_hfi1_qpsleep(qp, HFI1_S_WAIT_DMA_DESC);
 			atomic_inc(&qp->refcount);
 		}
@@ -1470,7 +1490,7 @@ eagain:
 
 static void iowait_wakeup(struct iowait *wait, int reason)
 {
-	struct hfi1_qp *qp = container_of(wait, struct hfi1_qp, s_iowait);
+	struct hfi1_qp *qp = iowait_to_qp(wait);
 
 	WARN_ON(reason != SDMA_AVAIL_REASON);
 	hfi1_qp_wakeup(qp, HFI1_S_WAIT_DMA_DESC);
@@ -1651,9 +1671,10 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 {
 	struct hfi1_swqe *wqe;
 	struct hfi1_qp *qp = iter->qp;
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct sdma_engine *sde;
 
-	sde = qp_to_sdma_engine(qp, qp->s_sc);
+	sde = qp_to_sdma_engine(qp, priv->s_sc);
 	wqe = get_swqe_ptr(qp, qp->s_last);
 	seq_printf(s,
 		   "N %d %s QP%u R %u %s %u %u %u f=%x %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u) QP%u LID %x SL %u MTU %d %u %u %u SDE %p,%u\n",
@@ -1666,8 +1687,8 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   wqe ? wqe->wr.opcode : 0,
 		   qp->s_hdrwords,
 		   qp->s_flags,
-		   atomic_read(&qp->s_iowait.sdma_busy),
-		   !list_empty(&qp->s_iowait.list),
+		   atomic_read(&priv->s_iowait.sdma_busy),
+		   !list_empty(&priv->s_iowait.list),
 		   qp->timeout,
 		   wqe ? wqe->ssn : 0,
 		   qp->s_lsn,
@@ -1707,14 +1728,15 @@ void qp_comm_est(struct hfi1_qp *qp)
 void hfi1_migrate_qp(struct hfi1_qp *qp)
 {
 	struct ib_event ev;
+	struct hfi1_qp_priv *priv = qp->priv;
 
 	qp->s_mig_state = IB_MIG_MIGRATED;
 	qp->remote_ah_attr = qp->alt_ah_attr;
 	qp->port_num = qp->alt_ah_attr.port_num;
 	qp->s_pkey_index = qp->s_alt_pkey_index;
 	qp->s_flags |= HFI1_S_AHG_CLEAR;
-	qp->s_sc = ah_to_sc(qp->ibqp.device, &qp->remote_ah_attr);
-	qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
+	priv->s_sc = ah_to_sc(qp->ibqp.device, &qp->remote_ah_attr);
+	qp->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
 
 	ev.device = qp->ibqp.device;
 	ev.element.qp = &qp->ibqp;
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 94fd748..1d34c22 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -123,9 +123,11 @@ static inline struct hfi1_qp *hfi1_lookup_qpn(struct hfi1_ibport *ibp,
  */
 static inline void clear_ahg(struct hfi1_qp *qp)
 {
-	qp->s_hdr->ahgcount = 0;
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	priv->s_hdr->ahgcount = 0;
 	qp->s_flags &= ~(HFI1_S_AHG_VALID | HFI1_S_AHG_CLEAR);
-	if (qp->s_sde && qp->s_ahgidx >= 0)
+	if (qp->s_sde)
 		sdma_ahg_free(qp->s_sde, qp->s_ahgidx);
 	qp->s_ahgidx = -1;
 }
@@ -257,12 +259,13 @@ void qp_comm_est(struct hfi1_qp *qp);
  */
 static inline void _hfi1_schedule_send(struct hfi1_qp *qp)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ibport *ibp =
 		to_iport(qp->ibqp.device, qp->port_num);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 
-	iowait_schedule(&qp->s_iowait, ppd->hfi1_wq,
+	iowait_schedule(&priv->s_iowait, ppd->hfi1_wq,
 			qp->s_sde ?
 			qp->s_sde->cpu :
 			cpumask_first(cpumask_of_node(dd->assigned_node_id)));
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 6f4a155..d830a8f 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -259,6 +259,7 @@ bail:
  */
 int hfi1_make_rc_req(struct hfi1_qp *qp)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
 	struct hfi1_other_headers *ohdr;
 	struct hfi1_sge_state *ss;
@@ -275,9 +276,9 @@ int hfi1_make_rc_req(struct hfi1_qp *qp)
 	int middle = 0;
 	int delta;
 
-	ohdr = &qp->s_hdr->ibh.u.oth;
+	ohdr = &priv->s_hdr->ibh.u.oth;
 	if (qp->remote_ah_attr.ah_flags & IB_AH_GRH)
-		ohdr = &qp->s_hdr->ibh.u.l.oth;
+		ohdr = &priv->s_hdr->ibh.u.l.oth;
 
 	/*
 	 * The lock is needed to synchronize between the sending tasklet,
@@ -297,7 +298,7 @@ int hfi1_make_rc_req(struct hfi1_qp *qp)
 		if (qp->s_last == qp->s_head)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
-		if (atomic_read(&qp->s_iowait.sdma_busy)) {
+		if (atomic_read(&priv->s_iowait.sdma_busy)) {
 			qp->s_flags |= HFI1_S_WAIT_DMA;
 			goto bail;
 		}
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 1c9c054..736b44d 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -690,6 +690,7 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
  */
 static inline void build_ahg(struct hfi1_qp *qp, u32 npsn)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	if (unlikely(qp->s_flags & HFI1_S_AHG_CLEAR))
 		clear_ahg(qp);
 	if (!(qp->s_flags & HFI1_S_AHG_VALID)) {
@@ -698,19 +699,19 @@ static inline void build_ahg(struct hfi1_qp *qp, u32 npsn)
 			qp->s_ahgidx = sdma_ahg_alloc(qp->s_sde);
 		if (qp->s_ahgidx >= 0) {
 			qp->s_ahgpsn = npsn;
-			qp->s_hdr->tx_flags |= SDMA_TXREQ_F_AHG_COPY;
+			priv->s_hdr->tx_flags |= SDMA_TXREQ_F_AHG_COPY;
 			/* save to protect a change in another thread */
-			qp->s_hdr->sde = qp->s_sde;
-			qp->s_hdr->ahgidx = qp->s_ahgidx;
+			priv->s_hdr->sde = qp->s_sde;
+			priv->s_hdr->ahgidx = qp->s_ahgidx;
 			qp->s_flags |= HFI1_S_AHG_VALID;
 		}
 	} else {
 		/* subsequent middle after valid */
 		if (qp->s_ahgidx >= 0) {
-			qp->s_hdr->tx_flags |= SDMA_TXREQ_F_USE_AHG;
-			qp->s_hdr->ahgidx = qp->s_ahgidx;
-			qp->s_hdr->ahgcount++;
-			qp->s_hdr->ahgdesc[0] =
+			priv->s_hdr->tx_flags |= SDMA_TXREQ_F_USE_AHG;
+			priv->s_hdr->ahgidx = qp->s_ahgidx;
+			priv->s_hdr->ahgcount++;
+			priv->s_hdr->ahgdesc[0] =
 				sdma_build_ahg_descriptor(
 					(__force u16)cpu_to_be16((u16)npsn),
 					BTH2_OFFSET,
@@ -718,8 +719,8 @@ static inline void build_ahg(struct hfi1_qp *qp, u32 npsn)
 					16);
 			if ((npsn & 0xffff0000) !=
 					(qp->s_ahgpsn & 0xffff0000)) {
-				qp->s_hdr->ahgcount++;
-				qp->s_hdr->ahgdesc[1] =
+				priv->s_hdr->ahgcount++;
+				priv->s_hdr->ahgdesc[1] =
 					sdma_build_ahg_descriptor(
 						(__force u16)cpu_to_be16(
 							(u16)(npsn >> 16)),
@@ -735,6 +736,7 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 			  u32 bth0, u32 bth2, int middle)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct hfi1_qp_priv *priv = qp->priv;
 	u16 lrh0;
 	u32 nwords;
 	u32 extra_bytes;
@@ -745,13 +747,13 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 	nwords = (qp->s_cur_size + extra_bytes) >> 2;
 	lrh0 = HFI1_LRH_BTH;
 	if (unlikely(qp->remote_ah_attr.ah_flags & IB_AH_GRH)) {
-		qp->s_hdrwords += hfi1_make_grh(ibp, &qp->s_hdr->ibh.u.l.grh,
-					       &qp->remote_ah_attr.grh,
-					       qp->s_hdrwords, nwords);
+		qp->s_hdrwords += hfi1_make_grh(ibp, &priv->s_hdr->ibh.u.l.grh,
+						&qp->remote_ah_attr.grh,
+						qp->s_hdrwords, nwords);
 		lrh0 = HFI1_LRH_GRH;
 		middle = 0;
 	}
-	lrh0 |= (qp->s_sc & 0xf) << 12 | (qp->remote_ah_attr.sl & 0xf) << 4;
+	lrh0 |= (priv->s_sc & 0xf) << 12 | (qp->remote_ah_attr.sl & 0xf) << 4;
 	/*
 	 * reset s_hdr/AHG fields
 	 *
@@ -763,10 +765,10 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 	 * build_ahg() will modify as appropriate
 	 * to use the AHG feature.
 	 */
-	qp->s_hdr->tx_flags = 0;
-	qp->s_hdr->ahgcount = 0;
-	qp->s_hdr->ahgidx = 0;
-	qp->s_hdr->sde = NULL;
+	priv->s_hdr->tx_flags = 0;
+	priv->s_hdr->ahgcount = 0;
+	priv->s_hdr->ahgidx = 0;
+	priv->s_hdr->sde = NULL;
 	if (qp->s_mig_state == IB_MIG_MIGRATED)
 		bth0 |= IB_BTH_MIG_REQ;
 	else
@@ -775,11 +777,11 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 		build_ahg(qp, bth2);
 	else
 		qp->s_flags &= ~HFI1_S_AHG_VALID;
-	qp->s_hdr->ibh.lrh[0] = cpu_to_be16(lrh0);
-	qp->s_hdr->ibh.lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
-	qp->s_hdr->ibh.lrh[2] =
+	priv->s_hdr->ibh.lrh[0] = cpu_to_be16(lrh0);
+	priv->s_hdr->ibh.lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
+	priv->s_hdr->ibh.lrh[2] =
 		cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
-	qp->s_hdr->ibh.lrh[3] = cpu_to_be16(ppd_from_ibp(ibp)->lid |
+	priv->s_hdr->ibh.lrh[3] = cpu_to_be16(ppd_from_ibp(ibp)->lid |
 				       qp->remote_ah_attr.src_path_bits);
 	bth0 |= hfi1_get_pkey(ibp, qp->s_pkey_index);
 	bth0 |= extra_bytes << 20;
@@ -808,7 +810,7 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 void hfi1_do_send(struct work_struct *work)
 {
 	struct iowait *wait = container_of(work, struct iowait, iowork);
-	struct hfi1_qp *qp = container_of(wait, struct hfi1_qp, s_iowait);
+	struct hfi1_qp *qp = iowait_to_qp(wait);
 	struct hfi1_pkt_state ps;
 	int (*make_req)(struct hfi1_qp *qp);
 	unsigned long flags;
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 4f2a788..1908a28 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -63,6 +63,7 @@
  */
 int hfi1_make_uc_req(struct hfi1_qp *qp)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_other_headers *ohdr;
 	struct hfi1_swqe *wqe;
 	unsigned long flags;
@@ -82,7 +83,7 @@ int hfi1_make_uc_req(struct hfi1_qp *qp)
 		if (qp->s_last == qp->s_head)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
-		if (atomic_read(&qp->s_iowait.sdma_busy)) {
+		if (atomic_read(&priv->s_iowait.sdma_busy)) {
 			qp->s_flags |= HFI1_S_WAIT_DMA;
 			goto bail;
 		}
@@ -92,9 +93,9 @@ int hfi1_make_uc_req(struct hfi1_qp *qp)
 		goto done;
 	}
 
-	ohdr = &qp->s_hdr->ibh.u.oth;
+	ohdr = &priv->s_hdr->ibh.u.oth;
 	if (qp->remote_ah_attr.ah_flags & IB_AH_GRH)
-		ohdr = &qp->s_hdr->ibh.u.l.oth;
+		ohdr = &priv->s_hdr->ibh.u.l.oth;
 
 	/* Get the next send request. */
 	wqe = get_swqe_ptr(qp, qp->s_cur);
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 969335a..ba8a557 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -265,6 +265,7 @@ drop:
  */
 int hfi1_make_ud_req(struct hfi1_qp *qp)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_other_headers *ohdr;
 	struct ib_ah_attr *ah_attr;
 	struct hfi1_pportdata *ppd;
@@ -289,7 +290,7 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 		if (qp->s_last == qp->s_head)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
-		if (atomic_read(&qp->s_iowait.sdma_busy)) {
+		if (atomic_read(&priv->s_iowait.sdma_busy)) {
 			qp->s_flags |= HFI1_S_WAIT_DMA;
 			goto bail;
 		}
@@ -323,7 +324,7 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 			 * Instead of waiting, we could queue a
 			 * zero length descriptor so we get a callback.
 			 */
-			if (atomic_read(&qp->s_iowait.sdma_busy)) {
+			if (atomic_read(&priv->s_iowait.sdma_busy)) {
 				qp->s_flags |= HFI1_S_WAIT_DMA;
 				goto bail;
 			}
@@ -354,11 +355,11 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 
 	if (ah_attr->ah_flags & IB_AH_GRH) {
 		/* Header size in 32-bit words. */
-		qp->s_hdrwords += hfi1_make_grh(ibp, &qp->s_hdr->ibh.u.l.grh,
+		qp->s_hdrwords += hfi1_make_grh(ibp, &priv->s_hdr->ibh.u.l.grh,
 					       &ah_attr->grh,
 					       qp->s_hdrwords, nwords);
 		lrh0 = HFI1_LRH_GRH;
-		ohdr = &qp->s_hdr->ibh.u.l.oth;
+		ohdr = &priv->s_hdr->ibh.u.l.oth;
 		/*
 		 * Don't worry about sending to locally attached multicast
 		 * QPs.  It is unspecified by the spec. what happens.
@@ -366,7 +367,7 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 	} else {
 		/* Header size in 32-bit words. */
 		lrh0 = HFI1_LRH_BTH;
-		ohdr = &qp->s_hdr->ibh.u.oth;
+		ohdr = &priv->s_hdr->ibh.u.oth;
 	}
 	if (wqe->wr.opcode == IB_WR_SEND_WITH_IMM) {
 		qp->s_hdrwords++;
@@ -378,25 +379,25 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 	lrh0 |= (ah_attr->sl & 0xf) << 4;
 	if (qp->ibqp.qp_type == IB_QPT_SMI) {
 		lrh0 |= 0xF000; /* Set VL (see ch. 13.5.3.1) */
-		qp->s_sc = 0xf;
+		priv->s_sc = 0xf;
 	} else {
 		lrh0 |= (sc5 & 0xf) << 12;
-		qp->s_sc = sc5;
+		priv->s_sc = sc5;
 	}
-	qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
-	qp->s_hdr->ibh.lrh[0] = cpu_to_be16(lrh0);
-	qp->s_hdr->ibh.lrh[1] = cpu_to_be16(ah_attr->dlid);  /* DEST LID */
-	qp->s_hdr->ibh.lrh[2] =
+	qp->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
+	priv->s_hdr->ibh.lrh[0] = cpu_to_be16(lrh0);
+	priv->s_hdr->ibh.lrh[1] = cpu_to_be16(ah_attr->dlid);  /* DEST LID */
+	priv->s_hdr->ibh.lrh[2] =
 		cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
 	if (ah_attr->dlid == be16_to_cpu(IB_LID_PERMISSIVE))
-		qp->s_hdr->ibh.lrh[3] = IB_LID_PERMISSIVE;
+		priv->s_hdr->ibh.lrh[3] = IB_LID_PERMISSIVE;
 	else {
 		lid = ppd->lid;
 		if (lid) {
 			lid |= ah_attr->src_path_bits & ((1 << ppd->lmc) - 1);
-			qp->s_hdr->ibh.lrh[3] = cpu_to_be16(lid);
+			priv->s_hdr->ibh.lrh[3] = cpu_to_be16(lid);
 		} else
-			qp->s_hdr->ibh.lrh[3] = IB_LID_PERMISSIVE;
+			priv->s_hdr->ibh.lrh[3] = IB_LID_PERMISSIVE;
 	}
 	if (wqe->wr.send_flags & IB_SEND_SOLICITED)
 		bth0 |= IB_BTH_SOLICITED;
@@ -416,10 +417,10 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 					 qp->qkey : wqe->ud_wr.remote_qkey);
 	ohdr->u.ud.deth[1] = cpu_to_be32(qp->ibqp.qp_num);
 	/* disarm any ahg */
-	qp->s_hdr->ahgcount = 0;
-	qp->s_hdr->ahgidx = 0;
-	qp->s_hdr->tx_flags = 0;
-	qp->s_hdr->sde = NULL;
+	priv->s_hdr->ahgcount = 0;
+	priv->s_hdr->ahgidx = 0;
+	priv->s_hdr->tx_flags = 0;
+	priv->s_hdr->sde = NULL;
 
 done:
 	ret = 1;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 9abf691..b810142 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -486,6 +486,7 @@ static int post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		     struct ib_send_wr **bad_wr)
 {
 	struct hfi1_qp *qp = to_iqp(ibqp);
+	struct hfi1_qp_priv *priv = qp->priv;
 	int err = 0;
 	int call_send;
 	unsigned long flags;
@@ -515,7 +516,7 @@ bail:
 	if (nreq && !call_send)
 		_hfi1_schedule_send(qp);
 	if (nreq && call_send)
-		hfi1_do_send(&qp->s_iowait.iowork);
+		hfi1_do_send(&priv->s_iowait.iowork);
 	return err;
 }
 
@@ -698,12 +699,14 @@ static void mem_timer(unsigned long data)
 	struct hfi1_qp *qp = NULL;
 	struct iowait *wait;
 	unsigned long flags;
+	struct hfi1_qp_priv *priv;
 
 	write_seqlock_irqsave(&dev->iowait_lock, flags);
 	if (!list_empty(list)) {
 		wait = list_first_entry(list, struct iowait, list);
-		qp = container_of(wait, struct hfi1_qp, s_iowait);
-		list_del_init(&qp->s_iowait.list);
+		qp = iowait_to_qp(wait);
+		priv = qp->priv;
+		list_del_init(&priv->s_iowait.list);
 		/* refcount held until actual wake up */
 		if (!list_empty(list))
 			mod_timer(&dev->mem_timer, jiffies + 1);
@@ -738,6 +741,7 @@ void update_sge(struct hfi1_sge_state *ss, u32 length)
 static noinline struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 						struct hfi1_qp *qp)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct verbs_txreq *tx;
 	unsigned long flags;
 
@@ -746,10 +750,10 @@ static noinline struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 		spin_lock_irqsave(&qp->s_lock, flags);
 		write_seqlock(&dev->iowait_lock);
 		if (ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK &&
-		    list_empty(&qp->s_iowait.list)) {
+		    list_empty(&priv->s_iowait.list)) {
 			dev->n_txwait++;
 			qp->s_flags |= HFI1_S_WAIT_TX;
-			list_add_tail(&qp->s_iowait.list, &dev->txwait);
+			list_add_tail(&priv->s_iowait.list, &dev->txwait);
 			trace_hfi1_qpsleep(qp, HFI1_S_WAIT_TX);
 			atomic_inc(&qp->refcount);
 		}
@@ -783,6 +787,7 @@ void hfi1_put_txreq(struct verbs_txreq *tx)
 	struct hfi1_qp *qp;
 	unsigned long flags;
 	unsigned int seq;
+	struct hfi1_qp_priv *priv;
 
 	qp = tx->qp;
 	dev = to_idev(qp->ibqp.device);
@@ -805,8 +810,9 @@ void hfi1_put_txreq(struct verbs_txreq *tx)
 			/* Wake up first QP wanting a free struct */
 			wait = list_first_entry(&dev->txwait, struct iowait,
 						list);
-			qp = container_of(wait, struct hfi1_qp, s_iowait);
-			list_del_init(&qp->s_iowait.list);
+			qp = iowait_to_qp(wait);
+			priv = qp->priv;
+			list_del_init(&priv->s_iowait.list);
 			/* refcount held until actual wake up */
 			write_sequnlock_irqrestore(&dev->iowait_lock, flags);
 			hfi1_qp_wakeup(qp, HFI1_S_WAIT_TX);
@@ -856,17 +862,18 @@ static void verbs_sdma_complete(
 
 static int wait_kmem(struct hfi1_ibdev *dev, struct hfi1_qp *qp)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	unsigned long flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK) {
 		write_seqlock(&dev->iowait_lock);
-		if (list_empty(&qp->s_iowait.list)) {
+		if (list_empty(&priv->s_iowait.list)) {
 			if (list_empty(&dev->memwait))
 				mod_timer(&dev->mem_timer, jiffies + 1);
 			qp->s_flags |= HFI1_S_WAIT_KMEM;
-			list_add_tail(&qp->s_iowait.list, &dev->memwait);
+			list_add_tail(&priv->s_iowait.list, &dev->memwait);
 			trace_hfi1_qpsleep(qp, HFI1_S_WAIT_KMEM);
 			atomic_inc(&qp->refcount);
 		}
@@ -1004,7 +1011,8 @@ bail_txadd:
 int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
 			u64 pbc)
 {
-	struct ahg_ib_header *ahdr = qp->s_hdr;
+	struct hfi1_qp_priv *priv = qp->priv;
+	struct ahg_ib_header *ahdr = priv->s_hdr;
 	u32 hdrwords = qp->s_hdrwords;
 	struct hfi1_sge_state *ss = qp->s_cur_sge;
 	u32 len = qp->s_cur_size;
@@ -1014,17 +1022,17 @@ int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
 	struct verbs_txreq *tx;
 	struct sdma_txreq *stx;
 	u64 pbc_flags = 0;
-	u8 sc5 = qp->s_sc;
+	u8 sc5 = priv->s_sc;
 	int ret;
 
-	if (!list_empty(&qp->s_iowait.tx_head)) {
+	if (!list_empty(&priv->s_iowait.tx_head)) {
 		stx = list_first_entry(
-			&qp->s_iowait.tx_head,
+			&priv->s_iowait.tx_head,
 			struct sdma_txreq,
 			list);
 		list_del_init(&stx->list);
 		tx = container_of(stx, struct verbs_txreq, txreq);
-		ret = sdma_send_txreq(tx->sde, &qp->s_iowait, stx);
+		ret = sdma_send_txreq(tx->sde, &priv->s_iowait, stx);
 		if (unlikely(ret == -ECOMM))
 			goto bail_ecomm;
 		return ret;
@@ -1053,7 +1061,7 @@ int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
 	if (unlikely(ret))
 		goto bail_build;
 	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device), &ahdr->ibh);
-	ret =  sdma_send_txreq(tx->sde, &qp->s_iowait, &tx->txreq);
+	ret =  sdma_send_txreq(tx->sde, &priv->s_iowait, &tx->txreq);
 	if (unlikely(ret == -ECOMM))
 		goto bail_ecomm;
 	return ret;
@@ -1075,6 +1083,7 @@ bail_tx:
  */
 static int no_bufs_available(struct hfi1_qp *qp, struct send_context *sc)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_devdata *dd = sc->dd;
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
 	unsigned long flags;
@@ -1089,14 +1098,14 @@ static int no_bufs_available(struct hfi1_qp *qp, struct send_context *sc)
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK) {
 		write_seqlock(&dev->iowait_lock);
-		if (list_empty(&qp->s_iowait.list)) {
+		if (list_empty(&priv->s_iowait.list)) {
 			struct hfi1_ibdev *dev = &dd->verbs_dev;
 			int was_empty;
 
 			dev->n_piowait++;
 			qp->s_flags |= HFI1_S_WAIT_PIO;
 			was_empty = list_empty(&sc->piowait);
-			list_add_tail(&qp->s_iowait.list, &sc->piowait);
+			list_add_tail(&priv->s_iowait.list, &sc->piowait);
 			trace_hfi1_qpsleep(qp, HFI1_S_WAIT_PIO);
 			atomic_inc(&qp->refcount);
 			/* counting: only call wantpiobuf_intr if first user */
@@ -1126,7 +1135,8 @@ struct send_context *qp_to_send_context(struct hfi1_qp *qp, u8 sc5)
 int hfi1_verbs_send_pio(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
 			u64 pbc)
 {
-	struct ahg_ib_header *ahdr = qp->s_hdr;
+	struct hfi1_qp_priv *priv = qp->priv;
+	struct ahg_ib_header *ahdr = priv->s_hdr;
 	u32 hdrwords = qp->s_hdrwords;
 	struct hfi1_sge_state *ss = qp->s_cur_sge;
 	u32 len = qp->s_cur_size;
@@ -1142,7 +1152,7 @@ int hfi1_verbs_send_pio(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
 	int wc_status = IB_WC_SUCCESS;
 
 	/* vl15 special case taken care of in ud.c */
-	sc5 = qp->s_sc;
+	sc5 = priv->s_sc;
 	sc = qp_to_send_context(qp, sc5);
 
 	if (!sc)
@@ -1249,11 +1259,12 @@ static inline int egress_pkey_check(struct hfi1_pportdata *ppd,
 				    struct hfi1_ib_header *hdr,
 				    struct hfi1_qp *qp)
 {
+	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_other_headers *ohdr;
 	struct hfi1_devdata *dd;
 	int i = 0;
 	u16 pkey;
-	u8 lnh, sc5 = qp->s_sc;
+	u8 lnh, sc5 = priv->s_sc;
 
 	if (!(ppd->part_enforce & HFI1_PART_ENFORCE_OUT))
 		return 0;
@@ -1312,7 +1323,8 @@ bad:
 int hfi1_verbs_send(struct hfi1_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
-	struct ahg_ib_header *ahdr = qp->s_hdr;
+	struct hfi1_qp_priv *priv = qp->priv;
+	struct ahg_ib_header *ahdr = priv->s_hdr;
 	int ret;
 	int pio = 0;
 	unsigned long flags = 0;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index d80111f..e35c918 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -387,6 +387,18 @@ struct hfi1_ack_entry {
 };
 
 /*
+ * hfi1 specific data structures that will be hidden from rvt after the queue
+ * pair is made common
+ */
+struct hfi1_qp;
+struct hfi1_qp_priv {
+	struct ahg_ib_header *s_hdr; /* next packet header to send */
+	u8 s_sc;		     /* SC[0..4] for next packet */
+	struct iowait s_iowait;
+	struct hfi1_qp *owner;
+};
+
+/*
  * Variables prefixed with s_ are for the requester (sender).
  * Variables prefixed with r_ are for the responder (receiver).
  * Variables prefixed with ack_ are for responder replies.
@@ -396,15 +408,13 @@ struct hfi1_ack_entry {
  */
 struct hfi1_qp {
 	struct ib_qp ibqp;
+	void *priv;
 	/* read mostly fields above and below */
 	struct ib_ah_attr remote_ah_attr;
 	struct ib_ah_attr alt_ah_attr;
 	struct hfi1_qp __rcu *next;           /* link list for QPN hash table */
 	struct hfi1_swqe *s_wq;  /* send work queue */
 	struct hfi1_mmap_info *ip;
-	struct ahg_ib_header *s_hdr;     /* next packet header to send */
-	/* sc for UC/RC QPs - based on ah for UD */
-	u8 s_sc;
 	unsigned long timeout_jiffies;  /* computed from timeout */
 
 	enum ib_mtu path_mtu;
@@ -501,8 +511,6 @@ struct hfi1_qp {
 	struct hfi1_sge_state s_ack_rdma_sge;
 	struct timer_list s_timer;
 
-	struct iowait s_iowait;
-
 	struct hfi1_sge r_sg_list[0] /* verified SGEs */
 		____cacheline_aligned_in_smp;
 };
@@ -794,6 +802,14 @@ static inline struct hfi1_ibdev *to_idev(struct ib_device *ibdev)
 	return container_of(rdi, struct hfi1_ibdev, rdi);
 }
 
+static inline struct hfi1_qp *iowait_to_qp(struct  iowait *s_iowait)
+{
+	struct hfi1_qp_priv *priv;
+
+	priv = container_of(s_iowait, struct hfi1_qp_priv, s_iowait);
+	return priv->owner;
+}
+
 /*
  * Send if not busy or waiting for I/O and either
  * a RC response is pending or we can process send work requests.

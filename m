From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 06/10] IB/qib: Remove driver specific members from qib qp
 type
Date: Fri, 22 Jan 2016 12:45:11 -0800
Message-ID: <20160122204507.2022.83735.stgit@scvm10.sc.intel.com>
References: <20160122204145.2022.26449.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122204145.2022.26449.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In preparation for moving the queue pair data structure to rdmavt the
members of the driver specific queue pairs which are not common need to be
pushed off to a private driver structure. This structure will be available
in the queue pair once moved to rdmavt as a void pointer. This patch while
not adding a lot of value in and of itself is a prerequisite to move the
queue pair out of the drivers and into rdmavt.

The driver specific, private queue pair data structure should condense as
more of the send side code moves to rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c    |   76 ++++++++++++++++++++-------------
 drivers/infiniband/hw/qib/qib_rc.c    |    7 ++-
 drivers/infiniband/hw/qib/qib_ruc.c   |   18 +++++---
 drivers/infiniband/hw/qib/qib_sdma.c  |   17 +++++--
 drivers/infiniband/hw/qib/qib_uc.c    |    7 ++-
 drivers/infiniband/hw/qib/qib_ud.c    |   22 +++++-----
 drivers/infiniband/hw/qib/qib_verbs.c |   61 +++++++++++++++++---------
 drivers/infiniband/hw/qib/qib_verbs.h |   26 ++++++++---
 8 files changed, 145 insertions(+), 89 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 6c17c90..aaa1cf9 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -371,10 +371,11 @@ struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
  */
 static void qib_reset_qp(struct qib_qp *qp, enum ib_qp_type type)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	qp->remote_qpn = 0;
 	qp->qkey = 0;
 	qp->qp_access_flags = 0;
-	atomic_set(&qp->s_dma_busy, 0);
+	atomic_set(&priv->s_dma_busy, 0);
 	qp->s_flags &= QIB_S_SIGNAL_REQ_WR;
 	qp->s_hdrwords = 0;
 	qp->s_wqe = NULL;
@@ -474,6 +475,7 @@ static void clear_mr_refs(struct qib_qp *qp, int clr_sends)
  */
 int qib_error_qp(struct qib_qp *qp, enum ib_wc_status err)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
 	struct ib_wc wc;
 	int ret = 0;
@@ -492,9 +494,9 @@ int qib_error_qp(struct qib_qp *qp, enum ib_wc_status err)
 		qp->s_flags &= ~QIB_S_ANY_WAIT_SEND;
 
 	spin_lock(&dev->pending_lock);
-	if (!list_empty(&qp->iowait) && !(qp->s_flags & QIB_S_BUSY)) {
+	if (!list_empty(&priv->iowait) && !(qp->s_flags & QIB_S_BUSY)) {
 		qp->s_flags &= ~QIB_S_ANY_WAIT_IO;
-		list_del_init(&qp->iowait);
+		list_del_init(&priv->iowait);
 	}
 	spin_unlock(&dev->pending_lock);
 
@@ -504,9 +506,9 @@ int qib_error_qp(struct qib_qp *qp, enum ib_wc_status err)
 			qib_put_mr(qp->s_rdma_mr);
 			qp->s_rdma_mr = NULL;
 		}
-		if (qp->s_tx) {
-			qib_put_txreq(qp->s_tx);
-			qp->s_tx = NULL;
+		if (priv->s_tx) {
+			qib_put_txreq(priv->s_tx);
+			priv->s_tx = NULL;
 		}
 	}
 
@@ -572,6 +574,7 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 {
 	struct qib_ibdev *dev = to_idev(ibqp->device);
 	struct qib_qp *qp = to_iqp(ibqp);
+	struct qib_qp_priv *priv = qp->priv;
 	enum ib_qp_state cur_state, new_state;
 	struct ib_event ev;
 	int lastwqe = 0;
@@ -699,19 +702,20 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (qp->state != IB_QPS_RESET) {
 			qp->state = IB_QPS_RESET;
 			spin_lock(&dev->pending_lock);
-			if (!list_empty(&qp->iowait))
-				list_del_init(&qp->iowait);
+			if (!list_empty(&priv->iowait))
+				list_del_init(&priv->iowait);
 			spin_unlock(&dev->pending_lock);
 			qp->s_flags &= ~(QIB_S_TIMER | QIB_S_ANY_WAIT);
 			spin_unlock(&qp->s_lock);
 			spin_unlock_irq(&qp->r_lock);
 			/* Stop the sending work queue and retry timer */
-			cancel_work_sync(&qp->s_work);
+			cancel_work_sync(&priv->s_work);
 			del_timer_sync(&qp->s_timer);
-			wait_event(qp->wait_dma, !atomic_read(&qp->s_dma_busy));
-			if (qp->s_tx) {
-				qib_put_txreq(qp->s_tx);
-				qp->s_tx = NULL;
+			wait_event(priv->wait_dma,
+				   !atomic_read(&priv->s_dma_busy));
+			if (priv->s_tx) {
+				qib_put_txreq(priv->s_tx);
+				priv->s_tx = NULL;
 			}
 			remove_qp(dev, qp);
 			wait_event(qp->wait, !atomic_read(&qp->refcount));
@@ -987,7 +991,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 	size_t sg_list_sz;
 	struct ib_qp *ret;
 	gfp_t gfp;
-
+	struct qib_qp_priv *priv;
 
 	if (init_attr->cap.max_send_sge > ib_qib_max_sges ||
 	    init_attr->cap.max_send_wr > ib_qib_max_qp_wrs ||
@@ -1055,11 +1059,18 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 			goto bail_swq;
 		}
 		RCU_INIT_POINTER(qp->next, NULL);
-		qp->s_hdr = kzalloc(sizeof(*qp->s_hdr), gfp);
-		if (!qp->s_hdr) {
+		priv = kzalloc(sizeof(*priv), gfp);
+		if (!priv) {
+			ret = ERR_PTR(-ENOMEM);
+			goto bail_qp_hdr;
+		}
+		priv->owner = qp;
+		priv->s_hdr = kzalloc(sizeof(*priv->s_hdr), gfp);
+		if (!priv->s_hdr) {
 			ret = ERR_PTR(-ENOMEM);
 			goto bail_qp;
 		}
+		qp->priv = priv;
 		qp->timeout_jiffies =
 			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
 				1000UL);
@@ -1095,11 +1106,11 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 		spin_lock_init(&qp->r_rq.lock);
 		atomic_set(&qp->refcount, 0);
 		init_waitqueue_head(&qp->wait);
-		init_waitqueue_head(&qp->wait_dma);
+		init_waitqueue_head(&priv->wait_dma);
 		init_timer(&qp->s_timer);
 		qp->s_timer.data = (unsigned long)qp;
-		INIT_WORK(&qp->s_work, qib_do_send);
-		INIT_LIST_HEAD(&qp->iowait);
+		INIT_WORK(&priv->s_work, qib_do_send);
+		INIT_LIST_HEAD(&priv->iowait);
 		INIT_LIST_HEAD(&qp->rspwait);
 		qp->state = IB_QPS_RESET;
 		qp->s_wq = swq;
@@ -1189,7 +1200,9 @@ bail_ip:
 		vfree(qp->r_rq.wq);
 	free_qpn(&dev->qpn_table, qp->ibqp.qp_num);
 bail_qp:
-	kfree(qp->s_hdr);
+	kfree(priv->s_hdr);
+	kfree(priv);
+bail_qp_hdr:
 	kfree(qp);
 bail_swq:
 	vfree(swq);
@@ -1210,23 +1223,24 @@ int qib_destroy_qp(struct ib_qp *ibqp)
 {
 	struct qib_qp *qp = to_iqp(ibqp);
 	struct qib_ibdev *dev = to_idev(ibqp->device);
+	struct qib_qp_priv *priv = qp->priv;
 
 	/* Make sure HW and driver activity is stopped. */
 	spin_lock_irq(&qp->s_lock);
 	if (qp->state != IB_QPS_RESET) {
 		qp->state = IB_QPS_RESET;
 		spin_lock(&dev->pending_lock);
-		if (!list_empty(&qp->iowait))
-			list_del_init(&qp->iowait);
+		if (!list_empty(&priv->iowait))
+			list_del_init(&priv->iowait);
 		spin_unlock(&dev->pending_lock);
 		qp->s_flags &= ~(QIB_S_TIMER | QIB_S_ANY_WAIT);
 		spin_unlock_irq(&qp->s_lock);
-		cancel_work_sync(&qp->s_work);
+		cancel_work_sync(&priv->s_work);
 		del_timer_sync(&qp->s_timer);
-		wait_event(qp->wait_dma, !atomic_read(&qp->s_dma_busy));
-		if (qp->s_tx) {
-			qib_put_txreq(qp->s_tx);
-			qp->s_tx = NULL;
+		wait_event(priv->wait_dma, !atomic_read(&priv->s_dma_busy));
+		if (priv->s_tx) {
+			qib_put_txreq(priv->s_tx);
+			priv->s_tx = NULL;
 		}
 		remove_qp(dev, qp);
 		wait_event(qp->wait, !atomic_read(&qp->refcount));
@@ -1245,7 +1259,8 @@ int qib_destroy_qp(struct ib_qp *ibqp)
 	else
 		vfree(qp->r_rq.wq);
 	vfree(qp->s_wq);
-	kfree(qp->s_hdr);
+	kfree(priv->s_hdr);
+	kfree(priv);
 	kfree(qp);
 	return 0;
 }
@@ -1368,6 +1383,7 @@ void qib_qp_iter_print(struct seq_file *s, struct qib_qp_iter *iter)
 {
 	struct qib_swqe *wqe;
 	struct qib_qp *qp = iter->qp;
+	struct qib_qp_priv *priv = qp->priv;
 
 	wqe = get_swqe_ptr(qp, qp->s_last);
 	seq_printf(s,
@@ -1379,8 +1395,8 @@ void qib_qp_iter_print(struct seq_file *s, struct qib_qp_iter *iter)
 		   wqe->wr.opcode,
 		   qp->s_hdrwords,
 		   qp->s_flags,
-		   atomic_read(&qp->s_dma_busy),
-		   !list_empty(&qp->iowait),
+		   atomic_read(&priv->s_dma_busy),
+		   !list_empty(&priv->iowait),
 		   qp->timeout,
 		   wqe->ssn,
 		   qp->s_lsn,
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index e6b7556..1506c02 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -230,6 +230,7 @@ bail:
  */
 int qib_make_rc_req(struct qib_qp *qp)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
 	struct qib_other_headers *ohdr;
 	struct qib_sge_state *ss;
@@ -244,9 +245,9 @@ int qib_make_rc_req(struct qib_qp *qp)
 	int ret = 0;
 	int delta;
 
-	ohdr = &qp->s_hdr->u.oth;
+	ohdr = &priv->s_hdr->u.oth;
 	if (qp->remote_ah_attr.ah_flags & IB_AH_GRH)
-		ohdr = &qp->s_hdr->u.l.oth;
+		ohdr = &priv->s_hdr->u.l.oth;
 
 	/*
 	 * The lock is needed to synchronize between the sending tasklet,
@@ -266,7 +267,7 @@ int qib_make_rc_req(struct qib_qp *qp)
 		if (qp->s_last == qp->s_head)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
-		if (atomic_read(&qp->s_dma_busy)) {
+		if (atomic_read(&priv->s_dma_busy)) {
 			qp->s_flags |= QIB_S_WAIT_DMA;
 			goto bail;
 		}
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 425c8c2..8985baa 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -675,6 +675,7 @@ u32 qib_make_grh(struct qib_ibport *ibp, struct ib_grh *hdr,
 void qib_make_ruc_header(struct qib_qp *qp, struct qib_other_headers *ohdr,
 			 u32 bth0, u32 bth2)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	u16 lrh0;
 	u32 nwords;
@@ -685,17 +686,18 @@ void qib_make_ruc_header(struct qib_qp *qp, struct qib_other_headers *ohdr,
 	nwords = (qp->s_cur_size + extra_bytes) >> 2;
 	lrh0 = QIB_LRH_BTH;
 	if (unlikely(qp->remote_ah_attr.ah_flags & IB_AH_GRH)) {
-		qp->s_hdrwords += qib_make_grh(ibp, &qp->s_hdr->u.l.grh,
+		qp->s_hdrwords += qib_make_grh(ibp, &priv->s_hdr->u.l.grh,
 					       &qp->remote_ah_attr.grh,
 					       qp->s_hdrwords, nwords);
 		lrh0 = QIB_LRH_GRH;
 	}
 	lrh0 |= ibp->sl_to_vl[qp->remote_ah_attr.sl] << 12 |
 		qp->remote_ah_attr.sl << 4;
-	qp->s_hdr->lrh[0] = cpu_to_be16(lrh0);
-	qp->s_hdr->lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
-	qp->s_hdr->lrh[2] = cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
-	qp->s_hdr->lrh[3] = cpu_to_be16(ppd_from_ibp(ibp)->lid |
+	priv->s_hdr->lrh[0] = cpu_to_be16(lrh0);
+	priv->s_hdr->lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
+	priv->s_hdr->lrh[2] =
+			cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
+	priv->s_hdr->lrh[3] = cpu_to_be16(ppd_from_ibp(ibp)->lid |
 				       qp->remote_ah_attr.src_path_bits);
 	bth0 |= qib_get_pkey(ibp, qp->s_pkey_index);
 	bth0 |= extra_bytes << 20;
@@ -717,7 +719,9 @@ void qib_make_ruc_header(struct qib_qp *qp, struct qib_other_headers *ohdr,
  */
 void qib_do_send(struct work_struct *work)
 {
-	struct qib_qp *qp = container_of(work, struct qib_qp, s_work);
+	struct qib_qp_priv *priv = container_of(work, struct qib_qp_priv,
+						s_work);
+	struct qib_qp *qp = priv->owner;
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 	int (*make_req)(struct qib_qp *qp);
@@ -756,7 +760,7 @@ void qib_do_send(struct work_struct *work)
 			 * If the packet cannot be sent now, return and
 			 * the send tasklet will be woken up later.
 			 */
-			if (qib_verbs_send(qp, qp->s_hdr, qp->s_hdrwords,
+			if (qib_verbs_send(qp, priv->s_hdr, qp->s_hdrwords,
 					   qp->s_cur_sge, qp->s_cur_size))
 				break;
 			/* Record that s_hdr is empty. */
diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index c6d6a54..ac4fcad 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -513,7 +513,9 @@ int qib_sdma_running(struct qib_pportdata *ppd)
 static void complete_sdma_err_req(struct qib_pportdata *ppd,
 				  struct qib_verbs_txreq *tx)
 {
-	atomic_inc(&tx->qp->s_dma_busy);
+	struct qib_qp_priv *priv = tx->qp->priv;
+
+	atomic_inc(&priv->s_dma_busy);
 	/* no sdma descriptors, so no unmap_desc */
 	tx->txreq.start_idx = 0;
 	tx->txreq.next_descq_idx = 0;
@@ -543,6 +545,7 @@ int qib_sdma_verbs_send(struct qib_pportdata *ppd,
 	u64 sdmadesc[2];
 	u32 dwoffset;
 	dma_addr_t addr;
+	struct qib_qp_priv *priv;
 
 	spin_lock_irqsave(&ppd->sdma_lock, flags);
 
@@ -644,8 +647,8 @@ retry:
 		descqp[0] |= cpu_to_le64(SDMA_DESC_DMA_HEAD);
 	if (tx->txreq.flags & QIB_SDMA_TXREQ_F_INTREQ)
 		descqp[0] |= cpu_to_le64(SDMA_DESC_INTR);
-
-	atomic_inc(&tx->qp->s_dma_busy);
+	priv = tx->qp->priv;
+	atomic_inc(&priv->s_dma_busy);
 	tx->txreq.next_descq_idx = tail;
 	ppd->dd->f_sdma_update_tail(ppd, tail);
 	ppd->sdma_descq_added += tx->txreq.sg_count;
@@ -663,6 +666,7 @@ unmap:
 		unmap_desc(ppd, tail);
 	}
 	qp = tx->qp;
+	priv = qp->priv;
 	qib_put_txreq(tx);
 	spin_lock(&qp->r_lock);
 	spin_lock(&qp->s_lock);
@@ -679,6 +683,7 @@ unmap:
 
 busy:
 	qp = tx->qp;
+	priv = qp->priv;
 	spin_lock(&qp->s_lock);
 	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
 		struct qib_ibdev *dev;
@@ -690,16 +695,16 @@ busy:
 		 */
 		tx->ss = ss;
 		tx->dwords = dwords;
-		qp->s_tx = tx;
+		priv->s_tx = tx;
 		dev = &ppd->dd->verbs_dev;
 		spin_lock(&dev->pending_lock);
-		if (list_empty(&qp->iowait)) {
+		if (list_empty(&priv->iowait)) {
 			struct qib_ibport *ibp;
 
 			ibp = &ppd->ibport_data;
 			ibp->n_dmawait++;
 			qp->s_flags |= QIB_S_WAIT_DMA_DESC;
-			list_add_tail(&qp->iowait, &dev->dmawait);
+			list_add_tail(&priv->iowait, &dev->dmawait);
 		}
 		spin_unlock(&dev->pending_lock);
 		qp->s_flags &= ~QIB_S_BUSY;
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 06a5645..d607656 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -45,6 +45,7 @@
  */
 int qib_make_uc_req(struct qib_qp *qp)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	struct qib_other_headers *ohdr;
 	struct qib_swqe *wqe;
 	unsigned long flags;
@@ -63,7 +64,7 @@ int qib_make_uc_req(struct qib_qp *qp)
 		if (qp->s_last == qp->s_head)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
-		if (atomic_read(&qp->s_dma_busy)) {
+		if (atomic_read(&priv->s_dma_busy)) {
 			qp->s_flags |= QIB_S_WAIT_DMA;
 			goto bail;
 		}
@@ -72,9 +73,9 @@ int qib_make_uc_req(struct qib_qp *qp)
 		goto done;
 	}
 
-	ohdr = &qp->s_hdr->u.oth;
+	ohdr = &priv->s_hdr->u.oth;
 	if (qp->remote_ah_attr.ah_flags & IB_AH_GRH)
-		ohdr = &qp->s_hdr->u.l.oth;
+		ohdr = &priv->s_hdr->u.l.oth;
 
 	/* header size in 32-bit words LRH+BTH = (8+12)/4. */
 	hwords = 5;
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 32fc80c..682403a 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -235,6 +235,7 @@ drop:
  */
 int qib_make_ud_req(struct qib_qp *qp)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	struct qib_other_headers *ohdr;
 	struct ib_ah_attr *ah_attr;
 	struct qib_pportdata *ppd;
@@ -258,7 +259,7 @@ int qib_make_ud_req(struct qib_qp *qp)
 		if (qp->s_last == qp->s_head)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
-		if (atomic_read(&qp->s_dma_busy)) {
+		if (atomic_read(&priv->s_dma_busy)) {
 			qp->s_flags |= QIB_S_WAIT_DMA;
 			goto bail;
 		}
@@ -295,7 +296,7 @@ int qib_make_ud_req(struct qib_qp *qp)
 			 * XXX Instead of waiting, we could queue a
 			 * zero length descriptor so we get a callback.
 			 */
-			if (atomic_read(&qp->s_dma_busy)) {
+			if (atomic_read(&priv->s_dma_busy)) {
 				qp->s_flags |= QIB_S_WAIT_DMA;
 				goto bail;
 			}
@@ -325,11 +326,11 @@ int qib_make_ud_req(struct qib_qp *qp)
 
 	if (ah_attr->ah_flags & IB_AH_GRH) {
 		/* Header size in 32-bit words. */
-		qp->s_hdrwords += qib_make_grh(ibp, &qp->s_hdr->u.l.grh,
+		qp->s_hdrwords += qib_make_grh(ibp, &priv->s_hdr->u.l.grh,
 					       &ah_attr->grh,
 					       qp->s_hdrwords, nwords);
 		lrh0 = QIB_LRH_GRH;
-		ohdr = &qp->s_hdr->u.l.oth;
+		ohdr = &priv->s_hdr->u.l.oth;
 		/*
 		 * Don't worry about sending to locally attached multicast
 		 * QPs.  It is unspecified by the spec. what happens.
@@ -337,7 +338,7 @@ int qib_make_ud_req(struct qib_qp *qp)
 	} else {
 		/* Header size in 32-bit words. */
 		lrh0 = QIB_LRH_BTH;
-		ohdr = &qp->s_hdr->u.oth;
+		ohdr = &priv->s_hdr->u.oth;
 	}
 	if (wqe->wr.opcode == IB_WR_SEND_WITH_IMM) {
 		qp->s_hdrwords++;
@@ -350,15 +351,16 @@ int qib_make_ud_req(struct qib_qp *qp)
 		lrh0 |= 0xF000; /* Set VL (see ch. 13.5.3.1) */
 	else
 		lrh0 |= ibp->sl_to_vl[ah_attr->sl] << 12;
-	qp->s_hdr->lrh[0] = cpu_to_be16(lrh0);
-	qp->s_hdr->lrh[1] = cpu_to_be16(ah_attr->dlid);  /* DEST LID */
-	qp->s_hdr->lrh[2] = cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
+	priv->s_hdr->lrh[0] = cpu_to_be16(lrh0);
+	priv->s_hdr->lrh[1] = cpu_to_be16(ah_attr->dlid);  /* DEST LID */
+	priv->s_hdr->lrh[2] =
+			cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
 	lid = ppd->lid;
 	if (lid) {
 		lid |= ah_attr->src_path_bits & ((1 << ppd->lmc) - 1);
-		qp->s_hdr->lrh[3] = cpu_to_be16(lid);
+		priv->s_hdr->lrh[3] = cpu_to_be16(lid);
 	} else
-		qp->s_hdr->lrh[3] = IB_LID_PERMISSIVE;
+		priv->s_hdr->lrh[3] = IB_LID_PERMISSIVE;
 	if (wqe->wr.send_flags & IB_SEND_SOLICITED)
 		bth0 |= IB_BTH_SOLICITED;
 	bth0 |= extra_bytes << 20;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 3bfa1a6..e55fc5f 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -486,6 +486,7 @@ static int qib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			 struct ib_send_wr **bad_wr)
 {
 	struct qib_qp *qp = to_iqp(ibqp);
+	struct qib_qp_priv *priv = qp->priv;
 	int err = 0;
 	int scheduled = 0;
 
@@ -499,7 +500,7 @@ static int qib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 	/* Try to do the send work in the caller's context. */
 	if (!scheduled)
-		qib_do_send(&qp->s_work);
+		qib_do_send(&priv->s_work);
 
 bail:
 	return err;
@@ -730,12 +731,14 @@ static void mem_timer(unsigned long data)
 	struct qib_ibdev *dev = (struct qib_ibdev *) data;
 	struct list_head *list = &dev->memwait;
 	struct qib_qp *qp = NULL;
+	struct qib_qp_priv *priv = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->pending_lock, flags);
 	if (!list_empty(list)) {
-		qp = list_entry(list->next, struct qib_qp, iowait);
-		list_del_init(&qp->iowait);
+		priv = list_entry(list->next, struct qib_qp_priv, iowait);
+		qp = priv->owner;
+		list_del_init(&priv->iowait);
 		atomic_inc(&qp->refcount);
 		if (!list_empty(list))
 			mod_timer(&dev->mem_timer, jiffies + 1);
@@ -950,6 +953,7 @@ static void copy_io(u32 __iomem *piobuf, struct qib_sge_state *ss,
 static noinline struct qib_verbs_txreq *__get_txreq(struct qib_ibdev *dev,
 					   struct qib_qp *qp)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	struct qib_verbs_txreq *tx;
 	unsigned long flags;
 
@@ -965,10 +969,10 @@ static noinline struct qib_verbs_txreq *__get_txreq(struct qib_ibdev *dev,
 		tx = list_entry(l, struct qib_verbs_txreq, txreq.list);
 	} else {
 		if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK &&
-		    list_empty(&qp->iowait)) {
+		    list_empty(&priv->iowait)) {
 			dev->n_txwait++;
 			qp->s_flags |= QIB_S_WAIT_TX;
-			list_add_tail(&qp->iowait, &dev->txwait);
+			list_add_tail(&priv->iowait, &dev->txwait);
 		}
 		qp->s_flags &= ~QIB_S_BUSY;
 		spin_unlock(&dev->pending_lock);
@@ -1004,6 +1008,7 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 {
 	struct qib_ibdev *dev;
 	struct qib_qp *qp;
+	struct qib_qp_priv *priv;
 	unsigned long flags;
 
 	qp = tx->qp;
@@ -1030,8 +1035,10 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 
 	if (!list_empty(&dev->txwait)) {
 		/* Wake up first QP wanting a free struct */
-		qp = list_entry(dev->txwait.next, struct qib_qp, iowait);
-		list_del_init(&qp->iowait);
+		priv = list_entry(dev->txwait.next, struct qib_qp_priv,
+				  iowait);
+		qp = priv->owner;
+		list_del_init(&priv->iowait);
 		atomic_inc(&qp->refcount);
 		spin_unlock_irqrestore(&dev->pending_lock, flags);
 
@@ -1057,6 +1064,7 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 {
 	struct qib_qp *qp, *nqp;
+	struct qib_qp_priv *qpp, *nqpp;
 	struct qib_qp *qps[20];
 	struct qib_ibdev *dev;
 	unsigned i, n;
@@ -1066,15 +1074,17 @@ void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 	spin_lock(&dev->pending_lock);
 
 	/* Search wait list for first QP wanting DMA descriptors. */
-	list_for_each_entry_safe(qp, nqp, &dev->dmawait, iowait) {
+	list_for_each_entry_safe(qpp, nqpp, &dev->dmawait, iowait) {
+		qp = qpp->owner;
+		nqp = nqpp->owner;
 		if (qp->port_num != ppd->port)
 			continue;
 		if (n == ARRAY_SIZE(qps))
 			break;
-		if (qp->s_tx->txreq.sg_count > avail)
+		if (qpp->s_tx->txreq.sg_count > avail)
 			break;
-		avail -= qp->s_tx->txreq.sg_count;
-		list_del_init(&qp->iowait);
+		avail -= qpp->s_tx->txreq.sg_count;
+		list_del_init(&qpp->iowait);
 		atomic_inc(&qp->refcount);
 		qps[n++] = qp;
 	}
@@ -1102,6 +1112,7 @@ static void sdma_complete(struct qib_sdma_txreq *cookie, int status)
 	struct qib_verbs_txreq *tx =
 		container_of(cookie, struct qib_verbs_txreq, txreq);
 	struct qib_qp *qp = tx->qp;
+	struct qib_qp_priv *priv = qp->priv;
 
 	spin_lock(&qp->s_lock);
 	if (tx->wqe)
@@ -1118,9 +1129,9 @@ static void sdma_complete(struct qib_sdma_txreq *cookie, int status)
 		}
 		qib_rc_send_complete(qp, hdr);
 	}
-	if (atomic_dec_and_test(&qp->s_dma_busy)) {
+	if (atomic_dec_and_test(&priv->s_dma_busy)) {
 		if (qp->state == IB_QPS_RESET)
-			wake_up(&qp->wait_dma);
+			wake_up(&priv->wait_dma);
 		else if (qp->s_flags & QIB_S_WAIT_DMA) {
 			qp->s_flags &= ~QIB_S_WAIT_DMA;
 			qib_schedule_send(qp);
@@ -1133,17 +1144,18 @@ static void sdma_complete(struct qib_sdma_txreq *cookie, int status)
 
 static int wait_kmem(struct qib_ibdev *dev, struct qib_qp *qp)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	unsigned long flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
 		spin_lock(&dev->pending_lock);
-		if (list_empty(&qp->iowait)) {
+		if (list_empty(&priv->iowait)) {
 			if (list_empty(&dev->memwait))
 				mod_timer(&dev->mem_timer, jiffies + 1);
 			qp->s_flags |= QIB_S_WAIT_KMEM;
-			list_add_tail(&qp->iowait, &dev->memwait);
+			list_add_tail(&priv->iowait, &dev->memwait);
 		}
 		spin_unlock(&dev->pending_lock);
 		qp->s_flags &= ~QIB_S_BUSY;
@@ -1158,6 +1170,7 @@ static int qib_verbs_send_dma(struct qib_qp *qp, struct qib_ib_header *hdr,
 			      u32 hdrwords, struct qib_sge_state *ss, u32 len,
 			      u32 plen, u32 dwords)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
 	struct qib_devdata *dd = dd_from_dev(dev);
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
@@ -1168,9 +1181,9 @@ static int qib_verbs_send_dma(struct qib_qp *qp, struct qib_ib_header *hdr,
 	u32 ndesc;
 	int ret;
 
-	tx = qp->s_tx;
+	tx = priv->s_tx;
 	if (tx) {
-		qp->s_tx = NULL;
+		priv->s_tx = NULL;
 		/* resend previously constructed packet */
 		ret = qib_sdma_verbs_send(ppd, tx->ss, tx->dwords, tx);
 		goto bail;
@@ -1260,6 +1273,7 @@ bail_tx:
  */
 static int no_bufs_available(struct qib_qp *qp)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
 	struct qib_devdata *dd;
 	unsigned long flags;
@@ -1274,10 +1288,10 @@ static int no_bufs_available(struct qib_qp *qp)
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
 		spin_lock(&dev->pending_lock);
-		if (list_empty(&qp->iowait)) {
+		if (list_empty(&priv->iowait)) {
 			dev->n_piowait++;
 			qp->s_flags |= QIB_S_WAIT_PIO;
-			list_add_tail(&qp->iowait, &dev->piowait);
+			list_add_tail(&priv->iowait, &dev->piowait);
 			dd = dd_from_dev(dev);
 			dd->f_wantpiobuf_intr(dd, 1);
 		}
@@ -1534,6 +1548,7 @@ void qib_ib_piobufavail(struct qib_devdata *dd)
 	struct qib_qp *qp;
 	unsigned long flags;
 	unsigned i, n;
+	struct qib_qp_priv *priv;
 
 	list = &dev->piowait;
 	n = 0;
@@ -1548,8 +1563,9 @@ void qib_ib_piobufavail(struct qib_devdata *dd)
 	while (!list_empty(list)) {
 		if (n == ARRAY_SIZE(qps))
 			goto full;
-		qp = list_entry(list->next, struct qib_qp, iowait);
-		list_del_init(&qp->iowait);
+		priv = list_entry(list->next, struct qib_qp_priv, iowait);
+		qp = priv->owner;
+		list_del_init(&priv->iowait);
 		atomic_inc(&qp->refcount);
 		qps[n++] = qp;
 	}
@@ -2330,11 +2346,12 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
  */
 void qib_schedule_send(struct qib_qp *qp)
 {
+	struct qib_qp_priv *priv = qp->priv;
 	if (qib_send_ok(qp)) {
 		struct qib_ibport *ibp =
 			to_iport(qp->ibqp.device, qp->port_num);
 		struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 
-		queue_work(ppd->qib_wq, &qp->s_work);
+		queue_work(ppd->qib_wq, &priv->s_work);
 	}
 }
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index f1ca5d1..a0cf23f 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -413,6 +413,21 @@ struct qib_ack_entry {
 };
 
 /*
+ * qib specific data structure that will be hidden from rvt after the queue pair
+ * is made common.
+ */
+struct qib_qp;
+struct qib_qp_priv {
+	struct qib_ib_header *s_hdr;    /* next packet header to send */
+	struct list_head iowait;        /* link for wait PIO buf */
+	atomic_t s_dma_busy;
+	struct qib_verbs_txreq *s_tx;
+	struct work_struct s_work;
+	wait_queue_head_t wait_dma;
+	struct qib_qp *owner;
+};
+
+/*
  * Variables prefixed with s_ are for the requester (sender).
  * Variables prefixed with r_ are for the responder (receiver).
  * Variables prefixed with ack_ are for responder replies.
@@ -422,13 +437,13 @@ struct qib_ack_entry {
  */
 struct qib_qp {
 	struct ib_qp ibqp;
+	struct qib_qp_priv *priv;
 	/* read mostly fields above and below */
 	struct ib_ah_attr remote_ah_attr;
 	struct ib_ah_attr alt_ah_attr;
 	struct qib_qp __rcu *next;            /* link list for QPN hash table */
 	struct qib_swqe *s_wq;  /* send work queue */
 	struct qib_mmap_info *ip;
-	struct qib_ib_header *s_hdr;     /* next packet header to send */
 	unsigned long timeout_jiffies;  /* computed from timeout */
 
 	enum ib_mtu path_mtu;
@@ -486,11 +501,11 @@ struct qib_qp {
 	spinlock_t s_lock ____cacheline_aligned_in_smp;
 	struct qib_sge_state *s_cur_sge;
 	u32 s_flags;
-	struct qib_verbs_txreq *s_tx;
+
 	struct qib_swqe *s_wqe;
 	struct qib_sge_state s_sge;     /* current send request data */
 	struct qib_mregion *s_rdma_mr;
-	atomic_t s_dma_busy;
+
 	u32 s_cur_size;         /* size of send packet in bytes */
 	u32 s_len;              /* total length of s_sge */
 	u32 s_rdma_read_len;    /* total length of s_rdma_read_sge */
@@ -521,11 +536,6 @@ struct qib_qp {
 
 	struct qib_sge_state s_ack_rdma_sge;
 	struct timer_list s_timer;
-	struct list_head iowait;        /* link for wait PIO buf */
-
-	struct work_struct s_work;
-
-	wait_queue_head_t wait_dma;
 
 	struct qib_sge r_sg_list[0] /* verified SGEs */
 		____cacheline_aligned_in_smp;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 25/31] staging/rdma/hfi1: Remove modify queue pair from hfi1
Date: Tue, 19 Jan 2016 14:43:44 -0800
Message-ID: <20160119224344.32765.76742.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In addition to removing the modify queue pair verb from hfi1 we also
remove ancillary functions which existed only for modify queue pair and
are also already present in hfi1.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c  |    7 
 drivers/staging/rdma/hfi1/common.h |    1 
 drivers/staging/rdma/hfi1/driver.c |   19 +
 drivers/staging/rdma/hfi1/qp.c     |  631 +++++++-----------------------------
 drivers/staging/rdma/hfi1/qp.h     |   65 ----
 drivers/staging/rdma/hfi1/rc.c     |   24 +
 drivers/staging/rdma/hfi1/ruc.c    |   17 +
 drivers/staging/rdma/hfi1/srq.c    |    4 
 drivers/staging/rdma/hfi1/trace.c  |    2 
 drivers/staging/rdma/hfi1/trace.h  |   35 --
 drivers/staging/rdma/hfi1/uc.c     |   16 -
 drivers/staging/rdma/hfi1/ud.c     |   15 -
 drivers/staging/rdma/hfi1/verbs.c  |   24 +
 drivers/staging/rdma/hfi1/verbs.h  |   31 --
 14 files changed, 205 insertions(+), 686 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index bc4e2eb..a12b9a0 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1096,13 +1096,6 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			qp->remote_ah_attr = qp->alt_ah_attr;
 			qp->port_num = qp->alt_ah_attr.port_num;
 			qp->s_pkey_index = qp->s_alt_pkey_index;
-
-			/*
-			 * Ignored by drivers which do not support it. Not
-			 * really worth creating a call back into the driver
-			 * just to set a flag.
-			 */
-			qp->s_flags |= RVT_S_AHG_CLEAR;
 		}
 	}
 
diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
index cb5ca79..dcf8edf 100644
--- a/drivers/staging/rdma/hfi1/common.h
+++ b/drivers/staging/rdma/hfi1/common.h
@@ -345,7 +345,6 @@ struct hfi1_message_header {
 #define HFI1_AETH_CREDIT_MASK 0x1F
 #define HFI1_AETH_CREDIT_INVAL 0x1F
 #define HFI1_MSN_MASK 0xFFFFFF
-#define HFI1_QPN_MASK 0xFFFFFF
 #define HFI1_FECN_SHIFT 31
 #define HFI1_FECN_MASK 1
 #define HFI1_FECN_SMASK BIT(HFI1_FECN_SHIFT)
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index d57c08f..d848cc0 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -282,6 +282,8 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 	u32 rte = rhf_rcv_type_err(packet->rhf);
 	int lnh = be16_to_cpu(rhdr->lrh[0]) & 3;
 	struct hfi1_ibport *ibp = &ppd->ibport_data;
+	struct hfi1_devdata *dd = ppd->dd;
+	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 
 	if (packet->rhf & (RHF_VCRC_ERR | RHF_ICRC_ERR))
 		return;
@@ -316,13 +318,13 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			goto drop;
 
 		/* Get the destination QP number. */
-		qp_num = be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
+		qp_num = be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
 		if (lid < be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 			struct rvt_qp *qp;
 			unsigned long flags;
 
 			rcu_read_lock();
-			qp = hfi1_lookup_qpn(ibp, qp_num);
+			qp = rvt_lookup_qpn(rdi, &ibp->rvp, qp_num);
 			if (!qp) {
 				rcu_read_unlock();
 				goto drop;
@@ -397,9 +399,9 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 				sc5 |= 0x10;
 			sl = ibp->sc_to_sl[sc5];
 
-			lqpn = be32_to_cpu(bth[1]) & HFI1_QPN_MASK;
+			lqpn = be32_to_cpu(bth[1]) & RVT_QPN_MASK;
 			rcu_read_lock();
-			qp = hfi1_lookup_qpn(ibp, lqpn);
+			qp = rvt_lookup_qpn(rdi, &ibp->rvp, lqpn);
 			if (qp == NULL) {
 				rcu_read_unlock();
 				goto drop;
@@ -470,7 +472,7 @@ static void process_ecn(struct rvt_qp *qp, struct hfi1_ib_header *hdr,
 	case IB_QPT_GSI:
 	case IB_QPT_UD:
 		rlid = be16_to_cpu(hdr->lrh[3]);
-		rqpn = be32_to_cpu(ohdr->u.ud.deth[1]) & HFI1_QPN_MASK;
+		rqpn = be32_to_cpu(ohdr->u.ud.deth[1]) & RVT_QPN_MASK;
 		svc_type = IB_CC_SVCTYPE_UD;
 		break;
 	case IB_QPT_UC:
@@ -500,7 +502,7 @@ static void process_ecn(struct rvt_qp *qp, struct hfi1_ib_header *hdr,
 
 	if (bth1 & HFI1_BECN_SMASK) {
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-		u32 lqpn = bth1 & HFI1_QPN_MASK;
+		u32 lqpn = bth1 & RVT_QPN_MASK;
 		u8 sl = ibp->sc_to_sl[sc5];
 
 		process_becn(ppd, sl, rlid, lqpn, rqpn, svc_type);
@@ -599,6 +601,7 @@ static void prescan_rxq(struct hfi1_packet *packet)
 		struct hfi1_ib_header *hdr;
 		struct hfi1_other_headers *ohdr;
 		struct ib_grh *grh = NULL;
+		struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 		u64 rhf = rhf_to_cpu(rhf_addr);
 		u32 etype = rhf_rcv_type(rhf), qpn, bth1;
 		int is_ecn = 0;
@@ -631,9 +634,9 @@ static void prescan_rxq(struct hfi1_packet *packet)
 		if (!is_ecn)
 			goto next;
 
-		qpn = bth1 & HFI1_QPN_MASK;
+		qpn = bth1 & RVT_QPN_MASK;
 		rcu_read_lock();
-		qp = hfi1_lookup_qpn(ibp, qpn);
+		qp = rvt_lookup_qpn(rdi, &ibp->rvp, qpn);
 
 		if (qp == NULL) {
 			rcu_read_unlock();
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 4d5d2e7..258fe4c 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -54,6 +54,8 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/seq_file.h>
+#include <rdma/rdma_vt.h>
+#include <rdma/rdmavt_qp.h>
 
 #include "hfi.h"
 #include "qp.h"
@@ -115,230 +117,6 @@ static const u16 credit_table[31] = {
 	32768                   /* 1E */
 };
 
-static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
-{
-	struct rvt_qpn_map *map;
-
-	map = qpt->map + qpn / RVT_BITS_PER_PAGE;
-	if (map->page)
-		clear_bit(qpn & RVT_BITS_PER_PAGE_MASK, map->page);
-}
-
-/*
- * Put the QP into the hash table.
- * The hash table holds a reference to the QP.
- */
-static void insert_qp(struct hfi1_ibdev *dev, struct rvt_qp *qp)
-{
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	unsigned long flags;
-
-	atomic_inc(&qp->refcount);
-	spin_lock_irqsave(&dev->rdi.qp_dev->qpt_lock, flags);
-
-	if (qp->ibqp.qp_num <= 1) {
-		rcu_assign_pointer(ibp->rvp.qp[qp->ibqp.qp_num], qp);
-	} else {
-		u32 n = qpn_hash(dev->rdi.qp_dev, qp->ibqp.qp_num);
-
-		qp->next = dev->rdi.qp_dev->qp_table[n];
-		rcu_assign_pointer(dev->rdi.qp_dev->qp_table[n], qp);
-		trace_hfi1_qpinsert(qp, n);
-	}
-
-	spin_unlock_irqrestore(&dev->rdi.qp_dev->qpt_lock, flags);
-}
-
-/*
- * Remove the QP from the table so it can't be found asynchronously by
- * the receive interrupt routine.
- */
-static void remove_qp(struct hfi1_ibdev *dev, struct rvt_qp *qp)
-{
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	u32 n = qpn_hash(dev->rdi.qp_dev, qp->ibqp.qp_num);
-	unsigned long flags;
-	int removed = 1;
-
-	spin_lock_irqsave(&dev->rdi.qp_dev->qpt_lock, flags);
-
-	if (rcu_dereference_protected(ibp->rvp.qp[0],
-				      lockdep_is_held(
-				      &dev->rdi.qp_dev->qpt_lock)) == qp) {
-		RCU_INIT_POINTER(ibp->rvp.qp[0], NULL);
-	} else if (rcu_dereference_protected(ibp->rvp.qp[1],
-			lockdep_is_held(&dev->rdi.qp_dev->qpt_lock)) == qp) {
-		RCU_INIT_POINTER(ibp->rvp.qp[1], NULL);
-	} else {
-		struct rvt_qp *q;
-		struct rvt_qp __rcu **qpp;
-
-		removed = 0;
-		qpp = &dev->rdi.qp_dev->qp_table[n];
-		for (; (q = rcu_dereference_protected(*qpp,
-				lockdep_is_held(&dev->rdi.qp_dev->qpt_lock)))
-					!= NULL;
-				qpp = &q->next)
-			if (q == qp) {
-				RCU_INIT_POINTER(*qpp,
-				 rcu_dereference_protected(qp->next,
-				 lockdep_is_held(&dev->rdi.qp_dev->qpt_lock)));
-				removed = 1;
-				trace_hfi1_qpremove(qp, n);
-				break;
-			}
-	}
-
-	spin_unlock_irqrestore(&dev->rdi.qp_dev->qpt_lock, flags);
-	if (removed) {
-		synchronize_rcu();
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
-	}
-}
-
-static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
-{
-	unsigned n;
-
-	if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
-		hfi1_put_ss(&qp->s_rdma_read_sge);
-
-	hfi1_put_ss(&qp->r_sge);
-
-	if (clr_sends) {
-		while (qp->s_last != qp->s_head) {
-			struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_last);
-			unsigned i;
-
-			for (i = 0; i < wqe->wr.num_sge; i++) {
-				struct rvt_sge *sge = &wqe->sg_list[i];
-
-				rvt_put_mr(sge->mr);
-			}
-			if (qp->ibqp.qp_type == IB_QPT_UD ||
-			    qp->ibqp.qp_type == IB_QPT_SMI ||
-			    qp->ibqp.qp_type == IB_QPT_GSI)
-				atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
-			if (++qp->s_last >= qp->s_size)
-				qp->s_last = 0;
-		}
-		if (qp->s_rdma_mr) {
-			rvt_put_mr(qp->s_rdma_mr);
-			qp->s_rdma_mr = NULL;
-		}
-	}
-
-	if (qp->ibqp.qp_type != IB_QPT_RC)
-		return;
-
-	for (n = 0; n < ARRAY_SIZE(qp->s_ack_queue); n++) {
-		struct rvt_ack_entry *e = &qp->s_ack_queue[n];
-
-		if (e->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST &&
-		    e->rdma_sge.mr) {
-			rvt_put_mr(e->rdma_sge.mr);
-			e->rdma_sge.mr = NULL;
-		}
-	}
-}
-
-/**
- * hfi1_error_qp - put a QP into the error state
- * @qp: the QP to put into the error state
- * @err: the receive completion error to signal if a RWQE is active
- *
- * Flushes both send and receive work queues.
- * Returns true if last WQE event should be generated.
- * The QP r_lock and s_lock should be held and interrupts disabled.
- * If we are already in error state, just return.
- */
-int hfi1_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
-{
-	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
-	struct hfi1_qp_priv *priv = qp->priv;
-	struct ib_wc wc;
-	int ret = 0;
-
-	if (qp->state == IB_QPS_ERR || qp->state == IB_QPS_RESET)
-		goto bail;
-
-	qp->state = IB_QPS_ERR;
-
-	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
-		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
-		del_timer(&qp->s_timer);
-	}
-
-	if (qp->s_flags & RVT_S_ANY_WAIT_SEND)
-		qp->s_flags &= ~RVT_S_ANY_WAIT_SEND;
-
-	write_seqlock(&dev->iowait_lock);
-	if (!list_empty(&priv->s_iowait.list) && !(qp->s_flags & RVT_S_BUSY)) {
-		qp->s_flags &= ~RVT_S_ANY_WAIT_IO;
-		list_del_init(&priv->s_iowait.list);
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
-	}
-	write_sequnlock(&dev->iowait_lock);
-
-	if (!(qp->s_flags & RVT_S_BUSY)) {
-		qp->s_hdrwords = 0;
-		if (qp->s_rdma_mr) {
-			rvt_put_mr(qp->s_rdma_mr);
-			qp->s_rdma_mr = NULL;
-		}
-		flush_tx_list(qp);
-	}
-
-	/* Schedule the sending tasklet to drain the send work queue. */
-	if (qp->s_last != qp->s_head)
-		hfi1_schedule_send(qp);
-
-	clear_mr_refs(qp, 0);
-
-	memset(&wc, 0, sizeof(wc));
-	wc.qp = &qp->ibqp;
-	wc.opcode = IB_WC_RECV;
-
-	if (test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags)) {
-		wc.wr_id = qp->r_wr_id;
-		wc.status = err;
-		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
-	}
-	wc.status = IB_WC_WR_FLUSH_ERR;
-
-	if (qp->r_rq.wq) {
-		struct rvt_rwq *wq;
-		u32 head;
-		u32 tail;
-
-		spin_lock(&qp->r_rq.lock);
-
-		/* sanity check pointers before trusting them */
-		wq = qp->r_rq.wq;
-		head = wq->head;
-		if (head >= qp->r_rq.size)
-			head = 0;
-		tail = wq->tail;
-		if (tail >= qp->r_rq.size)
-			tail = 0;
-		while (tail != head) {
-			wc.wr_id = get_rwqe_ptr(&qp->r_rq, tail)->wr_id;
-			if (++tail >= qp->r_rq.size)
-				tail = 0;
-			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
-		}
-		wq->tail = tail;
-
-		spin_unlock(&qp->r_rq.lock);
-	} else if (qp->ibqp.event_handler)
-		ret = 1;
-
-bail:
-	return ret;
-}
-
 static void flush_tx_list(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
@@ -397,314 +175,49 @@ static inline int verbs_mtu_enum_to_int(struct ib_device *dev, enum ib_mtu mtu)
 	return ib_mtu_enum_to_int(mtu);
 }
 
-
-/**
- * hfi1_modify_qp - modify the attributes of a queue pair
- * @ibqp: the queue pair who's attributes we're modifying
- * @attr: the new attributes
- * @attr_mask: the mask of attributes to modify
- * @udata: user data for libibverbs.so
- *
- * Returns 0 on success, otherwise returns an errno.
- */
-int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		   int attr_mask, struct ib_udata *udata)
+int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
+			 int attr_mask, struct ib_udata *udata)
 {
+	struct ib_qp *ibqp = &qp->ibqp;
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
-	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
-	struct hfi1_qp_priv *priv = qp->priv;
-	enum ib_qp_state cur_state, new_state;
-	struct ib_event ev;
-	int lastwqe = 0;
-	int mig = 0;
-	int ret;
-	u32 pmtu = 0; /* for gcc warning only */
 	struct hfi1_devdata *dd = dd_from_dev(dev);
-
-	spin_lock_irq(&qp->r_lock);
-	spin_lock(&qp->s_lock);
-
-	cur_state = attr_mask & IB_QP_CUR_STATE ?
-		attr->cur_qp_state : qp->state;
-	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
-
-	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type,
-				attr_mask, IB_LINK_LAYER_UNSPECIFIED))
-		goto inval;
+	u8 sc;
 
 	if (attr_mask & IB_QP_AV) {
-		u8 sc;
-
-		if (attr->ah_attr.dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
-			goto inval;
-		if (rvt_check_ah(qp->ibqp.device, &attr->ah_attr))
-			goto inval;
 		sc = ah_to_sc(ibqp->device, &attr->ah_attr);
 		if (!qp_to_sdma_engine(qp, sc) &&
 		    dd->flags & HFI1_HAS_SEND_DMA)
-			goto inval;
+			return -EINVAL;
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
-		u8 sc;
-
-		if (attr->alt_ah_attr.dlid >=
-		    be16_to_cpu(IB_MULTICAST_LID_BASE))
-			goto inval;
-		if (rvt_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
-			goto inval;
-		if (attr->alt_pkey_index >= hfi1_get_npkeys(dd))
-			goto inval;
 		sc = ah_to_sc(ibqp->device, &attr->alt_ah_attr);
 		if (!qp_to_sdma_engine(qp, sc) &&
 		    dd->flags & HFI1_HAS_SEND_DMA)
-			goto inval;
-	}
-
-	if (attr_mask & IB_QP_PKEY_INDEX)
-		if (attr->pkey_index >= hfi1_get_npkeys(dd))
-			goto inval;
-
-	if (attr_mask & IB_QP_MIN_RNR_TIMER)
-		if (attr->min_rnr_timer > 31)
-			goto inval;
-
-	if (attr_mask & IB_QP_PORT)
-		if (qp->ibqp.qp_type == IB_QPT_SMI ||
-		    qp->ibqp.qp_type == IB_QPT_GSI ||
-		    attr->port_num == 0 ||
-		    attr->port_num > ibqp->device->phys_port_cnt)
-			goto inval;
-
-	if (attr_mask & IB_QP_DEST_QPN)
-		if (attr->dest_qp_num > HFI1_QPN_MASK)
-			goto inval;
-
-	if (attr_mask & IB_QP_RETRY_CNT)
-		if (attr->retry_cnt > 7)
-			goto inval;
-
-	if (attr_mask & IB_QP_RNR_RETRY)
-		if (attr->rnr_retry > 7)
-			goto inval;
-
-	/*
-	 * Don't allow invalid path_mtu values.  OK to set greater
-	 * than the active mtu (or even the max_cap, if we have tuned
-	 * that to a small mtu.  We'll set qp->path_mtu
-	 * to the lesser of requested attribute mtu and active,
-	 * for packetizing messages.
-	 * Note that the QP port has to be set in INIT and MTU in RTR.
-	 */
-	if (attr_mask & IB_QP_PATH_MTU) {
-		int mtu, pidx = qp->port_num - 1;
-
-		dd = dd_from_dev(dev);
-		mtu = verbs_mtu_enum_to_int(ibqp->device, attr->path_mtu);
-		if (mtu == -1)
-			goto inval;
-
-		if (mtu > dd->pport[pidx].ibmtu)
-			pmtu = mtu_to_enum(dd->pport[pidx].ibmtu, IB_MTU_2048);
-		else
-			pmtu = attr->path_mtu;
+			return -EINVAL;
 	}
 
-	if (attr_mask & IB_QP_PATH_MIG_STATE) {
-		if (attr->path_mig_state == IB_MIG_REARM) {
-			if (qp->s_mig_state == IB_MIG_ARMED)
-				goto inval;
-			if (new_state != IB_QPS_RTS)
-				goto inval;
-		} else if (attr->path_mig_state == IB_MIG_MIGRATED) {
-			if (qp->s_mig_state == IB_MIG_REARM)
-				goto inval;
-			if (new_state != IB_QPS_RTS && new_state != IB_QPS_SQD)
-				goto inval;
-			if (qp->s_mig_state == IB_MIG_ARMED)
-				mig = 1;
-		} else
-			goto inval;
-	}
-
-	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
-		if (attr->max_dest_rd_atomic > HFI1_MAX_RDMA_ATOMIC)
-			goto inval;
-
-	switch (new_state) {
-	case IB_QPS_RESET:
-		if (qp->state != IB_QPS_RESET) {
-			qp->state = IB_QPS_RESET;
-			flush_iowait(qp);
-			qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
-			spin_unlock(&qp->s_lock);
-			spin_unlock_irq(&qp->r_lock);
-			/* Stop the sending work queue and retry timer */
-			cancel_work_sync(&priv->s_iowait.iowork);
-			del_timer_sync(&qp->s_timer);
-			iowait_sdma_drain(&priv->s_iowait);
-			flush_tx_list(qp);
-			remove_qp(dev, qp);
-			wait_event(qp->wait, !atomic_read(&qp->refcount));
-			spin_lock_irq(&qp->r_lock);
-			spin_lock(&qp->s_lock);
-			clear_mr_refs(qp, 1);
-			clear_ahg(qp);
-			rvt_reset_qp(&dev->rdi, qp, ibqp->qp_type);
-		}
-		break;
-
-	case IB_QPS_RTR:
-		/* Allow event to re-trigger if QP set to RTR more than once */
-		qp->r_flags &= ~RVT_R_COMM_EST;
-		qp->state = new_state;
-		break;
-
-	case IB_QPS_SQD:
-		qp->s_draining = qp->s_last != qp->s_cur;
-		qp->state = new_state;
-		break;
-
-	case IB_QPS_SQE:
-		if (qp->ibqp.qp_type == IB_QPT_RC)
-			goto inval;
-		qp->state = new_state;
-		break;
-
-	case IB_QPS_ERR:
-		lastwqe = hfi1_error_qp(qp, IB_WC_WR_FLUSH_ERR);
-		break;
-
-	default:
-		qp->state = new_state;
-		break;
-	}
-
-	if (attr_mask & IB_QP_PKEY_INDEX)
-		qp->s_pkey_index = attr->pkey_index;
-
-	if (attr_mask & IB_QP_PORT)
-		qp->port_num = attr->port_num;
-
-	if (attr_mask & IB_QP_DEST_QPN)
-		qp->remote_qpn = attr->dest_qp_num;
-
-	if (attr_mask & IB_QP_SQ_PSN) {
-		qp->s_next_psn = attr->sq_psn & PSN_MODIFY_MASK;
-		qp->s_psn = qp->s_next_psn;
-		qp->s_sending_psn = qp->s_next_psn;
-		qp->s_last_psn = qp->s_next_psn - 1;
-		qp->s_sending_hpsn = qp->s_last_psn;
-	}
-
-	if (attr_mask & IB_QP_RQ_PSN)
-		qp->r_psn = attr->rq_psn & PSN_MODIFY_MASK;
+	return 0;
+}
 
-	if (attr_mask & IB_QP_ACCESS_FLAGS)
-		qp->qp_access_flags = attr->qp_access_flags;
+void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
+		    int attr_mask, struct ib_udata *udata)
+{
+	struct ib_qp *ibqp = &qp->ibqp;
+	struct hfi1_qp_priv *priv = qp->priv;
 
 	if (attr_mask & IB_QP_AV) {
-		qp->remote_ah_attr = attr->ah_attr;
-		qp->s_srate = attr->ah_attr.static_rate;
-		qp->srate_mbps = ib_rate_to_mbps(qp->s_srate);
 		priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
 		priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
 	}
 
-	if (attr_mask & IB_QP_ALT_PATH) {
-		qp->alt_ah_attr = attr->alt_ah_attr;
-		qp->s_alt_pkey_index = attr->alt_pkey_index;
-	}
-
-	if (attr_mask & IB_QP_PATH_MIG_STATE) {
-		qp->s_mig_state = attr->path_mig_state;
-		if (mig) {
-			qp->remote_ah_attr = qp->alt_ah_attr;
-			qp->port_num = qp->alt_ah_attr.port_num;
-			qp->s_pkey_index = qp->s_alt_pkey_index;
-			qp->s_flags |= RVT_S_AHG_CLEAR;
-			priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
-			priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
-		}
-	}
-
-	if (attr_mask & IB_QP_PATH_MTU) {
-		struct hfi1_ibport *ibp;
-		u8 sc, vl;
-		u32 mtu;
-
-		dd = dd_from_dev(dev);
-		ibp = &dd->pport[qp->port_num - 1].ibport_data;
-
-		sc = ibp->sl_to_sc[qp->remote_ah_attr.sl];
-		vl = sc_to_vlt(dd, sc);
-
-		mtu = verbs_mtu_enum_to_int(ibqp->device, pmtu);
-		if (vl < PER_VL_SEND_CONTEXTS)
-			mtu = min_t(u32, mtu, dd->vld[vl].mtu);
-		pmtu = mtu_to_enum(mtu, OPA_MTU_8192);
-
-		qp->path_mtu = pmtu;
-		qp->pmtu = mtu;
-	}
-
-	if (attr_mask & IB_QP_RETRY_CNT) {
-		qp->s_retry_cnt = attr->retry_cnt;
-		qp->s_retry = attr->retry_cnt;
-	}
-
-	if (attr_mask & IB_QP_RNR_RETRY) {
-		qp->s_rnr_retry_cnt = attr->rnr_retry;
-		qp->s_rnr_retry = attr->rnr_retry;
-	}
-
-	if (attr_mask & IB_QP_MIN_RNR_TIMER)
-		qp->r_min_rnr_timer = attr->min_rnr_timer;
-
-	if (attr_mask & IB_QP_TIMEOUT) {
-		qp->timeout = attr->timeout;
-		qp->timeout_jiffies =
-			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
-				1000UL);
-	}
-
-	if (attr_mask & IB_QP_QKEY)
-		qp->qkey = attr->qkey;
-
-	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
-		qp->r_max_rd_atomic = attr->max_dest_rd_atomic;
-
-	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC)
-		qp->s_max_rd_atomic = attr->max_rd_atomic;
-
-	spin_unlock(&qp->s_lock);
-	spin_unlock_irq(&qp->r_lock);
-
-	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
-		insert_qp(dev, qp);
-
-	if (lastwqe) {
-		ev.device = qp->ibqp.device;
-		ev.element.qp = &qp->ibqp;
-		ev.event = IB_EVENT_QP_LAST_WQE_REACHED;
-		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
-	}
-	if (mig) {
-		ev.device = qp->ibqp.device;
-		ev.element.qp = &qp->ibqp;
-		ev.event = IB_EVENT_PATH_MIG;
-		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
+	if (attr_mask & IB_QP_PATH_MIG_STATE &&
+	    attr->path_mig_state == IB_MIG_MIGRATED &&
+	    qp->s_mig_state == IB_MIG_ARMED) {
+		qp->s_flags |= RVT_S_AHG_CLEAR;
+		priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
+		priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
 	}
-	ret = 0;
-	goto bail;
-
-inval:
-	spin_unlock(&qp->s_lock);
-	spin_unlock_irq(&qp->r_lock);
-	ret = -EINVAL;
-
-bail:
-	return ret;
 }
 
 int hfi1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
@@ -846,21 +359,19 @@ int hfi1_destroy_qp(struct ib_qp *ibqp)
 		del_timer_sync(&qp->s_timer);
 		iowait_sdma_drain(&priv->s_iowait);
 		flush_tx_list(qp);
-		remove_qp(dev, qp);
+		rvt_remove_qp(ib_to_rvt(ibqp->device), qp);
 		wait_event(qp->wait, !atomic_read(&qp->refcount));
 		spin_lock_irq(&qp->r_lock);
 		spin_lock(&qp->s_lock);
-		clear_mr_refs(qp, 1);
+		rvt_clear_mr_refs(qp, 1);
 		clear_ahg(qp);
 	}
 	spin_unlock(&qp->s_lock);
 	spin_unlock_irq(&qp->r_lock);
 
 	/* all user's cleaned up, mark it available */
-	free_qpn(&dev->rdi.qp_dev->qpn_table, qp->ibqp.qp_num);
-	spin_lock(&dev->n_qps_lock);
-	dev->n_qps_allocated--;
-	spin_unlock(&dev->n_qps_lock);
+	rvt_free_qpn(&dev->rdi.qp_dev->qpn_table, qp->ibqp.qp_num);
+	rvt_dec_qp_cnt(&dev->rdi);
 
 	if (qp->ip)
 		kref_put(&qp->ip->ref, rvt_release_mmap_info);
@@ -1215,6 +726,26 @@ unsigned free_all_qps(struct rvt_dev_info *rdi)
 	return qp_inuse;
 }
 
+void flush_qp_waiters(struct rvt_qp *qp)
+{
+	flush_iowait(qp);
+}
+
+void stop_send_queue(struct rvt_qp *qp)
+{
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	cancel_work_sync(&priv->s_iowait.iowork);
+}
+
+void quiesce_qp(struct rvt_qp *qp)
+{
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	iowait_sdma_drain(&priv->s_iowait);
+	flush_tx_list(qp);
+}
+
 void notify_qp_reset(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
@@ -1251,3 +782,75 @@ void hfi1_migrate_qp(struct rvt_qp *qp)
 	ev.event = IB_EVENT_PATH_MIG;
 	qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
 }
+
+int mtu_to_path_mtu(u32 mtu)
+{
+	return mtu_to_enum(mtu, OPA_MTU_8192);
+}
+
+u32 mtu_from_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp, u32 pmtu)
+{
+	u32 mtu;
+	struct hfi1_ibdev *verbs_dev = container_of(rdi,
+						    struct hfi1_ibdev,
+						    rdi);
+	struct hfi1_devdata *dd = container_of(verbs_dev,
+					       struct hfi1_devdata,
+					       verbs_dev);
+	struct hfi1_ibport *ibp;
+	u8 sc, vl;
+
+	ibp = &dd->pport[qp->port_num - 1].ibport_data;
+	sc = ibp->sl_to_sc[qp->remote_ah_attr.sl];
+	vl = sc_to_vlt(dd, sc);
+
+	mtu = verbs_mtu_enum_to_int(qp->ibqp.device, pmtu);
+	if (vl < PER_VL_SEND_CONTEXTS)
+		mtu = min_t(u32, mtu, dd->vld[vl].mtu);
+	return mtu;
+}
+
+int get_pmtu_from_attr(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+		       struct ib_qp_attr *attr)
+{
+	int mtu, pidx = qp->port_num - 1;
+	struct hfi1_ibdev *verbs_dev = container_of(rdi,
+						    struct hfi1_ibdev,
+						    rdi);
+	struct hfi1_devdata *dd = container_of(verbs_dev,
+					       struct hfi1_devdata,
+					       verbs_dev);
+	mtu = verbs_mtu_enum_to_int(qp->ibqp.device, attr->path_mtu);
+	if (mtu == -1)
+		return -1; /* values less than 0 are error */
+
+	if (mtu > dd->pport[pidx].ibmtu)
+		return mtu_to_enum(dd->pport[pidx].ibmtu, IB_MTU_2048);
+	else
+		return attr->path_mtu;
+}
+
+void notify_error_qp(struct rvt_qp *qp)
+{
+	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	write_seqlock(&dev->iowait_lock);
+	if (!list_empty(&priv->s_iowait.list) && !(qp->s_flags & RVT_S_BUSY)) {
+		qp->s_flags &= ~RVT_S_ANY_WAIT_IO;
+		list_del_init(&priv->s_iowait.list);
+		if (atomic_dec_and_test(&qp->refcount))
+			wake_up(&qp->wait);
+	}
+	write_sequnlock(&dev->iowait_lock);
+
+	if (!(qp->s_flags & RVT_S_BUSY)) {
+		qp->s_hdrwords = 0;
+		if (qp->s_rdma_mr) {
+			rvt_put_mr(qp->s_rdma_mr);
+			qp->s_rdma_mr = NULL;
+		}
+		flush_tx_list(qp);
+	}
+}
+
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index fd72802..7151f32 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -57,38 +57,6 @@
 
 extern unsigned int hfi1_qp_table_size;
 
-static inline u32 qpn_hash(struct rvt_qp_ibdev *dev, u32 qpn)
-{
-	return hash_32(qpn, dev->qp_table_bits);
-}
-
-/**
- * hfi1_lookup_qpn - return the QP with the given QPN
- * @ibp: the ibport
- * @qpn: the QP number to look up
- *
- * The caller must hold the rcu_read_lock(), and keep the lock until
- * the returned qp is no longer in use.
- */
-static inline struct rvt_qp *hfi1_lookup_qpn(struct hfi1_ibport *ibp,
-					     u32 qpn) __must_hold(RCU)
-{
-	struct rvt_qp *qp = NULL;
-
-	if (unlikely(qpn <= 1)) {
-		qp = rcu_dereference(ibp->rvp.qp[qpn]);
-	} else {
-		struct hfi1_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
-		u32 n = qpn_hash(dev->rdi.qp_dev, qpn);
-
-		for (qp = rcu_dereference(dev->rdi.qp_dev->qp_table[n]); qp;
-			qp = rcu_dereference(qp->next))
-			if (qp->ibqp.qp_num == qpn)
-				break;
-	}
-	return qp;
-}
-
 /*
  * free_ahg - clear ahg from QP
  */
@@ -103,30 +71,6 @@ static inline void clear_ahg(struct rvt_qp *qp)
 	qp->s_ahgidx = -1;
 }
 
-/**
- * hfi1_error_qp - put a QP into the error state
- * @qp: the QP to put into the error state
- * @err: the receive completion error to signal if a RWQE is active
- *
- * Flushes both send and receive work queues.
- * Returns true if last WQE event should be generated.
- * The QP r_lock and s_lock should be held and interrupts disabled.
- * If we are already in error state, just return.
- */
-int hfi1_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
-
-/**
- * hfi1_modify_qp - modify the attributes of a queue pair
- * @ibqp: the queue pair who's attributes we're modifying
- * @attr: the new attributes
- * @attr_mask: the mask of attributes to modify
- * @udata: user data for libibverbs.so
- *
- * Returns 0 on success, otherwise returns an errno.
- */
-int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		   int attr_mask, struct ib_udata *udata);
-
 int hfi1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		  int attr_mask, struct ib_qp_init_attr *init_attr);
 
@@ -252,5 +196,12 @@ void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp);
 void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp);
 unsigned free_all_qps(struct rvt_dev_info *rdi);
 void notify_qp_reset(struct rvt_qp *qp);
-
+int get_pmtu_from_attr(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+		       struct ib_qp_attr *attr);
+void flush_qp_waiters(struct rvt_qp *qp);
+void notify_error_qp(struct rvt_qp *qp);
+void stop_send_queue(struct rvt_qp *qp);
+void quiesce_qp(struct rvt_qp *qp);
+u32 mtu_from_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp, u32 pmtu);
+int mtu_to_path_mtu(u32 mtu);
 #endif /* _QP_H */
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index a30bf30..50559fd 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -49,6 +49,8 @@
  */
 
 #include <linux/io.h>
+#include <rdma/rdma_vt.h>
+#include <rdma/rdmavt_qp.h>
 
 #include "hfi.h"
 #include "qp.h"
@@ -891,7 +893,7 @@ static void restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 			qp->s_retry = qp->s_retry_cnt;
 		} else if (qp->s_last == qp->s_acked) {
 			hfi1_send_complete(qp, wqe, IB_WC_RETRY_EXC_ERR);
-			hfi1_error_qp(qp, IB_WC_WR_FLUSH_ERR);
+			rvt_error_qp(qp, IB_WC_WR_FLUSH_ERR);
 			return;
 		} else /* need to handle delayed completion */
 			return;
@@ -1355,7 +1357,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 class_b:
 			if (qp->s_last == qp->s_acked) {
 				hfi1_send_complete(qp, wqe, status);
-				hfi1_error_qp(qp, IB_WC_WR_FLUSH_ERR);
+				rvt_error_qp(qp, IB_WC_WR_FLUSH_ERR);
 			}
 			break;
 
@@ -1601,7 +1603,7 @@ ack_len_err:
 ack_err:
 	if (qp->s_last == qp->s_acked) {
 		hfi1_send_complete(qp, wqe, status);
-		hfi1_error_qp(qp, IB_WC_WR_FLUSH_ERR);
+		rvt_error_qp(qp, IB_WC_WR_FLUSH_ERR);
 	}
 ack_done:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -1832,7 +1834,7 @@ void hfi1_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
 	int lastwqe;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
-	lastwqe = hfi1_error_qp(qp, err);
+	lastwqe = rvt_error_qp(qp, err);
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 
 	if (lastwqe) {
@@ -1873,8 +1875,8 @@ static void log_cca_event(struct hfi1_pportdata *ppd, u8 sl, u32 rlid,
 	cc_event = &ppd->cc_events[ppd->cc_log_idx++];
 	if (ppd->cc_log_idx == OPA_CONG_LOG_ELEMS)
 		ppd->cc_log_idx = 0;
-	cc_event->lqpn = lqpn & HFI1_QPN_MASK;
-	cc_event->rqpn = rqpn & HFI1_QPN_MASK;
+	cc_event->lqpn = lqpn & RVT_QPN_MASK;
+	cc_event->rqpn = rqpn & RVT_QPN_MASK;
 	cc_event->sl = sl;
 	cc_event->svc_type = svc_type;
 	cc_event->rlid = rlid;
@@ -2063,7 +2065,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	/* OK, process the packet. */
 	switch (opcode) {
 	case OP(SEND_FIRST):
-		ret = hfi1_get_rwqe(qp, 0);
+		ret = hfi1_rvt_get_rwqe(qp, 0);
 		if (ret < 0)
 			goto nack_op_err;
 		if (!ret)
@@ -2084,7 +2086,7 @@ send_middle:
 
 	case OP(RDMA_WRITE_LAST_WITH_IMMEDIATE):
 		/* consume RWQE */
-		ret = hfi1_get_rwqe(qp, 1);
+		ret = hfi1_rvt_get_rwqe(qp, 1);
 		if (ret < 0)
 			goto nack_op_err;
 		if (!ret)
@@ -2093,7 +2095,7 @@ send_middle:
 
 	case OP(SEND_ONLY):
 	case OP(SEND_ONLY_WITH_IMMEDIATE):
-		ret = hfi1_get_rwqe(qp, 0);
+		ret = hfi1_rvt_get_rwqe(qp, 0);
 		if (ret < 0)
 			goto nack_op_err;
 		if (!ret)
@@ -2125,7 +2127,7 @@ send_last:
 		if (unlikely(wc.byte_len > qp->r_len))
 			goto nack_inv;
 		hfi1_copy_sge(&qp->r_sge, data, tlen, 1);
-		hfi1_put_ss(&qp->r_sge);
+		rvt_put_ss(&qp->r_sge);
 		qp->r_msn++;
 		if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 			break;
@@ -2193,7 +2195,7 @@ send_last:
 			goto send_middle;
 		else if (opcode == OP(RDMA_WRITE_ONLY))
 			goto no_immediate_data;
-		ret = hfi1_get_rwqe(qp, 1);
+		ret = hfi1_rvt_get_rwqe(qp, 1);
 		if (ret < 0)
 			goto nack_op_err;
 		if (!ret)
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index b47e462..6379df5 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -145,7 +145,7 @@ bail:
 }
 
 /**
- * hfi1_get_rwqe - copy the next RWQE into the QP's RWQE
+ * hfi1_rvt_get_rwqe - copy the next RWQE into the QP's RWQE
  * @qp: the QP
  * @wr_id_only: update qp->r_wr_id only, not qp->r_sge
  *
@@ -154,7 +154,7 @@ bail:
  *
  * Can be called from interrupt level.
  */
-int hfi1_get_rwqe(struct rvt_qp *qp, int wr_id_only)
+int hfi1_rvt_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 {
 	unsigned long flags;
 	struct rvt_rq *rq;
@@ -192,7 +192,7 @@ int hfi1_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 	}
 	/* Make sure entry is read after head index is read. */
 	smp_rmb();
-	wqe = get_rwqe_ptr(rq, tail);
+	wqe = rvt_get_rwqe_ptr(rq, tail);
 	/*
 	 * Even though we update the tail index in memory, the verbs
 	 * consumer is not supposed to post more entries until a
@@ -377,7 +377,8 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	 * Note that we check the responder QP state after
 	 * checking the requester's state.
 	 */
-	qp = hfi1_lookup_qpn(ibp, sqp->remote_qpn);
+	qp = rvt_lookup_qpn(ib_to_rvt(sqp->ibqp.device), &ibp->rvp,
+			    sqp->remote_qpn);
 
 	spin_lock_irqsave(&sqp->s_lock, flags);
 
@@ -441,7 +442,7 @@ again:
 		wc.ex.imm_data = wqe->wr.ex.imm_data;
 		/* FALLTHROUGH */
 	case IB_WR_SEND:
-		ret = hfi1_get_rwqe(qp, 0);
+		ret = hfi1_rvt_get_rwqe(qp, 0);
 		if (ret < 0)
 			goto op_err;
 		if (!ret)
@@ -453,7 +454,7 @@ again:
 			goto inv_err;
 		wc.wc_flags = IB_WC_WITH_IMM;
 		wc.ex.imm_data = wqe->wr.ex.imm_data;
-		ret = hfi1_get_rwqe(qp, 1);
+		ret = hfi1_rvt_get_rwqe(qp, 1);
 		if (ret < 0)
 			goto op_err;
 		if (!ret)
@@ -548,7 +549,7 @@ again:
 		sqp->s_len -= len;
 	}
 	if (release)
-		hfi1_put_ss(&qp->r_sge);
+		rvt_put_ss(&qp->r_sge);
 
 	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		goto send_comp;
@@ -623,7 +624,7 @@ serr:
 	spin_lock_irqsave(&sqp->s_lock, flags);
 	hfi1_send_complete(sqp, wqe, send_status);
 	if (sqp->ibqp.qp_type == IB_QPT_RC) {
-		int lastwqe = hfi1_error_qp(sqp, IB_WC_WR_FLUSH_ERR);
+		int lastwqe = rvt_error_qp(sqp, IB_WC_WR_FLUSH_ERR);
 
 		sqp->s_flags &= ~RVT_S_BUSY;
 		spin_unlock_irqrestore(&sqp->s_lock, flags);
diff --git a/drivers/staging/rdma/hfi1/srq.c b/drivers/staging/rdma/hfi1/srq.c
index c53b378..f71dff0 100644
--- a/drivers/staging/rdma/hfi1/srq.c
+++ b/drivers/staging/rdma/hfi1/srq.c
@@ -93,7 +93,7 @@ int hfi1_post_srq_receive(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 			goto bail;
 		}
 
-		wqe = get_rwqe_ptr(&srq->rq, wq->head);
+		wqe = rvt_get_rwqe_ptr(&srq->rq, wq->head);
 		wqe->wr_id = wr->wr_id;
 		wqe->num_sge = wr->num_sge;
 		for (i = 0; i < wr->num_sge; i++)
@@ -299,7 +299,7 @@ int hfi1_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			struct rvt_rwqe *wqe;
 			int i;
 
-			wqe = get_rwqe_ptr(&srq->rq, tail);
+			wqe = rvt_get_rwqe_ptr(&srq->rq, tail);
 			p->wr_id = wqe->wr_id;
 			p->num_sge = wqe->num_sge;
 			for (i = 0; i < wqe->num_sge; i++)
diff --git a/drivers/staging/rdma/hfi1/trace.c b/drivers/staging/rdma/hfi1/trace.c
index 10122e8..9eadec5 100644
--- a/drivers/staging/rdma/hfi1/trace.c
+++ b/drivers/staging/rdma/hfi1/trace.c
@@ -166,7 +166,7 @@ const char *parse_everbs_hdrs(
 	case OP(UD, SEND_ONLY_WITH_IMMEDIATE):
 		trace_seq_printf(p, DETH_PRN,
 			be32_to_cpu(eh->ud.deth[0]),
-			be32_to_cpu(eh->ud.deth[1]) & HFI1_QPN_MASK);
+			be32_to_cpu(eh->ud.deth[1]) & RVT_QPN_MASK);
 		break;
 	}
 	trace_seq_putc(p, 0);
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index 14601d7..fcae96e 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -364,37 +364,6 @@ DEFINE_EVENT(hfi1_qpsleepwakeup_template, hfi1_qpsleep,
 	     TP_ARGS(qp, flags));
 
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM hfi1_qphash
-DECLARE_EVENT_CLASS(hfi1_qphash_template,
-	TP_PROTO(struct rvt_qp *qp, u32 bucket),
-	TP_ARGS(qp, bucket),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
-		__field(u32, qpn)
-		__field(u32, bucket)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
-		__entry->qpn = qp->ibqp.qp_num;
-		__entry->bucket = bucket;
-	),
-	TP_printk(
-		"[%s] qpn 0x%x bucket %u",
-		__get_str(dev),
-		__entry->qpn,
-		__entry->bucket
-	)
-);
-
-DEFINE_EVENT(hfi1_qphash_template, hfi1_qpinsert,
-	TP_PROTO(struct rvt_qp *qp, u32 bucket),
-	TP_ARGS(qp, bucket));
-
-DEFINE_EVENT(hfi1_qphash_template, hfi1_qpremove,
-	TP_PROTO(struct rvt_qp *qp, u32 bucket),
-	TP_ARGS(qp, bucket));
-
-#undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_ibhdrs
 
 u8 ibhdr_exhdr_len(struct hfi1_ib_header *hdr);
@@ -538,7 +507,7 @@ DECLARE_EVENT_CLASS(hfi1_ibhdr_template,
 			(be32_to_cpu(ohdr->bth[1]) >> HFI1_BECN_SHIFT)
 			& HFI1_BECN_MASK;
 		__entry->qpn =
-			be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
+			be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
 		__entry->a =
 			(be32_to_cpu(ohdr->bth[2]) >> 31) & 1;
 		/* allow for larger PSN */
@@ -627,7 +596,7 @@ TRACE_EVENT(snoop_capture,
 		DD_DEV_ASSIGN(dd);
 		__entry->slid = be16_to_cpu(hdr->lrh[3]);
 		__entry->dlid = be16_to_cpu(hdr->lrh[1]);
-		__entry->qpn = be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
+		__entry->qpn = be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
 		__entry->opcode = (be32_to_cpu(ohdr->bth[0]) >> 24) & 0xff;
 		__entry->sl = (u8)(be16_to_cpu(hdr->lrh[0]) >> 4) & 0xf;
 		__entry->pkey =	be32_to_cpu(ohdr->bth[0]) & 0xffff;
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index ec404ff..1e50d30 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -292,7 +292,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 			u16 rlid = be16_to_cpu(hdr->lrh[3]);
 			u8 sl, sc5;
 
-			lqpn = bth1 & HFI1_QPN_MASK;
+			lqpn = bth1 & RVT_QPN_MASK;
 			rqpn = qp->remote_qpn;
 
 			sc5 = ibp->sl_to_sc[qp->remote_ah_attr.sl];
@@ -335,7 +335,7 @@ inv:
 			set_bit(RVT_R_REWIND_SGE, &qp->r_aflags);
 			qp->r_sge.num_sge = 0;
 		} else
-			hfi1_put_ss(&qp->r_sge);
+			rvt_put_ss(&qp->r_sge);
 		qp->r_state = OP(SEND_LAST);
 		switch (opcode) {
 		case OP(SEND_FIRST):
@@ -394,7 +394,7 @@ send_first:
 		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
 			qp->r_sge = qp->s_rdma_read_sge;
 		else {
-			ret = hfi1_get_rwqe(qp, 0);
+			ret = hfi1_rvt_get_rwqe(qp, 0);
 			if (ret < 0)
 				goto op_err;
 			if (!ret)
@@ -444,7 +444,7 @@ send_last:
 			goto rewind;
 		wc.opcode = IB_WC_RECV;
 		hfi1_copy_sge(&qp->r_sge, data, tlen, 0);
-		hfi1_put_ss(&qp->s_rdma_read_sge);
+		rvt_put_ss(&qp->s_rdma_read_sge);
 last_imm:
 		wc.wr_id = qp->r_wr_id;
 		wc.status = IB_WC_SUCCESS;
@@ -537,9 +537,9 @@ rdma_last_imm:
 		if (unlikely(tlen + qp->r_rcv_len != qp->r_len))
 			goto drop;
 		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
-			hfi1_put_ss(&qp->s_rdma_read_sge);
+			rvt_put_ss(&qp->s_rdma_read_sge);
 		else {
-			ret = hfi1_get_rwqe(qp, 1);
+			ret = hfi1_rvt_get_rwqe(qp, 1);
 			if (ret < 0)
 				goto op_err;
 			if (!ret)
@@ -548,7 +548,7 @@ rdma_last_imm:
 		wc.byte_len = qp->r_len;
 		wc.opcode = IB_WC_RECV_RDMA_WITH_IMM;
 		hfi1_copy_sge(&qp->r_sge, data, tlen, 1);
-		hfi1_put_ss(&qp->r_sge);
+		rvt_put_ss(&qp->r_sge);
 		goto last_imm;
 
 	case OP(RDMA_WRITE_LAST):
@@ -564,7 +564,7 @@ rdma_last:
 		if (unlikely(tlen + qp->r_rcv_len != qp->r_len))
 			goto drop;
 		hfi1_copy_sge(&qp->r_sge, data, tlen, 1);
-		hfi1_put_ss(&qp->r_sge);
+		rvt_put_ss(&qp->r_sge);
 		break;
 
 	default:
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index e2cbdc8..2eae167 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -80,7 +80,8 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 
 	rcu_read_lock();
 
-	qp = hfi1_lookup_qpn(ibp, swqe->ud_wr.remote_qpn);
+	qp = rvt_lookup_qpn(ib_to_rvt(sqp->ibqp.device), &ibp->rvp,
+			    swqe->ud_wr.remote_qpn);
 	if (!qp) {
 		ibp->rvp.n_pkt_drops++;
 		rcu_read_unlock();
@@ -166,7 +167,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	else {
 		int ret;
 
-		ret = hfi1_get_rwqe(qp, 0);
+		ret = hfi1_rvt_get_rwqe(qp, 0);
 		if (ret < 0) {
 			hfi1_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 			goto bail_unlock;
@@ -222,7 +223,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 		}
 		length -= len;
 	}
-	hfi1_put_ss(&qp->r_sge);
+	rvt_put_ss(&qp->r_sge);
 	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		goto bail_unlock;
 	wc.wr_id = qp->r_wr_id;
@@ -664,7 +665,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	struct ib_grh *grh = NULL;
 
 	qkey = be32_to_cpu(ohdr->u.ud.deth[0]);
-	src_qp = be32_to_cpu(ohdr->u.ud.deth[1]) & HFI1_QPN_MASK;
+	src_qp = be32_to_cpu(ohdr->u.ud.deth[1]) & RVT_QPN_MASK;
 	dlid = be16_to_cpu(hdr->lrh[1]);
 	is_mcast = (dlid > be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
 			(dlid != be16_to_cpu(IB_LID_PERMISSIVE));
@@ -675,7 +676,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		 * error path.
 		 */
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-		u32 lqpn =  be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
+		u32 lqpn =  be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
 		u8 sl, sc5;
 
 		sc5 = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
@@ -817,7 +818,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	else {
 		int ret;
 
-		ret = hfi1_get_rwqe(qp, 0);
+		ret = hfi1_rvt_get_rwqe(qp, 0);
 		if (ret < 0) {
 			hfi1_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 			return;
@@ -840,7 +841,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	} else
 		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
 	hfi1_copy_sge(&qp->r_sge, data, wc.byte_len - sizeof(struct ib_grh), 1);
-	hfi1_put_ss(&qp->r_sge);
+	rvt_put_ss(&qp->r_sge);
 	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		return;
 	wc.wr_id = qp->r_wr_id;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 2fed284..e51f827 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -368,7 +368,7 @@ static int post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			goto bail;
 		}
 
-		wqe = get_rwqe_ptr(&qp->r_rq, wq->head);
+		wqe = rvt_get_rwqe_ptr(&qp->r_rq, wq->head);
 		wqe->wr_id = wr->wr_id;
 		wqe->num_sge = wr->num_sge;
 		for (i = 0; i < wr->num_sge; i++)
@@ -418,6 +418,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 	u32 tlen = packet->tlen;
 	struct hfi1_pportdata *ppd = rcd->ppd;
 	struct hfi1_ibport *ibp = &ppd->ibport_data;
+	struct rvt_dev_info *rdi = &ppd->dd->verbs_dev.rdi;
 	unsigned long flags;
 	u32 qp_num;
 	int lnh;
@@ -447,7 +448,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 	inc_opstats(tlen, &rcd->opstats->stats[opcode]);
 
 	/* Get the destination QP number. */
-	qp_num = be32_to_cpu(packet->ohdr->bth[1]) & HFI1_QPN_MASK;
+	qp_num = be32_to_cpu(packet->ohdr->bth[1]) & RVT_QPN_MASK;
 	lid = be16_to_cpu(hdr->lrh[1]);
 	if (unlikely((lid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
 		     (lid != be16_to_cpu(IB_LID_PERMISSIVE)))) {
@@ -474,7 +475,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 			wake_up(&mcast->wait);
 	} else {
 		rcu_read_lock();
-		packet->qp = hfi1_lookup_qpn(ibp, qp_num);
+		packet->qp = rvt_lookup_qpn(rdi, &ibp->rvp, qp_num);
 		if (!packet->qp) {
 			rcu_read_unlock();
 			goto drop;
@@ -1534,7 +1535,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 
 	/* Only need to initialize non-zero fields. */
 
-	spin_lock_init(&dev->n_qps_lock);
 	spin_lock_init(&dev->n_srqs_lock);
 	init_timer(&dev->mem_timer);
 	dev->mem_timer.function = mem_timer;
@@ -1623,7 +1623,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->query_srq = hfi1_query_srq;
 	ibdev->destroy_srq = hfi1_destroy_srq;
 	ibdev->create_qp = NULL;
-	ibdev->modify_qp = hfi1_modify_qp;
+	ibdev->modify_qp = NULL;
 	ibdev->query_qp = hfi1_query_qp;
 	ibdev->destroy_qp = hfi1_destroy_qp;
 	ibdev->post_send = NULL;
@@ -1674,12 +1674,26 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.dparms.qpn_res_start = kdeth_qp << 16;
 	dd->verbs_dev.rdi.dparms.qpn_res_end =
 	dd->verbs_dev.rdi.dparms.qpn_res_start + 65535;
+	dd->verbs_dev.rdi.dparms.max_rdma_atomic = HFI1_MAX_RDMA_ATOMIC;
+	dd->verbs_dev.rdi.dparms.psn_mask = PSN_MASK;
+	dd->verbs_dev.rdi.dparms.psn_shift = PSN_SHIFT;
+	dd->verbs_dev.rdi.dparms.psn_modify_mask = PSN_MODIFY_MASK;
 	dd->verbs_dev.rdi.driver_f.qp_priv_alloc = qp_priv_alloc;
 	dd->verbs_dev.rdi.driver_f.qp_priv_free = qp_priv_free;
 	dd->verbs_dev.rdi.driver_f.free_all_qps = free_all_qps;
 	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
 	dd->verbs_dev.rdi.driver_f.do_send = hfi1_do_send;
 	dd->verbs_dev.rdi.driver_f.schedule_send = hfi1_schedule_send;
+	dd->verbs_dev.rdi.driver_f.get_pmtu_from_attr = get_pmtu_from_attr;
+	dd->verbs_dev.rdi.driver_f.notify_error_qp = notify_error_qp;
+	dd->verbs_dev.rdi.driver_f.flush_qp_waiters = flush_qp_waiters;
+	dd->verbs_dev.rdi.driver_f.stop_send_queue = stop_send_queue;
+	dd->verbs_dev.rdi.driver_f.quiesce_qp = quiesce_qp;
+	dd->verbs_dev.rdi.driver_f.notify_error_qp = notify_error_qp;
+	dd->verbs_dev.rdi.driver_f.mtu_from_qp = mtu_from_qp;
+	dd->verbs_dev.rdi.driver_f.mtu_to_path_mtu = mtu_to_path_mtu;
+	dd->verbs_dev.rdi.driver_f.check_modify_qp = hfi1_check_modify_qp;
+	dd->verbs_dev.rdi.driver_f.modify_qp = hfi1_modify_qp;
 
 	/* completeion queue */
 	snprintf(dd->verbs_dev.rdi.dparms.cq_name,
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 8e82cf0..f2c8a21 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -225,18 +225,6 @@ struct hfi1_pkt_state {
 
 #define HFI1_PSN_CREDIT  16
 
-/*
- * Since struct rvt_rwqe is not a fixed size, we can't simply index into
- * struct rvt_rwq.wq.  This function does the array index computation.
- */
-static inline struct rvt_rwqe *get_rwqe_ptr(struct rvt_rq *rq, unsigned n)
-{
-	return (struct rvt_rwqe *)
-		((char *) rq->wq->wq +
-		 (sizeof(struct rvt_rwqe) +
-		  rq->max_sge * sizeof(struct ib_sge)) * n);
-}
-
 struct hfi1_opcode_stats {
 	u64 n_packets;          /* number of packets */
 	u64 n_bytes;            /* total number of bytes */
@@ -286,8 +274,6 @@ struct hfi1_ibdev {
 	u64 n_kmem_wait;
 	u64 n_send_schedule;
 
-	u32 n_qps_allocated;    /* number of QPs allocated for device */
-	spinlock_t n_qps_lock;
 	u32 n_srqs_allocated;   /* number of SRQs allocated for device */
 	spinlock_t n_srqs_lock;
 #ifdef CONFIG_DEBUG_FS
@@ -464,19 +450,16 @@ int hfi1_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr);
 
 int hfi1_destroy_srq(struct ib_srq *ibsrq);
 
-static inline void hfi1_put_ss(struct rvt_sge_state *ss)
-{
-	while (ss->num_sge) {
-		rvt_put_mr(ss->sge.mr);
-		if (--ss->num_sge)
-			ss->sge = *ss->sg_list++;
-	}
-}
-
-int hfi1_get_rwqe(struct rvt_qp *qp, int wr_id_only);
+int hfi1_rvt_get_rwqe(struct rvt_qp *qp, int wr_id_only);
 
 void hfi1_migrate_qp(struct rvt_qp *qp);
 
+int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
+			 int attr_mask, struct ib_udata *udata);
+
+void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
+		    int attr_mask, struct ib_udata *udata);
+
 int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 		       int has_grh, struct rvt_qp *qp, u32 bth0);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

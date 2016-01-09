From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] IB/rdmavt: Add modify qp
Date: Sat, 09 Jan 2016 07:00:19 -0800
Message-ID: <20160109150018.8585.67680.stgit@scvm10.sc.intel.com>
References: <20160109145731.8585.48926.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109145731.8585.48926.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add modify qp and supporting functions.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c    |  503 +++++++++++++++++++++++++++++++++-
 drivers/infiniband/sw/rdmavt/trace.h |   31 ++
 include/rdma/rdma_vt.h               |   42 +++
 include/rdma/rdmavt_mr.h             |    9 +
 include/rdma/rdmavt_qp.h             |   20 +
 5 files changed, 596 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 5063e25..b8c7c49 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -45,6 +45,7 @@
  *
  */
 
+#include <linux/hash.h>
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
 #include <linux/vmalloc.h>
@@ -52,6 +53,7 @@
 #include <rdma/ib_verbs.h>
 #include "qp.h"
 #include "vt.h"
+#include "trace.h"
 
 /*
  * Note that it is OK to post send work requests in the SQE and ERR
@@ -377,19 +379,47 @@ static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
  * reset_qp - initialize the QP state to the reset state
  * @qp: the QP to reset
  * @type: the QP type
+ * r and s lock are required to be held by the caller
  */
 void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		  enum ib_qp_type type)
 {
-	qp->remote_qpn = 0;
-	qp->qkey = 0;
-	qp->qp_access_flags = 0;
+	if (qp->state != IB_QPS_RESET) {
+		qp->state = IB_QPS_RESET;
+
+		/* Let drivers flush their waitlist */
+		rdi->driver_f.flush_qp_waiters(qp);
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
+		spin_unlock(&qp->s_lock);
+		spin_unlock_irq(&qp->r_lock);
+
+		/* Stop the send queue and the retry timer */
+		rdi->driver_f.stop_send_queue(qp);
+		del_timer_sync(&qp->s_timer);
+
+		/* Wait for things to stop */
+		rdi->driver_f.quiesce_qp(qp);
+
+		/* take qp out the hash and wait for it to be unused */
+		rvt_remove_qp(rdi, qp);
+		wait_event(qp->wait, !atomic_read(&qp->refcount));
+
+		/* grab the lock b/c it was locked at call time */
+		spin_lock_irq(&qp->r_lock);
+		spin_lock(&qp->s_lock);
+
+		rvt_clear_mr_refs(qp, 1);
+	}
 
 	/*
-	 * Let driver do anything it needs to for a new/reset qp
+	 * Let the driver do any tear down it needs to for a qp
+	 * that has been reset
 	 */
 	rdi->driver_f.notify_qp_reset(qp);
 
+	qp->remote_qpn = 0;
+	qp->qkey = 0;
+	qp->qp_access_flags = 0;
 	qp->s_flags &= RVT_S_SIGNAL_REQ_WR;
 	qp->s_hdrwords = 0;
 	qp->s_wqe = NULL;
@@ -672,6 +702,208 @@ bail_swq:
 	return ret;
 }
 
+void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends)
+{
+	unsigned n;
+
+	if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
+		rvt_put_ss(&qp->s_rdma_read_sge);
+
+	rvt_put_ss(&qp->r_sge);
+
+	if (clr_sends) {
+		while (qp->s_last != qp->s_head) {
+			struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_last);
+			unsigned i;
+
+			for (i = 0; i < wqe->wr.num_sge; i++) {
+				struct rvt_sge *sge = &wqe->sg_list[i];
+
+				rvt_put_mr(sge->mr);
+			}
+			if (qp->ibqp.qp_type == IB_QPT_UD ||
+			    qp->ibqp.qp_type == IB_QPT_SMI ||
+			    qp->ibqp.qp_type == IB_QPT_GSI)
+				atomic_dec(&ibah_to_rvtah(
+						wqe->ud_wr.ah)->refcount);
+			if (++qp->s_last >= qp->s_size)
+				qp->s_last = 0;
+		}
+		if (qp->s_rdma_mr) {
+			rvt_put_mr(qp->s_rdma_mr);
+			qp->s_rdma_mr = NULL;
+		}
+	}
+
+	if (qp->ibqp.qp_type != IB_QPT_RC)
+		return;
+
+	for (n = 0; n < ARRAY_SIZE(qp->s_ack_queue); n++) {
+		struct rvt_ack_entry *e = &qp->s_ack_queue[n];
+
+		if (e->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST &&
+		    e->rdma_sge.mr) {
+			rvt_put_mr(e->rdma_sge.mr);
+			e->rdma_sge.mr = NULL;
+		}
+	}
+}
+EXPORT_SYMBOL(rvt_clear_mr_refs);
+
+/**
+ * rvt_error_qp - put a QP into the error state
+ * @qp: the QP to put into the error state
+ * @err: the receive completion error to signal if a RWQE is active
+ *
+ * Flushes both send and receive work queues.
+ * Returns true if last WQE event should be generated.
+ * The QP r_lock and s_lock should be held and interrupts disabled.
+ * If we are already in error state, just return.
+ */
+int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
+{
+	struct ib_wc wc;
+	int ret = 0;
+	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
+
+	if (qp->state == IB_QPS_ERR || qp->state == IB_QPS_RESET)
+		goto bail;
+
+	qp->state = IB_QPS_ERR;
+
+	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
+		del_timer(&qp->s_timer);
+	}
+
+	if (qp->s_flags & RVT_S_ANY_WAIT_SEND)
+		qp->s_flags &= ~RVT_S_ANY_WAIT_SEND;
+
+	rdi->driver_f.notify_error_qp(qp);
+
+	/* Schedule the sending tasklet to drain the send work queue. */
+	if (qp->s_last != qp->s_head)
+		rdi->driver_f.schedule_send(qp);
+
+	rvt_clear_mr_refs(qp, 0);
+
+	memset(&wc, 0, sizeof(wc));
+	wc.qp = &qp->ibqp;
+	wc.opcode = IB_WC_RECV;
+
+	if (test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags)) {
+		wc.wr_id = qp->r_wr_id;
+		wc.status = err;
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
+	}
+	wc.status = IB_WC_WR_FLUSH_ERR;
+
+	if (qp->r_rq.wq) {
+		struct rvt_rwq *wq;
+		u32 head;
+		u32 tail;
+
+		spin_lock(&qp->r_rq.lock);
+
+		/* sanity check pointers before trusting them */
+		wq = qp->r_rq.wq;
+		head = wq->head;
+		if (head >= qp->r_rq.size)
+			head = 0;
+		tail = wq->tail;
+		if (tail >= qp->r_rq.size)
+			tail = 0;
+		while (tail != head) {
+			wc.wr_id = rvt_get_rwqe_ptr(&qp->r_rq, tail)->wr_id;
+			if (++tail >= qp->r_rq.size)
+				tail = 0;
+			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
+		}
+		wq->tail = tail;
+
+		spin_unlock(&qp->r_rq.lock);
+	} else if (qp->ibqp.event_handler) {
+		ret = 1;
+	}
+
+bail:
+	return ret;
+}
+EXPORT_SYMBOL(rvt_error_qp);
+
+/*
+ * Put the QP into the hash table.
+ * The hash table holds a reference to the QP.
+ */
+static void rvt_insert_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
+{
+	struct rvt_ibport *rvp = rdi->ports[qp->port_num - 1];
+	unsigned long flags;
+
+	atomic_inc(&qp->refcount);
+	spin_lock_irqsave(&rdi->qp_dev->qpt_lock, flags);
+
+	if (qp->ibqp.qp_num <= 1) {
+		rcu_assign_pointer(rvp->qp[qp->ibqp.qp_num], qp);
+	} else {
+		u32 n = hash_32(qp->ibqp.qp_num, rdi->qp_dev->qp_table_bits);
+
+		qp->next = rdi->qp_dev->qp_table[n];
+		rcu_assign_pointer(rdi->qp_dev->qp_table[n], qp);
+		trace_rvt_qpinsert(qp, n);
+	}
+
+	spin_unlock_irqrestore(&rdi->qp_dev->qpt_lock, flags);
+}
+
+/*
+ * Remove the QP from the table so it can't be found asynchronously by
+ * the receive routine.
+ */
+void rvt_remove_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
+{
+	struct rvt_ibport *rvp = rdi->ports[qp->port_num - 1];
+	u32 n = hash_32(qp->ibqp.qp_num, rdi->qp_dev->qp_table_bits);
+	unsigned long flags;
+	int removed = 1;
+
+	spin_lock_irqsave(&rdi->qp_dev->qpt_lock, flags);
+
+	if (rcu_dereference_protected(rvp->qp[0],
+			lockdep_is_held(&rdi->qp_dev->qpt_lock)) == qp) {
+		RCU_INIT_POINTER(rvp->qp[0], NULL);
+	} else if (rcu_dereference_protected(rvp->qp[1],
+			lockdep_is_held(&rdi->qp_dev->qpt_lock)) == qp) {
+		RCU_INIT_POINTER(rvp->qp[1], NULL);
+	} else {
+		struct rvt_qp *q;
+		struct rvt_qp __rcu **qpp;
+
+		removed = 0;
+		qpp = &rdi->qp_dev->qp_table[n];
+		for (; (q = rcu_dereference_protected(*qpp,
+			lockdep_is_held(&rdi->qp_dev->qpt_lock))) != NULL;
+			qpp = &q->next) {
+			if (q == qp) {
+				RCU_INIT_POINTER(*qpp,
+				     rcu_dereference_protected(qp->next,
+				     lockdep_is_held(&rdi->qp_dev->qpt_lock)));
+				removed = 1;
+				trace_rvt_qpremove(qp, n);
+				break;
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&rdi->qp_dev->qpt_lock, flags);
+	if (removed) {
+		synchronize_rcu();
+		if (atomic_dec_and_test(&qp->refcount))
+			wake_up(&qp->wait);
+	}
+}
+EXPORT_SYMBOL(rvt_remove_qp);
+
 /**
  * qib_modify_qp - modify the attributes of a queue pair
  * @ibqp: the queue pair who's attributes we're modifying
@@ -684,13 +916,248 @@ bail_swq:
 int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		  int attr_mask, struct ib_udata *udata)
 {
+	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
+	enum ib_qp_state cur_state, new_state;
+	struct ib_event ev;
+	int lastwqe = 0;
+	int mig = 0;
+	int pmtu = 0; /* for gcc warning only */
+	enum rdma_link_layer link;
+
+	link = rdma_port_get_link_layer(ibqp->device, qp->port_num);
+
+	spin_lock_irq(&qp->r_lock);
+	spin_lock(&qp->s_lock);
+
+	cur_state = attr_mask & IB_QP_CUR_STATE ?
+		attr->cur_qp_state : qp->state;
+	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
+
+	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type,
+				attr_mask, link))
+		goto inval;
+
+	if (attr_mask & IB_QP_AV) {
+		if (attr->ah_attr.dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
+			goto inval;
+		if (rvt_check_ah(qp->ibqp.device, &attr->ah_attr))
+			goto inval;
+	}
+
+	if (attr_mask & IB_QP_ALT_PATH) {
+		if (attr->alt_ah_attr.dlid >=
+		    be16_to_cpu(IB_MULTICAST_LID_BASE))
+			goto inval;
+		if (rvt_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
+			goto inval;
+		if (attr->alt_pkey_index >= rvt_get_npkeys(rdi))
+			goto inval;
+	}
+
+	if (attr_mask & IB_QP_PKEY_INDEX)
+		if (attr->pkey_index >= rvt_get_npkeys(rdi))
+			goto inval;
+
+	if (attr_mask & IB_QP_MIN_RNR_TIMER)
+		if (attr->min_rnr_timer > 31)
+			goto inval;
+
+	if (attr_mask & IB_QP_PORT)
+		if (qp->ibqp.qp_type == IB_QPT_SMI ||
+		    qp->ibqp.qp_type == IB_QPT_GSI ||
+		    attr->port_num == 0 ||
+		    attr->port_num > ibqp->device->phys_port_cnt)
+			goto inval;
+
+	if (attr_mask & IB_QP_DEST_QPN)
+		if (attr->dest_qp_num > RVT_QPN_MASK)
+			goto inval;
+
+	if (attr_mask & IB_QP_RETRY_CNT)
+		if (attr->retry_cnt > 7)
+			goto inval;
+
+	if (attr_mask & IB_QP_RNR_RETRY)
+		if (attr->rnr_retry > 7)
+			goto inval;
+
 	/*
-	 * VT-DRIVER-API: qp_mtu()
-	 * OPA devices have a per VL MTU the driver has a mapping of IB SL to SC
-	 * to VL and the mapping table of MTUs per VL. This is not something
-	 * that IB has and should not live in the rvt.
+	 * Don't allow invalid path_mtu values.  OK to set greater
+	 * than the active mtu (or even the max_cap, if we have tuned
+	 * that to a small mtu.  We'll set qp->path_mtu
+	 * to the lesser of requested attribute mtu and active,
+	 * for packetizing messages.
+	 * Note that the QP port has to be set in INIT and MTU in RTR.
 	 */
-	return -EOPNOTSUPP;
+	if (attr_mask & IB_QP_PATH_MTU) {
+		pmtu = rdi->driver_f.get_pmtu_from_attr(rdi, qp, attr);
+		if (pmtu < 0)
+			goto inval;
+	}
+
+	if (attr_mask & IB_QP_PATH_MIG_STATE) {
+		if (attr->path_mig_state == IB_MIG_REARM) {
+			if (qp->s_mig_state == IB_MIG_ARMED)
+				goto inval;
+			if (new_state != IB_QPS_RTS)
+				goto inval;
+		} else if (attr->path_mig_state == IB_MIG_MIGRATED) {
+			if (qp->s_mig_state == IB_MIG_REARM)
+				goto inval;
+			if (new_state != IB_QPS_RTS && new_state != IB_QPS_SQD)
+				goto inval;
+			if (qp->s_mig_state == IB_MIG_ARMED)
+				mig = 1;
+		} else {
+			goto inval;
+		}
+	}
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
+		if (attr->max_dest_rd_atomic > rdi->dparms.max_rdma_atomic)
+			goto inval;
+
+	switch (new_state) {
+	case IB_QPS_RESET:
+		if (qp->state != IB_QPS_RESET)
+			rvt_reset_qp(rdi, qp, ibqp->qp_type);
+		break;
+
+	case IB_QPS_RTR:
+		/* Allow event to re-trigger if QP set to RTR more than once */
+		qp->r_flags &= ~RVT_R_COMM_EST;
+		qp->state = new_state;
+		break;
+
+	case IB_QPS_SQD:
+		qp->s_draining = qp->s_last != qp->s_cur;
+		qp->state = new_state;
+		break;
+
+	case IB_QPS_SQE:
+		if (qp->ibqp.qp_type == IB_QPT_RC)
+			goto inval;
+		qp->state = new_state;
+		break;
+
+	case IB_QPS_ERR:
+		lastwqe = rvt_error_qp(qp, IB_WC_WR_FLUSH_ERR);
+		break;
+
+	default:
+		qp->state = new_state;
+		break;
+	}
+
+	if (attr_mask & IB_QP_PKEY_INDEX)
+		qp->s_pkey_index = attr->pkey_index;
+
+	if (attr_mask & IB_QP_PORT)
+		qp->port_num = attr->port_num;
+
+	if (attr_mask & IB_QP_DEST_QPN)
+		qp->remote_qpn = attr->dest_qp_num;
+
+	if (attr_mask & IB_QP_SQ_PSN) {
+		qp->s_next_psn = attr->sq_psn & rdi->dparms.psn_modify_mask;
+		qp->s_psn = qp->s_next_psn;
+		qp->s_sending_psn = qp->s_next_psn;
+		qp->s_last_psn = qp->s_next_psn - 1;
+		qp->s_sending_hpsn = qp->s_last_psn;
+	}
+
+	if (attr_mask & IB_QP_RQ_PSN)
+		qp->r_psn = attr->rq_psn & rdi->dparms.psn_modify_mask;
+
+	if (attr_mask & IB_QP_ACCESS_FLAGS)
+		qp->qp_access_flags = attr->qp_access_flags;
+
+	if (attr_mask & IB_QP_AV) {
+		qp->remote_ah_attr = attr->ah_attr;
+		qp->s_srate = attr->ah_attr.static_rate;
+		qp->srate_mbps = ib_rate_to_mbps(qp->s_srate);
+	}
+
+	if (attr_mask & IB_QP_ALT_PATH) {
+		qp->alt_ah_attr = attr->alt_ah_attr;
+		qp->s_alt_pkey_index = attr->alt_pkey_index;
+	}
+
+	if (attr_mask & IB_QP_PATH_MIG_STATE) {
+		qp->s_mig_state = attr->path_mig_state;
+		if (mig) {
+			qp->remote_ah_attr = qp->alt_ah_attr;
+			qp->port_num = qp->alt_ah_attr.port_num;
+			qp->s_pkey_index = qp->s_alt_pkey_index;
+
+			/*
+			 * Ignored by drivers which do not support it. Not
+			 * really worth creating a call back into the driver
+			 * just to set a flag.
+			 */
+			qp->s_flags |= RVT_S_AHG_CLEAR;
+		}
+	}
+
+	if (attr_mask & IB_QP_PATH_MTU) {
+		qp->pmtu = rdi->driver_f.mtu_from_qp(rdi, qp, pmtu);
+		qp->path_mtu = rdi->driver_f.mtu_to_path_mtu(qp->pmtu);
+	}
+
+	if (attr_mask & IB_QP_RETRY_CNT) {
+		qp->s_retry_cnt = attr->retry_cnt;
+		qp->s_retry = attr->retry_cnt;
+	}
+
+	if (attr_mask & IB_QP_RNR_RETRY) {
+		qp->s_rnr_retry_cnt = attr->rnr_retry;
+		qp->s_rnr_retry = attr->rnr_retry;
+	}
+
+	if (attr_mask & IB_QP_MIN_RNR_TIMER)
+		qp->r_min_rnr_timer = attr->min_rnr_timer;
+
+	if (attr_mask & IB_QP_TIMEOUT) {
+		qp->timeout = attr->timeout;
+		qp->timeout_jiffies =
+			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
+				1000UL);
+	}
+
+	if (attr_mask & IB_QP_QKEY)
+		qp->qkey = attr->qkey;
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
+		qp->r_max_rd_atomic = attr->max_dest_rd_atomic;
+
+	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC)
+		qp->s_max_rd_atomic = attr->max_rd_atomic;
+
+	spin_unlock(&qp->s_lock);
+	spin_unlock_irq(&qp->r_lock);
+
+	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+		rvt_insert_qp(rdi, qp);
+
+	if (lastwqe) {
+		ev.device = qp->ibqp.device;
+		ev.element.qp = &qp->ibqp;
+		ev.event = IB_EVENT_QP_LAST_WQE_REACHED;
+		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
+	}
+	if (mig) {
+		ev.device = qp->ibqp.device;
+		ev.element.qp = &qp->ibqp;
+		ev.event = IB_EVENT_PATH_MIG;
+		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
+	}
+	return 0;
+
+inval:
+	spin_unlock(&qp->s_lock);
+	spin_unlock_irq(&qp->r_lock);
+	return -EINVAL;
 }
 
 /**
@@ -918,3 +1385,21 @@ int rvt_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 {
 	return -EOPNOTSUPP;
 }
+
+void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
+{
+	struct rvt_qpn_map *map;
+
+	map = qpt->map + qpn / RVT_BITS_PER_PAGE;
+	if (map->page)
+		clear_bit(qpn & RVT_BITS_PER_PAGE_MASK, map->page);
+}
+EXPORT_SYMBOL(rvt_free_qpn);
+
+void rvt_dec_qp_cnt(struct rvt_dev_info *rdi)
+{
+	spin_lock(&rdi->n_qps_lock);
+	rdi->n_qps_allocated--;
+	spin_unlock(&rdi->n_qps_lock);
+}
+EXPORT_SYMBOL(rvt_dec_qp_cnt);
diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
index 22e86ff..b269291 100644
--- a/drivers/infiniband/sw/rdmavt/trace.h
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -77,6 +77,37 @@ TRACE_EVENT(rvt_dbg,
 	TP_printk("[%s]: %s", __get_str(dev), __get_str(msg))
 );
 
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rvt_qphash
+DECLARE_EVENT_CLASS(rvt_qphash_template,
+	TP_PROTO(struct rvt_qp *qp, u32 bucket),
+	TP_ARGS(qp, bucket),
+	TP_STRUCT__entry(
+		RDI_DEV_ENTRY(ib_to_rvt(qp->ibqp.device))
+		__field(u32, qpn)
+		__field(u32, bucket)
+	),
+	TP_fast_assign(
+		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		__entry->qpn = qp->ibqp.qp_num;
+		__entry->bucket = bucket;
+	),
+	TP_printk(
+		"[%s] qpn 0x%x bucket %u",
+		__get_str(dev),
+		__entry->qpn,
+		__entry->bucket
+	)
+);
+
+DEFINE_EVENT(rvt_qphash_template, rvt_qpinsert,
+	TP_PROTO(struct rvt_qp *qp, u32 bucket),
+	TP_ARGS(qp, bucket));
+
+DEFINE_EVENT(rvt_qphash_template, rvt_qpremove,
+	TP_PROTO(struct rvt_qp *qp, u32 bucket),
+	TP_ARGS(qp, bucket));
+
 #endif /* __RDMAVT_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 3d92239..fac3f9b 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -55,6 +55,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <linux/hash.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdmavt_mr.h>
 #include <rdma/rdmavt_qp.h>
@@ -194,6 +195,10 @@ struct rvt_driver_params {
 	u8 qos_shift;
 	char cq_name[RVT_CQN_MAX];
 	int node;
+	int max_rdma_atomic;
+	int psn_mask;
+	int psn_shift;
+	int psn_modify_mask;
 };
 
 /* Protection domain */
@@ -232,6 +237,15 @@ struct rvt_driver_provided {
 	void (*notify_qp_reset)(struct rvt_qp *qp);
 	void (*schedule_send)(struct rvt_qp *qp);
 	void (*do_send)(struct rvt_qp *qp);
+	int (*get_pmtu_from_attr)(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+				  struct ib_qp_attr *attr);
+	void (*flush_qp_waiters)(struct rvt_qp *qp);
+	void (*stop_send_queue)(struct rvt_qp *qp);
+	void (*quiesce_qp)(struct rvt_qp *qp);
+	void (*notify_error_qp)(struct rvt_qp *qp);
+	u32 (*mtu_from_qp)(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+			   u32 pmtu);
+	int (*mtu_to_path_mtu)(u32 mtu);
 
 	/*--------------------*/
 	/* Optional functions */
@@ -339,6 +353,34 @@ static inline u16 rvt_get_pkey(struct rvt_dev_info *rdi,
 		return rdi->ports[port_index]->pkey_table[index];
 }
 
+/**
+ * rvt_lookup_qpn - return the QP with the given QPN
+ * @ibp: the ibport
+ * @qpn: the QP number to look up
+ *
+ * The caller must hold the rcu_read_lock(), and keep the lock until
+ * the returned qp is no longer in use.
+ */
+/* TODO: Remove this and put in rdmavt/qp.h when no longer needed by drivers */
+static inline struct rvt_qp *rvt_lookup_qpn(struct rvt_dev_info *rdi,
+					    struct rvt_ibport *rvp,
+					    u32 qpn) __must_hold(RCU)
+{
+	struct rvt_qp *qp = NULL;
+
+	if (unlikely(qpn <= 1)) {
+		qp = rcu_dereference(rvp->qp[qpn]);
+	} else {
+		u32 n = hash_32(qpn, rdi->qp_dev->qp_table_bits);
+
+		for (qp = rcu_dereference(rdi->qp_dev->qp_table[n]); qp;
+			qp = rcu_dereference(qp->next))
+			if (qp->ibqp.qp_num == qpn)
+				break;
+	}
+	return qp;
+}
+
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
 int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
diff --git a/include/rdma/rdmavt_mr.h b/include/rdma/rdmavt_mr.h
index ea60476..4aa8171 100644
--- a/include/rdma/rdmavt_mr.h
+++ b/include/rdma/rdmavt_mr.h
@@ -127,4 +127,13 @@ static inline void rvt_get_mr(struct rvt_mregion *mr)
 	atomic_inc(&mr->refcount);
 }
 
+static inline void rvt_put_ss(struct rvt_sge_state *ss)
+{
+	while (ss->num_sge) {
+		rvt_put_mr(ss->sge.mr);
+		if (--ss->num_sge)
+			ss->sge = *ss->sg_list++;
+	}
+}
+
 #endif          /* DEF_RDMAVT_INCMRH */
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 3189f19..e66bcc9 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -355,6 +355,7 @@ struct rvt_srq {
 #define RVT_QPNMAP_ENTRIES          (RVT_QPN_MAX / PAGE_SIZE / BITS_PER_BYTE)
 #define RVT_BITS_PER_PAGE           (PAGE_SIZE * BITS_PER_BYTE)
 #define RVT_BITS_PER_PAGE_MASK      (RVT_BITS_PER_PAGE - 1)
+#define RVT_QPN_MASK		    0xFFFFFF
 
 /*
  * QPN-map pages start out as NULL, they get allocated upon
@@ -397,6 +398,25 @@ static inline struct rvt_swqe *rvt_get_swqe_ptr(struct rvt_qp *qp,
 				      sizeof(struct rvt_sge)) * n);
 }
 
+/*
+ * Since struct rvt_rwqe is not a fixed size, we can't simply index into
+ * struct rvt_rwq.wq.  This function does the array index computation.
+ */
+static inline struct rvt_rwqe *rvt_get_rwqe_ptr(struct rvt_rq *rq, unsigned n)
+{
+	return (struct rvt_rwqe *)
+		((char *)rq->wq->wq +
+		 (sizeof(struct rvt_rwqe) +
+		  rq->max_sge * sizeof(struct ib_sge)) * n);
+}
+
 extern const int  ib_rvt_state_ops[];
 
+struct rvt_dev_info;
+void rvt_remove_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp);
+void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends);
+int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
+void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn);
+void rvt_dec_qp_cnt(struct rvt_dev_info *rdi);
+
 #endif          /* DEF_RDMAVT_INCQP_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

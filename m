From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/3] iw_cxgb4: refactor sq/rq drain logic
Date: Thu, 22 Dec 2016 07:04:59 -0800
Message-ID: <68eb584a0cf57442ca6b2be97f915ab03c9b4293.1482442436.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

With the addition of the IB/Core drain API, iw_cxgb4 supported drain
by watching the CQs when the QP was out of RTS and signalling "drain
complete" when the last CQE is polled.  This, however, doesn't fully
support the drain semantics. Namely, the drain logic is supposed to signal
"drain complete" only when the application has _processed_ the last CQE,
not just removed them from the CQ.  Thus a small timing hole exists that
can cause touch after free type bugs in applications using the drain API
(nvmf, iSER, for example).  So iw_cxgb4 needs a better solution.

The iWARP Verbs spec mandates that "_at some point_ after the QP is
moved to ERROR", the iWARP driver MUST synchronously fail post_send and
post_recv calls.  iw_cxgb4 was currently not allowing any posts once the
QP is in ERROR.  This was in part due to the fact that the HW queues for
the QP in ERROR state are disabled at this point, so there wasn't much
else to do but fail the post operation synchronously.  This restriction
is what drove the first drain implementation in iw_cxgb4 that has the
above mentioned flaw.

This patch changes iw_cxgb4 to allow post_send and post_recv WRs after
the QP is moved to ERROR state for kernel mode users, thus still adhering
to the Verbs spec for user mode users, but allowing flush WRs for kernel
users.  Since the HW queues are disabled, we just synthesize a CQE for
this post, queue it to the SW CQ, and then call the CQ event handler.
This enables proper drain operations for the various storage applications.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c       |  21 ++++---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   6 +-
 drivers/infiniband/hw/cxgb4/provider.c |   2 -
 drivers/infiniband/hw/cxgb4/qp.c       | 112 ++++++++++++++++++++-------------
 drivers/infiniband/hw/cxgb4/t4.h       |   2 +
 5 files changed, 85 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 19c6477..bec82a6 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -505,6 +505,15 @@ static int poll_cq(struct t4_wq *wq, struct t4_cq *cq, struct t4_cqe *cqe,
 	}
 
 	/*
+	 * Special cqe for drain WR completions...
+	 */
+	if (CQE_OPCODE(hw_cqe) == C4IW_DRAIN_OPCODE) {
+		*cookie = CQE_DRAIN_COOKIE(hw_cqe);
+		*cqe = *hw_cqe;
+		goto skip_cqe;
+	}
+
+	/*
 	 * Gotta tweak READ completions:
 	 *	1) the cqe doesn't contain the sq_wptr from the wr.
 	 *	2) opcode not reflected from the wr.
@@ -753,6 +762,9 @@ static int c4iw_poll_cq_one(struct c4iw_cq *chp, struct ib_wc *wc)
 				c4iw_invalidate_mr(qhp->rhp,
 						   CQE_WRID_FR_STAG(&cqe));
 			break;
+		case C4IW_DRAIN_OPCODE:
+			wc->opcode = IB_WC_SEND;
+			break;
 		default:
 			printk(KERN_ERR MOD "Unexpected opcode %d "
 			       "in the CQE received for QPID=0x%0x\n",
@@ -817,15 +829,8 @@ static int c4iw_poll_cq_one(struct c4iw_cq *chp, struct ib_wc *wc)
 		}
 	}
 out:
-	if (wq) {
-		if (unlikely(qhp->attr.state != C4IW_QP_STATE_RTS)) {
-			if (t4_sq_empty(wq))
-				complete(&qhp->sq_drained);
-			if (t4_rq_empty(wq))
-				complete(&qhp->rq_drained);
-		}
+	if (wq)
 		spin_unlock(&qhp->lock);
-	}
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 4788e1a..7b1e465 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -480,8 +480,6 @@ struct c4iw_qp {
 	wait_queue_head_t wait;
 	struct timer_list timer;
 	int sq_sig_all;
-	struct completion rq_drained;
-	struct completion sq_drained;
 };
 
 static inline struct c4iw_qp *to_c4iw_qp(struct ib_qp *ibqp)
@@ -615,6 +613,8 @@ static inline int to_ib_qp_state(int c4iw_qp_state)
 	return IB_QPS_ERR;
 }
 
+#define C4IW_DRAIN_OPCODE FW_RI_SGE_EC_CR_RETURN
+
 static inline u32 c4iw_ib_to_tpt_access(int a)
 {
 	return (a & IB_ACCESS_REMOTE_WRITE ? FW_RI_MEM_ACCESS_REM_WRITE : 0) |
@@ -997,8 +997,6 @@ extern int c4iw_wr_log;
 extern int db_fc_threshold;
 extern int db_coalescing_threshold;
 extern int use_dsgl;
-void c4iw_drain_rq(struct ib_qp *qp);
-void c4iw_drain_sq(struct ib_qp *qp);
 void c4iw_invalidate_mr(struct c4iw_dev *rhp, u32 rkey);
 
 #endif
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 645e606..7b24845 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -605,8 +605,6 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.uverbs_abi_ver = C4IW_UVERBS_ABI_VERSION;
 	dev->ibdev.get_port_immutable = c4iw_port_immutable;
 	dev->ibdev.get_dev_fw_str = get_dev_fw_str;
-	dev->ibdev.drain_sq = c4iw_drain_sq;
-	dev->ibdev.drain_rq = c4iw_drain_rq;
 
 	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
 	if (!dev->ibdev.iwcm)
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index cda5542..31ab451 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -776,6 +776,64 @@ static int ring_kernel_rq_db(struct c4iw_qp *qhp, u16 inc)
 	return 0;
 }
 
+static void complete_sq_drain_wr(struct c4iw_qp *qhp, struct ib_send_wr *wr)
+{
+	struct t4_cqe cqe = {};
+	struct c4iw_cq *schp;
+	unsigned long flag;
+	struct t4_cq *cq;
+
+	schp = to_c4iw_cq(qhp->ibqp.send_cq);
+	cq = &schp->cq;
+
+	cqe.u.drain_cookie = wr->wr_id;
+	cqe.header = cpu_to_be32(CQE_STATUS_V(T4_ERR_SWFLUSH) |
+				 CQE_OPCODE_V(C4IW_DRAIN_OPCODE) |
+				 CQE_TYPE_V(1) |
+				 CQE_SWCQE_V(1) |
+				 CQE_QPID_V(qhp->wq.sq.qid));
+
+	spin_lock_irqsave(&schp->lock, flag);
+	cqe.bits_type_ts = cpu_to_be64(CQE_GENBIT_V((u64)cq->gen));
+	cq->sw_queue[cq->sw_pidx] = cqe;
+	t4_swcq_produce(cq);
+	spin_unlock_irqrestore(&schp->lock, flag);
+
+	spin_lock_irqsave(&schp->comp_handler_lock, flag);
+	(*schp->ibcq.comp_handler)(&schp->ibcq,
+				   schp->ibcq.cq_context);
+	spin_unlock_irqrestore(&schp->comp_handler_lock, flag);
+}
+
+static void complete_rq_drain_wr(struct c4iw_qp *qhp, struct ib_recv_wr *wr)
+{
+	struct t4_cqe cqe = {};
+	struct c4iw_cq *rchp;
+	unsigned long flag;
+	struct t4_cq *cq;
+
+	rchp = to_c4iw_cq(qhp->ibqp.recv_cq);
+	cq = &rchp->cq;
+
+	cqe.u.drain_cookie = wr->wr_id;
+	cqe.header = cpu_to_be32(CQE_STATUS_V(T4_ERR_SWFLUSH) |
+				 CQE_OPCODE_V(C4IW_DRAIN_OPCODE) |
+				 CQE_TYPE_V(0) |
+				 CQE_SWCQE_V(1) |
+				 CQE_QPID_V(qhp->wq.sq.qid));
+
+	spin_lock_irqsave(&rchp->lock, flag);
+	cqe.bits_type_ts = cpu_to_be64(CQE_GENBIT_V((u64)cq->gen));
+	cq->sw_queue[cq->sw_pidx] = cqe;
+	t4_swcq_produce(cq);
+	spin_unlock_irqrestore(&rchp->lock, flag);
+
+	spin_lock_irqsave(&rchp->comp_handler_lock, flag);
+	(*rchp->ibcq.comp_handler)(&rchp->ibcq,
+				   rchp->ibcq.cq_context);
+	spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
+}
+
 int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		   struct ib_send_wr **bad_wr)
 {
@@ -794,8 +852,8 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	spin_lock_irqsave(&qhp->lock, flag);
 	if (t4_wq_in_error(&qhp->wq)) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
-		*bad_wr = wr;
-		return -EINVAL;
+		complete_sq_drain_wr(qhp, wr);
+		return err;
 	}
 	num_wrs = t4_sq_avail(&qhp->wq);
 	if (num_wrs == 0) {
@@ -937,8 +995,8 @@ int c4iw_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	spin_lock_irqsave(&qhp->lock, flag);
 	if (t4_wq_in_error(&qhp->wq)) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
-		*bad_wr = wr;
-		return -EINVAL;
+		complete_rq_drain_wr(qhp, wr);
+		return err;
 	}
 	num_wrs = t4_rq_avail(&qhp->wq);
 	if (num_wrs == 0) {
@@ -1550,7 +1608,12 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 		}
 		break;
 	case C4IW_QP_STATE_CLOSING:
-		if (!internal) {
+
+		/*
+		 * Allow kernel users to move to ERROR for qp draining.
+		 */
+		if (!internal && (qhp->ibqp.uobject || attrs->next_state !=
+				  C4IW_QP_STATE_ERROR)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1763,8 +1826,6 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	qhp->attr.max_ird = 0;
 	qhp->sq_sig_all = attrs->sq_sig_type == IB_SIGNAL_ALL_WR;
 	spin_lock_init(&qhp->lock);
-	init_completion(&qhp->sq_drained);
-	init_completion(&qhp->rq_drained);
 	mutex_init(&qhp->mutex);
 	init_waitqueue_head(&qhp->wait);
 	kref_init(&qhp->kref);
@@ -1958,40 +2019,3 @@ int c4iw_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	init_attr->sq_sig_type = qhp->sq_sig_all ? IB_SIGNAL_ALL_WR : 0;
 	return 0;
 }
-
-static void move_qp_to_err(struct c4iw_qp *qp)
-{
-	struct c4iw_qp_attributes attrs = { .next_state = C4IW_QP_STATE_ERROR };
-
-	(void)c4iw_modify_qp(qp->rhp, qp, C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
-}
-
-void c4iw_drain_sq(struct ib_qp *ibqp)
-{
-	struct c4iw_qp *qp = to_c4iw_qp(ibqp);
-	unsigned long flag;
-	bool need_to_wait;
-
-	move_qp_to_err(qp);
-	spin_lock_irqsave(&qp->lock, flag);
-	need_to_wait = !t4_sq_empty(&qp->wq);
-	spin_unlock_irqrestore(&qp->lock, flag);
-
-	if (need_to_wait)
-		wait_for_completion(&qp->sq_drained);
-}
-
-void c4iw_drain_rq(struct ib_qp *ibqp)
-{
-	struct c4iw_qp *qp = to_c4iw_qp(ibqp);
-	unsigned long flag;
-	bool need_to_wait;
-
-	move_qp_to_err(qp);
-	spin_lock_irqsave(&qp->lock, flag);
-	need_to_wait = !t4_rq_empty(&qp->wq);
-	spin_unlock_irqrestore(&qp->lock, flag);
-
-	if (need_to_wait)
-		wait_for_completion(&qp->rq_drained);
-}
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 862381a..640d221 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -179,6 +179,7 @@ struct t4_cqe {
 			__be32 wrid_hi;
 			__be32 wrid_low;
 		} gen;
+		u64 drain_cookie;
 	} u;
 	__be64 reserved;
 	__be64 bits_type_ts;
@@ -238,6 +239,7 @@ struct t4_cqe {
 /* generic accessor macros */
 #define CQE_WRID_HI(x)		(be32_to_cpu((x)->u.gen.wrid_hi))
 #define CQE_WRID_LOW(x)		(be32_to_cpu((x)->u.gen.wrid_low))
+#define CQE_DRAIN_COOKIE(x)	((x)->u.drain_cookie)
 
 /* macros for flit 3 of the cqe */
 #define CQE_GENBIT_S	63
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

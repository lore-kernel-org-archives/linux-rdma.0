From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH rdma-rc 2/3] iw_cxgb4: reflect the original WR opcode in drain
 cqes
Date: Tue, 19 Dec 2017 10:29:25 -0800
Message-ID: <20171220191649.D75382BBE5@smtp.opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The flush/drain logic was not retaining the original wr opcode in
its completion.  This can cause problems if the application uses
the completion opcode to make decisions.

Use bit 10 of the CQE header word to indicate the CQE is a special
drain completion, and save the original WR opcode in the cqe header
opcode field.

Fixes: 4fe7c2962e11 ("iw_cxgb4: refactor sq/rq drain logic")

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c       |  7 ++----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  2 --
 drivers/infiniband/hw/cxgb4/qp.c       | 46 +++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/cxgb4/t4.h       |  6 +++++
 4 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 7ed8762..6f2b261 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -395,7 +395,7 @@ void c4iw_flush_hw_cq(struct c4iw_cq *chp)
 
 static int cqe_completes_wr(struct t4_cqe *cqe, struct t4_wq *wq)
 {
-	if (CQE_OPCODE(cqe) == C4IW_DRAIN_OPCODE) {
+	if (DRAIN_CQE(cqe)) {
 		WARN_ONCE(1, "Unexpected DRAIN CQE qp id %u!\n", wq->sq.qid);
 		return 0;
 	}
@@ -494,7 +494,7 @@ static int poll_cq(struct t4_wq *wq, struct t4_cq *cq, struct t4_cqe *cqe,
 	/*
 	 * Special cqe for drain WR completions...
 	 */
-	if (CQE_OPCODE(hw_cqe) == C4IW_DRAIN_OPCODE) {
+	if (DRAIN_CQE(hw_cqe)) {
 		*cookie = CQE_DRAIN_COOKIE(hw_cqe);
 		*cqe = *hw_cqe;
 		goto skip_cqe;
@@ -748,9 +748,6 @@ static int c4iw_poll_cq_one(struct c4iw_cq *chp, struct ib_wc *wc)
 				c4iw_invalidate_mr(qhp->rhp,
 						   CQE_WRID_FR_STAG(&cqe));
 			break;
-		case C4IW_DRAIN_OPCODE:
-			wc->opcode = IB_WC_SEND;
-			break;
 		default:
 			pr_err("Unexpected opcode %d in the CQE received for QPID=0x%0x\n",
 			       CQE_OPCODE(&cqe), CQE_QPID(&cqe));
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 470f97a..65dd372 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -693,8 +693,6 @@ static inline int to_ib_qp_state(int c4iw_qp_state)
 	return IB_QPS_ERR;
 }
 
-#define C4IW_DRAIN_OPCODE FW_RI_SGE_EC_CR_RETURN
-
 static inline u32 c4iw_ib_to_tpt_access(int a)
 {
 	return (a & IB_ACCESS_REMOTE_WRITE ? FW_RI_MEM_ACCESS_REM_WRITE : 0) |
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 38bddd0..21495f9 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -790,21 +790,57 @@ static int ring_kernel_rq_db(struct c4iw_qp *qhp, u16 inc)
 	return 0;
 }
 
-static void complete_sq_drain_wr(struct c4iw_qp *qhp, struct ib_send_wr *wr)
+static int ib_to_fw_opcode(int ib_opcode)
+{
+	int opcode;
+
+	switch (ib_opcode) {
+	case IB_WR_SEND_WITH_INV:
+		opcode = FW_RI_SEND_WITH_INV;
+		break;
+	case IB_WR_SEND:
+		opcode = FW_RI_SEND;
+		break;
+	case IB_WR_RDMA_WRITE:
+		opcode = FW_RI_RDMA_WRITE;
+		break;
+	case IB_WR_RDMA_READ:
+	case IB_WR_RDMA_READ_WITH_INV:
+		opcode = FW_RI_READ_REQ;
+		break;
+	case IB_WR_REG_MR:
+		opcode = FW_RI_FAST_REGISTER;
+		break;
+	case IB_WR_LOCAL_INV:
+		opcode = FW_RI_LOCAL_INV;
+		break;
+	default:
+		opcode = -EINVAL;
+	}
+	return opcode;
+}
+
+static int complete_sq_drain_wr(struct c4iw_qp *qhp, struct ib_send_wr *wr)
 {
 	struct t4_cqe cqe = {};
 	struct c4iw_cq *schp;
 	unsigned long flag;
 	struct t4_cq *cq;
+	int opcode;
 
 	schp = to_c4iw_cq(qhp->ibqp.send_cq);
 	cq = &schp->cq;
 
+	opcode = ib_to_fw_opcode(wr->opcode);
+	if (opcode < 0)
+		return opcode;
+
 	cqe.u.drain_cookie = wr->wr_id;
 	cqe.header = cpu_to_be32(CQE_STATUS_V(T4_ERR_SWFLUSH) |
-				 CQE_OPCODE_V(C4IW_DRAIN_OPCODE) |
+				 CQE_OPCODE_V(opcode) |
 				 CQE_TYPE_V(1) |
 				 CQE_SWCQE_V(1) |
+				 CQE_DRAIN_V(1) |
 				 CQE_QPID_V(qhp->wq.sq.qid));
 
 	spin_lock_irqsave(&schp->lock, flag);
@@ -819,6 +855,7 @@ static void complete_sq_drain_wr(struct c4iw_qp *qhp, struct ib_send_wr *wr)
 					   schp->ibcq.cq_context);
 		spin_unlock_irqrestore(&schp->comp_handler_lock, flag);
 	}
+	return 0;
 }
 
 static void complete_rq_drain_wr(struct c4iw_qp *qhp, struct ib_recv_wr *wr)
@@ -833,9 +870,10 @@ static void complete_rq_drain_wr(struct c4iw_qp *qhp, struct ib_recv_wr *wr)
 
 	cqe.u.drain_cookie = wr->wr_id;
 	cqe.header = cpu_to_be32(CQE_STATUS_V(T4_ERR_SWFLUSH) |
-				 CQE_OPCODE_V(C4IW_DRAIN_OPCODE) |
+				 CQE_OPCODE_V(FW_RI_SEND) |
 				 CQE_TYPE_V(0) |
 				 CQE_SWCQE_V(1) |
+				 CQE_DRAIN_V(1) |
 				 CQE_QPID_V(qhp->wq.sq.qid));
 
 	spin_lock_irqsave(&rchp->lock, flag);
@@ -875,7 +913,7 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	 */
 	if (qhp->wq.flushed) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
-		complete_sq_drain_wr(qhp, wr);
+		err = complete_sq_drain_wr(qhp, wr);
 		return err;
 	}
 	num_wrs = t4_sq_avail(&qhp->wq);
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index e9ea942..79e8ee1 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -197,6 +197,11 @@ struct t4_cqe {
 #define CQE_SWCQE_G(x)    ((((x) >> CQE_SWCQE_S)) & CQE_SWCQE_M)
 #define CQE_SWCQE_V(x)	  ((x)<<CQE_SWCQE_S)
 
+#define CQE_DRAIN_S       10
+#define CQE_DRAIN_M       0x1
+#define CQE_DRAIN_G(x)    ((((x) >> CQE_DRAIN_S)) & CQE_DRAIN_M)
+#define CQE_DRAIN_V(x)	  ((x)<<CQE_DRAIN_S)
+
 #define CQE_STATUS_S      5
 #define CQE_STATUS_M      0x1F
 #define CQE_STATUS_G(x)   ((((x) >> CQE_STATUS_S)) & CQE_STATUS_M)
@@ -213,6 +218,7 @@ struct t4_cqe {
 #define CQE_OPCODE_V(x)   ((x)<<CQE_OPCODE_S)
 
 #define SW_CQE(x)         (CQE_SWCQE_G(be32_to_cpu((x)->header)))
+#define DRAIN_CQE(x)      (CQE_DRAIN_G(be32_to_cpu((x)->header)))
 #define CQE_QPID(x)       (CQE_QPID_G(be32_to_cpu((x)->header)))
 #define CQE_TYPE(x)       (CQE_TYPE_G(be32_to_cpu((x)->header)))
 #define SQ_TYPE(x)	  (CQE_TYPE((x)))
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

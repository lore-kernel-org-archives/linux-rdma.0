From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] RDMA/ocrdma: Removed driver QP state machine.
Date: Wed, 7 Aug 2013 12:52:35 +0530
Message-ID: <c627cbc1-836d-4219-b2af-fec2d1241777@CMEXHTCAS1.ad.emulex.com>
References: <1375860157-10588-1-git-send-email-bgottumukkala@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375860157-10588-1-git-send-email-bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Remove qp state machine and depend on stack's service.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 101 +++-------------------------
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   4 +-
 3 files changed, 11 insertions(+), 96 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index af01ba2..c4bb29c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -654,7 +654,7 @@ static void ocrdma_process_qpcat_error(struct ocrdma_dev *dev,
 
 	if (qp == NULL)
 		BUG();
-	ocrdma_qp_state_machine(qp, new_ib_qps, &old_ib_qps);
+	ocrdma_qp_state_change(qp, new_ib_qps, &old_ib_qps);
 }
 
 static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
@@ -1676,8 +1676,8 @@ void ocrdma_flush_qp(struct ocrdma_qp *qp)
 	spin_unlock_irqrestore(&qp->dev->flush_q_lock, flags);
 }
 
-int ocrdma_qp_state_machine(struct ocrdma_qp *qp, enum ib_qp_state new_ib_state,
-			    enum ib_qp_state *old_ib_state)
+int ocrdma_qp_state_change(struct ocrdma_qp *qp, enum ib_qp_state new_ib_state,
+			   enum ib_qp_state *old_ib_state)
 {
 	unsigned long flags;
 	int status = 0;
@@ -1694,96 +1694,11 @@ int ocrdma_qp_state_machine(struct ocrdma_qp *qp, enum ib_qp_state new_ib_state,
 		return 1;
 	}
 
-	switch (qp->state) {
-	case OCRDMA_QPS_RST:
-		switch (new_state) {
-		case OCRDMA_QPS_RST:
-		case OCRDMA_QPS_INIT:
-			break;
-		default:
-			status = -EINVAL;
-			break;
-		};
-		break;
-	case OCRDMA_QPS_INIT:
-		/* qps: INIT->XXX */
-		switch (new_state) {
-		case OCRDMA_QPS_INIT:
-		case OCRDMA_QPS_RTR:
-			break;
-		case OCRDMA_QPS_ERR:
-			ocrdma_flush_qp(qp);
-			break;
-		default:
-			status = -EINVAL;
-			break;
-		};
-		break;
-	case OCRDMA_QPS_RTR:
-		/* qps: RTS->XXX */
-		switch (new_state) {
-		case OCRDMA_QPS_RTS:
-			break;
-		case OCRDMA_QPS_ERR:
-			ocrdma_flush_qp(qp);
-			break;
-		default:
-			status = -EINVAL;
-			break;
-		};
-		break;
-	case OCRDMA_QPS_RTS:
-		/* qps: RTS->XXX */
-		switch (new_state) {
-		case OCRDMA_QPS_SQD:
-		case OCRDMA_QPS_SQE:
-			break;
-		case OCRDMA_QPS_ERR:
-			ocrdma_flush_qp(qp);
-			break;
-		default:
-			status = -EINVAL;
-			break;
-		};
-		break;
-	case OCRDMA_QPS_SQD:
-		/* qps: SQD->XXX */
-		switch (new_state) {
-		case OCRDMA_QPS_RTS:
-		case OCRDMA_QPS_SQE:
-		case OCRDMA_QPS_ERR:
-			break;
-		default:
-			status = -EINVAL;
-			break;
-		};
-		break;
-	case OCRDMA_QPS_SQE:
-		switch (new_state) {
-		case OCRDMA_QPS_RTS:
-		case OCRDMA_QPS_ERR:
-			break;
-		default:
-			status = -EINVAL;
-			break;
-		};
-		break;
-	case OCRDMA_QPS_ERR:
-		/* qps: ERR->XXX */
-		switch (new_state) {
-		case OCRDMA_QPS_RST:
-			break;
-		default:
-			status = -EINVAL;
-			break;
-		};
-		break;
-	default:
-		status = -EINVAL;
-		break;
-	};
-	if (!status)
-		qp->state = new_state;
+
+	if (new_state == OCRDMA_QPS_ERR)
+		ocrdma_flush_qp(qp);
+
+	qp->state = new_state;
 
 	spin_unlock_irqrestore(&qp->q_lock, flags);
 	return status;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
index 5d8e6f5..cc90ac3 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -122,7 +122,7 @@ int ocrdma_mbx_destroy_srq(struct ocrdma_dev *, struct ocrdma_srq *);
 int ocrdma_alloc_av(struct ocrdma_dev *, struct ocrdma_ah *);
 int ocrdma_free_av(struct ocrdma_dev *, struct ocrdma_ah *);
 
-int ocrdma_qp_state_machine(struct ocrdma_qp *, enum ib_qp_state new_state,
+int ocrdma_qp_state_change(struct ocrdma_qp *, enum ib_qp_state new_state,
 			    enum ib_qp_state *old_ib_state);
 bool ocrdma_is_qp_in_sq_flushlist(struct ocrdma_cq *, struct ocrdma_qp *);
 bool ocrdma_is_qp_in_rq_flushlist(struct ocrdma_cq *, struct ocrdma_qp *);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 2df980b..40d2c1c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1099,7 +1099,7 @@ int _ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	qp = get_ocrdma_qp(ibqp);
 	dev = qp->dev;
 	if (attr_mask & IB_QP_STATE)
-		status = ocrdma_qp_state_machine(qp, attr->qp_state, &old_qps);
+		status = ocrdma_qp_state_change(qp, attr->qp_state, &old_qps);
 	/* if new and previous states are same hw doesn't need to
 	 * know about it.
 	 */
@@ -2103,7 +2103,7 @@ static bool ocrdma_update_err_cqe(struct ib_wc *ibwc, struct ocrdma_cqe *cqe,
 	ibwc->status = ocrdma_to_ibwc_err(status);
 
 	ocrdma_flush_qp(qp);
-	ocrdma_qp_state_machine(qp, IB_QPS_ERR, NULL);
+	ocrdma_qp_state_change(qp, IB_QPS_ERR, NULL);
 
 	/* if wqe/rqe pending for which cqe needs to be returned,
 	 * trigger inflating it.
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

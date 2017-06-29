From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 12/13] RDMA/bnxt_re: Report MISSED_EVENTS in req_notify_cq
Date: Thu, 29 Jun 2017 12:28:18 -0700
Message-ID: <1498764499-24157-13-git-send-email-selvin.xavier@broadcom.com>
References: <1498764499-24157-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498764499-24157-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While invoking the req_notify_cq hook, ULPs can request
whether the CQs have any CQEs pending. If CQEs are pending,
drivers can indicate  it by returning 1 for req_notify_cq.
The stack will poll CQ again till CQ is empty.

This patch peeks the CQ for any valid entries and return accordingly.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  5 +++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 19 +++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.h |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 27893f7..2cfcd38 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3034,6 +3034,11 @@ int bnxt_re_req_notify_cq(struct ib_cq *ib_cq,
 	else if (ib_cqn_flags & IB_CQ_SOLICITED)
 		type = DBR_DBR_TYPE_CQ_ARMSE;
 
+	/* Poll to see if there are missed events */
+	if ((ib_cqn_flags & IB_CQ_REPORT_MISSED_EVENTS) &&
+	    !(bnxt_qplib_is_cq_empty(&cq->qplib_cq)))
+		return 1;
+
 	bnxt_qplib_req_notify_cq(&cq->qplib_cq, type);
 
 	return 0;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index bd95539..31e15f3 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2164,6 +2164,25 @@ static int bnxt_qplib_cq_process_res_ud(struct bnxt_qplib_cq *cq,
 	return rc;
 }
 
+bool bnxt_qplib_is_cq_empty(struct bnxt_qplib_cq *cq)
+{
+	struct cq_base *hw_cqe, **hw_cqe_ptr;
+	unsigned long flags;
+	u32 sw_cons, raw_cons;
+	bool rc = true;
+
+	spin_lock_irqsave(&cq->hwq.lock, flags);
+	raw_cons = cq->hwq.cons;
+	sw_cons = HWQ_CMP(raw_cons, &cq->hwq);
+	hw_cqe_ptr = (struct cq_base **)cq->hwq.pbl_ptr;
+	hw_cqe = &hw_cqe_ptr[CQE_PG(sw_cons)][CQE_IDX(sw_cons)];
+
+	 /* Check for Valid bit. If the CQE is valid, return false */
+	rc = !CQE_CMP_VALID(hw_cqe, raw_cons, cq->hwq.max_elements);
+	spin_unlock_irqrestore(&cq->hwq.lock, flags);
+	return rc;
+}
+
 static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
 						struct cq_res_raweth_qp1 *hwcqe,
 						struct bnxt_qplib_cqe **pcqe,
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 2495b33..23a26d5 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -463,6 +463,7 @@ int bnxt_qplib_create_cq(struct bnxt_qplib_res *res, struct bnxt_qplib_cq *cq);
 int bnxt_qplib_destroy_cq(struct bnxt_qplib_res *res, struct bnxt_qplib_cq *cq);
 int bnxt_qplib_poll_cq(struct bnxt_qplib_cq *cq, struct bnxt_qplib_cqe *cqe,
 		       int num, struct bnxt_qplib_qp **qp);
+bool bnxt_qplib_is_cq_empty(struct bnxt_qplib_cq *cq);
 void bnxt_qplib_req_notify_cq(struct bnxt_qplib_cq *cq, u32 arm_type);
 void bnxt_qplib_free_nq(struct bnxt_qplib_nq *nq);
 int bnxt_qplib_alloc_nq(struct pci_dev *pdev, struct bnxt_qplib_nq *nq);
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

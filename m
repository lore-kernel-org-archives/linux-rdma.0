From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/4] RDMA/bnxt_re: Flush CQ notification Work Queue before destroying QP
Date: Mon,  6 Nov 2017 08:07:31 -0800
Message-ID: <1509984452-18336-4-git-send-email-selvin.xavier@broadcom.com>
References: <1509984452-18336-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509984452-18336-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Destroy_qp shall wait for any outstanding CQ notification to be
flushed out before proceeding with QP destroy. Flushing the WQ
before destroying the QP.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 7 +++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.h | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ebcdfb4..96ec797 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -788,6 +788,7 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp)
 	struct bnxt_re_dev *rdev = qp->rdev;
 	int rc;
 
+	bnxt_qplib_flush_cqn_wq(&qp->qplib_qp);
 	bnxt_qplib_del_flush_qp(&qp->qplib_qp);
 	rc = bnxt_qplib_destroy_qp(&rdev->qplib_res, &qp->qplib_qp);
 	if (rc) {
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 805a612..c0f8133 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2537,3 +2537,10 @@ void bnxt_qplib_req_notify_cq(struct bnxt_qplib_cq *cq, u32 arm_type)
 	atomic_set(&cq->arm_state, 1);
 	spin_unlock_irqrestore(&cq->hwq.lock, flags);
 }
+
+void bnxt_qplib_flush_cqn_wq(struct bnxt_qplib_qp *qp)
+{
+	flush_workqueue(qp->scq->nq->cqn_wq);
+	if (qp->scq != qp->rcq)
+		flush_workqueue(qp->rcq->nq->cqn_wq);
+}
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 8ead70c..c582d4e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -478,4 +478,5 @@ void bnxt_qplib_release_cq_locks(struct bnxt_qplib_qp *qp,
 int bnxt_qplib_process_flush_list(struct bnxt_qplib_cq *cq,
 				  struct bnxt_qplib_cqe *cqe,
 				  int num_cqes);
+void bnxt_qplib_flush_cqn_wq(struct bnxt_qplib_qp *qp);
 #endif /* __BNXT_QPLIB_FP_H__ */
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

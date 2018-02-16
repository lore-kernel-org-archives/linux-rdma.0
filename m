From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-rc 4/6] RDMA/bnxt_re: Synchronize destroy_qp with poll_cq
Date: Thu, 15 Feb 2018 21:20:11 -0800
Message-ID: <1518758413-20850-5-git-send-email-selvin.xavier@broadcom.com>
References: <1518758413-20850-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518758413-20850-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid system crash when destroy_qp is invoked while
the driver is processing the poll_cq. Synchronize these
functions using the cq_lock.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 39 +++++++++++++++++++++++++++++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  2 ++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 21 +++++------------
 drivers/infiniband/hw/bnxt_re/qplib_fp.h |  4 +++-
 4 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index b7eb104..9cb9928 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -786,20 +786,51 @@ int bnxt_re_query_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr)
 	return 0;
 }
 
+static unsigned long bnxt_re_lock_cqs(struct bnxt_re_qp *qp)
+	__acquires(&qp->scq->cq_lock) __acquires(&qp->rcq->cq_lock)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->scq->cq_lock, flags);
+	if (qp->rcq != qp->scq)
+		spin_lock(&qp->rcq->cq_lock);
+	else
+		__acquire(&qp->rcq->cq_lock);
+
+	return flags;
+}
+
+static void bnxt_re_unlock_cqs(struct bnxt_re_qp *qp,
+			       unsigned long flags)
+	__releases(&qp->scq->cq_lock) __releases(&qp->rcq->cq_lock)
+{
+	if (qp->rcq != qp->scq)
+		spin_unlock(&qp->rcq->cq_lock);
+	else
+		__release(&qp->rcq->cq_lock);
+	spin_unlock_irqrestore(&qp->scq->cq_lock, flags);
+}
+
 /* Queue Pairs */
 int bnxt_re_destroy_qp(struct ib_qp *ib_qp)
 {
 	struct bnxt_re_qp *qp = container_of(ib_qp, struct bnxt_re_qp, ib_qp);
 	struct bnxt_re_dev *rdev = qp->rdev;
 	int rc;
+	unsigned int flags;
 
 	bnxt_qplib_flush_cqn_wq(&qp->qplib_qp);
-	bnxt_qplib_del_flush_qp(&qp->qplib_qp);
 	rc = bnxt_qplib_destroy_qp(&rdev->qplib_res, &qp->qplib_qp);
 	if (rc) {
 		dev_err(rdev_to_dev(rdev), "Failed to destroy HW QP");
 		return rc;
 	}
+
+	flags = bnxt_re_lock_cqs(qp);
+	bnxt_qplib_clean_qp(&qp->qplib_qp);
+	bnxt_re_unlock_cqs(qp, flags);
+	bnxt_qplib_free_qp_res(&rdev->qplib_res, &qp->qplib_qp);
+
 	if (ib_qp->qp_type == IB_QPT_GSI && rdev->qp1_sqp) {
 		rc = bnxt_qplib_destroy_ah(&rdev->qplib_res,
 					   &rdev->sqp_ah->qplib_ah);
@@ -809,7 +840,7 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp)
 			return rc;
 		}
 
-		bnxt_qplib_del_flush_qp(&qp->qplib_qp);
+		bnxt_qplib_clean_qp(&qp->qplib_qp);
 		rc = bnxt_qplib_destroy_qp(&rdev->qplib_res,
 					   &rdev->qp1_sqp->qplib_qp);
 		if (rc) {
@@ -1068,6 +1099,7 @@ struct ib_qp *bnxt_re_create_qp(struct ib_pd *ib_pd,
 			goto fail;
 		}
 		qp->qplib_qp.scq = &cq->qplib_cq;
+		qp->scq = cq;
 	}
 
 	if (qp_init_attr->recv_cq) {
@@ -1079,6 +1111,7 @@ struct ib_qp *bnxt_re_create_qp(struct ib_pd *ib_pd,
 			goto fail;
 		}
 		qp->qplib_qp.rcq = &cq->qplib_cq;
+		qp->rcq = cq;
 	}
 
 	if (qp_init_attr->srq) {
@@ -1612,7 +1645,7 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 			dev_dbg(rdev_to_dev(rdev),
 				"Move QP = %p out of flush list\n",
 				qp);
-			bnxt_qplib_del_flush_qp(&qp->qplib_qp);
+			bnxt_qplib_clean_qp(&qp->qplib_qp);
 		}
 	}
 	if (qp_attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY) {
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 423ebe0..b88a48d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -89,6 +89,8 @@ struct bnxt_re_qp {
 	/* QP1 */
 	u32			send_psn;
 	struct ib_ud_header	qp1_hdr;
+	struct bnxt_re_cq	*scq;
+	struct bnxt_re_cq	*rcq;
 };
 
 struct bnxt_re_cq {
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 8b5f11a..52df919 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -173,7 +173,7 @@ static void __bnxt_qplib_del_flush_qp(struct bnxt_qplib_qp *qp)
 	}
 }
 
-void bnxt_qplib_del_flush_qp(struct bnxt_qplib_qp *qp)
+void bnxt_qplib_clean_qp(struct bnxt_qplib_qp *qp)
 {
 	unsigned long flags;
 
@@ -1417,7 +1417,6 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
 	struct bnxt_qplib_rcfw *rcfw = res->rcfw;
 	struct cmdq_destroy_qp req;
 	struct creq_destroy_qp_resp resp;
-	unsigned long flags;
 	u16 cmd_flags = 0;
 	int rc;
 
@@ -1435,19 +1434,12 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
 		return rc;
 	}
 
-	/* Must walk the associated CQs to nullified the QP ptr */
-	spin_lock_irqsave(&qp->scq->hwq.lock, flags);
-
-	__clean_cq(qp->scq, (u64)(unsigned long)qp);
-
-	if (qp->rcq && qp->rcq != qp->scq) {
-		spin_lock(&qp->rcq->hwq.lock);
-		__clean_cq(qp->rcq, (u64)(unsigned long)qp);
-		spin_unlock(&qp->rcq->hwq.lock);
-	}
-
-	spin_unlock_irqrestore(&qp->scq->hwq.lock, flags);
+	return 0;
+}
 
+void bnxt_qplib_free_qp_res(struct bnxt_qplib_res *res,
+			    struct bnxt_qplib_qp *qp)
+{
 	bnxt_qplib_free_qp_hdr_buf(res, qp);
 	bnxt_qplib_free_hwq(res->pdev, &qp->sq.hwq);
 	kfree(qp->sq.swq);
@@ -1460,7 +1452,6 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
 	if (qp->orrq.max_elements)
 		bnxt_qplib_free_hwq(res->pdev, &qp->orrq);
 
-	return 0;
 }
 
 void *bnxt_qplib_get_qp1_sq_buf(struct bnxt_qplib_qp *qp,
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 211b27a..ca0a2ff 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -478,6 +478,9 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp);
 int bnxt_qplib_modify_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp);
 int bnxt_qplib_query_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp);
 int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp);
+void bnxt_qplib_clean_qp(struct bnxt_qplib_qp *qp);
+void bnxt_qplib_free_qp_res(struct bnxt_qplib_res *res,
+			    struct bnxt_qplib_qp *qp);
 void *bnxt_qplib_get_qp1_sq_buf(struct bnxt_qplib_qp *qp,
 				struct bnxt_qplib_sge *sge);
 void *bnxt_qplib_get_qp1_rq_buf(struct bnxt_qplib_qp *qp,
@@ -500,7 +503,6 @@ void bnxt_qplib_req_notify_cq(struct bnxt_qplib_cq *cq, u32 arm_type);
 void bnxt_qplib_free_nq(struct bnxt_qplib_nq *nq);
 int bnxt_qplib_alloc_nq(struct pci_dev *pdev, struct bnxt_qplib_nq *nq);
 void bnxt_qplib_add_flush_qp(struct bnxt_qplib_qp *qp);
-void bnxt_qplib_del_flush_qp(struct bnxt_qplib_qp *qp);
 void bnxt_qplib_acquire_cq_locks(struct bnxt_qplib_qp *qp,
 				 unsigned long *flags);
 void bnxt_qplib_release_cq_locks(struct bnxt_qplib_qp *qp,
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

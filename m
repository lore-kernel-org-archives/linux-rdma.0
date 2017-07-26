From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 8/8] RDMA/qedr: Add support for iWARP in user space
Date: Wed, 26 Jul 2017 14:41:57 +0300
Message-ID: <1501069317-16601-9-git-send-email-Michal.Kalderon@cavium.com>
References: <1501069317-16601-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501069317-16601-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: michal.kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: yuval.mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pass the second doorbell offset to userspace in create_qp response.
Pbl allocation is different for RoCE and iWARP and requires
different handling. RoCE allocated the pbl and passes the pointer
to qed, where-as in iWARP, qed allocates the pbl and qedr
populates it after it returns

Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 80 ++++++++++++++++++++++++++++++--------
 1 file changed, 63 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 7067249..4e14a55 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -789,7 +789,8 @@ static inline int qedr_init_user_queue(struct ib_ucontext *ib_ctx,
 				       struct qedr_dev *dev,
 				       struct qedr_userq *q,
 				       u64 buf_addr, size_t buf_len,
-				       int access, int dmasync)
+				       int access, int dmasync,
+				       int alloc_and_init)
 {
 	u32 fw_pages;
 	int rc;
@@ -810,19 +811,25 @@ static inline int qedr_init_user_queue(struct ib_ucontext *ib_ctx,
 	if (rc)
 		goto err0;
 
-	q->pbl_tbl = qedr_alloc_pbl_tbl(dev, &q->pbl_info, GFP_KERNEL);
-	if (IS_ERR(q->pbl_tbl)) {
-		rc = PTR_ERR(q->pbl_tbl);
-		goto err0;
-	}
-
+	if (alloc_and_init) {
+		q->pbl_tbl = qedr_alloc_pbl_tbl(dev, &q->pbl_info, GFP_KERNEL);
+		if (IS_ERR(q->pbl_tbl)) {
+			rc = PTR_ERR(q->pbl_tbl);
+			goto err0;
+		}
 		qedr_populate_pbls(dev, q->umem, q->pbl_tbl, &q->pbl_info,
 				   FW_PAGE_SHIFT);
+	} else {
+		q->pbl_tbl = kzalloc(sizeof(*q->pbl_tbl), GFP_KERNEL);
+		if (!q->pbl_tbl)
+			goto err0;
+	}
 
 	return 0;
 
 err0:
 	ib_umem_release(q->umem);
+	q->umem = NULL;
 
 	return rc;
 }
@@ -948,7 +955,8 @@ struct ib_cq *qedr_create_cq(struct ib_device *ibdev,
 		cq->cq_type = QEDR_CQ_TYPE_USER;
 
 		rc = qedr_init_user_queue(ib_ctx, dev, &cq->q, ureq.addr,
-					  ureq.len, IB_ACCESS_LOCAL_WRITE, 1);
+					  ureq.len, IB_ACCESS_LOCAL_WRITE,
+					  1, 1);
 		if (rc)
 			goto err0;
 
@@ -1241,18 +1249,34 @@ static int qedr_check_qp_attrs(struct ib_pd *ibpd, struct qedr_dev *dev,
 	return 0;
 }
 
-static void qedr_copy_rq_uresp(struct qedr_create_qp_uresp *uresp,
+static void qedr_copy_rq_uresp(struct qedr_dev *dev,
+			       struct qedr_create_qp_uresp *uresp,
 			       struct qedr_qp *qp)
 {
-	uresp->rq_db_offset = DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_ROCE_RQ_PROD);
+	/* iWARP requires two doorbells per RQ. */
+	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
+		uresp->rq_db_offset =
+		    DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_IWARP_RQ_PROD);
+		uresp->rq_db2_offset = DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_FLAGS);
+	} else {
+		uresp->rq_db_offset =
+		    DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_ROCE_RQ_PROD);
+	}
+
 	uresp->rq_icid = qp->icid;
 }
 
-static void qedr_copy_sq_uresp(struct qedr_create_qp_uresp *uresp,
+static void qedr_copy_sq_uresp(struct qedr_dev *dev,
+			       struct qedr_create_qp_uresp *uresp,
 			       struct qedr_qp *qp)
 {
 	uresp->sq_db_offset = DB_ADDR_SHIFT(DQ_PWM_OFFSET_XCM_RDMA_SQ_PROD);
-	uresp->sq_icid = qp->icid + 1;
+
+	/* iWARP uses the same cid for rq and sq */
+	if (rdma_protocol_iwarp(&dev->ibdev, 1))
+		uresp->sq_icid = qp->icid;
+	else
+		uresp->sq_icid = qp->icid + 1;
 }
 
 static int qedr_copy_qp_uresp(struct qedr_dev *dev,
@@ -1262,8 +1286,8 @@ static int qedr_copy_qp_uresp(struct qedr_dev *dev,
 	int rc;
 
 	memset(&uresp, 0, sizeof(uresp));
-	qedr_copy_sq_uresp(&uresp, qp);
-	qedr_copy_rq_uresp(&uresp, qp);
+	qedr_copy_sq_uresp(dev, &uresp, qp);
+	qedr_copy_rq_uresp(dev, &uresp, qp);
 
 	uresp.atomic_supported = dev->atomic_cap != IB_ATOMIC_NONE;
 	uresp.qp_id = qp->qp_id;
@@ -1381,6 +1405,25 @@ static void qedr_idr_remove(struct qedr_dev *dev, u32 id)
 	idr_remove(&dev->qpidr, id);
 	spin_unlock_irq(&dev->idr_lock);
 }
+
+static inline void
+qedr_iwarp_populate_user_qp(struct qedr_dev *dev,
+			    struct qedr_qp *qp,
+			    struct qed_rdma_create_qp_out_params *out_params)
+{
+	qp->usq.pbl_tbl->va = out_params->sq_pbl_virt;
+	qp->usq.pbl_tbl->pa = out_params->sq_pbl_phys;
+
+	qedr_populate_pbls(dev, qp->usq.umem, qp->usq.pbl_tbl,
+			   &qp->usq.pbl_info, FW_PAGE_SHIFT);
+
+	qp->urq.pbl_tbl->va = out_params->rq_pbl_virt;
+	qp->urq.pbl_tbl->pa = out_params->rq_pbl_phys;
+
+	qedr_populate_pbls(dev, qp->urq.umem, qp->urq.pbl_tbl,
+			   &qp->urq.pbl_info, FW_PAGE_SHIFT);
+}
+
 static void qedr_cleanup_user(struct qedr_dev *dev, struct qedr_qp *qp)
 {
 	if (qp->usq.umem)
@@ -1404,6 +1447,7 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	struct ib_ucontext *ib_ctx = NULL;
 	struct qedr_ucontext *ctx = NULL;
 	struct qedr_create_qp_ureq ureq;
+	int alloc_and_init = rdma_protocol_roce(&dev->ibdev, 1);
 	int rc = -EINVAL;
 
 	ib_ctx = ibpd->uobject->context;
@@ -1418,14 +1462,13 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 
 	/* SQ - read access only (0), dma sync not required (0) */
 	rc = qedr_init_user_queue(ib_ctx, dev, &qp->usq, ureq.sq_addr,
-				  ureq.sq_len, 0, 0);
+				  ureq.sq_len, 0, 0, alloc_and_init);
 	if (rc)
 		return rc;
 
 	/* RQ - read access only (0), dma sync not required (0) */
 	rc = qedr_init_user_queue(ib_ctx, dev, &qp->urq, ureq.rq_addr,
-				  ureq.rq_len, 0, 0);
-
+				  ureq.rq_len, 0, 0, alloc_and_init);
 	if (rc)
 		return rc;
 
@@ -1446,6 +1489,9 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 		goto err1;
 	}
 
+	if (rdma_protocol_iwarp(&dev->ibdev, 1))
+		qedr_iwarp_populate_user_qp(dev, qp, &out_params);
+
 	qp->qp_id = out_params.qp_id;
 	qp->icid = out_params.icid;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

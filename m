From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 26/26] IB/ocrdma: Adjust further ten checks for null pointers
Date: Wed, 8 Mar 2017 14:34:13 +0100
Message-ID: <19973137-7453-6a50-822a-c3a075e1c18f@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Wed, 8 Mar 2017 12:50:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl“ pointed information out like the following.

Comparison to NULL could be written !…

Thus fix affected source code places.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index bfd86fd08847..bd719e7f134e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -267,7 +267,7 @@ static int ocrdma_add_mmap(struct ocrdma_ucontext *uctx, u64 phy_addr,
 	struct ocrdma_mm *mm;
 
 	mm = kzalloc(sizeof(*mm), GFP_KERNEL);
-	if (mm == NULL)
+	if (!mm)
 		return -ENOMEM;
 	mm->key.phy_addr = phy_addr;
 	mm->key.len = len;
@@ -1187,7 +1187,7 @@ static int ocrdma_add_qpn_map(struct ocrdma_dev *dev, struct ocrdma_qp *qp)
 {
 	int status = -EINVAL;
 
-	if (qp->id < OCRDMA_MAX_QP && dev->qp_tbl[qp->id] == NULL) {
+	if (qp->id < OCRDMA_MAX_QP && !dev->qp_tbl[qp->id]) {
 		dev->qp_tbl[qp->id] = qp;
 		status = 0;
 	}
@@ -1355,11 +1355,11 @@ static int ocrdma_alloc_wr_id_tbl(struct ocrdma_qp *qp)
 {
 	qp->wqe_wr_id_tbl = kcalloc(qp->sq.max_cnt, sizeof(*qp->wqe_wr_id_tbl),
 				    GFP_KERNEL);
-	if (qp->wqe_wr_id_tbl == NULL)
+	if (!qp->wqe_wr_id_tbl)
 		return -ENOMEM;
 	qp->rqe_wr_id_tbl = kcalloc(qp->rq.max_cnt, sizeof(*qp->rqe_wr_id_tbl),
 				    GFP_KERNEL);
-	if (qp->rqe_wr_id_tbl == NULL)
+	if (!qp->rqe_wr_id_tbl)
 		return -ENOMEM;
 
 	return 0;
@@ -1419,7 +1419,7 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 		goto gen_err;
 	}
 	ocrdma_set_qp_init_params(qp, pd, attrs);
-	if (udata == NULL)
+	if (!udata)
 		qp->cap_flags |= (OCRDMA_QP_MW_BIND | OCRDMA_QP_LKEY0 |
 					OCRDMA_QP_FAST_REG);
 
@@ -1431,7 +1431,7 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 		goto mbx_err;
 
 	/* user space QP's wr_id table are managed in library */
-	if (udata == NULL) {
+	if (!udata) {
 		status = ocrdma_alloc_wr_id_tbl(qp);
 		if (status)
 			goto map_err;
@@ -1892,11 +1892,11 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 	if (status)
 		goto err;
 
-	if (udata == NULL) {
+	if (!udata) {
 		srq->rqe_wr_id_tbl = kcalloc(srq->rq.max_cnt,
 					     sizeof(*srq->rqe_wr_id_tbl),
 					     GFP_KERNEL);
-		if (srq->rqe_wr_id_tbl == NULL)
+		if (!srq->rqe_wr_id_tbl)
 			goto arm_err;
 
 		srq->bit_fields_len = (srq->rq.max_cnt / 32) +
@@ -1904,7 +1904,7 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 		srq->idx_bit_fields = kmalloc_array(srq->bit_fields_len,
 						    sizeof(*srq->idx_bit_fields),
 						    GFP_KERNEL);
-		if (srq->idx_bit_fields == NULL)
+		if (!srq->idx_bit_fields)
 			goto arm_err;
 		memset(srq->idx_bit_fields, 0xff,
 		       srq->bit_fields_len * sizeof(*srq->idx_bit_fields));
@@ -2878,7 +2878,7 @@ static int ocrdma_poll_hwcq(struct ocrdma_cq *cq, int num_entries,
 		if (qpn == 0)
 			goto skip_cqe;
 		qp = dev->qp_tbl[qpn];
-		BUG_ON(qp == NULL);
+		BUG_ON(!qp);
 
 		expand = is_cqe_for_sq(cqe)
 			 ? ocrdma_poll_scqe(qp, cqe, ibwc, &polled, &stop)
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

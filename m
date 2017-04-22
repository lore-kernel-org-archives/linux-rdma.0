From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v2 02/12] IB/ocrdma: Use kcalloc() in five functions
Date: Sat, 22 Apr 2017 16:33:00 +0200
Message-ID: <bc2e618f-9bfe-25bb-af16-e915605fc112@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sat, 22 Apr 2017 11:41:55 +0200

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of data types by pointer dereferences
  to make the corresponding size determinations a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---

v2:
Changes were rebased on source files from Linux next-20170421.
These were recombined as requested by Doug Ledford.

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 10 +++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 19 +++++++++----------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index c868314222b9..d5a3127b6df8 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -3103,7 +3103,7 @@ static int ocrdma_create_eqs(struct ocrdma_dev *dev)
 	if (!num_eq)
 		return -EINVAL;
 
-	dev->eq_tbl = kzalloc(sizeof(struct ocrdma_eq) * num_eq, GFP_KERNEL);
+	dev->eq_tbl = kcalloc(num_eq, sizeof(*dev->eq_tbl), GFP_KERNEL);
 	if (!dev->eq_tbl)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 57c9a2ad0260..91705b10f269 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -225,19 +225,19 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
 {
 	mutex_init(&dev->dev_lock);
-	dev->cq_tbl = kzalloc(sizeof(struct ocrdma_cq *) *
-			      OCRDMA_MAX_CQ, GFP_KERNEL);
+	dev->cq_tbl = kcalloc(OCRDMA_MAX_CQ, sizeof(*dev->cq_tbl), GFP_KERNEL);
 	if (!dev->cq_tbl)
 		goto alloc_err;
 
 	if (dev->attr.max_qp) {
-		dev->qp_tbl = kzalloc(sizeof(struct ocrdma_qp *) *
-				      OCRDMA_MAX_QP, GFP_KERNEL);
+		dev->qp_tbl = kcalloc(OCRDMA_MAX_QP, sizeof(*dev->qp_tbl),
+				      GFP_KERNEL);
 		if (!dev->qp_tbl)
 			goto alloc_err;
 	}
 
-	dev->stag_arr = kzalloc(sizeof(u64) * OCRDMA_MAX_STAG, GFP_KERNEL);
+	dev->stag_arr = kcalloc(OCRDMA_MAX_STAG, sizeof(*dev->stag_arr),
+				GFP_KERNEL);
 	if (dev->stag_arr == NULL)
 		goto alloc_err;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index c52edeafd616..146601c97158 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -879,9 +879,8 @@ static int ocrdma_build_pbl_tbl(struct ocrdma_dev *dev, struct ocrdma_hw_mr *mr)
 	void *va;
 	dma_addr_t pa;
 
-	mr->pbl_table = kzalloc(sizeof(struct ocrdma_pbl) *
-				mr->num_pbls, GFP_KERNEL);
-
+	mr->pbl_table = kcalloc(mr->num_pbls, sizeof(*mr->pbl_table),
+				GFP_KERNEL);
 	if (!mr->pbl_table)
 		return -ENOMEM;
 
@@ -1362,13 +1361,12 @@ static void ocrdma_set_qp_db(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
 
 static int ocrdma_alloc_wr_id_tbl(struct ocrdma_qp *qp)
 {
-	qp->wqe_wr_id_tbl =
-	    kzalloc(sizeof(*(qp->wqe_wr_id_tbl)) * qp->sq.max_cnt,
-		    GFP_KERNEL);
+	qp->wqe_wr_id_tbl = kcalloc(qp->sq.max_cnt, sizeof(*qp->wqe_wr_id_tbl),
+				    GFP_KERNEL);
 	if (qp->wqe_wr_id_tbl == NULL)
 		return -ENOMEM;
-	qp->rqe_wr_id_tbl =
-	    kzalloc(sizeof(u64) * qp->rq.max_cnt, GFP_KERNEL);
+	qp->rqe_wr_id_tbl = kcalloc(qp->rq.max_cnt, sizeof(*qp->rqe_wr_id_tbl),
+				    GFP_KERNEL);
 	if (qp->rqe_wr_id_tbl == NULL)
 		return -ENOMEM;
 
@@ -1903,8 +1901,9 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 		goto err;
 
 	if (udata == NULL) {
-		srq->rqe_wr_id_tbl = kzalloc(sizeof(u64) * srq->rq.max_cnt,
-			    GFP_KERNEL);
+		srq->rqe_wr_id_tbl = kcalloc(srq->rq.max_cnt,
+					     sizeof(*srq->rqe_wr_id_tbl),
+					     GFP_KERNEL);
 		if (srq->rqe_wr_id_tbl == NULL)
 			goto arm_err;
 
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

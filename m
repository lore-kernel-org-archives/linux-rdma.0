From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 25/26] IB/ocrdma: Delete unnecessary braces
Date: Wed, 8 Mar 2017 14:32:15 +0100
Message-ID: <dddca366-47ad-9319-4933-e1a07578018e@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Mar 2017 12:36:41 +0100

Do not use curly brackets at some source code places
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 41 +++++++++++------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index d3cb8e2f099f..bfd86fd08847 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -502,10 +502,10 @@ static int ocrdma_dealloc_ucontext_pd(struct ocrdma_ucontext *uctx)
 	struct ocrdma_pd *pd = uctx->cntxt_pd;
 	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 
-	if (uctx->pd_in_use) {
+	if (uctx->pd_in_use)
 		pr_err("%s(%d) Freeing in use pdid=0x%x.\n",
 		       __func__, dev->id, pd->id);
-	}
+
 	uctx->cntxt_pd = NULL;
 	(void)_ocrdma_dealloc_pd(dev, pd);
 	return 0;
@@ -739,11 +739,10 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *ibdev,
 	return &pd->ibpd;
 
 err:
-	if (is_uctx_pd) {
+	if (is_uctx_pd)
 		ocrdma_release_ucontext_pd(uctx);
-	} else {
+	else
 		status = _ocrdma_dealloc_pd(dev, pd);
-	}
 exit:
 	return ERR_PTR(status);
 }
@@ -1018,10 +1017,10 @@ int ocrdma_dereg_mr(struct ib_mr *ib_mr)
 	kfree(mr);
 
 	/* Don't stop cleanup, in case FW is unresponsive */
-	if (dev->mqe_ctx.fw_error_state) {
+	if (dev->mqe_ctx.fw_error_state)
 		pr_err("%s(%d) fw not responding.\n",
 		       __func__, dev->id);
-	}
+
 	return 0;
 }
 
@@ -1410,10 +1409,10 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 		goto gen_err;
 
 	memset(&ureq, 0, sizeof(ureq));
-	if (udata) {
+	if (udata)
 		if (ib_copy_from_udata(&ureq, udata, sizeof(ureq)))
 			return ERR_PTR(-EFAULT);
-	}
+
 	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
 	if (!qp) {
 		status = -ENOMEM;
@@ -2829,15 +2828,11 @@ static bool ocrdma_poll_rcqe(struct ocrdma_qp *qp, struct ocrdma_cqe *cqe,
 	bool expand = false;
 
 	ibwc->wc_flags = 0;
-	if (qp->qp_type == IB_QPT_UD || qp->qp_type == IB_QPT_GSI) {
-		status = (le32_to_cpu(cqe->flags_status_srcqpn) &
-					OCRDMA_CQE_UD_STATUS_MASK) >>
-					OCRDMA_CQE_UD_STATUS_SHIFT;
-	} else {
-		status = (le32_to_cpu(cqe->flags_status_srcqpn) &
-			     OCRDMA_CQE_STATUS_MASK) >> OCRDMA_CQE_STATUS_SHIFT;
-	}
-
+	status = (qp->qp_type == IB_QPT_UD || qp->qp_type == IB_QPT_GSI)
+		 ? ((le32_to_cpu(cqe->flags_status_srcqpn) &
+		    OCRDMA_CQE_UD_STATUS_MASK) >> OCRDMA_CQE_UD_STATUS_SHIFT)
+		 : ((le32_to_cpu(cqe->flags_status_srcqpn) &
+		    OCRDMA_CQE_STATUS_MASK) >> OCRDMA_CQE_STATUS_SHIFT);
 	if (status == OCRDMA_CQE_SUCCESS) {
 		*polled = true;
 		ocrdma_poll_success_rcqe(qp, cqe, ibwc);
@@ -2885,13 +2880,9 @@ static int ocrdma_poll_hwcq(struct ocrdma_cq *cq, int num_entries,
 		qp = dev->qp_tbl[qpn];
 		BUG_ON(qp == NULL);
 
-		if (is_cqe_for_sq(cqe)) {
-			expand = ocrdma_poll_scqe(qp, cqe, ibwc, &polled,
-						  &stop);
-		} else {
-			expand = ocrdma_poll_rcqe(qp, cqe, ibwc, &polled,
-						  &stop);
-		}
+		expand = is_cqe_for_sq(cqe)
+			 ? ocrdma_poll_scqe(qp, cqe, ibwc, &polled, &stop)
+			 : ocrdma_poll_rcqe(qp, cqe, ibwc, &polled, &stop);
 		if (expand)
 			goto expand_cqe;
 		if (stop)
-- 
2.12.0

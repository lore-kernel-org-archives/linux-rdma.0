From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 05/12] IB/ocrdma: Delete unnecessary braces
Date: Sat, 22 Apr 2017 16:43:14 +0200
Message-ID: <a15fbfbf-e0b3-1f1d-79ba-a5beb922674e@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, trivial@kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Apr 2017 13:54:28 +0200

Do not use curly brackets at some source code places
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---

v2:
Changes were rebased on source files from Linux next-20170421.
These were recombined as requested by Doug Ledford.

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 17 ++++++------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 41 +++++++++++------------------
 2 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index aa32bc9f323d..d5b988b011d1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1092,14 +1092,14 @@ static int ocrdma_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe)
 	if (cqe_status || ext_status) {
 		pr_err("%s() cqe_status=0x%x, ext_status=0x%x,",
 		       __func__, cqe_status, ext_status);
-		if (rsp) {
+		if (rsp)
 			/* This is for embedded cmds. */
 			pr_err("opcode=0x%x, subsystem=0x%x\n",
 			       (rsp->subsys_op & OCRDMA_MBX_RSP_OPCODE_MASK) >>
 				OCRDMA_MBX_RSP_OPCODE_SHIFT,
 				(rsp->subsys_op & OCRDMA_MBX_RSP_SUBSYS_MASK) >>
 				OCRDMA_MBX_RSP_SUBSYS_SHIFT);
-		}
+
 		status = ocrdma_get_mbx_cqe_errno(cqe_status);
 		goto mbx_err;
 	}
@@ -1600,10 +1600,9 @@ void ocrdma_alloc_pd_pool(struct ocrdma_dev *dev)
 		return;
 
 	status = ocrdma_mbx_alloc_pd_range(dev);
-	if (status) {
+	if (status)
 		pr_err("%s(%d) Unable to initialize PD pool, using default.\n",
 			 __func__, dev->id);
-	}
 }
 
 static void ocrdma_free_pd_pool(struct ocrdma_dev *dev)
@@ -2997,11 +2996,10 @@ static int ocrdma_parse_dcbxcfg_rsp(struct ocrdma_dev *dev, int ptype,
 					goto out;
 				}
 			}
-			if (slindx == OCRDMA_MAX_SERVICE_LEVEL_INDEX) {
+			if (slindx == OCRDMA_MAX_SERVICE_LEVEL_INDEX)
 				pr_info("%s ocrdma%d application priority not set for 0x%x protocol\n",
 					dev_name(&dev->nic_info.pdev->dev),
 					dev->id, proto);
-			}
 		}
 	}
 
@@ -3158,16 +3156,17 @@ static int ocrdma_modify_eqd(struct ocrdma_dev *dev, struct ocrdma_eq *eq,
 			     int num)
 {
 	int num_eqs, i = 0;
-	if (num > 8) {
+
+	if (num > 8)
 		while (num) {
 			num_eqs = min(num, 8);
 			ocrdma_mbx_modify_eqd(dev, &eq[i], num_eqs);
 			i += num_eqs;
 			num -= num_eqs;
 		}
-	} else {
+	else
 		ocrdma_mbx_modify_eqd(dev, eq, num);
-	}
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index f12d1d458f28..16f14d4c3e85 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -504,10 +504,10 @@ static int ocrdma_dealloc_ucontext_pd(struct ocrdma_ucontext *uctx)
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
@@ -741,11 +741,10 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *ibdev,
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
@@ -1022,10 +1021,10 @@ int ocrdma_dereg_mr(struct ib_mr *ib_mr)
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
 
@@ -1417,10 +1416,10 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
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
@@ -2835,15 +2834,11 @@ static bool ocrdma_poll_rcqe(struct ocrdma_qp *qp, struct ocrdma_cqe *cqe,
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
@@ -2891,13 +2886,9 @@ static int ocrdma_poll_hwcq(struct ocrdma_cq *cq, int num_entries,
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
2.12.2

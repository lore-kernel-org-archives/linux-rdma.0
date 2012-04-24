From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/4] RDMA/ocrdma: Remove write-only variables
Date: Tue, 24 Apr 2012 16:49:45 -0700
Message-ID: <1335311385-11381-5-git-send-email-roland@kernel.org>
References: <1335311385-11381-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335311385-11381-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    6 ++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    6 ------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 5af30f1..9b204b1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2293,7 +2293,6 @@ int ocrdma_mbx_modify_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
 {
 	int status = -ENOMEM;
 	struct ocrdma_modify_qp *cmd;
-	struct ocrdma_modify_qp_rsp *rsp;
 
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_MODIFY_QP, sizeof(*cmd));
 	if (!cmd)
@@ -2317,7 +2316,7 @@ int ocrdma_mbx_modify_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
 	if (status)
 		goto mbx_err;
-	rsp = (struct ocrdma_modify_qp_rsp *)cmd;
+
 mbx_err:
 	kfree(cmd);
 	return status;
@@ -2327,7 +2326,6 @@ int ocrdma_mbx_destroy_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp)
 {
 	int status = -ENOMEM;
 	struct ocrdma_destroy_qp *cmd;
-	struct ocrdma_destroy_qp_rsp *rsp;
 	struct pci_dev *pdev = dev->nic_info.pdev;
 
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_DELETE_QP, sizeof(*cmd));
@@ -2337,7 +2335,7 @@ int ocrdma_mbx_destroy_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp)
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
 	if (status)
 		goto mbx_err;
-	rsp = (struct ocrdma_destroy_qp_rsp *)cmd;
+
 mbx_err:
 	kfree(cmd);
 	if (qp->sq.va)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index e955f1f..eb55c80 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -625,12 +625,10 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	struct ocrdma_dev *dev;
 	struct ocrdma_mr *mr;
 	struct ocrdma_pd *pd;
-	struct pci_dev *pdev;
 	u32 num_pbes;
 
 	pd = get_ocrdma_pd(ibpd);
 	dev = pd->dev;
-	pdev = dev->nic_info.pdev;
 
 	if (acc & IB_ACCESS_REMOTE_WRITE && !(acc & IB_ACCESS_LOCAL_WRITE))
 		return ERR_PTR(-EINVAL);
@@ -1596,10 +1594,8 @@ int ocrdma_modify_srq(struct ib_srq *ibsrq,
 {
 	int status = 0;
 	struct ocrdma_srq *srq;
-	struct ocrdma_dev *dev;
 
 	srq = get_ocrdma_srq(ibsrq);
-	dev = srq->dev;
 	if (srq_attr_mask & IB_SRQ_MAX_WR)
 		status = -EINVAL;
 	else
@@ -1611,10 +1607,8 @@ int ocrdma_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 {
 	int status;
 	struct ocrdma_srq *srq;
-	struct ocrdma_dev *dev;
 
 	srq = get_ocrdma_srq(ibsrq);
-	dev = srq->dev;
 	status = ocrdma_mbx_query_srq(srq, srq_attr);
 	return status;
 }
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

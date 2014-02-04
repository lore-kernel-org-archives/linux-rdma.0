From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 13/17] RDMA/ocrdma: Support non-embedded mailbox commands
Date: Tue, 4 Feb 2014 11:57:06 +0530
Message-ID: <a774f7b0-ecae-402f-974a-fe93eaee7be5@CMEXHTCAS2.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391495230-28021-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Added a routine to issue non-embedded mailbox commands,
for handling large mailbox request/response data

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |   55 +++++++++++++++++++++++++----
 1 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 6a36476..7ca83eb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -953,7 +953,8 @@ static int ocrdma_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe)
 {
 	int status = 0;
 	u16 cqe_status, ext_status;
-	struct ocrdma_mqe *rsp;
+	struct ocrdma_mqe *rsp_mqe;
+	struct ocrdma_mbx_rsp *rsp = NULL;
 
 	mutex_lock(&dev->mqe_ctx.lock);
 	ocrdma_post_mqe(dev, mqe);
@@ -962,23 +963,61 @@ static int ocrdma_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe)
 		goto mbx_err;
 	cqe_status = dev->mqe_ctx.cqe_status;
 	ext_status = dev->mqe_ctx.ext_status;
-	rsp = ocrdma_get_mqe_rsp(dev);
-	ocrdma_copy_le32_to_cpu(mqe, rsp, (sizeof(*mqe)));
+	rsp_mqe = ocrdma_get_mqe_rsp(dev);
+	ocrdma_copy_le32_to_cpu(mqe, rsp_mqe, (sizeof(*mqe)));
+	if ((mqe->hdr.spcl_sge_cnt_emb & OCRDMA_MQE_HDR_EMB_MASK) >>
+				OCRDMA_MQE_HDR_EMB_SHIFT)
+		rsp = &mqe->u.rsp;
+
 	if (cqe_status || ext_status) {
-		pr_err("%s() opcode=0x%x, cqe_status=0x%x, ext_status=0x%x\n",
-		       __func__,
-		     (rsp->u.rsp.subsys_op & OCRDMA_MBX_RSP_OPCODE_MASK) >>
-		     OCRDMA_MBX_RSP_OPCODE_SHIFT, cqe_status, ext_status);
+		pr_err("%s() cqe_status=0x%x, ext_status=0x%x,",
+		       __func__, cqe_status, ext_status);
+		if (rsp) {
+			/* This is for embedded cmds. */
+			pr_err("opcode=0x%x, subsystem=0x%x\n",
+			       (rsp->subsys_op & OCRDMA_MBX_RSP_OPCODE_MASK) >>
+				OCRDMA_MBX_RSP_OPCODE_SHIFT,
+				(rsp->subsys_op & OCRDMA_MBX_RSP_SUBSYS_MASK) >>
+				OCRDMA_MBX_RSP_SUBSYS_SHIFT);
+		}
 		status = ocrdma_get_mbx_cqe_errno(cqe_status);
 		goto mbx_err;
 	}
-	if (mqe->u.rsp.status & OCRDMA_MBX_RSP_STATUS_MASK)
+	/* For non embedded, rsp errors are handled in ocrdma_nonemb_mbx_cmd */
+	if (rsp && (mqe->u.rsp.status & OCRDMA_MBX_RSP_STATUS_MASK))
 		status = ocrdma_get_mbx_errno(mqe->u.rsp.status);
 mbx_err:
 	mutex_unlock(&dev->mqe_ctx.lock);
 	return status;
 }
 
+static int ocrdma_nonemb_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe,
+				 void *payload_va)
+{
+	int status = 0;
+	struct ocrdma_mbx_rsp *rsp = payload_va;
+
+	if ((mqe->hdr.spcl_sge_cnt_emb & OCRDMA_MQE_HDR_EMB_MASK) >>
+				OCRDMA_MQE_HDR_EMB_SHIFT)
+		BUG();
+
+	status = ocrdma_mbx_cmd(dev, mqe);
+	if (!status)
+		/* For non embedded, only CQE failures are handled in
+		 * ocrdma_mbx_cmd. We need to check for RSP errors.
+		 */
+		if (rsp->status & OCRDMA_MBX_RSP_STATUS_MASK)
+			status = ocrdma_get_mbx_errno(rsp->status);
+
+	if (status)
+		pr_err("opcode=0x%x, subsystem=0x%x\n",
+		       (rsp->subsys_op & OCRDMA_MBX_RSP_OPCODE_MASK) >>
+			OCRDMA_MBX_RSP_OPCODE_SHIFT,
+			(rsp->subsys_op & OCRDMA_MBX_RSP_SUBSYS_MASK) >>
+			OCRDMA_MBX_RSP_SUBSYS_SHIFT);
+	return status;
+}
+
 static void ocrdma_get_attr(struct ocrdma_dev *dev,
 			      struct ocrdma_dev_attr *attr,
 			      struct ocrdma_mbx_query_config *rsp)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

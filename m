From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH V2 for-4.1 5/9] RDMA/ocrdma: Fix the request length for RDMA_QUERY_QP mailbox command to FW.
Date: Tue, 19 May 2015 11:32:36 +0530
Message-ID: <1432015360-15447-6-git-send-email-selvin.xavier@avagotech.com>
References: <1432015360-15447-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432015360-15447-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

Fix ocrdma_query_qp to pass correct mailbox request length to FW.

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c  | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index da688d7..5636eb6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2412,7 +2412,7 @@ int ocrdma_mbx_query_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
 	struct ocrdma_query_qp *cmd;
 	struct ocrdma_query_qp_rsp *rsp;
 
-	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_QUERY_QP, sizeof(*cmd));
+	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_QUERY_QP, sizeof(*rsp));
 	if (!cmd)
 		return status;
 	cmd->qp_id = qp->id;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index baf9b8a..02ad0ae 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1176,6 +1176,8 @@ struct ocrdma_query_qp_rsp {
 	struct ocrdma_mqe_hdr hdr;
 	struct ocrdma_mbx_rsp rsp;
 	struct ocrdma_qp_params params;
+	u32 dpp_credits_cqid;
+	u32 rbq_id;
 };
 
 enum {
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

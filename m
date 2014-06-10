From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 for-next 01/16] RDMA/ocrdma: Avoid posting DPP requests for RDMA READ
Date: Tue, 10 Jun 2014 19:32:12 +0530
Message-ID: <c02e5c22-33fd-4e90-bfba-428723240b32@CMEXHTCAS1.ad.emulex.com>
References: <1402408947-2074-1-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402408947-2074-1-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Rollback the patch which allows dpp posting of RDMA READ since this path is
not yet stable in FW

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 3bbf201..bce4adf 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2206,7 +2206,8 @@ int ocrdma_mbx_create_qp(struct ocrdma_qp *qp, struct ib_qp_init_attr *attrs,
 				OCRDMA_CREATE_QP_REQ_RQ_CQID_MASK;
 	qp->rq_cq = cq;
 
-	if (pd->dpp_enabled && pd->num_dpp_qp) {
+	if (pd->dpp_enabled && attrs->cap.max_inline_data && pd->num_dpp_qp &&
+	    (attrs->cap.max_inline_data <= dev->attr.max_inline_data)) {
 		ocrdma_set_create_qp_dpp_cmd(cmd, pd, qp, enable_dpp_cq,
 					     dpp_cq_id);
 	}
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

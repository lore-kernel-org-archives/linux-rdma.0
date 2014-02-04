From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 04/17] RDMA/ocrdma: Allow DPP QP creation
Date: Tue, 4 Feb 2014 11:56:57 +0530
Message-ID: <73c19960-396a-435a-aa31-28a76504ff7f@CMEXHTCAS2.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391495230-28021-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow creating DPP QP even if inline-data is not requested. This is an optimization to
lower the latency figures.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 15d1ab1..c25445d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2026,8 +2026,7 @@ int ocrdma_mbx_create_qp(struct ocrdma_qp *qp, struct ib_qp_init_attr *attrs,
 				OCRDMA_CREATE_QP_REQ_RQ_CQID_MASK;
 	qp->rq_cq = cq;
 
-	if (pd->dpp_enabled && attrs->cap.max_inline_data && pd->num_dpp_qp &&
-	    (attrs->cap.max_inline_data <= dev->attr.max_inline_data)) {
+	if (pd->dpp_enabled && pd->num_dpp_qp) {
 		ocrdma_set_create_qp_dpp_cmd(cmd, pd, qp, enable_dpp_cq,
 					     dpp_cq_id);
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

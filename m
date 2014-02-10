From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: fix traffic class shift
Date: Mon, 10 Feb 2014 13:48:58 +0530
Message-ID: <8b417e9b-fb15-4585-aba3-e9be06b7b12a@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use correct value for obtaining traffic class from device
response for Query QP request.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 7686dce..998f0de 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1415,7 +1415,7 @@ int ocrdma_query_qp(struct ib_qp *ibqp,
 					  OCRDMA_QP_PARAMS_HOP_LMT_MASK) >>
 						OCRDMA_QP_PARAMS_HOP_LMT_SHIFT;
 	qp_attr->ah_attr.grh.traffic_class = (params.tclass_sq_psn &
-					      OCRDMA_QP_PARAMS_SQ_PSN_MASK) >>
+					      OCRDMA_QP_PARAMS_TCLASS_MASK) >>
 						OCRDMA_QP_PARAMS_TCLASS_SHIFT;
 
 	qp_attr->ah_attr.ah_flags = IB_AH_GRH;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

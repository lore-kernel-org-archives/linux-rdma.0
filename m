From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 for-next 08/16] RDMA/ocrdma: Avoid reporting wrong completions in case of error CQEs
Date: Tue, 10 Jun 2014 19:32:19 +0530
Message-ID: <bbae055f-6318-495a-87af-fb026b1fcee1@CMEXHTCAS1.ad.emulex.com>
References: <1402408947-2074-1-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-2-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-3-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-4-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-5-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-6-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-7-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-8-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402408947-2074-8-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During cable pull test with a mount over nfs rdma, driver was reporting
error completions when there was no pending requests in the SQ and RQ.
This was triggering a host crash because of reporting wrong work req id.
Avoid this crash by adding a check for SQ and RQ empty condition and
prevent reporting completions if queues are empty.

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 0d7d808..2b68235 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2489,6 +2489,11 @@ static bool ocrdma_poll_err_scqe(struct ocrdma_qp *qp,
 			*stop = true;
 			expand = false;
 		}
+	} else if (is_hw_sq_empty(qp)) {
+		/* Do nothing */
+		expand = false;
+		*polled = false;
+		*stop = false;
 	} else {
 		*polled = true;
 		expand = ocrdma_update_err_scqe(ibwc, cqe, qp, status);
@@ -2594,6 +2599,11 @@ static bool ocrdma_poll_err_rcqe(struct ocrdma_qp *qp, struct ocrdma_cqe *cqe,
 			*stop = true;
 			expand = false;
 		}
+	} else if (is_hw_rq_empty(qp)) {
+		/* Do nothing */
+		expand = false;
+		*polled = false;
+		*stop = false;
 	} else {
 		*polled = true;
 		expand = ocrdma_update_err_rcqe(ibwc, cqe, qp, status);
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

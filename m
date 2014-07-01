From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [for-next 3/4] RDMA/libocrdma: stop polling when SQ/RQ is empty
Date: Tue, 1 Jul 2014 11:24:04 +0530
Message-ID: <25d7e82e-650e-4e10-8048-b310ffcfeaa6@CMEXHTCAS1.ad.emulex.com>
References: <1404194045-26900-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404194045-26900-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

The cq polling logic was hitting an infinite loop while generating
flush completions for a torn down QP. This patch adds a check in
flush completion logic to detect SQ/RQ empty condition and stop
polling loop.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_verbs.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index a5b7252..edff8b6 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -1739,6 +1739,11 @@ static int ocrdma_poll_err_scqe(struct ocrdma_qp *qp,
 			*stop = 1;
 			expand = 0;
 		}
+	} else if (is_hw_sq_empty(qp)) {
+		/* Do nothing */
+		expand = 0;
+		*polled = 0;
+		*stop = 0;
 	} else {
 		*polled = 1;
 		expand = ocrdma_update_err_scqe(ibwc, cqe, qp, status);
@@ -1848,6 +1853,11 @@ static int ocrdma_poll_err_rcqe(struct ocrdma_qp *qp, struct ocrdma_cqe *cqe,
 			*stop = 1;
 			expand = 0;
 		}
+	} else if (is_hw_rq_empty(qp)) {
+		/* Do nothing */
+		expand = 0;
+		*polled = 0;
+		*stop = 0;
 	} else {
 		*polled = 1;
 		expand = ocrdma_update_err_rcqe(ibwc, cqe, qp, status);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

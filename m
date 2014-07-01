From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [for-next 2/4] RDMA/libocrdma: do not allow RDMA on UD QP
Date: Tue, 1 Jul 2014 11:24:03 +0530
Message-ID: <0de644e0-1c42-4f35-a32b-507c11df810e@CMEXHTCAS1.ad.emulex.com>
References: <1404194045-26900-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404194045-26900-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As per IB compilance it is not allowed to post RDMA operations
on a UD QP. This patch is adding a compilance check and if any
violation is detected -EINVAL is returned.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_verbs.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index 0f138cf..a5b7252 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -1395,6 +1395,14 @@ int ocrdma_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 	}
 
 	while (wr) {
+
+		if (qp->qp_type == IBV_QPT_UD && (wr->opcode != IBV_WR_SEND &&
+		    wr->opcode != IBV_WR_SEND_WITH_IMM)) {
+			*bad_wr = wr;
+			status = -EINVAL;
+			break;
+		}
+
 		if (ocrdma_hwq_free_cnt(&qp->sq) == 0 ||
 		    wr->num_sge > qp->sq.max_sges) {
 			*bad_wr = wr;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

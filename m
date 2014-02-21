From: <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] RDMA/libocrdma: Allow RDMA-READ posted on DPP
Date: Fri, 21 Feb 2014 11:01:42 +0530
Message-ID: <1392960704-10871-2-git-send-email-devesh.sharma@emulex.com>
References: <1392960704-10871-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392960704-10871-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

RDMA-READs can be posted on DPP QP to achive better latancies.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_verbs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index aedb578..acf460f 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -1441,8 +1441,10 @@ int ocrdma_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 		else
 			qp->wqe_wr_id_tbl[qp->sq.head].signaled = 0;
 
-		if (qp->dpp_enabled && (wr->send_flags & IBV_SEND_INLINE))
+		if (qp->dpp_enabled && (wr->send_flags & IBV_SEND_INLINE
+			|| wr->opcode == IBV_WR_RDMA_READ)) {
 			ocrdma_post_dpp_wqe(qp, hdr);
+		}
 
 		ocrdma_swap_cpu_to_le(hdr, ((hdr->cw >> OCRDMA_WQE_SIZE_SHIFT) &
 				      OCRDMA_WQE_SIZE_MASK) *
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

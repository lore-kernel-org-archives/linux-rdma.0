From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 11/17] ocrdma: use NULL instead of 0 for NULL pointers
Date: Thu, 13 Oct 2016 21:56:10 +0200
Message-ID: <1476388576-22863-12-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/ocrdma/ocrdma_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/providers/ocrdma/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
index c5dd74b..7e066dc 100644
--- a/providers/ocrdma/ocrdma_verbs.c
+++ b/providers/ocrdma/ocrdma_verbs.c
@@ -455,7 +455,7 @@ int ocrdma_destroy_srq(struct ibv_srq *ibsrq)
 		free(srq->rqe_wr_id_tbl);
 	if (srq->db_va) {
 		munmap((void *)srq->db_va, srq->db_size);
-		srq->db_va = 0;
+		srq->db_va = NULL;
 	}
 	if (srq->rq.va) {
 		munmap(srq->rq.va, srq->rq.len);
@@ -591,7 +591,7 @@ struct ibv_qp *ocrdma_create_qp(struct ibv_pd *pd,
 	} else {
 		if (qp->dpp_cq) {
 			ocrdma_destroy_cq(&qp->dpp_cq->ibv_cq);
-			qp->dpp_cq = 0;
+			qp->dpp_cq = NULL;
 		}
 	}
 	qp->state = OCRDMA_QPS_RST;
@@ -1789,7 +1789,7 @@ static void ocrdma_update_free_srq_cqe(struct ibv_wc *ibwc,
 				       struct ocrdma_cqe *cqe,
 				       struct ocrdma_qp *qp)
 {
-	struct ocrdma_srq *srq = 0;
+	struct ocrdma_srq *srq = NULL;
 	uint32_t wqe_idx;
 
 	srq = get_ocrdma_srq(qp->ibv_qp.srq);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

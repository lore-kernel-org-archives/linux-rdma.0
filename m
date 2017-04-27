From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core 3/4] libqedr: fix comments and alignment in verbs file
Date: Thu, 27 Apr 2017 09:11:07 +0300
Message-ID: <1493273468-23774-4-git-send-email-Ram.Amrani@cavium.com>
References: <1493273468-23774-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493273468-23774-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 7419540..375664b 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -349,7 +349,7 @@ static inline int qelr_create_qp_buffers_sq(struct qelr_devctx *cxt,
 	rc = qelr_chain_alloc(&qp->sq.chain, chain_size, cxt->kernel_page_size,
 			      QELR_SQE_ELEMENT_SIZE);
 	if (rc)
-		DP_ERR(cxt->dbg_fp, "create qp: failed to map SQ, got %d", rc);
+		DP_ERR(cxt->dbg_fp, "create qp: failed to map SQ chain, got %d", rc);
 
 	qp->sq.max_wr = max_send_wr;
 	qp->sq.max_sges = cxt->sges_per_send_wr;
@@ -376,7 +376,7 @@ static inline int qelr_create_qp_buffers_rq(struct qelr_devctx *cxt,
 	rc = qelr_chain_alloc(&qp->rq.chain, chain_size, cxt->kernel_page_size,
 			      QELR_RQE_ELEMENT_SIZE);
 	if (rc)
-		DP_ERR(cxt->dbg_fp, "create qp: failed to map RQ, got %d", rc);
+		DP_ERR(cxt->dbg_fp, "create qp: failed to map RQ chain, got %d", rc);
 
 	qp->rq.max_wr = max_recv_wr;
 	qp->rq.max_sges = cxt->sges_per_recv_wr;
@@ -419,7 +419,7 @@ static inline int qelr_configure_qp_sq(struct qelr_devctx *cxt,
 	qp->wqe_wr_id = calloc(qp->sq.max_wr, sizeof(*qp->wqe_wr_id));
 	if (!qp->wqe_wr_id) {
 		DP_ERR(cxt->dbg_fp,
-		       "create qp: failed shdow SQ memory allocation\n");
+		       "create qp: failed shadow SQ memory allocation\n");
 		return -ENOMEM;
 	}
 	return 0;
@@ -441,7 +441,7 @@ static inline int qelr_configure_qp_rq(struct qelr_devctx *cxt,
 	qp->rqe_wr_id = calloc(qp->rq.max_wr, sizeof(*qp->rqe_wr_id));
 	if (!qp->rqe_wr_id) {
 		DP_ERR(cxt->dbg_fp,
-		       "create qp: failed shdow RQ memory allocation\n");
+		       "create qp: failed shadow RQ memory allocation\n");
 		return -ENOMEM;
 	}
 
@@ -1600,13 +1600,13 @@ static int qelr_poll_cq_req(struct qelr_qp *qp, struct qelr_cq *cq,
 			enum ibv_wc_status wc_status;
 
 			switch (req->status) {
-			case	RDMA_CQE_REQ_STS_BAD_RESPONSE_ERR:
+			case    RDMA_CQE_REQ_STS_BAD_RESPONSE_ERR:
 				DP_ERR(cxt->dbg_fp,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_BAD_RESPONSE_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_BAD_RESP_ERR;
 				break;
-			case	RDMA_CQE_REQ_STS_LOCAL_LENGTH_ERR:
+			case    RDMA_CQE_REQ_STS_LOCAL_LENGTH_ERR:
 				DP_ERR(cxt->dbg_fp,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_LOCAL_LENGTH_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
@@ -1663,7 +1663,7 @@ static int qelr_poll_cq_req(struct qelr_qp *qp, struct qelr_cq *cq,
 			default:
 				DP_ERR(cxt->dbg_fp,
 				       "IBV_WC_GENERAL_ERR. QP icid=0x%x\n",
-					qp->sq.icid);
+				       qp->sq.icid);
 				wc_status = IBV_WC_GENERAL_ERR;
 			}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

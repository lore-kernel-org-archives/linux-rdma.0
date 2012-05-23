From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: corrected queue free count math
Date: Wed, 23 May 2012 21:02:07 +0530
Message-ID: <40162dc4-2ed3-413b-93bb-34971d08d11c@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mahesh.Vardhamanaiah-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Corrected queue free count math for SQ, RQ for all hardware type.
Updated user-kernel abi interface.

Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h   |    5 +----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    7 -------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    5 -----
 4 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 85a69c9..037f5ce 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -231,7 +231,6 @@ struct ocrdma_qp_hwq_info {
 	u32 entry_size;
 	u32 max_cnt;
 	u32 max_wqe_idx;
-	u32 free_delta;
 	u16 dbid;		/* qid, where to ring the doorbell. */
 	u32 len;
 	dma_addr_t pa;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
index a411a4e..517ab20 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
@@ -101,8 +101,6 @@ struct ocrdma_create_qp_uresp {
 	u32 rsvd1;
 	u32 num_wqe_allocated;
 	u32 num_rqe_allocated;
-	u32 free_wqe_delta;
-	u32 free_rqe_delta;
 	u32 db_sq_offset;
 	u32 db_rq_offset;
 	u32 db_shift;
@@ -126,8 +124,7 @@ struct ocrdma_create_srq_uresp {
 	u32 db_rq_offset;
 	u32 db_shift;
 
-	u32 free_rqe_delta;
-	u32 rsvd2;
+	u64 rsvd2;
 	u64 rsvd3;
 } __packed;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 9b204b1..f26314f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1990,19 +1990,12 @@ static void ocrdma_get_create_qp_rsp(struct ocrdma_create_qp_rsp *rsp,
 	max_wqe_allocated = 1 << max_wqe_allocated;
 	max_rqe_allocated = 1 << ((u16)rsp->max_wqe_rqe);
 
-	if (qp->dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
-		qp->sq.free_delta = 0;
-		qp->rq.free_delta = 1;
-	} else
-		qp->sq.free_delta = 1;
-
 	qp->sq.max_cnt = max_wqe_allocated;
 	qp->sq.max_wqe_idx = max_wqe_allocated - 1;
 
 	if (!attrs->srq) {
 		qp->rq.max_cnt = max_rqe_allocated;
 		qp->rq.max_wqe_idx = max_rqe_allocated - 1;
-		qp->rq.free_delta = 1;
 	}
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index e9f74d1..d16d172 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -940,8 +940,6 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
 		uresp.db_rq_offset = OCRDMA_DB_RQ_OFFSET;
 		uresp.db_shift = 16;
 	}
-	uresp.free_wqe_delta = qp->sq.free_delta;
-	uresp.free_rqe_delta = qp->rq.free_delta;
 
 	if (qp->dpp_enabled) {
 		uresp.dpp_credit = dpp_credit_lmt;
@@ -1307,8 +1305,6 @@ static int ocrdma_hwq_free_cnt(struct ocrdma_qp_hwq_info *q)
 		free_cnt = (q->max_cnt - q->head) + q->tail;
 	else
 		free_cnt = q->tail - q->head;
-	if (q->free_delta)
-		free_cnt -= q->free_delta;
 	return free_cnt;
 }
 
@@ -1501,7 +1497,6 @@ static int ocrdma_copy_srq_uresp(struct ocrdma_srq *srq, struct ib_udata *udata)
 	    (srq->pd->id * srq->dev->nic_info.db_page_size);
 	uresp.db_page_size = srq->dev->nic_info.db_page_size;
 	uresp.num_rqe_allocated = srq->rq.max_cnt;
-	uresp.free_rqe_delta = 1;
 	if (srq->dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
 		uresp.db_rq_offset = OCRDMA_DB_GEN2_RQ1_OFFSET;
 		uresp.db_shift = 24;
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

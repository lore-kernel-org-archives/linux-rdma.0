From: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband: hw: ocrdma: Replace BUG() with BUG_ON()
Date: Sat, 24 Dec 2016 21:50:06 +0530
Message-ID: <1482596406-7180-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org
Cc: devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Replace BUG() with BUG_ON() using coccinelle

Signed-off-by: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 6af44f8..e06ad72 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1170,8 +1170,7 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
 
 	dev->cq_tbl[cq->id] = NULL;
 	indx = ocrdma_get_eq_table_index(dev, cq->eqn);
-	if (indx == -EINVAL)
-		BUG();
+	BUG_ON(indx == -EINVAL);
 
 	eq = &dev->eq_tbl[indx];
 	irq = ocrdma_get_irq(dev, eq);
@@ -1741,8 +1740,7 @@ static void ocrdma_discard_cqes(struct ocrdma_qp *qp, struct ocrdma_cq *cq)
 				wqe_idx = (le32_to_cpu(cqe->rq.buftag_qpn) >>
 					OCRDMA_CQE_BUFTAG_SHIFT) &
 					qp->srq->rq.max_wqe_idx;
-				if (wqe_idx < 1)
-					BUG();
+				BUG_ON(wqe_idx < 1);
 				spin_lock_irqsave(&qp->srq->q_lock, flags);
 				ocrdma_hwq_inc_tail(&qp->srq->rq);
 				ocrdma_srq_toggle_bit(qp->srq, wqe_idx - 1);
@@ -2388,15 +2386,13 @@ static int ocrdma_srq_get_idx(struct ocrdma_srq *srq)
 		if (srq->idx_bit_fields[row]) {
 			indx = ffs(srq->idx_bit_fields[row]);
 			indx = (row * 32) + (indx - 1);
-			if (indx >= srq->rq.max_cnt)
-				BUG();
+			BUG_ON(indx >= srq->rq.max_cnt);
 			ocrdma_srq_toggle_bit(srq, indx);
 			break;
 		}
 	}
 
-	if (row == srq->bit_fields_len)
-		BUG();
+	BUG_ON(row == srq->bit_fields_len);
 	return indx + 1; /* Use from index 1 */
 }
 
@@ -2754,8 +2750,7 @@ static void ocrdma_update_free_srq_cqe(struct ib_wc *ibwc,
 	srq = get_ocrdma_srq(qp->ibqp.srq);
 	wqe_idx = (le32_to_cpu(cqe->rq.buftag_qpn) >>
 		OCRDMA_CQE_BUFTAG_SHIFT) & srq->rq.max_wqe_idx;
-	if (wqe_idx < 1)
-		BUG();
+	BUG_ON(wqe_idx < 1);
 
 	ibwc->wr_id = srq->rqe_wr_id_tbl[wqe_idx];
 	spin_lock_irqsave(&srq->q_lock, flags);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

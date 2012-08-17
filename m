From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Fixed cqe expansion of unsignaled wqe
Date: Fri, 17 Aug 2012 20:15:33 +0530
Message-ID: <1a7e463d-c208-4695-beb8-1a6b3100c3d1@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixed cqe expansion of unsignaled wqe - stop expanding the cqe
when wqe index of the completed cqe matches with last pending wqe (tail)
in the queue.

Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index cb5b7f7..b29a424 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2219,7 +2219,6 @@ static bool ocrdma_poll_success_scqe(struct ocrdma_qp *qp,
 	u32 wqe_idx;
 
 	if (!qp->wqe_wr_id_tbl[tail].signaled) {
-		expand = true;	/* CQE cannot be consumed yet */
 		*polled = false;    /* WC cannot be consumed yet */
 	} else {
 		ibwc->status = IB_WC_SUCCESS;
@@ -2227,10 +2226,11 @@ static bool ocrdma_poll_success_scqe(struct ocrdma_qp *qp,
 		ibwc->qp = &qp->ibqp;
 		ocrdma_update_wc(qp, ibwc, tail);
 		*polled = true;
-		wqe_idx = le32_to_cpu(cqe->wq.wqeidx) &	OCRDMA_CQE_WQEIDX_MASK;
-		if (tail != wqe_idx)
-			expand = true; /* Coalesced CQE can't be consumed yet */
 	}
+	wqe_idx = le32_to_cpu(cqe->wq.wqeidx) &	OCRDMA_CQE_WQEIDX_MASK;
+	if (tail != wqe_idx)
+		expand = true; /* Coalesced CQE can't be consumed yet */
+
 	ocrdma_hwq_inc_tail(&qp->sq);
 	return expand;
 }
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

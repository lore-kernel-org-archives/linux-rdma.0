From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 13/14] vmw_pvrdma: Update to use new udma write barriers
Date: Thu, 16 Feb 2017 12:23:08 -0700
Message-ID: <1487272989-8215-14-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For some reason write barriers were placed after the writes, move
them before.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/vmw_pvrdma/cq.c | 6 +++---
 providers/vmw_pvrdma/qp.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/providers/vmw_pvrdma/cq.c b/providers/vmw_pvrdma/cq.c
index f24d80742678bd..701f0522f7b0dd 100644
--- a/providers/vmw_pvrdma/cq.c
+++ b/providers/vmw_pvrdma/cq.c
@@ -109,7 +109,7 @@ retry:
 	if (!cqe)
 		return CQ_EMPTY;
 
-	rmb();
+	udma_from_device_barrier();
 
 	if (ctx->qp_tbl[cqe->qp & 0xFFFF])
 		*cur_qp = (struct pvrdma_qp *)ctx->qp_tbl[cqe->qp & 0xFFFF];
@@ -184,11 +184,11 @@ void pvrdma_cq_clean_int(struct pvrdma_cq *cq, uint32_t qpn)
 			if (tail < 0)
 				tail = cq->cqe_cnt - 1;
 			curr_cqe = get_cqe(cq, curr);
-			rmb();
+			udma_from_device_barrier();
 			if ((curr_cqe->qp & 0xFFFF) != qpn) {
 				if (curr != tail) {
 					cqe = get_cqe(cq, tail);
-					rmb();
+					udma_from_device_barrier();
 					*cqe = *curr_cqe;
 				}
 				tail--;
diff --git a/providers/vmw_pvrdma/qp.c b/providers/vmw_pvrdma/qp.c
index d2e2189fda6de4..116063ee07c83b 100644
--- a/providers/vmw_pvrdma/qp.c
+++ b/providers/vmw_pvrdma/qp.c
@@ -404,11 +404,10 @@ int pvrdma_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			sge++;
 		}
 
+		udma_to_device_barrier();
 		pvrdma_idx_ring_inc(&(qp->sq.ring_state->prod_tail),
 				    qp->sq.wqe_cnt);
 
-		wmb();
-
 		qp->sq.wrid[ind] = wr->wr_id;
 		++ind;
 		if (ind >= qp->sq.wqe_cnt)
@@ -416,11 +415,12 @@ int pvrdma_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	}
 
 out:
-	if (nreq)
+	if (nreq) {
+		udma_to_device_barrier();
 		pvrdma_write_uar_qp(ctx->uar,
 				    PVRDMA_UAR_QP_SEND | ibqp->qp_num);
+	}
 
-	wmb();
 	pthread_spin_unlock(&qp->sq.lock);
 
 	return ret;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 05/14] hns: Update to use new udma write barriers
Date: Thu, 16 Feb 2017 12:23:00 -0700
Message-ID: <1487272989-8215-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move the barriers to directly before the doorbell MMIO write for
clarity.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/hns/hns_roce_u_hw_v1.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/providers/hns/hns_roce_u_hw_v1.c b/providers/hns/hns_roce_u_hw_v1.c
index 263502d4a85610..0de94e1fabd3d9 100644
--- a/providers/hns/hns_roce_u_hw_v1.c
+++ b/providers/hns/hns_roce_u_hw_v1.c
@@ -67,6 +67,8 @@ static void hns_roce_update_rq_head(struct hns_roce_context *ctx,
 	roce_set_field(rq_db.u32_8, RQ_DB_U32_8_CMD_M, RQ_DB_U32_8_CMD_S, 1);
 	roce_set_bit(rq_db.u32_8, RQ_DB_U32_8_HW_SYNC_S, 1);
 
+	udma_to_device_barrier();
+
 	hns_roce_write64((uint32_t *)&rq_db, ctx, ROCEE_DB_OTHERS_L_0_REG);
 }
 
@@ -87,6 +89,8 @@ static void hns_roce_update_sq_head(struct hns_roce_context *ctx,
 	roce_set_field(sq_db.u32_8, SQ_DB_U32_8_QPN_M, SQ_DB_U32_8_QPN_S, qpn);
 	roce_set_bit(sq_db.u32_8, SQ_DB_U32_8_HW_SYNC, 1);
 
+	udma_to_device_barrier();
+
 	hns_roce_write64((uint32_t *)&sq_db, ctx, ROCEE_DB_SQ_L_0_REG);
 }
 
@@ -261,7 +265,7 @@ static int hns_roce_v1_poll_one(struct hns_roce_cq *cq,
 	/* Get the next cqe, CI will be added gradually */
 	++cq->cons_index;
 
-	rmb();
+	udma_from_device_barrier();
 
 	qpn = roce_get_field(cqe->cqe_byte_16, CQE_BYTE_16_LOCAL_QPN_M,
 			     CQE_BYTE_16_LOCAL_QPN_S);
@@ -408,7 +412,7 @@ static int hns_roce_u_v1_poll_cq(struct ibv_cq *ibvcq, int ne,
 		if (dev->hw_version == HNS_ROCE_HW_VER1) {
 			*cq->set_ci_db = (unsigned short)(cq->cons_index &
 					 ((cq->cq_depth << 1) - 1));
-			mb();
+			mmio_ordered_writes_hack();
 		}
 
 		hns_roce_update_cq_cons_index(ctx, cq);
@@ -581,7 +585,6 @@ out:
 	/* Set DB return */
 	if (likely(nreq)) {
 		qp->sq.head += nreq;
-		wmb();
 
 		hns_roce_update_sq_head(ctx, qp->ibv_qp.qp_num,
 				qp->port_num - 1, qp->sl,
@@ -625,7 +628,7 @@ static void __hns_roce_v1_cq_clean(struct hns_roce_cq *cq, uint32_t qpn,
 
 	if (nfreed) {
 		cq->cons_index += nfreed;
-		wmb();
+		udma_to_device_barrier();
 		hns_roce_update_cq_cons_index(ctx, cq);
 	}
 }
@@ -816,8 +819,6 @@ out:
 	if (nreq) {
 		qp->rq.head += nreq;
 
-		wmb();
-
 		hns_roce_update_rq_head(ctx, qp->ibv_qp.qp_num,
 				    qp->rq.head & ((qp->rq.wqe_cnt << 1) - 1));
 	}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

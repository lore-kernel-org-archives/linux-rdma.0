From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/8] mlx5: Avoid sparse complaints about !!
Date: Wed, 12 Jul 2017 15:17:38 -0600
Message-ID: <1499894262-10761-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499894262-10761-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sparse says:
 warning: dubious: !x & y

Unclear why sparse thinks this is bad, but casting to C99 bool is the
same as !! and much easier to read.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx5/cq.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 500116133c1f9e..9a8d958a9ced68 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -206,11 +206,12 @@ static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 		if (likely(cur_rsc->type == MLX5_RSC_TYPE_QP)) {
 			wq = &qp->rq;
 			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
-				wc->wc_flags |= (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
-						 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
-						(get_cqe_l3_hdr_type(cqe) ==
-						MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
-						IBV_WC_IP_CSUM_OK_SHIFT;
+				wc->wc_flags |=
+				    ((bool)(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
+				     (bool)(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
+				     (get_cqe_l3_hdr_type(cqe) ==
+				      MLX5_CQE_L3_HDR_TYPE_IPV4))
+				    << IBV_WC_IP_CSUM_OK_SHIFT;
 		} else {
 			wq = &(rsc_to_mrwq(cur_rsc)->rq);
 		}
@@ -1105,11 +1106,11 @@ static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 	int wc_flags = 0;
 
 	if (cq->flags & MLX5_CQ_FLAGS_RX_CSUM_VALID)
-		wc_flags = (!!(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
-				 !!(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
-				 (get_cqe_l3_hdr_type(cq->cqe64) ==
-				  MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
-				IBV_WC_IP_CSUM_OK_SHIFT;
+		wc_flags = ((bool)(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
+			    (bool)(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
+			    (get_cqe_l3_hdr_type(cq->cqe64) ==
+			     MLX5_CQE_L3_HDR_TYPE_IPV4))
+			   << IBV_WC_IP_CSUM_OK_SHIFT;
 
 	switch (mlx5dv_get_cqe_opcode(cq->cqe64)) {
 	case MLX5_CQE_RESP_WR_IMM:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

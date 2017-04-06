From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/6] mlx4: Fix incorrect masking of g_mlpath_rqpn
Date: Thu,  6 Apr 2017 16:42:24 -0600
Message-ID: <1491518545-14746-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1491518545-14746-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491518545-14746-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Two other places do this math and consensus is that MLX4_CQE_QPN_MASK
is in host endian, so this math is wrong. Found by sparse.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx4/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 01d103d983eb4d..844e4da1305c63 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -739,7 +739,7 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 		cqe = get_cqe(cq, prod_index & cq->ibv_cq.cqe);
 		cqe += cqe_inc;
 		if (srq && srq->ext_srq &&
-		    be32toh(cqe->g_mlpath_rqpn & MLX4_CQE_QPN_MASK) == srq->verbs_srq.srq_num &&
+		    (be32toh(cqe->g_mlpath_rqpn) & MLX4_CQE_QPN_MASK) == srq->verbs_srq.srq_num &&
 		    !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK)) {
 			mlx4_free_srq_wqe(srq, be16toh(cqe->wqe_index));
 			++nfreed;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

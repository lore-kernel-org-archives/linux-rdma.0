From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 4/8] mlx5: Avoid sparse complaints about !!
Date: Thu, 20 Jul 2017 11:36:12 -0600
Message-ID: <20170720173612.GA11767@obsidianresearch.com>
References: <1500570064-11712-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1500570064-11712-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <1500571411.3181.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1500571411.3181.4.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 20, 2017 at 05:23:32PM +0000, Bart Van Assche wrote:
> Since patches 4 and 5 touch the same code: shouldn't these two patches
> be squashed into a single patch?

Oops, yes, that is a rebasing error on my part. Thanks for noticing

Here is the corrected patch:

>From f4d0eb7dd6ebbdbfababd5cd42f7bbd8fb935978 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Fri, 7 Apr 2017 14:34:45 -0600
Subject: [PATCH] mlx5: Avoid sparse complaints about !!

Sparse says:
 warning: dubious: !x & y

Unclear why sparse thinks this is bad. Hoist this code into an inline
and write the test as == instead of !!.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx5/cq.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 500116133c1f9e..a5167477db1a20 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -182,6 +182,15 @@ static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *c
 	return err;
 }
 
+/* Returns IBV_WC_IP_CSUM_OK or 0 */
+static inline int get_csum_ok(struct mlx5_cqe64 *cqe)
+{
+	return (((cqe->hds_ip_ext & (MLX5_CQE_L4_OK | MLX5_CQE_L3_OK)) ==
+		 (MLX5_CQE_L4_OK | MLX5_CQE_L3_OK)) &
+		(get_cqe_l3_hdr_type(cqe) == MLX5_CQE_L3_HDR_TYPE_IPV4))
+	       << IBV_WC_IP_CSUM_OK_SHIFT;
+}
+
 static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 				   struct mlx5_resource *cur_rsc, struct mlx5_srq *srq)
 {
@@ -206,11 +215,7 @@ static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 		if (likely(cur_rsc->type == MLX5_RSC_TYPE_QP)) {
 			wq = &qp->rq;
 			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
-				wc->wc_flags |= (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
-						 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
-						(get_cqe_l3_hdr_type(cqe) ==
-						MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
-						IBV_WC_IP_CSUM_OK_SHIFT;
+				wc->wc_flags |= get_csum_ok(cqe);
 		} else {
 			wq = &(rsc_to_mrwq(cur_rsc)->rq);
 		}
@@ -1105,11 +1110,7 @@ static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 	int wc_flags = 0;
 
 	if (cq->flags & MLX5_CQ_FLAGS_RX_CSUM_VALID)
-		wc_flags = (!!(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
-				 !!(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
-				 (get_cqe_l3_hdr_type(cq->cqe64) ==
-				  MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
-				IBV_WC_IP_CSUM_OK_SHIFT;
+		wc_flags = get_csum_ok(cq->cqe64);
 
 	switch (mlx5dv_get_cqe_opcode(cq->cqe64)) {
 	case MLX5_CQE_RESP_WR_IMM:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

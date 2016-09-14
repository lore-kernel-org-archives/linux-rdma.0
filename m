From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 09/28] mlx5: Fix gcc 6.4 uninitialized variable warning
Date: Wed, 14 Sep 2016 10:37:16 -0600
Message-ID: <20160914163716.GB16014@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-10-git-send-email-jgunthorpe@obsidianresearch.com>
 <0ba444b7-6af4-72f3-d3d6-c27b73421679@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0ba444b7-6af4-72f3-d3d6-c27b73421679-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 14, 2016 at 06:39:10PM +0300, Yishai Hadas wrote:
> On 9/6/2016 12:07 AM, Jason Gunthorpe wrote:
> >gcc 6.4 remarks:
> >
> >../providers/mlx5/cq.c:647:10: warning: 'wc_byte_len' may be used uninitialized in this function [-Wmaybe-uninitialized]
> >    err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
> >           lazy ? wc_byte_len : wc->byte_len);
> >The path is because handle_good_req_lazy does not set its wc_byte_len
> >outputs under certain case conditions.
> 
> wc_byte_len defined as uint32_t uninitialized_var(wc_byte_len) to prevent
> this warning, isn't this macro applicable ?

The macro is not compatible with clang so I've run builds without
it. Turns out we generally don't need it anymore. I'd like to get rid
of it.

I view clang support as very important, since it found a different set
of mistakes :(

Further, it is not approriate to use the macro in a case where the
compiler *is not wrong*

> >Perhaps it is possible that the hardware never produces a completion
> >with opcodes and scatter flags that could trigger this,

> It can't happen, no real functional issue.

Okay, great, in that case you can gain more speed by writing code the
compiler can understand. In this instance we don't need to test for
(cqe64->op_own & MLX5_INLINE_SCATTER_XX) after we have disproven it by
checking for !(MLX5_OPCODE_RDMA_READ,MLX5_OPCODE_ATOMIC_CS,MLX5_OPCODE_ATOMIC_FA)

Here:

>From ac039248746318adfa41933d45495dc74a8eddb6 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Fri, 2 Sep 2016 12:30:15 -0600
Subject: [PATCH] mlx5: Fix gcc 6.4 uninitialized variable warning

gcc 6.4 remarks:

../providers/mlx5/cq.c:647:10: warning: 'wc_byte_len' may be used uninitialized in this function [-Wmaybe-uninitialized]
    err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
           lazy ? wc_byte_len : wc->byte_len);

The path is because handle_good_req_lazy does not set its wc_byte_len
outputs under certain case conditions.

Yishai says it is not possible for the hardware to produce a completion
that follows this path, so restructure the logic to avoid even looking at
the scatter bits if we already determined they cannot be present.

This avoids the warnings and eliminates some branches on a hot path.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libmlx5/src/cq.c | 59 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/libmlx5/src/cq.c b/libmlx5/src/cq.c
index 88097037eea0..91c568e2f4b6 100644
--- a/libmlx5/src/cq.c
+++ b/libmlx5/src/cq.c
@@ -222,23 +222,6 @@ static inline void handle_good_req(struct ibv_wc *wc, struct mlx5_cqe64 *cqe, st
 	}
 }
 
-static inline void handle_good_req_lazy(struct mlx5_cqe64 *cqe, uint32_t *pwc_byte_len,
-					int *umr_opcode, struct mlx5_wq *wq, int idx)
-{
-	switch (ntohl(cqe->sop_drop_qpn) >> 24) {
-	case MLX5_OPCODE_RDMA_READ:
-		*pwc_byte_len  = ntohl(cqe->byte_cnt);
-		break;
-	case MLX5_OPCODE_ATOMIC_CS:
-	case MLX5_OPCODE_ATOMIC_FA:
-		*pwc_byte_len  = 8;
-		break;
-	case MLX5_OPCODE_UMR:
-		*umr_opcode = wq->wr_data[idx];
-		break;
-	}
-}
-
 static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *cqe,
 					struct mlx5_qp *qp, struct mlx5_srq *srq)
 {
@@ -634,7 +617,6 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 	switch (opcode) {
 	case MLX5_CQE_REQ:
 	{
-		uint32_t uninitialized_var(wc_byte_len);
 		mqp = get_req_context(mctx, cur_rsc,
 				      (cqe_ver ? (ntohl(cqe64->srqn_uidx) & 0xffffff) : qpn),
 				      cqe_ver);
@@ -643,17 +625,40 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 		wq = &mqp->sq;
 		wqe_ctr = ntohs(cqe64->wqe_counter);
 		idx = wqe_ctr & (wq->wqe_cnt - 1);
-		if (lazy)
-			handle_good_req_lazy(cqe64, &wc_byte_len, &cq->umr_opcode, wq, idx);
-		else
+		if (lazy) {
+			uint32_t wc_byte_len;
+
+			switch (ntohl(cqe64->sop_drop_qpn) >> 24) {
+			case MLX5_OPCODE_UMR:
+				cq->umr_opcode = wq->wr_data[idx];
+				break;
+
+			case MLX5_OPCODE_RDMA_READ:
+				wc_byte_len = ntohl(cqe64->byte_cnt);
+				goto scatter_out;
+			case MLX5_OPCODE_ATOMIC_CS:
+			case MLX5_OPCODE_ATOMIC_FA:
+				wc_byte_len = 8;
+
+			scatter_out:
+				if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
+					err = mlx5_copy_to_send_wqe(
+					    mqp, wqe_ctr, cqe, wc_byte_len);
+				else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
+					err = mlx5_copy_to_send_wqe(
+					    mqp, wqe_ctr, cqe - 1, wc_byte_len);
+				break;
+			}
+		} else {
 			handle_good_req(wc, cqe64, wq, idx);
 
-		if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
-			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
-						    lazy ? wc_byte_len : wc->byte_len);
-		else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
-			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe - 1,
-						     lazy ? wc_byte_len : wc->byte_len);
+			if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
+				err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
+							    wc->byte_len);
+			else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
+				err = mlx5_copy_to_send_wqe(
+				    mqp, wqe_ctr, cqe - 1, wc->byte_len);
+		}
 
 		if (lazy) {
 			cq->ibv_cq.wr_id = wq->wrid[idx];
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

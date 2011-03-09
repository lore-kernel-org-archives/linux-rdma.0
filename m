From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH/libmlx] Set the ibv_wc.opcode even if the wc is an error wc
Date: Tue, 8 Mar 2011 21:26:13 -0700
Message-ID: <20110309042613.GA21606@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a SQ and a RQ are sharing a CQ then the opcode must be set to
determine if the error WC applies to the SQ or RQ, this is important
for buffer tracking, etc.

Testing shows that the is_send value is correct at this point so if
the chip does not provide an accurate opcode the default statements
will produce IBV_WC_RECV for RQ WC's and IBV_WC_SEND for SQ WC's.

Tested with a UD QP causing 'local length error' on both the RQ
and SQ.

Tested with a RC QP causing 'local length error' on the SQ and RQ,
as well as 'remote invalid request error' and
'Work Request Flushed Error'

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 src/cq.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

Roland: I don't have a PRM to check if this is correct for the chip,
but it is definately in line with what the IBA expects to happen
here. Some basic testing shows it works as expected..

For the RQ case the value of (cqe->owner_sr_opcode &
MLX4_CQE_OPCODE_MASK) is MLX4_CQE_OPCODE_ERROR, the SQ case
doesn't hit the default statement in my tests.

I noticed this while trying to figure out what to do with a 
'local length error' received on a UD RQ which is not specified
to be possible. Since it does not put the RQ into an error state
it just need to be ignored and the buffer recycled, except you can't
tell that it is a RQ local length error or a SQ local length error
without the opcode being set properly...

Same general patch applies to the kernel, and I didn't check other
drivers.

diff --git a/src/cq.c b/src/cq.c
index 8226b6b..c920844 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -253,13 +253,6 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		++wq->tail;
 	}
 
-	if (is_error) {
-		mlx4_handle_error_cqe((struct mlx4_err_cqe *) cqe, wc);
-		return CQ_OK;
-	}
-
-	wc->status = IBV_WC_SUCCESS;
-
 	if (is_send) {
 		wc->wc_flags = 0;
 		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
@@ -311,6 +304,10 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 			wc->wc_flags = IBV_WC_WITH_IMM;
 			wc->imm_data = cqe->immed_rss_invalid;
 			break;
+		default:
+			/* assume it's a recv completion */
+			wc->opcode    = IBV_WC_RECV;
+			break;
 		}
 
 		wc->slid	   = ntohs(cqe->rlid);
@@ -322,6 +319,11 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		wc->pkey_index     = ntohl(cqe->immed_rss_invalid) & 0x7f;
 	}
 
+	if (is_error)
+		mlx4_handle_error_cqe((struct mlx4_err_cqe *) cqe, wc);
+	else
+		wc->status = IBV_WC_SUCCESS;
+
 	return CQ_OK;
 }
 
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

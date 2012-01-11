From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Send with immediate data completion
Date: Wed, 11 Jan 2012 21:59:24 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373256758E5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From my interpretation of the spec, it looks like a bug and the immediate data
> should be available in the send wc, since it's not explicitly excluded.  I'll
> verify that this is the intent with the IBTA.

I'm still waiting on feedback from the IBTA, but they are looking into the matter.
 
> I haven't traced through the library and driver code to see if mlx4 driver can
> report it.  I'll see if I can do this within the next couple of days.

The following patch to libmlx4 added the immediate data to the send work completion for me.  A similar change looks like it would be needed in the kernel.

Report immediate data with send work completions

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cq.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 8226b6b..ad1d20c 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -46,6 +46,7 @@
 
 #include "mlx4.h"
 #include "doorbell.h"
+#include "wqe.h"
 
 enum {
 	MLX4_CQ_DOORBELL			= 0x20
@@ -194,6 +195,7 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 {
 	struct mlx4_wq *wq;
 	struct mlx4_cqe *cqe;
+	struct mlx4_wqe_ctrl_seg *ctrl;
 	struct mlx4_srq *srq;
 	uint32_t qpn;
 	uint32_t g_mlpath_rqpn;
@@ -240,6 +242,8 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		wq = &(*cur_qp)->sq;
 		wqe_index = ntohs(cqe->wqe_index);
 		wq->tail += (uint16_t) (wqe_index - (uint16_t) wq->tail);
+		ctrl = (*cur_qp)->buf.buf + (*cur_qp)->sq.offset +
+			((wq->tail & (wq->wqe_cnt - 1)) << (*cur_qp)->sq.wqe_shift);
 		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
 	} else if ((*cur_qp)->ibv_qp.srq) {
@@ -265,11 +269,13 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
 		case MLX4_OPCODE_RDMA_WRITE_IMM:
 			wc->wc_flags |= IBV_WC_WITH_IMM;
+			wc->imm_data = ctrl->imm;
 		case MLX4_OPCODE_RDMA_WRITE:
 			wc->opcode    = IBV_WC_RDMA_WRITE;
 			break;
 		case MLX4_OPCODE_SEND_IMM:
 			wc->wc_flags |= IBV_WC_WITH_IMM;
+			wc->imm_data = ctrl->imm;
 		case MLX4_OPCODE_SEND:
 			wc->opcode    = IBV_WC_SEND;
 			break;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

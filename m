From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/28] IB/hfi1: Handle send with invalidate opcode in the RC
 recv path
Date: Mon, 25 Jul 2016 13:38:31 -0700
Message-ID: <20160725203830.4800.41066.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

As part of enabling extended memory management support, add the processing
of the RC send with invalidate.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |   16 +++++++++++++++-
 drivers/infiniband/hw/hfi1/verbs.c |    2 ++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index bd4baa4..cb474a7 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2098,6 +2098,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	unsigned long flags;
 	int ret, is_fecn = 0;
 	int copy_last = 0;
+	u32 rkey;
 
 	bth0 = be32_to_cpu(ohdr->bth[0]);
 	if (hfi1_ruc_check_hdr(ibp, hdr, rcv_flags & HFI1_HAS_GRH, qp, bth0))
@@ -2137,7 +2138,8 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	case OP(SEND_MIDDLE):
 		if (opcode == OP(SEND_MIDDLE) ||
 		    opcode == OP(SEND_LAST) ||
-		    opcode == OP(SEND_LAST_WITH_IMMEDIATE))
+		    opcode == OP(SEND_LAST_WITH_IMMEDIATE) ||
+		    opcode == OP(SEND_LAST_WITH_INVALIDATE))
 			break;
 		goto nack_inv;
 
@@ -2153,6 +2155,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 		if (opcode == OP(SEND_MIDDLE) ||
 		    opcode == OP(SEND_LAST) ||
 		    opcode == OP(SEND_LAST_WITH_IMMEDIATE) ||
+		    opcode == OP(SEND_LAST_WITH_INVALIDATE) ||
 		    opcode == OP(RDMA_WRITE_MIDDLE) ||
 		    opcode == OP(RDMA_WRITE_LAST) ||
 		    opcode == OP(RDMA_WRITE_LAST_WITH_IMMEDIATE))
@@ -2201,6 +2204,7 @@ send_middle:
 
 	case OP(SEND_ONLY):
 	case OP(SEND_ONLY_WITH_IMMEDIATE):
+	case OP(SEND_ONLY_WITH_INVALIDATE):
 		ret = hfi1_rvt_get_rwqe(qp, 0);
 		if (ret < 0)
 			goto nack_op_err;
@@ -2209,12 +2213,22 @@ send_middle:
 		qp->r_rcv_len = 0;
 		if (opcode == OP(SEND_ONLY))
 			goto no_immediate_data;
+		if (opcode == OP(SEND_ONLY_WITH_INVALIDATE))
+			goto send_last_inv;
 		/* FALLTHROUGH for SEND_ONLY_WITH_IMMEDIATE */
 	case OP(SEND_LAST_WITH_IMMEDIATE):
 send_last_imm:
 		wc.ex.imm_data = ohdr->u.imm_data;
 		wc.wc_flags = IB_WC_WITH_IMM;
 		goto send_last;
+	case OP(SEND_LAST_WITH_INVALIDATE):
+send_last_inv:
+		rkey = be32_to_cpu(ohdr->u.ieth);
+		if (rvt_invalidate_rkey(qp, rkey))
+			goto no_immediate_data;
+		wc.ex.invalidate_rkey = rkey;
+		wc.wc_flags = IB_WC_WITH_INVALIDATE;
+		goto send_last;
 	case OP(RDMA_WRITE_LAST):
 		copy_last = ibpd_to_rvtpd(qp->ibqp.pd)->user;
 		/* fall through */
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index a89055f..84cc09a 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -378,6 +378,8 @@ static const opcode_handler opcode_handler_tbl[256] = {
 	[IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE]             = &hfi1_rc_rcv,
 	[IB_OPCODE_RC_COMPARE_SWAP]                   = &hfi1_rc_rcv,
 	[IB_OPCODE_RC_FETCH_ADD]                      = &hfi1_rc_rcv,
+	[IB_OPCODE_RC_SEND_LAST_WITH_INVALIDATE]      = &hfi1_rc_rcv,
+	[IB_OPCODE_RC_SEND_ONLY_WITH_INVALIDATE]      = &hfi1_rc_rcv,
 	/* UC */
 	[IB_OPCODE_UC_SEND_FIRST]                     = &hfi1_uc_rcv,
 	[IB_OPCODE_UC_SEND_MIDDLE]                    = &hfi1_uc_rcv,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

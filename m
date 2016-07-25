From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/28] IB/hfi1: Work request processing for fast register mr
 and invalidate
Date: Mon, 25 Jul 2016 13:38:37 -0700
Message-ID: <20160725203836.4800.13123.stgit@scvm10.sc.intel.com>
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

In order to support extended memory management support, add send side
processing of work requests of type IB_WR_REG_MR, IB_WR_LOCAL_INV, and
IB_WR_SEND_WITH_INV. The first two are local operations and are supported
for both RC and UC. Send with invalidate is only supported for RC because
the corresponding IB opcodes are not defined for UC.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |   46 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/hfi1/ruc.c   |   26 ++++++++++++++++++++
 drivers/infiniband/hw/hfi1/uc.c    |   24 +++++++++++++++++++
 drivers/infiniband/hw/hfi1/verbs.c |    5 +++-
 4 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index cb474a7..0bc43b6 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -402,6 +402,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	char newreq;
 	int middle = 0;
 	int delta;
+	int err;
 
 	ps->s_txreq = get_txreq(ps->dev, qp);
 	if (IS_ERR(ps->s_txreq))
@@ -477,6 +478,35 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 				qp->s_flags |= RVT_S_WAIT_FENCE;
 				goto bail;
 			}
+			/*
+			 * Local operations are processed immediately
+			 * after all prior requests have completed
+			 */
+			if (wqe->wr.opcode == IB_WR_REG_MR ||
+			    wqe->wr.opcode == IB_WR_LOCAL_INV) {
+				if (qp->s_last != qp->s_cur)
+					goto bail;
+				if (++qp->s_cur == qp->s_size)
+					qp->s_cur = 0;
+				if (++qp->s_tail == qp->s_size)
+					qp->s_tail = 0;
+				if (wqe->wr.opcode == IB_WR_REG_MR)
+					err = rvt_fast_reg_mr(
+						qp, wqe->reg_wr.mr,
+						wqe->reg_wr.key,
+						wqe->reg_wr.access);
+				else
+					err = rvt_invalidate_rkey(
+						qp,
+						wqe->wr.ex.invalidate_rkey);
+				hfi1_send_complete(qp, wqe,
+						   err ? IB_WC_LOC_PROT_ERR
+						       : IB_WC_SUCCESS);
+				atomic_dec(&qp->local_ops_pending);
+				qp->s_hdrwords = 0;
+				goto done_free_tx;
+			}
+
 			newreq = 1;
 			qp->s_psn = wqe->psn;
 		}
@@ -491,6 +521,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		switch (wqe->wr.opcode) {
 		case IB_WR_SEND:
 		case IB_WR_SEND_WITH_IMM:
+		case IB_WR_SEND_WITH_INV:
 			/* If no credit, return. */
 			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
 			    cmp_msn(wqe->ssn, qp->s_lsn + 1) > 0) {
@@ -504,11 +535,17 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			}
 			if (wqe->wr.opcode == IB_WR_SEND) {
 				qp->s_state = OP(SEND_ONLY);
-			} else {
+			} else if (wqe->wr.opcode == IB_WR_SEND_WITH_IMM) {
 				qp->s_state = OP(SEND_ONLY_WITH_IMMEDIATE);
 				/* Immediate data comes after the BTH */
 				ohdr->u.imm_data = wqe->wr.ex.imm_data;
 				hwords += 1;
+			} else {
+				qp->s_state = OP(SEND_ONLY_WITH_INVALIDATE);
+				/* Invalidate rkey comes after the BTH */
+				ohdr->u.ieth = cpu_to_be32(
+						wqe->wr.ex.invalidate_rkey);
+				hwords += 1;
 			}
 			if (wqe->wr.send_flags & IB_SEND_SOLICITED)
 				bth0 |= IB_BTH_SOLICITED;
@@ -671,11 +708,16 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		}
 		if (wqe->wr.opcode == IB_WR_SEND) {
 			qp->s_state = OP(SEND_LAST);
-		} else {
+		} else if (wqe->wr.opcode == IB_WR_SEND_WITH_IMM) {
 			qp->s_state = OP(SEND_LAST_WITH_IMMEDIATE);
 			/* Immediate data comes after the BTH */
 			ohdr->u.imm_data = wqe->wr.ex.imm_data;
 			hwords += 1;
+		} else {
+			qp->s_state = OP(SEND_LAST_WITH_INVALIDATE);
+			/* invalidate data comes after the BTH */
+			ohdr->u.ieth = cpu_to_be32(wqe->wr.ex.invalidate_rkey);
+			hwords += 1;
 		}
 		if (wqe->wr.send_flags & IB_SEND_SOLICITED)
 			bth0 |= IB_BTH_SOLICITED;
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index a659aec..76b9c9e 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -372,6 +372,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	int ret;
 	int copy_last = 0;
 	u32 to;
+	int local_ops = 0;
 
 	rcu_read_lock();
 
@@ -440,11 +441,32 @@ again:
 	sqp->s_sge.num_sge = wqe->wr.num_sge;
 	sqp->s_len = wqe->length;
 	switch (wqe->wr.opcode) {
+	case IB_WR_REG_MR:
+		if (rvt_fast_reg_mr(sqp, wqe->reg_wr.mr, wqe->reg_wr.key,
+				    wqe->reg_wr.access))
+			send_status = IB_WC_LOC_PROT_ERR;
+		local_ops = 1;
+		goto send_comp;
+
+	case IB_WR_LOCAL_INV:
+		if (rvt_invalidate_rkey(sqp, wqe->wr.ex.invalidate_rkey))
+			send_status = IB_WC_LOC_PROT_ERR;
+		local_ops = 1;
+		goto send_comp;
+
+	case IB_WR_SEND_WITH_INV:
+		if (!rvt_invalidate_rkey(qp, wqe->wr.ex.invalidate_rkey)) {
+			wc.wc_flags = IB_WC_WITH_INVALIDATE;
+			wc.ex.invalidate_rkey = wqe->wr.ex.invalidate_rkey;
+		}
+		goto send;
+
 	case IB_WR_SEND_WITH_IMM:
 		wc.wc_flags = IB_WC_WITH_IMM;
 		wc.ex.imm_data = wqe->wr.ex.imm_data;
 		/* FALLTHROUGH */
 	case IB_WR_SEND:
+send:
 		ret = hfi1_rvt_get_rwqe(qp, 0);
 		if (ret < 0)
 			goto op_err;
@@ -583,6 +605,10 @@ send_comp:
 flush_send:
 	sqp->s_rnr_retry = sqp->s_rnr_retry_cnt;
 	hfi1_send_complete(sqp, wqe, send_status);
+	if (local_ops) {
+		atomic_dec(&sqp->local_ops_pending);
+		local_ops = 0;
+	}
 	goto again;
 
 rnr_nak:
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index b7a2531..ef6c96c 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -77,6 +77,7 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	u32 len;
 	u32 pmtu = qp->pmtu;
 	int middle = 0;
+	int err;
 
 	ps->s_txreq = get_txreq(ps->dev, qp);
 	if (IS_ERR(ps->s_txreq))
@@ -119,6 +120,29 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			goto bail;
 		}
 		/*
+		 * Local operations are processed immediately
+		 * after all prior requests have completed.
+		 */
+		if (wqe->wr.opcode == IB_WR_REG_MR ||
+		    wqe->wr.opcode == IB_WR_LOCAL_INV) {
+			if (qp->s_last != qp->s_cur)
+				goto bail;
+			if (++qp->s_cur == qp->s_size)
+				qp->s_cur = 0;
+			if (wqe->wr.opcode == IB_WR_REG_MR)
+				err = rvt_fast_reg_mr(qp, wqe->reg_wr.mr,
+						      wqe->reg_wr.key,
+						      wqe->reg_wr.access);
+			else
+				err = rvt_invalidate_rkey(
+					qp, wqe->wr.ex.invalidate_rkey);
+			hfi1_send_complete(qp, wqe, err ? IB_WC_LOC_PROT_ERR
+							: IB_WC_SUCCESS);
+			atomic_dec(&qp->local_ops_pending);
+			qp->s_hdrwords = 0;
+			goto done_free_tx;
+		}
+		/*
 		 * Start a new request.
 		 */
 		qp->s_psn = wqe->psn;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 84cc09a..57e0c0d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -306,7 +306,10 @@ const enum ib_wc_opcode ib_hfi1_wc_opcode[] = {
 	[IB_WR_SEND_WITH_IMM] = IB_WC_SEND,
 	[IB_WR_RDMA_READ] = IB_WC_RDMA_READ,
 	[IB_WR_ATOMIC_CMP_AND_SWP] = IB_WC_COMP_SWAP,
-	[IB_WR_ATOMIC_FETCH_AND_ADD] = IB_WC_FETCH_ADD
+	[IB_WR_ATOMIC_FETCH_AND_ADD] = IB_WC_FETCH_ADD,
+	[IB_WR_SEND_WITH_INV] = IB_WC_SEND,
+	[IB_WR_LOCAL_INV] = IB_WC_LOCAL_INV,
+	[IB_WR_REG_MR] = IB_WC_REG_MR
 };
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

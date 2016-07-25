From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/28] IB/rdmavt,
 hfi1: Fix NFSoRDMA failure with FRMR enabled
Date: Mon, 25 Jul 2016 13:39:45 -0700
Message-ID: <20160725203944.4800.44029.stgit@scvm10.sc.intel.com>
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

Hanging has been observed while writing a file over NFSoRDMA. Dmesg on
the server contains messages like these:

[  931.992501] svcrdma: Error -22 posting RDMA_READ
[  952.076879] svcrdma: Error -22 posting RDMA_READ
[  982.154127] svcrdma: Error -22 posting RDMA_READ
[ 1012.235884] svcrdma: Error -22 posting RDMA_READ
[ 1042.319194] svcrdma: Error -22 posting RDMA_READ

Here is why:

With the base memory management extension enabled, FRMR is used instead
of FMR. The xprtrdma server issues each RDMA read request as the following
bundle:

(1)IB_WR_REG_MR, signaled;
(2)IB_WR_RDMA_READ, signaled;
(3)IB_WR_LOCAL_INV, signaled & fencing.

These requests are signaled. In order to generate completion, the fast
register work request is processed by the hfi1 send engine after being
posted to the work queue, and the corresponding lkey is not valid until
the request is processed. However, the rdmavt driver validates lkey when
the RDMA read request is posted and thus it fails immediately with error
-EINVAL (-22).

This patch changes the work flow of local operations (fast register and
local invalidate) so that fast register work requests are always
processed immediately to ensure that the corresponding lkey is valid
when subsequent work requests are posted. Local invalidate requests are
processed immediately if fencing is not required and no previous local
invalidate request is pending.

To allow completion generation for signaled local operations that have
been processed before posting to the work queue, an internal send flag
RVT_SEND_COMPLETION_ONLY is added. The hfi1 send engine checks this flag
and only generates completion for such requests.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c   |   17 +++++++------
 drivers/infiniband/hw/hfi1/ruc.c  |   13 +++++-----
 drivers/infiniband/hw/hfi1/uc.c   |   15 ++++++------
 drivers/infiniband/sw/rdmavt/qp.c |   48 +++++++++++++++++++++++++------------
 include/rdma/rdmavt_qp.h          |    1 +
 5 files changed, 56 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 0bc43b6..5da190e 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -402,7 +402,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	char newreq;
 	int middle = 0;
 	int delta;
-	int err;
 
 	ps->s_txreq = get_txreq(ps->dev, qp);
 	if (IS_ERR(ps->s_txreq))
@@ -484,25 +483,27 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			 */
 			if (wqe->wr.opcode == IB_WR_REG_MR ||
 			    wqe->wr.opcode == IB_WR_LOCAL_INV) {
+				int local_ops = 0;
+				int err = 0;
+
 				if (qp->s_last != qp->s_cur)
 					goto bail;
 				if (++qp->s_cur == qp->s_size)
 					qp->s_cur = 0;
 				if (++qp->s_tail == qp->s_size)
 					qp->s_tail = 0;
-				if (wqe->wr.opcode == IB_WR_REG_MR)
-					err = rvt_fast_reg_mr(
-						qp, wqe->reg_wr.mr,
-						wqe->reg_wr.key,
-						wqe->reg_wr.access);
-				else
+				if (!(wqe->wr.send_flags &
+				      RVT_SEND_COMPLETION_ONLY)) {
 					err = rvt_invalidate_rkey(
 						qp,
 						wqe->wr.ex.invalidate_rkey);
+					local_ops = 1;
+				}
 				hfi1_send_complete(qp, wqe,
 						   err ? IB_WC_LOC_PROT_ERR
 						       : IB_WC_SUCCESS);
-				atomic_dec(&qp->local_ops_pending);
+				if (local_ops)
+					atomic_dec(&qp->local_ops_pending);
 				qp->s_hdrwords = 0;
 				goto done_free_tx;
 			}
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 76b9c9e..7e76d33 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -442,16 +442,15 @@ again:
 	sqp->s_len = wqe->length;
 	switch (wqe->wr.opcode) {
 	case IB_WR_REG_MR:
-		if (rvt_fast_reg_mr(sqp, wqe->reg_wr.mr, wqe->reg_wr.key,
-				    wqe->reg_wr.access))
-			send_status = IB_WC_LOC_PROT_ERR;
-		local_ops = 1;
 		goto send_comp;
 
 	case IB_WR_LOCAL_INV:
-		if (rvt_invalidate_rkey(sqp, wqe->wr.ex.invalidate_rkey))
-			send_status = IB_WC_LOC_PROT_ERR;
-		local_ops = 1;
+		if (!(wqe->wr.send_flags & RVT_SEND_COMPLETION_ONLY)) {
+			if (rvt_invalidate_rkey(sqp,
+						wqe->wr.ex.invalidate_rkey))
+				send_status = IB_WC_LOC_PROT_ERR;
+			local_ops = 1;
+		}
 		goto send_comp;
 
 	case IB_WR_SEND_WITH_INV:
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index ef6c96c..a726d96 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -77,7 +77,6 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	u32 len;
 	u32 pmtu = qp->pmtu;
 	int middle = 0;
-	int err;
 
 	ps->s_txreq = get_txreq(ps->dev, qp);
 	if (IS_ERR(ps->s_txreq))
@@ -125,20 +124,22 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		 */
 		if (wqe->wr.opcode == IB_WR_REG_MR ||
 		    wqe->wr.opcode == IB_WR_LOCAL_INV) {
+			int local_ops = 0;
+			int err = 0;
+
 			if (qp->s_last != qp->s_cur)
 				goto bail;
 			if (++qp->s_cur == qp->s_size)
 				qp->s_cur = 0;
-			if (wqe->wr.opcode == IB_WR_REG_MR)
-				err = rvt_fast_reg_mr(qp, wqe->reg_wr.mr,
-						      wqe->reg_wr.key,
-						      wqe->reg_wr.access);
-			else
+			if (!(wqe->wr.send_flags & RVT_SEND_COMPLETION_ONLY)) {
 				err = rvt_invalidate_rkey(
 					qp, wqe->wr.ex.invalidate_rkey);
+				local_ops = 1;
+			}
 			hfi1_send_complete(qp, wqe, err ? IB_WC_LOC_PROT_ERR
 							: IB_WC_SUCCESS);
-			atomic_dec(&qp->local_ops_pending);
+			if (local_ops)
+				atomic_dec(&qp->local_ops_pending);
 			qp->s_hdrwords = 0;
 			goto done_free_tx;
 		}
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 218494c..8ccf1b9 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1579,6 +1579,7 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 	int ret;
 	size_t cplen;
 	bool reserved_op;
+	int local_ops_delayed = 0;
 
 	BUILD_BUG_ON(IB_QPT_MAX >= (sizeof(u32) * BITS_PER_BYTE));
 
@@ -1592,25 +1593,37 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 	cplen = ret;
 
 	/*
-	 * Local operations including fast register and local invalidate
-	 * can be processed immediately w/o being posted to the send queue
-	 * if neither fencing nor completion generation is needed. However,
-	 * once fencing or completion is requested, direct processing of
-	 * following local operations must be disabled until all the local
-	 * operations posted to the send queue have completed. This is
-	 * necessary to ensure the correct ordering.
+	 * Local operations include fast register and local invalidate.
+	 * Fast register needs to be processed immediately because the
+	 * registered lkey may be used by following work requests and the
+	 * lkey needs to be valid at the time those requests are posted.
+	 * Local invalidate can be processed immediately if fencing is
+	 * not required and no previous local invalidate ops are pending.
+	 * Signaled local operations that have been processed immediately
+	 * need to have requests with "completion only" flags set posted
+	 * to the send queue in order to generate completions.
 	 */
-	if ((rdi->post_parms[wr->opcode].flags & RVT_OPERATION_LOCAL) &&
-	    !(wr->send_flags & (IB_SEND_FENCE | IB_SEND_SIGNALED)) &&
-	    !atomic_read(&qp->local_ops_pending)) {
-		struct ib_reg_wr *reg = reg_wr(wr);
-
+	if ((rdi->post_parms[wr->opcode].flags & RVT_OPERATION_LOCAL)) {
 		switch (wr->opcode) {
 		case IB_WR_REG_MR:
-			return rvt_fast_reg_mr(qp, reg->mr, reg->key,
-					       reg->access);
+			ret = rvt_fast_reg_mr(qp,
+					      reg_wr(wr)->mr,
+					      reg_wr(wr)->key,
+					      reg_wr(wr)->access);
+			if (ret || !(wr->send_flags & IB_SEND_SIGNALED))
+				return ret;
+			break;
 		case IB_WR_LOCAL_INV:
-			return rvt_invalidate_rkey(qp, wr->ex.invalidate_rkey);
+			if ((wr->send_flags & IB_SEND_FENCE) ||
+			    atomic_read(&qp->local_ops_pending)) {
+				local_ops_delayed = 1;
+			} else {
+				ret = rvt_invalidate_rkey(
+					qp, wr->ex.invalidate_rkey);
+				if (ret || !(wr->send_flags & IB_SEND_SIGNALED))
+					return ret;
+			}
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -1675,7 +1688,10 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 	}
 
 	if (rdi->post_parms[wr->opcode].flags & RVT_OPERATION_LOCAL) {
-		atomic_inc(&qp->local_ops_pending);
+		if (local_ops_delayed)
+			atomic_inc(&qp->local_ops_pending);
+		else
+			wqe->wr.send_flags |= RVT_SEND_COMPLETION_ONLY;
 		wqe->ssn = 0;
 		wqe->psn = 0;
 		wqe->lpsn = 0;
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 56adcfc..13902dd 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -148,6 +148,7 @@
  * Internal send flags
  */
 #define RVT_SEND_RESERVE_USED           IB_SEND_RESERVED_START
+#define RVT_SEND_COMPLETION_ONLY	(IB_SEND_RESERVED_START << 1)
 
 /*
  * Send work request queue entry.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

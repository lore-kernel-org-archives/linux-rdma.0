From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/28] IB/rdmavt: Handle local operations in post send
Date: Mon, 25 Jul 2016 13:38:25 -0700
Message-ID: <20160725203824.4800.45029.stgit@scvm10.sc.intel.com>
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

Some work requests are local operations, such as IB_WR_REG_MR and
IB_WR_LOCAL_INV. They differ from non-local operations in that:

(1) Local operations can be processed immediately without being posted
to the send queue if neither fencing nor completion generation is needed.
However, to ensure correct ordering, once a local operation is posted to
the work queue due to fencing or completion requiement, all subsequent
local operations must also be posted to the work queue until all the
local operations on the work queue have completed.

(2) Local operations don't send packets over the wire and thus don't
need (and shouldn't update) the packet sequence numbers.

Define a new a flag bit for the post send table to identify local
operations.

Add a new field to the QP structure to track the number of local
operations on the send queue to determine if direct processing of new
local operations should be enabled/disabled.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   45 +++++++++++++++++++++++++++++++++----
 include/rdma/rdmavt_qp.h          |    3 ++
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index ebc37f5..f79b809 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -743,6 +743,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		spin_lock_init(&qp->s_lock);
 		spin_lock_init(&qp->r_rq.lock);
 		atomic_set(&qp->refcount, 0);
+		atomic_set(&qp->local_ops_pending, 0);
 		init_waitqueue_head(&qp->wait);
 		init_timer(&qp->s_timer);
 		qp->s_timer.data = (unsigned long)qp;
@@ -1548,6 +1549,31 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 		return ret;
 	cplen = ret;
 
+	/*
+	 * Local operations including fast register and local invalidate
+	 * can be processed immediately w/o being posted to the send queue
+	 * if neither fencing nor completion generation is needed. However,
+	 * once fencing or completion is requested, direct processing of
+	 * following local operations must be disabled until all the local
+	 * operations posted to the send queue have completed. This is
+	 * necessary to ensure the correct ordering.
+	 */
+	if ((rdi->post_parms[wr->opcode].flags & RVT_OPERATION_LOCAL) &&
+	    !(wr->send_flags & (IB_SEND_FENCE | IB_SEND_SIGNALED)) &&
+	    !atomic_read(&qp->local_ops_pending)) {
+		struct ib_reg_wr *reg = reg_wr(wr);
+
+		switch (wr->opcode) {
+		case IB_WR_REG_MR:
+			return rvt_fast_reg_mr(qp, reg->mr, reg->key,
+					       reg->access);
+		case IB_WR_LOCAL_INV:
+			return rvt_invalidate_rkey(qp, wr->ex.invalidate_rkey);
+		default:
+			return -EINVAL;
+		}
+	}
+
 	/* check for avail */
 	if (unlikely(!qp->s_avail)) {
 		qp->s_avail = qp_get_savail(qp);
@@ -1612,11 +1638,20 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 		atomic_inc(&ibah_to_rvtah(ud_wr(wr)->ah)->refcount);
 	}
 
-	wqe->ssn = qp->s_ssn++;
-	wqe->psn = qp->s_next_psn;
-	wqe->lpsn = wqe->psn +
-			(wqe->length ? ((wqe->length - 1) >> log_pmtu) : 0);
-	qp->s_next_psn = wqe->lpsn + 1;
+	if (rdi->post_parms[wr->opcode].flags & RVT_OPERATION_LOCAL) {
+		atomic_inc(&qp->local_ops_pending);
+		wqe->ssn = 0;
+		wqe->psn = 0;
+		wqe->lpsn = 0;
+	} else {
+		wqe->ssn = qp->s_ssn++;
+		wqe->psn = qp->s_next_psn;
+		wqe->lpsn = wqe->psn +
+				(wqe->length ?
+					((wqe->length - 1) >> log_pmtu) :
+					0);
+		qp->s_next_psn = wqe->lpsn + 1;
+	}
 	trace_rvt_post_one_wr(qp, wqe);
 	smp_wmb(); /* see request builders */
 	qp->s_avail--;
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index a90d1e9..b0ab12b 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -231,6 +231,7 @@ struct rvt_ack_entry {
 #define RVT_OPERATION_PRIV        0x00000001
 #define RVT_OPERATION_ATOMIC      0x00000002
 #define RVT_OPERATION_ATOMIC_SGE  0x00000004
+#define RVT_OPERATION_LOCAL       0x00000008
 
 #define RVT_OPERATION_MAX (IB_WR_RESERVED10 + 1)
 
@@ -363,6 +364,8 @@ struct rvt_qp {
 	struct rvt_sge_state s_ack_rdma_sge;
 	struct timer_list s_timer;
 
+	atomic_t local_ops_pending; /* number of fast_reg/local_inv reqs */
+
 	/*
 	 * This sge list MUST be last. Do not add anything below here.
 	 */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

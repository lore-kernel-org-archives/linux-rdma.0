From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 25/27] IB/hfi1: Remove post_recv and use rdmavt version
Date: Sat, 09 Jan 2016 07:18:58 -0800
Message-ID: <20160109151857.30800.70884.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch removes the simple post recv function in favor of using rdmavt.
The packet receive processing still lives in the driver though.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |   63 +------------------------------------
 1 files changed, 1 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index b8350a8..0f0e8e8 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -323,67 +323,6 @@ void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, int release)
 	}
 }
 
-/**
- * post_receive - post a receive on a QP
- * @ibqp: the QP to post the receive on
- * @wr: the WR to post
- * @bad_wr: the first bad WR is put here
- *
- * This may be called from interrupt context.
- */
-static int post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
-			struct ib_recv_wr **bad_wr)
-{
-	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
-	struct rvt_rwq *wq = qp->r_rq.wq;
-	unsigned long flags;
-	int ret;
-
-	/* Check that state is OK to post receive. */
-	if (!(ib_rvt_state_ops[qp->state] & RVT_POST_RECV_OK) || !wq) {
-		*bad_wr = wr;
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	for (; wr; wr = wr->next) {
-		struct rvt_rwqe *wqe;
-		u32 next;
-		int i;
-
-		if ((unsigned) wr->num_sge > qp->r_rq.max_sge) {
-			*bad_wr = wr;
-			ret = -EINVAL;
-			goto bail;
-		}
-
-		spin_lock_irqsave(&qp->r_rq.lock, flags);
-		next = wq->head + 1;
-		if (next >= qp->r_rq.size)
-			next = 0;
-		if (next == wq->tail) {
-			spin_unlock_irqrestore(&qp->r_rq.lock, flags);
-			*bad_wr = wr;
-			ret = -ENOMEM;
-			goto bail;
-		}
-
-		wqe = rvt_get_rwqe_ptr(&qp->r_rq, wq->head);
-		wqe->wr_id = wr->wr_id;
-		wqe->num_sge = wr->num_sge;
-		for (i = 0; i < wr->num_sge; i++)
-			wqe->sg_list[i] = wr->sg_list[i];
-		/* Make sure queue entry is written before the head index. */
-		smp_wmb();
-		wq->head = next;
-		spin_unlock_irqrestore(&qp->r_rq.lock, flags);
-	}
-	ret = 0;
-
-bail:
-	return ret;
-}
-
 /*
  * Make sure the QP is ready and able to accept the given opcode.
  */
@@ -1641,7 +1580,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->query_qp = hfi1_query_qp;
 	ibdev->destroy_qp = NULL;
 	ibdev->post_send = NULL;
-	ibdev->post_recv = post_receive;
+	ibdev->post_recv = NULL;
 	ibdev->post_srq_recv = hfi1_post_srq_receive;
 	ibdev->create_cq = NULL;
 	ibdev->destroy_cq = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

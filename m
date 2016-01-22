From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 5/7] IB/qib: Remove qib_post_receive and use rdmavt
 version
Date: Fri, 22 Jan 2016 13:07:49 -0800
Message-ID: <20160122210747.10962.40073.stgit@scvm10.sc.intel.com>
References: <20160122210559.10962.33295.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122210559.10962.33295.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch removes the simple post recv function in favor of using rdmavt.
The packet receive processing still lives in the driver though.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |   64 +--------------------------------
 1 files changed, 1 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 3766ea4..add899b 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -301,68 +301,6 @@ static void qib_copy_from_sge(void *data, struct rvt_sge_state *ss, u32 length)
 }
 
 /**
-
- * qib_post_receive - post a receive on a QP
- * @ibqp: the QP to post the receive on
- * @wr: the WR to post
- * @bad_wr: the first bad WR is put here
- *
- * This may be called from interrupt context.
- */
-static int qib_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
-			    struct ib_recv_wr **bad_wr)
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
-		wqe = get_rwqe_ptr(&qp->r_rq, wq->head);
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
-/**
  * qib_qp_rcv - processing an incoming packet on a QP
  * @rcd: the context pointer
  * @hdr: the packet header
@@ -1826,7 +1764,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->query_qp = qib_query_qp;
 	ibdev->destroy_qp = qib_destroy_qp;
 	ibdev->post_send = NULL;
-	ibdev->post_recv = qib_post_receive;
+	ibdev->post_recv = NULL;
 	ibdev->post_srq_recv = qib_post_srq_receive;
 	ibdev->create_cq = NULL;
 	ibdev->destroy_cq = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

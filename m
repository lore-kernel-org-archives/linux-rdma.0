From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/8] IB/rdmavt: Add post receive to rdmavt
Date: Sat, 09 Jan 2016 07:00:30 -0800
Message-ID: <20160109150030.8585.17045.stgit@scvm10.sc.intel.com>
References: <20160109145731.8585.48926.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109145731.8585.48926.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the simple post receive verbs call to rdmavt. The actual
interrupt handling and packet processing is still done in the low level
driver.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   47 +++++++++++++++++++++++++++++++------
 1 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 6aa7d6f..0b606b1 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1214,14 +1214,47 @@ int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		  struct ib_recv_wr **bad_wr)
 {
-	/*
-	 * When a packet arrives the driver needs to call up to rvt to process
-	 * the packet. The UD, RC, UC processing will be done in rvt, however
-	 * the driver should be able to override this if it so choses. Perhaps a
-	 * set of function pointers set up at registration time.
-	 */
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
+	struct rvt_rwq *wq = qp->r_rq.wq;
+	unsigned long flags;
 
-	return -EOPNOTSUPP;
+	/* Check that state is OK to post receive. */
+	if (!(ib_rvt_state_ops[qp->state] & RVT_POST_RECV_OK) || !wq) {
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	for (; wr; wr = wr->next) {
+		struct rvt_rwqe *wqe;
+		u32 next;
+		int i;
+
+		if ((unsigned)wr->num_sge > qp->r_rq.max_sge) {
+			*bad_wr = wr;
+			return -EINVAL;
+		}
+
+		spin_lock_irqsave(&qp->r_rq.lock, flags);
+		next = wq->head + 1;
+		if (next >= qp->r_rq.size)
+			next = 0;
+		if (next == wq->tail) {
+			spin_unlock_irqrestore(&qp->r_rq.lock, flags);
+			*bad_wr = wr;
+			return -ENOMEM;
+		}
+
+		wqe = rvt_get_rwqe_ptr(&qp->r_rq, wq->head);
+		wqe->wr_id = wr->wr_id;
+		wqe->num_sge = wr->num_sge;
+		for (i = 0; i < wr->num_sge; i++)
+			wqe->sg_list[i] = wr->sg_list[i];
+		/* Make sure queue entry is written before the head index. */
+		smp_wmb();
+		wq->head = next;
+		spin_unlock_irqrestore(&qp->r_rq.lock, flags);
+	}
+	return 0;
 }
 
 /**

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

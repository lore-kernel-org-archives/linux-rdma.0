From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Improve ipoib UD performance
Date: Thu, 24 Dec 2015 11:19:23 -0500
Message-ID: <20151224161923.9544.79119.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Based on profiling, UD performance drops in case of processes
in a single client due to excess context switches when
the progress workqueue is scheduled.

This is solved by modifying the heuristic to select the
direct progress instead of the scheduling progress via
the workqueue when UD-like situations are detected in
the heuristic.

Reviewed-by: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index de6cb6f..f29f097 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -346,6 +346,7 @@ static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
 	unsigned long flags;
 	struct qib_lkey_table *rkt;
 	struct qib_pd *pd;
+	int avoid_schedule = 0;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
@@ -438,11 +439,15 @@ static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
 	    qp->ibqp.qp_type == IB_QPT_RC) {
 		if (wqe->length > 0x80000000U)
 			goto bail_inval_free;
+		if (wqe->length <= qp->pmtu)
+			avoid_schedule = 1;
 	} else if (wqe->length > (dd_from_ibdev(qp->ibqp.device)->pport +
-				  qp->port_num - 1)->ibmtu)
+				  qp->port_num - 1)->ibmtu) {
 		goto bail_inval_free;
-	else
+	} else {
 		atomic_inc(&to_iah(ud_wr(wr)->ah)->refcount);
+		avoid_schedule = 1;
+	}
 	wqe->ssn = qp->s_ssn++;
 	qp->s_head = next;
 
@@ -458,7 +463,7 @@ bail_inval_free:
 bail_inval:
 	ret = -EINVAL;
 bail:
-	if (!ret && !wr->next &&
+	if (!ret && !wr->next && !avoid_schedule &&
 	 !qib_sdma_empty(
 	   dd_from_ibdev(qp->ibqp.device)->pport + qp->port_num - 1)) {
 		qib_schedule_send(qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

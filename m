From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Fix arm logic to align with new cq API
Date: Thu, 11 Feb 2016 00:21:52 -0500
Message-ID: <1455168112-12803-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Today ocrdma driver defer arming the CQ till poll is called.
This was used to prevent calling poll-cq on an armed CQ.

Recently a set of new CQ API has been introduced into the linux
kernel. The implementation of this API guarantees that a given
CQ is never armed before calling poll on it. Most of the kernel
ULPs have already moved to use this new API or have a code where
poll is called before arming the CQ.

Thus, the above workaround in ocrdma is not needed anymore.
This patch removes the additional logic to deffer arm till poll
is called. This patch adds a simple scheme where ib_req_notify_cq()
will actually arm the cq.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  3 ---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 18 ++++--------------
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 040bb8b..12503f1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -323,9 +323,6 @@ struct ocrdma_cq {
 			 */
 	u32 max_hw_cqe;
 	bool phase_change;
-	bool deferred_arm, deferred_sol;
-	bool first_arm;
-
 	spinlock_t cq_lock ____cacheline_aligned; /* provide synchronization
 						   * to cq polling
 						   */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 37620b4..12420e4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1094,7 +1094,6 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev,
 	spin_lock_init(&cq->comp_handler_lock);
 	INIT_LIST_HEAD(&cq->sq_head);
 	INIT_LIST_HEAD(&cq->rq_head);
-	cq->first_arm = true;
 
 	if (ib_ctx) {
 		uctx = get_ocrdma_ucontext(ib_ctx);
@@ -2910,12 +2909,9 @@ expand_cqe:
 	}
 stop_cqe:
 	cq->getp = cur_getp;
-	if (cq->deferred_arm || polled_hw_cqes) {
-		ocrdma_ring_cq_db(dev, cq->id, cq->deferred_arm,
-				  cq->deferred_sol, polled_hw_cqes);
-		cq->deferred_arm = false;
-		cq->deferred_sol = false;
-	}
+
+	if (polled_hw_cqes)
+		ocrdma_ring_cq_db(dev, cq->id, false, false, polled_hw_cqes);
 
 	return i;
 }
@@ -2999,13 +2995,7 @@ int ocrdma_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags cq_flags)
 	if (cq_flags & IB_CQ_SOLICITED)
 		sol_needed = true;
 
-	if (cq->first_arm) {
-		ocrdma_ring_cq_db(dev, cq_id, arm_needed, sol_needed, 0);
-		cq->first_arm = false;
-	}
-
-	cq->deferred_arm = true;
-	cq->deferred_sol = sol_needed;
+	ocrdma_ring_cq_db(dev, cq_id, arm_needed, sol_needed, 0);
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

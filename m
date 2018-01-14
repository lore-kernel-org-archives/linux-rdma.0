From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] IB/cq: Don't force IB_POLL_DIRECT poll context for ib_process_cq_direct
Date: Sun, 14 Jan 2018 17:07:50 +0200
Message-ID: <1515942470-11461-3-git-send-email-maxg@mellanox.com>
References: <1515942470-11461-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515942470-11461-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

polling the completion queue directly does not interfere
with the existing polling logic, hence drop the requirement.
Be aware that running ib_process_cq_direct with non IB_POLL_DIRECT
CQ may trigger concurrent CQ processing.

This can be used for polling mode ULPs.

Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reported-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
[maxg: added wcs array argument to __ib_process_cq]
Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cq.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 637c999..0519130 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -22,9 +22,10 @@
 #define IB_POLL_FLAGS \
 	(IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS)
 
-static int __ib_process_cq(struct ib_cq *cq, int budget)
+static int __ib_process_cq(struct ib_cq *cq, int budget, struct ib_wc *poll_wc)
 {
 	int i, n, completed = 0;
+	struct ib_wc *wcs = poll_wc ? : cq->wc;
 
 	/*
 	 * budget might be (-1) if the caller does not
@@ -32,9 +33,9 @@ static int __ib_process_cq(struct ib_cq *cq, int budget)
 	 * minimum here.
 	 */
 	while ((n = ib_poll_cq(cq, min_t(u32, IB_POLL_BATCH,
-			budget - completed), cq->wc)) > 0) {
+			budget - completed), wcs)) > 0) {
 		for (i = 0; i < n; i++) {
-			struct ib_wc *wc = &cq->wc[i];
+			struct ib_wc *wc = &wcs[i];
 
 			if (wc->wr_cqe)
 				wc->wr_cqe->done(cq, wc);
@@ -57,18 +58,20 @@ static int __ib_process_cq(struct ib_cq *cq, int budget)
  * @cq:		CQ to process
  * @budget:	number of CQEs to poll for
  *
- * This function is used to process all outstanding CQ entries on a
- * %IB_POLL_DIRECT CQ.  It does not offload CQ processing to a different
- * context and does not ask for completion interrupts from the HCA.
+ * This function is used to process all outstanding CQ entries.
+ * It does not offload CQ processing to a different context and does
+ * not ask for completion interrupts from the HCA.
+ * Using direct processing on CQ with non IB_POLL_DIRECT type may trigger
+ * concurrent processing.
  *
  * Note: do not pass -1 as %budget unless it is guaranteed that the number
  * of completions that will be processed is small.
  */
 int ib_process_cq_direct(struct ib_cq *cq, int budget)
 {
-	WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT);
+	struct ib_wc wcs[IB_POLL_BATCH];
 
-	return __ib_process_cq(cq, budget);
+	return __ib_process_cq(cq, budget, wcs);
 }
 EXPORT_SYMBOL(ib_process_cq_direct);
 
@@ -82,7 +85,7 @@ static int ib_poll_handler(struct irq_poll *iop, int budget)
 	struct ib_cq *cq = container_of(iop, struct ib_cq, iop);
 	int completed;
 
-	completed = __ib_process_cq(cq, budget);
+	completed = __ib_process_cq(cq, budget, NULL);
 	if (completed < budget) {
 		irq_poll_complete(&cq->iop);
 		if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
@@ -102,7 +105,7 @@ static void ib_cq_poll_work(struct work_struct *work)
 	struct ib_cq *cq = container_of(work, struct ib_cq, work);
 	int completed;
 
-	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
+	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE, NULL);
 	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
 	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
 		queue_work(ib_comp_wq, &cq->work);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

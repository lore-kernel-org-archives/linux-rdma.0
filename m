From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 7/8] IB/core: Add support for draining IB_POLL_DIRECT completion queues
Date: Fri, 10 Feb 2017 15:56:10 -0800
Message-ID: <20170210235611.3243-8-bart.vanassche@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210235611.3243-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 71580cc28c9e..42f8927b542c 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1949,17 +1949,12 @@ static void ib_drain_qp_done(struct ib_cq *cq, struct ib_wc *wc)
  */
 static void __ib_drain_sq(struct ib_qp *qp)
 {
+	struct ib_cq *cq = qp->send_cq;
 	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
 	struct ib_drain_cqe sdrain;
 	struct ib_send_wr swr = {}, *bad_swr;
 	int ret;
 
-	if (qp->send_cq->poll_ctx == IB_POLL_DIRECT) {
-		WARN_ONCE(qp->send_cq->poll_ctx == IB_POLL_DIRECT,
-			  "IB_POLL_DIRECT poll_ctx not supported for drain\n");
-		return;
-	}
-
 	swr.wr_cqe = &sdrain.cqe;
 	sdrain.cqe.done = ib_drain_qp_done;
 	init_completion(&sdrain.done);
@@ -1976,7 +1971,11 @@ static void __ib_drain_sq(struct ib_qp *qp)
 		return;
 	}
 
-	wait_for_completion(&sdrain.done);
+	if (cq->poll_ctx == IB_POLL_DIRECT)
+		while (wait_for_completion_timeout(&sdrain.done, HZ / 10) <= 0)
+			ib_process_cq_direct(cq, -1);
+	else
+		wait_for_completion(&sdrain.done);
 }
 
 /*
@@ -1984,17 +1983,12 @@ static void __ib_drain_sq(struct ib_qp *qp)
  */
 static void __ib_drain_rq(struct ib_qp *qp)
 {
+	struct ib_cq *cq = qp->recv_cq;
 	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
 	struct ib_drain_cqe rdrain;
 	struct ib_recv_wr rwr = {}, *bad_rwr;
 	int ret;
 
-	if (qp->recv_cq->poll_ctx == IB_POLL_DIRECT) {
-		WARN_ONCE(qp->recv_cq->poll_ctx == IB_POLL_DIRECT,
-			  "IB_POLL_DIRECT poll_ctx not supported for drain\n");
-		return;
-	}
-
 	rwr.wr_cqe = &rdrain.cqe;
 	rdrain.cqe.done = ib_drain_qp_done;
 	init_completion(&rdrain.done);
@@ -2011,7 +2005,11 @@ static void __ib_drain_rq(struct ib_qp *qp)
 		return;
 	}
 
-	wait_for_completion(&rdrain.done);
+	if (cq->poll_ctx == IB_POLL_DIRECT)
+		while (wait_for_completion_timeout(&rdrain.done, HZ / 10) <= 0)
+			ib_process_cq_direct(cq, -1);
+	else
+		wait_for_completion(&rdrain.done);
 }
 
 /**
@@ -2028,8 +2026,7 @@ static void __ib_drain_rq(struct ib_qp *qp)
  * ensure there is room in the CQ and SQ for the drain work request and
  * completion.
  *
- * allocate the CQ using ib_alloc_cq() and the CQ poll context cannot be
- * IB_POLL_DIRECT.
+ * allocate the CQ using ib_alloc_cq().
  *
  * ensure that there are no other contexts that are posting WRs concurrently.
  * Otherwise the drain is not guaranteed.
@@ -2057,8 +2054,7 @@ EXPORT_SYMBOL(ib_drain_sq);
  * ensure there is room in the CQ and RQ for the drain work request and
  * completion.
  *
- * allocate the CQ using ib_alloc_cq() and the CQ poll context cannot be
- * IB_POLL_DIRECT.
+ * allocate the CQ using ib_alloc_cq().
  *
  * ensure that there are no other contexts that are posting WRs concurrently.
  * Otherwise the drain is not guaranteed.
@@ -2082,8 +2078,7 @@ EXPORT_SYMBOL(ib_drain_rq);
  * ensure there is room in the CQ(s), SQ, and RQ for drain work requests
  * and completions.
  *
- * allocate the CQs using ib_alloc_cq() and the CQ poll context cannot be
- * IB_POLL_DIRECT.
+ * allocate the CQs using ib_alloc_cq().
  *
  * ensure that there are no other contexts that are posting WRs concurrently.
  * Otherwise the drain is not guaranteed.
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

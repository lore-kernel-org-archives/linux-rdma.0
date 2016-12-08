From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Use ib_drain_qp instead of ib_drain_rq in ib_srp
Date: Wed, 7 Dec 2016 16:54:07 -0800
Message-ID: <6ed6633b-d4ff-4293-c270-42a58e89f076@sandisk.com>
References: <fa2d38be-bc59-5120-6dfd-f24ab01d6d8f@mellanox.com>
 <b2a1ed73-fb4c-07a5-c343-389bdc29501c@sandisk.com>
 <7ec8b32c-f813-5a86-b7e9-b1272bc28b2c@mellanox.com>
 <67507993-487f-d1fd-8a1d-76d8faa7cb96@sandisk.com>
 <45659b93-f938-9ed9-677a-5fe949e79381@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------2BF86B98961267F0E0BA9464"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <45659b93-f938-9ed9-677a-5fe949e79381-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--------------2BF86B98961267F0E0BA9464
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 12/07/2016 03:34 PM, Max Gurtovoy wrote:
> they will work in case of srp (the only user for DIRECT approach in the
> ULP's), but don't you think it's a hard requirement for the caller to
> ensure that no ib_poll_cq can be called during ib_set_cq_poll_context ?
> There was some thought in the past to share cq's among ULP's that is
> currently on hold (in this approach we can't be sure other context don't
> call ib_poll_cq). In other hand we can avoid sharing DIRECT cq's.
> Anyway, I thought of passing "struct ib_drain_cqe" as an arg to drain
> function from ULP and wait for completion (with tmo) in the ULP level,
> after direct ib_process_cq_direct.
> I don't have an implementation yet, but I hope I explained my idea.

Hello Max,

How about the attached two patches? The approach of these patches should 
be compatible with CQ sharing.

Bart.


--------------2BF86B98961267F0E0BA9464
Content-Type: text/x-patch;
	name="0001-IB-core-Add-support-for-draining-IB_POLL_DIRECT-comp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-IB-core-Add-support-for-draining-IB_POLL_DIRECT-comp.pa";
	filename*1="tch"

>From 13d8ba925e26679054960131bf85621ac659fb89 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Date: Wed, 7 Dec 2016 16:12:21 -0800
Subject: [PATCH 1/2] IB/core: Add support for draining IB_POLL_DIRECT
 completion queues

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 83687646da68..f0c5f2a0ec55 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1943,17 +1943,12 @@ static void ib_drain_qp_done(struct ib_cq *cq, struct ib_wc *wc)
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
@@ -1970,7 +1965,11 @@ static void __ib_drain_sq(struct ib_qp *qp)
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
@@ -1978,17 +1977,12 @@ static void __ib_drain_sq(struct ib_qp *qp)
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
@@ -2005,7 +1999,11 @@ static void __ib_drain_rq(struct ib_qp *qp)
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
@@ -2022,8 +2020,7 @@ static void __ib_drain_rq(struct ib_qp *qp)
  * ensure there is room in the CQ and SQ for the drain work request and
  * completion.
  *
- * allocate the CQ using ib_alloc_cq() and the CQ poll context cannot be
- * IB_POLL_DIRECT.
+ * allocate the CQ using ib_alloc_cq().
  *
  * ensure that there are no other contexts that are posting WRs concurrently.
  * Otherwise the drain is not guaranteed.
@@ -2051,8 +2048,7 @@ EXPORT_SYMBOL(ib_drain_sq);
  * ensure there is room in the CQ and RQ for the drain work request and
  * completion.
  *
- * allocate the CQ using ib_alloc_cq() and the CQ poll context cannot be
- * IB_POLL_DIRECT.
+ * allocate the CQ using ib_alloc_cq().
  *
  * ensure that there are no other contexts that are posting WRs concurrently.
  * Otherwise the drain is not guaranteed.
@@ -2076,8 +2072,7 @@ EXPORT_SYMBOL(ib_drain_rq);
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


--------------2BF86B98961267F0E0BA9464
Content-Type: text/x-patch;
	name="0002-IB-srp-Drain-the-send-queue-before-destroying-a-QP.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0002-IB-srp-Drain-the-send-queue-before-destroying-a-QP.patc";
	filename*1="h"

>From 593d9c8eb7676486dfc7839f6adc5949ce8b4a3c Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Date: Tue, 6 Dec 2016 08:49:11 -0800
Subject: [PATCH 2/2] IB/srp: Drain the send queue before destroying a QP

A quote from the IB spec:

However, if the Consumer does not wait for the Affiliated Asynchronous
Last WQE Reached Event, then WQE and Data Segment leakage may occur.
Therefore, it is good programming practice to tear down a QP that is
associated with an SRQ by using the following process:
* Put the QP in the Error State;
* wait for the Affiliated Asynchronous Last WQE Reached Event;
* either:
  * drain the CQ by invoking the Poll CQ verb and either wait for CQ
    to be empty or the number of Poll CQ operations has exceeded CQ
    capacity size; or
  * post another WR that completes on the same CQ and wait for this WR to return as a WC;
* and then invoke a Destroy QP or Reset QP.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6c8d6847f920..5cc19b2b70c1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -472,7 +472,7 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
  */
 static void srp_destroy_qp(struct ib_qp *qp)
 {
-	ib_drain_rq(qp);
+	ib_drain_qp(qp);
 	ib_destroy_qp(qp);
 }
 
-- 
2.11.0


--------------2BF86B98961267F0E0BA9464--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

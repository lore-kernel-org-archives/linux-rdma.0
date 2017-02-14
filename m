From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Tue, 14 Feb 2017 10:56:36 -0800
Message-ID: <20170214185636.29250-9-bart.vanassche@sandisk.com>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214185636.29250-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b303b4331e98..39bc0f4e1303 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -466,9 +466,13 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
  * completion handler can access the queue pair while it is
  * being destroyed.
  */
-static void srp_destroy_qp(struct ib_qp *qp)
+static void srp_destroy_qp(struct srp_rdma_ch *ch, struct ib_qp *qp)
 {
-	ib_drain_rq(qp);
+	spin_lock_irq(&ch->lock);
+	ib_process_cq_direct(ch->send_cq, -1);
+	spin_unlock_irq(&ch->lock);
+
+	ib_drain_qp(qp);
 	ib_destroy_qp(qp);
 }
 
@@ -542,7 +546,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	}
 
 	if (ch->qp)
-		srp_destroy_qp(ch->qp);
+		srp_destroy_qp(ch, ch->qp);
 	if (ch->recv_cq)
 		ib_free_cq(ch->recv_cq);
 	if (ch->send_cq)
@@ -566,7 +570,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	return 0;
 
 err_qp:
-	srp_destroy_qp(qp);
+	srp_destroy_qp(ch, qp);
 
 err_send_cq:
 	ib_free_cq(send_cq);
@@ -609,7 +613,7 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 			ib_destroy_fmr_pool(ch->fmr_pool);
 	}
 
-	srp_destroy_qp(ch->qp);
+	srp_destroy_qp(ch, ch->qp);
 	ib_free_cq(ch->send_cq);
 	ib_free_cq(ch->recv_cq);
 
@@ -1822,6 +1826,11 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_rdma_ch *ch,
 	return iu;
 }
 
+/*
+ * Note: if this function is called from inside ib_drain_sq() then it will
+ * be called without ch->lock being held. If ib_drain_sq() dequeues a WQE
+ * with status IB_WC_SUCCESS then that's a bug.
+ */
 static void srp_send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct srp_iu *iu = container_of(wc->wr_cqe, struct srp_iu, cqe);
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 3/3] IB/srp: use ib_drain_qp()
Date: Wed, 27 Jan 2016 12:09:47 -0800
Message-ID: <4cb51de7f5449fe1de9db18f2c5d3fa379ccb0ad.1454709317.git.swise@chelsio.com>
References: <cover.1454709317.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1454709317.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 45 ++++++-------------------------------
 1 file changed, 7 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 03022f6..95670ae 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -446,49 +446,17 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
 				  dev->max_pages_per_mr);
 }
 
-static void srp_drain_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct srp_rdma_ch *ch = cq->cq_context;
-
-	complete(&ch->done);
-}
-
-static struct ib_cqe srp_drain_cqe = {
-	.done		= srp_drain_done,
-};
-
 /**
  * srp_destroy_qp() - destroy an RDMA queue pair
  * @ch: SRP RDMA channel.
  *
- * Change a queue pair into the error state and wait until all receive
- * completions have been processed before destroying it. This avoids that
- * the receive completion handler can access the queue pair while it is
+ * Drain the qp before destroying it.  This avoids that the receive
+ * completion handler can access the queue pair while it is
  * being destroyed.
  */
 static void srp_destroy_qp(struct srp_rdma_ch *ch)
 {
-	static struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
-	static struct ib_recv_wr wr = { 0 };
-	struct ib_recv_wr *bad_wr;
-	int ret;
-
-	wr.wr_cqe = &srp_drain_cqe;
-	/* Destroying a QP and reusing ch->done is only safe if not connected */
-	WARN_ON_ONCE(ch->connected);
-
-	ret = ib_modify_qp(ch->qp, &attr, IB_QP_STATE);
-	WARN_ONCE(ret, "ib_cm_init_qp_attr() returned %d\n", ret);
-	if (ret)
-		goto out;
-
-	init_completion(&ch->done);
-	ret = ib_post_recv(ch->qp, &wr, &bad_wr);
-	WARN_ONCE(ret, "ib_post_recv() returned %d\n", ret);
-	if (ret == 0)
-		wait_for_completion(&ch->done);
-
-out:
+	ib_drain_qp(ch->qp);
 	ib_destroy_qp(ch->qp);
 }
 
@@ -508,7 +476,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	if (!init_attr)
 		return -ENOMEM;
 
-	/* queue_size + 1 for ib_drain_qp */
+	/* queue_size + 1 for ib_drain_qp() */
 	recv_cq = ib_alloc_cq(dev->dev, ch, target->queue_size + 1,
 				ch->comp_vector, IB_POLL_SOFTIRQ);
 	if (IS_ERR(recv_cq)) {
@@ -516,7 +484,8 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 		goto err;
 	}
 
-	send_cq = ib_alloc_cq(dev->dev, ch, m * target->queue_size,
+	/* queue_size + 1 for ib_drain_qp() */
+	send_cq = ib_alloc_cq(dev->dev, ch, m * target->queue_size + 1,
 				ch->comp_vector, IB_POLL_DIRECT);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
@@ -524,7 +493,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	}
 
 	init_attr->event_handler       = srp_qp_event;
-	init_attr->cap.max_send_wr     = m * target->queue_size;
+	init_attr->cap.max_send_wr     = m * target->queue_size + 1;
 	init_attr->cap.max_recv_wr     = target->queue_size + 1;
 	init_attr->cap.max_recv_sge    = 1;
 	init_attr->cap.max_send_sge    = 1;
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

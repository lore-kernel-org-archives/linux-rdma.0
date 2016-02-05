From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/3] IB: new common API for draining queues
Date: Fri, 5 Feb 2016 13:13:16 -0800
Message-ID: <3e7261d1436d33320223d365974ff38945f0d558.1455230646.git.swise@chelsio.com>
References: <cover.1455230646.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1455230646.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+p6NamaJ0bNTAL8bYrjMMd8@public.gmane.org>

Add provider-specific drain_sq/drain_rq functions for providers needing
special drain logic.

Add static functions __ib_drain_sq() and __ib_drain_rq() which post noop
WRs to the SQ or RQ and block until their completions are processed.
This ensures the applications completions have all been processed.

Add API functions ib_drain_sq(), ib_drain_rq(), and ib_drain_qp().

Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 144 ++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |   5 ++
 2 files changed, 149 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5af6d02..aed521e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1657,3 +1657,147 @@ next_page:
 	return i;
 }
 EXPORT_SYMBOL(ib_sg_to_pages);
+
+struct ib_drain_cqe {
+	struct ib_cqe cqe;
+	struct completion done;
+};
+
+static void ib_drain_qp_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct ib_drain_cqe *cqe = container_of(wc->wr_cqe, struct ib_drain_cqe,
+						cqe);
+
+	complete(&cqe->done);
+}
+
+static void wait_for_drain(struct ib_cq *cq, struct completion *c)
+{
+	if (cq->poll_ctx == IB_POLL_DIRECT)
+		do
+			ib_process_cq_direct(cq, 1024);
+		while (!wait_for_completion_timeout(c, msecs_to_jiffies(100)));
+	else
+		wait_for_completion(c);
+}
+
+/*
+ * Post a WR and block until its completion is reaped for the SQ.
+ */
+static void __ib_drain_sq(struct ib_qp *qp)
+{
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	struct ib_drain_cqe sdrain;
+	struct ib_send_wr swr = {}, *bad_swr;
+	int ret;
+
+	swr.wr_cqe = &sdrain.cqe;
+	sdrain.cqe.done = ib_drain_qp_done;
+	init_completion(&sdrain.done);
+
+	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
+	if (ret) {
+		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
+		return;
+	}
+
+	ret = ib_post_send(qp, &swr, &bad_swr);
+	if (ret) {
+		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
+		return;
+	}
+
+	wait_for_drain(qp->send_cq, &sdrain.done);
+}
+
+/*
+ * Post a WR and block until its completion is reaped for the RQ.
+ */
+static void __ib_drain_rq(struct ib_qp *qp)
+{
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	struct ib_drain_cqe rdrain;
+	struct ib_recv_wr rwr = {}, *bad_rwr;
+	int ret;
+
+	rwr.wr_cqe = &rdrain.cqe;
+	rdrain.cqe.done = ib_drain_qp_done;
+	init_completion(&rdrain.done);
+
+	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
+	if (ret) {
+		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
+		return;
+	}
+
+	ret = ib_post_recv(qp, &rwr, &bad_rwr);
+	if (ret) {
+		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
+		return;
+	}
+
+	wait_for_drain(qp->recv_cq, &rdrain.done);
+}
+
+/**
+ * ib_drain_sq() - Block until all SQ CQEs have been consumed by the
+ *		   application.
+ * @qp:            queue pair to drain
+ *
+ * If the device has a provider-specific drain function, then
+ * call that.  Otherwise call the generic drain function
+ * __ib_drain_sq().
+ *
+ * The consumer must ensure there is room in the CQ and SQ
+ * for a drain work requests.  Also the consumer must allocate the
+ * CQ using ib_alloc_cq().  It is up to the consumer to handle concurrency
+ * issues if the CQs are using the IB_POLL_DIRECT polling context.
+ */
+void ib_drain_sq(struct ib_qp *qp)
+{
+	if (qp->device->drain_sq)
+		qp->device->drain_sq(qp);
+	else
+		__ib_drain_sq(qp);
+}
+EXPORT_SYMBOL(ib_drain_sq);
+
+/**
+ * ib_drain_rq() - Block until all RQ CQEs have been consumed by the
+ *		   application.
+ * @qp:            queue pair to drain
+ *
+ * If the device has a provider-specific drain function, then
+ * call that.  Otherwise call the generic drain function
+ * __ib_drain_rq().
+ *
+ * The consumer must ensure there is room in the CQ and RQ
+ * for a drain work requests.  Also the consumer must allocate the
+ * CQ using ib_alloc_cq().  It is up to the consumer to handle concurrency
+ * issues if the CQs are using the IB_POLL_DIRECT polling context.
+ */
+void ib_drain_rq(struct ib_qp *qp)
+{
+	if (qp->device->drain_rq)
+		qp->device->drain_rq(qp);
+	else
+		__ib_drain_rq(qp);
+}
+EXPORT_SYMBOL(ib_drain_rq);
+
+/**
+ * ib_drain_qp() - Block until all CQEs have been consumed by the
+ *		   application on both the RQ and SQ.
+ * @qp:            queue pair to drain
+ *
+ * The consumer must ensure there is room in the CQ(s), SQ, and RQ
+ * for a drain work requests.  Also the consumer must allocate the
+ * CQ using ib_alloc_cq().  It is up to the consumer to handle concurrency
+ * issues if the CQs are using the IB_POLL_DIRECT polling context.
+ */
+void ib_drain_qp(struct ib_qp *qp)
+{
+	ib_drain_sq(qp);
+	ib_drain_rq(qp);
+}
+EXPORT_SYMBOL(ib_drain_qp);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 284b00c..68b7e97 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1846,6 +1846,8 @@ struct ib_device {
 	int			   (*check_mr_status)(struct ib_mr *mr, u32 check_mask,
 						      struct ib_mr_status *mr_status);
 	void			   (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
+	void			   (*drain_rq)(struct ib_qp *qp);
+	void			   (*drain_sq)(struct ib_qp *qp);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -3094,4 +3096,7 @@ int ib_sg_to_pages(struct ib_mr *mr,
 		   int sg_nents,
 		   int (*set_page)(struct ib_mr *, u64));
 
+void ib_drain_rq(struct ib_qp *qp);
+void ib_drain_sq(struct ib_qp *qp);
+void ib_drain_qp(struct ib_qp *qp);
 #endif /* IB_VERBS_H */
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

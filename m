From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/3] IB: new common API for draining a queue pair
Date: Fri, 5 Feb 2016 13:13:16 -0800
Message-ID: <2da1db58d642789e8df154e34d622a37295d1ba3.1454709317.git.swise@chelsio.com>
References: <cover.1454709317.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1454709317.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+p6NamaJ0bNTAL8bYrjMMd8@public.gmane.org>

Add provider-specific drain_qp function for providers needing special
drain logic.

Add static function __ib_drain_qp() which posts noop WRs to the RQ and
SQ and blocks until their completions are processed.  This ensures the
applications completions have all been processed.

Add API function ib_drain_qp() which calls the provider-specific drain
if it exists or __ib_drain_qp().

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 72 +++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |  2 ++
 2 files changed, 74 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5af6d02..31b82cd 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1657,3 +1657,75 @@ next_page:
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
+/*
+ * Post a WR and block until its completion is reaped for both the RQ and SQ.
+ */
+static void __ib_drain_qp(struct ib_qp *qp)
+{
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	struct ib_drain_cqe rdrain, sdrain;
+	struct ib_recv_wr rwr = {}, *bad_rwr;
+	struct ib_send_wr swr = {}, *bad_swr;
+	int ret;
+
+	rwr.wr_cqe = &rdrain.cqe;
+	rdrain.cqe.done = ib_drain_qp_done;
+	init_completion(&rdrain.done);
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
+	ret = ib_post_recv(qp, &rwr, &bad_rwr);
+	if (ret) {
+		WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
+		return;
+	}
+
+	ret = ib_post_send(qp, &swr, &bad_swr);
+	if (ret) {
+		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
+		return;
+	}
+
+	wait_for_completion(&rdrain.done);
+	wait_for_completion(&sdrain.done);
+}
+
+/**
+ * ib_drain_qp() - Block until all CQEs have been consumed by the
+ *		   application.
+ * @qp:            queue pair to drain
+ *
+ * If the device has a provider-specific drain function, then
+ * call that.  Otherwise call the generic drain function
+ * __ib_drain_qp().
+ */
+void ib_drain_qp(struct ib_qp *qp)
+{
+	if (qp->device->drain_qp)
+		qp->device->drain_qp(qp);
+	else
+		__ib_drain_qp(qp);
+}
+EXPORT_SYMBOL(ib_drain_qp);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 284b00c..d8533ab 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1846,6 +1846,7 @@ struct ib_device {
 	int			   (*check_mr_status)(struct ib_mr *mr, u32 check_mask,
 						      struct ib_mr_status *mr_status);
 	void			   (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
+	void			   (*drain_qp)(struct ib_qp *qp);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -3094,4 +3095,5 @@ int ib_sg_to_pages(struct ib_mr *mr,
 		   int sg_nents,
 		   int (*set_page)(struct ib_mr *, u64));
 
+void ib_drain_qp(struct ib_qp *qp);
 #endif /* IB_VERBS_H */
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

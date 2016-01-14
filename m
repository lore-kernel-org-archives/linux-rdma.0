From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/3] iw_cxgb4: add queue drain functions
Date: Thu, 14 Jan 2016 10:24:50 -0800
Message-ID: <e41c60cfa9be6800ffbec0a712142bf3cdcda80b.1455230646.git.swise@chelsio.com>
References: <cover.1455230646.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1455230646.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add completion objects, named sq_drained and rq_drained, to the c4iw_qp
struct.  The queue-specific completion object is signaled when the last
CQE is drained from the CQ for that queue.

Add c4iw_drain_sq() to block until qp->rq_drained is completed.

Add c4iw_drain_rq() to block until qp->sq_drained is completed.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c       |  9 ++++++++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  4 ++++
 drivers/infiniband/hw/cxgb4/provider.c |  2 ++
 drivers/infiniband/hw/cxgb4/qp.c       | 16 ++++++++++++++++
 4 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index cf21df4..b4eeb78 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -815,8 +815,15 @@ static int c4iw_poll_cq_one(struct c4iw_cq *chp, struct ib_wc *wc)
 		}
 	}
 out:
-	if (wq)
+	if (wq) {
+		if (unlikely(qhp->attr.state != C4IW_QP_STATE_RTS)) {
+			if (t4_sq_empty(wq))
+				complete(&qhp->sq_drained);
+			if (t4_rq_empty(wq))
+				complete(&qhp->rq_drained);
+		}
 		spin_unlock(&qhp->lock);
+	}
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index fb2de75..7c6a6e1 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -476,6 +476,8 @@ struct c4iw_qp {
 	wait_queue_head_t wait;
 	struct timer_list timer;
 	int sq_sig_all;
+	struct completion rq_drained;
+	struct completion sq_drained;
 };
 
 static inline struct c4iw_qp *to_c4iw_qp(struct ib_qp *ibqp)
@@ -1016,6 +1018,8 @@ extern int c4iw_wr_log;
 extern int db_fc_threshold;
 extern int db_coalescing_threshold;
 extern int use_dsgl;
+void c4iw_drain_rq(struct ib_qp *qp);
+void c4iw_drain_sq(struct ib_qp *qp);
 
 
 #endif
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index ec04272..104662d 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -564,6 +564,8 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.get_protocol_stats = c4iw_get_mib;
 	dev->ibdev.uverbs_abi_ver = C4IW_UVERBS_ABI_VERSION;
 	dev->ibdev.get_port_immutable = c4iw_port_immutable;
+	dev->ibdev.drain_sq = c4iw_drain_sq;
+	dev->ibdev.drain_rq = c4iw_drain_rq;
 
 	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
 	if (!dev->ibdev.iwcm)
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index e99345e..7b1b1e8 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1697,6 +1697,8 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	qhp->attr.max_ird = 0;
 	qhp->sq_sig_all = attrs->sq_sig_type == IB_SIGNAL_ALL_WR;
 	spin_lock_init(&qhp->lock);
+	init_completion(&qhp->sq_drained);
+	init_completion(&qhp->rq_drained);
 	mutex_init(&qhp->mutex);
 	init_waitqueue_head(&qhp->wait);
 	atomic_set(&qhp->refcnt, 1);
@@ -1888,3 +1890,17 @@ int c4iw_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	init_attr->sq_sig_type = qhp->sq_sig_all ? IB_SIGNAL_ALL_WR : 0;
 	return 0;
 }
+
+void c4iw_drain_sq(struct ib_qp *ibqp)
+{
+	struct c4iw_qp *qp = to_c4iw_qp(ibqp);
+
+	wait_for_completion(&qp->sq_drained);
+}
+
+void c4iw_drain_rq(struct ib_qp *ibqp)
+{
+	struct c4iw_qp *qp = to_c4iw_qp(ibqp);
+
+	wait_for_completion(&qp->rq_drained);
+}
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

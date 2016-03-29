From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Adding queue drain functions
Date: Tue, 29 Mar 2016 12:58:37 -0500
Message-ID: <20160329175837.GA9868@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adding sq and rq drain functions, which block until all
previously posted wr-s in the specified queue have completed.
A completion object is signaled to unblock the thread,
when the last cqe for the corresponding queue is processed.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_verbs.h |  2 ++
 2 files changed, 36 insertions(+)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index fba69a3..170d43a 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1315,6 +1315,8 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 			nes_debug(NES_DBG_QP, "Invalid QP type: %d\n", init_attr->qp_type);
 			return ERR_PTR(-EINVAL);
 	}
+	init_completion(&nesqp->sq_drained);
+	init_completion(&nesqp->rq_drained);
 
 	nesqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR);
 	init_timer(&nesqp->terminate_timer);
@@ -3452,6 +3454,29 @@ out:
 	return err;
 }
 
+/**
+ * nes_drain_sq - drain sq
+ * @ibqp: pointer to ibqp
+ */
+static void nes_drain_sq(struct ib_qp *ibqp)
+{
+	struct nes_qp *nesqp = to_nesqp(ibqp);
+
+	if (nesqp->hwqp.sq_tail != nesqp->hwqp.sq_head)
+		wait_for_completion(&nesqp->sq_drained);
+}
+
+/**
+ * nes_drain_rq - drain rq
+ * @ibqp: pointer to ibqp
+ */
+static void nes_drain_rq(struct ib_qp *ibqp)
+{
+	struct nes_qp *nesqp = to_nesqp(ibqp);
+
+	if (nesqp->hwqp.rq_tail != nesqp->hwqp.rq_head)
+		wait_for_completion(&nesqp->rq_drained);
+}
 
 /**
  * nes_poll_cq
@@ -3581,6 +3606,13 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 					wq_tail = nesqp->hwqp.rq_tail;
 				}
 			}
+
+			if (nesqp->iwarp_state > NES_CQP_QP_IWARP_STATE_RTS) {
+				if (nesqp->hwqp.sq_tail == nesqp->hwqp.sq_head)
+					complete(&nesqp->sq_drained);
+				if (nesqp->hwqp.rq_tail == nesqp->hwqp.rq_head)
+					complete(&nesqp->rq_drained);
+			}
 
 			entry->wr_id = wrid;
 			entry++;
@@ -3754,6 +3786,8 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.req_notify_cq = nes_req_notify_cq;
 	nesibdev->ibdev.post_send = nes_post_send;
 	nesibdev->ibdev.post_recv = nes_post_recv;
+	nesibdev->ibdev.drain_sq = nes_drain_sq;
+	nesibdev->ibdev.drain_rq = nes_drain_rq;
 
 	nesibdev->ibdev.iwcm = kzalloc(sizeof(*nesibdev->ibdev.iwcm), GFP_KERNEL);
 	if (nesibdev->ibdev.iwcm == NULL) {
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index 7029088..e02a566 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -189,6 +189,8 @@ struct nes_qp {
 	u8                    pau_pending;
 	u8                    pau_state;
 	__u64                 nesuqp_addr;
+	struct completion     sq_drained;
+	struct completion     rq_drained;
 };
 
 struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

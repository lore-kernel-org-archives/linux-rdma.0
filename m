From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3 16/16] RDMA/i40iw: Adding queue drain functions
Date: Mon, 18 Apr 2016 10:33:09 -0500
Message-ID: <1460993589-9428-17-git-send-email-mustafa.ismail@intel.com>
References: <1460993589-9428-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460993589-9428-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adding sq and rq drain functions, which block until all
previously posted wr-s in the specified queue have completed.
A completion object is signaled to unblock the thread,
when the last cqe for the corresponding queue is processed.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 38 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/i40iw/i40iw_verbs.h |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 196d6f0..bf4e1e3 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -789,6 +789,8 @@ static struct ib_qp *i40iw_create_qp(struct ib_pd *ibpd,
 			return ERR_PTR(err_code);
 		}
 	}
+	init_completion(&iwqp->sq_drained);
+	init_completion(&iwqp->rq_drained);
 
 	return &iwqp->ibqp;
 error:
@@ -1582,6 +1584,32 @@ static int i40iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_ne
 }
 
 /**
+ * i40iw_drain_sq - drain the send queue
+ * @ibqp: ib qp pointer
+ */
+static void i40iw_drain_sq(struct ib_qp *ibqp)
+{
+	struct i40iw_qp *iwqp = to_iwqp(ibqp);
+	struct i40iw_sc_qp *qp = &iwqp->sc_qp;
+
+	if (I40IW_RING_MORE_WORK(qp->qp_uk.sq_ring))
+		wait_for_completion(&iwqp->sq_drained);
+}
+
+/**
+ * i40iw_drain_rq - drain the receive queue
+ * @ibqp: ib qp pointer
+ */
+static void i40iw_drain_rq(struct ib_qp *ibqp)
+{
+	struct i40iw_qp *iwqp = to_iwqp(ibqp);
+	struct i40iw_sc_qp *qp = &iwqp->sc_qp;
+
+	if (I40IW_RING_MORE_WORK(qp->qp_uk.rq_ring))
+		wait_for_completion(&iwqp->rq_drained);
+}
+
+/**
  * i40iw_hwreg_mr - send cqp command for memory registration
  * @iwdev: iwarp device
  * @iwmr: iwarp mr pointer
@@ -2218,6 +2246,7 @@ static int i40iw_poll_cq(struct ib_cq *ibcq,
 	enum i40iw_status_code ret;
 	struct i40iw_cq_uk *ukcq;
 	struct i40iw_sc_qp *qp;
+	struct i40iw_qp *iwqp;
 	unsigned long flags;
 
 	iwcq = (struct i40iw_cq *)ibcq;
@@ -2268,6 +2297,13 @@ static int i40iw_poll_cq(struct ib_cq *ibcq,
 		qp = (struct i40iw_sc_qp *)cq_poll_info.qp_handle;
 		entry->qp = (struct ib_qp *)qp->back_qp;
 		entry->src_qp = cq_poll_info.qp_id;
+		iwqp = (struct i40iw_qp *)qp->back_qp;
+		if (iwqp->iwarp_state > I40IW_QP_STATE_RTS) {
+			if (!I40IW_RING_MORE_WORK(qp->qp_uk.sq_ring))
+				complete(&iwqp->sq_drained);
+			if (!I40IW_RING_MORE_WORK(qp->qp_uk.rq_ring))
+				complete(&iwqp->rq_drained);
+		}
 		entry->byte_len = cq_poll_info.bytes_xfered;
 		entry++;
 		cqe_count++;
@@ -2514,6 +2550,8 @@ static struct i40iw_ib_device *i40iw_init_rdma_device(struct i40iw_device *iwdev
 	iwibdev->ibdev.query_device = i40iw_query_device;
 	iwibdev->ibdev.create_ah = i40iw_create_ah;
 	iwibdev->ibdev.destroy_ah = i40iw_destroy_ah;
+	iwibdev->ibdev.drain_sq = i40iw_drain_sq;
+	iwibdev->ibdev.drain_rq = i40iw_drain_rq;
 	iwibdev->ibdev.alloc_mr = i40iw_alloc_mr;
 	iwibdev->ibdev.map_mr_sg = i40iw_map_mr_sg;
 	iwibdev->ibdev.iwcm = kzalloc(sizeof(*iwibdev->ibdev.iwcm), GFP_KERNEL);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.h b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
index 0acb6c8..0069be8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
@@ -170,5 +170,7 @@ struct i40iw_qp {
 	struct i40iw_pbl *iwpbl;
 	struct i40iw_dma_mem q2_ctx_mem;
 	struct i40iw_dma_mem ietf_mem;
+	struct completion sq_drained;
+	struct completion rq_drained;
 };
 #endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

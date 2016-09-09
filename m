From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 4/6] IB/srpt: use implicit CQ allocation
Date: Fri,  9 Sep 2016 14:36:25 +0200
Message-ID: <1473424587-13818-5-git-send-email-hch@lst.de>
References: <1473424587-13818-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473424587-13818-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
[hch: ported to the new API]
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 46 ++++++++++++-----------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  1 -
 2 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 48a44af..7c1110a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -785,7 +785,7 @@ static int srpt_zerolength_write(struct srpt_rdma_ch *ch)
 
 static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_rdma_ch *ch = wc->qp->qp_context;
 
 	if (wc->status == IB_WC_SUCCESS) {
 		srpt_process_wait_list(ch);
@@ -1188,7 +1188,7 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
  */
 static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_rdma_ch *ch = wc->qp->qp_context;
 	struct srpt_send_ioctx *ioctx =
 		container_of(wc->wr_cqe, struct srpt_send_ioctx, rdma_cqe);
 
@@ -1513,7 +1513,7 @@ out_wait:
 
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_rdma_ch *ch = wc->qp->qp_context;
 	struct srpt_recv_ioctx *ioctx =
 		container_of(wc->wr_cqe, struct srpt_recv_ioctx, ioctx.cqe);
 
@@ -1567,7 +1567,7 @@ static void srpt_process_wait_list(struct srpt_rdma_ch *ch)
  */
 static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_rdma_ch *ch = wc->qp->qp_context;
 	struct srpt_send_ioctx *ioctx =
 		container_of(wc->wr_cqe, struct srpt_send_ioctx, ioctx.cqe);
 	enum srpt_command_state state;
@@ -1613,23 +1613,14 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 		goto out;
 
 retry:
-	ch->cq = ib_alloc_cq(sdev->device, ch, ch->rq_size + srp_sq_size,
-			0 /* XXX: spread CQs */, IB_POLL_WORKQUEUE);
-	if (IS_ERR(ch->cq)) {
-		ret = PTR_ERR(ch->cq);
-		pr_err("failed to create CQ cqe= %d ret= %d\n",
-		       ch->rq_size + srp_sq_size, ret);
-		goto out;
-	}
-
+	qp_init->create_flags = IB_QP_CREATE_ASSIGN_CQS;
 	qp_init->qp_context = (void *)ch;
 	qp_init->event_handler
 		= (void(*)(struct ib_event *, void*))srpt_qp_event;
-	qp_init->send_cq = ch->cq;
-	qp_init->recv_cq = ch->cq;
 	qp_init->srq = sdev->srq;
 	qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_init->qp_type = IB_QPT_RC;
+	qp_init->poll_ctx = IB_POLL_WORKQUEUE;
 	/*
 	 * We divide up our send queue size into half SEND WRs to send the
 	 * completions, and half R/W contexts to actually do the RDMA
@@ -1640,6 +1631,9 @@ retry:
 	qp_init->cap.max_send_wr = srp_sq_size / 2;
 	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
 	qp_init->cap.max_send_sge = min(attrs->max_sge, SRPT_MAX_SG_PER_WQE);
+
+	qp_init->cap.max_recv_wr = ch->rq_size;
+
 	qp_init->port_num = ch->sport->port;
 
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
@@ -1647,19 +1641,17 @@ retry:
 		ret = PTR_ERR(ch->qp);
 		if (ret == -ENOMEM) {
 			srp_sq_size /= 2;
-			if (srp_sq_size >= MIN_SRPT_SQ_SIZE) {
-				ib_destroy_cq(ch->cq);
+			if (srp_sq_size >= MIN_SRPT_SQ_SIZE)
 				goto retry;
-			}
 		}
 		pr_err("failed to create_qp ret= %d\n", ret);
-		goto err_destroy_cq;
+		goto out;
 	}
 
 	atomic_set(&ch->sq_wr_avail, qp_init->cap.max_send_wr);
 
-	pr_debug("%s: max_cqe= %d max_sge= %d sq_size = %d cm_id= %p\n",
-		 __func__, ch->cq->cqe, qp_init->cap.max_send_sge,
+	pr_debug("%s: max_sge= %d sq_size = %d cm_id= %p\n",
+		 __func__, qp_init->cap.max_send_sge,
 		 qp_init->cap.max_send_wr, ch->cm_id);
 
 	ret = srpt_init_ch_qp(ch, ch->qp);
@@ -1672,17 +1664,9 @@ out:
 
 err_destroy_qp:
 	ib_destroy_qp(ch->qp);
-err_destroy_cq:
-	ib_free_cq(ch->cq);
 	goto out;
 }
 
-static void srpt_destroy_ch_ib(struct srpt_rdma_ch *ch)
-{
-	ib_destroy_qp(ch->qp);
-	ib_free_cq(ch->cq);
-}
-
 /**
  * srpt_close_ch() - Close an RDMA channel.
  *
@@ -1799,7 +1783,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 
 	ib_destroy_cm_id(ch->cm_id);
 
-	srpt_destroy_ch_ib(ch);
+	ib_destroy_qp(ch->qp);
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
 			     ch->sport->sdev, ch->rq_size,
@@ -2056,7 +2040,7 @@ release_channel:
 	ch->sess = NULL;
 
 destroy_ib:
-	srpt_destroy_ch_ib(ch);
+	ib_destroy_qp(ch->qp);
 
 free_ring:
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 5818787..162eb11 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -264,7 +264,6 @@ enum rdma_ch_state {
 struct srpt_rdma_ch {
 	struct ib_cm_id		*cm_id;
 	struct ib_qp		*qp;
-	struct ib_cq		*cq;
 	struct ib_cqe		zw_cqe;
 	struct kref		kref;
 	int			rq_size;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v3 4/9] IB/srpt: use implicit CQ allocation
Date: Wed,  8 Nov 2017 11:57:37 +0200
Message-ID: <20171108095742.25365-5-sagi@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
[hch: ported to the new API]
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 46 ++++++++++++-----------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  1 -
 2 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9e8e9220f816..256d0d5b32e5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -798,7 +798,7 @@ static int srpt_zerolength_write(struct srpt_rdma_ch *ch)
 
 static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_rdma_ch *ch = wc->qp->qp_context;
 
 	if (wc->status == IB_WC_SUCCESS) {
 		srpt_process_wait_list(ch);
@@ -1201,7 +1201,7 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
  */
 static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_rdma_ch *ch = wc->qp->qp_context;
 	struct srpt_send_ioctx *ioctx =
 		container_of(wc->wr_cqe, struct srpt_send_ioctx, rdma_cqe);
 
@@ -1526,7 +1526,7 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_rdma_ch *ch = wc->qp->qp_context;
 	struct srpt_recv_ioctx *ioctx =
 		container_of(wc->wr_cqe, struct srpt_recv_ioctx, ioctx.cqe);
 
@@ -1580,7 +1580,7 @@ static void srpt_process_wait_list(struct srpt_rdma_ch *ch)
  */
 static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_rdma_ch *ch = wc->qp->qp_context;
 	struct srpt_send_ioctx *ioctx =
 		container_of(wc->wr_cqe, struct srpt_send_ioctx, ioctx.cqe);
 	enum srpt_command_state state;
@@ -1626,23 +1626,14 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
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
@@ -1653,6 +1644,9 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	qp_init->cap.max_send_wr = srp_sq_size / 2;
 	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
 	qp_init->cap.max_send_sge = min(attrs->max_sge, SRPT_MAX_SG_PER_WQE);
+
+	qp_init->cap.max_recv_wr = ch->rq_size;
+
 	qp_init->port_num = ch->sport->port;
 
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
@@ -1660,19 +1654,17 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
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
@@ -1685,17 +1677,9 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 
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
@@ -1812,7 +1796,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 
 	ib_destroy_cm_id(ch->cm_id);
 
-	srpt_destroy_ch_ib(ch);
+	ib_destroy_qp(ch->qp);
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
 			     ch->sport->sdev, ch->rq_size,
@@ -2070,7 +2054,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	ch->sess = NULL;
 
 destroy_ib:
-	srpt_destroy_ch_ib(ch);
+	ib_destroy_qp(ch->qp);
 
 free_ring:
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 1b817e51b84b..4ab0d94af174 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -265,7 +265,6 @@ enum rdma_ch_state {
 struct srpt_rdma_ch {
 	struct ib_cm_id		*cm_id;
 	struct ib_qp		*qp;
-	struct ib_cq		*cq;
 	struct ib_cqe		zw_cqe;
 	struct kref		kref;
 	int			rq_size;
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

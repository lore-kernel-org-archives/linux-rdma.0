From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/6] nvmet-rdma: use implicit CQ allocation
Date: Fri,  9 Sep 2016 14:36:23 +0200
Message-ID: <1473424587-13818-3-git-send-email-hch@lst.de>
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
 drivers/nvme/target/rdma.c | 67 ++++++++++++----------------------------------
 1 file changed, 17 insertions(+), 50 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 187763a..fc7ed0a 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -83,7 +83,6 @@ enum nvmet_rdma_queue_state {
 struct nvmet_rdma_queue {
 	struct rdma_cm_id	*cm_id;
 	struct nvmet_port	*port;
-	struct ib_cq		*cq;
 	atomic_t		sq_wr_avail;
 	struct nvmet_rdma_device *dev;
 	spinlock_t		state_lock;
@@ -548,7 +547,7 @@ static void nvmet_rdma_read_data_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct nvmet_rdma_rsp *rsp =
 		container_of(wc->wr_cqe, struct nvmet_rdma_rsp, read_cqe);
-	struct nvmet_rdma_queue *queue = cq->cq_context;
+	struct nvmet_rdma_queue *queue = wc->qp->qp_context;
 
 	WARN_ON(rsp->n_rdma <= 0);
 	atomic_add(rsp->n_rdma, &queue->sq_wr_avail);
@@ -722,7 +721,7 @@ static void nvmet_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct nvmet_rdma_cmd *cmd =
 		container_of(wc->wr_cqe, struct nvmet_rdma_cmd, cqe);
-	struct nvmet_rdma_queue *queue = cq->cq_context;
+	struct nvmet_rdma_queue *queue = wc->qp->qp_context;
 	struct nvmet_rdma_rsp *rsp;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
@@ -877,62 +876,41 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 {
 	struct ib_qp_init_attr qp_attr;
 	struct nvmet_rdma_device *ndev = queue->dev;
-	int comp_vector, nr_cqe, ret, i;
-
-	/*
-	 * Spread the io queues across completion vectors,
-	 * but still keep all admin queues on vector 0.
-	 */
-	comp_vector = !queue->host_qid ? 0 :
-		queue->idx % ndev->device->num_comp_vectors;
-
-	/*
-	 * Reserve CQ slots for RECV + RDMA_READ/RDMA_WRITE + RDMA_SEND.
-	 */
-	nr_cqe = queue->recv_queue_size + 2 * queue->send_queue_size;
-
-	queue->cq = ib_alloc_cq(ndev->device, queue,
-			nr_cqe + 1, comp_vector,
-			IB_POLL_WORKQUEUE);
-	if (IS_ERR(queue->cq)) {
-		ret = PTR_ERR(queue->cq);
-		pr_err("failed to create CQ cqe= %d ret= %d\n",
-		       nr_cqe + 1, ret);
-		goto out;
-	}
+	int ret, i;
 
 	memset(&qp_attr, 0, sizeof(qp_attr));
+	qp_attr.create_flags = IB_QP_CREATE_ASSIGN_CQS;
 	qp_attr.qp_context = queue;
 	qp_attr.event_handler = nvmet_rdma_qp_event;
-	qp_attr.send_cq = queue->cq;
-	qp_attr.recv_cq = queue->cq;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_attr.qp_type = IB_QPT_RC;
+	qp_attr.poll_ctx = IB_POLL_WORKQUEUE;
+
 	/* +1 for drain */
 	qp_attr.cap.max_send_wr = queue->send_queue_size + 1;
 	qp_attr.cap.max_rdma_ctxs = queue->send_queue_size;
 	qp_attr.cap.max_send_sge = max(ndev->device->attrs.max_sge_rd,
 					ndev->device->attrs.max_sge);
 
-	if (ndev->srq) {
+	/* +1 for drain */
+	qp_attr.cap.max_recv_wr = queue->recv_queue_size + 1;
+
+	if (ndev->srq)
 		qp_attr.srq = ndev->srq;
-	} else {
-		/* +1 for drain */
-		qp_attr.cap.max_recv_wr = 1 + queue->recv_queue_size;
+	else
 		qp_attr.cap.max_recv_sge = 2;
-	}
 
 	ret = rdma_create_qp(queue->cm_id, ndev->pd, &qp_attr);
 	if (ret) {
 		pr_err("failed to create_qp ret= %d\n", ret);
-		goto err_destroy_cq;
+		return ret;
 	}
 
 	atomic_set(&queue->sq_wr_avail, qp_attr.cap.max_send_wr);
 
-	pr_debug("%s: max_cqe= %d max_sge= %d sq_size = %d cm_id= %p\n",
-		 __func__, queue->cq->cqe, qp_attr.cap.max_send_sge,
-		 qp_attr.cap.max_send_wr, queue->cm_id);
+	pr_debug("%s: max_sge= %d sq_size = %d cm_id=%p\n", __func__,
+		qp_attr.cap.max_send_sge, qp_attr.cap.max_send_wr,
+		queue->cm_id);
 
 	if (!ndev->srq) {
 		for (i = 0; i < queue->recv_queue_size; i++) {
@@ -941,18 +919,7 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 		}
 	}
 
-out:
-	return ret;
-
-err_destroy_cq:
-	ib_free_cq(queue->cq);
-	goto out;
-}
-
-static void nvmet_rdma_destroy_queue_ib(struct nvmet_rdma_queue *queue)
-{
-	rdma_destroy_qp(queue->cm_id);
-	ib_free_cq(queue->cq);
+	return 0;
 }
 
 static void nvmet_rdma_free_queue(struct nvmet_rdma_queue *queue)
@@ -961,7 +928,7 @@ static void nvmet_rdma_free_queue(struct nvmet_rdma_queue *queue)
 
 	nvmet_sq_destroy(&queue->nvme_sq);
 
-	nvmet_rdma_destroy_queue_ib(queue);
+	rdma_destroy_qp(queue->cm_id);
 	if (!queue->dev->srq) {
 		nvmet_rdma_free_cmds(queue->dev, queue->cmds,
 				queue->recv_queue_size,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

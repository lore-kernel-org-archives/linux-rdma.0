From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 6/6] nvme-rdma: use implicit CQ allocation
Date: Fri,  9 Sep 2016 14:36:27 +0200
Message-ID: <1473424587-13818-7-git-send-email-hch@lst.de>
References: <1473424587-13818-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473424587-13818-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 70 +++++++++++++++++++-----------------------------
 1 file changed, 28 insertions(+), 42 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 1a18547..e8f343f 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -95,7 +95,6 @@ struct nvme_rdma_queue {
 	size_t			cmnd_capsule_len;
 	struct nvme_rdma_ctrl	*ctrl;
 	struct nvme_rdma_device	*device;
-	struct ib_cq		*ib_cq;
 	struct ib_qp		*qp;
 
 	unsigned long		flags;
@@ -253,24 +252,38 @@ static int nvme_rdma_wait_for_cm(struct nvme_rdma_queue *queue)
 	return queue->cm_error;
 }
 
-static int nvme_rdma_create_qp(struct nvme_rdma_queue *queue, const int factor)
+static int nvme_rdma_create_qp(struct nvme_rdma_queue *queue)
 {
 	struct nvme_rdma_device *dev = queue->device;
 	struct ib_qp_init_attr init_attr;
-	int ret;
+	int ret, idx;
+	const int send_wr_factor = 3;		/* MR, SEND, INV */
 
 	memset(&init_attr, 0, sizeof(init_attr));
+	init_attr.create_flags = IB_QP_CREATE_ASSIGN_CQS;
 	init_attr.event_handler = nvme_rdma_qp_event;
+	init_attr.qp_context = queue;
+	init_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
+	init_attr.qp_type = IB_QPT_RC;
+	init_attr.poll_ctx = IB_POLL_SOFTIRQ;
+
 	/* +1 for drain */
-	init_attr.cap.max_send_wr = factor * queue->queue_size + 1;
+	init_attr.cap.max_send_wr = send_wr_factor * queue->queue_size + 1;
+	init_attr.cap.max_send_sge = 1 + NVME_RDMA_MAX_INLINE_SEGMENTS;
+
 	/* +1 for drain */
 	init_attr.cap.max_recv_wr = queue->queue_size + 1;
 	init_attr.cap.max_recv_sge = 1;
-	init_attr.cap.max_send_sge = 1 + NVME_RDMA_MAX_INLINE_SEGMENTS;
-	init_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
-	init_attr.qp_type = IB_QPT_RC;
-	init_attr.send_cq = queue->ib_cq;
-	init_attr.recv_cq = queue->ib_cq;
+
+	/*
+	 * The admin queue is barely used once the controller is live, so don't
+	 * bother to spread it out.
+	 */
+	idx = nvme_rdma_queue_idx(queue);
+	if (idx > 0) {
+		init_attr.comp_vector = idx;
+		init_attr.create_flags |= IB_QP_CREATE_COMP_VECTOR;
+	}
 
 	ret = rdma_create_qp(queue->cm_id, dev->pd, &init_attr);
 
@@ -474,7 +487,6 @@ static void nvme_rdma_destroy_queue_ib(struct nvme_rdma_queue *queue)
 	struct ib_device *ibdev = dev->dev;
 
 	rdma_destroy_qp(queue->cm_id);
-	ib_free_cq(queue->ib_cq);
 
 	nvme_rdma_free_ring(ibdev, queue->rsp_ring, queue->queue_size,
 			sizeof(struct nvme_completion), DMA_FROM_DEVICE);
@@ -485,39 +497,15 @@ static void nvme_rdma_destroy_queue_ib(struct nvme_rdma_queue *queue)
 static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue,
 		struct nvme_rdma_device *dev)
 {
-	struct ib_device *ibdev = dev->dev;
-	const int send_wr_factor = 3;			/* MR, SEND, INV */
-	const int cq_factor = send_wr_factor + 1;	/* + RECV */
-	int comp_vector, idx = nvme_rdma_queue_idx(queue);
-
 	int ret;
 
 	queue->device = dev;
 
-	/*
-	 * The admin queue is barely used once the controller is live, so don't
-	 * bother to spread it out.
-	 */
-	if (idx == 0)
-		comp_vector = 0;
-	else
-		comp_vector = idx % ibdev->num_comp_vectors;
-
-
-	/* +1 for ib_stop_cq */
-	queue->ib_cq = ib_alloc_cq(dev->dev, queue,
-				cq_factor * queue->queue_size + 1, comp_vector,
-				IB_POLL_SOFTIRQ);
-	if (IS_ERR(queue->ib_cq)) {
-		ret = PTR_ERR(queue->ib_cq);
-		goto out;
-	}
-
-	ret = nvme_rdma_create_qp(queue, send_wr_factor);
+	ret = nvme_rdma_create_qp(queue);
 	if (ret)
-		goto out_destroy_ib_cq;
+		goto out;
 
-	queue->rsp_ring = nvme_rdma_alloc_ring(ibdev, queue->queue_size,
+	queue->rsp_ring = nvme_rdma_alloc_ring(dev->dev, queue->queue_size,
 			sizeof(struct nvme_completion), DMA_FROM_DEVICE);
 	if (!queue->rsp_ring) {
 		ret = -ENOMEM;
@@ -528,8 +516,6 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue,
 
 out_destroy_qp:
 	ib_destroy_qp(queue->qp);
-out_destroy_ib_cq:
-	ib_free_cq(queue->ib_cq);
 out:
 	return ret;
 }
@@ -781,7 +767,7 @@ static void nvme_rdma_error_recovery(struct nvme_rdma_ctrl *ctrl)
 static void nvme_rdma_wr_error(struct ib_cq *cq, struct ib_wc *wc,
 		const char *op)
 {
-	struct nvme_rdma_queue *queue = cq->cq_context;
+	struct nvme_rdma_queue *queue = wc->qp->qp_context;
 	struct nvme_rdma_ctrl *ctrl = queue->ctrl;
 
 	if (ctrl->ctrl.state == NVME_CTRL_LIVE)
@@ -1141,7 +1127,7 @@ static int __nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc, int tag)
 {
 	struct nvme_rdma_qe *qe =
 		container_of(wc->wr_cqe, struct nvme_rdma_qe, cqe);
-	struct nvme_rdma_queue *queue = cq->cq_context;
+	struct nvme_rdma_queue *queue = wc->qp->qp_context;
 	struct ib_device *ibdev = queue->device->dev;
 	struct nvme_completion *cqe = qe->data;
 	const size_t len = sizeof(struct nvme_completion);
@@ -1461,7 +1447,7 @@ err:
 static int nvme_rdma_poll(struct blk_mq_hw_ctx *hctx, unsigned int tag)
 {
 	struct nvme_rdma_queue *queue = hctx->driver_data;
-	struct ib_cq *cq = queue->ib_cq;
+	struct ib_cq *cq = queue->cm_id->qp->recv_cq;
 	struct ib_wc wc;
 	int found = 0;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

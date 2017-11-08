From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v3 6/9] nvme-rdma: use implicit CQ allocation
Date: Wed,  8 Nov 2017 11:57:39 +0200
Message-ID: <20171108095742.25365-7-sagi@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 62 +++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 32e21ab1ae52..3acf4d1ccfed 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -90,7 +90,6 @@ struct nvme_rdma_queue {
 	size_t			cmnd_capsule_len;
 	struct nvme_rdma_ctrl	*ctrl;
 	struct nvme_rdma_device	*device;
-	struct ib_cq		*ib_cq;
 	struct ib_qp		*qp;
 
 	unsigned long		flags;
@@ -241,24 +240,38 @@ static int nvme_rdma_wait_for_cm(struct nvme_rdma_queue *queue)
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
+		init_attr.affinity_hint = idx;
+		init_attr.create_flags |= IB_QP_CREATE_AFFINITY_HINT;
+	}
 
 	ret = rdma_create_qp(queue->cm_id, dev->pd, &init_attr);
 
@@ -440,7 +453,6 @@ static void nvme_rdma_destroy_queue_ib(struct nvme_rdma_queue *queue)
 	struct ib_device *ibdev = dev->dev;
 
 	rdma_destroy_qp(queue->cm_id);
-	ib_free_cq(queue->ib_cq);
 
 	nvme_rdma_free_ring(ibdev, queue->rsp_ring, queue->queue_size,
 			sizeof(struct nvme_completion), DMA_FROM_DEVICE);
@@ -451,9 +463,6 @@ static void nvme_rdma_destroy_queue_ib(struct nvme_rdma_queue *queue)
 static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 {
 	struct ib_device *ibdev;
-	const int send_wr_factor = 3;			/* MR, SEND, INV */
-	const int cq_factor = send_wr_factor + 1;	/* + RECV */
-	int comp_vector, idx = nvme_rdma_queue_idx(queue);
 	int ret;
 
 	queue->device = nvme_rdma_find_get_device(queue->cm_id);
@@ -464,24 +473,9 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 	}
 	ibdev = queue->device->dev;
 
-	/*
-	 * Spread I/O queues completion vectors according their queue index.
-	 * Admin queues can always go on completion vector 0.
-	 */
-	comp_vector = idx == 0 ? idx : idx - 1;
-
-	/* +1 for ib_stop_cq */
-	queue->ib_cq = ib_alloc_cq(ibdev, queue,
-				cq_factor * queue->queue_size + 1,
-				comp_vector, IB_POLL_SOFTIRQ);
-	if (IS_ERR(queue->ib_cq)) {
-		ret = PTR_ERR(queue->ib_cq);
-		goto out_put_dev;
-	}
-
-	ret = nvme_rdma_create_qp(queue, send_wr_factor);
+	ret = nvme_rdma_create_qp(queue);
 	if (ret)
-		goto out_destroy_ib_cq;
+		goto out_put_dev;
 
 	queue->rsp_ring = nvme_rdma_alloc_ring(ibdev, queue->queue_size,
 			sizeof(struct nvme_completion), DMA_FROM_DEVICE);
@@ -494,8 +488,6 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 
 out_destroy_qp:
 	rdma_destroy_qp(queue->cm_id);
-out_destroy_ib_cq:
-	ib_free_cq(queue->ib_cq);
 out_put_dev:
 	nvme_rdma_dev_put(queue->device);
 	return ret;
@@ -999,7 +991,7 @@ static void nvme_rdma_error_recovery(struct nvme_rdma_ctrl *ctrl)
 static void nvme_rdma_wr_error(struct ib_cq *cq, struct ib_wc *wc,
 		const char *op)
 {
-	struct nvme_rdma_queue *queue = cq->cq_context;
+	struct nvme_rdma_queue *queue = wc->qp->qp_context;
 	struct nvme_rdma_ctrl *ctrl = queue->ctrl;
 
 	if (ctrl->ctrl.state == NVME_CTRL_LIVE)
@@ -1361,7 +1353,7 @@ static int __nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc, int tag)
 {
 	struct nvme_rdma_qe *qe =
 		container_of(wc->wr_cqe, struct nvme_rdma_qe, cqe);
-	struct nvme_rdma_queue *queue = cq->cq_context;
+	struct nvme_rdma_queue *queue = wc->qp->qp_context;
 	struct ib_device *ibdev = queue->device->dev;
 	struct nvme_completion *cqe = qe->data;
 	const size_t len = sizeof(struct nvme_completion);
@@ -1678,7 +1670,7 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 static int nvme_rdma_poll(struct blk_mq_hw_ctx *hctx, unsigned int tag)
 {
 	struct nvme_rdma_queue *queue = hctx->driver_data;
-	struct ib_cq *cq = queue->ib_cq;
+	struct ib_cq *cq = queue->cm_id->qp->recv_cq;
 	struct ib_wc wc;
 	int found = 0;
 
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

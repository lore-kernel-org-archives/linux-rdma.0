From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2 1/3] nvme-rdma: don't suppress send completions
Date: Wed,  8 Nov 2017 12:06:14 +0200
Message-ID: <20171108100616.26605-2-sagi@grimberg.me>
References: <20171108100616.26605-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108100616.26605-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The entire completions suppress mechanism is currently
broken because the HCA might retry a send operation
(due to dropped ack) after the nvme transaction has completed.

In order to handle this, we signal all send completions (besides
async event which is not racing anything).

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 42 ++++--------------------------------------
 1 file changed, 4 insertions(+), 38 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ef7d27b63088..c765f1d20141 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -85,7 +85,6 @@ enum nvme_rdma_queue_flags {
 
 struct nvme_rdma_queue {
 	struct nvme_rdma_qe	*rsp_ring;
-	atomic_t		sig_count;
 	int			queue_size;
 	size_t			cmnd_capsule_len;
 	struct nvme_rdma_ctrl	*ctrl;
@@ -510,7 +509,6 @@ static int nvme_rdma_alloc_queue(struct nvme_rdma_ctrl *ctrl,
 		queue->cmnd_capsule_len = sizeof(struct nvme_command);
 
 	queue->queue_size = queue_size;
-	atomic_set(&queue->sig_count, 0);
 
 	queue->cm_id = rdma_create_id(&init_net, nvme_rdma_cm_handler, queue,
 			RDMA_PS_TCP, IB_QPT_RC);
@@ -1196,21 +1194,9 @@ static void nvme_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
 		nvme_rdma_wr_error(cq, wc, "SEND");
 }
 
-/*
- * We want to signal completion at least every queue depth/2.  This returns the
- * largest power of two that is not above half of (queue size + 1) to optimize
- * (avoid divisions).
- */
-static inline bool nvme_rdma_queue_sig_limit(struct nvme_rdma_queue *queue)
-{
-	int limit = 1 << ilog2((queue->queue_size + 1) / 2);
-
-	return (atomic_inc_return(&queue->sig_count) & (limit - 1)) == 0;
-}
-
 static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
 		struct nvme_rdma_qe *qe, struct ib_sge *sge, u32 num_sge,
-		struct ib_send_wr *first, bool flush)
+		struct ib_send_wr *first)
 {
 	struct ib_send_wr wr, *bad_wr;
 	int ret;
@@ -1226,24 +1212,7 @@ static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
 	wr.sg_list    = sge;
 	wr.num_sge    = num_sge;
 	wr.opcode     = IB_WR_SEND;
-	wr.send_flags = 0;
-
-	/*
-	 * Unsignalled send completions are another giant desaster in the
-	 * IB Verbs spec:  If we don't regularly post signalled sends
-	 * the send queue will fill up and only a QP reset will rescue us.
-	 * Would have been way to obvious to handle this in hardware or
-	 * at least the RDMA stack..
-	 *
-	 * Always signal the flushes. The magic request used for the flush
-	 * sequencer is not allocated in our driver's tagset and it's
-	 * triggered to be freed by blk_cleanup_queue(). So we need to
-	 * always mark it as signaled to ensure that the "wr_cqe", which is
-	 * embedded in request's payload, is not freed when __ib_process_cq()
-	 * calls wr_cqe->done().
-	 */
-	if (nvme_rdma_queue_sig_limit(queue) || flush)
-		wr.send_flags |= IB_SEND_SIGNALED;
+	wr.send_flags = IB_SEND_SIGNALED;
 
 	if (first)
 		first->next = &wr;
@@ -1317,7 +1286,7 @@ static void nvme_rdma_submit_async_event(struct nvme_ctrl *arg, int aer_idx)
 	ib_dma_sync_single_for_device(dev, sqe->dma, sizeof(*cmd),
 			DMA_TO_DEVICE);
 
-	ret = nvme_rdma_post_send(queue, sqe, &sge, 1, NULL, false);
+	ret = nvme_rdma_post_send(queue, sqe, &sge, 1, NULL);
 	WARN_ON_ONCE(ret);
 }
 
@@ -1602,7 +1571,6 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
 	struct nvme_rdma_qe *sqe = &req->sqe;
 	struct nvme_command *c = sqe->data;
-	bool flush = false;
 	struct ib_device *dev;
 	blk_status_t ret;
 	int err;
@@ -1634,10 +1602,8 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	ib_dma_sync_single_for_device(dev, sqe->dma,
 			sizeof(struct nvme_command), DMA_TO_DEVICE);
 
-	if (req_op(rq) == REQ_OP_FLUSH)
-		flush = true;
 	err = nvme_rdma_post_send(queue, sqe, req->sge, req->num_sge,
-			req->mr->need_inval ? &req->reg_wr.wr : NULL, flush);
+			req->mr->need_inval ? &req->reg_wr.wr : NULL);
 	if (unlikely(err)) {
 		nvme_rdma_unmap_data(queue, rq);
 		goto err;
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

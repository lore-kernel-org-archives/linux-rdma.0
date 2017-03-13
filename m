From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH] nvmet-rdma: Fix a possible uninitialized variable dereference
Date: Mon, 13 Mar 2017 13:05:35 +0200
Message-ID: <1489403135-12774-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When handling a new recv command, we grab a new rsp resource and
check for the queue state being live. In case the queue is not in
live state, we simply restore the rsp back to the free list. However
in this flow we didn't set rsp->queue yet, so we cannot dereference it.

Instead, get rid of rsp->queue, because we already have rsp->cmd
reference which has a queue reference already, so use that instead.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/target/rdma.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 9aa1da3778b3..2827271c2111 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -58,7 +58,6 @@ struct nvmet_rdma_rsp {
 	struct ib_send_wr	send_wr;
 
 	struct nvmet_rdma_cmd	*cmd;
-	struct nvmet_rdma_queue	*queue;
 
 	struct ib_cqe		read_cqe;
 	struct rdma_rw_ctx	rw;
@@ -180,9 +179,9 @@ nvmet_rdma_put_rsp(struct nvmet_rdma_rsp *rsp)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&rsp->queue->rsps_lock, flags);
-	list_add_tail(&rsp->free_list, &rsp->queue->free_rsps);
-	spin_unlock_irqrestore(&rsp->queue->rsps_lock, flags);
+	spin_lock_irqsave(&rsp->cmd->queue->rsps_lock, flags);
+	list_add_tail(&rsp->free_list, &rsp->cmd->queue->free_rsps);
+	spin_unlock_irqrestore(&rsp->cmd->queue->rsps_lock, flags);
 }
 
 static void nvmet_rdma_free_sgl(struct scatterlist *sgl, unsigned int nents)
@@ -473,7 +472,7 @@ static void nvmet_rdma_process_wr_wait_list(struct nvmet_rdma_queue *queue)
 
 static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
 {
-	struct nvmet_rdma_queue *queue = rsp->queue;
+	struct nvmet_rdma_queue *queue = rsp->cmd->queue;
 
 	atomic_add(1 + rsp->n_rdma, &queue->sq_wr_avail);
 
@@ -517,7 +516,7 @@ static void nvmet_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
 		     wc->status != IB_WC_WR_FLUSH_ERR)) {
 		pr_err("SEND for CQE 0x%p failed with status %s (%d).\n",
 			wc->wr_cqe, ib_wc_status_msg(wc->status), wc->status);
-		nvmet_rdma_error_comp(rsp->queue);
+		nvmet_rdma_error_comp(rsp->cmd->queue);
 	}
 }
 
@@ -525,7 +524,7 @@ static void nvmet_rdma_queue_response(struct nvmet_req *req)
 {
 	struct nvmet_rdma_rsp *rsp =
 		container_of(req, struct nvmet_rdma_rsp, req);
-	struct rdma_cm_id *cm_id = rsp->queue->cm_id;
+	struct rdma_cm_id *cm_id = rsp->cmd->queue->cm_id;
 	struct ib_send_wr *first_wr, *bad_wr;
 
 	if (rsp->flags & NVMET_RDMA_REQ_INVALIDATE_RKEY) {
@@ -541,9 +540,9 @@ static void nvmet_rdma_queue_response(struct nvmet_req *req)
 	else
 		first_wr = &rsp->send_wr;
 
-	nvmet_rdma_post_recv(rsp->queue->dev, rsp->cmd);
+	nvmet_rdma_post_recv(rsp->cmd->queue->dev, rsp->cmd);
 
-	ib_dma_sync_single_for_device(rsp->queue->dev->device,
+	ib_dma_sync_single_for_device(rsp->cmd->queue->dev->device,
 		rsp->send_sge.addr, rsp->send_sge.length,
 		DMA_TO_DEVICE);
 
@@ -614,7 +613,7 @@ static u16 nvmet_rdma_map_sgl_inline(struct nvmet_rdma_rsp *rsp)
 static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_rsp *rsp,
 		struct nvme_keyed_sgl_desc *sgl, bool invalidate)
 {
-	struct rdma_cm_id *cm_id = rsp->queue->cm_id;
+	struct rdma_cm_id *cm_id = rsp->cmd->queue->cm_id;
 	u64 addr = le64_to_cpu(sgl->addr);
 	u32 len = get_unaligned_le24(sgl->length);
 	u32 key = get_unaligned_le32(sgl->key);
@@ -676,7 +675,7 @@ static u16 nvmet_rdma_map_sgl(struct nvmet_rdma_rsp *rsp)
 
 static bool nvmet_rdma_execute_command(struct nvmet_rdma_rsp *rsp)
 {
-	struct nvmet_rdma_queue *queue = rsp->queue;
+	struct nvmet_rdma_queue *queue = rsp->cmd->queue;
 
 	if (unlikely(atomic_sub_return(1 + rsp->n_rdma,
 			&queue->sq_wr_avail) < 0)) {
@@ -703,11 +702,6 @@ static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
 {
 	u16 status;
 
-	cmd->queue = queue;
-	cmd->n_rdma = 0;
-	cmd->req.port = queue->port;
-
-
 	ib_dma_sync_single_for_cpu(queue->dev->device,
 		cmd->cmd->sge[0].addr, cmd->cmd->sge[0].length,
 		DMA_FROM_DEVICE);
@@ -763,6 +757,8 @@ static void nvmet_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	rsp->cmd = cmd;
 	rsp->flags = 0;
 	rsp->req.cmd = cmd->nvme_cmd;
+	rsp->n_rdma = 0;
+	rsp->req.port = queue->port;
 
 	if (unlikely(queue->state != NVMET_RDMA_Q_LIVE)) {
 		unsigned long flags;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

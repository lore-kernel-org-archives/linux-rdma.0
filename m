From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH 2/3] nvme-rdma: don't complete requests before a send work request has completed
Date: Tue, 31 Oct 2017 10:55:21 +0200
Message-ID: <1509440122-1190-3-git-send-email-sagi@grimberg.me>
References: <1509440122-1190-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509440122-1190-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to guarantee that the HCA will never get an access violation
(either from invalidated rkey or from iommu) when retrying a send
operation we must complete a request only when both send completion
and the nvme cqe has arrived.

Only then we are safe to invalidate the rkey (if needed), unmap
the host buffers, and complete the IO.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ccbae327fe72..ae1fb66358f7 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -67,6 +67,9 @@ struct nvme_rdma_request {
 	struct nvme_request	req;
 	struct ib_mr		*mr;
 	struct nvme_rdma_qe	sqe;
+	struct nvme_completion	cqe;
+	bool			send_completed;
+	bool			resp_completed;
 	struct ib_sge		sge[1 + NVME_RDMA_MAX_INLINE_SEGMENTS];
 	u32			num_sge;
 	int			nents;
@@ -961,6 +964,8 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 	req->num_sge = 1;
 	req->inline_data = false;
 	req->mr->need_inval = false;
+	req->send_completed = false;
+	req->resp_completed = false;
 
 	c->common.flags |= NVME_CMD_SGL_METABUF;
 
@@ -997,13 +1002,25 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 
 static void nvme_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	if (unlikely(wc->status != IB_WC_SUCCESS))
+	struct nvme_rdma_qe *qe =
+		container_of(wc->wr_cqe, struct nvme_rdma_qe, cqe);
+	struct nvme_rdma_request *req =
+		container_of(qe, struct nvme_rdma_request, sqe);
+	struct request *rq = blk_mq_rq_from_pdu(req);
+
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		nvme_rdma_wr_error(cq, wc, "SEND");
+		return;
+	}
+
+	req->send_completed = true;
+	if (req->resp_completed)
+		nvme_end_request(rq, req->cqe.status, req->cqe.result);
 }
 
 static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
 		struct nvme_rdma_qe *qe, struct ib_sge *sge, u32 num_sge,
-		struct ib_send_wr *first)
+		struct ib_send_wr *first, bool signal)
 {
 	struct ib_send_wr wr, *bad_wr;
 	int ret;
@@ -1019,7 +1036,7 @@ static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
 	wr.sg_list    = sge;
 	wr.num_sge    = num_sge;
 	wr.opcode     = IB_WR_SEND;
-	wr.send_flags = IB_SEND_SIGNALED;
+	wr.send_flags = signal ? IB_SEND_SIGNALED : 0;
 
 	if (first)
 		first->next = &wr;
@@ -1093,7 +1110,7 @@ static void nvme_rdma_submit_async_event(struct nvme_ctrl *arg, int aer_idx)
 	ib_dma_sync_single_for_device(dev, sqe->dma, sizeof(*cmd),
 			DMA_TO_DEVICE);
 
-	ret = nvme_rdma_post_send(queue, sqe, &sge, 1, NULL);
+	ret = nvme_rdma_post_send(queue, sqe, &sge, 1, NULL, false);
 	WARN_ON_ONCE(ret);
 }
 
@@ -1117,11 +1134,17 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 	if (rq->tag == tag)
 		ret = 1;
 
+	req->cqe.status = cqe->status;
+	req->cqe.result = cqe->result;
+	req->resp_completed = true;
+
 	if ((wc->wc_flags & IB_WC_WITH_INVALIDATE) &&
 	    wc->ex.invalidate_rkey == req->mr->rkey)
 		req->mr->need_inval = false;
 
-	nvme_end_request(rq, cqe->status, cqe->result);
+	if (req->send_completed)
+		nvme_end_request(rq, req->cqe.status, req->cqe.result);
+
 	return ret;
 }
 
@@ -1410,7 +1433,7 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 			sizeof(struct nvme_command), DMA_TO_DEVICE);
 
 	err = nvme_rdma_post_send(queue, sqe, req->sge, req->num_sge,
-			req->mr->need_inval ? &req->reg_wr.wr : NULL);
+			req->mr->need_inval ? &req->reg_wr.wr : NULL, true);
 	if (unlikely(err)) {
 		nvme_rdma_unmap_data(queue, rq);
 		goto err;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

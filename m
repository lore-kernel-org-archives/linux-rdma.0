From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2 3/3] nvme-rdma: wait for local invalidation before completing a request
Date: Wed,  8 Nov 2017 12:06:16 +0200
Message-ID: <20171108100616.26605-4-sagi@grimberg.me>
References: <20171108100616.26605-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108100616.26605-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We must not complete a request before the host memory region is
invalidated. Luckily we have send with invalidate protocol support
so we usually don't need to execute it, but in case the target
did not invalidate a memory region for us, we must wait for
the invalidation to complete before unmapping host memory and
completing the I/O.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 998f7cb445d9..6ddaa7964657 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1014,8 +1014,24 @@ static void nvme_rdma_memreg_done(struct ib_cq *cq, struct ib_wc *wc)
 
 static void nvme_rdma_inv_rkey_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	if (unlikely(wc->status != IB_WC_SUCCESS))
+	struct nvme_rdma_request *req =
+		container_of(wc->wr_cqe, struct nvme_rdma_request, reg_cqe);
+	struct request *rq = blk_mq_rq_from_pdu(req);
+	unsigned long flags;
+	bool end;
+
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		nvme_rdma_wr_error(cq, wc, "LOCAL_INV");
+		return;
+	}
+
+	spin_lock_irqsave(&req->lock, flags);
+	req->mr->need_inval = false;
+	end = (req->resp_completed && req->send_completed);
+	spin_unlock_irqrestore(&req->lock, flags);
+	if (end)
+		nvme_end_request(rq, req->cqe.status, req->cqe.result);
+
 }
 
 static int nvme_rdma_inv_rkey(struct nvme_rdma_queue *queue,
@@ -1026,7 +1042,7 @@ static int nvme_rdma_inv_rkey(struct nvme_rdma_queue *queue,
 		.opcode		    = IB_WR_LOCAL_INV,
 		.next		    = NULL,
 		.num_sge	    = 0,
-		.send_flags	    = 0,
+		.send_flags	    = IB_SEND_SIGNALED,
 		.ex.invalidate_rkey = req->mr->rkey,
 	};
 
@@ -1040,24 +1056,12 @@ static void nvme_rdma_unmap_data(struct nvme_rdma_queue *queue,
 		struct request *rq)
 {
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
-	struct nvme_rdma_ctrl *ctrl = queue->ctrl;
 	struct nvme_rdma_device *dev = queue->device;
 	struct ib_device *ibdev = dev->dev;
-	int res;
 
 	if (!blk_rq_bytes(rq))
 		return;
 
-	if (req->mr->need_inval && test_bit(NVME_RDMA_Q_LIVE, &req->queue->flags)) {
-		res = nvme_rdma_inv_rkey(queue, req);
-		if (unlikely(res < 0)) {
-			dev_err(ctrl->ctrl.device,
-				"Queueing INV WR for rkey %#x failed (%d)\n",
-				req->mr->rkey, res);
-			nvme_rdma_error_recovery(queue->ctrl);
-		}
-	}
-
 	ib_dma_unmap_sg(ibdev, req->sg_table.sgl,
 			req->nents, rq_data_dir(rq) ==
 				    WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
@@ -1213,7 +1217,7 @@ static void nvme_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	spin_lock_irqsave(&req->lock, flags);
 	req->send_completed = true;
-	end = req->resp_completed;
+	end = req->resp_completed && !req->mr->need_inval;
 	spin_unlock_irqrestore(&req->lock, flags);
 	if (end)
 		nvme_end_request(rq, req->cqe.status, req->cqe.result);
@@ -1338,12 +1342,21 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 	req->cqe.result = cqe->result;
 
 	if ((wc->wc_flags & IB_WC_WITH_INVALIDATE) &&
-	    wc->ex.invalidate_rkey == req->mr->rkey)
+	    wc->ex.invalidate_rkey == req->mr->rkey) {
 		req->mr->need_inval = false;
+	} else if (req->mr->need_inval) {
+		ret = nvme_rdma_inv_rkey(queue, req);
+		if (unlikely(ret < 0)) {
+			dev_err(queue->ctrl->ctrl.device,
+				"Queueing INV WR for rkey %#x failed (%d)\n",
+				req->mr->rkey, ret);
+			nvme_rdma_error_recovery(queue->ctrl);
+		}
+	}
 
 	spin_lock_irqsave(&req->lock, flags);
 	req->resp_completed = true;
-	end = req->send_completed;
+	end = req->send_completed && !req->mr->need_inval;
 	spin_unlock_irqrestore(&req->lock, flags);
 	if (end) {
 		if (rq->tag == tag)
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH 3/3] nvme-rdma: wait for local invalidation before completing a request
Date: Tue, 31 Oct 2017 10:55:22 +0200
Message-ID: <1509440122-1190-4-git-send-email-sagi@grimberg.me>
References: <1509440122-1190-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509440122-1190-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We must not complete a request before the host memory region is
invalidated. Luckily we have send with invalidate protocol support
so we usually don't need to execute it, but in case the target
did not invalidate a memory region for us, we must wait for
the invalidation to complete before unmapping host memory and
completing the I/O.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ae1fb66358f7..b7e0fb0fe913 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -818,8 +818,19 @@ static void nvme_rdma_memreg_done(struct ib_cq *cq, struct ib_wc *wc)
 
 static void nvme_rdma_inv_rkey_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	if (unlikely(wc->status != IB_WC_SUCCESS))
+	struct nvme_rdma_request *req =
+		container_of(wc->wr_cqe, struct nvme_rdma_request, reg_cqe);
+	struct request *rq = blk_mq_rq_from_pdu(req);
+
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		nvme_rdma_wr_error(cq, wc, "LOCAL_INV");
+		return;
+	}
+
+	req->mr->need_inval = false;
+	if (req->resp_completed && req->send_completed)
+		nvme_end_request(rq, req->cqe.status, req->cqe.result);
+
 }
 
 static int nvme_rdma_inv_rkey(struct nvme_rdma_queue *queue,
@@ -830,7 +841,7 @@ static int nvme_rdma_inv_rkey(struct nvme_rdma_queue *queue,
 		.opcode		    = IB_WR_LOCAL_INV,
 		.next		    = NULL,
 		.num_sge	    = 0,
-		.send_flags	    = 0,
+		.send_flags	    = IB_SEND_SIGNALED,
 		.ex.invalidate_rkey = req->mr->rkey,
 	};
 
@@ -844,24 +855,12 @@ static void nvme_rdma_unmap_data(struct nvme_rdma_queue *queue,
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
-			nvmf_error_recovery(&queue->ctrl->ctrl);
-		}
-	}
-
 	ib_dma_unmap_sg(ibdev, req->sg_table.sgl,
 			req->nents, rq_data_dir(rq) ==
 				    WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
@@ -1014,7 +1013,7 @@ static void nvme_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	}
 
 	req->send_completed = true;
-	if (req->resp_completed)
+	if (req->resp_completed && !req->mr->need_inval)
 		nvme_end_request(rq, req->cqe.status, req->cqe.result);
 }
 
@@ -1139,10 +1138,19 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 	req->resp_completed = true;
 
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
+			nvmf_error_recovery(&queue->ctrl->ctrl);
+		}
+	}
 
-	if (req->send_completed)
+	if (req->send_completed && !req->mr->need_inval)
 		nvme_end_request(rq, req->cqe.status, req->cqe.result);
 
 	return ret;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

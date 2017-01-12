From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 22/26] nvme-rdma: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:14 -0800
Message-ID: <20170112190718.6728-23-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Keith Busch <keith.busch@intel.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <keith.busch@intel.com>
---
 drivers/nvme/host/rdma.c   | 35 +++++++++++++++++++----------------
 drivers/nvme/target/rdma.c | 32 ++++++++++++++++----------------
 2 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 208b6a08781c..877ff1982f38 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -207,7 +207,7 @@ static inline size_t nvme_rdma_inline_data_size(struct nvme_rdma_queue *queue)
 static void nvme_rdma_free_qe(struct ib_device *ibdev, struct nvme_rdma_qe *qe,
 		size_t capsule_size, enum dma_data_direction dir)
 {
-	ib_dma_unmap_single(ibdev, qe->dma, capsule_size, dir);
+	dma_unmap_single(ibdev->dma_device, qe->dma, capsule_size, dir);
 	kfree(qe->data);
 }
 
@@ -218,8 +218,9 @@ static int nvme_rdma_alloc_qe(struct ib_device *ibdev, struct nvme_rdma_qe *qe,
 	if (!qe->data)
 		return -ENOMEM;
 
-	qe->dma = ib_dma_map_single(ibdev, qe->data, capsule_size, dir);
-	if (ib_dma_mapping_error(ibdev, qe->dma)) {
+	qe->dma = dma_map_single(ibdev->dma_device, qe->data, capsule_size,
+				 dir);
+	if (dma_mapping_error(ibdev->dma_device, qe->dma)) {
 		kfree(qe->data);
 		return -ENOMEM;
 	}
@@ -895,9 +896,8 @@ static void nvme_rdma_unmap_data(struct nvme_rdma_queue *queue,
 		}
 	}
 
-	ib_dma_unmap_sg(ibdev, req->sg_table.sgl,
-			req->nents, rq_data_dir(rq) ==
-				    WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	dma_unmap_sg(ibdev->dma_device, req->sg_table.sgl, req->nents,
+		rq_data_dir(rq) == WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
 	nvme_cleanup_cmd(rq);
 	sg_free_table_chained(&req->sg_table, true);
@@ -1008,7 +1008,7 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 
 	req->nents = blk_rq_map_sg(rq->q, rq, req->sg_table.sgl);
 
-	count = ib_dma_map_sg(ibdev, req->sg_table.sgl, req->nents,
+	count = dma_map_sg(ibdev->dma_device, req->sg_table.sgl, req->nents,
 		    rq_data_dir(rq) == WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	if (unlikely(count <= 0)) {
 		sg_free_table_chained(&req->sg_table, true);
@@ -1135,7 +1135,8 @@ static void nvme_rdma_submit_async_event(struct nvme_ctrl *arg, int aer_idx)
 	if (WARN_ON_ONCE(aer_idx != 0))
 		return;
 
-	ib_dma_sync_single_for_cpu(dev, sqe->dma, sizeof(*cmd), DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(dev->dma_device, sqe->dma, sizeof(*cmd),
+				DMA_TO_DEVICE);
 
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->common.opcode = nvme_admin_async_event;
@@ -1143,8 +1144,8 @@ static void nvme_rdma_submit_async_event(struct nvme_ctrl *arg, int aer_idx)
 	cmd->common.flags |= NVME_CMD_SGL_METABUF;
 	nvme_rdma_set_sg_null(cmd);
 
-	ib_dma_sync_single_for_device(dev, sqe->dma, sizeof(*cmd),
-			DMA_TO_DEVICE);
+	dma_sync_single_for_device(dev->dma_device, sqe->dma, sizeof(*cmd),
+				   DMA_TO_DEVICE);
 
 	ret = nvme_rdma_post_send(queue, sqe, &sge, 1, NULL, false);
 	WARN_ON_ONCE(ret);
@@ -1194,7 +1195,8 @@ static int __nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc, int tag)
 		return 0;
 	}
 
-	ib_dma_sync_single_for_cpu(ibdev, qe->dma, len, DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(ibdev->dma_device, qe->dma, len,
+				DMA_FROM_DEVICE);
 	/*
 	 * AEN requests are special as they don't time out and can
 	 * survive any kind of queue freeze and often don't respond to
@@ -1207,7 +1209,8 @@ static int __nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc, int tag)
 				&cqe->result);
 	else
 		ret = nvme_rdma_process_nvme_rsp(queue, cqe, wc, tag);
-	ib_dma_sync_single_for_device(ibdev, qe->dma, len, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(ibdev->dma_device, qe->dma, len,
+				   DMA_FROM_DEVICE);
 
 	nvme_rdma_post_recv(queue, qe);
 	return ret;
@@ -1455,8 +1458,8 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return BLK_MQ_RQ_QUEUE_BUSY;
 
 	dev = queue->device->dev;
-	ib_dma_sync_single_for_cpu(dev, sqe->dma,
-			sizeof(struct nvme_command), DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(dev->dma_device, sqe->dma,
+				sizeof(struct nvme_command), DMA_TO_DEVICE);
 
 	ret = nvme_setup_cmd(ns, rq, c);
 	if (ret != BLK_MQ_RQ_QUEUE_OK)
@@ -1473,8 +1476,8 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 		goto err;
 	}
 
-	ib_dma_sync_single_for_device(dev, sqe->dma,
-			sizeof(struct nvme_command), DMA_TO_DEVICE);
+	dma_sync_single_for_device(dev->dma_device, sqe->dma,
+				   sizeof(struct nvme_command), DMA_TO_DEVICE);
 
 	if (rq->cmd_type == REQ_TYPE_FS && req_op(rq) == REQ_OP_FLUSH)
 		flush = true;
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 8c3760a78ac0..f8be76f9fb5c 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -246,9 +246,9 @@ static int nvmet_rdma_alloc_cmd(struct nvmet_rdma_device *ndev,
 	if (!c->nvme_cmd)
 		goto out;
 
-	c->sge[0].addr = ib_dma_map_single(ndev->device, c->nvme_cmd,
-			sizeof(*c->nvme_cmd), DMA_FROM_DEVICE);
-	if (ib_dma_mapping_error(ndev->device, c->sge[0].addr))
+	c->sge[0].addr = dma_map_single(ndev->device->dma_device, c->nvme_cmd,
+					sizeof(*c->nvme_cmd), DMA_FROM_DEVICE);
+	if (dma_mapping_error(ndev->device->dma_device, c->sge[0].addr))
 		goto out_free_cmd;
 
 	c->sge[0].length = sizeof(*c->nvme_cmd);
@@ -259,10 +259,10 @@ static int nvmet_rdma_alloc_cmd(struct nvmet_rdma_device *ndev,
 				get_order(NVMET_RDMA_INLINE_DATA_SIZE));
 		if (!c->inline_page)
 			goto out_unmap_cmd;
-		c->sge[1].addr = ib_dma_map_page(ndev->device,
+		c->sge[1].addr = dma_map_page(ndev->device->dma_device,
 				c->inline_page, 0, NVMET_RDMA_INLINE_DATA_SIZE,
 				DMA_FROM_DEVICE);
-		if (ib_dma_mapping_error(ndev->device, c->sge[1].addr))
+		if (dma_mapping_error(ndev->device->dma_device, c->sge[1].addr))
 			goto out_free_inline_page;
 		c->sge[1].length = NVMET_RDMA_INLINE_DATA_SIZE;
 		c->sge[1].lkey = ndev->pd->local_dma_lkey;
@@ -282,8 +282,8 @@ static int nvmet_rdma_alloc_cmd(struct nvmet_rdma_device *ndev,
 				get_order(NVMET_RDMA_INLINE_DATA_SIZE));
 	}
 out_unmap_cmd:
-	ib_dma_unmap_single(ndev->device, c->sge[0].addr,
-			sizeof(*c->nvme_cmd), DMA_FROM_DEVICE);
+	dma_unmap_single(ndev->device->dma_device, c->sge[0].addr,
+			 sizeof(*c->nvme_cmd), DMA_FROM_DEVICE);
 out_free_cmd:
 	kfree(c->nvme_cmd);
 
@@ -295,13 +295,13 @@ static void nvmet_rdma_free_cmd(struct nvmet_rdma_device *ndev,
 		struct nvmet_rdma_cmd *c, bool admin)
 {
 	if (!admin) {
-		ib_dma_unmap_page(ndev->device, c->sge[1].addr,
-				NVMET_RDMA_INLINE_DATA_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_page(ndev->device->dma_device, c->sge[1].addr,
+			       NVMET_RDMA_INLINE_DATA_SIZE, DMA_FROM_DEVICE);
 		__free_pages(c->inline_page,
 				get_order(NVMET_RDMA_INLINE_DATA_SIZE));
 	}
-	ib_dma_unmap_single(ndev->device, c->sge[0].addr,
-				sizeof(*c->nvme_cmd), DMA_FROM_DEVICE);
+	dma_unmap_single(ndev->device->dma_device, c->sge[0].addr,
+			 sizeof(*c->nvme_cmd), DMA_FROM_DEVICE);
 	kfree(c->nvme_cmd);
 }
 
@@ -350,9 +350,9 @@ static int nvmet_rdma_alloc_rsp(struct nvmet_rdma_device *ndev,
 	if (!r->req.rsp)
 		goto out;
 
-	r->send_sge.addr = ib_dma_map_single(ndev->device, r->req.rsp,
-			sizeof(*r->req.rsp), DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(ndev->device, r->send_sge.addr))
+	r->send_sge.addr = dma_map_single(ndev->device->dma_device, r->req.rsp,
+					  sizeof(*r->req.rsp), DMA_TO_DEVICE);
+	if (dma_mapping_error(ndev->device->dma_device, r->send_sge.addr))
 		goto out_free_rsp;
 
 	r->send_sge.length = sizeof(*r->req.rsp);
@@ -378,8 +378,8 @@ static int nvmet_rdma_alloc_rsp(struct nvmet_rdma_device *ndev,
 static void nvmet_rdma_free_rsp(struct nvmet_rdma_device *ndev,
 		struct nvmet_rdma_rsp *r)
 {
-	ib_dma_unmap_single(ndev->device, r->send_sge.addr,
-				sizeof(*r->req.rsp), DMA_TO_DEVICE);
+	dma_unmap_single(ndev->device->dma_device, r->send_sge.addr,
+			 sizeof(*r->req.rsp), DMA_TO_DEVICE);
 	kfree(r->req.rsp);
 }
 
-- 
2.11.0

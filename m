From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 6/6] nvmet_rdma: use generic RDMA READ/WRITE path
Date: Thu, 4 Feb 2016 13:56:24 -0800
Message-ID: <527b0205ec6944f3df63871b6ca62f6f09807591.1454709715.git.swise@chelsio.com>
References: <cover.1454709715.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1454709715.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/nvme/target/rdma.c | 169 ++++++++++++++-------------------------------
 1 file changed, 51 insertions(+), 118 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 19137c3..8e870f9 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -28,6 +28,7 @@
 #include <linux/nvme-rdma.h>
 
 #include "nvmet.h"
+#include "rw.h"
 
 /*
  * Number of scatter/gather entries we support per WR.  We only ever use two
@@ -47,8 +48,8 @@ struct nvmet_rdma_cmd {
 
 	struct nvmet_rdma_queue	*queue;
 
-	struct ib_rdma_wr	*rdma_wr;
 	struct ib_cqe		read_cqe;
+	struct rdma_rw_ctx	rw;
 
 	struct scatterlist	inline_sg;
 	void			*inline_data;
@@ -98,6 +99,7 @@ struct nvmet_rdma_device {
 	size_t			srq_size;
 	struct kref		ref;
 	struct list_head	entry;
+	bool			need_rdma_read_mr;
 };
 
 static u16 nvmet_rdma_cm_port = 1023; // XXX
@@ -318,78 +320,6 @@ static void nvmet_rdma_free_cmds(struct nvmet_rdma_device *ndev,
 	kfree(cmds);
 }
 
-static void nvmet_rdma_free_rdma_wrs(struct nvmet_rdma_cmd *cmd)
-{
-	struct ib_rdma_wr *wr, *next;
-
-	for (wr = cmd->rdma_wr; wr; wr = next) {
-		if (wr->wr.next &&
-		    (wr->wr.next->opcode == IB_WR_RDMA_READ ||
-		     wr->wr.next->opcode == IB_WR_RDMA_WRITE))
-			next = rdma_wr(wr->wr.next);
-		else
-			next = NULL;
-
-		kfree(wr);
-	}
-}
-
-static int nvmet_rdma_setup_rdma_wrs(struct ib_pd *pd, struct scatterlist *sgl,
-		int sg_cnt, int hw_sge_cnt, struct ib_rdma_wr **first,
-		struct ib_rdma_wr **last, u64 remote_addr, u32 len,
-		u32 rkey, enum dma_data_direction dir)
-{
-	struct ib_device *dev = pd->device;
-	struct ib_rdma_wr *wr = NULL, *prev = NULL;
-	int offset = 0, nr_wrs, i, j;
-
-	nr_wrs = (sg_cnt + hw_sge_cnt - 1) / hw_sge_cnt;
-	for (i = 0; i < nr_wrs; i++) {
-		int nr_sge = min_t(int, sg_cnt, hw_sge_cnt);
-		struct ib_sge *sge;
-		struct scatterlist *s;
-
-		wr = kzalloc(sizeof(*wr) + nr_sge * sizeof(*sge), GFP_KERNEL);
-		if (!wr)
-			return -ENOMEM;
-
-		wr->wr.opcode = dir == DMA_FROM_DEVICE ?
-				IB_WR_RDMA_READ : IB_WR_RDMA_WRITE;
-		wr->wr.num_sge = nr_sge;
-		wr->wr.sg_list = sge = (struct ib_sge *)(wr + 1);
-
-		wr->remote_addr = remote_addr + offset;
-		wr->rkey = rkey;
-
-		for_each_sg(sgl, s, nr_sge, j) {
-			sge->addr = ib_sg_dma_address(dev, s);
-			sge->length = min_t(u32, ib_sg_dma_len(dev, s), len);
-			sge->lkey = pd->local_dma_lkey;
-
-			offset += sge->length;
-			len -= sge->length;
-			if (!len) {
-				WARN_ON_ONCE(j + 1 != nr_sge);
-				break;
-			}
-			sge++;
-		}
-
-		sg_cnt -= nr_sge;
-		sgl = s;
-
-		if (prev)
-			prev->wr.next = &wr->wr;
-		else
-			*first = wr;
-		prev = wr;
-	}
-
-	WARN_ON_ONCE(!wr);
-	*last = wr;
-	return nr_wrs;
-}
-
 static int nvmet_rdma_post_recv(struct nvmet_rdma_device *ndev,
 		struct nvmet_rdma_cmd *cmd)
 {
@@ -429,16 +359,12 @@ static void nvmet_rdma_release_cmd(struct nvmet_rdma_cmd *cmd)
 	struct nvmet_rdma_queue *queue = cmd->queue;
 
 	atomic_add(1 + cmd->n_rdma, &queue->sq_wr_avail);
-	if (cmd->n_rdma)
-		nvmet_rdma_free_rdma_wrs(cmd);
 
-	if (cmd->req.sg_cnt) {
-		ib_dma_unmap_sg(queue->dev->device, cmd->req.sg,
-				cmd->req.sg_cnt, nvmet_data_dir(&cmd->req));
+	if (cmd->n_rdma)
+		rdma_rw_ctx_destroy(&cmd->rw, queue->cm_id->qp);
 
-		if (cmd->req.sg != &cmd->inline_sg)
-			nvmet_rdma_free_sgl(cmd->req.sg, cmd->req.sg_cnt);
-	}
+	if (cmd->req.sg != &cmd->inline_sg)
+		nvmet_rdma_free_sgl(cmd->req.sg, cmd->req.sg_cnt);
 
 	if (unlikely(!list_empty_careful(&queue->cmd_wr_wait_list)))
 		nvmet_rdma_process_wr_wait_list(queue);
@@ -457,7 +383,9 @@ static void nvmet_rdma_queue_response(struct nvmet_req *req)
 {
 	struct nvmet_rdma_cmd *cmd =
 		container_of(req, struct nvmet_rdma_cmd, req);
-	struct ib_send_wr *first_wr, *bad_wr;
+	struct ib_qp *qp = cmd->queue->cm_id->qp;
+	struct ib_send_wr *bad_wr;
+	int ret;
 
 	if (cmd->req.flags & NVMET_REQ_INVALIDATE_RKEY) {
 		cmd->send_wr.opcode = IB_WR_SEND_WITH_INV;
@@ -467,12 +395,12 @@ static void nvmet_rdma_queue_response(struct nvmet_req *req)
 	}
 
 	if (nvmet_rdma_need_data_out(req))
-		first_wr = &cmd->rdma_wr->wr;
+		ret = rdma_rw_post(&cmd->rw, qp, NULL, &cmd->send_wr);
 	else
-		first_wr = &cmd->send_wr;
+		ret = ib_post_send(qp, &cmd->send_wr, &bad_wr);
 
-	if (ib_post_send(cmd->queue->cm_id->qp, first_wr, &bad_wr)) {
-		pr_err("sending cmd response failed\n");
+	if (ret) {
+		pr_err("sending cmd response failed: %d\n", ret);
 		nvmet_rdma_release_cmd(cmd);
 	}
 }
@@ -485,7 +413,7 @@ static void nvmet_rdma_read_data_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	WARN_ON(cmd->n_rdma <= 0);
 	atomic_add(cmd->n_rdma, &queue->sq_wr_avail);
-	nvmet_rdma_free_rdma_wrs(cmd);
+	rdma_rw_ctx_destroy(&cmd->rw, queue->cm_id->qp);
 	cmd->n_rdma = 0;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS &&
@@ -541,11 +469,8 @@ static u16 nvmet_rdma_map_inline_data(struct nvmet_rdma_cmd *cmd)
 static u16 nvmet_rdma_map_sgl_data(struct nvmet_rdma_cmd *cmd,
 		struct nvme_rsgl_desc *rsgl)
 {
-	struct nvmet_rdma_device *ndev = cmd->queue->dev;
-	enum dma_data_direction dir = nvmet_data_dir(&cmd->req);
-	struct ib_rdma_wr *last_wr;
 	struct scatterlist *sg;
-	int sg_cnt, count, hw_sge_cnt, ret;
+	int sg_cnt, ret;
 	u32 len;
 	u16 status;
 
@@ -569,17 +494,10 @@ static u16 nvmet_rdma_map_sgl_data(struct nvmet_rdma_cmd *cmd,
 	if (status)
 		return status;
 
-	count = ib_dma_map_sg(ndev->device, sg, sg_cnt, dir);
-	if (unlikely(!count))
-		return NVME_SC_INTERNAL;
-
-	hw_sge_cnt = dir == DMA_FROM_DEVICE ?
-				ndev->device->attrs.max_sge_rd :
-				ndev->device->attrs.max_sge;
-
-	ret = nvmet_rdma_setup_rdma_wrs(ndev->pd, sg, sg_cnt, hw_sge_cnt,
-			&cmd->rdma_wr, &last_wr, le64_to_cpu(rsgl->addr), len,
-			get_unaligned_le32(rsgl->key), dir);
+	ret = rdma_rw_ctx_init(&cmd->rw, cmd->queue->cm_id->qp,
+			cmd->queue->cm_id->port_num, sg, sg_cnt, len,
+			le64_to_cpu(rsgl->addr), get_unaligned_le32(rsgl->key),
+			nvmet_data_dir(&cmd->req), 0);
 	if (ret < 0)
 		return NVME_SC_INTERNAL;
 
@@ -592,14 +510,6 @@ static u16 nvmet_rdma_map_sgl_data(struct nvmet_rdma_cmd *cmd,
 	 */
 	cmd->req.sg = sg;
 	cmd->req.sg_cnt = sg_cnt;
-
-	if (nvme_is_write(cmd->req.cmd)) {
-		last_wr->wr.wr_cqe = &cmd->read_cqe;
-		last_wr->wr.send_flags = IB_SEND_SIGNALED;
-	} else {
-		last_wr->wr.next = &cmd->send_wr;
-	}
-
 	return 0;
 }
 
@@ -679,10 +589,8 @@ static bool nvmet_rdma_execute_command(struct nvmet_rdma_cmd *cmd)
 	}
 
 	if (nvmet_rdma_need_data_in(&cmd->req)) {
-		struct ib_send_wr *bad_wr;
-
-		if (ib_post_send(cmd->queue->cm_id->qp, &cmd->rdma_wr->wr,
-				&bad_wr))
+		if (rdma_rw_post(&cmd->rw, cmd->queue->cm_id->qp,
+				 &cmd->read_cqe, NULL))
 			nvmet_req_complete(&cmd->req, NVME_SC_DATA_XFER_ERROR);
 	} else {
 		cmd->req.execute(&cmd->req);
@@ -698,7 +606,6 @@ static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
 
 	cmd->queue = queue;
 	cmd->n_rdma = 0;
-	cmd->rdma_wr = NULL;
 
 	status = nvmet_req_init(&cmd->req, &queue->nvme_cq, &queue->nvme_sq,
 			nvmet_rdma_queue_response);
@@ -829,6 +736,9 @@ nvmet_rdma_find_get_device(struct rdma_cm_id *cm_id)
 	ndev->device = cm_id->device;
 	kref_init(&ndev->ref);
 
+	if (rdma_protocol_iwarp(ndev->device, cm_id->port_num))
+		ndev->need_rdma_read_mr = true;
+
 	ndev->pd = ib_alloc_pd(ndev->device);
 	if (IS_ERR(ndev->pd))
 		goto out_free_dev;
@@ -858,8 +768,7 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 {
 	struct ib_qp_init_attr *qp_attr;
 	struct nvmet_rdma_device *ndev = queue->dev;
-	int nr_cqe = queue->send_queue_size + queue->recv_queue_size;
-	int comp_vector, ret, i;
+	int comp_vector, send_wrs, nr_cqe, ret, i;
 
 	/*
 	 * The admin queue is barely used once the controller is live, so don't
@@ -871,6 +780,12 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 		comp_vector =
 			queue->idx % ndev->device->num_comp_vectors;
 
+	send_wrs = queue->send_queue_size;
+	if (ndev->need_rdma_read_mr)
+		send_wrs *= 3; /* + REG_WR, INV_WR */
+
+	nr_cqe = send_wrs + queue->recv_queue_size;
+
 	ret = -ENOMEM;
 	qp_attr = kzalloc(sizeof(*qp_attr), GFP_KERNEL);
 	if (!qp_attr)
@@ -893,7 +808,7 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 	qp_attr->sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_attr->qp_type = IB_QPT_RC;
 	/* +1 for drain */
-	qp_attr->cap.max_send_wr = 1 + queue->send_queue_size;
+	qp_attr->cap.max_send_wr = 1 + send_wrs;
 	qp_attr->cap.max_send_sge = max(ndev->device->attrs.max_sge_rd,
 					ndev->device->attrs.max_sge);
 
@@ -911,6 +826,20 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 		goto err_destroy_cq;
 	}
 
+	if (ndev->need_rdma_read_mr) {
+		/*
+		 * Allocate one MR per SQE as a start.  For devices with very
+		 * small MR sizes we will need a multiplier here.
+		 */
+		ret = ib_mr_pool_init(queue->cm_id->qp, queue->send_queue_size,
+				IB_MR_TYPE_MEM_REG,
+				ndev->device->attrs.max_fast_reg_page_list_len);
+		if (ret) {
+			pr_err("failed to init MR pool ret= %d\n", ret);
+			goto err_destroy_qp;
+		}
+	}
+
 	atomic_set(&queue->sq_wr_avail, qp_attr->cap.max_send_wr);
 
 	pr_debug("%s: max_cqe= %d max_sge= %d sq_size = %d cm_id= %p\n",
@@ -928,6 +857,8 @@ out:
 	kfree(qp_attr);
 	return ret;
 
+err_destroy_qp:
+	rdma_destroy_qp(queue->cm_id);
 err_destroy_cq:
 	ib_free_cq(queue->cq);
 	goto out;
@@ -935,6 +866,8 @@ err_destroy_cq:
 
 static void nvmet_rdma_destroy_queue_ib(struct nvmet_rdma_queue *queue)
 {
+	if (queue->dev->need_rdma_read_mr)
+		ib_mr_pool_destroy(queue->cm_id->qp);
 	rdma_destroy_qp(queue->cm_id);
 	ib_free_cq(queue->cq);
 }
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

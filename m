From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv3] nvmet-rdma: Fix missing dma sync to nvme data structures
Date: Wed, 18 Jan 2017 18:22:26 -0600
Message-ID: <1484785346-2991-1-git-send-email-parav@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch performs dma sync operations on nvme_command
and nvme_completion.

nvme_command is synced
(a) on receiving of the recv queue completion for cpu access.
(b) before posting recv wqe back to rdma adapter for device access.

nvme_completion is synced
(a) on receiving of the recv queue completion of associated
nvme_command for cpu access.
(b) before posting send wqe to rdma adapter for device access.

This patch is generated for git://git.infradead.org/nvme-fabrics.git
Branch: nvmf-4.10

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/nvme/target/rdma.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 6c1c368..0599217 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -438,6 +438,10 @@ static int nvmet_rdma_post_recv(struct nvmet_rdma_device *ndev,
 {
 	struct ib_recv_wr *bad_wr;
 
+	ib_dma_sync_single_for_device(ndev->device,
+		cmd->sge[0].addr, cmd->sge[0].length,
+		DMA_FROM_DEVICE);
+
 	if (ndev->srq)
 		return ib_post_srq_recv(ndev->srq, &cmd->wr, &bad_wr);
 	return ib_post_recv(cmd->queue->cm_id->qp, &cmd->wr, &bad_wr);
@@ -538,6 +542,11 @@ static void nvmet_rdma_queue_response(struct nvmet_req *req)
 		first_wr = &rsp->send_wr;
 
 	nvmet_rdma_post_recv(rsp->queue->dev, rsp->cmd);
+
+	ib_dma_sync_single_for_device(rsp->queue->dev->device,
+			rsp->send_sge.addr, rsp->send_sge.length,
+			DMA_TO_DEVICE);
+
 	if (ib_post_send(cm_id->qp, first_wr, &bad_wr)) {
 		pr_err("sending cmd response failed\n");
 		nvmet_rdma_release_rsp(rsp);
@@ -698,6 +707,13 @@ static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
 	cmd->n_rdma = 0;
 	cmd->req.port = queue->port;
 
+	ib_dma_sync_single_for_cpu(queue->dev->device,
+		cmd->cmd->sge[0].addr, cmd->cmd->sge[0].length,
+		DMA_FROM_DEVICE);
+	ib_dma_sync_single_for_cpu(queue->dev->device,
+			cmd->send_sge.addr, cmd->send_sge.length,
+			DMA_TO_DEVICE);
+
 	if (!nvmet_req_init(&cmd->req, &queue->nvme_cq,
 			&queue->nvme_sq, &nvmet_rdma_ops))
 		return;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

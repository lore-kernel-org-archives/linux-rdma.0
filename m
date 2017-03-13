From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2] nvmet-rdma: Fix a possible uninitialized variable dereference
Date: Mon, 13 Mar 2017 15:39:41 +0200
Message-ID: <1489412381-28947-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When handling a new recv command, we grab a new rsp resource and
check for the queue state being live. In case the queue is not in
live state, we simply restore the rsp back to the free list. However
in this flow we didn't set rsp->queue yet, so we cannot dereference it.

Instead, make sure to initialize rsp->queue (and other rsp members)
as soon as possible so we won't reference uninitialized variables.

Reported-by: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
- v1 broke srq, this one doesn't

 drivers/nvme/target/rdma.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 9aa1da3778b3..ecc4fe862561 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -703,11 +703,6 @@ static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
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
@@ -760,9 +755,12 @@ static void nvmet_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	cmd->queue = queue;
 	rsp = nvmet_rdma_get_rsp(queue);
+	rsp->queue = queue;
 	rsp->cmd = cmd;
 	rsp->flags = 0;
 	rsp->req.cmd = cmd->nvme_cmd;
+	rsp->req.port = queue->port;
+	rsp->n_rdma = 0;
 
 	if (unlikely(queue->state != NVMET_RDMA_Q_LIVE)) {
 		unsigned long flags;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

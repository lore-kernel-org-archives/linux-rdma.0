From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 05/10] nvme-pci: Support blk_poll_batch
Date: Thu,  9 Mar 2017 15:16:37 +0200
Message-ID: <1489065402-14757-6-git-send-email-sagi@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/pci.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a7ad514c2451..f8dcd0bd19f8 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -789,6 +789,21 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx, unsigned int tag)
 	return found;
 }
 
+static int nvme_poll_batch(struct blk_mq_hw_ctx *hctx, unsigned int batch)
+{
+	struct nvme_queue *nvmeq = hctx->driver_data;
+	int completed;
+
+	if (!nvme_cqe_valid(nvmeq, nvmeq->cq_head, nvmeq->cq_phase))
+		return 0;
+
+	spin_lock_irq(&nvmeq->q_lock);
+	completed = __nvme_process_cq(nvmeq, batch);
+	spin_unlock_irq(&nvmeq->q_lock);
+
+	return completed;
+}
+
 static void nvme_pci_submit_async_event(struct nvme_ctrl *ctrl, int aer_idx)
 {
 	struct nvme_dev *dev = to_nvme_dev(ctrl);
@@ -1174,6 +1189,7 @@ static struct blk_mq_ops nvme_mq_ops = {
 	.map_queues	= nvme_pci_map_queues,
 	.timeout	= nvme_timeout,
 	.poll		= nvme_poll,
+	.poll_batch	= nvme_poll_batch,
 };
 
 static void nvme_dev_remove_admin(struct nvme_dev *dev)
-- 
2.7.4

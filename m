From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 03/10] nvme-pci: open-code polling logic in nvme_poll
Date: Thu,  9 Mar 2017 15:16:35 +0200
Message-ID: <1489065402-14757-4-git-send-email-sagi@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Given that the code is simple enough it seems better
then passing a tag by reference for each call site.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/pci.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4ed67f194cfd..a7ad514c2451 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -716,7 +716,7 @@ static inline bool nvme_read_cqe(struct nvme_queue *nvmeq,
 	return false;
 }
 
-static int __nvme_process_cq(struct nvme_queue *nvmeq, int budget, int *tag)
+static int __nvme_process_cq(struct nvme_queue *nvmeq, int budget)
 {
 	struct nvme_completion cqe;
 	int consumed = 0;
@@ -725,11 +725,6 @@ static int __nvme_process_cq(struct nvme_queue *nvmeq, int budget, int *tag)
 		nvme_handle_cqe(nvmeq, &cqe);
 		if (++consumed == budget)
 			break;
-
-		if (tag && *tag == cqe.command_id) {
-			*tag = -1;
-			break;
-		}
 	}
 
 	if (consumed) {
@@ -742,7 +737,7 @@ static int __nvme_process_cq(struct nvme_queue *nvmeq, int budget, int *tag)
 
 static int nvme_process_cq(struct nvme_queue *nvmeq)
 {
-	return __nvme_process_cq(nvmeq, INT_MAX, NULL);
+	return __nvme_process_cq(nvmeq, INT_MAX);
 }
 
 static irqreturn_t nvme_irq(int irq, void *data)
@@ -770,17 +765,28 @@ static irqreturn_t nvme_irq_check(int irq, void *data)
 static int nvme_poll(struct blk_mq_hw_ctx *hctx, unsigned int tag)
 {
 	struct nvme_queue *nvmeq = hctx->driver_data;
+	struct nvme_completion cqe;
+	int found = 0, consumed = 0;
 
-	if (nvme_cqe_valid(nvmeq, nvmeq->cq_head, nvmeq->cq_phase)) {
-		spin_lock_irq(&nvmeq->q_lock);
-		__nvme_process_cq(nvmeq, INT_MAX, &tag);
-		spin_unlock_irq(&nvmeq->q_lock);
+	if (!nvme_cqe_valid(nvmeq, nvmeq->cq_head, nvmeq->cq_phase))
+		return 0;
 
-		if (tag == -1)
-			return 1;
+	spin_lock_irq(&nvmeq->q_lock);
+	while (nvme_read_cqe(nvmeq, &cqe)) {
+		nvme_handle_cqe(nvmeq, &cqe);
+		consumed++;
+
+		if (tag == cqe.command_id) {
+			found = 1;
+			break;
+		}
 	}
 
-	return 0;
+	if (consumed)
+		nvme_ring_cq_doorbell(nvmeq);
+	spin_unlock_irq(&nvmeq->q_lock);
+
+	return found;
 }
 
 static void nvme_pci_submit_async_event(struct nvme_ctrl *ctrl, int aer_idx)
-- 
2.7.4

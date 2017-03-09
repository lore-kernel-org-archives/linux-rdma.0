From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 02/10] nvme-pci: Add budget to __nvme_process_cq
Date: Thu,  9 Mar 2017 15:16:34 +0200
Message-ID: <1489065402-14757-3-git-send-email-sagi@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Prepare to allow passing a batch size to nvme cq processing.

This patch does not change an functionality.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/pci.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d3f74fa40f26..4ed67f194cfd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -716,14 +716,15 @@ static inline bool nvme_read_cqe(struct nvme_queue *nvmeq,
 	return false;
 }
 
-static int __nvme_process_cq(struct nvme_queue *nvmeq, int *tag)
+static int __nvme_process_cq(struct nvme_queue *nvmeq, int budget, int *tag)
 {
 	struct nvme_completion cqe;
 	int consumed = 0;
 
 	while (nvme_read_cqe(nvmeq, &cqe)) {
 		nvme_handle_cqe(nvmeq, &cqe);
-		consumed++;
+		if (++consumed == budget)
+			break;
 
 		if (tag && *tag == cqe.command_id) {
 			*tag = -1;
@@ -741,7 +742,7 @@ static int __nvme_process_cq(struct nvme_queue *nvmeq, int *tag)
 
 static int nvme_process_cq(struct nvme_queue *nvmeq)
 {
-	return __nvme_process_cq(nvmeq, NULL);
+	return __nvme_process_cq(nvmeq, INT_MAX, NULL);
 }
 
 static irqreturn_t nvme_irq(int irq, void *data)
@@ -772,7 +773,7 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx, unsigned int tag)
 
 	if (nvme_cqe_valid(nvmeq, nvmeq->cq_head, nvmeq->cq_phase)) {
 		spin_lock_irq(&nvmeq->q_lock);
-		__nvme_process_cq(nvmeq, &tag);
+		__nvme_process_cq(nvmeq, INT_MAX, &tag);
 		spin_unlock_irq(&nvmeq->q_lock);
 
 		if (tag == -1)
-- 
2.7.4

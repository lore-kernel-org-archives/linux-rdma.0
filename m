From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 01/10] nvme-pci: Split __nvme_process_cq to poll and handle
Date: Thu,  9 Mar 2017 15:16:33 +0200
Message-ID: <1489065402-14757-2-git-send-email-sagi@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Just some rework to split the logic and make it slightly
more readable. This will help us to easily add the irq-poll
logic.

Also, introduce nvme_ring_cq_doorbell helper to mask out the
cq_vector validity check.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/pci.c | 109 +++++++++++++++++++++++++++++-------------------
 1 file changed, 65 insertions(+), 44 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 26a5fd05fe88..d3f74fa40f26 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -71,7 +71,7 @@ struct nvme_dev;
 struct nvme_queue;
 
 static int nvme_reset(struct nvme_dev *dev);
-static void nvme_process_cq(struct nvme_queue *nvmeq);
+static int nvme_process_cq(struct nvme_queue *nvmeq);
 static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown);
 
 /*
@@ -665,75 +665,96 @@ static inline bool nvme_cqe_valid(struct nvme_queue *nvmeq, u16 head,
 	return (le16_to_cpu(nvmeq->cqes[head].status) & 1) == phase;
 }
 
-static void __nvme_process_cq(struct nvme_queue *nvmeq, unsigned int *tag)
+static inline void nvme_ring_cq_doorbell(struct nvme_queue *nvmeq)
 {
-	u16 head, phase;
+	if (likely(nvmeq->cq_vector >= 0))
+		writel(nvmeq->cq_head, nvmeq->q_db + nvmeq->dev->db_stride);
+}
 
-	head = nvmeq->cq_head;
-	phase = nvmeq->cq_phase;
+static inline void nvme_handle_cqe(struct nvme_queue *nvmeq,
+		struct nvme_completion *cqe)
+{
+	struct request *req;
 
-	while (nvme_cqe_valid(nvmeq, head, phase)) {
-		struct nvme_completion cqe = nvmeq->cqes[head];
-		struct request *req;
+	if (unlikely(cqe->command_id >= nvmeq->q_depth)) {
+		dev_warn(nvmeq->dev->ctrl.device,
+			"invalid id %d completed on queue %d\n",
+			cqe->command_id, le16_to_cpu(cqe->sq_id));
+		return;
+	}
 
-		if (++head == nvmeq->q_depth) {
-			head = 0;
-			phase = !phase;
-		}
+	/*
+	 * AEN requests are special as they don't time out and can
+	 * survive any kind of queue freeze and often don't respond to
+	 * aborts.  We don't even bother to allocate a struct request
+	 * for them but rather special case them here.
+	 */
+	if (unlikely(nvmeq->qid == 0 &&
+			cqe->command_id >= NVME_AQ_BLKMQ_DEPTH)) {
+		nvme_complete_async_event(&nvmeq->dev->ctrl,
+				cqe->status, &cqe->result);
+		return;
+	}
 
-		if (tag && *tag == cqe.command_id)
-			*tag = -1;
+	req = blk_mq_tag_to_rq(*nvmeq->tags, cqe->command_id);
+	nvme_req(req)->result = cqe->result;
+	blk_mq_complete_request(req, le16_to_cpu(cqe->status) >> 1);
+}
 
-		if (unlikely(cqe.command_id >= nvmeq->q_depth)) {
-			dev_warn(nvmeq->dev->ctrl.device,
-				"invalid id %d completed on queue %d\n",
-				cqe.command_id, le16_to_cpu(cqe.sq_id));
-			continue;
-		}
+static inline bool nvme_read_cqe(struct nvme_queue *nvmeq,
+		struct nvme_completion *cqe)
+{
+	if (nvme_cqe_valid(nvmeq, nvmeq->cq_head, nvmeq->cq_phase)) {
+		*cqe = nvmeq->cqes[nvmeq->cq_head];
 
-		/*
-		 * AEN requests are special as they don't time out and can
-		 * survive any kind of queue freeze and often don't respond to
-		 * aborts.  We don't even bother to allocate a struct request
-		 * for them but rather special case them here.
-		 */
-		if (unlikely(nvmeq->qid == 0 &&
-				cqe.command_id >= NVME_AQ_BLKMQ_DEPTH)) {
-			nvme_complete_async_event(&nvmeq->dev->ctrl,
-					cqe.status, &cqe.result);
-			continue;
+		if (++nvmeq->cq_head == nvmeq->q_depth) {
+			nvmeq->cq_head = 0;
+			nvmeq->cq_phase = !nvmeq->cq_phase;
 		}
-
-		req = blk_mq_tag_to_rq(*nvmeq->tags, cqe.command_id);
-		nvme_req(req)->result = cqe.result;
-		blk_mq_complete_request(req, le16_to_cpu(cqe.status) >> 1);
+		return true;
 	}
+	return false;
+}
 
-	if (head == nvmeq->cq_head && phase == nvmeq->cq_phase)
-		return;
+static int __nvme_process_cq(struct nvme_queue *nvmeq, int *tag)
+{
+	struct nvme_completion cqe;
+	int consumed = 0;
 
-	if (likely(nvmeq->cq_vector >= 0))
-		writel(head, nvmeq->q_db + nvmeq->dev->db_stride);
-	nvmeq->cq_head = head;
-	nvmeq->cq_phase = phase;
+	while (nvme_read_cqe(nvmeq, &cqe)) {
+		nvme_handle_cqe(nvmeq, &cqe);
+		consumed++;
 
-	nvmeq->cqe_seen = 1;
+		if (tag && *tag == cqe.command_id) {
+			*tag = -1;
+			break;
+		}
+	}
+
+	if (consumed) {
+		nvme_ring_cq_doorbell(nvmeq);
+		nvmeq->cqe_seen = 1;
+	}
+
+	return consumed;
 }
 
-static void nvme_process_cq(struct nvme_queue *nvmeq)
+static int nvme_process_cq(struct nvme_queue *nvmeq)
 {
-	__nvme_process_cq(nvmeq, NULL);
+	return __nvme_process_cq(nvmeq, NULL);
 }
 
 static irqreturn_t nvme_irq(int irq, void *data)
 {
 	irqreturn_t result;
 	struct nvme_queue *nvmeq = data;
+
 	spin_lock(&nvmeq->q_lock);
 	nvme_process_cq(nvmeq);
 	result = nvmeq->cqe_seen ? IRQ_HANDLED : IRQ_NONE;
 	nvmeq->cqe_seen = 0;
 	spin_unlock(&nvmeq->q_lock);
+
 	return result;
 }
 
-- 
2.7.4

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 3/6] nvme-rdma: use ib_drain_qp() function
Date: Thu, 4 Feb 2016 13:52:25 -0800
Message-ID: <46311d109c4e440ba7d3a890f92b7b3b2fadcaf4.1454709715.git.swise@chelsio.com>
References: <cover.1454709715.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1454709715.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/nvme/host/rdma.c   | 35 +++--------------------------------
 drivers/nvme/target/rdma.c | 36 +++---------------------------------
 2 files changed, 6 insertions(+), 65 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index a3e5c3a..613cc39 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -101,8 +101,6 @@ struct nvme_rdma_queue {
 	struct rdma_cm_id	*cm_id;
 	int			cm_error;
 	struct completion	cm_done;
-
-	struct completion	drain_done;
 };
 
 enum nvme_rdma_ctrl_state {
@@ -283,7 +281,8 @@ static int nvme_rdma_create_qp(struct nvme_rdma_queue *queue, const int factor)
 		return -ENOMEM;
 
 	init_attr->event_handler = nvme_rdma_qp_event;
-	init_attr->cap.max_send_wr = factor * queue->queue_size;
+	/* +1 for drain */
+	init_attr->cap.max_send_wr = factor * queue->queue_size + 1;
 	/* +1 for drain */
 	init_attr->cap.max_recv_wr = queue->queue_size + 1;
 	init_attr->cap.max_recv_sge = 1;
@@ -638,7 +637,6 @@ static int nvme_rdma_init_queue(struct nvme_rdma_ctrl *ctrl,
 	queue = &ctrl->queues[idx];
 	queue->ctrl = ctrl;
 	init_completion(&queue->cm_done);
-	init_completion(&queue->drain_done);
 
 	if (idx > 0) {
 		queue->cmnd_capsule_len =
@@ -682,40 +680,13 @@ out_destroy_cm_id:
 	return ret;
 }
 
-static void nvme_rdma_drain_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct nvme_rdma_queue *queue = cq->cq_context;
-
-	complete(&queue->drain_done);
-}
-
-static struct ib_cqe nvme_rdma_drain_cqe = {
-	.done		= nvme_rdma_drain_done,
-};
-
-static void nvme_rdma_drain_qp(struct nvme_rdma_queue *queue)
-{
-	struct ib_qp *qp = queue->cm_id->qp;
-	struct ib_recv_wr wr = { }, *bad_wr;
-	int ret;
-
-	wr.wr_cqe = &nvme_rdma_drain_cqe;
-	ret = ib_post_recv(qp, &wr, &bad_wr);
-	if (ret) {
-		WARN_ONCE(ret, "ib_post_recv(returned %d\n", ret);
-		return;
-	}
-
-	wait_for_completion(&queue->drain_done);
-}
-
 static void nvme_rdma_free_queue(struct nvme_rdma_queue *queue)
 {
 	if (!test_and_clear_bit(NVME_RDMA_Q_CONNECTED, &queue->flags))
 		return;
 
 	rdma_disconnect(queue->cm_id);
-	nvme_rdma_drain_qp(queue);
+	ib_drain_qp(queue->cm_id->qp);
 	nvme_rdma_destroy_queue_ib(queue);
 	rdma_destroy_id(queue->cm_id);
 }
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 85fd44a..19137c3 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -87,7 +87,6 @@ struct nvmet_rdma_queue {
 	int			recv_queue_size;
 	int			send_queue_size;
 
-	struct completion	drain_done;
 	struct list_head	queue_list;
 };
 
@@ -901,7 +900,8 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 	if (ndev->srq) {
 		qp_attr->srq = ndev->srq;
 	} else {
-		qp_attr->cap.max_recv_wr = queue->recv_queue_size;
+		/* +1 for drain */
+		qp_attr->cap.max_recv_wr = 1 + queue->recv_queue_size;
 		qp_attr->cap.max_recv_sge = 2;
 	}
 
@@ -1165,7 +1165,6 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 		ret = -ENOMEM;
 		goto put_device;
 	}
-	init_completion(&queue->drain_done);
 	cm_id->context = queue;
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue);
@@ -1214,35 +1213,6 @@ out_unlock:
 	spin_unlock_irqrestore(&queue->state_lock, flags);
 }
 
-static void nvmet_rdma_drain_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct nvmet_rdma_queue *queue = cq->cq_context;
-
-	complete(&queue->drain_done);
-}
-
-static struct ib_cqe nvmet_rdma_drain_cqe = {
-	.done		= nvmet_rdma_drain_done,
-};
-
-static void nvmet_rdma_queue_drain(struct nvmet_rdma_queue *queue)
-{
-	struct ib_qp *qp = queue->cm_id->qp;
-	struct ib_send_wr wr = { }, *bad_wr;
-	int ret;
-
-	wr.wr_cqe = &nvmet_rdma_drain_cqe;
-	wr.opcode = IB_WR_RDMA_WRITE;
-	wr.send_flags = IB_SEND_SIGNALED;
-	ret = ib_post_send(qp, &wr, &bad_wr);
-	if (ret) {
-		WARN_ONCE(ret, "ib_post_send(returned %d\n", ret);
-		return;
-	}
-
-	wait_for_completion(&queue->drain_done);
-}
-
 static void nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 {
 	bool disconnect = false;
@@ -1264,7 +1234,7 @@ static void nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 
 	if (disconnect) {
 		rdma_disconnect(queue->cm_id);
-		nvmet_rdma_queue_drain(queue);
+		ib_drain_qp(queue->cm_id->qp);
 		kref_put(&queue->ref, nvmet_rdma_queue_put);
 	}
 }
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

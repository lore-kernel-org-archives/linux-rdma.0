From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v4 5/6] nvme-rdma: add DELETING queue flag
Date: Thu, 1 Sep 2016 09:12:57 -0700
Message-ID: <cb63534fde54bd557ab491b85af67b694d5f3303.1472746379.git.swise@opengridcomputing.com>
References: <cover.1472746379.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1472746379.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

When we get a surprise disconnect from the target we queue a periodic
reconnect (which is the sane thing to do...).

We only move the queues out of CONNECTED when we retry to reconnect (after
10 seconds in the default case) but we stop the blk queues immediately
so we are not bothered with traffic from now on. If delete() is kicking
off in this period the queues are still in CONNECTED state.

Part of the delete sequence is trying to issue ctrl shutdown if the
admin queue is CONNECTED (which it is!). This request is issued but
stuck in blk-mq waiting for the queues to start again. This might be
the one preventing us from forward progress...

The patch separates the queue flags to CONNECTED and DELETING. Now we
will move out of CONNECTED as soon as error recovery kicks in (before
stopping the queues) and DELETING is on when we start the queue deletion.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index d97a16f..a5c2280 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -83,6 +83,7 @@ struct nvme_rdma_request {
 enum nvme_rdma_queue_flags {
 	NVME_RDMA_Q_CONNECTED = (1 << 0),
 	NVME_RDMA_IB_QUEUE_ALLOCATED = (1 << 1),
+	NVME_RDMA_Q_DELETING = (1 << 2),
 };
 
 struct nvme_rdma_queue {
@@ -614,7 +615,7 @@ static void nvme_rdma_free_queue(struct nvme_rdma_queue *queue)
 
 static void nvme_rdma_stop_and_free_queue(struct nvme_rdma_queue *queue)
 {
-	if (!test_and_clear_bit(NVME_RDMA_Q_CONNECTED, &queue->flags))
+	if (test_and_set_bit(NVME_RDMA_Q_DELETING, &queue->flags))
 		return;
 	nvme_rdma_stop_queue(queue);
 	nvme_rdma_free_queue(queue);
@@ -767,8 +768,13 @@ static void nvme_rdma_error_recovery_work(struct work_struct *work)
 {
 	struct nvme_rdma_ctrl *ctrl = container_of(work,
 			struct nvme_rdma_ctrl, err_work);
+	int i;
 
 	nvme_stop_keep_alive(&ctrl->ctrl);
+
+	for (i = 0; i < ctrl->queue_count; i++)
+		clear_bit(NVME_RDMA_Q_CONNECTED, &ctrl->queues[i].flags);
+
 	if (ctrl->queue_count > 1)
 		nvme_stop_queues(&ctrl->ctrl);
 	blk_mq_stop_hw_queues(ctrl->ctrl.admin_q);
@@ -1348,7 +1354,7 @@ static int nvme_rdma_device_unplug(struct nvme_rdma_queue *queue)
 	cancel_delayed_work_sync(&ctrl->reconnect_work);
 
 	/* Disable the queue so ctrl delete won't free it */
-	if (test_and_clear_bit(NVME_RDMA_Q_CONNECTED, &queue->flags)) {
+	if (!test_and_set_bit(NVME_RDMA_Q_DELETING, &queue->flags)) {
 		/* Free this queue ourselves */
 		nvme_rdma_stop_queue(queue);
 		nvme_rdma_destroy_queue_ib(queue);
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

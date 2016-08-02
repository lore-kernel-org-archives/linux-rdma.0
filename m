From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2 1/5] nvme-rdma: Fix device removal handling
Date: Tue,  2 Aug 2016 10:53:35 +0300
Message-ID: <1470124419-30405-2-git-send-email-sagi@grimberg.me>
References: <1470124419-30405-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470124419-30405-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Device removal sequence may have crashed because the
controller (and admin queue space) was freed before
we destroyed the admin queue resources. Thus we
want to destroy the admin queue and only then queue
controller deletion and wait for it to complete.

More specifically we:
1. own the controller deletion (make sure we are not
   competing with another deletion).
2. get rid of inflight reconnects if exists (which
   also destroy and create queues).
3. destroy the queue.
4. safely queue controller deletion (and wait for it
   to complete).

Reported-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 21ecbf3f3603..f391d67e4ee0 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -169,7 +169,6 @@ MODULE_PARM_DESC(register_always,
 static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		struct rdma_cm_event *event);
 static void nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc);
-static int __nvme_rdma_del_ctrl(struct nvme_rdma_ctrl *ctrl);
 
 /* XXX: really should move to a generic header sooner or later.. */
 static inline void put_unaligned_le24(u32 val, u8 *p)
@@ -1318,37 +1317,39 @@ out_destroy_queue_ib:
  * that caught the event. Since we hold the callout until the controller
  * deletion is completed, we'll deadlock if the controller deletion will
  * call rdma_destroy_id on this queue's cm_id. Thus, we claim ownership
- * of destroying this queue before-hand, destroy the queue resources
- * after the controller deletion completed with the exception of destroying
- * the cm_id implicitely by returning a non-zero rc to the callout.
+ * of destroying this queue before-hand, destroy the queue resources,
+ * then queue the controller deletion which won't destroy this queue and
+ * we destroy the cm_id implicitely by returning a non-zero rc to the callout.
  */
 static int nvme_rdma_device_unplug(struct nvme_rdma_queue *queue)
 {
 	struct nvme_rdma_ctrl *ctrl = queue->ctrl;
-	int ret, ctrl_deleted = 0;
+	int ret;
 
-	/* First disable the queue so ctrl delete won't free it */
-	if (!test_and_clear_bit(NVME_RDMA_Q_CONNECTED, &queue->flags))
-		goto out;
+	/* Own the controller deletion */
+	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_DELETING))
+		return 0;
 
-	/* delete the controller */
-	ret = __nvme_rdma_del_ctrl(ctrl);
-	if (!ret) {
-		dev_warn(ctrl->ctrl.device,
-			"Got rdma device removal event, deleting ctrl\n");
-		flush_work(&ctrl->delete_work);
+	dev_warn(ctrl->ctrl.device,
+		"Got rdma device removal event, deleting ctrl\n");
 
-		/* Return non-zero so the cm_id will destroy implicitly */
-		ctrl_deleted = 1;
+	/* Get rid of reconnect work if its running */
+	cancel_delayed_work_sync(&ctrl->reconnect_work);
 
+	/* Disable the queue so ctrl delete won't free it */
+	if (test_and_clear_bit(NVME_RDMA_Q_CONNECTED, &queue->flags)) {
 		/* Free this queue ourselves */
-		rdma_disconnect(queue->cm_id);
-		ib_drain_qp(queue->qp);
+		nvme_rdma_stop_queue(queue);
 		nvme_rdma_destroy_queue_ib(queue);
+
+		/* Return non-zero so the cm_id will destroy implicitly */
+		ret = 1;
 	}
 
-out:
-	return ctrl_deleted;
+	/* Queue controller deletion */
+	queue_work(nvme_rdma_wq, &ctrl->delete_work);
+	flush_work(&ctrl->delete_work);
+	return ret;
 }
 
 static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

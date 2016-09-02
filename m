From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v5 6/6] nvme-rdma: use ib_client API to detect device removal
Date: Fri, 2 Sep 2016 09:01:54 -0700
Message-ID: <9ad4620156836dec725fc7723accd3bac4b9fc54.1472833420.git.swise@opengridcomputing.com>
References: <cover.1472833420.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1472833420.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Change nvme-rdma to use the IB Client API to detect device removal.
This has the wonderful benefit of being able to blow away all the
ib/rdma_cm resources for the device being removed.  No craziness about
not destroying the cm_id handling the event.  No deadlocks due to broken
iw_cm/rdma_cm/iwarp dependencies.  And no need to have a bound cm_id
around during controller recovery/reconnect to catch device removal
events.

We don't use the device_add aspect of the ib_client service since we only
want to create resources for an IB device if we have a target utilizing
that device.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 108 ++++++++++++++++++-----------------------------
 1 file changed, 40 insertions(+), 68 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 9ea69cc..d2f891e 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1319,64 +1319,6 @@ out_destroy_queue_ib:
 	return ret;
 }
 
-/**
- * nvme_rdma_device_unplug() - Handle RDMA device unplug
- * @queue:      Queue that owns the cm_id that caught the event
- *
- * DEVICE_REMOVAL event notifies us that the RDMA device is about
- * to unplug so we should take care of destroying our RDMA resources.
- * This event will be generated for each allocated cm_id.
- *
- * In our case, the RDMA resources are managed per controller and not
- * only per queue. So the way we handle this is we trigger an implicit
- * controller deletion upon the first DEVICE_REMOVAL event we see, and
- * hold the event inflight until the controller deletion is completed.
- *
- * One exception that we need to handle is the destruction of the cm_id
- * that caught the event. Since we hold the callout until the controller
- * deletion is completed, we'll deadlock if the controller deletion will
- * call rdma_destroy_id on this queue's cm_id. Thus, we claim ownership
- * of destroying this queue before-hand, destroy the queue resources,
- * then queue the controller deletion which won't destroy this queue and
- * we destroy the cm_id implicitely by returning a non-zero rc to the callout.
- */
-static int nvme_rdma_device_unplug(struct nvme_rdma_queue *queue)
-{
-	struct nvme_rdma_ctrl *ctrl = queue->ctrl;
-	int ret = 0;
-
-	/* Own the controller deletion */
-	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_DELETING))
-		return 0;
-
-	dev_warn(ctrl->ctrl.device,
-		"Got rdma device removal event, deleting ctrl\n");
-
-	/* Get rid of reconnect work if its running */
-	cancel_delayed_work_sync(&ctrl->reconnect_work);
-
-	/* Disable the queue so ctrl delete won't free it */
-	if (!test_and_set_bit(NVME_RDMA_Q_DELETING, &queue->flags)) {
-		/* Free this queue ourselves */
-		nvme_rdma_stop_queue(queue);
-		nvme_rdma_destroy_queue_ib(queue);
-
-		/* Return non-zero so the cm_id will destroy implicitly */
-		ret = 1;
-	}
-
-	/*
-	 * Queue controller deletion. Keep a reference until all
-	 * work is flushed since delete_work will free the ctrl mem
-	 */
-	kref_get(&ctrl->ctrl.kref);
-	queue_work(nvme_rdma_wq, &ctrl->delete_work);
-	flush_work(&ctrl->delete_work);
-	nvme_put_ctrl(&ctrl->ctrl);
-
-	return ret;
-}
-
 static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		struct rdma_cm_event *ev)
 {
@@ -1418,8 +1360,8 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		nvme_rdma_error_recovery(queue->ctrl);
 		break;
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
-		/* return 1 means impliciy CM ID destroy */
-		return nvme_rdma_device_unplug(queue);
+		/* device removal is handled via the ib_client API */
+		break;
 	default:
 		dev_err(queue->ctrl->ctrl.device,
 			"Unexpected RDMA CM event (%d)\n", ev->event);
@@ -2029,27 +1971,57 @@ static struct nvmf_transport_ops nvme_rdma_transport = {
 	.create_ctrl	= nvme_rdma_create_ctrl,
 };
 
+static void nvme_rdma_add_one(struct ib_device *ib_device)
+{
+}
+
+static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
+{
+	struct nvme_rdma_ctrl *ctrl;
+
+	/* Delete all controllers using this device */
+	mutex_lock(&nvme_rdma_ctrl_mutex);
+	list_for_each_entry(ctrl, &nvme_rdma_ctrl_list, list) {
+		if (ctrl->device->dev != ib_device)
+			continue;
+		dev_info(ctrl->ctrl.device,
+			"Removing ctrl: NQN \"%s\", addr %pISp\n",
+			ctrl->ctrl.opts->subsysnqn, &ctrl->addr);
+		__nvme_rdma_del_ctrl(ctrl);
+	}
+	mutex_unlock(&nvme_rdma_ctrl_mutex);
+
+	flush_workqueue(nvme_rdma_wq);
+}
+
+static struct ib_client nvme_rdma_ib_client = {
+	.name   = "nvme_rdma",
+	.add = nvme_rdma_add_one,
+	.remove = nvme_rdma_remove_one
+};
+
 static int __init nvme_rdma_init_module(void)
 {
+	int ret;
+
 	nvme_rdma_wq = create_workqueue("nvme_rdma_wq");
 	if (!nvme_rdma_wq)
 		return -ENOMEM;
 
+	ret = ib_register_client(&nvme_rdma_ib_client);
+	if (ret) {
+		destroy_workqueue(nvme_rdma_wq);
+		return ret;
+	}
+
 	nvmf_register_transport(&nvme_rdma_transport);
 	return 0;
 }
 
 static void __exit nvme_rdma_cleanup_module(void)
 {
-	struct nvme_rdma_ctrl *ctrl;
-
 	nvmf_unregister_transport(&nvme_rdma_transport);
-
-	mutex_lock(&nvme_rdma_ctrl_mutex);
-	list_for_each_entry(ctrl, &nvme_rdma_ctrl_list, list)
-		__nvme_rdma_del_ctrl(ctrl);
-	mutex_unlock(&nvme_rdma_ctrl_mutex);
-
+	ib_unregister_client(&nvme_rdma_ib_client);
 	destroy_workqueue(nvme_rdma_wq);
 }
 
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

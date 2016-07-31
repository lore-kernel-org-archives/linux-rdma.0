From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2] nvmet-rdma: Correctly handle RDMA device hot removal
Date: Sun, 31 Jul 2016 14:49:36 +0300
Message-ID: <1469965776-31210-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When configuring a device attached listener, we may
see device removal events. In this case we return a
non-zero return code from the cm event handler which
implicitly destroys the cm_id. It is possible that in
the future the user will remove this listener and by
that trigger a second call to rdma_destroy_id on an
already destroyed cm_id -> BUG.

In addition, when a queue bound (active session) cm_id
generates a DEVICE_REMOVAL event we must guarantee all
resources are cleaned up by the time we return from the
event handler.

Introduce nvmet_rdma_device_removal which addresses
(or at least attempts to) both scenarios.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
Changes from v1:
- Fixed some typos resulting of uncommited code conflicts of an old patch.

 drivers/nvme/target/rdma.c | 87 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 71 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 347cc6d37dad..6a309f6b0bd9 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -77,6 +77,7 @@ enum nvmet_rdma_queue_state {
 	NVMET_RDMA_Q_CONNECTING,
 	NVMET_RDMA_Q_LIVE,
 	NVMET_RDMA_Q_DISCONNECTING,
+	NVMET_RDMA_IN_DEVICE_REMOVAL,
 };
 
 struct nvmet_rdma_queue {
@@ -977,9 +978,17 @@ static void nvmet_rdma_release_queue_work(struct work_struct *w)
 		container_of(w, struct nvmet_rdma_queue, release_work);
 	struct rdma_cm_id *cm_id = queue->cm_id;
 	struct nvmet_rdma_device *dev = queue->dev;
+	bool device_removal;
+	unsigned long flags;
 
 	nvmet_rdma_free_queue(queue);
-	rdma_destroy_id(cm_id);
+
+	spin_lock_irqsave(&queue->state_lock, flags);
+	device_removal = queue->state == NVMET_RDMA_IN_DEVICE_REMOVAL;
+	spin_unlock_irqrestore(&queue->state_lock, flags);
+	if (!device_removal)
+		rdma_destroy_id(cm_id);
+
 	kref_put(&dev->ref, nvmet_rdma_free_dev);
 }
 
@@ -1228,8 +1237,9 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 	switch (queue->state) {
 	case NVMET_RDMA_Q_CONNECTING:
 	case NVMET_RDMA_Q_LIVE:
-		disconnect = true;
 		queue->state = NVMET_RDMA_Q_DISCONNECTING;
+	case NVMET_RDMA_IN_DEVICE_REMOVAL:
+		disconnect = true;
 		break;
 	case NVMET_RDMA_Q_DISCONNECTING:
 		break;
@@ -1267,9 +1277,62 @@ static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
 	schedule_work(&queue->release_work);
 }
 
+/**
+ * nvme_rdma_device_removal() - Handle RDMA device removal
+ * @queue:      nvmet rdma queue (cm id qp_context)
+ * @addr:	nvmet address (cm_id context)
+ *
+ * DEVICE_REMOVAL event notifies us that the RDMA device is about
+ * to unplug so we should take care of destroying our RDMA resources.
+ * This event will be generated for each allocated cm_id.
+ *
+ * Note that this event can be generated on a normal queue cm_id
+ * and/or a device bound listener cm_id (where in this case
+ * queue will be null).
+ *
+ * we claim ownership on destroying the cm_id. For queues we move
+ * the queue state to NVMET_RDMA_IN_DEVICE_REMOVAL and for port
+ * we nullify the priv to prevent double cm_id destruction and destroying
+ * the cm_id implicitely by returning a non-zero rc to the callout.
+ */
+static int nvmet_rdma_device_removal(struct nvmet_port *port,
+			struct nvmet_rdma_queue *queue)
+{
+	unsigned long flags;
+
+	if (!queue) {
+		/*
+		 * This is a listener cm_id. Make sure that
+		 * future remove_port won't invoke a double
+		 * cm_id destroy.
+		 */
+		port->priv = NULL;
+	} else {
+		/*
+		 * This is a queue cm_id. Make sure that
+		 * release queue will not destroy the cm_id
+		 * and schedule all ctrl queues removal (only
+		 * if the queue is not disconnecting already).
+		 */
+		spin_lock_irqsave(&queue->state_lock, flags);
+		if (queue->state != NVMET_RDMA_Q_DISCONNECTING)
+			queue->state = NVMET_RDMA_IN_DEVICE_REMOVAL;
+		spin_unlock_irqrestore(&queue->state_lock, flags);
+		nvmet_rdma_queue_disconnect(queue);
+		flush_scheduled_work();
+	}
+
+	/*
+	 * We need to return 1 so that the core will destroy
+	 * it's own ID.  What a great API design..
+	 */
+	return 1;
+}
+
 static int nvmet_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		struct rdma_cm_event *event)
 {
+	struct nvmet_port *port = cm_id->context;
 	struct nvmet_rdma_queue *queue = NULL;
 	int ret = 0;
 
@@ -1289,20 +1352,11 @@ static int nvmet_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		break;
 	case RDMA_CM_EVENT_ADDR_CHANGE:
 	case RDMA_CM_EVENT_DISCONNECTED:
-	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
-		/*
-		 * We can get the device removal callback even for a
-		 * CM ID that we aren't actually using.  In that case
-		 * the context pointer is NULL, so we shouldn't try
-		 * to disconnect a non-existing queue.  But we also
-		 * need to return 1 so that the core will destroy
-		 * it's own ID.  What a great API design..
-		 */
-		if (queue)
-			nvmet_rdma_queue_disconnect(queue);
-		else
-			ret = 1;
+		nvmet_rdma_queue_disconnect(queue);
+		break;
+	case RDMA_CM_EVENT_DEVICE_REMOVAL:
+		ret = nvmet_rdma_device_removal(port, queue);
 		break;
 	case RDMA_CM_EVENT_REJECTED:
 	case RDMA_CM_EVENT_UNREACHABLE:
@@ -1442,7 +1496,8 @@ static void nvmet_rdma_remove_port(struct nvmet_port *port)
 {
 	struct rdma_cm_id *cm_id = port->priv;
 
-	rdma_destroy_id(cm_id);
+	if (cm_id)
+		rdma_destroy_id(cm_id);
 }
 
 static struct nvmet_fabrics_ops nvmet_rdma_ops = {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

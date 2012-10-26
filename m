From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 18/19] ib_srp: Remove SCSI devices upon port down event
Date: Fri, 26 Oct 2012 14:58:00 +0200
Message-ID: <508A88D8.2050905@acm.org>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508A85BB.1000505-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch is a modified version of a patch from Karandeep Chahal
that was posted on May 29, 2012 on the linux-rdma mailing list
(http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11796.html).

Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   68 +++++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7ed0c26..91f86ea 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -451,13 +451,14 @@ static bool srp_change_state(struct srp_target_port *target,
 static bool srp_queue_remove_work(struct srp_target_port *target)
 {
 	bool changed = false;
+	unsigned long flags;
 
-	spin_lock_irq(&target->lock);
+	spin_lock_irqsave(&target->lock, flags);
 	if (target->state != SRP_TARGET_REMOVED) {
 		target->state = SRP_TARGET_REMOVED;
 		changed = true;
 	}
-	spin_unlock_irq(&target->lock);
+	spin_unlock_irqrestore(&target->lock, flags);
 
 	if (changed)
 		queue_work(system_long_wq, &target->remove_work);
@@ -630,9 +631,9 @@ static void srp_remove_work(struct work_struct *work)
 
 	WARN_ON(target->state != SRP_TARGET_REMOVED);
 
-	spin_lock(&target->srp_host->target_lock);
+	spin_lock_irq(&target->srp_host->target_lock);
 	list_del(&target->list);
-	spin_unlock(&target->srp_host->target_lock);
+	spin_unlock_irq(&target->srp_host->target_lock);
 
 	srp_remove_target(target);
 }
@@ -653,7 +654,7 @@ static bool srp_conn_unique(struct srp_host *host,
 	struct srp_target_port *t;
 	bool ret = true;
 
-	spin_lock(&host->target_lock);
+	spin_lock_irq(&host->target_lock);
 	list_for_each_entry(t, &host->target_list, list) {
 		if (t != target &&
 		    target->id_ext == t->id_ext &&
@@ -663,7 +664,7 @@ static bool srp_conn_unique(struct srp_host *host,
 			break;
 		}
 	}
-	spin_unlock(&host->target_lock);
+	spin_unlock_irq(&host->target_lock);
 
 	return ret;
 }
@@ -2487,9 +2488,9 @@ static ssize_t srp_create_target(struct device *dev,
 	target->scsi_host_added = false;
 
 	mutex_lock(&target->mutex);
-	spin_lock(&host->target_lock);
+	spin_lock_irq(&host->target_lock);
 	list_add_tail(&target->list, &host->target_list);
-	spin_unlock(&host->target_lock);
+	spin_unlock_irq(&host->target_lock);
 
 	if (!srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_LIVE)) {
 		ret = -ENOENT;
@@ -2600,13 +2601,48 @@ free_host:
 	return NULL;
 }
 
+static void srp_host_remove_all(struct srp_host *host)
+{
+	struct srp_target_port *target;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->target_lock, flags);
+	list_for_each_entry(target, &host->target_list, list)
+		srp_queue_remove_work(target);
+	spin_unlock_irqrestore(&host->target_lock, flags);
+}
+
+static void srp_event_handler(struct ib_event_handler *handler,
+			      struct ib_event *event)
+{
+	struct srp_device *srp_dev = container_of(handler, struct srp_device,
+						  event_handler);
+	u8 port;
+	struct srp_host *host;
+
+	switch (event->event) {
+	case IB_EVENT_DEVICE_FATAL:
+	case IB_EVENT_PORT_ERR:
+		port = event->element.port_num;
+		pr_info("an error occurred on port %s-%d\n", srp_dev->dev->name,
+			port);
+
+		list_for_each_entry(host, &srp_dev->dev_list, list)
+			if (host->port == port)
+				srp_host_remove_all(host);
+		break;
+	default:
+		break;
+	}
+}
+
 static void srp_add_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
 	struct ib_device_attr *dev_attr;
 	struct ib_fmr_pool_param fmr_param;
 	struct srp_host *host;
-	int max_pages_per_fmr, fmr_page_shift, s, e, p;
+	int max_pages_per_fmr, fmr_page_shift, s, e, p, ret;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -2680,6 +2716,12 @@ static void srp_add_one(struct ib_device *device)
 			list_add_tail(&host->list, &srp_dev->dev_list);
 	}
 
+	INIT_IB_EVENT_HANDLER(&srp_dev->event_handler, device,
+			      srp_event_handler);
+	ret = ib_register_event_handler(&srp_dev->event_handler);
+	if (ret)
+		pr_err("ib_register_event_handler() failed: %d", ret);
+
 	ib_set_client_data(device, &srp_client, srp_dev);
 
 	goto free_attr;
@@ -2698,10 +2740,11 @@ static void srp_remove_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
 	struct srp_host *host, *tmp_host;
-	struct srp_target_port *target;
 
 	srp_dev = ib_get_client_data(device, &srp_client);
 
+	ib_unregister_event_handler(&srp_dev->event_handler);
+
 	list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list, list) {
 		device_unregister(&host->dev);
 		/*
@@ -2713,10 +2756,7 @@ static void srp_remove_one(struct ib_device *device)
 		/*
 		 * Remove all target ports.
 		 */
-		spin_lock(&host->target_lock);
-		list_for_each_entry(target, &host->target_list, list)
-			srp_queue_remove_work(target);
-		spin_unlock(&host->target_lock);
+		srp_host_remove_all(host);
 
 		/*
 		 * Wait for target port removal tasks.
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 99485a3..f7841c8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -107,6 +107,7 @@ struct srp_device {
 	struct ib_pd	       *pd;
 	struct ib_mr	       *mr;
 	struct ib_fmr_pool     *fmr_pool;
+	struct ib_event_handler event_handler;
 	u64			fmr_page_mask;
 	int			fmr_page_size;
 	int			fmr_max_size;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

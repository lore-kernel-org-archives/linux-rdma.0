From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/6]  SRP handles async. port error/active events
Date: Mon, 09 Nov 2009 13:34:19 -0800
Message-ID: <4AF88ADB.10202@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050303030807050500070407"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------050303030807050500070407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Handling async local port events: port error, active, lid change...
Upon local port err, it will set up timer device_loss_timeout seconds to
propagate I/O errors and reconnect. If local port active and there is
timer, it will delete the timer

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--------------050303030807050500070407
Content-Type: text/plain;
 name="srp_5_async_event_handler.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_5_async_event_handler.patch"

 drivers/infiniband/ulp/srp/ib_srp.c |   85 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3475a8b..f62ef8f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2037,6 +2037,81 @@ free_host:
 	return NULL;
 }
 
+static void srp_event_handler(struct ib_event_handler *handler,
+			      struct ib_event *event)
+{
+	struct srp_device *srp_dev =
+	    ib_get_client_data(event->device, &srp_client);
+	struct srp_host *host, *tmp_host;
+	struct srp_target_port *target, *tmp_target;
+
+	if (!srp_dev || srp_dev->dev != event->device)
+		return;
+
+	printk(KERN_WARNING PFX "ASYNC event= %d on device= %s\n",
+		event->event, srp_dev->dev->name);
+
+	switch (event->event) {
+	case IB_EVENT_PORT_ERR:
+		spin_lock(&srp_dev->dev_lock);
+		list_for_each_entry_safe(host, tmp_host,
+					 &srp_dev->dev_list, list) {
+			if (event->element.port_num == host->port) {
+				spin_lock(&host->target_lock);
+				list_for_each_entry_safe(target, tmp_target,
+							 &host->target_list, list) {
+					unsigned long flags;
+
+					spin_lock_irqsave(target->scsi_host->host_lock,
+							  flags);
+					if (!target->qp_in_error &&
+					    target->state == SRP_TARGET_LIVE)
+						srp_qp_err_add_timer(target,
+								     target->device_loss_timeout);
+					spin_unlock_irqrestore(target->scsi_host->host_lock,
+							       flags);
+				}
+				spin_unlock(&host->target_lock);
+			}
+		}
+		spin_unlock(&srp_dev->dev_lock);
+		break;
+	case IB_EVENT_PORT_ACTIVE:
+	case IB_EVENT_LID_CHANGE:
+	case IB_EVENT_PKEY_CHANGE:
+	case IB_EVENT_SM_CHANGE:
+		spin_lock(&srp_dev->dev_lock);
+		list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list,
+					 list) {
+			if (event->element.port_num == host->port) {
+				spin_lock(&host->target_lock);
+				list_for_each_entry_safe(target, tmp_target,
+							 &host->target_list, list) {
+					unsigned long flags;
+
+					spin_lock_irqsave(target->scsi_host->host_lock,
+							  flags);
+					if (timer_pending(&target->qp_err_timer)
+					    && !target->qp_in_error) {
+						shost_printk(KERN_WARNING PFX,
+							     target->scsi_host,
+							     "delete qp_in_err timer\n");
+						del_timer(&target->qp_err_timer);
+					}
+					spin_unlock_irqrestore(target->scsi_host->host_lock,
+							       flags);
+				}
+				spin_unlock(&host->target_lock);
+			}
+		}
+		spin_unlock(&srp_dev->dev_lock);
+		break;
+	default:
+		break;
+	}
+
+}
+
 static void srp_add_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
@@ -2069,6 +2144,7 @@ static void srp_add_one(struct ib_device *device)
 	srp_dev->fmr_page_mask  = ~((u64) srp_dev->fmr_page_size - 1);
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
+	spin_lock_init(&srp_dev->dev_lock);
 
 	srp_dev->dev = device;
 	srp_dev->pd  = ib_alloc_pd(device);
@@ -2082,6 +2158,11 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->mr))
 		goto err_pd;
 
+	INIT_IB_EVENT_HANDLER(&srp_dev->event_handler, srp_dev->dev,
+			      srp_event_handler);
+	if (ib_register_event_handler(&srp_dev->event_handler))
+		goto err_pd;
+
 	memset(&fmr_param, 0, sizeof fmr_param);
 	fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
 	fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
@@ -2133,6 +2214,9 @@ static void srp_remove_one(struct ib_device *device)
 
 	srp_dev = ib_get_client_data(device, &srp_client);
 
+	ib_unregister_event_handler(&srp_dev->event_handler);
+
+	spin_lock(&srp_dev->dev_lock);
 	list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list, list) {
 		device_unregister(&host->dev);
 		/*
@@ -2172,6 +2256,7 @@ static void srp_remove_one(struct ib_device *device)
 
 		kfree(host);
 	}
+	spin_unlock(&srp_dev->dev_lock);
 
 	if (srp_dev->fmr_pool)
 		ib_destroy_fmr_pool(srp_dev->fmr_pool);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index daa4bf7..74d1f09 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -86,8 +86,10 @@ enum srp_request_type {
 struct srp_device {
 	struct list_head	dev_list;
 	struct ib_device       *dev;
+	spinlock_t		dev_lock;
 	struct ib_pd	       *pd;
 	struct ib_mr	       *mr;
+	struct ib_event_handler event_handler;
 	struct ib_fmr_pool     *fmr_pool;
 	int			fmr_page_shift;
 	int			fmr_page_size;

--------------050303030807050500070407--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

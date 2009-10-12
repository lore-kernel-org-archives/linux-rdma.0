From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ofa-general][PATCH 4/4] SRP fail-over faster
Date: Mon, 12 Oct 2009 15:57:42 -0700
Message-ID: <4AD3B466.8060908@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060505070000030706000804"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060505070000030706000804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------060505070000030706000804
Content-Type: message/rfc822;
 name="[ofa-general][PATCH 4/4] SRP fail-over faster,.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[ofa-general][PATCH 4/4] SRP fail-over faster,.eml"

Message-ID: <4AD3B1E8.40601-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 12 Oct 2009 15:47:04 -0700
From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: OF General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
CC: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [ofa-general][PATCH 4/4] SRP fail-over faster,
Content-Type: multipart/mixed;
 boundary="------------050209090909090503020504"

This is a multi-part message in MIME format.
--------------050209090909090503020504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Handling async local port events: port err, active, lid change...
Upon local port err, it will set up timer srp_dev_loss_tmo seconds to 
reconnect. If local port active and there is timer, it will delete the timer

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--------------050209090909090503020504
Content-Type: text/plain;
 name="srp_4_async_event_handler.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_4_async_event_handler.patch"

Index: ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
===================================================================
--- ofed_kernel.orig/drivers/infiniband/ulp/srp/ib_srp.c
+++ ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2071,6 +2120,77 @@
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
+								     srp_dev_loss_tmo);
+					spin_unlock_irqrestore(target->scsi_host->host_lock,
+							       flags);
+				}
+				spin_unlock(&host->target_lock);
+			}
+		}
+		break;
+	case IB_EVENT_PORT_ACTIVE:
+	case IB_EVENT_LID_CHANGE:
+	case IB_EVENT_PKEY_CHANGE:
+	case IB_EVENT_SM_CHANGE:
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
@@ -2116,6 +2228,11 @@
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
@@ -2160,6 +2284,8 @@
 
 	srp_dev = ib_get_client_data(device, &srp_client);
 
+	ib_unregister_event_handler(&srp_dev->event_handler);
+
 	list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list, list) {
 		device_unregister(&host->dev);
 		/*
Index: ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.h
===================================================================
--- ofed_kernel.orig/drivers/infiniband/ulp/srp/ib_srp.h
+++ ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.h
@@ -88,6 +88,7 @@ struct srp_device {
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
 	struct ib_mr	       *mr;
+	struct ib_event_handler event_handler;
 	struct ib_fmr_pool     *fmr_pool;
 	int			fmr_page_shift;
 	int			fmr_page_size;

--------------050209090909090503020504--


--------------060505070000030706000804--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

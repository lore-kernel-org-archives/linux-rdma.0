From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 4/4] SRP fail-over faster
Date: Thu, 22 Oct 2009 16:17:43 -0700
Message-ID: <4AE0E817.2000802@mellanox.com>
References: <4AD3B466.8060908@mellanox.com> <e2e108260910130409q78e3edbcndd64b7cf419705b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040907020700040209090804"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260910130409q78e3edbcndd64b7cf419705b9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------040907020700040209090804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bart Van Assche wrote:
>
>>
>> +static void srp_event_handler(struct ib_event_handler *handler,
>> +                             struct ib_event *event)
>> +{
>> +       struct srp_device *srp_dev =
>> +           ib_get_client_data(event->device, &srp_client);
>> +       struct srp_host *host, *tmp_host;
>> +       struct srp_target_port *target, *tmp_target;
>> +
>> +       if (!srp_dev || srp_dev->dev != event->device)
>> +               return;
>> +
>> +       printk(KERN_WARNING PFX "ASYNC event= %d on device= %s\n",
>> +               event->event, srp_dev->dev->name);
>> +
>> +       switch (event->event) {
>> +       case IB_EVENT_PORT_ERR:
>> +               list_for_each_entry_safe(host, tmp_host,
>> +                                        &srp_dev->dev_list, list) {
>> +                       if (event->element.port_num == host->port) {
>> +                               spin_lock(&host->target_lock);
>>     
>
> Can srp_remove_work() be executed concurrently with
> srp_event_handler() ? In that case the above code isn't safe and the
> spin_lock(&host->target_lock) should be moved to just before
> list_for_each_entry_safe(). The current implementation can trigger
> reading deallocated memory.
>
>   
Here is the updated patch to address the race


--------------040907020700040209090804
Content-Type: text/plain;
 name="srp_4_async_event_handler.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_4_async_event_handler.patch"

Handling async local port events: port error, active, lid change...
Upon local port err, it will set up timer device_loss_timeout seconds to
reconnect. If local port active and there is timer, it will delete the timer

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> 


 drivers/infiniband/ulp/srp/ib_srp.c |   85 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 12404d5..88dbc17 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2058,6 +2058,81 @@ free_host:
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
@@ -2090,6 +2165,7 @@ static void srp_add_one(struct ib_device *device)
 	srp_dev->fmr_page_mask  = ~((u64) srp_dev->fmr_page_size - 1);
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
+	spin_lock_init(&srp_dev->dev_lock);
 
 	srp_dev->dev = device;
 	srp_dev->pd  = ib_alloc_pd(device);
@@ -2103,6 +2179,11 @@ static void srp_add_one(struct ib_device *device)
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
@@ -2154,6 +2235,9 @@ static void srp_remove_one(struct ib_device *device)
 
 	srp_dev = ib_get_client_data(device, &srp_client);
 
+	ib_unregister_event_handler(&srp_dev->event_handler);
+
+	spin_lock(&srp_dev->dev_lock);
 	list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list, list) {
 		device_unregister(&host->dev);
 		/*
@@ -2193,6 +2277,7 @@ static void srp_remove_one(struct ib_device *device)
 
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

--------------040907020700040209090804--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

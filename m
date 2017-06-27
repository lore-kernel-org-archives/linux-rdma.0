From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Deadlock on device removal event for NVMeF target
Date: Tue, 27 Jun 2017 09:37:51 +0300
Message-ID: <56030fcd-b8a0-fc0e-18e5-985ebf16a82e@grimberg.me>
References: <20170626225920.GA11700@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170626225920.GA11700-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hi Sagi/Christoph,

Hi Shiraz,

Please CC linux-nvme for nvme-rdma related stuff.

> I am seeing a deadlock for a device removal event on NVMeF target.
> 
> The sequence of events leading to the deadlock are as follows,
> 
> 1. i40iw posts IW_CM_EVENT_CLOSE events for all QPs causing the corresponding
> NVMet RDMA Queues to disconnect and schedule release of any pending work on WQ
> 2. i40iw triggers device removal
> 	ib_unregister_device
> 	[..]
> 	cma_remove_id_dev (takes a handler lock before calling the event handler)
> 	nvmet_rdma_cm_handler
> 	nvmet_rdma_device_removal (queue->state = NVMET_RDMA_Q_DISCONNECTING due to 1.)
> 	flush_scheduled_work (blocks till all scheduled work is drained from WQ)
> 	nvmet_rdma_release_queue_work (queue->state = NVMET_RDMA_Q_DISCONNECTING)
> 	rdma_destroy_id (waits on the same handler lock as cma_remove_id_dev causing the deadlock)
>       
> So this problem can occur when there is a device removal event while the queue is in
> disconnect state with the some oustanding work that hasnt been drained from the WQ at the
> time flush_scheduled_work is called.

This indeed looks like a bug (thanks for reporting!). We indeed don't
have sufficient information on where the queue release procedure is by
only looking at the queue state, we can't tell if rdma_destroy_id was
invoked and we can deadlock with rdma_destroy_id.

> This patch fixed the problem but I am not sure if it is the correct fix.
> 
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index 9e45cde..d0fb307 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1349,6 +1349,12 @@ static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
>                  spin_lock_irqsave(&queue->state_lock, flags);
>                  if (queue->state != NVMET_RDMA_Q_DISCONNECTING)
>                          queue->state = NVMET_RDMA_IN_DEVICE_REMOVAL;
> +               else {
> +                       /*queue is disconnecting; so cm_id and queues will be destroyed*/
> +                       spin_unlock_irqrestore(&queue->state_lock, flags);
> +                       return 0;
> +               }
> +
>                  spin_unlock_irqrestore(&queue->state_lock, flags);
>                  nvmet_rdma_queue_disconnect(queue);
>                  flush_scheduled_work();
> 

The problem with your patch, is that it introduces a race in the
opposite direction. The queue state does not indicate that the queue
release work has _started_, it only indicates that it was queued.
The DEVICE_REMOVAL event expects that by the end of the callout _all_
associated resources have been freed and the device can safely continue
with its teardown flow.

How about the (untested) alternative below:
--
[PATCH] nvmet-rdma: register ib_client to not deadlock in device
  removal

We can deadlock in case we got to a device removal
event on a queue which is already in the process of
destroying the cm_id is this is blocking until all
events on this cm_id will drain. On the other hand
we cannot guarantee that rdma_destroy_id was invoked
as we only have indication that the queue disconnect
flow has been queued (the queue state is updated before
the realease work has been queued).

So, we leave all the queue removal to a separate ib_client
to avoid this deadlock as ib_client device removal is in
a different context than the cm_id itself.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
  drivers/nvme/target/rdma.c | 100 
++++++++++++++++++++++++++++++---------------
  1 file changed, 67 insertions(+), 33 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 32aa10b521c8..56a4cba690b5 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1307,53 +1307,44 @@ static void nvmet_rdma_queue_connect_fail(struct 
rdma_cm_id *cm_id,

  /**
   * nvme_rdma_device_removal() - Handle RDMA device removal
+ * @cm_id:     rdma_cm id, used for nvmet port
   * @queue:      nvmet rdma queue (cm id qp_context)
- * @addr:      nvmet address (cm_id context)
   *
   * DEVICE_REMOVAL event notifies us that the RDMA device is about
- * to unplug so we should take care of destroying our RDMA resources.
- * This event will be generated for each allocated cm_id.
+ * to unplug. Note that this event can be generated on a normal
+ * queue cm_id and/or a device bound listener cm_id (where in this
+ * case queue will be null).
   *
- * Note that this event can be generated on a normal queue cm_id
- * and/or a device bound listener cm_id (where in this case
- * queue will be null).
- *
- * we claim ownership on destroying the cm_id. For queues we move
- * the queue state to NVMET_RDMA_IN_DEVICE_REMOVAL and for port
+ * We registered an ib_client to handle device removal for queues,
+ * so we only need to handle the listening port cm_ids. In this case
   * we nullify the priv to prevent double cm_id destruction and destroying
   * the cm_id implicitely by returning a non-zero rc to the callout.
   */
  static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
                 struct nvmet_rdma_queue *queue)
  {
-       unsigned long flags;
-
-       if (!queue) {
-               struct nvmet_port *port = cm_id->context;
+       struct nvmet_port *port;

+       if (queue) {
                 /*
-                * This is a listener cm_id. Make sure that
-                * future remove_port won't invoke a double
-                * cm_id destroy. use atomic xchg to make sure
-                * we don't compete with remove_port.
-                */
-               if (xchg(&port->priv, NULL) != cm_id)
-                       return 0;
-       } else {
-               /*
-                * This is a queue cm_id. Make sure that
-                * release queue will not destroy the cm_id
-                * and schedule all ctrl queues removal (only
-                * if the queue is not disconnecting already).
+                * This is a queue cm_id. we have registered
+                * an ib_client to handle queues removal
+                * so don't interfear and just return.
                  */
-               spin_lock_irqsave(&queue->state_lock, flags);
-               if (queue->state != NVMET_RDMA_Q_DISCONNECTING)
-                       queue->state = NVMET_RDMA_IN_DEVICE_REMOVAL;
-               spin_unlock_irqrestore(&queue->state_lock, flags);
-               nvmet_rdma_queue_disconnect(queue);
-               flush_scheduled_work();
+               return 0;
         }

+       port = cm_id->context;
+
+       /*
+        * This is a listener cm_id. Make sure that
+        * future remove_port won't invoke a double
+        * cm_id destroy. use atomic xchg to make sure
+        * we don't compete with remove_port.
+        */
+       if (xchg(&port->priv, NULL) != cm_id)
+               return 0;
+
         /*
          * We need to return 1 so that the core will destroy
          * it's own ID.  What a great API design..
@@ -1519,9 +1510,51 @@ static struct nvmet_fabrics_ops nvmet_rdma_ops = {
         .delete_ctrl            = nvmet_rdma_delete_ctrl,
  };

+static void nvmet_rdma_add_one(struct ib_device *ib_device)
+{
+}
+
+static void nvmet_rdma_remove_one(struct ib_device *ib_device, void 
*client_data)
+{
+       struct nvmet_rdma_queue *queue;
+
+       /* Device is being removed, delete all queues using this device */
+       mutex_lock(&nvmet_rdma_queue_mutex);
+       list_for_each_entry(queue, &nvmet_rdma_queue_list, queue_list) {
+               if (queue->dev->device != ib_device)
+                       continue;
+
+               pr_info("Removing queue %d\n", queue->idx);
+               __nvmet_rdma_queue_disconnect(queue);
+       }
+       mutex_unlock(&nvmet_rdma_queue_mutex);
+
+       flush_scheduled_work();
+}
+
+static struct ib_client nvmet_rdma_ib_client = {
+       .name   = "nvmet_rdma",
+       .add = nvmet_rdma_add_one,
+       .remove = nvmet_rdma_remove_one
+};
+
  static int __init nvmet_rdma_init(void)
  {
-       return nvmet_register_transport(&nvmet_rdma_ops);
+       int ret;
+
+       ret = ib_register_client(&nvmet_rdma_ib_client);
+       if (ret)
+               return ret;
+
+       ret = nvmet_register_transport(&nvmet_rdma_ops);
+       if (ret)
+               goto err_ib_client;
+
+       return 0;
+
+err_ib_client:
+       ib_unregister_client(&nvmet_rdma_ib_client);
+       return ret;
  }

  static void __exit nvmet_rdma_exit(void)
@@ -1544,6 +1577,7 @@ static void __exit nvmet_rdma_exit(void)
         mutex_unlock(&nvmet_rdma_queue_mutex);

         flush_scheduled_work();
+       ib_unregister_client(&nvmet_rdma_ib_client);
         ida_destroy(&nvmet_rdma_queue_ida);
  }

--

Unfortunately, the patch failed to produce a clear diff :/ sorry...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

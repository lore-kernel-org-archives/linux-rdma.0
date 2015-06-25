From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/cm: Do not queue a work when the device is going to be removed
Date: Thu, 25 Jun 2015 17:13:22 +0300
Message-ID: <1435241602-12104-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Whenever ib_cm gets remove_one call, like when there is a hot-unplug
event, the driver should mark itself as going_down and confirm that no
new works are going to be queued for that device.
so, the order of the actions are:
1. mark the going_down bit.
2. flush the wq.
3. [make sure no new works for that device.]
4. unregister mad agent.

otherwise, works that are already queued can be scheduled after the mad
agent was freed.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 61 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 55 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index dbddddd..3a972eb 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -169,6 +169,7 @@ struct cm_device {
 	struct ib_device *ib_device;
 	struct device *device;
 	u8 ack_delay;
+	int going_down;
 	struct cm_port *port[0];
 };
 
@@ -805,6 +806,11 @@ static void cm_enter_timewait(struct cm_id_private *cm_id_priv)
 {
 	int wait_time;
 	unsigned long flags;
+	struct cm_device *cm_dev;
+
+	cm_dev = ib_get_client_data(cm_id_priv->id.device, &cm_client);
+	if (!cm_dev)
+		return;
 
 	spin_lock_irqsave(&cm.lock, flags);
 	cm_cleanup_timewait(cm_id_priv->timewait_info);
@@ -818,8 +824,14 @@ static void cm_enter_timewait(struct cm_id_private *cm_id_priv)
 	 */
 	cm_id_priv->id.state = IB_CM_TIMEWAIT;
 	wait_time = cm_convert_to_ms(cm_id_priv->av.timeout);
-	queue_delayed_work(cm.wq, &cm_id_priv->timewait_info->work.work,
-			   msecs_to_jiffies(wait_time));
+
+	/* Check if the device started its remove_one */
+	spin_lock_irq(&cm.lock);
+	if (!cm_dev->going_down)
+		queue_delayed_work(cm.wq, &cm_id_priv->timewait_info->work.work,
+				   msecs_to_jiffies(wait_time));
+	spin_unlock_irq(&cm.lock);
+
 	cm_id_priv->timewait_info = NULL;
 }
 
@@ -3305,6 +3317,11 @@ static int cm_establish(struct ib_cm_id *cm_id)
 	struct cm_work *work;
 	unsigned long flags;
 	int ret = 0;
+	struct cm_device *cm_dev;
+
+	cm_dev = ib_get_client_data(cm_id->device, &cm_client);
+	if (!cm_dev)
+		return -ENODEV;
 
 	work = kmalloc(sizeof *work, GFP_ATOMIC);
 	if (!work)
@@ -3343,7 +3360,17 @@ static int cm_establish(struct ib_cm_id *cm_id)
 	work->remote_id = cm_id->remote_id;
 	work->mad_recv_wc = NULL;
 	work->cm_event.event = IB_CM_USER_ESTABLISHED;
-	queue_delayed_work(cm.wq, &work->work, 0);
+
+	/* Check if the device started its remove_one */
+	spin_lock_irq(&cm.lock);
+	if (!cm_dev->going_down) {
+		queue_delayed_work(cm.wq, &work->work, 0);
+	} else {
+		kfree(work);
+		ret = -ENODEV;
+	}
+	spin_unlock_irq(&cm.lock);
+
 out:
 	return ret;
 }
@@ -3394,6 +3421,7 @@ static void cm_recv_handler(struct ib_mad_agent *mad_agent,
 	enum ib_cm_event_type event;
 	u16 attr_id;
 	int paths = 0;
+	int going_down = 0;
 
 	switch (mad_recv_wc->recv_buf.mad->mad_hdr.attr_id) {
 	case CM_REQ_ATTR_ID:
@@ -3452,7 +3480,19 @@ static void cm_recv_handler(struct ib_mad_agent *mad_agent,
 	work->cm_event.event = event;
 	work->mad_recv_wc = mad_recv_wc;
 	work->port = port;
-	queue_delayed_work(cm.wq, &work->work, 0);
+
+	/* Check if the device started its remove_one */
+	spin_lock_irq(&cm.lock);
+	if (!port->cm_dev->going_down)
+		queue_delayed_work(cm.wq, &work->work, 0);
+	else
+		going_down = 1;
+	spin_unlock_irq(&cm.lock);
+
+	if (going_down) {
+		kfree(work);
+		ib_free_recv_mad(mad_recv_wc);
+	}
 }
 
 static int cm_init_qp_init_attr(struct cm_id_private *cm_id_priv,
@@ -3771,7 +3811,7 @@ static void cm_add_one(struct ib_device *ib_device)
 
 	cm_dev->ib_device = ib_device;
 	cm_get_ack_delay(cm_dev);
-
+	cm_dev->going_down = 0;
 	cm_dev->device = device_create(&cm_class, &ib_device->dev,
 				       MKDEV(0, 0), NULL,
 				       "%s", ib_device->name);
@@ -3864,14 +3904,23 @@ static void cm_remove_one(struct ib_device *ib_device)
 	list_del(&cm_dev->list);
 	write_unlock_irqrestore(&cm.device_lock, flags);
 
+	spin_lock_irq(&cm.lock);
+	cm_dev->going_down = 1;
+	spin_unlock_irq(&cm.lock);
+
 	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
 		if (!rdma_cap_ib_cm(ib_device, i))
 			continue;
 
 		port = cm_dev->port[i-1];
 		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
-		ib_unregister_mad_agent(port->mad_agent);
+		/*
+		 * We flush the queue here after the going_down set, this
+		 * verify that no new works will be queued in the recv handler,
+		 * after that we can call the unregister_mad_agent
+		 */
 		flush_workqueue(cm.wq);
+		ib_unregister_mad_agent(port->mad_agent);
 		cm_remove_port_fs(port);
 	}
 	device_unregister(cm_dev->device);
-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

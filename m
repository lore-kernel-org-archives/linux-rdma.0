From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 6/6] IB/mad: P_Key change event handler
Date: Wed, 14 Oct 2015 11:29:48 +0300
Message-ID: <1444811388-22486-7-git-send-email-haggaie@mellanox.com>
References: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444811388-22486-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a device event handler to capture P_Key table change events. For
devices that don't support setting the P_Key index per work request, update
the per-P_Key QP table in the MAD layer, creating QPs as
needed.

The code currently doesn't destroy created QPs when their pkeys are
cleared. This can be added later on.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 51 ++++++++++++++++++++++++++++++++++++--
 drivers/infiniband/core/mad_priv.h |  2 ++
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 02977942574c..a350b4117cb3 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3153,6 +3153,28 @@ static void srq_event_handler(struct ib_event *event, void *srq_context)
 		event->event, qp_num);
 }
 
+static void device_event_handler(struct ib_event_handler *handler,
+				 struct ib_event *event)
+{
+	struct ib_mad_port_private *port_priv =
+		container_of(handler, struct ib_mad_port_private,
+			     event_handler);
+
+	if (event->element.port_num != port_priv->port_num)
+		return;
+
+	dev_dbg(&port_priv->device->dev, "ib_mad: event %s on port %d\n",
+		ib_event_msg(event->event), event->element.port_num);
+
+	switch (event->event) {
+	case IB_EVENT_PKEY_CHANGE:
+		queue_work(port_priv->wq, &port_priv->pkey_change_work);
+		break;
+	default:
+		break;
+	}
+}
+
 static void init_mad_queue(struct ib_mad_qp_info *qp_info,
 			   struct ib_mad_queue *mad_queue)
 {
@@ -3306,6 +3328,15 @@ static int update_pkey_table(struct ib_mad_qp_info *qp_info)
 	return 0;
 }
 
+static void pkey_change_handler(struct work_struct *work)
+{
+	struct ib_mad_port_private *port_priv =
+		container_of(work, struct ib_mad_port_private,
+			     pkey_change_work);
+
+	update_pkey_table(&port_priv->qp_info[1]);
+}
+
 static void destroy_mad_qp(struct ib_mad_qp_info *qp_info)
 {
 	u16 qp_index;
@@ -3453,6 +3484,17 @@ static int ib_mad_port_open(struct ib_device *device,
 	}
 	INIT_WORK(&port_priv->work, ib_mad_completion_handler);
 
+	if (device->gsi_pkey_index_in_qp) {
+		INIT_WORK(&port_priv->pkey_change_work, pkey_change_handler);
+		INIT_IB_EVENT_HANDLER(&port_priv->event_handler, device,
+				      device_event_handler);
+		ret = ib_register_event_handler(&port_priv->event_handler);
+		if (ret) {
+			dev_err(&device->dev, "Unable to register event handler for ib_mad\n");
+			goto error9;
+		}
+	}
+
 	spin_lock_irqsave(&ib_mad_port_list_lock, flags);
 	list_add_tail(&port_priv->port_list, &ib_mad_port_list);
 	spin_unlock_irqrestore(&ib_mad_port_list_lock, flags);
@@ -3460,16 +3502,19 @@ static int ib_mad_port_open(struct ib_device *device,
 	ret = ib_mad_port_start(port_priv);
 	if (ret) {
 		dev_err(&device->dev, "Couldn't start port\n");
-		goto error9;
+		goto error10;
 	}
 
 	return 0;
 
-error9:
+error10:
 	spin_lock_irqsave(&ib_mad_port_list_lock, flags);
 	list_del_init(&port_priv->port_list);
 	spin_unlock_irqrestore(&ib_mad_port_list_lock, flags);
 
+	if (device->gsi_pkey_index_in_qp)
+		ib_unregister_event_handler(&port_priv->event_handler);
+error9:
 	destroy_workqueue(port_priv->wq);
 error8:
 	destroy_mad_qp(&port_priv->qp_info[1]);
@@ -3507,6 +3552,8 @@ static int ib_mad_port_close(struct ib_device *device, int port_num)
 	list_del_init(&port_priv->port_list);
 	spin_unlock_irqrestore(&ib_mad_port_list_lock, flags);
 
+	if (device->gsi_pkey_index_in_qp)
+		ib_unregister_event_handler(&port_priv->event_handler);
 	destroy_workqueue(port_priv->wq);
 	destroy_mad_qp(&port_priv->qp_info[1]);
 	destroy_mad_qp(&port_priv->qp_info[0]);
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 32b9532c7868..ee8003648d8a 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -211,6 +211,8 @@ struct ib_mad_port_private {
 	struct workqueue_struct *wq;
 	struct work_struct work;
 	struct ib_mad_qp_info qp_info[IB_MAD_QPS_CORE];
+	struct ib_event_handler event_handler;
+	struct work_struct pkey_change_work;
 };
 
 int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr);
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

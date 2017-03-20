From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/7] IB/SA: Move functions update_sm_ah() and ib_sa_event()
Date: Mon, 20 Mar 2017 19:38:07 -0400
Message-ID: <1490053090-32840-5-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Moving these will facilitate changes to these in the
next patchs. This is strictly a move and there are no
changes to the functions in any way.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 172 ++++++++++++++++++-------------------
 1 file changed, 86 insertions(+), 86 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index b04b499..2181f8c 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -931,92 +931,6 @@ static void free_sm_ah(struct kref *kref)
 	kfree(sm_ah);
 }
 
-static void update_sm_ah(struct work_struct *work)
-{
-	struct ib_sa_port *port =
-		container_of(work, struct ib_sa_port, update_task);
-	struct ib_sa_sm_ah *new_ah;
-	struct ib_port_attr port_attr;
-	struct ib_ah_attr   ah_attr;
-
-	if (ib_query_port(port->agent->device, port->port_num, &port_attr)) {
-		pr_warn("Couldn't query port\n");
-		return;
-	}
-
-	new_ah = kmalloc(sizeof(*new_ah), GFP_KERNEL);
-	if (!new_ah)
-		return;
-
-	kref_init(&new_ah->ref);
-	new_ah->src_path_mask = (1 << port_attr.lmc) - 1;
-
-	new_ah->pkey_index = 0;
-	if (ib_find_pkey(port->agent->device, port->port_num,
-			 IB_DEFAULT_PKEY_FULL, &new_ah->pkey_index))
-		pr_err("Couldn't find index for default PKey\n");
-
-	memset(&ah_attr, 0, sizeof(ah_attr));
-	ah_attr.dlid     = port_attr.sm_lid;
-	ah_attr.sl       = port_attr.sm_sl;
-	ah_attr.port_num = port->port_num;
-	if (port_attr.grh_required) {
-		ah_attr.ah_flags = IB_AH_GRH;
-		ah_attr.grh.dgid.global.subnet_prefix =
-			cpu_to_be64(port_attr.subnet_prefix);
-		ah_attr.grh.dgid.global.interface_id =
-			cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
-	}
-
-	new_ah->ah = ib_create_ah(port->agent->qp->pd, &ah_attr);
-	if (IS_ERR(new_ah->ah)) {
-		pr_warn("Couldn't create new SM AH\n");
-		kfree(new_ah);
-		return;
-	}
-
-	spin_lock_irq(&port->ah_lock);
-	if (port->sm_ah)
-		kref_put(&port->sm_ah->ref, free_sm_ah);
-	port->sm_ah = new_ah;
-	spin_unlock_irq(&port->ah_lock);
-}
-
-static void ib_sa_event(struct ib_event_handler *handler,
-			struct ib_event *event)
-{
-	if (event->event == IB_EVENT_PORT_ERR    ||
-	    event->event == IB_EVENT_PORT_ACTIVE ||
-	    event->event == IB_EVENT_LID_CHANGE  ||
-	    event->event == IB_EVENT_PKEY_CHANGE ||
-	    event->event == IB_EVENT_SM_CHANGE   ||
-	    event->event == IB_EVENT_CLIENT_REREGISTER) {
-		unsigned long flags;
-		struct ib_sa_device *sa_dev =
-			container_of(handler, typeof(*sa_dev), event_handler);
-		u8 port_num = event->element.port_num - sa_dev->start_port;
-		struct ib_sa_port *port = &sa_dev->port[port_num];
-
-		if (!rdma_cap_ib_sa(handler->device, port->port_num))
-			return;
-
-		spin_lock_irqsave(&port->ah_lock, flags);
-		if (port->sm_ah)
-			kref_put(&port->sm_ah->ref, free_sm_ah);
-		port->sm_ah = NULL;
-		spin_unlock_irqrestore(&port->ah_lock, flags);
-
-		if (event->event == IB_EVENT_SM_CHANGE ||
-		    event->event == IB_EVENT_CLIENT_REREGISTER ||
-		    event->event == IB_EVENT_LID_CHANGE) {
-			spin_lock_irqsave(&port->classport_lock, flags);
-			port->classport_info.valid = false;
-			spin_unlock_irqrestore(&port->classport_lock, flags);
-		}
-		queue_work(ib_wq, &sa_dev->port[port_num].update_task);
-	}
-}
-
 void ib_sa_register_client(struct ib_sa_client *client)
 {
 	atomic_set(&client->users, 1);
@@ -1897,6 +1811,92 @@ static void recv_handler(struct ib_mad_agent *mad_agent,
 	ib_free_recv_mad(mad_recv_wc);
 }
 
+static void update_sm_ah(struct work_struct *work)
+{
+	struct ib_sa_port *port =
+		container_of(work, struct ib_sa_port, update_task);
+	struct ib_sa_sm_ah *new_ah;
+	struct ib_port_attr port_attr;
+	struct ib_ah_attr   ah_attr;
+
+	if (ib_query_port(port->agent->device, port->port_num, &port_attr)) {
+		pr_warn("Couldn't query port\n");
+		return;
+	}
+
+	new_ah = kmalloc(sizeof(*new_ah), GFP_KERNEL);
+	if (!new_ah)
+		return;
+
+	kref_init(&new_ah->ref);
+	new_ah->src_path_mask = (1 << port_attr.lmc) - 1;
+
+	new_ah->pkey_index = 0;
+	if (ib_find_pkey(port->agent->device, port->port_num,
+			 IB_DEFAULT_PKEY_FULL, &new_ah->pkey_index))
+		pr_err("Couldn't find index for default PKey\n");
+
+	memset(&ah_attr, 0, sizeof(ah_attr));
+	ah_attr.dlid     = port_attr.sm_lid;
+	ah_attr.sl       = port_attr.sm_sl;
+	ah_attr.port_num = port->port_num;
+	if (port_attr.grh_required) {
+		ah_attr.ah_flags = IB_AH_GRH;
+		ah_attr.grh.dgid.global.subnet_prefix =
+			cpu_to_be64(port_attr.subnet_prefix);
+		ah_attr.grh.dgid.global.interface_id =
+			cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
+	}
+
+	new_ah->ah = ib_create_ah(port->agent->qp->pd, &ah_attr);
+	if (IS_ERR(new_ah->ah)) {
+		pr_warn("Couldn't create new SM AH\n");
+		kfree(new_ah);
+		return;
+	}
+
+	spin_lock_irq(&port->ah_lock);
+	if (port->sm_ah)
+		kref_put(&port->sm_ah->ref, free_sm_ah);
+	port->sm_ah = new_ah;
+	spin_unlock_irq(&port->ah_lock);
+}
+
+static void ib_sa_event(struct ib_event_handler *handler,
+			struct ib_event *event)
+{
+	if (event->event == IB_EVENT_PORT_ERR    ||
+	    event->event == IB_EVENT_PORT_ACTIVE ||
+	    event->event == IB_EVENT_LID_CHANGE  ||
+	    event->event == IB_EVENT_PKEY_CHANGE ||
+	    event->event == IB_EVENT_SM_CHANGE   ||
+	    event->event == IB_EVENT_CLIENT_REREGISTER) {
+		unsigned long flags;
+		struct ib_sa_device *sa_dev =
+			container_of(handler, typeof(*sa_dev), event_handler);
+		u8 port_num = event->element.port_num - sa_dev->start_port;
+		struct ib_sa_port *port = &sa_dev->port[port_num];
+
+		if (!rdma_cap_ib_sa(handler->device, port->port_num))
+			return;
+
+		spin_lock_irqsave(&port->ah_lock, flags);
+		if (port->sm_ah)
+			kref_put(&port->sm_ah->ref, free_sm_ah);
+		port->sm_ah = NULL;
+		spin_unlock_irqrestore(&port->ah_lock, flags);
+
+		if (event->event == IB_EVENT_SM_CHANGE ||
+		    event->event == IB_EVENT_CLIENT_REREGISTER ||
+		    event->event == IB_EVENT_LID_CHANGE) {
+			spin_lock_irqsave(&port->classport_lock, flags);
+			port->classport_info.valid = false;
+			spin_unlock_irqrestore(&port->classport_lock, flags);
+		}
+		queue_work(ib_wq, &sa_dev->port[port_num].update_task);
+	}
+}
+
 static void ib_sa_add_one(struct ib_device *device)
 {
 	struct ib_sa_device *sa_dev;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

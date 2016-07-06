From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH V1 for-next 1/2] IB/sa: Add cached attribute containing SM information to SA port
Date: Wed,  6 Jul 2016 16:36:34 +0300
Message-ID: <1467812195-22221-2-git-send-email-leon@kernel.org>
References: <1467812195-22221-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467812195-22221-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Added a new SA port attribute containing SM ClassPortInfo fields,
(ClassPortInfo fields: Table 126 IB Spec 1.3.). This is useful for
checking SM support for specific features. The attribute is cached
to avoid resending queries, caching is done when a successful
ClassPortInfo reply is received on the port. Invalidation of the
attribute is done on SM change events, SM re-registration events,
and SM LID change events. The fields in ClassPortInfo should not
change during SM runtime without an event.

Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index e955386..b9bf7aa 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -65,10 +65,17 @@ struct ib_sa_sm_ah {
 	u8		     src_path_mask;
 };
 
+struct ib_sa_classport_cache {
+	bool valid;
+	struct ib_class_port_info data;
+};
+
 struct ib_sa_port {
 	struct ib_mad_agent *agent;
 	struct ib_sa_sm_ah  *sm_ah;
 	struct work_struct   update_task;
+	struct ib_sa_classport_cache classport_info;
+	spinlock_t                   classport_lock; /* protects class port info set */
 	spinlock_t           ah_lock;
 	u8                   port_num;
 };
@@ -998,6 +1005,13 @@ static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event
 		port->sm_ah = NULL;
 		spin_unlock_irqrestore(&port->ah_lock, flags);
 
+		if (event->event == IB_EVENT_SM_CHANGE ||
+		    event->event == IB_EVENT_CLIENT_REREGISTER ||
+		    event->event == IB_EVENT_LID_CHANGE) {
+			spin_lock_irqsave(&port->classport_lock, flags);
+			port->classport_info.valid = false;
+			spin_unlock_irqrestore(&port->classport_lock, flags);
+		}
 		queue_work(ib_wq, &sa_dev->port[event->element.port_num -
 					    sa_dev->start_port].update_task);
 	}
@@ -1719,6 +1733,7 @@ static void ib_sa_classport_info_rec_callback(struct ib_sa_query *sa_query,
 					      int status,
 					      struct ib_sa_mad *mad)
 {
+	unsigned long flags;
 	struct ib_sa_classport_info_query *query =
 		container_of(sa_query, struct ib_sa_classport_info_query, sa_query);
 
@@ -1728,6 +1743,16 @@ static void ib_sa_classport_info_rec_callback(struct ib_sa_query *sa_query,
 		ib_unpack(classport_info_rec_table,
 			  ARRAY_SIZE(classport_info_rec_table),
 			  mad->data, &rec);
+
+		spin_lock_irqsave(&sa_query->port->classport_lock, flags);
+		if (!status && !sa_query->port->classport_info.valid) {
+			memcpy(&sa_query->port->classport_info.data, &rec,
+			       sizeof(sa_query->port->classport_info.data));
+
+			sa_query->port->classport_info.valid = true;
+		}
+		spin_unlock_irqrestore(&sa_query->port->classport_lock, flags);
+
 		query->callback(status, &rec, query->context);
 	} else {
 		query->callback(status, NULL, query->context);
@@ -1754,7 +1779,9 @@ int ib_sa_classport_info_rec_query(struct ib_sa_client *client,
 	struct ib_sa_port *port;
 	struct ib_mad_agent *agent;
 	struct ib_sa_mad *mad;
+	struct ib_class_port_info cached_class_port_info;
 	int ret;
+	unsigned long flags;
 
 	if (!sa_dev)
 		return -ENODEV;
@@ -1762,6 +1789,17 @@ int ib_sa_classport_info_rec_query(struct ib_sa_client *client,
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
 	agent = port->agent;
 
+	/* Use cached ClassPortInfo attribute if valid instead of sending mad */
+	spin_lock_irqsave(&port->classport_lock, flags);
+	if (port->classport_info.valid && callback) {
+		memcpy(&cached_class_port_info, &port->classport_info.data,
+		       sizeof(cached_class_port_info));
+		spin_unlock_irqrestore(&port->classport_lock, flags);
+		callback(0, &cached_class_port_info, context);
+		return 0;
+	}
+	spin_unlock_irqrestore(&port->classport_lock, flags);
+
 	query = kzalloc(sizeof(*query), gfp_mask);
 	if (!query)
 		return -ENOMEM;
@@ -1885,6 +1923,9 @@ static void ib_sa_add_one(struct ib_device *device)
 		sa_dev->port[i].sm_ah    = NULL;
 		sa_dev->port[i].port_num = i + s;
 
+		spin_lock_init(&sa_dev->port[i].classport_lock);
+		sa_dev->port[i].classport_info.valid = false;
+
 		sa_dev->port[i].agent =
 			ib_register_mad_agent(device, i + s, IB_QPT_GSI,
 					      NULL, 0, send_handler,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

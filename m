From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/7] IB/SA: Fix lines longer than 80 columns
Date: Mon, 20 Mar 2017 19:38:04 -0400
Message-ID: <1490053090-32840-2-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This fixes a checkpatch issue. The fix is needed
so that some of these functions can be moved around
in the forthcoming patches

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 81b742c..60c0405 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -963,8 +963,10 @@ static void update_sm_ah(struct work_struct *work)
 	ah_attr.port_num = port->port_num;
 	if (port_attr.grh_required) {
 		ah_attr.ah_flags = IB_AH_GRH;
-		ah_attr.grh.dgid.global.subnet_prefix = cpu_to_be64(port_attr.subnet_prefix);
-		ah_attr.grh.dgid.global.interface_id = cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
+		ah_attr.grh.dgid.global.subnet_prefix =
+			cpu_to_be64(port_attr.subnet_prefix);
+		ah_attr.grh.dgid.global.interface_id =
+			cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
 	}
 
 	new_ah->ah = ib_create_ah(port->agent->qp->pd, &ah_attr);
@@ -979,10 +981,10 @@ static void update_sm_ah(struct work_struct *work)
 		kref_put(&port->sm_ah->ref, free_sm_ah);
 	port->sm_ah = new_ah;
 	spin_unlock_irq(&port->ah_lock);
-
 }
 
-static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event)
+static void ib_sa_event(struct ib_event_handler *handler,
+			struct ib_event *event)
 {
 	if (event->event == IB_EVENT_PORT_ERR    ||
 	    event->event == IB_EVENT_PORT_ACTIVE ||
@@ -993,8 +995,8 @@ static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event
 		unsigned long flags;
 		struct ib_sa_device *sa_dev =
 			container_of(handler, typeof(*sa_dev), event_handler);
-		struct ib_sa_port *port =
-			&sa_dev->port[event->element.port_num - sa_dev->start_port];
+		u8 port_num = event->element.port_num - sa_dev->start_port;
+		struct ib_sa_port *port = &sa_dev->port[port_num];
 
 		if (!rdma_cap_ib_sa(handler->device, port->port_num))
 			return;
@@ -1012,8 +1014,7 @@ static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event
 			port->classport_info.valid = false;
 			spin_unlock_irqrestore(&port->classport_lock, flags);
 		}
-		queue_work(ib_wq, &sa_dev->port[event->element.port_num -
-					    sa_dev->start_port].update_task);
+		queue_work(ib_wq, &sa_dev->port[port_num].update_task);
 	}
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

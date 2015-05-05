From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v8 05/23] IB/Verbs: Reform IB-core sa_query
Date: Tue,  5 May 2015 14:50:22 +0200
Message-ID: <1430830240-32389-6-git-send-email-yun.wang@profitbricks.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430830240-32389-1-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use raw management helpers to reform IB-core sa_query.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index c38f030..b115c28 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -450,7 +450,7 @@ static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event
 		struct ib_sa_port *port =
 			&sa_dev->port[event->element.port_num - sa_dev->start_port];
 
-		if (rdma_port_get_link_layer(handler->device, port->port_num) != IB_LINK_LAYER_INFINIBAND)
+		if (WARN_ON(!rdma_protocol_ib(handler->device, port->port_num)))
 			return;
 
 		spin_lock_irqsave(&port->ah_lock, flags);
@@ -540,7 +540,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 	ah_attr->port_num = port_num;
 	ah_attr->static_rate = rec->rate;
 
-	force_grh = rdma_port_get_link_layer(device, port_num) == IB_LINK_LAYER_ETHERNET;
+	force_grh = rdma_protocol_iboe(device, port_num);
 
 	if (rec->hop_limit > 1 || force_grh) {
 		ah_attr->ah_flags = IB_AH_GRH;
@@ -1153,9 +1153,7 @@ static void ib_sa_add_one(struct ib_device *device)
 {
 	struct ib_sa_device *sa_dev;
 	int s, e, i;
-
-	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
-		return;
+	int count = 0;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH)
 		s = e = 0;
@@ -1175,7 +1173,7 @@ static void ib_sa_add_one(struct ib_device *device)
 
 	for (i = 0; i <= e - s; ++i) {
 		spin_lock_init(&sa_dev->port[i].ah_lock);
-		if (rdma_port_get_link_layer(device, i + 1) != IB_LINK_LAYER_INFINIBAND)
+		if (!rdma_protocol_ib(device, i + 1))
 			continue;
 
 		sa_dev->port[i].sm_ah    = NULL;
@@ -1189,8 +1187,13 @@ static void ib_sa_add_one(struct ib_device *device)
 			goto err;
 
 		INIT_WORK(&sa_dev->port[i].update_task, update_sm_ah);
+
+		count++;
 	}
 
+	if (!count)
+		goto free;
+
 	ib_set_client_data(device, &sa_client, sa_dev);
 
 	/*
@@ -1204,19 +1207,20 @@ static void ib_sa_add_one(struct ib_device *device)
 	if (ib_register_event_handler(&sa_dev->event_handler))
 		goto err;
 
-	for (i = 0; i <= e - s; ++i)
-		if (rdma_port_get_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND)
+	for (i = 0; i <= e - s; ++i) {
+		if (rdma_protocol_ib(device, i + 1))
 			update_sm_ah(&sa_dev->port[i].update_task);
+	}
 
 	return;
 
 err:
-	while (--i >= 0)
-		if (rdma_port_get_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND)
+	while (--i >= 0) {
+		if (rdma_protocol_ib(device, i + 1))
 			ib_unregister_mad_agent(sa_dev->port[i].agent);
-
+	}
+free:
 	kfree(sa_dev);
-
 	return;
 }
 
@@ -1233,7 +1237,7 @@ static void ib_sa_remove_one(struct ib_device *device)
 	flush_workqueue(ib_wq);
 
 	for (i = 0; i <= sa_dev->end_port - sa_dev->start_port; ++i) {
-		if (rdma_port_get_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND) {
+		if (rdma_protocol_ib(device, i + 1)) {
 			ib_unregister_mad_agent(sa_dev->port[i].agent);
 			if (sa_dev->port[i].sm_ah)
 				kref_put(&sa_dev->port[i].sm_ah->ref, free_sm_ah);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

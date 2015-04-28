From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v7 05/23] IB/Verbs: Reform IB-core sa_query
Date: Tue, 28 Apr 2015 17:10:05 +0200
Message-ID: <1430233823-7075-6-git-send-email-yun.wang@profitbricks.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org

Use raw management helpers to reform IB-core sa_query.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
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

From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v7 19/23] IB/Verbs: Use management helper cap_ib_sa()
Date: Tue, 28 Apr 2015 17:10:19 +0200
Message-ID: <1430233823-7075-20-git-send-email-yun.wang@profitbricks.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org

Introduce helper cap_ib_sa() to help us check if the port of an
IB device support Infiniband Subnet Administration.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cma.c      |  4 ++--
 drivers/infiniband/core/sa_query.c | 10 +++++-----
 drivers/infiniband/core/ucma.c     |  2 +-
 include/rdma/ib_verbs.h            | 15 +++++++++++++++
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7d55296..ec3a901 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -933,7 +933,7 @@ static inline int cma_user_data_offset(struct rdma_id_private *id_priv)
 
 static void cma_cancel_route(struct rdma_id_private *id_priv)
 {
-	if (rdma_protocol_ib(id_priv->id.device, id_priv->id.port_num)) {
+	if (cap_ib_sa(id_priv->id.device, id_priv->id.port_num)) {
 		if (id_priv->query)
 			ib_sa_cancel_query(id_priv->query_id, id_priv->query);
 	}
@@ -1957,7 +1957,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 		return -EINVAL;
 
 	atomic_inc(&id_priv->refcount);
-	if (rdma_protocol_ib(id->device, id->port_num))
+	if (cap_ib_sa(id->device, id->port_num))
 		ret = cma_resolve_ib_route(id_priv, timeout_ms);
 	else if (rdma_protocol_iboe(id->device, id->port_num))
 		ret = cma_resolve_iboe_route(id_priv);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index b115c28..c82aa48 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -450,7 +450,7 @@ static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event
 		struct ib_sa_port *port =
 			&sa_dev->port[event->element.port_num - sa_dev->start_port];
 
-		if (WARN_ON(!rdma_protocol_ib(handler->device, port->port_num)))
+		if (WARN_ON(!cap_ib_sa(handler->device, port->port_num)))
 			return;
 
 		spin_lock_irqsave(&port->ah_lock, flags);
@@ -1173,7 +1173,7 @@ static void ib_sa_add_one(struct ib_device *device)
 
 	for (i = 0; i <= e - s; ++i) {
 		spin_lock_init(&sa_dev->port[i].ah_lock);
-		if (!rdma_protocol_ib(device, i + 1))
+		if (!cap_ib_sa(device, i + 1))
 			continue;
 
 		sa_dev->port[i].sm_ah    = NULL;
@@ -1208,7 +1208,7 @@ static void ib_sa_add_one(struct ib_device *device)
 		goto err;
 
 	for (i = 0; i <= e - s; ++i) {
-		if (rdma_protocol_ib(device, i + 1))
+		if (cap_ib_sa(device, i + 1))
 			update_sm_ah(&sa_dev->port[i].update_task);
 	}
 
@@ -1216,7 +1216,7 @@ static void ib_sa_add_one(struct ib_device *device)
 
 err:
 	while (--i >= 0) {
-		if (rdma_protocol_ib(device, i + 1))
+		if (cap_ib_sa(device, i + 1))
 			ib_unregister_mad_agent(sa_dev->port[i].agent);
 	}
 free:
@@ -1237,7 +1237,7 @@ static void ib_sa_remove_one(struct ib_device *device)
 	flush_workqueue(ib_wq);
 
 	for (i = 0; i <= sa_dev->end_port - sa_dev->start_port; ++i) {
-		if (rdma_protocol_ib(device, i + 1)) {
+		if (cap_ib_sa(device, i + 1)) {
 			ib_unregister_mad_agent(sa_dev->port[i].agent);
 			if (sa_dev->port[i].sm_ah)
 				kref_put(&sa_dev->port[i].sm_ah->ref, free_sm_ah);
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index dae7620..6204065 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -723,7 +723,7 @@ static ssize_t ucma_query_route(struct ucma_file *file,
 	resp.node_guid = (__force __u64) ctx->cm_id->device->node_guid;
 	resp.port_num = ctx->cm_id->port_num;
 
-	if (rdma_protocol_ib(ctx->cm_id->device, ctx->cm_id->port_num))
+	if (cap_ib_sa(ctx->cm_id->device, ctx->cm_id->port_num))
 		ucma_copy_ib_route(&resp, &ctx->cm_id->route);
 	else if (rdma_protocol_iboe(ctx->cm_id->device, ctx->cm_id->port_num))
 		ucma_copy_iboe_route(&resp, &ctx->cm_id->route);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d69e467..f3d9760 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1834,6 +1834,21 @@ static inline int cap_iw_cm(struct ib_device *device, u8 port_num)
 	return rdma_protocol_iwarp(device, port_num);
 }
 
+/**
+ * cap_ib_sa - Check if the port of device has the capability Infiniband
+ * Subnet Administration.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support Infiniband
+ * Subnet Administration.
+ */
+static inline int cap_ib_sa(struct ib_device *device, u8 port_num)
+{
+	return rdma_protocol_ib(device, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0

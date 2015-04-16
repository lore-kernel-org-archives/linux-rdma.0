From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v4 21/27] IB/Verbs: Use management helper cap_ib_mcast()
Date: Thu, 16 Apr 2015 10:13:15 +0200
Message-ID: <552F6F1B.7040507@profitbricks.com>
References: <552F6CF2.4000606@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552F6CF2.4000606@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, hal@dev.mellanox.co.il, Michael Wang <yun.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org


Introduce helper cap_ib_mcast() to help us check if the port of an
IB device support Infiniband Multicast.

Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cma.c       |  6 +++---
 drivers/infiniband/core/multicast.c |  6 +++---
 include/rdma/ib_verbs.h             | 15 +++++++++++++++
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 094816f..0ae88dc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1029,7 +1029,7 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 		mc = container_of(id_priv->mc_list.next,
 				  struct cma_multicast, list);
 		list_del(&mc->list);
-		if (rdma_tech_ib(id_priv->cma_dev->device,
+		if (cap_ib_mcast(id_priv->cma_dev->device,
 				      id_priv->id.port_num)) {
 			ib_sa_free_multicast(mc->multicast.ib);
 			kfree(mc);
@@ -3343,7 +3343,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	if (rdma_tech_iboe(id->device, id->port_num)) {
 		kref_init(&mc->mcref);
 		ret = cma_iboe_join_multicast(id_priv, mc);
-	} else if (rdma_tech_ib(id->device, id->port_num))
+	} else if (cap_ib_mcast(id->device, id->port_num))
 		ret = cma_join_ib_multicast(id_priv, mc);
 	else
 		ret = -ENOSYS;
@@ -3377,7 +3377,7 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 
 			BUG_ON(id_priv->cma_dev->device != id->device);
 
-			if (rdma_tech_ib(id->device, id->port_num)) {
+			if (cap_ib_mcast(id->device, id->port_num)) {
 				ib_sa_free_multicast(mc->multicast.ib);
 				kfree(mc);
 			} else if (rdma_tech_iboe(id->device,
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 24d93f5..bdc1880 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -780,7 +780,7 @@ static void mcast_event_handler(struct ib_event_handler *handler,
 	int index;
 
 	dev = container_of(handler, struct mcast_device, event_handler);
-	if (WARN_ON(!rdma_tech_ib(dev->device, event->element.port_num)))
+	if (WARN_ON(!cap_ib_mcast(dev->device, event->element.port_num)))
 		return;
 
 	index = event->element.port_num - dev->start_port;
@@ -820,7 +820,7 @@ static void mcast_add_one(struct ib_device *device)
 	}
 
 	for (i = 0; i <= dev->end_port - dev->start_port; i++) {
-		if (!rdma_tech_ib(device, dev->start_port + i))
+		if (!cap_ib_mcast(device, dev->start_port + i))
 			continue;
 		port = &dev->port[i];
 		port->dev = dev;
@@ -858,7 +858,7 @@ static void mcast_remove_one(struct ib_device *device)
 	flush_workqueue(mcast_wq);
 
 	for (i = 0; i <= dev->end_port - dev->start_port; i++) {
-		if (rdma_tech_ib(device, dev->start_port + i)) {
+		if (cap_ib_mcast(device, dev->start_port + i)) {
 			port = &dev->port[i];
 			deref_port(port);
 			wait_for_completion(&port->comp);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 3bfdf81..b2cee8d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1848,6 +1848,21 @@ static inline int cap_ib_sa(struct ib_device *device, u8 port_num)
 	return rdma_tech_ib(device, port_num);
 }
 
+/**
+ * cap_ib_mcast - Check if the port of device has the capability Infiniband
+ * Multicast.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support Infiniband
+ * Multicast.
+ */
+static inline int cap_ib_mcast(struct ib_device *device, u8 port_num)
+{
+	return cap_ib_sa(device, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0

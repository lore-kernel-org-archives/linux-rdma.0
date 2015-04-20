From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v5 12/27] IB/Verbs: Reform mcast related part in IB-core cma
Date: Mon, 20 Apr 2015 10:37:35 +0200
Message-ID: <5534BACF.3080700@profitbricks.com>
References: <5534B8C9.506@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5534B8C9.506@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il
Cc: Michael Wang <yun.wang@profitbricks.com>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org


Use raw management helpers to reform mcast related part in IB-core cma.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cma.c | 56 ++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index fa69f34..a89c246 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -997,17 +997,12 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 		mc = container_of(id_priv->mc_list.next,
 				  struct cma_multicast, list);
 		list_del(&mc->list);
-		switch (rdma_port_get_link_layer(id_priv->cma_dev->device, id_priv->id.port_num)) {
-		case IB_LINK_LAYER_INFINIBAND:
+		if (rdma_tech_ib(id_priv->cma_dev->device,
+				      id_priv->id.port_num)) {
 			ib_sa_free_multicast(mc->multicast.ib);
 			kfree(mc);
-			break;
-		case IB_LINK_LAYER_ETHERNET:
+		} else
 			kref_put(&mc->mcref, release_mc);
-			break;
-		default:
-			break;
-		}
 	}
 }
 
@@ -3314,24 +3309,13 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	list_add(&mc->list, &id_priv->mc_list);
 	spin_unlock(&id_priv->lock);
 
-	switch (rdma_node_get_transport(id->device->node_type)) {
-	case RDMA_TRANSPORT_IB:
-		switch (rdma_port_get_link_layer(id->device, id->port_num)) {
-		case IB_LINK_LAYER_INFINIBAND:
-			ret = cma_join_ib_multicast(id_priv, mc);
-			break;
-		case IB_LINK_LAYER_ETHERNET:
-			kref_init(&mc->mcref);
-			ret = cma_iboe_join_multicast(id_priv, mc);
-			break;
-		default:
-			ret = -EINVAL;
-		}
-		break;
-	default:
+	if (rdma_tech_iboe(id->device, id->port_num)) {
+		kref_init(&mc->mcref);
+		ret = cma_iboe_join_multicast(id_priv, mc);
+	} else if (rdma_tech_ib(id->device, id->port_num))
+		ret = cma_join_ib_multicast(id_priv, mc);
+	else
 		ret = -ENOSYS;
-		break;
-	}
 
 	if (ret) {
 		spin_lock_irq(&id_priv->lock);
@@ -3359,19 +3343,15 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 				ib_detach_mcast(id->qp,
 						&mc->multicast.ib->rec.mgid,
 						be16_to_cpu(mc->multicast.ib->rec.mlid));
-			if (rdma_node_get_transport(id_priv->cma_dev->device->node_type) == RDMA_TRANSPORT_IB) {
-				switch (rdma_port_get_link_layer(id->device, id->port_num)) {
-				case IB_LINK_LAYER_INFINIBAND:
-					ib_sa_free_multicast(mc->multicast.ib);
-					kfree(mc);
-					break;
-				case IB_LINK_LAYER_ETHERNET:
-					kref_put(&mc->mcref, release_mc);
-					break;
-				default:
-					break;
-				}
-			}
+
+			BUG_ON(id_priv->cma_dev->device != id->device);
+
+			if (rdma_tech_ib(id->device, id->port_num)) {
+				ib_sa_free_multicast(mc->multicast.ib);
+				kfree(mc);
+			} else if (rdma_tech_iboe(id->device, id->port_num))
+				kref_put(&mc->mcref, release_mc);
+
 			return;
 		}
 	}
-- 
2.1.0

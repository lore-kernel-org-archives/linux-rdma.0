From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v6 13/26] IB/Verbs: Reserve legacy transport type in 'dev_addr'
Date: Fri, 24 Apr 2015 14:23:37 +0200
Message-ID: <1429878230-11749-14-git-send-email-yun.wang@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Reserve the legacy transport type for the 'transport' member
of 'struct rdma_dev_addr' until we make sure this is no
longer needed.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cma.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a89c246..e47284e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -244,14 +244,35 @@ static inline void cma_set_ip_ver(struct cma_hdr *hdr, u8 ip_ver)
 	hdr->ip_version = (ip_ver << 4) | (hdr->ip_version & 0xF);
 }
 
+static inline void cma_set_legacy_transport(struct rdma_cm_id *id)
+{
+	switch (id->device->node_type) {
+	case RDMA_NODE_IB_CA:
+	case RDMA_NODE_IB_SWITCH:
+	case RDMA_NODE_IB_ROUTER:
+		id->route.addr.dev_addr.transport = RDMA_TRANSPORT_IB;
+		break;
+	case RDMA_NODE_RNIC:
+		id->route.addr.dev_addr.transport = RDMA_TRANSPORT_IWARP;
+		break;
+	case RDMA_NODE_USNIC:
+		id->route.addr.dev_addr.transport = RDMA_TRANSPORT_USNIC;
+		break;
+	case RDMA_NODE_USNIC_UDP:
+		id->route.addr.dev_addr.transport = RDMA_TRANSPORT_USNIC_UDP;
+		break;
+	default:
+		BUG();
+	}
+}
+
 static void cma_attach_to_dev(struct rdma_id_private *id_priv,
 			      struct cma_device *cma_dev)
 {
 	atomic_inc(&cma_dev->refcount);
 	id_priv->cma_dev = cma_dev;
 	id_priv->id.device = cma_dev->device;
-	id_priv->id.route.addr.dev_addr.transport =
-		rdma_node_get_transport(cma_dev->device->node_type);
+	cma_set_legacy_transport(&id_priv->id);
 	list_add_tail(&id_priv->list, &cma_dev->id_list);
 }
 
-- 
2.1.0

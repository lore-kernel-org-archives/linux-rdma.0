From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v6 26/26] IB/Verbs: Cleanup rdma_node_get_transport()
Date: Fri, 24 Apr 2015 14:23:50 +0200
Message-ID: <1429878230-11749-27-git-send-email-yun.wang@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

We have get rid of all the scene using legacy rdma_node_get_transport(),
now clean it up.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/verbs.c | 21 ---------------------
 include/rdma/ib_verbs.h         |  3 ---
 2 files changed, 24 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 44e25c1..7dc08b1 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -107,27 +107,6 @@ __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate)
 }
 EXPORT_SYMBOL(ib_rate_to_mbps);
 
-__attribute_const__ enum rdma_transport_type
-rdma_node_get_transport(enum rdma_node_type node_type)
-{
-	switch (node_type) {
-	case RDMA_NODE_IB_CA:
-	case RDMA_NODE_IB_SWITCH:
-	case RDMA_NODE_IB_ROUTER:
-		return RDMA_TRANSPORT_IB;
-	case RDMA_NODE_RNIC:
-		return RDMA_TRANSPORT_IWARP;
-	case RDMA_NODE_USNIC:
-		return RDMA_TRANSPORT_USNIC;
-	case RDMA_NODE_USNIC_UDP:
-		return RDMA_TRANSPORT_USNIC_UDP;
-	default:
-		BUG();
-		return 0;
-	}
-}
-EXPORT_SYMBOL(rdma_node_get_transport);
-
 enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_num)
 {
 	if (device->get_link_layer)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0def4e1..d051500 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -84,9 +84,6 @@ enum rdma_transport_type {
 	RDMA_TRANSPORT_IBOE,
 };
 
-__attribute_const__ enum rdma_transport_type
-rdma_node_get_transport(enum rdma_node_type node_type);
-
 enum rdma_link_layer {
 	IB_LINK_LAYER_UNSPECIFIED,
 	IB_LINK_LAYER_INFINIBAND,
-- 
2.1.0

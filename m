From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v3 28/28] IB/Verbs: Cleanup rdma_node_get_transport()
Date: Mon, 13 Apr 2015 14:37:13 +0200
Message-ID: <552BB879.4000409@profitbricks.com>
References: <552BB470.4090407@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552BB470.4090407@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Michael Wang <yun.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org


We have get rid of all the scene using legacy rdma_node_get_transport(),
now clean it up.

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
index 2e0c2cf1..d2a2b52 100644
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
index 9f6b88e..3cc3f53 100644
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

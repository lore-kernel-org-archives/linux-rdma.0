From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v6 02/26] IB/Verbs: Implement raw management helpers
Date: Fri, 24 Apr 2015 14:23:26 +0200
Message-ID: <1429878230-11749-3-git-send-email-yun.wang@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Add raw helpers:
	rdma_tech_ib
	rdma_tech_iboe
	rdma_tech_iwarp
	rdma_ib_or_iboe (transition, clean up later)
To help us detect which technology the port supported.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 include/rdma/ib_verbs.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d54f91e..a12e876 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1748,6 +1748,31 @@ int ib_query_port(struct ib_device *device,
 enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
 					       u8 port_num);
 
+static inline int rdma_tech_ib(struct ib_device *device, u8 port_num)
+{
+	return device->query_transport(device, port_num)
+			== RDMA_TRANSPORT_IB;
+}
+
+static inline int rdma_tech_iboe(struct ib_device *device, u8 port_num)
+{
+	return device->query_transport(device, port_num)
+			== RDMA_TRANSPORT_IBOE;
+}
+
+static inline int rdma_tech_iwarp(struct ib_device *device, u8 port_num)
+{
+	return device->query_transport(device, port_num)
+			== RDMA_TRANSPORT_IWARP;
+}
+
+static inline int rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
+{
+	enum rdma_transport_type tp = device->query_transport(device, port_num);
+
+	return (tp == RDMA_TRANSPORT_IB || tp == RDMA_TRANSPORT_IBOE);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0

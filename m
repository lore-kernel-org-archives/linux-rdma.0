From: Eli Cohen <eli@mellanox.co.il>
Subject: [PATCHv6 02/10] ib_core: Add RDMAoE transport protocol
Date: Mon, 16 Nov 2009 17:53:22 +0200
Message-ID: <20091116155322.GC2463@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Linux RDMA list <linux-rdma@vger.kernel.org>, netdev <netdev@vger.kernel.org>, ewg <ewg@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

Add a new transport protocol, RDMAoE, used for transporting Infiniband traffic
over Ethernet fabrics.

Signed-off-by: Eli Cohen <eli@mellanox.co.il>
---
 include/rdma/ib_verbs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4cf42f3..d9146c4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -69,7 +69,8 @@ enum rdma_node_type {
 
 enum rdma_transport_type {
 	RDMA_TRANSPORT_IB,
-	RDMA_TRANSPORT_IWARP
+	RDMA_TRANSPORT_IWARP,
+	RDMA_TRANSPORT_RDMAOE
 };
 
 enum ib_device_cap_flags {
-- 
1.6.5.2


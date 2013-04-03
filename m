From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] Add RDMA_*_USNIC enums for the Cisco Ethernet Virtual NIC.
Date: Wed,  3 Apr 2013 06:13:15 -0700
Message-ID: <1364994796-10642-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Per off-list conversation with Roland, add some new enums for the
Cisco Ethernet Virtual NIC (it's not an RNIC/iWARP device, so it
doesn't fit in the same category as RDMA_NODE_RNIC / RDMA_TRANSPORT_IWARP).

"USNIC" = "Userspace NIC".

---
 drivers/infiniband/core/verbs.c | 3 +++
 include/rdma/ib_verbs.h         | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a8fdd33..2a35518 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -114,6 +114,8 @@ rdma_node_get_transport(enum rdma_node_type node_type)
 		return RDMA_TRANSPORT_IB;
 	case RDMA_NODE_RNIC:
 		return RDMA_TRANSPORT_IWARP;
+	case RDMA_NODE_USNIC:
+		return RDMA_TRANSPORT_USNIC;
 	default:
 		BUG();
 		return 0;
@@ -130,6 +132,7 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_
 	case RDMA_TRANSPORT_IB:
 		return IB_LINK_LAYER_INFINIBAND;
 	case RDMA_TRANSPORT_IWARP:
+	case RDMA_TRANSPORT_USNIC:
 		return IB_LINK_LAYER_ETHERNET;
 	default:
 		return IB_LINK_LAYER_UNSPECIFIED;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 98cc4b2..8a66758 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -67,12 +67,14 @@ enum rdma_node_type {
 	RDMA_NODE_IB_CA 	= 1,
 	RDMA_NODE_IB_SWITCH,
 	RDMA_NODE_IB_ROUTER,
-	RDMA_NODE_RNIC
+	RDMA_NODE_RNIC,
+	RDMA_NODE_USNIC
 };
 
 enum rdma_transport_type {
 	RDMA_TRANSPORT_IB,
-	RDMA_TRANSPORT_IWARP
+	RDMA_TRANSPORT_IWARP,
+	RDMA_TRANSPORT_USNIC
 };
 
 enum rdma_transport_type
-- 
1.8.1.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

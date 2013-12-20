From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 6/6] IB/core: Rename RMDA_TRANSPORT_USNIC
Date: Fri, 20 Dec 2013 12:38:23 -0800
Message-ID: <1387571903-9398-7-git-send-email-umalhi@cisco.com>
References: <1387571903-9398-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571903-9398-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch renames RDMA_TRANSPORT_USNIC to RDMA_TRANSPORT_USNIC_UDP.
usNIC traffic will go over UDP, hence _UDP suffix is apt.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 4 ++--
 include/rdma/ib_verbs.h         | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index d4f6ddf..1428adc 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -115,7 +115,7 @@ rdma_node_get_transport(enum rdma_node_type node_type)
 	case RDMA_NODE_RNIC:
 		return RDMA_TRANSPORT_IWARP;
 	case RDMA_NODE_USNIC:
-		return RDMA_TRANSPORT_USNIC;
+		return RDMA_TRANSPORT_USNIC_UDP;
 	default:
 		BUG();
 		return 0;
@@ -132,7 +132,7 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_
 	case RDMA_TRANSPORT_IB:
 		return IB_LINK_LAYER_INFINIBAND;
 	case RDMA_TRANSPORT_IWARP:
-	case RDMA_TRANSPORT_USNIC:
+	case RDMA_TRANSPORT_USNIC_UDP:
 		return IB_LINK_LAYER_ETHERNET;
 	default:
 		return IB_LINK_LAYER_UNSPECIFIED;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 979874c..485a8e0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -74,7 +74,7 @@ enum rdma_node_type {
 enum rdma_transport_type {
 	RDMA_TRANSPORT_IB,
 	RDMA_TRANSPORT_IWARP,
-	RDMA_TRANSPORT_USNIC
+	RDMA_TRANSPORT_USNIC_UDP
 };
 
 enum rdma_transport_type
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

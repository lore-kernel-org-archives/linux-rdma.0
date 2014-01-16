From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/2] IB/core: Add support for RDMA_NODE_USNIC_UDP
Date: Wed, 15 Jan 2014 17:02:36 -0800
Message-ID: <1389834157-16635-2-git-send-email-umalhi@cisco.com>
References: <1389834157-16635-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389834157-16635-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add the complementary RDMA_NODE_USNIC_UDP for RDMA_TRANSPORT_USNIC_UDP.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 1 +
 drivers/infiniband/core/verbs.c | 2 ++
 include/rdma/ib_verbs.h         | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index faad2ca..7d3292c 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -613,6 +613,7 @@ static ssize_t show_node_type(struct device *device,
 	case RDMA_NODE_IB_CA:	  return sprintf(buf, "%d: CA\n", dev->node_type);
 	case RDMA_NODE_RNIC:	  return sprintf(buf, "%d: RNIC\n", dev->node_type);
 	case RDMA_NODE_USNIC:	  return sprintf(buf, "%d: usNIC\n", dev->node_type);
+	case RDMA_NODE_USNIC_UDP: return sprintf(buf, "%d: usNIC UDP\n", dev->node_type);
 	case RDMA_NODE_IB_SWITCH: return sprintf(buf, "%d: switch\n", dev->node_type);
 	case RDMA_NODE_IB_ROUTER: return sprintf(buf, "%d: router\n", dev->node_type);
 	default:		  return sprintf(buf, "%d: <unknown>\n", dev->node_type);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c1cfeda..3ac7951 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -118,6 +118,8 @@ rdma_node_get_transport(enum rdma_node_type node_type)
 	case RDMA_NODE_RNIC:
 		return RDMA_TRANSPORT_IWARP;
 	case RDMA_NODE_USNIC:
+		return RDMA_TRANSPORT_USNIC;
+	case RDMA_NODE_USNIC_UDP:
 		return RDMA_TRANSPORT_USNIC_UDP;
 	default:
 		BUG();
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index dbf6a3c..8d4a1c0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -70,6 +70,7 @@ enum rdma_node_type {
 	RDMA_NODE_IB_ROUTER,
 	RDMA_NODE_RNIC,
 	RDMA_NODE_USNIC,
+	RDMA_NODE_USNIC_UDP,
 };
 
 enum rdma_transport_type {
-- 
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

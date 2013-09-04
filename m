From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [RFC][PATCH 1/4] IB/core: Cisco VIC - usNIC rdma node and transport
Date: Wed, 4 Sep 2013 03:47:05 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C013BC786@xmb-rcd-x09.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <58B7CF7A5E4FC942B5976C43E635863D-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds new rdma node and new rdma transport, and supporting
code used by Cisco's low latency driver called usNIC.  usNIC uses its
own transport, distinct from IB and iWARP.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
drivers/infiniband/core/sysfs.c |    1 +
drivers/infiniband/core/verbs.c |    3 +++
include/rdma/ib_verbs.h         |    6 ++++--
3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index cde1e7b..faad2ca 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -612,6 +612,7 @@ static ssize_t show_node_type(struct device *device,
	switch (dev->node_type) {
	case RDMA_NODE_IB_CA:	  return sprintf(buf, "%d: CA\n", dev->node_type);
	case RDMA_NODE_RNIC:	  return sprintf(buf, "%d: RNIC\n", dev->node_type);
+	case RDMA_NODE_USNIC:	  return sprintf(buf, "%d: usNIC\n", dev->node_type);
	case RDMA_NODE_IB_SWITCH: return sprintf(buf, "%d: switch\n", dev->node_type);
	case RDMA_NODE_IB_ROUTER: return sprintf(buf, "%d: router\n", dev->node_type);
	default:		  return sprintf(buf, "%d: <unknown>\n", dev->node_type);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 22192de..84cef2e 100644
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
index 645c3ce..880d83d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -67,12 +67,14 @@ enum rdma_node_type {
	RDMA_NODE_IB_CA 	= 1,
	RDMA_NODE_IB_SWITCH,
	RDMA_NODE_IB_ROUTER,
-	RDMA_NODE_RNIC
+	RDMA_NODE_RNIC,
+	RDMA_NODE_USNIC,
};

enum rdma_transport_type {
	RDMA_TRANSPORT_IB,
-	RDMA_TRANSPORT_IWARP
+	RDMA_TRANSPORT_IWARP,
+	RDMA_TRANSPORT_USNIC
};

enum rdma_transport_type
--
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

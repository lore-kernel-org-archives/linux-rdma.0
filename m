From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibverbs: Add support for usNIC node and transport
Date: Tue, 17 Dec 2013 16:56:55 +0000
Message-ID: <3A16F43E-69AF-42D7-959E-9A979D2974E4@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <2AC9CD628CE52D40B8C765ADFBE04AB0-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

180771a3707a4c0577cbf4f830c754dbabfdfccb adds core support for
usNIC node and transport in the kernel.  This patch adds
the corresponding support to libibverbs.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 examples/devinfo.c         | 1 +
 include/infiniband/verbs.h | 6 ++++--
 src/enum_strs.c            | 5 +++--
 src/init.c                 | 5 ++++-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index ff078e4..479c513 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -72,6 +72,7 @@ static const char *transport_str(enum ibv_transport_type transport)
 	switch (transport) {
 	case IBV_TRANSPORT_IB:    return "InfiniBand";
 	case IBV_TRANSPORT_IWARP: return "iWARP";
+	case IBV_TRANSPORT_USNIC: return "usNIC";
 	default:		  return "invalid transport";
 	}
 }
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 4b1ab57..38cea25 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -68,13 +68,15 @@ enum ibv_node_type {
 	IBV_NODE_CA 		= 1,
 	IBV_NODE_SWITCH,
 	IBV_NODE_ROUTER,
-	IBV_NODE_RNIC
+	IBV_NODE_RNIC,
+	IBV_NODE_USNIC,
 };
 
 enum ibv_transport_type {
 	IBV_TRANSPORT_UNKNOWN	= -1,
 	IBV_TRANSPORT_IB	= 0,
-	IBV_TRANSPORT_IWARP
+	IBV_TRANSPORT_IWARP,
+	IBV_TRANSPORT_USNIC,
 };
 
 enum ibv_device_cap_flags {
diff --git a/src/enum_strs.c b/src/enum_strs.c
index 54d71a6..971a82f 100644
--- a/src/enum_strs.c
+++ b/src/enum_strs.c
@@ -38,10 +38,11 @@ const char *ibv_node_type_str(enum ibv_node_type node_type)
 		[IBV_NODE_CA]		= "InfiniBand channel adapter",
 		[IBV_NODE_SWITCH]	= "InfiniBand switch",
 		[IBV_NODE_ROUTER]	= "InfiniBand router",
-		[IBV_NODE_RNIC]		= "iWARP NIC"
+		[IBV_NODE_RNIC]		= "iWARP NIC",
+		[IBV_NODE_USNIC]	= "usNIC",
 	};
 
-	if (node_type < IBV_NODE_CA || node_type > IBV_NODE_RNIC)
+	if (node_type < IBV_NODE_CA || node_type > IBV_NODE_USNIC)
 		return "unknown";
 
 	return node_type_str[node_type];
diff --git a/src/init.c b/src/init.c
index 8e93f3f..3583955 100644
--- a/src/init.c
+++ b/src/init.c
@@ -346,7 +346,7 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 			dev->node_type = IBV_NODE_UNKNOWN;
 	} else {
 		dev->node_type = strtol(value, NULL, 10);
-		if (dev->node_type < IBV_NODE_CA || dev->node_type > IBV_NODE_RNIC)
+		if (dev->node_type < IBV_NODE_CA || dev->node_type > IBV_NODE_USNIC)
 			dev->node_type = IBV_NODE_UNKNOWN;
 	}
 
@@ -359,6 +359,9 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 	case IBV_NODE_RNIC:
 		dev->transport_type = IBV_TRANSPORT_IWARP;
 		break;
+	case IBV_NODE_USNIC:
+		dev->transport_type = IBV_TRANSPORT_USNIC;
+		break;
 	default:
 		dev->transport_type = IBV_TRANSPORT_UNKNOWN;
 		break;
-- 
1.8.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

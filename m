From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1] libibverbs: Add support for usNIC nodes and transports
Date: Tue, 21 Jan 2014 19:18:41 -0800
Message-ID: <1390360721-14894-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

5db5765e255de4072eb0e35facfeafce53af001b and 180771a3707a4c0577cbf4f830c754dbabfdfccb
on git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
add IB_NODE_USNIC[_UDP] and IB_TRANSPORT_USNIC[_UDP] support to the kernel.
This patch adds the corresponding support in libibverbs.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 examples/devinfo.c         | 8 +++++---
 include/infiniband/verbs.h | 8 ++++++--
 src/enum_strs.c            | 6 ++++--
 src/init.c                 | 8 +++++++-
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index ff078e4..afa8c85 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -70,9 +70,11 @@ static const char *guid_str(uint64_t node_guid, char *str)
 static const char *transport_str(enum ibv_transport_type transport)
 {
 	switch (transport) {
-	case IBV_TRANSPORT_IB:    return "InfiniBand";
-	case IBV_TRANSPORT_IWARP: return "iWARP";
-	default:		  return "invalid transport";
+	case IBV_TRANSPORT_IB:		return "InfiniBand";
+	case IBV_TRANSPORT_IWARP:	return "iWARP";
+	case IBV_TRANSPORT_USNIC:	return "usNIC";
+	case IBV_TRANSPORT_USNIC_UDP:	return "usNIC UDP";
+	default:			return "invalid transport";
 	}
 }

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 4b1ab57..ff9a1aa 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -68,13 +68,17 @@ enum ibv_node_type {
 	IBV_NODE_CA 		= 1,
 	IBV_NODE_SWITCH,
 	IBV_NODE_ROUTER,
-	IBV_NODE_RNIC
+	IBV_NODE_RNIC,
+	IBV_NODE_USNIC,
+	IBV_NODE_USNIC_UDP,
 };

 enum ibv_transport_type {
 	IBV_TRANSPORT_UNKNOWN	= -1,
 	IBV_TRANSPORT_IB	= 0,
-	IBV_TRANSPORT_IWARP
+	IBV_TRANSPORT_IWARP,
+	IBV_TRANSPORT_USNIC,
+	IBV_TRANSPORT_USNIC_UDP,
 };

 enum ibv_device_cap_flags {
diff --git a/src/enum_strs.c b/src/enum_strs.c
index 54d71a6..93ffe32 100644
--- a/src/enum_strs.c
+++ b/src/enum_strs.c
@@ -38,10 +38,12 @@ const char *ibv_node_type_str(enum ibv_node_type node_type)
 		[IBV_NODE_CA]		= "InfiniBand channel adapter",
 		[IBV_NODE_SWITCH]	= "InfiniBand switch",
 		[IBV_NODE_ROUTER]	= "InfiniBand router",
-		[IBV_NODE_RNIC]		= "iWARP NIC"
+		[IBV_NODE_RNIC]		= "iWARP NIC",
+		[IBV_NODE_USNIC]	= "usNIC",
+		[IBV_NODE_USNIC_UDP]	= "usNIC UDP",
 	};

-	if (node_type < IBV_NODE_CA || node_type > IBV_NODE_RNIC)
+	if (node_type < IBV_NODE_CA || node_type > IBV_NODE_USNIC_UDP)
 		return "unknown";

 	return node_type_str[node_type];
diff --git a/src/init.c b/src/init.c
index 8e93f3f..1724d81 100644
--- a/src/init.c
+++ b/src/init.c
@@ -346,7 +346,7 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 			dev->node_type = IBV_NODE_UNKNOWN;
 	} else {
 		dev->node_type = strtol(value, NULL, 10);
-		if (dev->node_type < IBV_NODE_CA || dev->node_type > IBV_NODE_RNIC)
+		if (dev->node_type < IBV_NODE_CA || dev->node_type > IBV_NODE_USNIC_UDP)
 			dev->node_type = IBV_NODE_UNKNOWN;
 	}

@@ -359,6 +359,12 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 	case IBV_NODE_RNIC:
 		dev->transport_type = IBV_TRANSPORT_IWARP;
 		break;
+	case IBV_NODE_USNIC:
+		dev->transport_type = IBV_TRANSPORT_USNIC;
+		break;
+	case IBV_NODE_USNIC_UDP:
+		dev->transport_type = IBV_TRANSPORT_USNIC_UDP;
+		break;
 	default:
 		dev->transport_type = IBV_TRANSPORT_UNKNOWN;
 		break;
--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

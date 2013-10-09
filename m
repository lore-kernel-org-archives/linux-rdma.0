From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/10] IB/core: Remove ib_uverbs_flow_spec structure from userspace
Date: Wed,  9 Oct 2013 23:12:51 +0200
Message-ID: <2fac065d4517b3f5dab4735b15e976ac623d843f.1381351017.git.ydroneaud@opteya.com>
References: <cover.1381351016.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The structure holding any types of flow_spec is of no use to userspace.
It would be wrong for userspace to do:

  struct ib_uverbs_flow_spec flow_spec;

  flow_spec.type = IB_FLOW_SPEC_TCP;
  flow_spec.size = sizeof(flow_spec);

Instead, userspace should use the dedicated flow_spec structure for
  - Ethernet : struct ib_uverbs_flow_spec_eth,
  - IPv4     : struct ib_uverbs_flow_spec_ipv4,
  - TCP/UDP  : struct ib_uverbs_flow_spec_tcp_udp.

In other words, struct ib_uverbs_flow_spec is a "virtual"
data structure that can only be use by the kernel as an alias
to the other.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs.h     | 16 ++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c | 10 +++++-----
 include/uapi/rdma/ib_user_verbs.h    | 16 ----------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index d040b87..b16e9fb 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -178,6 +178,22 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 			     struct ib_event *event);
 void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
 
+struct ib_uverbs_flow_spec_storage {
+	union {
+		union {
+			struct ib_uverbs_flow_spec_hdr hdr;
+			struct {
+				__u32 type;
+				__u16 size;
+				__u16 reserved;
+			};
+		};
+		struct ib_uverbs_flow_spec_eth     eth;
+		struct ib_uverbs_flow_spec_ipv4    ipv4;
+		struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
+	};
+};
+
 #define IB_UVERBS_DECLARE_CMD(name)					\
 	ssize_t ib_uverbs_##name(struct ib_uverbs_file *file,		\
 				 const char __user *buf, int in_len,	\
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 8079383..902dfd3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2602,7 +2602,7 @@ out_put:
 static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec_hdr *uverbs_spec_hdr,
 				union ib_flow_spec *ib_spec)
 {
-	struct ib_uverbs_flow_spec *uverbs_spec;
+	struct ib_uverbs_flow_spec_storage *uverbs_spec;
 
 	ib_spec->type = uverbs_spec_hdr->type;
 
@@ -2610,7 +2610,7 @@ static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec_hdr *uverbs_spec_hd
 	case IB_FLOW_SPEC_ETH:
 		if (uverbs_spec_hdr->size != sizeof(struct ib_uverbs_flow_spec_eth))
 			return -EINVAL;
-		uverbs_spec = (struct ib_uverbs_flow_spec *)uverbs_spec_hdr;
+		uverbs_spec = (struct ib_uverbs_flow_spec_storage *)uverbs_spec_hdr;
 		ib_spec->eth.size = sizeof(struct ib_flow_spec_eth);
 		memcpy(&ib_spec->eth.val, &uverbs_spec->eth.val,
 		       sizeof(struct ib_flow_eth_filter));
@@ -2620,7 +2620,7 @@ static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec_hdr *uverbs_spec_hd
 	case IB_FLOW_SPEC_IPV4:
 		if (uverbs_spec_hdr->size != sizeof(struct ib_uverbs_flow_spec_ipv4))
 			return -EINVAL;
-		uverbs_spec = (struct ib_uverbs_flow_spec *)uverbs_spec_hdr;
+		uverbs_spec = (struct ib_uverbs_flow_spec_storage *)uverbs_spec_hdr;
 		ib_spec->ipv4.size = sizeof(struct ib_flow_spec_ipv4);
 		memcpy(&ib_spec->ipv4.val, &uverbs_spec->ipv4.val,
 		       sizeof(struct ib_flow_ipv4_filter));
@@ -2631,7 +2631,7 @@ static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec_hdr *uverbs_spec_hd
 	case IB_FLOW_SPEC_UDP:
 		if (uverbs_spec_hdr->size != sizeof(struct ib_uverbs_flow_spec_tcp_udp))
 			return -EINVAL;
-		uverbs_spec = (struct ib_uverbs_flow_spec *)uverbs_spec_hdr;
+		uverbs_spec = (struct ib_uverbs_flow_spec_storage *)uverbs_spec_hdr;
 		ib_spec->tcp_udp.size = sizeof(struct ib_flow_spec_tcp_udp);
 		memcpy(&ib_spec->tcp_udp.val, &uverbs_spec->tcp_udp.val,
 		       sizeof(struct ib_flow_tcp_udp_filter));
@@ -2685,7 +2685,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 		return -EINVAL;
 
 	if (cmd.flow_attr.size >
-	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_flow_spec)))
+	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_flow_spec_storage)))
 		return -EINVAL;
 
 	uverbs_spec_size = cmd.flow_attr.size;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 8be941e..cd12dd7 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -760,22 +760,6 @@ struct ib_uverbs_flow_spec_tcp_udp {
 	struct ib_uverbs_flow_tcp_udp_filter mask;
 };
 
-struct ib_uverbs_flow_spec {
-	union {
-		union {
-			struct ib_uverbs_flow_spec_hdr hdr;
-			struct {
-				__u32 type;
-				__u16 size;
-				__u16 reserved;
-			};
-		};
-		struct ib_uverbs_flow_spec_eth	    eth;
-		struct ib_uverbs_flow_spec_ipv4    ipv4;
-		struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
-	};
-};
-
 struct ib_uverbs_flow_attr {
 	__u32 type;
 	__u16 size;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

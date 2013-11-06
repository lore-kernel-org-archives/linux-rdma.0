From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for -next v2 5/7] IB/core: Remove ib_uverbs_flow_spec structure from userspace
Date: Wed,  6 Nov 2013 23:21:48 +0100
Message-ID: <502cabd3ee9cf3902372b24a2105eb51f788b9c9.1383773832.git.ydroneaud@opteya.com>
References: <cover.1383773832.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
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
Link: http://marc.info/?i=cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs.h  | 16 ++++++++++++++++
 include/uapi/rdma/ib_user_verbs.h | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index d8f9c6c..777954f 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -178,6 +178,22 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 			     struct ib_event *event);
 void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
 
+struct ib_uverbs_flow_spec {
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
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 4301498..fc9bbe3 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -765,22 +765,6 @@ struct ib_uverbs_flow_spec_tcp_udp {
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

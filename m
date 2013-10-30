From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 6/8] IB/core: Remove ib_uverbs_flow_spec structure from userspace
Date: Wed, 30 Oct 2013 11:52:49 +0200
Message-ID: <1383126771-7658-7-git-send-email-matanb@mellanox.com>
References: <1383126771-7658-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383126771-7658-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

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
Link: http://marc.info/?i=cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs.h  | 16 ++++++++++++++++
 include/uapi/rdma/ib_user_verbs.h | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index d040b87..4ae0307 100644
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
index f7f233b5..93577fc 100644
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
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

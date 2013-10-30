From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 5/8] IB/core: Uses a common header for uverbs flow_specs
Date: Wed, 30 Oct 2013 11:52:48 +0200
Message-ID: <1383126771-7658-6-git-send-email-matanb@mellanox.com>
References: <1383126771-7658-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383126771-7658-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

A common header will allows better checking of
flow specs size, while ensuring strict alignment
to 64bits.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 include/uapi/rdma/ib_user_verbs.h | 53 +++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 1a097d6..f7f233b5 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -696,6 +696,14 @@ struct ib_uverbs_detach_mcast {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_flow_spec_hdr {
+	__u32 type;
+	__u16 size;
+	__u16 reserved;
+	/* followed by flow_spec */
+	__u64 flow_spec_data[0];
+};
+
 struct ib_uverbs_flow_eth_filter {
 	__u8  dst_mac[6];
 	__u8  src_mac[6];
@@ -704,9 +712,14 @@ struct ib_uverbs_flow_eth_filter {
 };
 
 struct ib_uverbs_flow_spec_eth {
-	__u32  type;
-	__u16  size;
-	__u16  reserved;
+	union {
+		struct ib_uverbs_flow_spec_hdr hdr;
+		struct {
+			__u32 type;
+			__u16 size;
+			__u16 reserved;
+		};
+	};
 	struct ib_uverbs_flow_eth_filter val;
 	struct ib_uverbs_flow_eth_filter mask;
 };
@@ -717,9 +730,14 @@ struct ib_uverbs_flow_ipv4_filter {
 };
 
 struct ib_uverbs_flow_spec_ipv4 {
-	__u32  type;
-	__u16  size;
-	__u16  reserved;
+	union {
+		struct ib_uverbs_flow_spec_hdr hdr;
+		struct {
+			__u32 type;
+			__u16 size;
+			__u16 reserved;
+		};
+	};
 	struct ib_uverbs_flow_ipv4_filter val;
 	struct ib_uverbs_flow_ipv4_filter mask;
 };
@@ -730,19 +748,27 @@ struct ib_uverbs_flow_tcp_udp_filter {
 };
 
 struct ib_uverbs_flow_spec_tcp_udp {
-	__u32  type;
-	__u16  size;
-	__u16  reserved;
+	union {
+		struct ib_uverbs_flow_spec_hdr hdr;
+		struct {
+			__u32 type;
+			__u16 size;
+			__u16 reserved;
+		};
+	};
 	struct ib_uverbs_flow_tcp_udp_filter val;
 	struct ib_uverbs_flow_tcp_udp_filter mask;
 };
 
 struct ib_uverbs_flow_spec {
 	union {
-		struct {
-			__u32 type;
-			__u16 size;
-			__u16 reserved;
+		union {
+			struct ib_uverbs_flow_spec_hdr hdr;
+			struct {
+				__u32 type;
+				__u16 size;
+				__u16 reserved;
+			};
 		};
 		struct ib_uverbs_flow_spec_eth	    eth;
 		struct ib_uverbs_flow_spec_ipv4    ipv4;
@@ -762,6 +788,7 @@ struct ib_uverbs_flow_attr {
 	 * struct ib_flow_spec_xxx
 	 * struct ib_flow_spec_yyy
 	 */
+	struct ib_uverbs_flow_spec_hdr flow_specs[0];
 };
 
 struct ib_uverbs_create_flow  {
-- 
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

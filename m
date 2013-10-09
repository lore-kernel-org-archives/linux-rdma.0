From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/10] IB/core: Uses a common header for uverbs flow_specs
Date: Wed,  9 Oct 2013 23:12:49 +0200
Message-ID: <b1472ab1ed45ef41e60269d45645c374d4c4237f.1381351017.git.ydroneaud@opteya.com>
References: <cover.1381351016.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A common header allows better checking of flow specs
size, while ensuring strict alignment to 64bits.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 10 +++++--
 include/uapi/rdma/ib_user_verbs.h    | 53 +++++++++++++++++++++++++++---------
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 106e997..6b066a3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2647,7 +2647,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	struct ib_uverbs_create_flow_resp resp;
 	struct ib_uobject		  *uobj;
 	struct ib_flow			  *flow_id;
-	struct ib_uverbs_flow_spec	  *uverbs_flow_spec = NULL;
+	struct ib_uverbs_flow_spec_hdr	  *uverbs_flow_spec = NULL;
 	struct ib_flow_attr		  *flow_attr;
 	struct ib_qp			  *qp;
 	int err = 0;
@@ -2675,6 +2675,10 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	if (cmd.flow_attr.size > (in_len - sizeof(cmd)))
 		return -EINVAL;
 
+	if (cmd.flow_attr.size <
+	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_flow_spec_hdr)))
+		return -EINVAL;
+
 	if (cmd.flow_attr.size >
 	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_flow_spec)))
 		return -EINVAL;
@@ -2728,8 +2732,8 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 			goto err_free;
 		flow_attr->size +=
 			((union ib_flow_spec *) ib_spec)->size;
-		uverbs_spec_size -= ((struct ib_uverbs_flow_spec *) uverbs_spec)->size;
-		uverbs_spec += ((struct ib_uverbs_flow_spec *) uverbs_spec)->size;
+		uverbs_spec_size -= ((struct ib_uverbs_flow_spec_hdr *) uverbs_spec)->size;
+		uverbs_spec += ((struct ib_uverbs_flow_spec_hdr *) uverbs_spec)->size;
 		ib_spec += ((union ib_flow_spec *) ib_spec)->size;
 	}
 	if (uverbs_spec_size) {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 61ecd59..8be941e 100644
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
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

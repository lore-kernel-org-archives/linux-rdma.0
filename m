From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/9] IB/core: Makes uverbs flow structure using names more similar to verbs ones
Date: Fri, 11 Oct 2013 19:18:50 +0200
Message-ID: <6441f52e27e09f76adf217492e2e7e239ea62919.1381510045.git.ydroneaud@opteya.com>
References: <cover.1381510045.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch add "flow" prefix to most of data structure added as part
of commit 436f2ad to keep those names in sync with the data structures
added in commit 319a441.

It's just a matter of translating 'ib_flow' to 'ib_uverbs_flow'.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 12 ++++++------
 include/uapi/rdma/ib_user_verbs.h    | 32 ++++++++++++++++----------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 20ad9c6..052e07c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2599,7 +2599,7 @@ out_put:
 	return ret ? ret : in_len;
 }
 
-static int kern_spec_to_ib_spec(struct ib_uverbs_spec *kern_spec,
+static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 				union ib_flow_spec *ib_spec)
 {
 	ib_spec->type = kern_spec->type;
@@ -2673,7 +2673,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 
 	if (cmd.flow_attr.size > (in_len - sizeof(cmd)) ||
 	    cmd.flow_attr.size >
-	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_spec)))
+	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_flow_spec)))
 		return -EINVAL;
 
 	if (cmd.flow_attr.num_of_specs) {
@@ -2722,16 +2722,16 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	kern_spec = kern_flow_attr + 1;
 	ib_spec = flow_attr + 1;
 	for (i = 0; i < flow_attr->num_of_specs &&
-	     cmd.flow_attr.size > offsetof(struct ib_uverbs_spec, reserved) &&
+	     cmd.flow_attr.size > offsetof(struct ib_uverbs_flow_spec, reserved) &&
 	     cmd.flow_attr.size >=
-	     ((struct ib_uverbs_spec *)kern_spec)->size; i++) {
+	     ((struct ib_uverbs_flow_spec *)kern_spec)->size; i++) {
 		err = kern_spec_to_ib_spec(kern_spec, ib_spec);
 		if (err)
 			goto err_free;
 		flow_attr->size +=
 			((union ib_flow_spec *) ib_spec)->size;
-		cmd.flow_attr.size -= ((struct ib_uverbs_spec *)kern_spec)->size;
-		kern_spec += ((struct ib_uverbs_spec *) kern_spec)->size;
+		cmd.flow_attr.size -= ((struct ib_uverbs_flow_spec *)kern_spec)->size;
+		kern_spec += ((struct ib_uverbs_flow_spec *) kern_spec)->size;
 		ib_spec += ((union ib_flow_spec *) ib_spec)->size;
 	}
 	if (cmd.flow_attr.size || (i != flow_attr->num_of_specs)) {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 6a8fd43..1a097d6 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -696,57 +696,57 @@ struct ib_uverbs_detach_mcast {
 	__u64 driver_data[0];
 };
 
-struct ib_uverbs_eth_filter {
+struct ib_uverbs_flow_eth_filter {
 	__u8  dst_mac[6];
 	__u8  src_mac[6];
 	__be16 ether_type;
 	__be16 vlan_tag;
 };
 
-struct ib_uverbs_spec_eth {
+struct ib_uverbs_flow_spec_eth {
 	__u32  type;
 	__u16  size;
 	__u16  reserved;
-	struct ib_uverbs_eth_filter val;
-	struct ib_uverbs_eth_filter mask;
+	struct ib_uverbs_flow_eth_filter val;
+	struct ib_uverbs_flow_eth_filter mask;
 };
 
-struct ib_uverbs_ipv4_filter {
+struct ib_uverbs_flow_ipv4_filter {
 	__be32 src_ip;
 	__be32 dst_ip;
 };
 
-struct ib_uverbs_spec_ipv4 {
+struct ib_uverbs_flow_spec_ipv4 {
 	__u32  type;
 	__u16  size;
 	__u16  reserved;
-	struct ib_uverbs_ipv4_filter val;
-	struct ib_uverbs_ipv4_filter mask;
+	struct ib_uverbs_flow_ipv4_filter val;
+	struct ib_uverbs_flow_ipv4_filter mask;
 };
 
-struct ib_uverbs_tcp_udp_filter {
+struct ib_uverbs_flow_tcp_udp_filter {
 	__be16 dst_port;
 	__be16 src_port;
 };
 
-struct ib_uverbs_spec_tcp_udp {
+struct ib_uverbs_flow_spec_tcp_udp {
 	__u32  type;
 	__u16  size;
 	__u16  reserved;
-	struct ib_uverbs_tcp_udp_filter val;
-	struct ib_uverbs_tcp_udp_filter mask;
+	struct ib_uverbs_flow_tcp_udp_filter val;
+	struct ib_uverbs_flow_tcp_udp_filter mask;
 };
 
-struct ib_uverbs_spec {
+struct ib_uverbs_flow_spec {
 	union {
 		struct {
 			__u32 type;
 			__u16 size;
 			__u16 reserved;
 		};
-		struct ib_uverbs_spec_eth	    eth;
-		struct ib_uverbs_spec_ipv4    ipv4;
-		struct ib_uverbs_spec_tcp_udp tcp_udp;
+		struct ib_uverbs_flow_spec_eth	    eth;
+		struct ib_uverbs_flow_spec_ipv4    ipv4;
+		struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
 	};
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

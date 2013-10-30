From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 3/8] IB/core: Rename 'flow' structs to match other uverbs structs
Date: Wed, 30 Oct 2013 11:52:46 +0200
Message-ID: <1383126771-7658-4-git-send-email-matanb@mellanox.com>
References: <1383126771-7658-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383126771-7658-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

Commit 436f2ad added public data structures to support
receive flow steering. The new structs are not following
the 'uverbs' pattern: they're lacking the common prefix
'ib_uverbs'.

This patch replaces ib_kern prefix by ib_uverbs.


Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 14 +++++++-------
 include/uapi/rdma/ib_user_verbs.h    | 36 ++++++++++++++++++------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 98f1746..85f8b5f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2602,7 +2602,7 @@ out_put:
 	return ret ? ret : in_len;
 }
 
-static int kern_spec_to_ib_spec(struct ib_kern_spec *kern_spec,
+static int kern_spec_to_ib_spec(struct ib_uverbs_spec *kern_spec,
 				union ib_flow_spec *ib_spec)
 {
 	ib_spec->type = kern_spec->type;
@@ -2650,7 +2650,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	struct ib_uverbs_create_flow_resp resp;
 	struct ib_uobject		  *uobj;
 	struct ib_flow			  *flow_id;
-	struct ib_kern_flow_attr	  *kern_flow_attr;
+	struct ib_uverbs_flow_attr	  *kern_flow_attr;
 	struct ib_flow_attr		  *flow_attr;
 	struct ib_qp			  *qp;
 	int err = 0;
@@ -2676,7 +2676,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 
 	if (cmd.flow_attr.size > (in_len - sizeof(cmd)) ||
 	    cmd.flow_attr.size >
-	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
+	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_spec)))
 		return -EINVAL;
 
 	if (cmd.flow_attr.num_of_specs) {
@@ -2725,16 +2725,16 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	kern_spec = kern_flow_attr + 1;
 	ib_spec = flow_attr + 1;
 	for (i = 0; i < flow_attr->num_of_specs &&
-	     cmd.flow_attr.size > offsetof(struct ib_kern_spec, reserved) &&
+	     cmd.flow_attr.size > offsetof(struct ib_uverbs_spec, reserved) &&
 	     cmd.flow_attr.size >=
-	     ((struct ib_kern_spec *)kern_spec)->size; i++) {
+	     ((struct ib_uverbs_spec *)kern_spec)->size; i++) {
 		err = kern_spec_to_ib_spec(kern_spec, ib_spec);
 		if (err)
 			goto err_free;
 		flow_attr->size +=
 			((union ib_flow_spec *) ib_spec)->size;
-		cmd.flow_attr.size -= ((struct ib_kern_spec *)kern_spec)->size;
-		kern_spec += ((struct ib_kern_spec *) kern_spec)->size;
+		cmd.flow_attr.size -= ((struct ib_uverbs_spec *)kern_spec)->size;
+		kern_spec += ((struct ib_uverbs_spec *) kern_spec)->size;
 		ib_spec += ((union ib_flow_spec *) ib_spec)->size;
 	}
 	if (cmd.flow_attr.size || (i != flow_attr->num_of_specs)) {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 71e994b..6a8fd43 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -696,61 +696,61 @@ struct ib_uverbs_detach_mcast {
 	__u64 driver_data[0];
 };
 
-struct ib_kern_eth_filter {
+struct ib_uverbs_eth_filter {
 	__u8  dst_mac[6];
 	__u8  src_mac[6];
 	__be16 ether_type;
 	__be16 vlan_tag;
 };
 
-struct ib_kern_spec_eth {
+struct ib_uverbs_spec_eth {
 	__u32  type;
 	__u16  size;
 	__u16  reserved;
-	struct ib_kern_eth_filter val;
-	struct ib_kern_eth_filter mask;
+	struct ib_uverbs_eth_filter val;
+	struct ib_uverbs_eth_filter mask;
 };
 
-struct ib_kern_ipv4_filter {
+struct ib_uverbs_ipv4_filter {
 	__be32 src_ip;
 	__be32 dst_ip;
 };
 
-struct ib_kern_spec_ipv4 {
+struct ib_uverbs_spec_ipv4 {
 	__u32  type;
 	__u16  size;
 	__u16  reserved;
-	struct ib_kern_ipv4_filter val;
-	struct ib_kern_ipv4_filter mask;
+	struct ib_uverbs_ipv4_filter val;
+	struct ib_uverbs_ipv4_filter mask;
 };
 
-struct ib_kern_tcp_udp_filter {
+struct ib_uverbs_tcp_udp_filter {
 	__be16 dst_port;
 	__be16 src_port;
 };
 
-struct ib_kern_spec_tcp_udp {
+struct ib_uverbs_spec_tcp_udp {
 	__u32  type;
 	__u16  size;
 	__u16  reserved;
-	struct ib_kern_tcp_udp_filter val;
-	struct ib_kern_tcp_udp_filter mask;
+	struct ib_uverbs_tcp_udp_filter val;
+	struct ib_uverbs_tcp_udp_filter mask;
 };
 
-struct ib_kern_spec {
+struct ib_uverbs_spec {
 	union {
 		struct {
 			__u32 type;
 			__u16 size;
 			__u16 reserved;
 		};
-		struct ib_kern_spec_eth	    eth;
-		struct ib_kern_spec_ipv4    ipv4;
-		struct ib_kern_spec_tcp_udp tcp_udp;
+		struct ib_uverbs_spec_eth	    eth;
+		struct ib_uverbs_spec_ipv4    ipv4;
+		struct ib_uverbs_spec_tcp_udp tcp_udp;
 	};
 };
 
-struct ib_kern_flow_attr {
+struct ib_uverbs_flow_attr {
 	__u32 type;
 	__u16 size;
 	__u16 priority;
@@ -769,7 +769,7 @@ struct ib_uverbs_create_flow  {
 	__u32 reserved;
 	__u64 response;
 	__u32 qp_handle;
-	struct ib_kern_flow_attr flow_attr;
+	struct ib_uverbs_flow_attr flow_attr;
 };
 
 struct ib_uverbs_create_flow_resp {
-- 
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

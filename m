From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/10] IB/core: Rename 'flow' structs to match other uverbs structs
Date: Wed,  9 Oct 2013 23:12:43 +0200
Message-ID: <0d2aecd4ea2af8ffe95a987466196a24f5b35f8d.1381351017.git.ydroneaud@opteya.com>
References: <cover.1381351016.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 436f2ad added public data structures to support
receive flow steering. The new structs are not following
the 'uverbs' pattern: they're lacking the common prefix
'ib_uverbs'.

This patch replaces ib_kern prefix by ib_uverbs.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 76 ++++++++++++++++++------------------
 include/uapi/rdma/ib_user_verbs.h    | 36 ++++++++---------
 2 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f2b81b9..e16e22e 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2599,38 +2599,38 @@ out_put:
 	return ret ? ret : in_len;
 }
 
-static int kern_spec_to_ib_spec(struct ib_kern_spec *kern_spec,
+static int uverbs_spec_to_ib_spec(struct ib_uverbs_spec *uverbs_spec,
 				union ib_flow_spec *ib_spec)
 {
-	ib_spec->type = kern_spec->type;
+	ib_spec->type = uverbs_spec->type;
 
 	switch (ib_spec->type) {
 	case IB_FLOW_SPEC_ETH:
 		ib_spec->eth.size = sizeof(struct ib_flow_spec_eth);
-		if (ib_spec->eth.size != kern_spec->eth.size)
+		if (ib_spec->eth.size != uverbs_spec->eth.size)
 			return -EINVAL;
-		memcpy(&ib_spec->eth.val, &kern_spec->eth.val,
+		memcpy(&ib_spec->eth.val, &uverbs_spec->eth.val,
 		       sizeof(struct ib_flow_eth_filter));
-		memcpy(&ib_spec->eth.mask, &kern_spec->eth.mask,
+		memcpy(&ib_spec->eth.mask, &uverbs_spec->eth.mask,
 		       sizeof(struct ib_flow_eth_filter));
 		break;
 	case IB_FLOW_SPEC_IPV4:
 		ib_spec->ipv4.size = sizeof(struct ib_flow_spec_ipv4);
-		if (ib_spec->ipv4.size != kern_spec->ipv4.size)
+		if (ib_spec->ipv4.size != uverbs_spec->ipv4.size)
 			return -EINVAL;
-		memcpy(&ib_spec->ipv4.val, &kern_spec->ipv4.val,
+		memcpy(&ib_spec->ipv4.val, &uverbs_spec->ipv4.val,
 		       sizeof(struct ib_flow_ipv4_filter));
-		memcpy(&ib_spec->ipv4.mask, &kern_spec->ipv4.mask,
+		memcpy(&ib_spec->ipv4.mask, &uverbs_spec->ipv4.mask,
 		       sizeof(struct ib_flow_ipv4_filter));
 		break;
 	case IB_FLOW_SPEC_TCP:
 	case IB_FLOW_SPEC_UDP:
 		ib_spec->tcp_udp.size = sizeof(struct ib_flow_spec_tcp_udp);
-		if (ib_spec->tcp_udp.size != kern_spec->tcp_udp.size)
+		if (ib_spec->tcp_udp.size != uverbs_spec->tcp_udp.size)
 			return -EINVAL;
-		memcpy(&ib_spec->tcp_udp.val, &kern_spec->tcp_udp.val,
+		memcpy(&ib_spec->tcp_udp.val, &uverbs_spec->tcp_udp.val,
 		       sizeof(struct ib_flow_tcp_udp_filter));
-		memcpy(&ib_spec->tcp_udp.mask, &kern_spec->tcp_udp.mask,
+		memcpy(&ib_spec->tcp_udp.mask, &uverbs_spec->tcp_udp.mask,
 		       sizeof(struct ib_flow_tcp_udp_filter));
 		break;
 	default:
@@ -2647,14 +2647,14 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	struct ib_uverbs_create_flow_resp resp;
 	struct ib_uobject		  *uobj;
 	struct ib_flow			  *flow_id;
-	struct ib_kern_flow_attr	  *kern_flow_attr;
+	struct ib_uverbs_flow_attr	  *uverbs_flow_attr;
 	struct ib_flow_attr		  *flow_attr;
 	struct ib_qp			  *qp;
 	int err = 0;
-	void *kern_spec;
+	void *uverbs_spec;
 	void *ib_spec;
 	int i;
-	int kern_attr_size;
+	int uverbs_attr_size;
 
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
@@ -2673,28 +2673,28 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
 		return -EINVAL;
 
-	kern_attr_size = cmd.flow_attr.size - sizeof(cmd) -
+	uverbs_attr_size = cmd.flow_attr.size - sizeof(cmd) -
 			 sizeof(struct ib_uverbs_cmd_hdr_ex);
 
 	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > in_len ||
-	    kern_attr_size < 0 || kern_attr_size >
-	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
+	    uverbs_attr_size < 0 || uverbs_attr_size >
+	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_spec)))
 		return -EINVAL;
 
 	if (cmd.flow_attr.num_of_specs) {
-		kern_flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
-		if (!kern_flow_attr)
+		uverbs_flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
+		if (!uverbs_flow_attr)
 			return -ENOMEM;
 
-		memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
-		if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
-				   kern_attr_size)) {
+		memcpy(uverbs_flow_attr, &cmd.flow_attr, sizeof(*uverbs_flow_attr));
+		if (copy_from_user(uverbs_flow_attr + 1, buf + sizeof(cmd),
+				   uverbs_attr_size)) {
 			err = -EFAULT;
 			goto err_free_attr;
 		}
 	} else {
-		kern_flow_attr = &cmd.flow_attr;
-		kern_attr_size = sizeof(cmd.flow_attr);
+		uverbs_flow_attr = &cmd.flow_attr;
+		uverbs_attr_size = sizeof(cmd.flow_attr);
 	}
 
 	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
@@ -2717,28 +2717,28 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 		goto err_put;
 	}
 
-	flow_attr->type = kern_flow_attr->type;
-	flow_attr->priority = kern_flow_attr->priority;
-	flow_attr->num_of_specs = kern_flow_attr->num_of_specs;
-	flow_attr->port = kern_flow_attr->port;
-	flow_attr->flags = kern_flow_attr->flags;
+	flow_attr->type = uverbs_flow_attr->type;
+	flow_attr->priority = uverbs_flow_attr->priority;
+	flow_attr->num_of_specs = uverbs_flow_attr->num_of_specs;
+	flow_attr->port = uverbs_flow_attr->port;
+	flow_attr->flags = uverbs_flow_attr->flags;
 	flow_attr->size = sizeof(*flow_attr);
 
-	kern_spec = kern_flow_attr + 1;
+	uverbs_spec = uverbs_flow_attr + 1;
 	ib_spec = flow_attr + 1;
-	for (i = 0; i < flow_attr->num_of_specs && kern_attr_size > 0; i++) {
-		err = kern_spec_to_ib_spec(kern_spec, ib_spec);
+	for (i = 0; i < flow_attr->num_of_specs && uverbs_attr_size > 0; i++) {
+		err = uverbs_spec_to_ib_spec(uverbs_spec, ib_spec);
 		if (err)
 			goto err_free;
 		flow_attr->size +=
 			((union ib_flow_spec *) ib_spec)->size;
-		kern_attr_size -= ((struct ib_kern_spec *) kern_spec)->size;
-		kern_spec += ((struct ib_kern_spec *) kern_spec)->size;
+		uverbs_attr_size -= ((struct ib_uverbs_spec *) uverbs_spec)->size;
+		uverbs_spec += ((struct ib_uverbs_spec *) uverbs_spec)->size;
 		ib_spec += ((union ib_flow_spec *) ib_spec)->size;
 	}
-	if (kern_attr_size) {
+	if (uverbs_attr_size) {
 		pr_warn("create flow failed, %d bytes left from uverb cmd\n",
-			kern_attr_size);
+			uverbs_attr_size);
 		goto err_free;
 	}
 	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
@@ -2773,7 +2773,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	up_write(&uobj->mutex);
 	kfree(flow_attr);
 	if (cmd.flow_attr.num_of_specs)
-		kfree(kern_flow_attr);
+		kfree(uverbs_flow_attr);
 	return in_len;
 err_copy:
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
@@ -2787,7 +2787,7 @@ err_uobj:
 	put_uobj_write(uobj);
 err_free_attr:
 	if (cmd.flow_attr.num_of_specs)
-		kfree(kern_flow_attr);
+		kfree(uverbs_flow_attr);
 	return err;
 }
 
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 0b233c5..f8fea78 100644
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
@@ -768,7 +768,7 @@ struct ib_uverbs_create_flow  {
 	__u32 comp_mask;
 	__u64 response;
 	__u32 qp_handle;
-	struct ib_kern_flow_attr flow_attr;
+	struct ib_uverbs_flow_attr flow_attr;
 };
 
 struct ib_uverbs_create_flow_resp {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 14/17] verbs: Use kernel uapi header for flow steering types
Date: Thu, 11 Jan 2018 15:13:37 -0700
Message-ID: <20180111221340.965-15-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The kernel versions are a bit different, they have a union
around the header fields mapping to ib_uverbs_flow_spec_hdr
but are otherwise the same.

Performed by this script:

$ sed -i \
 -e 's/struct[ \t]ibv_kern_spec_action_drop\([ \t,)]\)/struct ib_uverbs_flow_spec_action_drop\1/g' \
 -e 's/struct[ \t]ibv_kern_spec_action_tag\([ \t,)]\)/struct ib_uverbs_flow_spec_action_tag\1/g' \
 -e 's/struct[ \t]ibv_kern_spec_eth\([ \t,)]\)/struct ib_uverbs_flow_spec_eth\1/g' \
 -e 's/struct[ \t]ibv_kern_spec_ipv4_ext\([ \t,)]\)/struct ib_uverbs_flow_spec_ipv4\1/g' \
 -e 's/struct[ \t]ibv_kern_spec_ipv6\([ \t,)]\)/struct ib_uverbs_flow_spec_ipv6\1/g' \
 -e 's/struct[ \t]ibv_kern_spec_tcp_udp\([ \t,)]\)/struct ib_uverbs_flow_spec_tcp_udp\1/g' \
 -e 's/struct[ \t]ibv_kern_spec_tunnel\([ \t,)]\)/struct ib_uverbs_flow_spec_tunnel\1/g' \
    `git ls-files`

And some minor touch ups.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      | 14 +++++-----
 libibverbs/kern-abi.h | 74 ++++++---------------------------------------------
 2 files changed, 15 insertions(+), 73 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index dfa3fe6e113e98..f73af7b7a92d80 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1790,7 +1790,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 	switch (kern_spec->hdr.type) {
 	case IBV_FLOW_SPEC_ETH:
 	case IBV_FLOW_SPEC_ETH | IBV_FLOW_SPEC_INNER:
-		kern_spec->eth.size = sizeof(struct ibv_kern_spec_eth);
+		kern_spec->eth.size = sizeof(struct ib_uverbs_flow_spec_eth);
 		memcpy(&kern_spec->eth.val, &ib_spec->eth.val,
 		       sizeof(struct ibv_flow_eth_filter));
 		memcpy(&kern_spec->eth.mask, &ib_spec->eth.mask,
@@ -1815,7 +1815,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		kern_spec->hdr.type = IBV_FLOW_SPEC_IPV4 |
 				     (IBV_FLOW_SPEC_INNER & ib_spec->hdr.type);
 		kern_spec->ipv4_ext.size = sizeof(struct
-						  ibv_kern_spec_ipv4_ext);
+						  ib_uverbs_flow_spec_ipv4);
 		memcpy(&kern_spec->ipv4_ext.val, &ib_spec->ipv4_ext.val,
 		       kern_filter_size);
 		memcpy(&kern_spec->ipv4_ext.mask, (void *)&ib_spec->ipv4_ext.val
@@ -1829,7 +1829,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		if (ret)
 			return ret;
 
-		kern_spec->ipv6.size = sizeof(struct ibv_kern_spec_ipv6);
+		kern_spec->ipv6.size = sizeof(struct ib_uverbs_flow_spec_ipv6);
 		memcpy(&kern_spec->ipv6.val, &ib_spec->ipv6.val,
 		       kern_filter_size);
 		memcpy(&kern_spec->ipv6.mask, (void *)&ib_spec->ipv6.val
@@ -1839,7 +1839,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 	case IBV_FLOW_SPEC_UDP:
 	case IBV_FLOW_SPEC_TCP | IBV_FLOW_SPEC_INNER:
 	case IBV_FLOW_SPEC_UDP | IBV_FLOW_SPEC_INNER:
-		kern_spec->tcp_udp.size = sizeof(struct ibv_kern_spec_tcp_udp);
+		kern_spec->tcp_udp.size = sizeof(struct ib_uverbs_flow_spec_tcp_udp);
 		memcpy(&kern_spec->tcp_udp.val, &ib_spec->tcp_udp.val,
 		       sizeof(struct ibv_flow_tcp_udp_filter));
 		memcpy(&kern_spec->tcp_udp.mask, &ib_spec->tcp_udp.mask,
@@ -1852,7 +1852,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		if (ret)
 			return ret;
 
-		kern_spec->tunnel.size = sizeof(struct ibv_kern_spec_tunnel);
+		kern_spec->tunnel.size = sizeof(struct ib_uverbs_flow_spec_tunnel);
 		memcpy(&kern_spec->tunnel.val, &ib_spec->tunnel.val,
 		       kern_filter_size);
 		memcpy(&kern_spec->tunnel.mask, (void *)&ib_spec->tunnel.val
@@ -1860,11 +1860,11 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		break;
 	case IBV_FLOW_SPEC_ACTION_TAG:
 		kern_spec->flow_tag.size =
-			sizeof(struct ibv_kern_spec_action_tag);
+			sizeof(struct ib_uverbs_flow_spec_action_tag);
 		kern_spec->flow_tag.tag_id = ib_spec->flow_tag.tag_id;
 		break;
 	case IBV_FLOW_SPEC_ACTION_DROP:
-		kern_spec->drop.size = sizeof(struct ibv_kern_spec_action_drop);
+		kern_spec->drop.size = sizeof(struct ib_uverbs_flow_spec_action_drop);
 		break;
 	default:
 		return EINVAL;
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 277d968f0bcc2c..57ef1dd6ff6beb 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -390,14 +390,6 @@ struct ibv_destroy_qp {
 	__u32 reserved;
 };
 
-struct ibv_kern_spec_eth {
-	__u32 type;
-	__u16  size;
-	__u16 reserved;
-	struct ib_uverbs_flow_eth_filter val;
-	struct ib_uverbs_flow_eth_filter mask;
-};
-
 struct ibv_kern_ipv4_filter {
 	__u32 src_ip;
 	__u32 dst_ip;
@@ -411,67 +403,17 @@ struct ibv_kern_spec_ipv4 {
 	struct ibv_kern_ipv4_filter mask;
 };
 
-struct ibv_kern_spec_ipv4_ext {
-	__u32  type;
-	__u16  size;
-	__u16 reserved;
-	struct ib_uverbs_flow_ipv4_filter val;
-	struct ib_uverbs_flow_ipv4_filter mask;
-};
-
-struct ibv_kern_spec_ipv6 {
-	__u32  type;
-	__u16  size;
-	__u16 reserved;
-	struct ib_uverbs_flow_ipv6_filter val;
-	struct ib_uverbs_flow_ipv6_filter mask;
-};
-
-struct ibv_kern_spec_tcp_udp {
-	__u32  type;
-	__u16  size;
-	__u16 reserved;
-	struct ib_uverbs_flow_tcp_udp_filter val;
-	struct ib_uverbs_flow_tcp_udp_filter mask;
-};
-
-struct ibv_kern_spec_action_tag {
-	__u32  type;
-	__u16  size;
-	__u16 reserved;
-	__u32 tag_id;
-	__u32 reserved1;
-};
-
-struct ibv_kern_spec_tunnel {
-	__u32  type;
-	__u16  size;
-	__u16 reserved;
-	struct ib_uverbs_flow_tunnel_filter val;
-	struct ib_uverbs_flow_tunnel_filter mask;
-};
-
-struct ibv_kern_spec_action_drop {
-	__u32  type;
-	__u16  size;
-	__u16 reserved;
-};
-
 struct ibv_kern_spec {
 	union {
-		struct {
-			__u32 type;
-			__u16 size;
-			__u16 reserved;
-		} hdr;
-		struct ibv_kern_spec_eth eth;
+		struct ib_uverbs_flow_spec_hdr hdr;
+		struct ib_uverbs_flow_spec_eth eth;
 		struct ibv_kern_spec_ipv4 ipv4;
-		struct ibv_kern_spec_ipv4_ext ipv4_ext;
-		struct ibv_kern_spec_tcp_udp tcp_udp;
-		struct ibv_kern_spec_ipv6 ipv6;
-		struct ibv_kern_spec_tunnel tunnel;
-		struct ibv_kern_spec_action_tag flow_tag;
-		struct ibv_kern_spec_action_drop drop;
+		struct ib_uverbs_flow_spec_ipv4 ipv4_ext;
+		struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
+		struct ib_uverbs_flow_spec_ipv6 ipv6;
+		struct ib_uverbs_flow_spec_tunnel tunnel;
+		struct ib_uverbs_flow_spec_action_tag flow_tag;
+		struct ib_uverbs_flow_spec_action_drop drop;
 	};
 };
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

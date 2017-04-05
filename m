From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/5] ibverbs: Add tunnel VXLAN flow specification
Date: Wed,  5 Apr 2017 18:19:20 +0300
Message-ID: <1491405564-19735-2-git-send-email-yishaih@mellanox.com>
References: <1491405564-19735-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491405564-19735-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add flow specification for receiving a specific VXLAN packet. The
specification defines a filter on the VNI field in the packet. There is an
option to mask a range of tunnel IDs to be steered by using the filter
mask.

VNI: 24-bit value that provides a unique identifier for the
individual VXLAN segment.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                 | 22 ++++++++++++++++++++++
 libibverbs/kern-abi.h            | 13 +++++++++++++
 libibverbs/man/ibv_create_flow.3 |  1 +
 libibverbs/verbs.h               | 25 +++++++++++++++++++------
 4 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 06ec671..8814142 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1712,6 +1712,15 @@ static int get_filters_size(struct ibv_flow_spec *ib_spec,
 		ib_spec_filter_mask = (void *)&ib_spec->ipv6.val +
 			*ib_filter_size;
 		break;
+	case IBV_FLOW_SPEC_VXLAN_TUNNEL:
+		min_filter_size =
+			offsetof(struct ibv_kern_tunnel_filter,
+				 tunnel_id) +
+			sizeof(kern_spec->tunnel.mask.tunnel_id);
+		curr_kern_filter_size = min_filter_size;
+		ib_spec_filter_mask = (void *)&ib_spec->tunnel.val +
+			*ib_filter_size;
+		break;
 	default:
 		return EINVAL;
 	}
@@ -1789,6 +1798,19 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		memcpy(&kern_spec->tcp_udp.mask, &ib_spec->tcp_udp.mask,
 		       sizeof(struct ibv_flow_tcp_udp_filter));
 		break;
+	case IBV_FLOW_SPEC_VXLAN_TUNNEL:
+		ret = get_filters_size(ib_spec, kern_spec,
+				       &ib_filter_size, &kern_filter_size,
+				       IBV_FLOW_SPEC_VXLAN_TUNNEL);
+		if (ret)
+			return ret;
+
+		kern_spec->tunnel.size = sizeof(struct ibv_kern_spec_tunnel);
+		memcpy(&kern_spec->tunnel.val, &ib_spec->tunnel.val,
+		       kern_filter_size);
+		memcpy(&kern_spec->tunnel.mask, (void *)&ib_spec->tunnel.val
+		       + ib_filter_size, kern_filter_size);
+		break;
 	default:
 		return EINVAL;
 	}
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index cb229f8..f8bdc9d 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -919,6 +919,18 @@ struct ibv_kern_spec_tcp_udp {
 };
 
 
+struct ibv_kern_tunnel_filter {
+	__u32 tunnel_id;
+};
+
+struct ibv_kern_spec_tunnel {
+	__u32  type;
+	__u16  size;
+	__u16 reserved;
+	struct ibv_kern_tunnel_filter val;
+	struct ibv_kern_tunnel_filter mask;
+};
+
 struct ibv_kern_spec {
 	union {
 		struct {
@@ -931,6 +943,7 @@ struct ibv_kern_spec {
 		struct ibv_kern_spec_ipv4_ext ipv4_ext;
 		struct ibv_kern_spec_tcp_udp tcp_udp;
 		struct ibv_kern_spec_ipv6 ipv6;
+		struct ibv_kern_spec_tunnel tunnel;
 	};
 };
 
diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index 656bbf1..3056972 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -66,6 +66,7 @@ IBV_FLOW_SPEC_IPV6                      = 0x31,   /* Flow specification of IPv6
 IBV_FLOW_SPEC_IPV4_EXT                  = 0x32,   /* Extended flow specification of IPv4 */
 IBV_FLOW_SPEC_TCP                       = 0x40,   /* Flow specification of TCP header */
 IBV_FLOW_SPEC_UDP                       = 0x41,   /* Flow specification of UDP header */
+IBV_FLOW_SPEC_VXLAN_TUNNEL             	= 0x50,   /* Flow specification of VXLAN header */
 .in -8
 };
 .br
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 4dbdb02..b41a116 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1217,12 +1217,13 @@ enum ibv_flow_attr_type {
 };
 
 enum ibv_flow_spec_type {
-	IBV_FLOW_SPEC_ETH	= 0x20,
-	IBV_FLOW_SPEC_IPV4	= 0x30,
-	IBV_FLOW_SPEC_IPV6	= 0x31,
-	IBV_FLOW_SPEC_IPV4_EXT	= 0x32,
-	IBV_FLOW_SPEC_TCP	= 0x40,
-	IBV_FLOW_SPEC_UDP	= 0x41,
+	IBV_FLOW_SPEC_ETH		= 0x20,
+	IBV_FLOW_SPEC_IPV4		= 0x30,
+	IBV_FLOW_SPEC_IPV6		= 0x31,
+	IBV_FLOW_SPEC_IPV4_EXT		= 0x32,
+	IBV_FLOW_SPEC_TCP		= 0x40,
+	IBV_FLOW_SPEC_UDP		= 0x41,
+	IBV_FLOW_SPEC_VXLAN_TUNNEL	= 0x50
 };
 
 struct ibv_flow_eth_filter {
@@ -1298,6 +1299,17 @@ struct ibv_flow_spec_tcp_udp {
 	struct ibv_flow_tcp_udp_filter mask;
 };
 
+struct ibv_flow_tunnel_filter {
+	uint32_t tunnel_id;
+};
+
+struct ibv_flow_spec_tunnel {
+	enum ibv_flow_spec_type  type;
+	uint16_t  size;
+	struct ibv_flow_tunnel_filter val;
+	struct ibv_flow_tunnel_filter mask;
+};
+
 struct ibv_flow_spec {
 	union {
 		struct {
@@ -1309,6 +1321,7 @@ struct ibv_flow_spec {
 		struct ibv_flow_spec_tcp_udp tcp_udp;
 		struct ibv_flow_spec_ipv4_ext ipv4_ext;
 		struct ibv_flow_spec_ipv6 ipv6;
+		struct ibv_flow_spec_tunnel tunnel;
 	};
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

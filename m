From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/5] ibverbs: Introduce IPv6 flow specification
Date: Sun,  6 Nov 2016 16:42:47 +0200
Message-ID: <1478443369-8208-4-git-send-email-yishaih@mellanox.com>
References: <1478443369-8208-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478443369-8208-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add IPv6 flow specification in order to support steering rules
of IPv6.

This flow specification includes:
1. Source and Destination address
2. Traffic Class
3. Next Header
4. Hop Limit
5. Flow Label

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      | 21 +++++++++++++++++++++
 libibverbs/kern-abi.h | 20 +++++++++++++++++++-
 libibverbs/verbs.h    | 18 ++++++++++++++++++
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index c960f16..3806189 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1615,6 +1615,14 @@ static int get_filters_size(struct ibv_flow_spec *ib_spec,
 		ib_spec_filter_mask = (void *)&ib_spec->ipv4_ext.val +
 			*ib_filter_size;
 		break;
+	case IBV_FLOW_SPEC_IPV6:
+		min_filter_size =
+			offsetof(struct ibv_kern_ipv6_filter, hop_limit) +
+			sizeof(kern_spec->ipv6.mask.hop_limit);
+		curr_kern_filter_size = min_filter_size;
+		ib_spec_filter_mask = (void *)&ib_spec->ipv6.val +
+			*ib_filter_size;
+		break;
 	default:
 		return EINVAL;
 	}
@@ -1671,6 +1679,19 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		memcpy(&kern_spec->ipv4_ext.mask, (void *)&ib_spec->ipv4_ext.val
 		       + ib_filter_size, kern_filter_size);
 		break;
+	case IBV_FLOW_SPEC_IPV6:
+		ret = get_filters_size(ib_spec, kern_spec,
+				       &ib_filter_size, &kern_filter_size,
+				       IBV_FLOW_SPEC_IPV6);
+		if (ret)
+			return ret;
+
+		kern_spec->ipv6.size = sizeof(struct ibv_kern_spec_ipv6);
+		memcpy(&kern_spec->ipv6.val, &ib_spec->ipv6.val,
+		       kern_filter_size);
+		memcpy(&kern_spec->ipv6.mask, (void *)&ib_spec->ipv6.val
+		       + ib_filter_size, kern_filter_size);
+		break;
 	case IBV_FLOW_SPEC_TCP:
 	case IBV_FLOW_SPEC_UDP:
 		kern_spec->tcp_udp.size = sizeof(struct ibv_kern_spec_tcp_udp);
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 3869e64..bb57495 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -869,6 +869,24 @@ struct ibv_kern_spec_ipv4_ext {
 	struct ibv_kern_ipv4_ext_filter mask;
 };
 
+struct ibv_kern_ipv6_filter {
+	__u8  src_ip[16];
+	__u8  dst_ip[16];
+	__u32 flow_label;
+	__u8  next_hdr;
+	__u8  traffic_class;
+	__u8  hop_limit;
+	__u8  reserved;
+};
+
+struct ibv_kern_spec_ipv6 {
+	__u32  type;
+	__u16  size;
+	__u16 reserved;
+	struct ibv_kern_ipv6_filter val;
+	struct ibv_kern_ipv6_filter mask;
+};
+
 struct ibv_kern_tcp_udp_filter {
 	__u16 dst_port;
 	__u16 src_port;
@@ -894,8 +912,8 @@ struct ibv_kern_spec {
 		struct ibv_kern_spec_ipv4 ipv4;
 		struct ibv_kern_spec_ipv4_ext ipv4_ext;
 		struct ibv_kern_spec_tcp_udp tcp_udp;
+		struct ibv_kern_spec_ipv6 ipv6;
 	};
-
 };
 
 struct ibv_kern_flow_attr {
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index a4e120b..de06edd 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1177,6 +1177,7 @@ enum ibv_flow_attr_type {
 enum ibv_flow_spec_type {
 	IBV_FLOW_SPEC_ETH	= 0x20,
 	IBV_FLOW_SPEC_IPV4	= 0x30,
+	IBV_FLOW_SPEC_IPV6	= 0x31,
 	IBV_FLOW_SPEC_IPV4_EXT	= 0x32,
 	IBV_FLOW_SPEC_TCP	= 0x40,
 	IBV_FLOW_SPEC_UDP	= 0x41,
@@ -1227,6 +1228,22 @@ struct ibv_flow_spec_ipv4_ext {
 	struct ibv_flow_ipv4_ext_filter mask;
 };
 
+struct ibv_flow_ipv6_filter {
+	uint8_t  src_ip[16];
+	uint8_t  dst_ip[16];
+	uint32_t flow_label;
+	uint8_t  next_hdr;
+	uint8_t  traffic_class;
+	uint8_t  hop_limit;
+};
+
+struct ibv_flow_spec_ipv6 {
+	enum ibv_flow_spec_type  type;
+	uint16_t  size;
+	struct ibv_flow_ipv6_filter val;
+	struct ibv_flow_ipv6_filter mask;
+};
+
 struct ibv_flow_tcp_udp_filter {
 	uint16_t dst_port;
 	uint16_t src_port;
@@ -1249,6 +1266,7 @@ struct ibv_flow_spec {
 		struct ibv_flow_spec_ipv4 ipv4;
 		struct ibv_flow_spec_tcp_udp tcp_udp;
 		struct ibv_flow_spec_ipv4_ext ipv4_ext;
+		struct ibv_flow_spec_ipv6 ipv6;
 	};
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

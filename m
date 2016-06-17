From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] IB/core: Add IPv6 support to flow steering
Date: Fri, 17 Jun 2016 15:14:50 +0300
Message-ID: <1466165691-32538-2-git-send-email-leon@kernel.org>
References: <1466165691-32538-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466165691-32538-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add IPv6 flow specification support.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h     |  1 +
 drivers/infiniband/core/uverbs_cmd.c |  9 +++++++++
 include/rdma/ib_verbs.h              | 14 ++++++++++++++
 include/uapi/rdma/ib_user_verbs.h    | 18 ++++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 612ccfd..92791b9 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -219,6 +219,7 @@ struct ib_uverbs_flow_spec {
 		struct ib_uverbs_flow_spec_eth     eth;
 		struct ib_uverbs_flow_spec_ipv4    ipv4;
 		struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
+		struct ib_uverbs_flow_spec_ipv6    ipv6;
 	};
 };
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 1a8babb..7125f24 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3040,6 +3040,15 @@ static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 		memcpy(&ib_spec->ipv4.mask, &kern_spec->ipv4.mask,
 		       sizeof(struct ib_flow_ipv4_filter));
 		break;
+	case IB_FLOW_SPEC_IPV6:
+		ib_spec->ipv6.size = sizeof(struct ib_flow_spec_ipv6);
+		if (ib_spec->ipv6.size != kern_spec->ipv6.size)
+			return -EINVAL;
+		memcpy(&ib_spec->ipv6.val, &kern_spec->ipv6.val,
+		       sizeof(struct ib_flow_ipv6_filter));
+		memcpy(&ib_spec->ipv6.mask, &kern_spec->ipv6.mask,
+		       sizeof(struct ib_flow_ipv6_filter));
+		break;
 	case IB_FLOW_SPEC_TCP:
 	case IB_FLOW_SPEC_UDP:
 		ib_spec->tcp_udp.size = sizeof(struct ib_flow_spec_tcp_udp);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 432bed5..8f76032 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1506,6 +1506,7 @@ enum ib_flow_spec_type {
 	IB_FLOW_SPEC_IB		= 0x22,
 	/* L3 header*/
 	IB_FLOW_SPEC_IPV4	= 0x30,
+	IB_FLOW_SPEC_IPV6	= 0x31,
 	/* L4 headers*/
 	IB_FLOW_SPEC_TCP	= 0x40,
 	IB_FLOW_SPEC_UDP	= 0x41
@@ -1567,6 +1568,18 @@ struct ib_flow_spec_ipv4 {
 	struct ib_flow_ipv4_filter mask;
 };
 
+struct ib_flow_ipv6_filter {
+	u8	src_ip[16];
+	u8	dst_ip[16];
+};
+
+struct ib_flow_spec_ipv6 {
+	enum ib_flow_spec_type	   type;
+	u16			   size;
+	struct ib_flow_ipv6_filter val;
+	struct ib_flow_ipv6_filter mask;
+};
+
 struct ib_flow_tcp_udp_filter {
 	__be16	dst_port;
 	__be16	src_port;
@@ -1588,6 +1601,7 @@ union ib_flow_spec {
 	struct ib_flow_spec_ib		ib;
 	struct ib_flow_spec_ipv4        ipv4;
 	struct ib_flow_spec_tcp_udp	tcp_udp;
+	struct ib_flow_spec_ipv6        ipv6;
 };
 
 struct ib_flow_attr {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index b6543d7..9bd22fa 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -852,6 +852,24 @@ struct ib_uverbs_flow_spec_tcp_udp {
 	struct ib_uverbs_flow_tcp_udp_filter mask;
 };
 
+struct ib_uverbs_flow_ipv6_filter {
+	__u8 src_ip[16];
+	__u8 dst_ip[16];
+};
+
+struct ib_uverbs_flow_spec_ipv6 {
+	union {
+		struct ib_uverbs_flow_spec_hdr hdr;
+		struct {
+			__u32 type;
+			__u16 size;
+			__u16 reserved;
+		};
+	};
+	struct ib_uverbs_flow_ipv6_filter val;
+	struct ib_uverbs_flow_ipv6_filter mask;
+};
+
 struct ib_uverbs_flow_attr {
 	__u32 type;
 	__u16 size;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

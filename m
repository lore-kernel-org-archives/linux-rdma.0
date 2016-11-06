From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/5] ibverbs: Introduce IBV_FLOW_SPEC_IPV4_EXT flow specification
Date: Sun,  6 Nov 2016 16:42:46 +0200
Message-ID: <1478443369-8208-3-git-send-email-yishaih@mellanox.com>
References: <1478443369-8208-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478443369-8208-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce a new extended specification named IBV_FLOW_SPEC_IPV4_EXT
which extends the IBV_FLOW_SPEC_IPV4 specification with the following fields:
1. Type of Service
2. Time to Live
3. Flags
4. Protocol

The IBV_FLOW_SPEC_IPV4 specification itself can't be extended since
current code doesn't take into account the size of the specification
which the user provided, it uses internally the basic structure size
and as such is not extendable.

Changing the library code for IBV_FLOW_SPEC_IPV4 to use the input size
and add the above fields to this specification might cause few issues:

1) An application that would like to use the new fields and as such will be
   compiled over the new library but run over a legacy library will have no
   hint that the new fields were really ignored as of the usage of the fixed
   size inside the legacy library.

2) Existing applications which ignored this input size field will
   start to fail as of the new size checking in the library for this
   specification.

To prevent the above issues this patch introduces an extended new
IPV4 specification having the above new fields.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 libibverbs/kern-abi.h | 18 +++++++++++++++
 libibverbs/verbs.h    | 18 +++++++++++++++
 3 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 496d27b..c960f16 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -42,7 +42,7 @@
 #include <string.h>
 
 #include "ibverbs.h"
-
+#include <ccan/minmax.h>
 
 int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd,
 			size_t cmd_size, struct ibv_get_context_resp *resp,
@@ -1590,9 +1590,55 @@ int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t l
 	return 0;
 }
 
+static int buffer_is_zero(char *addr, ssize_t size)
+{
+	return addr[0] == 0 && !memcmp(addr, addr + 1, size - 1);
+}
+
+static int get_filters_size(struct ibv_flow_spec *ib_spec,
+			    struct ibv_kern_spec *kern_spec,
+			    int *ib_filter_size, int *kern_filter_size,
+			    enum ibv_flow_spec_type type)
+{
+	void *ib_spec_filter_mask;
+	int curr_kern_filter_size;
+	int min_filter_size;
+
+	*ib_filter_size = (ib_spec->hdr.size - sizeof(ib_spec->hdr)) / 2;
+
+	switch (type) {
+	case IBV_FLOW_SPEC_IPV4_EXT:
+		min_filter_size =
+			offsetof(struct ibv_kern_ipv4_ext_filter, flags) +
+			sizeof(kern_spec->ipv4_ext.mask.flags);
+		curr_kern_filter_size = min_filter_size;
+		ib_spec_filter_mask = (void *)&ib_spec->ipv4_ext.val +
+			*ib_filter_size;
+		break;
+	default:
+		return EINVAL;
+	}
+
+	if (*ib_filter_size < min_filter_size)
+		return EINVAL;
+
+	if (*ib_filter_size > curr_kern_filter_size &&
+	    !buffer_is_zero(ib_spec_filter_mask + curr_kern_filter_size,
+			    *ib_filter_size - curr_kern_filter_size))
+		return EOPNOTSUPP;
+
+	*kern_filter_size = min_t(int, curr_kern_filter_size, *ib_filter_size);
+
+	return 0;
+}
+
 static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 				struct ibv_kern_spec *kern_spec)
 {
+	int kern_filter_size;
+	int ib_filter_size;
+	int ret;
+
 	kern_spec->hdr.type = ib_spec->hdr.type;
 
 	switch (ib_spec->hdr.type) {
@@ -1610,6 +1656,21 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		memcpy(&kern_spec->ipv4.mask, &ib_spec->ipv4.mask,
 		       sizeof(struct ibv_flow_ipv4_filter));
 		break;
+	case IBV_FLOW_SPEC_IPV4_EXT:
+		ret = get_filters_size(ib_spec, kern_spec,
+				       &ib_filter_size, &kern_filter_size,
+				       IBV_FLOW_SPEC_IPV4_EXT);
+		if (ret)
+			return ret;
+
+		kern_spec->hdr.type = IBV_FLOW_SPEC_IPV4;
+		kern_spec->ipv4_ext.size = sizeof(struct
+						  ibv_kern_spec_ipv4_ext);
+		memcpy(&kern_spec->ipv4_ext.val, &ib_spec->ipv4_ext.val,
+		       kern_filter_size);
+		memcpy(&kern_spec->ipv4_ext.mask, (void *)&ib_spec->ipv4_ext.val
+		       + ib_filter_size, kern_filter_size);
+		break;
 	case IBV_FLOW_SPEC_TCP:
 	case IBV_FLOW_SPEC_UDP:
 		kern_spec->tcp_udp.size = sizeof(struct ibv_kern_spec_tcp_udp);
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 381fd50..3869e64 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -852,6 +852,23 @@ struct ibv_kern_spec_ipv4 {
 	struct ibv_kern_ipv4_filter mask;
 };
 
+struct ibv_kern_ipv4_ext_filter {
+	__u32 src_ip;
+	__u32 dst_ip;
+	__u8  proto;
+	__u8  tos;
+	__u8  ttl;
+	__u8  flags;
+};
+
+struct ibv_kern_spec_ipv4_ext {
+	__u32  type;
+	__u16  size;
+	__u16 reserved;
+	struct ibv_kern_ipv4_ext_filter val;
+	struct ibv_kern_ipv4_ext_filter mask;
+};
+
 struct ibv_kern_tcp_udp_filter {
 	__u16 dst_port;
 	__u16 src_port;
@@ -875,6 +892,7 @@ struct ibv_kern_spec {
 		} hdr;
 		struct ibv_kern_spec_eth eth;
 		struct ibv_kern_spec_ipv4 ipv4;
+		struct ibv_kern_spec_ipv4_ext ipv4_ext;
 		struct ibv_kern_spec_tcp_udp tcp_udp;
 	};
 
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 67a44a7..a4e120b 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1177,6 +1177,7 @@ enum ibv_flow_attr_type {
 enum ibv_flow_spec_type {
 	IBV_FLOW_SPEC_ETH	= 0x20,
 	IBV_FLOW_SPEC_IPV4	= 0x30,
+	IBV_FLOW_SPEC_IPV4_EXT	= 0x32,
 	IBV_FLOW_SPEC_TCP	= 0x40,
 	IBV_FLOW_SPEC_UDP	= 0x41,
 };
@@ -1210,6 +1211,22 @@ struct ibv_flow_spec_ipv4 {
 	struct ibv_flow_ipv4_filter mask;
 };
 
+struct ibv_flow_ipv4_ext_filter {
+	uint32_t src_ip;
+	uint32_t dst_ip;
+	uint8_t  proto;
+	uint8_t  tos;
+	uint8_t  ttl;
+	uint8_t  flags;
+};
+
+struct ibv_flow_spec_ipv4_ext {
+	enum ibv_flow_spec_type  type;
+	uint16_t  size;
+	struct ibv_flow_ipv4_ext_filter val;
+	struct ibv_flow_ipv4_ext_filter mask;
+};
+
 struct ibv_flow_tcp_udp_filter {
 	uint16_t dst_port;
 	uint16_t src_port;
@@ -1231,6 +1248,7 @@ struct ibv_flow_spec {
 		struct ibv_flow_spec_eth eth;
 		struct ibv_flow_spec_ipv4 ipv4;
 		struct ibv_flow_spec_tcp_udp tcp_udp;
+		struct ibv_flow_spec_ipv4_ext ipv4_ext;
 	};
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

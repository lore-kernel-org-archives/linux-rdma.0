From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/5] ibverbs: Add flow tag specification
Date: Wed,  5 Apr 2017 18:19:22 +0300
Message-ID: <1491405564-19735-4-git-send-email-yishaih@mellanox.com>
References: <1491405564-19735-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491405564-19735-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The flow tag specification is used to identify flow with
specific tag-id.
This feature allows an application to request to add an action to tag
all the packets that matches this rule.
This tag-id will be later reported in the CQE.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                 |  5 +++++
 libibverbs/kern-abi.h            |  8 ++++++++
 libibverbs/man/ibv_create_flow.3 |  1 +
 libibverbs/verbs.h               | 10 +++++++++-
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 6bdd1c4..3a5aa4e 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1818,6 +1818,11 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		memcpy(&kern_spec->tunnel.mask, (void *)&ib_spec->tunnel.val
 		       + ib_filter_size, kern_filter_size);
 		break;
+	case IBV_FLOW_SPEC_ACTION_TAG:
+		kern_spec->flow_tag.size =
+			sizeof(struct ibv_kern_spec_action_tag);
+		kern_spec->flow_tag.tag_id = ib_spec->flow_tag.tag_id;
+		break;
 	default:
 		return EINVAL;
 	}
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index f8bdc9d..448b2e8 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -918,6 +918,13 @@ struct ibv_kern_spec_tcp_udp {
 	struct ibv_kern_tcp_udp_filter mask;
 };
 
+struct ibv_kern_spec_action_tag {
+	__u32  type;
+	__u16  size;
+	__u16 reserved;
+	__u32 tag_id;
+	__u32 reserved1;
+};
 
 struct ibv_kern_tunnel_filter {
 	__u32 tunnel_id;
@@ -944,6 +951,7 @@ struct ibv_kern_spec {
 		struct ibv_kern_spec_tcp_udp tcp_udp;
 		struct ibv_kern_spec_ipv6 ipv6;
 		struct ibv_kern_spec_tunnel tunnel;
+		struct ibv_kern_spec_action_tag flow_tag;
 	};
 };
 
diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index 32a7572..32d47ad 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -68,6 +68,7 @@ IBV_FLOW_SPEC_TCP                       = 0x40,   /* Flow specification of TCP h
 IBV_FLOW_SPEC_UDP                       = 0x41,   /* Flow specification of UDP header */
 IBV_FLOW_SPEC_VXLAN_TUNNEL             	= 0x50,   /* Flow specification of VXLAN header */
 IBV_FLOW_SPEC_INNER                    	= 0x100,  /* Flag making L2/L3/L4 specifications to be applied on the inner header */
+IBV_FLOW_SPEC_ACTION_TAG                = 0x1000, /* Action tagging matched packet */
 .in -8
 };
 .br
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 225ab81..5a4dcbc 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1224,7 +1224,8 @@ enum ibv_flow_spec_type {
 	IBV_FLOW_SPEC_TCP		= 0x40,
 	IBV_FLOW_SPEC_UDP		= 0x41,
 	IBV_FLOW_SPEC_VXLAN_TUNNEL	= 0x50,
-	IBV_FLOW_SPEC_INNER		= 0x100
+	IBV_FLOW_SPEC_INNER		= 0x100,
+	IBV_FLOW_SPEC_ACTION_TAG	= 0x1000
 };
 
 struct ibv_flow_eth_filter {
@@ -1311,6 +1312,12 @@ struct ibv_flow_spec_tunnel {
 	struct ibv_flow_tunnel_filter mask;
 };
 
+struct ibv_flow_spec_action_tag {
+	enum ibv_flow_spec_type  type;
+	uint16_t  size;
+	uint32_t  tag_id;
+};
+
 struct ibv_flow_spec {
 	union {
 		struct {
@@ -1323,6 +1330,7 @@ struct ibv_flow_spec {
 		struct ibv_flow_spec_ipv4_ext ipv4_ext;
 		struct ibv_flow_spec_ipv6 ipv6;
 		struct ibv_flow_spec_tunnel tunnel;
+		struct ibv_flow_spec_action_tag flow_tag;
 	};
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

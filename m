From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Introduce flow steering drop action
Date: Thu,  1 Jun 2017 18:47:14 +0300
Message-ID: <1496332034-14758-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This flow steering specification identifies a drop flow to the
hardware.

If user creates a flow only with the drop specification, then all the
packets that hit this flow will be dropped, otherwise the hardware will
drop only the packets that match the other L2/L3/L4 specifications.

Signed-off-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

This is the complementary user space part of the kernel code that was merged
into 4.12.

 libibverbs/cmd.c                 | 3 +++
 libibverbs/kern-abi.h            | 7 +++++++
 libibverbs/man/ibv_create_flow.3 | 1 +
 libibverbs/verbs.h               | 9 ++++++++-
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 3a5aa4e..7a266ee 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1823,6 +1823,9 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 			sizeof(struct ibv_kern_spec_action_tag);
 		kern_spec->flow_tag.tag_id = ib_spec->flow_tag.tag_id;
 		break;
+	case IBV_FLOW_SPEC_ACTION_DROP:
+		kern_spec->drop.size = sizeof(struct ibv_kern_spec_action_drop);
+		break;
 	default:
 		return EINVAL;
 	}
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 448b2e8..8d42faf 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -938,6 +938,12 @@ struct ibv_kern_spec_tunnel {
 	struct ibv_kern_tunnel_filter mask;
 };
 
+struct ibv_kern_spec_action_drop {
+	__u32  type;
+	__u16  size;
+	__u16 reserved;
+};
+
 struct ibv_kern_spec {
 	union {
 		struct {
@@ -952,6 +958,7 @@ struct ibv_kern_spec {
 		struct ibv_kern_spec_ipv6 ipv6;
 		struct ibv_kern_spec_tunnel tunnel;
 		struct ibv_kern_spec_action_tag flow_tag;
+		struct ibv_kern_spec_action_drop drop;
 	};
 };
 
diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index 32d47ad..48bbb14 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -69,6 +69,7 @@ IBV_FLOW_SPEC_UDP                       = 0x41,   /* Flow specification of UDP h
 IBV_FLOW_SPEC_VXLAN_TUNNEL             	= 0x50,   /* Flow specification of VXLAN header */
 IBV_FLOW_SPEC_INNER                    	= 0x100,  /* Flag making L2/L3/L4 specifications to be applied on the inner header */
 IBV_FLOW_SPEC_ACTION_TAG                = 0x1000, /* Action tagging matched packet */
+IBV_FLOW_SPEC_ACTION_DROP               = 0x1001, /* Action dropping matched packet */
 .in -8
 };
 .br
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index b27dfd1..4f0765e 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1233,7 +1233,8 @@ enum ibv_flow_spec_type {
 	IBV_FLOW_SPEC_UDP		= 0x41,
 	IBV_FLOW_SPEC_VXLAN_TUNNEL	= 0x50,
 	IBV_FLOW_SPEC_INNER		= 0x100,
-	IBV_FLOW_SPEC_ACTION_TAG	= 0x1000
+	IBV_FLOW_SPEC_ACTION_TAG	= 0x1000,
+	IBV_FLOW_SPEC_ACTION_DROP	= 0x1001,
 };
 
 struct ibv_flow_eth_filter {
@@ -1326,6 +1327,11 @@ struct ibv_flow_spec_action_tag {
 	uint32_t  tag_id;
 };
 
+struct ibv_flow_spec_action_drop {
+	enum ibv_flow_spec_type  type;
+	uint16_t  size;
+};
+
 struct ibv_flow_spec {
 	union {
 		struct {
@@ -1339,6 +1345,7 @@ struct ibv_flow_spec {
 		struct ibv_flow_spec_ipv6 ipv6;
 		struct ibv_flow_spec_tunnel tunnel;
 		struct ibv_flow_spec_action_tag flow_tag;
+		struct ibv_flow_spec_action_drop drop;
 	};
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

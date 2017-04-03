From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/core: Introduce drop flow specification
Date: Mon,  3 Apr 2017 13:13:51 +0300
Message-ID: <20170403101352.5692-2-leon@kernel.org>
References: <20170403101352.5692-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403101352.5692-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This flow steering specification identifies flow for drop by the HW.
If user create a flow only with the drop specification,
then all the packets that hit this flow will be dropped, otherwise the HW
will drop only the packets that match the other L2/L3/L4 specifications.

Signed-off-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h     |  1 +
 drivers/infiniband/core/uverbs_cmd.c |  7 +++++++
 include/rdma/ib_verbs.h              |  7 +++++++
 include/uapi/rdma/ib_user_verbs.h    | 11 +++++++++++
 4 files changed, 26 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index e1bedf0bac04..0f5578f8ba59 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -229,6 +229,7 @@ struct ib_uverbs_flow_spec {
 		struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
 		struct ib_uverbs_flow_spec_ipv6    ipv6;
 		struct ib_uverbs_flow_spec_action_tag	flow_tag;
+		struct ib_uverbs_flow_spec_action_drop	drop;
 	};
 };
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7b7a76e1279a..4e5062dd84e0 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3227,6 +3227,13 @@ static int kern_spec_to_ib_spec_action(struct ib_uverbs_flow_spec *kern_spec,
 		ib_spec->flow_tag.size = sizeof(struct ib_flow_spec_action_tag);
 		ib_spec->flow_tag.tag_id = kern_spec->flow_tag.tag_id;
 		break;
+	case IB_FLOW_SPEC_ACTION_DROP:
+		if (kern_spec->drop.size !=
+		    sizeof(struct ib_uverbs_flow_spec_action_drop))
+			return -EINVAL;
+
+		ib_spec->drop.size = sizeof(struct ib_flow_spec_action_drop);
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0f1813c13687..1676d36956ee 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1662,6 +1662,7 @@ enum ib_flow_spec_type {
 	IB_FLOW_SPEC_INNER		= 0x100,
 	/* Actions */
 	IB_FLOW_SPEC_ACTION_TAG         = 0x1000,
+	IB_FLOW_SPEC_ACTION_DROP        = 0x1001,
 };
 #define IB_FLOW_SPEC_LAYER_MASK	0xF0
 #define IB_FLOW_SPEC_SUPPORT_LAYERS 8
@@ -1790,6 +1791,11 @@ struct ib_flow_spec_action_tag {
 	u32                           tag_id;
 };
 
+struct ib_flow_spec_action_drop {
+	enum ib_flow_spec_type	      type;
+	u16			      size;
+};
+
 union ib_flow_spec {
 	struct {
 		u32			type;
@@ -1802,6 +1808,7 @@ union ib_flow_spec {
 	struct ib_flow_spec_ipv6        ipv6;
 	struct ib_flow_spec_tunnel      tunnel;
 	struct ib_flow_spec_action_tag  flow_tag;
+	struct ib_flow_spec_action_drop drop;
 };
 
 struct ib_flow_attr {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 997f904c7692..477d629f539d 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -947,6 +947,17 @@ struct ib_uverbs_flow_spec_action_tag {
 	__u32			      reserved1;
 };
 
+struct ib_uverbs_flow_spec_action_drop {
+	union {
+		struct ib_uverbs_flow_spec_hdr hdr;
+		struct {
+			__u32 type;
+			__u16 size;
+			__u16 reserved;
+		};
+	};
+};
+
 struct ib_uverbs_flow_tunnel_filter {
 	__be32 tunnel_id;
 };
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

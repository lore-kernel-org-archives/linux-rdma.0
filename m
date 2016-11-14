From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 3/6] IB/uverbs: Add support for Vxlan protocol
Date: Mon, 14 Nov 2016 19:04:49 +0200
Message-ID: <1479143092-11723-4-git-send-email-leonro@mellanox.com>
References: <1479143092-11723-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479143092-11723-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add ib_uverbs_flow_spec_tunnel to define the rule to match Vxlan,
the type, size, reserved fields are identical to rest of the protocols,
and are used to identify the spec.
The tunnel id is the vni value of the Vxlan protocol, and it is used
as part of the steering rule, it is limited by the mask.
The steering rule configured on the hardware does a match
according to vni and other protocols.
In the same way as rest of the protocols that we match,
the uniq field's of each protocol are represented on
the val and the mask.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/ib_user_verbs.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 25225eb..90ba5e8 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -908,6 +908,23 @@ struct ib_uverbs_flow_spec_ipv6 {
 	struct ib_uverbs_flow_ipv6_filter mask;
 };

+struct ib_uverbs_flow_tunnel_filter {
+	__be32 tunnel_id;
+};
+
+struct ib_uverbs_flow_spec_tunnel {
+	union {
+		struct ib_uverbs_flow_spec_hdr hdr;
+		struct {
+			__u32 type;
+			__u16 size;
+			__u16 reserved;
+		};
+	};
+	struct ib_uverbs_flow_tunnel_filter val;
+	struct ib_uverbs_flow_tunnel_filter mask;
+};
+
 struct ib_uverbs_flow_attr {
 	__u32 type;
 	__u16 size;
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/5] IB/core: Introduce flow tag specification
Date: Wed, 18 Jan 2017 14:59:48 +0200
Message-ID: <20170118125951.3469-3-leon@kernel.org>
References: <20170118125951.3469-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118125951.3469-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This specification identifies flow with a specific tag-id.
This tag-id will be reported in the CQE.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 958a24d..da08a04 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1604,6 +1604,8 @@ enum ib_flow_spec_type {
 	IB_FLOW_SPEC_UDP		= 0x41,
 	IB_FLOW_SPEC_VXLAN_TUNNEL	= 0x50,
 	IB_FLOW_SPEC_INNER		= 0x100,
+	/* Actions */
+	IB_FLOW_SPEC_ACTION_TAG         = 0x1000,
 };
 #define IB_FLOW_SPEC_LAYER_MASK	0xF0
 #define IB_FLOW_SPEC_SUPPORT_LAYERS 8
@@ -1726,6 +1728,12 @@ struct ib_flow_spec_tunnel {
 	struct ib_flow_tunnel_filter  mask;
 };
 
+struct ib_flow_spec_action_tag {
+	enum ib_flow_spec_type	      type;
+	u16			      size;
+	u32                           tag_id;
+};
+
 union ib_flow_spec {
 	struct {
 		u32			type;
@@ -1737,6 +1745,7 @@ union ib_flow_spec {
 	struct ib_flow_spec_tcp_udp	tcp_udp;
 	struct ib_flow_spec_ipv6        ipv6;
 	struct ib_flow_spec_tunnel      tunnel;
+	struct ib_flow_spec_action_tag  flow_tag;
 };
 
 struct ib_flow_attr {
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 1/6] IB/core: Add flow spec tunneling support
Date: Mon, 14 Nov 2016 19:04:47 +0200
Message-ID: <1479143092-11723-2-git-send-email-leonro@mellanox.com>
References: <1479143092-11723-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479143092-11723-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to support tunneling, that can be used by the QP,
both struct ib_flow_spec_tunnel and struct ib_flow_tunnel_filter can be
used to more IP or UDP based tunneling protocols (e.g NVGRE, GRE, etc).

IB_FLOW_SPEC_VXLAN_TUNNEL type flow specification is added to use this
functionality and match specific Vxlan packets.

In similar to IPv6, we check overflow of the vni value by
comparing with the maximum size.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 15 +++++++++++++++
 include/rdma/ib_verbs.h              | 19 ++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cb3f515a..561010a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3175,6 +3175,21 @@ static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 		memcpy(&ib_spec->tcp_udp.val, kern_spec_val, actual_filter_sz);
 		memcpy(&ib_spec->tcp_udp.mask, kern_spec_mask, actual_filter_sz);
 		break;
+	case IB_FLOW_SPEC_VXLAN_TUNNEL:
+		ib_filter_sz = offsetof(struct ib_flow_tunnel_filter, real_sz);
+		actual_filter_sz = spec_filter_size(kern_spec_mask,
+						    kern_filter_sz,
+						    ib_filter_sz);
+		if (actual_filter_sz <= 0)
+			return -EINVAL;
+		ib_spec->tunnel.size = sizeof(struct ib_flow_spec_tunnel);
+		memcpy(&ib_spec->tunnel.val, kern_spec_val, actual_filter_sz);
+		memcpy(&ib_spec->tunnel.mask, kern_spec_mask, actual_filter_sz);
+
+		if ((ntohl(ib_spec->tunnel.mask.tunnel_id)) >= BIT(24) ||
+		    (ntohl(ib_spec->tunnel.val.tunnel_id)) >= BIT(24))
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..9dd8309 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1599,7 +1599,8 @@ enum ib_flow_spec_type {
 	IB_FLOW_SPEC_IPV6	= 0x31,
 	/* L4 headers*/
 	IB_FLOW_SPEC_TCP	= 0x40,
-	IB_FLOW_SPEC_UDP	= 0x41
+	IB_FLOW_SPEC_UDP	= 0x41,
+	IB_FLOW_SPEC_VXLAN_TUNNEL	= 0x50,
 };
 #define IB_FLOW_SPEC_LAYER_MASK	0xF0
 #define IB_FLOW_SPEC_SUPPORT_LAYERS 4
@@ -1707,6 +1708,21 @@ struct ib_flow_spec_tcp_udp {
 	struct ib_flow_tcp_udp_filter mask;
 };

+struct ib_flow_tunnel_filter {
+	__be32	tunnel_id;
+	u8	real_sz[0];
+};
+
+/* ib_flow_spec_tunnel describes the Vxlan tunnel
+ * the tunnel_id from val has the vni value
+ */
+struct ib_flow_spec_tunnel {
+	enum ib_flow_spec_type	      type;
+	u16			      size;
+	struct ib_flow_tunnel_filter  val;
+	struct ib_flow_tunnel_filter  mask;
+};
+
 union ib_flow_spec {
 	struct {
 		enum ib_flow_spec_type	type;
@@ -1717,6 +1733,7 @@ union ib_flow_spec {
 	struct ib_flow_spec_ipv4        ipv4;
 	struct ib_flow_spec_tcp_udp	tcp_udp;
 	struct ib_flow_spec_ipv6        ipv6;
+	struct ib_flow_spec_tunnel      tunnel;
 };

 struct ib_flow_attr {
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

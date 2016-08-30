From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 6/7] IB/mlx5: Add support in TOS and protocol to flow steering
Date: Tue, 30 Aug 2016 16:58:35 +0300
Message-ID: <1472565516-11591-7-git-send-email-leon@kernel.org>
References: <1472565516-11591-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472565516-11591-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support to receive TOS or specific IPv4 protocol.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4268895..21448d3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1405,9 +1405,23 @@ static bool outer_header_zero(u32 *match_criteria)
 						  size - 1);
 }
 
+static void set_proto(void *outer_c, void *outer_v, u8 mask, u8 val)
+{
+	MLX5_SET(fte_match_set_lyr_2_4, outer_c, ip_protocol, mask);
+	MLX5_SET(fte_match_set_lyr_2_4, outer_v, ip_protocol, val);
+}
+
+static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
+{
+	MLX5_SET(fte_match_set_lyr_2_4, outer_c, ip_ecn, mask);
+	MLX5_SET(fte_match_set_lyr_2_4, outer_v, ip_ecn, val);
+	MLX5_SET(fte_match_set_lyr_2_4, outer_c, ip_dscp, mask >> 2);
+	MLX5_SET(fte_match_set_lyr_2_4, outer_v, ip_dscp, val >> 2);
+}
+
 #define LAST_ETH_FIELD vlan_tag
 #define LAST_IB_FIELD sl
-#define LAST_IPV4_FIELD dst_ip
+#define LAST_IPV4_FIELD tos
 #define LAST_IPV6_FIELD dst_ip
 #define LAST_TCP_UDP_FIELD src_port
 
@@ -1493,6 +1507,12 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 				    dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
 		       &ib_spec->ipv4.val.dst_ip,
 		       sizeof(ib_spec->ipv4.val.dst_ip));
+
+		set_tos(outer_headers_c, outer_headers_v,
+			ib_spec->ipv4.mask.tos, ib_spec->ipv4.val.tos);
+
+		set_proto(outer_headers_c, outer_headers_v,
+			  ib_spec->ipv4.mask.proto, ib_spec->ipv4.val.proto);
 		break;
 	case IB_FLOW_SPEC_IPV6:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv6.mask, LAST_IPV6_FIELD))
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

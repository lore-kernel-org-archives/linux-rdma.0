From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 2/7] IB/mlx5: Add validation to flow specifications parsing
Date: Tue, 30 Aug 2016 16:58:31 +0300
Message-ID: <1472565516-11591-3-git-send-email-leon@kernel.org>
References: <1472565516-11591-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472565516-11591-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add validation check that all set fields in flow specification
are supported by vendor.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f02a975..4268895 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1405,6 +1405,20 @@ static bool outer_header_zero(u32 *match_criteria)
 						  size - 1);
 }
 
+#define LAST_ETH_FIELD vlan_tag
+#define LAST_IB_FIELD sl
+#define LAST_IPV4_FIELD dst_ip
+#define LAST_IPV6_FIELD dst_ip
+#define LAST_TCP_UDP_FIELD src_port
+
+/* Field is the last supported field */
+#define FIELDS_NOT_SUPPORTED(filter, field)\
+	memchr_inv((void *)&filter.field  +\
+		   sizeof(filter.field), 0,\
+		   sizeof(filter) -\
+		   offsetof(typeof(filter), field) -\
+		   sizeof(filter.field))
+
 static int parse_flow_attr(u32 *match_c, u32 *match_v,
 			   union ib_flow_spec *ib_spec)
 {
@@ -1414,8 +1428,8 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 					     outer_headers);
 	switch (ib_spec->type) {
 	case IB_FLOW_SPEC_ETH:
-		if (ib_spec->size != sizeof(ib_spec->eth))
-			return -EINVAL;
+		if (FIELDS_NOT_SUPPORTED(ib_spec->eth.mask, LAST_ETH_FIELD))
+			return -ENOTSUPP;
 
 		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
 					     dmac_47_16),
@@ -1455,8 +1469,8 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 			 ethertype, ntohs(ib_spec->eth.val.ether_type));
 		break;
 	case IB_FLOW_SPEC_IPV4:
-		if (ib_spec->size != sizeof(ib_spec->ipv4))
-			return -EINVAL;
+		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv4.mask, LAST_IPV4_FIELD))
+			return -ENOTSUPP;
 
 		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
 			 ethertype, 0xffff);
@@ -1481,8 +1495,8 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 		       sizeof(ib_spec->ipv4.val.dst_ip));
 		break;
 	case IB_FLOW_SPEC_IPV6:
-		if (ib_spec->size != sizeof(ib_spec->ipv6))
-			return -EINVAL;
+		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv6.mask, LAST_IPV6_FIELD))
+			return -ENOTSUPP;
 
 		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
 			 ethertype, 0xffff);
@@ -1507,8 +1521,9 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 		       sizeof(ib_spec->ipv6.val.dst_ip));
 		break;
 	case IB_FLOW_SPEC_TCP:
-		if (ib_spec->size != sizeof(ib_spec->tcp_udp))
-			return -EINVAL;
+		if (FIELDS_NOT_SUPPORTED(ib_spec->tcp_udp.mask,
+					 LAST_TCP_UDP_FIELD))
+			return -ENOTSUPP;
 
 		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c, ip_protocol,
 			 0xff);
@@ -1526,8 +1541,9 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 			 ntohs(ib_spec->tcp_udp.val.dst_port));
 		break;
 	case IB_FLOW_SPEC_UDP:
-		if (ib_spec->size != sizeof(ib_spec->tcp_udp))
-			return -EINVAL;
+		if (FIELDS_NOT_SUPPORTED(ib_spec->tcp_udp.mask,
+					 LAST_TCP_UDP_FIELD))
+			return -ENOTSUPP;
 
 		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c, ip_protocol,
 			 0xff);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

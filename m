From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 7/7] IB/mlx5: Add support of more IPv6 fields to flow steering
Date: Tue, 30 Aug 2016 16:58:36 +0300
Message-ID: <1472565516-11591-8-git-send-email-leon@kernel.org>
References: <1472565516-11591-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472565516-11591-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support to receive Traffic Class, specific IPv6 protocol
or IPv6 flow label.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 56 +++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 21448d3..0f6c583 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1394,15 +1394,31 @@ static int mlx5_ib_dealloc_pd(struct ib_pd *pd)
 	return 0;
 }
 
-static bool outer_header_zero(u32 *match_criteria)
+enum {
+	MATCH_CRITERIA_ENABLE_OUTER_BIT,
+	MATCH_CRITERIA_ENABLE_MISC_BIT,
+	MATCH_CRITERIA_ENABLE_INNER_BIT
+};
+
+#define HEADER_IS_ZERO(match_criteria, headers)			           \
+	!(memchr_inv(MLX5_ADDR_OF(fte_match_param, match_criteria, headers), \
+		    0, MLX5_FLD_SZ_BYTES(fte_match_param, headers)))       \
+
+static u8 get_match_criteria_enable(u32 *match_criteria)
 {
-	int size = MLX5_ST_SZ_BYTES(fte_match_param);
-	char *outer_headers_c = MLX5_ADDR_OF(fte_match_param, match_criteria,
-					     outer_headers);
+	u8 match_criteria_enable;
+
+	match_criteria_enable =
+		(!HEADER_IS_ZERO(match_criteria, outer_headers)) <<
+		MATCH_CRITERIA_ENABLE_OUTER_BIT;
+	match_criteria_enable |=
+		(!HEADER_IS_ZERO(match_criteria, misc_parameters)) <<
+		MATCH_CRITERIA_ENABLE_MISC_BIT;
+	match_criteria_enable |=
+		(!HEADER_IS_ZERO(match_criteria, inner_headers)) <<
+		MATCH_CRITERIA_ENABLE_INNER_BIT;
 
-	return outer_headers_c[0] == 0 && !memcmp(outer_headers_c,
-						  outer_headers_c + 1,
-						  size - 1);
+	return match_criteria_enable;
 }
 
 static void set_proto(void *outer_c, void *outer_v, u8 mask, u8 val)
@@ -1422,7 +1438,7 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 #define LAST_ETH_FIELD vlan_tag
 #define LAST_IB_FIELD sl
 #define LAST_IPV4_FIELD tos
-#define LAST_IPV6_FIELD dst_ip
+#define LAST_IPV6_FIELD traffic_class
 #define LAST_TCP_UDP_FIELD src_port
 
 /* Field is the last supported field */
@@ -1440,6 +1456,11 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 					     outer_headers);
 	void *outer_headers_v = MLX5_ADDR_OF(fte_match_param, match_v,
 					     outer_headers);
+	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
+					   misc_parameters);
+	void *misc_params_v = MLX5_ADDR_OF(fte_match_param, match_v,
+					   misc_parameters);
+
 	switch (ib_spec->type) {
 	case IB_FLOW_SPEC_ETH:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->eth.mask, LAST_ETH_FIELD))
@@ -1539,6 +1560,21 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
 		       &ib_spec->ipv6.val.dst_ip,
 		       sizeof(ib_spec->ipv6.val.dst_ip));
+
+		set_tos(outer_headers_c, outer_headers_v,
+			ib_spec->ipv6.mask.traffic_class,
+			ib_spec->ipv6.val.traffic_class);
+
+		set_proto(outer_headers_c, outer_headers_v,
+			  ib_spec->ipv6.mask.next_hdr,
+			  ib_spec->ipv6.val.next_hdr);
+
+		MLX5_SET(fte_match_set_misc, misc_params_c,
+			 outer_ipv6_flow_label,
+			 ntohl(ib_spec->ipv6.mask.flow_label));
+		MLX5_SET(fte_match_set_misc, misc_params_v,
+			 outer_ipv6_flow_label,
+			 ntohl(ib_spec->ipv6.val.flow_label));
 		break;
 	case IB_FLOW_SPEC_TCP:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->tcp_udp.mask,
@@ -1766,9 +1802,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 		ib_flow += ((union ib_flow_spec *)ib_flow)->size;
 	}
 
-	/* Outer header support only */
-	spec->match_criteria_enable = (!outer_header_zero(spec->match_criteria))
-		<< 0;
+	spec->match_criteria_enable = get_match_criteria_enable(spec->match_criteria);
 	action = dst ? MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
 		MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
 	handler->rule = mlx5_add_flow_rule(ft, spec,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

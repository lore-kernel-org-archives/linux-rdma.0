From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 6/6] IB/mlx5: Add support to match inner packet fields
Date: Mon, 14 Nov 2016 19:04:52 +0200
Message-ID: <1479143092-11723-7-git-send-email-leonro@mellanox.com>
References: <1479143092-11723-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479143092-11723-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support to match packet fields which are tunneled,
i.e. support matching the header of the inner packet which is the result of
or bit operation of the original header and the IB_FLOW_SPEC_INNER type.

The combination of IB_FLOW_SPEC_INNER | IB_FLOW_SPEC_VXLAN_TUNNEL is not
needed to be checked, because the IB core has this check already.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 131 +++++++++++++++++++++++---------------
 1 file changed, 78 insertions(+), 53 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a833f45..65eb5e0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1502,6 +1502,22 @@ static void set_proto(void *outer_c, void *outer_v, u8 mask, u8 val)
 	MLX5_SET(fte_match_set_lyr_2_4, outer_v, ip_protocol, val);
 }

+static void set_flow_label(void *misc_c, void *misc_v, u8 mask, u8 val,
+			   bool inner)
+{
+	if (inner) {
+		MLX5_SET(fte_match_set_misc,
+			 misc_c, inner_ipv6_flow_label, mask);
+		MLX5_SET(fte_match_set_misc,
+			 misc_v, inner_ipv6_flow_label, val);
+	} else {
+		MLX5_SET(fte_match_set_misc,
+			 misc_c, outer_ipv6_flow_label, mask);
+		MLX5_SET(fte_match_set_misc,
+			 misc_v, outer_ipv6_flow_label, val);
+	}
+}
+
 static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 {
 	MLX5_SET(fte_match_set_lyr_2_4, outer_c, ip_ecn, mask);
@@ -1528,155 +1544,164 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 static int parse_flow_attr(u32 *match_c, u32 *match_v,
 			   const union ib_flow_spec *ib_spec)
 {
-	void *outer_headers_c = MLX5_ADDR_OF(fte_match_param, match_c,
-					     outer_headers);
-	void *outer_headers_v = MLX5_ADDR_OF(fte_match_param, match_v,
-					     outer_headers);
 	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
 					   misc_parameters);
 	void *misc_params_v = MLX5_ADDR_OF(fte_match_param, match_v,
 					   misc_parameters);
+	void *headers_c;
+	void *headers_v;
+
+	if (ib_spec->type & IB_FLOW_SPEC_INNER) {
+		headers_c = MLX5_ADDR_OF(fte_match_param, match_c,
+					 inner_headers);
+		headers_v = MLX5_ADDR_OF(fte_match_param, match_v,
+					 inner_headers);
+	} else {
+		headers_c = MLX5_ADDR_OF(fte_match_param, match_c,
+					 outer_headers);
+		headers_v = MLX5_ADDR_OF(fte_match_param, match_v,
+					 outer_headers);
+	}

-	switch (ib_spec->type) {
+	switch (ib_spec->type & ~IB_FLOW_SPEC_INNER) {
 	case IB_FLOW_SPEC_ETH:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->eth.mask, LAST_ETH_FIELD))
 			return -ENOTSUPP;

-		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 					     dmac_47_16),
 				ib_spec->eth.mask.dst_mac);
-		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_v,
+		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 					     dmac_47_16),
 				ib_spec->eth.val.dst_mac);

-		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 					     smac_47_16),
 				ib_spec->eth.mask.src_mac);
-		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_v,
+		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 					     smac_47_16),
 				ib_spec->eth.val.src_mac);

 		if (ib_spec->eth.mask.vlan_tag) {
-			MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 				 vlan_tag, 1);
-			MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v,
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
 				 vlan_tag, 1);

-			MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 				 first_vid, ntohs(ib_spec->eth.mask.vlan_tag));
-			MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v,
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
 				 first_vid, ntohs(ib_spec->eth.val.vlan_tag));

-			MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 				 first_cfi,
 				 ntohs(ib_spec->eth.mask.vlan_tag) >> 12);
-			MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v,
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
 				 first_cfi,
 				 ntohs(ib_spec->eth.val.vlan_tag) >> 12);

-			MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 				 first_prio,
 				 ntohs(ib_spec->eth.mask.vlan_tag) >> 13);
-			MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v,
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
 				 first_prio,
 				 ntohs(ib_spec->eth.val.vlan_tag) >> 13);
 		}
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 			 ethertype, ntohs(ib_spec->eth.mask.ether_type));
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
 			 ethertype, ntohs(ib_spec->eth.val.ether_type));
 		break;
 	case IB_FLOW_SPEC_IPV4:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv4.mask, LAST_IPV4_FIELD))
 			return -ENOTSUPP;

-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 			 ethertype, 0xffff);
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
 			 ethertype, ETH_P_IP);

-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    src_ipv4_src_ipv6.ipv4_layout.ipv4),
 		       &ib_spec->ipv4.mask.src_ip,
 		       sizeof(ib_spec->ipv4.mask.src_ip));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_v,
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    src_ipv4_src_ipv6.ipv4_layout.ipv4),
 		       &ib_spec->ipv4.val.src_ip,
 		       sizeof(ib_spec->ipv4.val.src_ip));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
 		       &ib_spec->ipv4.mask.dst_ip,
 		       sizeof(ib_spec->ipv4.mask.dst_ip));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_v,
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
 		       &ib_spec->ipv4.val.dst_ip,
 		       sizeof(ib_spec->ipv4.val.dst_ip));

-		set_tos(outer_headers_c, outer_headers_v,
+		set_tos(headers_c, headers_v,
 			ib_spec->ipv4.mask.tos, ib_spec->ipv4.val.tos);

-		set_proto(outer_headers_c, outer_headers_v,
+		set_proto(headers_c, headers_v,
 			  ib_spec->ipv4.mask.proto, ib_spec->ipv4.val.proto);
 		break;
 	case IB_FLOW_SPEC_IPV6:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv6.mask, LAST_IPV6_FIELD))
 			return -ENOTSUPP;

-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 			 ethertype, 0xffff);
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
 			 ethertype, ETH_P_IPV6);

-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
 		       &ib_spec->ipv6.mask.src_ip,
 		       sizeof(ib_spec->ipv6.mask.src_ip));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_v,
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
 		       &ib_spec->ipv6.val.src_ip,
 		       sizeof(ib_spec->ipv6.val.src_ip));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
 		       &ib_spec->ipv6.mask.dst_ip,
 		       sizeof(ib_spec->ipv6.mask.dst_ip));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_v,
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
 		       &ib_spec->ipv6.val.dst_ip,
 		       sizeof(ib_spec->ipv6.val.dst_ip));

-		set_tos(outer_headers_c, outer_headers_v,
+		set_tos(headers_c, headers_v,
 			ib_spec->ipv6.mask.traffic_class,
 			ib_spec->ipv6.val.traffic_class);

-		set_proto(outer_headers_c, outer_headers_v,
+		set_proto(headers_c, headers_v,
 			  ib_spec->ipv6.mask.next_hdr,
 			  ib_spec->ipv6.val.next_hdr);

-		MLX5_SET(fte_match_set_misc, misc_params_c,
-			 outer_ipv6_flow_label,
-			 ntohl(ib_spec->ipv6.mask.flow_label));
-		MLX5_SET(fte_match_set_misc, misc_params_v,
-			 outer_ipv6_flow_label,
-			 ntohl(ib_spec->ipv6.val.flow_label));
+		set_flow_label(misc_params_c, misc_params_v,
+			       ntohl(ib_spec->ipv6.mask.flow_label),
+			       ntohl(ib_spec->ipv6.val.flow_label),
+			       ib_spec->type & IB_FLOW_SPEC_INNER);
+
 		break;
 	case IB_FLOW_SPEC_TCP:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->tcp_udp.mask,
 					 LAST_TCP_UDP_FIELD))
 			return -ENOTSUPP;

-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c, ip_protocol,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
 			 0xff);
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v, ip_protocol,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
 			 IPPROTO_TCP);

-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c, tcp_sport,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, tcp_sport,
 			 ntohs(ib_spec->tcp_udp.mask.src_port));
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v, tcp_sport,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, tcp_sport,
 			 ntohs(ib_spec->tcp_udp.val.src_port));

-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c, tcp_dport,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, tcp_dport,
 			 ntohs(ib_spec->tcp_udp.mask.dst_port));
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v, tcp_dport,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, tcp_dport,
 			 ntohs(ib_spec->tcp_udp.val.dst_port));
 		break;
 	case IB_FLOW_SPEC_UDP:
@@ -1684,19 +1709,19 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 					 LAST_TCP_UDP_FIELD))
 			return -ENOTSUPP;

-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c, ip_protocol,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
 			 0xff);
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v, ip_protocol,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
 			 IPPROTO_UDP);

-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c, udp_sport,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, udp_sport,
 			 ntohs(ib_spec->tcp_udp.mask.src_port));
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v, udp_sport,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, udp_sport,
 			 ntohs(ib_spec->tcp_udp.val.src_port));

-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c, udp_dport,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, udp_dport,
 			 ntohs(ib_spec->tcp_udp.mask.dst_port));
-		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v, udp_dport,
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, udp_dport,
 			 ntohs(ib_spec->tcp_udp.val.dst_port));
 		break;
 	case IB_FLOW_SPEC_VXLAN_TUNNEL:
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

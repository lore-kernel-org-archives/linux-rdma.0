From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/5] IB/mlx5: Replace ENOTSUPP usage with EOPNOTSUPP
Date: Wed, 18 Jan 2017 14:59:51 +0200
Message-ID: <20170118125951.3469-6-leon@kernel.org>
References: <20170118125951.3469-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118125951.3469-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Flow steering is supposed to return EOPNOTSUPP error
for unsupported fields and not ENOTSUPP error.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d557150..858fc3f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1687,7 +1687,7 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 	switch (ib_spec->type & ~IB_FLOW_SPEC_INNER) {
 	case IB_FLOW_SPEC_ETH:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->eth.mask, LAST_ETH_FIELD))
-			return -ENOTSUPP;
+			return -EOPNOTSUPP;
 
 		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 					     dmac_47_16),
@@ -1735,7 +1735,7 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 		break;
 	case IB_FLOW_SPEC_IPV4:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv4.mask, LAST_IPV4_FIELD))
-			return -ENOTSUPP;
+			return -EOPNOTSUPP;
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 			 ethertype, 0xffff);
@@ -1767,7 +1767,7 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 		break;
 	case IB_FLOW_SPEC_IPV6:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv6.mask, LAST_IPV6_FIELD))
-			return -ENOTSUPP;
+			return -EOPNOTSUPP;
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 			 ethertype, 0xffff);
@@ -1808,7 +1808,7 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 	case IB_FLOW_SPEC_TCP:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->tcp_udp.mask,
 					 LAST_TCP_UDP_FIELD))
-			return -ENOTSUPP;
+			return -EOPNOTSUPP;
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
 			 0xff);
@@ -1828,7 +1828,7 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 	case IB_FLOW_SPEC_UDP:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->tcp_udp.mask,
 					 LAST_TCP_UDP_FIELD))
-			return -ENOTSUPP;
+			return -EOPNOTSUPP;
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
 			 0xff);
@@ -1848,7 +1848,7 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 	case IB_FLOW_SPEC_VXLAN_TUNNEL:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->tunnel.mask,
 					 LAST_TUNNEL_FIELD))
-			return -ENOTSUPP;
+			return -EOPNOTSUPP;
 
 		MLX5_SET(fte_match_set_misc, misc_params_c, vxlan_vni,
 			 ntohl(ib_spec->tunnel.mask.tunnel_id));
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] IB/mlx5: Enable flow steering for IPv6 traffic
Date: Fri, 17 Jun 2016 15:14:51 +0300
Message-ID: <1466165691-32538-3-git-send-email-leon@kernel.org>
References: <1466165691-32538-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466165691-32538-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable flow steering for IPv6 traffic by using an IPv6 spec.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c72797c..714e878 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1320,6 +1320,32 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 		       &ib_spec->ipv4.val.dst_ip,
 		       sizeof(ib_spec->ipv4.val.dst_ip));
 		break;
+	case IB_FLOW_SPEC_IPV6:
+		if (ib_spec->size != sizeof(ib_spec->ipv6))
+			return -EINVAL;
+
+		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
+			 ethertype, 0xffff);
+		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v,
+			 ethertype, ETH_P_IPV6);
+
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       &ib_spec->ipv6.mask.src_ip,
+		       sizeof(ib_spec->ipv6.mask.src_ip));
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_v,
+				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       &ib_spec->ipv6.val.src_ip,
+		       sizeof(ib_spec->ipv6.val.src_ip));
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       &ib_spec->ipv6.mask.dst_ip,
+		       sizeof(ib_spec->ipv6.mask.dst_ip));
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_v,
+				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       &ib_spec->ipv6.val.dst_ip,
+		       sizeof(ib_spec->ipv6.val.dst_ip));
+		break;
 	case IB_FLOW_SPEC_TCP:
 		if (ib_spec->size != sizeof(ib_spec->tcp_udp))
 			return -EINVAL;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 4/6] IB/mlx5: Support Vxlan tunneling specification
Date: Mon, 14 Nov 2016 19:04:50 +0200
Message-ID: <1479143092-11723-5-git-send-email-leonro@mellanox.com>
References: <1479143092-11723-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479143092-11723-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support to receive specific Vxlan packet in ConnectX-4.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2217477..a833f45 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1515,6 +1515,7 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 #define LAST_IPV4_FIELD tos
 #define LAST_IPV6_FIELD traffic_class
 #define LAST_TCP_UDP_FIELD src_port
+#define LAST_TUNNEL_FIELD tunnel_id

 /* Field is the last supported field */
 #define FIELDS_NOT_SUPPORTED(filter, field)\
@@ -1698,6 +1699,16 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 		MLX5_SET(fte_match_set_lyr_2_4, outer_headers_v, udp_dport,
 			 ntohs(ib_spec->tcp_udp.val.dst_port));
 		break;
+	case IB_FLOW_SPEC_VXLAN_TUNNEL:
+		if (FIELDS_NOT_SUPPORTED(ib_spec->tunnel.mask,
+					 LAST_TUNNEL_FIELD))
+			return -ENOTSUPP;
+
+		MLX5_SET(fte_match_set_misc, misc_params_c, vxlan_vni,
+			 ntohl(ib_spec->tunnel.mask.tunnel_id));
+		MLX5_SET(fte_match_set_misc, misc_params_v, vxlan_vni,
+			 ntohl(ib_spec->tunnel.val.tunnel_id));
+		break;
 	default:
 		return -EINVAL;
 	}
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

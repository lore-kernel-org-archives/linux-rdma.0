From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/6] IB/mlx5: Update tunnel offloads bits
Date: Thu, 19 Oct 2017 08:25:54 +0300
Message-ID: <20171019052556.8514-5-leon@kernel.org>
References: <20171019052556.8514-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019052556.8514-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch updates the mlx5_ifc with the following:
- Fix tunnel_stateless_gre typo.
- max_geneve_opt_len - Maximum geneve options length.
- tunnel_stateless_geneve_rx - If set, receive Stateless
  Offloads for Geneve tunneled (inner) packets are supported.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index d49928c314ed..d4c29c183d28 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -614,7 +614,9 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 	u8         swp[0x1];
 	u8         swp_csum[0x1];
 	u8         swp_lso[0x1];
-	u8         reserved_at_23[0x1d];
+	u8         reserved_at_23[0x1b];
+	u8         max_geneve_opt_len[0x1];
+	u8         tunnel_stateless_geneve_rx[0x1];
 
 	u8         reserved_at_40[0x10];
 	u8         lro_min_mss_size[0x10];
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

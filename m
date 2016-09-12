From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 7/7] IB/mlx5: Set source mac address in FTE
Date: Mon, 12 Sep 2016 19:16:24 +0300
Message-ID: <1473696984-6161-8-git-send-email-leon@kernel.org>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Set the source mac address in the FTE when L2 specification
is provided.

Fixes: 038d2ef87572 ('IB/mlx5: Add flow steering support')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0480b64..e19537c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1430,6 +1430,13 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 					     dmac_47_16),
 				ib_spec->eth.val.dst_mac);
 
+		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+					     smac_47_16),
+				ib_spec->eth.mask.src_mac);
+		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_v,
+					     smac_47_16),
+				ib_spec->eth.val.src_mac);
+
 		if (ib_spec->eth.mask.vlan_tag) {
 			MLX5_SET(fte_match_set_lyr_2_4, outer_headers_c,
 				 vlan_tag, 1);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

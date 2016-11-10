From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc V1 7/9] IB/mlx4: Fix port query for 56Gb Ethernet links
Date: Thu, 10 Nov 2016 11:30:59 +0200
Message-ID: <1478770261-5775-8-git-send-email-leon@kernel.org>
References: <1478770261-5775-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478770261-5775-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Report the correct speed in the port attributes when using a 56Gbps
ethernet link.  Without this change the field is incorrectly set to 10.

Fixes: a9c766bb75ee ('IB/mlx4: Fix info returned when querying IBoE ports')
Fixes: 2e96691c31ec ('IB: Use central enum for speed instead of hard-coded values')
Signed-off-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 05ab3cb..4054a1b 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -698,9 +698,11 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	if (err)
 		goto out;
 
-	props->active_width	=  (((u8 *)mailbox->buf)[5] == 0x40) ?
-						IB_WIDTH_4X : IB_WIDTH_1X;
-	props->active_speed	= IB_SPEED_QDR;
+	props->active_width	=  (((u8 *)mailbox->buf)[5] == 0x40) ||
+				   (((u8 *)mailbox->buf)[5] == 0x20 /*56Gb*/) ?
+					   IB_WIDTH_4X : IB_WIDTH_1X;
+	props->active_speed	=  (((u8 *)mailbox->buf)[5] == 0x20 /*56Gb*/) ?
+					   IB_SPEED_FDR : IB_SPEED_QDR;
 	props->port_cap_flags	= IB_PORT_CM_SUP | IB_PORT_IP_BASED_GIDS;
 	props->gid_tbl_len	= mdev->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= mdev->dev->caps.max_msg_sz;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

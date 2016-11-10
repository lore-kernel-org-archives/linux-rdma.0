From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc V1 6/9] IB/mlx4: Put non zero value in max_ah device attribute
Date: Thu, 10 Nov 2016 11:30:58 +0200
Message-ID: <1478770261-5775-7-git-send-email-leon@kernel.org>
References: <1478770261-5775-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478770261-5775-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Use INT_MAX since this is the max value the attribute can hold, though
hardware capability is unlimited.

Fixes: 225c7b1feef1 ('IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b597e82..05ab3cb 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -547,6 +547,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_map_per_fmr = dev->dev->caps.max_fmr_maps;
 	props->hca_core_clock = dev->dev->caps.hca_core_clock * 1000UL;
 	props->timestamp_mask = 0xFFFFFFFFFFFFULL;
+	props->max_ah = INT_MAX;
 
 	if (!mlx4_is_slave(dev->dev))
 		err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 04/12] IB/mlx5: Fix memory leak in query device
Date: Thu, 27 Oct 2016 16:36:39 +0300
Message-ID: <1477575407-20562-5-git-send-email-leon@kernel.org>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We need to free dev->port when we fail to enable RoCE or
initialize node data.

Fixes: 0837e86a7a34 ('IB/mlx5: Add per port counters')
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index df0df80..c6ea25d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3116,7 +3116,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	}
 	err = init_node_data(dev);
 	if (err)
-		goto err_dealloc;
+		goto err_free_port;
 
 	mutex_init(&dev->flow_db.lock);
 	mutex_init(&dev->cap_mask_mutex);
@@ -3126,7 +3126,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (ll == IB_LINK_LAYER_ETHERNET) {
 		err = mlx5_enable_roce(dev);
 		if (err)
-			goto err_dealloc;
+			goto err_free_port;
 	}
 
 	err = create_dev_resources(&dev->devr);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

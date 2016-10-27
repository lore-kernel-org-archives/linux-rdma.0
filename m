From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 08/12] IB/mlx5: Wait for all async command completions to complete
Date: Thu, 27 Oct 2016 16:36:43 +0300
Message-ID: <1477575407-20562-9-git-send-email-leon@kernel.org>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Wait before continuing unload till all pending mkey async creation requests
are done.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 4e90124..55e2fee 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -646,6 +646,33 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 	return 0;
 }
 
+static void wait_for_async_commands(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_cache_ent *ent;
+	int total = 0;
+	int i;
+	int j;
+
+	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+		ent = &cache->ent[i];
+		for (j = 0 ; j < 1000; j++) {
+			if (!ent->pending)
+				break;
+			msleep(50);
+		}
+	}
+	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+		ent = &cache->ent[i];
+		total += ent->pending;
+	}
+
+	if (total)
+		mlx5_ib_warn(dev, "aborted while there are %d pending mr requests\n", total);
+	else
+		mlx5_ib_warn(dev, "done with all pending requests\n");
+}
+
 int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 {
 	int i;
@@ -659,6 +686,7 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 		clean_keys(dev, i);
 
 	destroy_workqueue(dev->cache.wq);
+	wait_for_async_commands(dev);
 	del_timer_sync(&dev->delay_timer);
 
 	return 0;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

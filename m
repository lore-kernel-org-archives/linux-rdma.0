From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 1/4] IB/mlx5: Remove dead code in mr.c
Date: Thu, 24 Oct 2013 12:01:00 +0300
Message-ID: <1382605263-6822-2-git-send-email-eli@mellanox.com>
References: <1382605263-6822-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382605263-6822-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In mlx5_mr_cache_init() the size variable is not used so remove it to avoid
compiler warnings when running with make W=1.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index d7f2022..2c4626f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -40,7 +40,6 @@
 #include "mlx5_ib.h"
 
 enum {
-	DEF_CACHE_SIZE	= 10,
 	MAX_PENDING_REG_MR = 8,
 };
 
@@ -550,7 +549,6 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
 	int limit;
-	int size;
 	int err;
 	int i;
 
@@ -571,13 +569,11 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		ent->order = i + 2;
 		ent->dev = dev;
 
-		if (dev->mdev.profile->mask & MLX5_PROF_MASK_MR_CACHE) {
-			size = dev->mdev.profile->mr_cache[i].size;
+		if (dev->mdev.profile->mask & MLX5_PROF_MASK_MR_CACHE)
 			limit = dev->mdev.profile->mr_cache[i].limit;
-		} else {
-			size = DEF_CACHE_SIZE;
+		else
 			limit = 0;
-		}
+
 		INIT_WORK(&ent->work, cache_work_func);
 		INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
 		ent->limit = limit;
-- 
1.8.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

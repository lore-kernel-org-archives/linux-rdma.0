From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx5: Clean mr_cache debugfs in case of failure
Date: Tue, 30 May 2017 09:44:48 +0300
Message-ID: <20170530064448.4282-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The failure in creation of debugfs entries for mr_cache left entries,
which were already created.

It caused to mismatch and misguiding for the end users. The solution
is to clean mr_cache debugfs root, so no leftovers will be in the
system. In addition, let's document why the error is not needed to be
forwarded to user in case of failure.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 366433f71b58..cc311b287cf5 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -582,6 +582,15 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 	}
 }

+static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
+{
+	if (!mlx5_debugfs_root)
+		return;
+
+	debugfs_remove_recursive(dev->cache.root);
+	dev->cache.root = NULL;
+}
+
 static int mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
@@ -600,38 +609,34 @@ static int mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 		sprintf(ent->name, "%d", ent->order);
 		ent->dir = debugfs_create_dir(ent->name,  cache->root);
 		if (!ent->dir)
-			return -ENOMEM;
+			goto err;

 		ent->fsize = debugfs_create_file("size", 0600, ent->dir, ent,
 						 &size_fops);
 		if (!ent->fsize)
-			return -ENOMEM;
+			goto err;

 		ent->flimit = debugfs_create_file("limit", 0600, ent->dir, ent,
 						  &limit_fops);
 		if (!ent->flimit)
-			return -ENOMEM;
+			goto err;

 		ent->fcur = debugfs_create_u32("cur", 0400, ent->dir,
 					       &ent->cur);
 		if (!ent->fcur)
-			return -ENOMEM;
+			goto err;

 		ent->fmiss = debugfs_create_u32("miss", 0600, ent->dir,
 						&ent->miss);
 		if (!ent->fmiss)
-			return -ENOMEM;
+			goto err;
 	}

 	return 0;
-}
-
-static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
-{
-	if (!mlx5_debugfs_root)
-		return;
+err:
+	mlx5_mr_cache_debugfs_cleanup(dev);

-	debugfs_remove_recursive(dev->cache.root);
+	return -ENOMEM;
 }

 static void delay_time_func(unsigned long ctx)
@@ -692,6 +697,11 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 	if (err)
 		mlx5_ib_warn(dev, "cache debugfs failure\n");

+	/*
+	 * We don't want to fail driver if debugfs failed to initialize,
+	 * so we are not forwarding error to the user.
+	 */
+
 	return 0;
 }

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes-3.12 02/15] IB/mlx5: Flush cache workqueue before destroying it
Date: Wed, 11 Sep 2013 16:35:23 +0300
Message-ID: <1378906536-6925-3-git-send-email-ogerlitz@mellanox.com>
References: <1378906536-6925-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378906536-6925-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elic-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Destroying the workqueue without flushing it first can lead to a case in which
the kernel tries to push a delayed work to the workqueue which does not exist
anymore.

Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bd41df9..cfe0812 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -415,6 +415,7 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 	int size;
 	int err;
 
+	cancel_delayed_work(&ent->dwork);
 	while (1) {
 		spin_lock(&ent->lock);
 		if (list_empty(&ent->head)) {
@@ -540,13 +541,16 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 	int i;
 
 	dev->cache.stopped = 1;
-	destroy_workqueue(dev->cache.wq);
+	flush_workqueue(dev->cache.wq);
 
 	mlx5_mr_cache_debugfs_cleanup(dev);
 
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++)
 		clean_keys(dev, i);
 
+	flush_workqueue(dev->cache.wq);
+	destroy_workqueue(dev->cache.wq);
+
 	return 0;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

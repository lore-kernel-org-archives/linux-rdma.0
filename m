From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 07/12] IB/mlx5: Resolve soft lock on massive reg MRs
Date: Thu, 27 Oct 2016 16:36:42 +0300
Message-ID: <1477575407-20562-8-git-send-email-leon@kernel.org>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When calling reg_mr of large MRs (e.g. 4GB) from multiple processes
and MR caches can't supply the required amount of MRs the slow-path
of MR allocation may be used. In this case we need to serialize the
slow-path between the processes to avoid soft lock.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 ++
 drivers/infiniband/hw/mlx5/mr.c      | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index dcdcd19..7d68990 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -626,6 +626,8 @@ struct mlx5_ib_dev {
 	struct mlx5_ib_resources	devr;
 	struct mlx5_mr_cache		cache;
 	struct timer_list		delay_timer;
+	/* Prevents soft lock on massive reg MRs */
+	struct mutex			slow_path_mutex;
 	int				fill_delay;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct ib_odp_caps	odp_caps;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index d4ad672..4e90124 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -610,6 +610,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 	int err;
 	int i;
 
+	mutex_init(&dev->slow_path_mutex);
 	cache->wq = alloc_ordered_workqueue("mkey_cache", WQ_MEM_RECLAIM);
 	if (!cache->wq) {
 		mlx5_ib_warn(dev, "failed to create work queue\n");
@@ -1182,9 +1183,12 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto error;
 	}
 
-	if (!mr)
+	if (!mr) {
+		mutex_lock(&dev->slow_path_mutex);
 		mr = reg_create(NULL, pd, virt_addr, length, umem, ncont,
 				page_shift, access_flags);
+		mutex_unlock(&dev->slow_path_mutex);
+	}
 
 	if (IS_ERR(mr)) {
 		err = PTR_ERR(mr);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

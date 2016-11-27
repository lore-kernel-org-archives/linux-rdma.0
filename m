From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/4] IB/mlx5: Avoid system crash when enabling many VFs
Date: Sun, 27 Nov 2016 15:18:21 +0200
Message-ID: <1480252702-8005-4-git-send-email-leon@kernel.org>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480252702-8005-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When enabling many VFs, the total amount of DMA mappings increase
significantly. This causes DMA allocations to take a lot of time
since they are serialized in the kernel.

As a result the driver enters into fatal condition due to
timeout and the system hangs. To recover from this we disable
MR cache for VFs.

PFs will still have a full cache and VFs cache can be manipulated
as usual after driver load.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 4e90124..501af9e 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -628,7 +628,8 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		ent->order = i + 2;
 		ent->dev = dev;
 
-		if (dev->mdev->profile->mask & MLX5_PROF_MASK_MR_CACHE)
+		if ((dev->mdev->profile->mask & MLX5_PROF_MASK_MR_CACHE) &&
+		    (mlx5_core_is_pf(dev->mdev)))
 			limit = dev->mdev->profile->mr_cache[i].limit;
 		else
 			limit = 0;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

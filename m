From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc] IB/mlx5: Fix label order in error path handling
Date: Sun,  1 Oct 2017 09:54:35 +0300
Message-ID: <20171001065435.7733-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When UAR get_page fails, it needs to continue to cleanup debugfs for
congestion control parameters. Labels for error path were incorrectly
ordered.

This patch fixes to do correct cleanup on debugfs init failure and uar
get page failure.

Fixes: 4a2da0b8c078 ("IB/mlx5: Add debug control parameters for congestion control")
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d6fbad8f34aa..552f7bd4ecc3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4174,9 +4174,9 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 err_uar_page:
 	mlx5_put_uars_page(dev->mdev, dev->mdev->priv.uar);

-err_cnt:
-	mlx5_ib_cleanup_cong_debugfs(dev);
 err_cong:
+	mlx5_ib_cleanup_cong_debugfs(dev);
+err_cnt:
 	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt))
 		mlx5_ib_dealloc_counters(dev);

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/7] IB/mlx5: Verify that Q counters are supported
Date: Wed, 18 Jan 2017 14:10:32 +0200
Message-ID: <20170118121036.32642-4-leon@kernel.org>
References: <20170118121036.32642-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118121036.32642-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Make sure that the Q counters are supported by the FW before trying
to allocate/deallocte them, this will avoid driver load failure when
they aren't supported by the FW.

Fixes: 0837e86a7a34 ('IB/mlx5: Add per port counters')
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.7+
Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a191b93..0187f1d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3313,9 +3313,11 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_rsrc;

-	err = mlx5_ib_alloc_q_counters(dev);
-	if (err)
-		goto err_odp;
+	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt)) {
+		err = mlx5_ib_alloc_q_counters(dev);
+		if (err)
+			goto err_odp;
+	}

 	dev->mdev->priv.uar = mlx5_get_uars_page(dev->mdev);
 	if (!dev->mdev->priv.uar)
@@ -3364,7 +3366,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	mlx5_put_uars_page(dev->mdev, dev->mdev->priv.uar);

 err_q_cnt:
-	mlx5_ib_dealloc_q_counters(dev);
+	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt))
+		mlx5_ib_dealloc_q_counters(dev);

 err_odp:
 	mlx5_ib_odp_remove_one(dev);
@@ -3397,7 +3400,8 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
 	mlx5_free_bfreg(dev->mdev, &dev->bfreg);
 	mlx5_put_uars_page(dev->mdev, mdev->priv.uar);
-	mlx5_ib_dealloc_q_counters(dev);
+	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt))
+		mlx5_ib_dealloc_q_counters(dev);
 	destroy_umrc_res(dev);
 	mlx5_ib_odp_remove_one(dev);
 	destroy_dev_resources(&dev->devr);
--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 6/6] IB/mlx5: Move locks initialization to the corresponding stage
Date: Sun, 24 Dec 2017 14:40:15 +0200
Message-ID: <20171224124015.31917-7-leon@kernel.org>
References: <20171224124015.31917-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224124015.31917-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Unconditional locks/list initialization should be done in the INIT stage.
Remove those from the CAPS stage and move them to the proper stage.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d7ccf8d5b2d2..6775e440e23f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3988,6 +3988,11 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 		dev->mdev->priv.eq_table.num_comp_vectors;
 	dev->ib_dev.dev.parent		= &mdev->pdev->dev;
 
+	mutex_init(&dev->flow_db.lock);
+	mutex_init(&dev->cap_mask_mutex);
+	INIT_LIST_HEAD(&dev->qp_list);
+	spin_lock_init(&dev->reset_flow_resource_lock);
+
 	return 0;
 
 err_free_port:
@@ -4123,11 +4128,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	if (err)
 		return err;
 
-	mutex_init(&dev->flow_db.lock);
-	mutex_init(&dev->cap_mask_mutex);
-	INIT_LIST_HEAD(&dev->qp_list);
-	spin_lock_init(&dev->reset_flow_resource_lock);
-
 	if ((MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
 	    MLX5_CAP_GEN(dev->mdev, disable_local_lb))
 		mutex_init(&dev->lb_mutex);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

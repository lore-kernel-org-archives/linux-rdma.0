From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/6] IB/mlx5: Move loopback initialization to the corresponding stage
Date: Sun, 24 Dec 2017 14:40:14 +0200
Message-ID: <20171224124015.31917-6-leon@kernel.org>
References: <20171224124015.31917-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224124015.31917-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The loopback stage only initializes a lock, move it to be in
the CAPS initialization phase and get rid loopback step completely.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 16 ++++------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 -
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c68dd1041aaa..d7ccf8d5b2d2 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4128,6 +4128,10 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	INIT_LIST_HEAD(&dev->qp_list);
 	spin_lock_init(&dev->reset_flow_resource_lock);
 
+	if ((MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
+	    MLX5_CAP_GEN(dev->mdev, disable_local_lb))
+		mutex_init(&dev->lb_mutex);
+
 	return 0;
 }
 
@@ -4309,15 +4313,6 @@ static int mlx5_ib_stage_class_attr_init(struct mlx5_ib_dev *dev)
 	return 0;
 }
 
-static int mlx5_ib_stage_loopback_init(struct mlx5_ib_dev *dev)
-{
-	if ((MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
-	    MLX5_CAP_GEN(dev->mdev, disable_local_lb))
-		mutex_init(&dev->lb_mutex);
-
-	return 0;
-}
-
 static void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 			     struct mlx5_ib_profile *profile,
 			     int stage)
@@ -4406,9 +4401,6 @@ static struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_CLASS_ATTR,
 		     mlx5_ib_stage_class_attr_init,
 		     NULL),
-	STAGE_CREATE(MLX5_IB_STAGE_LOOPBACK,
-		     mlx5_ib_stage_loopback_init,
-		     NULL),
 };
 
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e0d9c03f4432..8f762ac4a659 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -719,7 +719,6 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_UMR_RESOURCES,
 	MLX5_IB_STAGE_DELAY_DROP,
 	MLX5_IB_STAGE_CLASS_ATTR,
-	MLX5_IB_STAGE_LOOPBACK,
 	MLX5_IB_STAGE_MAX,
 };
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

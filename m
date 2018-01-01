From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 5/6] IB/mlx5: Move loopback initialization to the corresponding stage
Date: Mon,  1 Jan 2018 13:07:02 +0200
Message-ID: <20180101110703.28759-6-leon@kernel.org>
References: <20180101110703.28759-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180101110703.28759-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
index 1a409e7ade80..b8952fff1fc8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4203,6 +4203,10 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	INIT_LIST_HEAD(&dev->qp_list);
 	spin_lock_init(&dev->reset_flow_resource_lock);
 
+	if ((MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
+	    MLX5_CAP_GEN(dev->mdev, disable_local_lb))
+		mutex_init(&dev->lb_mutex);
+
 	return 0;
 }
 
@@ -4384,15 +4388,6 @@ static int mlx5_ib_stage_class_attr_init(struct mlx5_ib_dev *dev)
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
 			     const struct mlx5_ib_profile *profile,
 			     int stage)
@@ -4481,9 +4476,6 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_CLASS_ATTR,
 		     mlx5_ib_stage_class_attr_init,
 		     NULL),
-	STAGE_CREATE(MLX5_IB_STAGE_LOOPBACK,
-		     mlx5_ib_stage_loopback_init,
-		     NULL),
 };
 
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 0504ab3b9a06..768fa7334100 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -729,7 +729,6 @@ enum mlx5_ib_stages {
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

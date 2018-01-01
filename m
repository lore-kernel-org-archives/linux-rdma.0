From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 3/6] IB/mlx5: Move ODP initialization to the corresponding stage
Date: Mon,  1 Jan 2018 13:07:00 +0200
Message-ID: <20180101110703.28759-4-leon@kernel.org>
References: <20180101110703.28759-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180101110703.28759-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Now that we have a stage just for ODP, move all relevant
initialization logic into one place.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9a5de242b74d..07331613f423 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4170,8 +4170,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 
 	dev->ib_dev.disassociate_ucontext = mlx5_ib_disassociate_ucontext;
 
-	mlx5_ib_internal_fill_odp_caps(dev);
-
 	dev->umr_fence = mlx5_get_umr_fence(MLX5_CAP_GEN(mdev, umr_fence));
 
 	if (MLX5_CAP_GEN(mdev, imaicl)) {
@@ -4272,6 +4270,8 @@ static void mlx5_ib_stage_dev_res_cleanup(struct mlx5_ib_dev *dev)
 
 static int mlx5_ib_stage_odp_init(struct mlx5_ib_dev *dev)
 {
+	mlx5_ib_internal_fill_odp_caps(dev);
+
 	return mlx5_ib_odp_init_one(dev);
 }
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

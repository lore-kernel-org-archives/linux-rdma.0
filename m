From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 4/6] IB/mlx5: Move hardware counters initialization to the corresponding stage
Date: Mon,  1 Jan 2018 13:07:01 +0200
Message-ID: <20180101110703.28759-5-leon@kernel.org>
References: <20180101110703.28759-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180101110703.28759-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Now that we have a stage just for hardware counters, move all relevant
initialization logic into one place.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 07331613f423..1a409e7ade80 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4180,11 +4180,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 			(1ull << IB_USER_VERBS_CMD_DEALLOC_MW);
 	}
 
-	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt)) {
-		dev->ib_dev.get_hw_stats	= mlx5_ib_get_hw_stats;
-		dev->ib_dev.alloc_hw_stats	= mlx5_ib_alloc_hw_stats;
-	}
-
 	if (MLX5_CAP_GEN(mdev, xrc)) {
 		dev->ib_dev.alloc_xrcd = mlx5_ib_alloc_xrcd;
 		dev->ib_dev.dealloc_xrcd = mlx5_ib_dealloc_xrcd;
@@ -4282,8 +4277,12 @@ static void mlx5_ib_stage_odp_cleanup(struct mlx5_ib_dev *dev)
 
 static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
 {
-	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt))
-		return  mlx5_ib_alloc_counters(dev);
+	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt)) {
+		dev->ib_dev.get_hw_stats	= mlx5_ib_get_hw_stats;
+		dev->ib_dev.alloc_hw_stats	= mlx5_ib_alloc_hw_stats;
+
+		return mlx5_ib_alloc_counters(dev);
+	}
 
 	return 0;
 }
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

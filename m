From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 01/15] net/mlx5: Fix race for multiple RoCE enable
Date: Thu,  4 Jan 2018 11:06:31 +0200
Message-ID: <20180104090645.4901-2-leon@kernel.org>
References: <20180104090645.4901-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104090645.4901-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There are two potential problems with the existing implementation.

1. Enable and disable can race after the atomic operations.
2. If a command fails the refcount is left in an inconsistent state.

Introduce a lock and perform error checking.

Fixes: a6f7d2aff623 ("net/mlx5: Add support for multiple RoCE enable")
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 33 ++++++++++++++++++++-----
 include/linux/mlx5/driver.h                     |  2 +-
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index d653b0025b13..916523103f16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -36,6 +36,9 @@
 #include <linux/mlx5/vport.h>
 #include "mlx5_core.h"
 
+/* Mutex to hold while enabling or disabling RoCE */
+static DEFINE_MUTEX(mlx5_roce_en_lock);
+
 static int _mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod,
 				   u16 vport, u32 *out, int outlen)
 {
@@ -988,17 +991,35 @@ static int mlx5_nic_vport_update_roce_state(struct mlx5_core_dev *mdev,
 
 int mlx5_nic_vport_enable_roce(struct mlx5_core_dev *mdev)
 {
-	if (atomic_inc_return(&mdev->roce.roce_en) != 1)
-		return 0;
-	return mlx5_nic_vport_update_roce_state(mdev, MLX5_VPORT_ROCE_ENABLED);
+	int err = 0;
+
+	mutex_lock(&mlx5_roce_en_lock);
+	if (!mdev->roce.roce_en)
+		err = mlx5_nic_vport_update_roce_state(mdev, MLX5_VPORT_ROCE_ENABLED);
+
+	if (!err)
+		mdev->roce.roce_en++;
+	mutex_unlock(&mlx5_roce_en_lock);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_nic_vport_enable_roce);
 
 int mlx5_nic_vport_disable_roce(struct mlx5_core_dev *mdev)
 {
-	if (atomic_dec_return(&mdev->roce.roce_en) != 0)
-		return 0;
-	return mlx5_nic_vport_update_roce_state(mdev, MLX5_VPORT_ROCE_DISABLED);
+	int err = 0;
+
+	mutex_lock(&mlx5_roce_en_lock);
+	if (mdev->roce.roce_en) {
+		mdev->roce.roce_en--;
+		if (mdev->roce.roce_en == 0)
+			err = mlx5_nic_vport_update_roce_state(mdev, MLX5_VPORT_ROCE_DISABLED);
+
+		if (err)
+			mdev->roce.roce_en++;
+	}
+	mutex_unlock(&mlx5_roce_en_lock);
+	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_nic_vport_disable_roce);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0776554f18dc..5b0443c9d337 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -835,7 +835,7 @@ struct mlx5_core_dev {
 	struct mlx5e_resources  mlx5e_res;
 	struct {
 		struct mlx5_rsvd_gids	reserved_gids;
-		atomic_t                roce_en;
+		u32			roce_en;
 	} roce;
 #ifdef CONFIG_MLX5_FPGA
 	struct mlx5_fpga_device *fpga;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

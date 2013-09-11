From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes-3.12 13/15] IB/mlx5: Fix eq names to display nicely in /proc/interrupts
Date: Wed, 11 Sep 2013 16:35:34 +0300
Message-ID: <1378906536-6925-14-git-send-email-ogerlitz@mellanox.com>
References: <1378906536-6925-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378906536-6925-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elic-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

It is normal for a device to display the pci slot name along with it's IRQs, so
the user which will check /proc/interrupts will see the pci slot of the device.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c            |    6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |    4 +++-
 include/linux/mlx5/driver.h                  |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b267c65..b1a6cb3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -164,6 +164,7 @@ int mlx5_vector2eqn(struct mlx5_ib_dev *dev, int vector, int *eqn, int *irqn)
 static int alloc_comp_eqs(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_eq_table *table = &dev->mdev.priv.eq_table;
+	char name[MLX5_MAX_EQ_NAME];
 	struct mlx5_eq *eq, *n;
 	int ncomp_vec;
 	int nent;
@@ -180,11 +181,10 @@ static int alloc_comp_eqs(struct mlx5_ib_dev *dev)
 			goto clean;
 		}
 
-		snprintf(eq->name, MLX5_MAX_EQ_NAME, "mlx5_comp%d", i);
+		snprintf(name, MLX5_MAX_EQ_NAME, "mlx5_comp%d", i);
 		err = mlx5_create_map_eq(&dev->mdev, eq,
 					 i + MLX5_EQ_VEC_COMP_BASE, nent, 0,
-					 eq->name,
-					 &dev->mdev.priv.uuari.uars[0]);
+					 name, &dev->mdev.priv.uuari.uars[0]);
 		if (err) {
 			kfree(eq);
 			goto clean;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index c02cbcf..f3a5862 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -366,9 +366,11 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 		goto err_in;
 	}
 
+	snprintf(eq->name, MLX5_MAX_EQ_NAME, "%s@pci:%s",
+		 name, pci_name(dev->pdev));
 	eq->eqn = out.eq_number;
 	err = request_irq(table->msix_arr[vecidx].vector, mlx5_msix_handler, 0,
-			  name, eq);
+			  eq->name, eq);
 	if (err)
 		goto err_eq;
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 171b599..f685663 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -82,7 +82,7 @@ enum {
 };
 
 enum {
-	MLX5_MAX_EQ_NAME	= 20
+	MLX5_MAX_EQ_NAME	= 32
 };
 
 enum {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

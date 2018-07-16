From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Mon, 16 Jul 2018 11:30:12 +0300
Message-ID: <20180716083012.15410-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The IRQ affinity mask is managed by mlx5_core, however any user
triggered updates through /proc/irq/<irq#>/smp_affinity were not
reflected in mlx5_ib_get_vector_affinity().

Drop the attempt to use cached version of affinity mask in favour of
managed by PCI core value.

Fixes: e3ca34880652 ("net/mlx5: Fix build break when CONFIG_SMP=n")
Reported-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 4 +++-
 include/linux/mlx5/driver.h       | 7 -------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d0834525afe3..1c3584024acb 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5304,8 +5304,10 @@ static const struct cpumask *
 mlx5_ib_get_vector_affinity(struct ib_device *ibdev, int comp_vector)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	int irq = pci_irq_vector(dev->mdev->pdev,
+				 MLX5_EQ_VEC_COMP_BASE + comp_vector);

-	return mlx5_get_vector_affinity_hint(dev->mdev, comp_vector);
+	return irq_get_affinity_mask(irq);
 }

 /* The mlx5_ib_multiport_mutex should be held when calling this function */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0b7daa4a8f84..d3581cd5d517 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1287,11 +1287,4 @@ static inline int mlx5_core_native_port_num(struct mlx5_core_dev *dev)
 enum {
 	MLX5_TRIGGERED_CMD_COMP = (u64)1 << 32,
 };
-
-static inline const struct cpumask *
-mlx5_get_vector_affinity_hint(struct mlx5_core_dev *dev, int vector)
-{
-	return dev->priv.irq_info[vector].mask;
-}
-
 #endif /* MLX5_DRIVER_H */

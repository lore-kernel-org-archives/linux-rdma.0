From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.14] IB/mlx4: Don't allocate range of steerable UD QPs for Ethernet-only device
Date: Sun,  2 Feb 2014 17:06:47 +0200
Message-ID: <1391353607-12484-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When the device has only Ethernet ports, don't try to allocate range of steerable
UD QPs since they aren't needed. This fixes an issue where mlx4 VFs tried to
allocate a range of UD steerable QPs, but failed to do so.

Fixes: c1c9850 ('IB/mlx4: Add support for steerable IB UD QPs')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 5d4088a..d7a0619 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1810,6 +1810,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	int i, j;
 	int err;
 	struct mlx4_ib_iboe *iboe;
+	int ib_num_ports = 0;
 
 	pr_info_once("%s", mlx4_ib_version);
 
@@ -1985,10 +1986,14 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 				ibdev->counters[i] = -1;
 	}
 
+	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
+		ib_num_ports++;
+
 	spin_lock_init(&ibdev->sm_lock);
 	mutex_init(&ibdev->cap_mask_mutex);
 
-	if (ibdev->steering_support == MLX4_STEERING_MODE_DEVICE_MANAGED) {
+	if (ibdev->steering_support == MLX4_STEERING_MODE_DEVICE_MANAGED &&
+	    ib_num_ports) {
 		ibdev->steer_qpn_count = MLX4_IB_UC_MAX_NUM_QPS;
 		err = mlx4_qp_reserve_range(dev, ibdev->steer_qpn_count,
 					    MLX4_IB_UC_STEER_QPN_ALIGN,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

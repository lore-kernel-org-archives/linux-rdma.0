From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/6] IB/mlx4_ib: Enable device managed steering support for IB ports too
Date: Thu,  7 Nov 2013 15:25:15 +0200
Message-ID: <1383830717-17312-5-git-send-email-ogerlitz@mellanox.com>
References: <1383830717-17312-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383830717-17312-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Up until now, flow steering wasn't supported when using IB ports.

This patch enables the support for flow steering if all hardware ports
support that, e.g under the new MLX4_DEV_CAP_FLAG2_DMFS_IPOIB mlx4 device
capability.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |   31 +++++++++++++++++++------------
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    1 +
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f061264..093fc85 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -92,21 +92,27 @@ static union ib_gid zgid;
 
 static int check_flow_steering_support(struct mlx4_dev *dev)
 {
+	int eth_num_ports = 0;
 	int ib_num_ports = 0;
-	int i;
-
-	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
-		ib_num_ports++;
 
-	if (dev->caps.steering_mode == MLX4_STEERING_MODE_DEVICE_MANAGED) {
-		if (ib_num_ports || mlx4_is_mfunc(dev)) {
-			pr_warn("Device managed flow steering is unavailable "
-				"for IB ports or in multifunction env.\n");
-			return 0;
+	int dmfs = dev->caps.steering_mode == MLX4_STEERING_MODE_DEVICE_MANAGED;
+
+	if (dmfs) {
+		int i;
+		mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_ETH)
+			eth_num_ports++;
+		mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
+			ib_num_ports++;
+		dmfs &= (!ib_num_ports ||
+			 (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_DMFS_IPOIB)) &&
+			(!eth_num_ports ||
+			 (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_FS_EN));
+		if (ib_num_ports && mlx4_is_mfunc(dev)) {
+			pr_warn("Device managed flow steering is unavailable for IB port in multifunction env.\n");
+			dmfs = 0;
 		}
-		return 1;
 	}
-	return 0;
+	return dmfs;
 }
 
 static int mlx4_ib_query_device(struct ib_device *ibdev,
@@ -165,7 +171,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2B;
 		else
 			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2A;
-	if (check_flow_steering_support(dev->dev))
+	if (dev->steering_support ==  MLX4_STEERING_MODE_DEVICE_MANAGED)
 		props->device_cap_flags |= IB_DEVICE_MANAGED_FLOW_STEERING;
 	}
 
@@ -1688,6 +1694,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	}
 
 	if (check_flow_steering_support(dev)) {
+		ibdev->steering_support = MLX4_STEERING_MODE_DEVICE_MANAGED;
 		ibdev->ib_dev.create_flow	= mlx4_ib_create_flow;
 		ibdev->ib_dev.destroy_flow	= mlx4_ib_destroy_flow;
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 036b663..e9fb396 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -494,6 +494,7 @@ struct mlx4_ib_dev {
 	struct kobject	       *dev_ports_parent[MLX4_MFUNC_MAX];
 	struct mlx4_ib_iov_port	iov_ports[MLX4_MAX_PORTS];
 	struct pkey_mgt		pkeys;
+	int steering_support;
 };
 
 struct ib_event_work {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

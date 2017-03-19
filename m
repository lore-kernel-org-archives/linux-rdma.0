From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx4: Support RAW Ethernet when RoCE is disabled
Date: Sun, 19 Mar 2017 11:01:28 +0200
Message-ID: <20170319090128.7593-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On some environments, such as certain SR-IOV VF configurations, RoCE
isn't supported for mlx4 Ethernet ports. Currently the driver will
not open IB device on that port.

This is problematic since we do want user-space RAW Ethernet QPs functionality
to remain in place. For that end, enhance the relevant driver flows such that we
do create a device instance in that case.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 26 +++++++++++---------------
 include/linux/mlx4/device.h       |  3 +--
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index fba94df28cf1..2cc6f21baea1 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2867,23 +2867,19 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_ib_init_sriov(ibdev))
 		goto err_mad;

-	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE ||
-	    dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
-		if (!iboe->nb.notifier_call) {
-			iboe->nb.notifier_call = mlx4_ib_netdev_event;
-			err = register_netdevice_notifier(&iboe->nb);
-			if (err) {
-				iboe->nb.notifier_call = NULL;
-				goto err_notif;
-			}
-		}
-		if (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
-			err = mlx4_config_roce_v2_port(dev, ROCE_V2_UDP_DPORT);
-			if (err) {
-				goto err_notif;
-			}
+	if (!iboe->nb.notifier_call) {
+		iboe->nb.notifier_call = mlx4_ib_netdev_event;
+		err = register_netdevice_notifier(&iboe->nb);
+		if (err) {
+			iboe->nb.notifier_call = NULL;
+			goto err_notif;
 		}
 	}
+	if (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
+		err = mlx4_config_roce_v2_port(dev, ROCE_V2_UDP_DPORT);
+		if (err)
+			goto err_notif;
+	}

 	for (j = 0; j < ARRAY_SIZE(mlx4_class_attributes); ++j) {
 		if (device_create_file(&ibdev->ib_dev.dev,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 7e66e4f62858..48f82fd1897d 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1010,8 +1010,7 @@ struct mlx4_mad_ifc {
 #define mlx4_foreach_ib_transport_port(port, dev)                         \
 	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)       \
 		if (((dev)->caps.port_mask[port] == MLX4_PORT_TYPE_IB) || \
-			((dev)->caps.flags & MLX4_DEV_CAP_FLAG_IBOE) || \
-			((dev)->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2))
+		    ((dev)->caps.port_mask[port] == MLX4_PORT_TYPE_ETH))

 #define MLX4_INVALID_SLAVE_ID	0xFF
 #define MLX4_SINK_COUNTER_INDEX(dev)	(dev->caps.max_counters - 1)
--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

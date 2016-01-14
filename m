From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 09/12] IB/mlx4: Enable RoCE v2 when the IB device is added
Date: Thu, 14 Jan 2016 17:50:40 +0200
Message-ID: <5dfd809d81491fa38df962e0d35df78be2877a6c.1452780850.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the hardware supports RoCE v2, we configure the hardware UDP
port according to the RoCE v2 Annex when mlx4_ib device is added.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 2a1ee80..63f049f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2493,7 +2493,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_ib_init_sriov(ibdev))
 		goto err_mad;
 
-	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE) {
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE ||
+	    dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
 		if (!iboe->nb.notifier_call) {
 			iboe->nb.notifier_call = mlx4_ib_netdev_event;
 			err = register_netdevice_notifier(&iboe->nb);
@@ -2502,6 +2503,12 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 				goto err_notif;
 			}
 		}
+		if (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
+			err = mlx4_config_roce_v2_port(dev, ROCE_V2_UDP_DPORT);
+			if (err) {
+				goto err_notif;
+			}
+		}
 	}
 
 	for (j = 0; j < ARRAY_SIZE(mlx4_class_attributes); ++j) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

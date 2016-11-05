From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc 8/9] IB/mlx4: Add precondition for flow_steering_ib_uc_qp_range command
Date: Sat,  5 Nov 2016 21:57:21 +0200
Message-ID: <1478375842-21513-9-git-send-email-leonro@mellanox.com>
References: <1478375842-21513-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478375842-21513-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

FLOW_STEERING_IB_UC_QP_RANGE command is supported only if dmfs_ipoib bit is set.

If it isn't set we want to ensure allocating NET_IF QPs fail. We do so
by filling out the allocation bitmap. By thus, the NET_IF QPs allocating
function won't find any free QP and will fail.

Fixes: c1c98501121e ('IB/mlx4: Add support for steerable IB UD QPs')
Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 4054a1b..4a67ffc 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2823,14 +2823,19 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			goto err_steer_qp_release;
 		}
 
-		bitmap_zero(ibdev->ib_uc_qpns_bitmap, ibdev->steer_qpn_count);
-
-		err = mlx4_FLOW_STEERING_IB_UC_QP_RANGE(
-				dev, ibdev->steer_qpn_base,
-				ibdev->steer_qpn_base +
-				ibdev->steer_qpn_count - 1);
-		if (err)
-			goto err_steer_free_bitmap;
+		if (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_DMFS_IPOIB) {
+			bitmap_zero(ibdev->ib_uc_qpns_bitmap,
+				    ibdev->steer_qpn_count);
+			err = mlx4_FLOW_STEERING_IB_UC_QP_RANGE(
+					dev, ibdev->steer_qpn_base,
+					ibdev->steer_qpn_base +
+					ibdev->steer_qpn_count - 1);
+			if (err)
+				goto err_steer_free_bitmap;
+		} else {
+			bitmap_fill(ibdev->ib_uc_qpns_bitmap,
+				    ibdev->steer_qpn_count);
+		}
 	}
 
 	for (j = 1; j <= ibdev->dev->caps.num_ports; j++)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

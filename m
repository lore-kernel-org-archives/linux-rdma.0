From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 6/7] IB/mlx5: Enable MAD_IFC commands for IB ports only
Date: Mon, 12 Sep 2016 19:16:23 +0300
Message-ID: <1473696984-6161-7-git-send-email-leon@kernel.org>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

MAD_IFC command is supported only for physical functions (PF)
and when physical port is IB. The proposed fix enforces it.

Fixes: d603c809ef91 ("IB/mlx5: Fix decision on using MAD_IFC")
Reported-by: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8150ea3..0480b64 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -288,7 +288,9 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,

 static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
 {
-	return !MLX5_CAP_GEN(dev->mdev, ib_virt);
+	if (MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_IB)
+		return !MLX5_CAP_GEN(dev->mdev, ib_virt);
+	return 0;
 }

 enum {
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

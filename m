From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for 3.16] IB/mlx5: Enable block multicast loopback for kernel consumers too
Date: Wed, 25 Jun 2014 16:44:14 +0300
Message-ID: <1403703854-14328-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Under commit f360d88 we advertize blocking multicast loopback to both
kernel and user-space consumers, but disallow the kernel ones (e.g IPoIB)
to use it with their UD QPs, fix that.

Fixes: f360d88 ('IB/mlx5: Add block multicast loopback support')
Reported-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d13ddf1..bbbcf38 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -675,7 +675,7 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 	int err;
 
 	uuari = &dev->mdev.priv.uuari;
-	if (init_attr->create_flags & ~IB_QP_CREATE_SIGNATURE_EN)
+	if (init_attr->create_flags & ~(IB_QP_CREATE_SIGNATURE_EN | IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK))
 		return -EINVAL;
 
 	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

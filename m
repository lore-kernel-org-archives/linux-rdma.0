From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1] IB/mlx5: Fix blue flame buffer size calculation
Date: Thu,  9 Feb 2017 19:31:47 +0200
Message-ID: <20170209173147.20528-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A blue flame register is comprised of two buffers of equal size.

Fixes: 5fe9dec0d0454 ("IB/mlx5: Use blue flame register allocator in mlx5_ib")
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Chanelog v0->v1:
 * Add brackets to ensure proper calculation order.
---
 drivers/infiniband/hw/mlx5/qp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e22d9572ae8f..04e9dbd97a3c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -905,7 +905,10 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 	else
 		qp->bf.bfreg = &dev->bfreg;

-	qp->bf.buf_size = 1 << MLX5_CAP_GEN(dev->mdev, log_bf_reg_size);
+	/* We need to divide by two since each register is comprised of
+	 * two buffers of identical size, namely odd and even
+	 */
+	qp->bf.buf_size = (1 << MLX5_CAP_GEN(dev->mdev, log_bf_reg_size)) / 2;
 	uar_index = qp->bf.bfreg->index;

 	err = calc_sq_size(dev, init_attr, qp);
--
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

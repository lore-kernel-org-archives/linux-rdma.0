From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/mlx4: Enable blocking multicast loopback for user-space consumers
Date: Sun, 14 Sep 2014 16:20:02 +0300
Message-ID: <1410700802-27848-3-git-send-email-ogerlitz@mellanox.com>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410700802-27848-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow user-space UD QPs to require blocking multicast loopback.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 577b477..5e4785f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -706,6 +706,9 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	if (err)
 		goto err;
 
+	if (init_attr->create_flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
+			qp->flags |= MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK;
+
 	if (pd->uobject) {
 		struct mlx4_ib_create_qp ucmd;
 
@@ -745,9 +748,6 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	} else {
 		qp->sq_no_prefetch = 0;
 
-		if (init_attr->create_flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
-			qp->flags |= MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK;
-
 		if (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO)
 			qp->flags |= MLX4_IB_QP_LSO;
 
@@ -1077,9 +1077,12 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 			return ERR_PTR(-EINVAL);
 	}
 
+	if (udata &&
+	    init_attr->create_flags & ~(MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK))
+		return ERR_PTR(-EINVAL);
+
 	if (init_attr->create_flags &&
-	    (udata ||
-	     ((init_attr->create_flags & ~(MLX4_IB_SRIOV_SQP | MLX4_IB_QP_CREATE_USE_GFP_NOIO)) &&
+	    (((init_attr->create_flags & ~(MLX4_IB_SRIOV_SQP | MLX4_IB_QP_CREATE_USE_GFP_NOIO)) &&
 	      init_attr->qp_type != IB_QPT_UD) ||
 	     ((init_attr->create_flags & MLX4_IB_SRIOV_SQP) &&
 	      init_attr->qp_type > IB_QPT_GSI)))
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

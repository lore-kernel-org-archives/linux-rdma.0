From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 7/7] IB/mlx4: Add support for blocking multicast loopback QP creation user flag
Date: Sun, 16 Aug 2015 19:05:33 +0300
Message-ID: <1439741133-30145-8-git-send-email-eranbe@mellanox.com>
References: <1439741133-30145-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439741133-30145-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK is now supported downstream.

In addition, this flag was supported only for IB_QPT_UD, now, with the
new implementation it is supported for all QP types.

Support IB_USER_VERBS_EX_CMD_CREATE_QP in order to get the flag from
user space using the extension create qp command.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |  3 ++-
 drivers/infiniband/hw/mlx4/qp.c   | 13 ++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index d0d5b55..4c56659 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2175,7 +2175,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 
 	ibdev->ib_dev.uverbs_ex_cmd_mask |=
 		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE) |
-		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ);
+		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ) |
+		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP);
 
 	mlx4_ib_alloc_eqs(dev, ibdev);
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 2871949..ba25a1b 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -758,9 +758,6 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	} else {
 		qp->sq_no_prefetch = 0;
 
-		if (init_attr->create_flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
-			qp->flags |= MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK;
-
 		if (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO)
 			qp->flags |= MLX4_IB_QP_LSO;
 
@@ -834,6 +831,9 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err_proxy;
 	}
 
+	if (init_attr->create_flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
+		qp->flags |= MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK;
+
 	err = mlx4_qp_alloc(dev->dev, qpn, &qp->mqp, gfp);
 	if (err)
 		goto err_qpn;
@@ -1098,6 +1098,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 {
 	struct mlx4_ib_qp *qp = NULL;
 	int err;
+	int sup_u_create_flags = MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK;
 	u16 xrcdn = 0;
 	gfp_t gfp;
 
@@ -1121,8 +1122,10 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	}
 
 	if (init_attr->create_flags &&
-	    (udata ||
-	     ((init_attr->create_flags & ~(MLX4_IB_SRIOV_SQP | MLX4_IB_QP_CREATE_USE_GFP_NOIO)) &&
+	    ((udata && init_attr->create_flags & ~(sup_u_create_flags)) ||
+	     ((init_attr->create_flags & ~(MLX4_IB_SRIOV_SQP |
+					   MLX4_IB_QP_CREATE_USE_GFP_NOIO |
+					   MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK)) &&
 	      init_attr->qp_type != IB_QPT_UD) ||
 	     ((init_attr->create_flags & MLX4_IB_SRIOV_SQP) &&
 	      init_attr->qp_type > IB_QPT_GSI)))
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

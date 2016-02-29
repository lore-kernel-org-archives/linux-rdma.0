From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 02/10] IB/mlx5: Modify QP debugging prints
Date: Mon, 29 Feb 2016 15:45:04 +0200
Message-ID: <1456753512-17688-3-git-send-email-haggaie@mellanox.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add debugging prints to the modify QP verb to help understand the cause a
returned error.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7cf789d1aa29..784ddf77fca2 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2173,8 +2173,10 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 
 	context = &in->ctx;
 	err = to_mlx5_st(ibqp->qp_type);
-	if (err < 0)
+	if (err < 0) {
+		mlx5_ib_dbg(dev, "unsupported qp type %d\n", ibqp->qp_type);
 		goto out;
+	}
 
 	context->flags = cpu_to_be32(err << 16);
 
@@ -2394,30 +2396,45 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	if (ibqp->qp_type != MLX5_IB_QPT_REG_UMR &&
 	    !ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask,
-				ll))
+				ll)) {
+		mlx5_ib_dbg(dev, "invalid QP state transition from %d to %d, qp_type %d, attr_mask 0x%x\n",
+			    cur_state, new_state, ibqp->qp_type, attr_mask);
 		goto out;
+	}
 
 	if ((attr_mask & IB_QP_PORT) &&
 	    (attr->port_num == 0 ||
-	     attr->port_num > MLX5_CAP_GEN(dev->mdev, num_ports)))
+	     attr->port_num > MLX5_CAP_GEN(dev->mdev, num_ports))) {
+		mlx5_ib_dbg(dev, "invalid port number %d. number of ports is %d\n",
+			    attr->port_num, dev->num_ports);
 		goto out;
+	}
 
 	if (attr_mask & IB_QP_PKEY_INDEX) {
 		port = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
 		if (attr->pkey_index >=
-		    dev->mdev->port_caps[port - 1].pkey_table_len)
+		    dev->mdev->port_caps[port - 1].pkey_table_len) {
+			mlx5_ib_dbg(dev, "invalid pkey index %d\n",
+				    attr->pkey_index);
 			goto out;
+		}
 	}
 
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
 	    attr->max_rd_atomic >
-	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_res_qp)))
+	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_res_qp))) {
+		mlx5_ib_dbg(dev, "invalid max_rd_atomic value %d\n",
+			    attr->max_rd_atomic);
 		goto out;
+	}
 
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
 	    attr->max_dest_rd_atomic >
-	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_req_qp)))
+	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_req_qp))) {
+		mlx5_ib_dbg(dev, "invalid max_dest_rd_atomic value %d\n",
+			    attr->max_dest_rd_atomic);
 		goto out;
+	}
 
 	if (cur_state == new_state && cur_state == IB_QPS_RESET) {
 		err = 0;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

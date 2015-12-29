From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/7] IB/mlx4: Create and use another QP1 for RoCEv2
Date: Tue, 29 Dec 2015 15:24:06 +0200
Message-ID: <1451395447-5198-7-git-send-email-matanb@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The mlx4 driver uses a special QP to implement the GSI QP. This kind
of QP allows to build the InfiniBand headers in SW to be put before
the payload that comes in with the WR. The mlx4 HW builds the packet,
calculates the ICRC and puts it at the end of the payload. This ICRC
calculation however depends on the QP configuration which is
determined when QP is modified (roce_mode during INIT->RTR).
On the other hand, ICRC verification when packet is received does to
depend on this configuration.
Therefore, using 2 GSI QPs for send (one for each RoCE version) and 1
GSI QP for receive are required.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   7 ++
 drivers/infiniband/hw/mlx4/qp.c      | 162 ++++++++++++++++++++++++++++++-----
 2 files changed, 149 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 7179fb1..52ce7b0 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -177,11 +177,18 @@ struct mlx4_ib_wq {
 	unsigned		tail;
 };
 
+enum {
+	MLX4_IB_QP_CREATE_ROCE_V2_GSI = IB_QP_CREATE_RESERVED_START
+};
+
 enum mlx4_ib_qp_flags {
 	MLX4_IB_QP_LSO = IB_QP_CREATE_IPOIB_UD_LSO,
 	MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK = IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK,
 	MLX4_IB_QP_NETIF = IB_QP_CREATE_NETIF_QP,
 	MLX4_IB_QP_CREATE_USE_GFP_NOIO = IB_QP_CREATE_USE_GFP_NOIO,
+
+	/* Mellanox specific flags start from IB_QP_CREATE_RESERVED_START */
+	MLX4_IB_ROCE_V2_GSI_QP = MLX4_IB_QP_CREATE_ROCE_V2_GSI,
 	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
 	MLX4_IB_SRIOV_SQP = 1 << 31,
 };
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 8485602..a154d51 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -87,6 +87,7 @@ struct mlx4_ib_sqp {
 	u32			send_psn;
 	struct ib_ud_header	ud_header;
 	u8			header_buf[MLX4_IB_UD_HEADER_SIZE];
+	struct ib_qp		*roce_v2_gsi;
 };
 
 enum {
@@ -155,7 +156,10 @@ static int is_sqp(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
 			}
 		}
 	}
-	return proxy_sqp;
+	if (proxy_sqp)
+		return 1;
+
+	return !!(qp->flags & MLX4_IB_ROCE_V2_GSI_QP);
 }
 
 /* used for INIT/CLOSE port logic */
@@ -695,6 +699,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			qp = &sqp->qp;
 			qp->pri.vid = 0xFFFF;
 			qp->alt.vid = 0xFFFF;
+			sqp->roce_v2_gsi = NULL;
 		} else {
 			qp = kzalloc(sizeof (struct mlx4_ib_qp), gfp);
 			if (!qp)
@@ -1085,9 +1090,17 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 	del_gid_entries(qp);
 }
 
-static u32 get_sqp_num(struct mlx4_ib_dev *dev, struct ib_qp_init_attr *attr)
+static int get_sqp_num(struct mlx4_ib_dev *dev, struct ib_qp_init_attr *attr)
 {
 	/* Native or PPF */
+	if ((!mlx4_is_mfunc(dev->dev) || mlx4_is_master(dev->dev)) &&
+	    attr->create_flags & MLX4_IB_QP_CREATE_ROCE_V2_GSI) {
+		int sqpn;
+		int res = mlx4_qp_reserve_range(dev->dev, 1, 1, &sqpn, 0);
+
+		return res ? -abs(res) : sqpn;
+	}
+
 	if (!mlx4_is_mfunc(dev->dev) ||
 	    (mlx4_is_master(dev->dev) &&
 	     attr->create_flags & MLX4_IB_SRIOV_SQP)) {
@@ -1102,9 +1115,9 @@ static u32 get_sqp_num(struct mlx4_ib_dev *dev, struct ib_qp_init_attr *attr)
 		return dev->dev->caps.qp1_proxy[attr->port_num - 1];
 }
 
-struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
-				struct ib_qp_init_attr *init_attr,
-				struct ib_udata *udata)
+static struct ib_qp *_mlx4_ib_create_qp(struct ib_pd *pd,
+					struct ib_qp_init_attr *init_attr,
+					struct ib_udata *udata)
 {
 	struct mlx4_ib_qp *qp = NULL;
 	int err;
@@ -1123,6 +1136,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 					MLX4_IB_SRIOV_TUNNEL_QP |
 					MLX4_IB_SRIOV_SQP |
 					MLX4_IB_QP_NETIF |
+					MLX4_IB_QP_CREATE_ROCE_V2_GSI |
 					MLX4_IB_QP_CREATE_USE_GFP_NOIO))
 		return ERR_PTR(-EINVAL);
 
@@ -1131,15 +1145,21 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 			return ERR_PTR(-EINVAL);
 	}
 
-	if (init_attr->create_flags &&
-	    ((udata && init_attr->create_flags & ~(sup_u_create_flags)) ||
-	     ((init_attr->create_flags & ~(MLX4_IB_SRIOV_SQP |
-					   MLX4_IB_QP_CREATE_USE_GFP_NOIO |
-					   MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK)) &&
-	      init_attr->qp_type != IB_QPT_UD) ||
-	     ((init_attr->create_flags & MLX4_IB_SRIOV_SQP) &&
-	      init_attr->qp_type > IB_QPT_GSI)))
-		return ERR_PTR(-EINVAL);
+	if (init_attr->create_flags) {
+		/* userspace is not allowed to set create flags */
+		if (udata && init_attr->create_flags & ~(sup_u_create_flags))
+			return ERR_PTR(-EINVAL);
+
+		if ((init_attr->create_flags & ~(MLX4_IB_SRIOV_SQP |
+						 MLX4_IB_QP_CREATE_USE_GFP_NOIO |
+						 MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK) &&
+		     init_attr->qp_type != IB_QPT_UD) &&
+		    (init_attr->create_flags & MLX4_IB_SRIOV_SQP &&
+		     init_attr->qp_type > IB_QPT_GSI) &&
+		    (init_attr->create_flags & MLX4_IB_QP_CREATE_ROCE_V2_GSI &&
+		     init_attr->qp_type != IB_QPT_GSI))
+			return ERR_PTR(-EINVAL);
+	}
 
 	switch (init_attr->qp_type) {
 	case IB_QPT_XRC_TGT:
@@ -1176,19 +1196,25 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:
 	{
+		int sqpn;
+
 		/* Userspace is not allowed to create special QPs: */
 		if (udata)
 			return ERR_PTR(-EINVAL);
+		sqpn = get_sqp_num(to_mdev(pd->device), init_attr);
+
+		if (sqpn < 0)
+			return ERR_PTR(sqpn);
 
 		err = create_qp_common(to_mdev(pd->device), pd, init_attr, udata,
-				       get_sqp_num(to_mdev(pd->device), init_attr),
+				       sqpn,
 				       &qp, gfp);
 		if (err)
 			return ERR_PTR(err);
 
 		qp->port	= init_attr->port_num;
-		qp->ibqp.qp_num = init_attr->qp_type == IB_QPT_SMI ? 0 : 1;
-
+		qp->ibqp.qp_num = init_attr->qp_type == IB_QPT_SMI ? 0 :
+			init_attr->create_flags & MLX4_IB_QP_CREATE_ROCE_V2_GSI ? sqpn : 1;
 		break;
 	}
 	default:
@@ -1199,7 +1225,41 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	return &qp->ibqp;
 }
 
-int mlx4_ib_destroy_qp(struct ib_qp *qp)
+struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
+				struct ib_qp_init_attr *init_attr,
+				struct ib_udata *udata) {
+	struct ib_device *device = pd ? pd->device : init_attr->xrcd->device;
+	struct ib_qp *ibqp;
+	struct mlx4_ib_dev *dev = to_mdev(device);
+
+	ibqp = _mlx4_ib_create_qp(pd, init_attr, udata);
+
+	if (!IS_ERR_OR_NULL(ibqp) &&
+	    (init_attr->qp_type == IB_QPT_GSI) &&
+	    !(init_attr->create_flags & MLX4_IB_QP_CREATE_ROCE_V2_GSI)) {
+		struct mlx4_ib_sqp *sqp = to_msqp((to_mqp(ibqp)));
+		int is_eth = rdma_cap_eth_ah(&dev->ib_dev, init_attr->port_num);
+
+		if (is_eth &&
+		    dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
+			init_attr->create_flags |= MLX4_IB_QP_CREATE_ROCE_V2_GSI;
+			sqp->roce_v2_gsi = ib_create_qp(pd, init_attr);
+
+			if (IS_ERR_OR_NULL(sqp->roce_v2_gsi)) {
+				pr_err("Failed to create GSI QP for RoCEv2 (%ld)\n", PTR_ERR(sqp->roce_v2_gsi));
+				sqp->roce_v2_gsi = NULL;
+			} else {
+				sqp = to_msqp(to_mqp(sqp->roce_v2_gsi));
+				sqp->qp.flags |= MLX4_IB_ROCE_V2_GSI_QP;
+			}
+
+			init_attr->create_flags &= ~MLX4_IB_QP_CREATE_ROCE_V2_GSI;
+		}
+	}
+	return ibqp;
+}
+
+static int _mlx4_ib_destroy_qp(struct ib_qp *qp)
 {
 	struct mlx4_ib_dev *dev = to_mdev(qp->device);
 	struct mlx4_ib_qp *mqp = to_mqp(qp);
@@ -1228,6 +1288,20 @@ int mlx4_ib_destroy_qp(struct ib_qp *qp)
 	return 0;
 }
 
+int mlx4_ib_destroy_qp(struct ib_qp *qp)
+{
+	struct mlx4_ib_qp *mqp = to_mqp(qp);
+
+	if (mqp->mlx4_ib_qp_type == MLX4_IB_QPT_GSI) {
+		struct mlx4_ib_sqp *sqp = to_msqp(mqp);
+
+		if (sqp->roce_v2_gsi)
+			ib_destroy_qp(sqp->roce_v2_gsi);
+	}
+
+	return _mlx4_ib_destroy_qp(qp);
+}
+
 static int to_mlx4_st(struct mlx4_ib_dev *dev, enum mlx4_ib_qp_type type)
 {
 	switch (type) {
@@ -1654,6 +1728,14 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			mlx4_ib_steer_qp_reg(dev, qp, 1);
 			steer_qp = 1;
 		}
+
+		if (ibqp->qp_type == IB_QPT_GSI) {
+			enum ib_gid_type gid_type = qp->flags & MLX4_IB_ROCE_V2_GSI_QP ?
+				IB_GID_TYPE_ROCE_UDP_ENCAP : IB_GID_TYPE_ROCE;
+			u8 qpc_roce_mode = gid_type_to_qpc(gid_type);
+
+			context->rlkey_roce_mode |= (qpc_roce_mode << 6);
+		}
 	}
 
 	if (attr_mask & IB_QP_PKEY_INDEX) {
@@ -2054,8 +2136,8 @@ out:
 	return err;
 }
 
-int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		      int attr_mask, struct ib_udata *udata)
+static int _mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			      int attr_mask, struct ib_udata *udata)
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibqp->device);
 	struct mlx4_ib_qp *qp = to_mqp(ibqp);
@@ -2158,6 +2240,26 @@ out:
 	return err;
 }
 
+int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		      int attr_mask, struct ib_udata *udata)
+{
+	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
+	int ret;
+
+	ret = _mlx4_ib_modify_qp(ibqp, attr, attr_mask, udata);
+
+	if (mqp->mlx4_ib_qp_type == MLX4_IB_QPT_GSI) {
+		struct mlx4_ib_sqp *sqp = to_msqp(mqp);
+
+		if (sqp->roce_v2_gsi)
+			ret = ib_modify_qp(sqp->roce_v2_gsi, attr, attr_mask);
+		if (ret)
+			pr_err("Failed to modify GSI QP for RoCEv2 (%d)\n",
+			       ret);
+	}
+	return ret;
+}
+
 static int vf_get_qp0_qkey(struct mlx4_dev *dev, int qpn, u32 *qkey)
 {
 	int i;
@@ -2802,6 +2904,26 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	int i;
 	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
 
+	if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_GSI) {
+		struct mlx4_ib_sqp *sqp = to_msqp(qp);
+
+		if (sqp->roce_v2_gsi) {
+			struct mlx4_ib_ah *ah = to_mah(ud_wr(wr)->ah);
+			struct ib_gid_attr gid_attr;
+			union ib_gid gid;
+
+			if (!ib_get_cached_gid(ibqp->device,
+					       be32_to_cpu(ah->av.ib.port_pd) >> 24,
+					       ah->av.ib.gid_index, &gid,
+					       &gid_attr)) {
+				if (gid_attr.ndev)
+					dev_put(gid_attr.ndev);
+				qp = (gid_attr.gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) ?
+					to_mqp(sqp->roce_v2_gsi) : qp;
+			}
+		}
+	}
+
 	spin_lock_irqsave(&qp->sq.lock, flags);
 	if (mdev->dev->persist->state & MLX4_DEVICE_STATE_INTERNAL_ERROR) {
 		err = -EIO;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

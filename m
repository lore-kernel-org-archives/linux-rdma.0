From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 4/4] mlx4: RAW PACKET QP support
Date: Mon, 6 Dec 2010 09:38:43 +0200
Message-ID: <4CFC9303.101@voltaire.com>
References: <4CFC918D.1090708@voltaire.com> <4CFC921D.3000907@voltaire.com> <4CFC926B.8060305@voltaire.com> <4CFC92AF.8070009@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFC92AF.8070009-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make distinction when attaching/detaching multicast QP.
QP type  used for protocol determination.

When modifiying QP set mtu_msgmax to 0xff as it  required by from
Mellanox PRM. In the case of using raw ethernet first three bits (mtu)
should be set to 7 and the rest (maximum message size) to 31.

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   14 +++++++++-----
 drivers/infiniband/hw/mlx4/qp.c   |   20 +++++++++++++++-----
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bbe003f..0a19fcd 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -622,10 +622,12 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	int err;
 	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
 	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
+	enum mlx4_protocol prot = (ibqp->qp_type == IB_QPT_RAW_PACKET ?
+			    MLX4_PROTOCOL_EN : MLX4_PROTOCOL_IB);
 
 	err = mlx4_multicast_attach(mdev->dev, &mqp->mqp, gid->raw, !!(mqp->flags &
-				    MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK),
-				    MLX4_PROTOCOL_IB);
+				    MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK), prot);
+
 	if (err)
 		return err;
 
@@ -636,8 +638,8 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	return 0;
 
 err_add:
-	mlx4_multicast_detach(mdev->dev, &mqp->mqp, gid->raw,
-			MLX4_PROTOCOL_IB);
+	mlx4_multicast_detach(mdev->dev, &mqp->mqp, gid->raw, prot);
+
 	return err;
 }
 
@@ -665,9 +667,11 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	u8 mac[6];
 	struct net_device *ndev;
 	struct mlx4_ib_gid_entry *ge;
+	enum mlx4_protocol prot = (ibqp->qp_type == IB_QPT_RAW_PACKET ?
+				    MLX4_PROTOCOL_EN : MLX4_PROTOCOL_IB);
 
 	err = mlx4_multicast_detach(mdev->dev,
-				    &mqp->mqp, gid->raw, MLX4_PROTOCOL_IB);
+				    &mqp->mqp, gid->raw, prot);
 	if (err)
 		return err;
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 9a7794a..0008b7a 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -746,6 +746,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
+	case IB_QPT_RAW_PACKET:
 	{
 		qp = kzalloc(sizeof *qp, GFP_KERNEL);
 		if (!qp)
@@ -822,7 +823,8 @@ static int to_mlx4_st(enum ib_qp_type type)
 	case IB_QPT_UC:		return MLX4_QP_ST_UC;
 	case IB_QPT_UD:		return MLX4_QP_ST_UD;
 	case IB_QPT_SMI:
-	case IB_QPT_GSI:	return MLX4_QP_ST_MLX;
+	case IB_QPT_GSI:
+	case IB_QPT_RAW_PACKET:	return MLX4_QP_ST_MLX;
 	default:		return -1;
 	}
 }
@@ -988,8 +990,9 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			break;
 		}
 	}
-
-	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI)
+	if (ibqp->qp_type == IB_QPT_RAW_PACKET)
+		context->mtu_msgmax = 0xff;
+	else if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI)
 		context->mtu_msgmax = (IB_MTU_4096 << 5) | 11;
 	else if (ibqp->qp_type == IB_QPT_UD) {
 		if (qp->flags & MLX4_IB_QP_LSO)
@@ -1138,7 +1141,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (cur_state == IB_QPS_INIT &&
 	    new_state == IB_QPS_RTR  &&
 	    (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI ||
-	     ibqp->qp_type == IB_QPT_UD)) {
+	     ibqp->qp_type == IB_QPT_UD ||
+	     ibqp->qp_type == IB_QPT_RAW_PACKET)) {
 		context->pri_path.sched_queue = (qp->port - 1) << 6;
 		if (is_qp0(dev, qp))
 			context->pri_path.sched_queue |= MLX4_IB_DEFAULT_QP0_SCHED_QUEUE;
@@ -1252,11 +1256,17 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask))
 		goto out;
 
-	if ((attr_mask & IB_QP_PORT) &&
+	if ((attr_mask & IB_QP_PORT) && (ibqp->qp_type != IB_QPT_RAW_PACKET) &&
 	    (attr->port_num == 0 || attr->port_num > dev->dev->caps.num_ports)) {
 		goto out;
 	}
 
+	if ((attr_mask & IB_QP_PORT) && (ibqp->qp_type == IB_QPT_RAW_PACKET) &&
+		(rdma_port_get_link_layer(&dev->ib_dev, attr->port_num)
+				!= IB_LINK_LAYER_ETHERNET)) {
+		goto out;
+	}
+
 	if (attr_mask & IB_QP_PKEY_INDEX) {
 		int p = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
 		if (attr->pkey_index >= dev->dev->caps.pkey_table_len[p])
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

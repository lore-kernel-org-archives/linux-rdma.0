From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/4] IB/mlx4: add Raw Packet QP support
Date: Tue, 17 Jan 2012 13:39:07 +0200
Message-ID: <alpine.LRH.2.00.1201171338430.26871@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201171330540.24946-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implementation of the RAW Packet QP for the mlx4_ib driver,
use the MLX transport as done by the mlx4_en Ethernet driver.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index aa2aefa..97ee02a 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -84,6 +84,11 @@ enum {
 	MLX4_IB_CACHE_LINE_SIZE	= 64,
 };

+enum {
+	MLX4_RAW_QP_MTU		= 7,
+	MLX4_RAW_QP_MSGMAX	= 31,
+};
+
 static const __be32 mlx4_ib_opcode[] = {
 	[IB_WR_SEND]				= cpu_to_be32(MLX4_OPCODE_SEND),
 	[IB_WR_LSO]				= cpu_to_be32(MLX4_OPCODE_LSO),
@@ -573,7 +578,12 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	if (sqpn) {
 		qpn = sqpn;
 	} else {
-		err = mlx4_qp_reserve_range(dev->dev, 1, 1, &qpn);
+		/* Raw packet QPNs must be aligned to 8 bits. If not, the WQE
+		   BlueFlame setup flow would wrongly cause vlan insertion */
+		if (init_attr->qp_type == IB_QPT_RAW_PACKET)
+			err = mlx4_qp_reserve_range(dev->dev, 1, 1 << 8, &qpn);
+		else
+			err = mlx4_qp_reserve_range(dev->dev, 1, 1, &qpn);
 		if (err)
 			goto err_wrid;
 	}
@@ -791,6 +801,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
+	case IB_QPT_RAW_PACKET:
 	{
 		qp = kzalloc(sizeof *qp, GFP_KERNEL);
 		if (!qp)
@@ -872,7 +883,8 @@ static int to_mlx4_st(enum ib_qp_type type)
 	case IB_QPT_XRC_INI:
 	case IB_QPT_XRC_TGT:	return MLX4_QP_ST_XRC;
 	case IB_QPT_SMI:
-	case IB_QPT_GSI:	return MLX4_QP_ST_MLX;
+	case IB_QPT_GSI:
+	case IB_QPT_RAW_PACKET:	return MLX4_QP_ST_MLX;
 	default:		return -1;
 	}
 }
@@ -1042,6 +1054,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,

 	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI)
 		context->mtu_msgmax = (IB_MTU_4096 << 5) | 11;
+	else if (ibqp->qp_type == IB_QPT_RAW_PACKET)
+		context->mtu_msgmax = (MLX4_RAW_QP_MTU << 5) | MLX4_RAW_QP_MSGMAX;
 	else if (ibqp->qp_type == IB_QPT_UD) {
 		if (qp->flags & MLX4_IB_QP_LSO)
 			context->mtu_msgmax = (IB_MTU_4096 << 5) |
@@ -1200,7 +1214,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (cur_state == IB_QPS_INIT &&
 	    new_state == IB_QPS_RTR  &&
 	    (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI ||
-	     ibqp->qp_type == IB_QPT_UD)) {
+	     ibqp->qp_type == IB_QPT_UD ||
+	     ibqp->qp_type == IB_QPT_RAW_PACKET)) {
 		context->pri_path.sched_queue = (qp->port - 1) << 6;
 		if (is_qp0(dev, qp))
 			context->pri_path.sched_queue |= MLX4_IB_DEFAULT_QP0_SCHED_QUEUE;
@@ -1319,6 +1334,14 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto out;
 	}

+	if ((attr_mask & IB_QP_PORT) && (ibqp->qp_type == IB_QPT_RAW_PACKET) &&
+		(rdma_port_get_link_layer(&dev->ib_dev, attr->port_num)
+				!= IB_LINK_LAYER_ETHERNET)) {
+		printk(KERN_WARNING "mlx4_ib: RAW PACKET QPs can "
+			"only be used over Ethernet ports\n");
+		goto out;
+	}
+
 	if (attr_mask & IB_QP_PKEY_INDEX) {
 		int p = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
 		if (attr->pkey_index >= dev->dev->caps.pkey_table_len[p])
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

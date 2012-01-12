From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 1/6] IB: use central enum for speed instead of hard-coded
 values
Date: Thu, 12 Jan 2012 19:34:05 +0200
Message-ID: <alpine.LRH.2.00.1201121932160.5886@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com> <alpine.LRH.2.00.1201111854190.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111854190.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The kernel IB stack uses one enumeration for IB speed, which wasn't
explicitly specified in the verbs header file. Add that enum, and
use it all over the code. Note that the IB speed/width notation is
also used by iWARP and IBoE hw drivers who apply the convention of
rate = speed X width, to advertize their port link rate.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

changes from v0:
 fixed typo in the enum type name (was ib_port_seed instead of ib_port_speed)

 drivers/infiniband/core/sysfs.c              |   15 +++++++-----
 drivers/infiniband/core/uverbs_cmd.c         |    3 ++
 drivers/infiniband/core/verbs.c              |    1 +
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/cxgb4/provider.c       |    2 +-
 drivers/infiniband/hw/ehca/ehca_hca.c        |    2 +-
 drivers/infiniband/hw/mlx4/main.c            |   10 ++++----
 drivers/infiniband/hw/mlx4/qp.c              |   31 +++++++++++++++++++++----
 drivers/infiniband/hw/nes/nes_verbs.c        |    2 +-
 include/rdma/ib_verbs.h                      |   11 ++++++++-
 11 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c61bca3..9ce70ca 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -189,21 +189,24 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 	rate = (25 * attr.active_speed) / 10;

 	switch (attr.active_speed) {
-	case 2:
+	case IB_SPEED_SDR:
+		speed = " SDR";
+		break;
+	case IB_SPEED_DDR:
 		speed = " DDR";
 		break;
-	case 4:
+	case IB_SPEED_QDR:
 		speed = " QDR";
 		break;
-	case 8:
+	case IB_SPEED_FDR10:
 		speed = " FDR10";
 		rate = 10;
 		break;
-	case 16:
+	case IB_SPEED_FDR:
 		speed = " FDR";
 		rate = 14;
 		break;
-	case 32:
+	case IB_SPEED_EDR:
 		speed = " EDR";
 		rate = 25;
 		break;
@@ -214,7 +217,7 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 		return -EINVAL;

 	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
-		       rate, (attr.active_speed == 1) ? ".5" : "",
+		       rate, (attr.active_speed == IB_SPEED_SDR) ? ".5" : "",
 		       ib_width_enum_to_int(attr.active_width), speed);
 }

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b930da4..8722e96 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1399,6 +1399,9 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;

+	if (cmd.qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
+		return -EPERM;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 602b1bd..f73e15b 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -479,6 +479,7 @@ static const struct {
 				[IB_QPT_UD]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_QKEY),
+				[IB_QPT_RAW_PACKET] = IB_QP_PORT,
 				[IB_QPT_UC]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 12f923d..07eb3a8 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -94,7 +94,7 @@ static int c2_query_port(struct ib_device *ibdev,
 	props->pkey_tbl_len = 1;
 	props->qkey_viol_cntr = 0;
 	props->active_width = 1;
-	props->active_speed = 1;
+	props->active_speed = IB_SPEED_SDR;

 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 37c224f..0bdf09a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1227,7 +1227,7 @@ static int iwch_query_port(struct ib_device *ibdev,
 	props->gid_tbl_len = 1;
 	props->pkey_tbl_len = 1;
 	props->active_width = 2;
-	props->active_speed = 2;
+	props->active_speed = IB_SPEED_DDR;
 	props->max_msg_sz = -1;

 	return 0;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 247fe70..be1c18f 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -329,7 +329,7 @@ static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 	props->gid_tbl_len = 1;
 	props->pkey_tbl_len = 1;
 	props->active_width = 2;
-	props->active_speed = 2;
+	props->active_speed = IB_SPEED_DDR;
 	props->max_msg_sz = -1;

 	return 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 73edc36..9ed4d25 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -233,7 +233,7 @@ int ehca_query_port(struct ib_device *ibdev,
 		props->phys_state      = 5;
 		props->state           = rblock->state;
 		props->active_width    = IB_WIDTH_12X;
-		props->active_speed    = 0x1;
+		props->active_speed    = IB_SPEED_SDR;
 	}

 query_port1:
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7b445df..6ff6bdf 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -215,16 +215,16 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,

 		switch (ext_active_speed) {
 		case 1:
-			props->active_speed = 16; /* FDR */
+			props->active_speed = IB_SPEED_FDR;
 			break;
 		case 2:
-			props->active_speed = 32; /* EDR */
+			props->active_speed = IB_SPEED_EDR;
 			break;
 		}
 	}

 	/* If reported active speed is QDR, check if is FDR-10 */
-	if (props->active_speed == 4) {
+	if (props->active_speed == IB_SPEED_QDR) {
 		if (to_mdev(ibdev)->dev->caps.ext_port_cap[port] &
 		    MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO) {
 			init_query_mad(in_mad);
@@ -238,7 +238,7 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,

 			/* Checking LinkSpeedActive for FDR-10 */
 			if (out_mad->data[15] & 0x1)
-				props->active_speed = 8;
+				props->active_speed = IB_SPEED_FDR10;
 		}
 	}

@@ -259,7 +259,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	enum ib_mtu tmp;

 	props->active_width	= IB_WIDTH_1X;
-	props->active_speed	= 4;
+	props->active_speed	= IB_SPEED_QDR;
 	props->port_cap_flags	= IB_PORT_CM_SUP;
 	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= to_mdev(ibdev)->dev->caps.max_msg_sz;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index aa2aefa..3b434f8 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -84,6 +84,10 @@ enum {
 	MLX4_IB_CACHE_LINE_SIZE	= 64,
 };

+enum {
+	IB_MTU_RAW_QP = 7,
+};
+
 static const __be32 mlx4_ib_opcode[] = {
 	[IB_WR_SEND]				= cpu_to_be32(MLX4_OPCODE_SEND),
 	[IB_WR_LSO]				= cpu_to_be32(MLX4_OPCODE_LSO),
@@ -573,7 +577,12 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	if (sqpn) {
 		qpn = sqpn;
 	} else {
-		err = mlx4_qp_reserve_range(dev->dev, 1, 1, &qpn);
+		/* Raw packet QPNs must be aligned to 8 bits.
+		   If not, the blueflame setup code runs over the vlan bits */
+		if (init_attr->qp_type == IB_QPT_RAW_PACKET)
+			err = mlx4_qp_reserve_range(dev->dev, 1, 1 << 8, &qpn);
+		else
+			err = mlx4_qp_reserve_range(dev->dev, 1, 1, &qpn);
 		if (err)
 			goto err_wrid;
 	}
@@ -791,6 +800,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
+	case IB_QPT_RAW_PACKET:
 	{
 		qp = kzalloc(sizeof *qp, GFP_KERNEL);
 		if (!qp)
@@ -872,7 +882,8 @@ static int to_mlx4_st(enum ib_qp_type type)
 	case IB_QPT_XRC_INI:
 	case IB_QPT_XRC_TGT:	return MLX4_QP_ST_XRC;
 	case IB_QPT_SMI:
-	case IB_QPT_GSI:	return MLX4_QP_ST_MLX;
+	case IB_QPT_GSI:
+	case IB_QPT_RAW_PACKET:	return MLX4_QP_ST_MLX;
 	default:		return -1;
 	}
 }
@@ -1039,8 +1050,9 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			break;
 		}
 	}
-
-	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI)
+	if (ibqp->qp_type == IB_QPT_RAW_PACKET)
+		context->mtu_msgmax = (IB_MTU_RAW_QP << 5) | 31;
+	else if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI)
 		context->mtu_msgmax = (IB_MTU_4096 << 5) | 11;
 	else if (ibqp->qp_type == IB_QPT_UD) {
 		if (qp->flags & MLX4_IB_QP_LSO)
@@ -1200,7 +1212,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (cur_state == IB_QPS_INIT &&
 	    new_state == IB_QPS_RTR  &&
 	    (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI ||
-	     ibqp->qp_type == IB_QPT_UD)) {
+	     ibqp->qp_type == IB_QPT_UD ||
+	     ibqp->qp_type == IB_QPT_RAW_PACKET)) {
 		context->pri_path.sched_queue = (qp->port - 1) << 6;
 		if (is_qp0(dev, qp))
 			context->pri_path.sched_queue |= MLX4_IB_DEFAULT_QP0_SCHED_QUEUE;
@@ -1319,6 +1332,14 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 5095bc4..b7b9c85 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -597,7 +597,7 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	props->pkey_tbl_len = 1;
 	props->qkey_viol_cntr = 0;
 	props->active_width = IB_WIDTH_4X;
-	props->active_speed = 1;
+	props->active_speed = IB_SPEED_SDR;
 	props->max_msg_sz = 0x80000000;

 	return 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bf5daaf..857dbd5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -239,6 +239,15 @@ static inline int ib_width_enum_to_int(enum ib_port_width width)
 	}
 }

+enum ib_port_speed {
+	IB_SPEED_SDR	= 1,
+	IB_SPEED_DDR	= 2,
+	IB_SPEED_QDR	= 4,
+	IB_SPEED_FDR10	= 8,
+	IB_SPEED_FDR	= 16,
+	IB_SPEED_EDR	= 32
+};
+
 struct ib_protocol_stats {
 	/* TBD... */
 };
@@ -596,7 +605,7 @@ enum ib_qp_type {
 	IB_QPT_UD,
 	IB_QPT_RAW_IPV6,
 	IB_QPT_RAW_ETHERTYPE,
-	/* Save 8 for RAW_PACKET */
+ 	IB_QPT_RAW_PACKET = 8,
 	IB_QPT_XRC_INI = 9,
 	IB_QPT_XRC_TGT,
 	IB_QPT_MAX
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

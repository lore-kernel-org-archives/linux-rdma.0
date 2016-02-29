From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 03/10] IB/mlx5: Add GSI QP wrapper
Date: Mon, 29 Feb 2016 15:45:05 +0200
Message-ID: <1456753512-17688-4-git-send-email-haggaie@mellanox.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

mlx5 creates special GSI QPs that has limited ability to control the P_Key
of transmitted packets. The sent P_Key is taken from the QP object,
similarly to what happens with regular UD QPs.

Create a software wrapper around GSI QPs that with the following patches
will be able to emulate the functionality of a GSI QP including control of
the P_Key per work request.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/Makefile  |   2 +-
 drivers/infiniband/hw/mlx5/gsi.c     | 179 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c    |   2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  30 +++++-
 drivers/infiniband/hw/mlx5/qp.c      |  50 +++++++---
 5 files changed, 249 insertions(+), 14 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/gsi.c

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index 27a70159e2ea..4e851889355a 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MLX5_INFINIBAND)	+= mlx5_ib.o
 
-mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o
+mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o
 mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
new file mode 100644
index 000000000000..711655400ca5
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -0,0 +1,179 @@
+/*
+ * Copyright (c) 2016, Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include "mlx5_ib.h"
+
+struct mlx5_ib_gsi_qp {
+	struct ib_qp ibqp;
+	struct ib_qp *rx_qp;
+	u8 port_num;
+	struct ib_qp_cap cap;
+	enum ib_sig_type sq_sig_type;
+	/* Serialize qp state modifications */
+	struct mutex mutex;
+};
+
+static struct mlx5_ib_gsi_qp *gsi_qp(struct ib_qp *qp)
+{
+	return container_of(qp, struct mlx5_ib_gsi_qp, ibqp);
+}
+
+struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
+				    struct ib_qp_init_attr *init_attr)
+{
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_gsi_qp *gsi;
+	struct ib_qp_init_attr hw_init_attr = *init_attr;
+	const u8 port_num = init_attr->port_num;
+	int ret;
+
+	mlx5_ib_dbg(dev, "creating GSI QP\n");
+
+	if (port_num > ARRAY_SIZE(dev->devr.ports) || port_num < 1) {
+		mlx5_ib_warn(dev,
+			     "invalid port number %d during GSI QP creation\n",
+			     port_num);
+		return ERR_PTR(-EINVAL);
+	}
+
+	gsi = kzalloc(sizeof(*gsi), GFP_KERNEL);
+	if (!gsi)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&gsi->mutex);
+
+	mutex_lock(&dev->devr.mutex);
+
+	if (dev->devr.ports[port_num - 1].gsi) {
+		mlx5_ib_warn(dev, "GSI QP already exists on port %d\n",
+			     port_num);
+		ret = -EBUSY;
+		goto err_free;
+	}
+
+	gsi->cap = init_attr->cap;
+	gsi->sq_sig_type = init_attr->sq_sig_type;
+	gsi->ibqp.qp_num = 1;
+	gsi->port_num = port_num;
+
+	hw_init_attr.qp_type = MLX5_IB_QPT_HW_GSI;
+	gsi->rx_qp = ib_create_qp(pd, &hw_init_attr);
+	if (IS_ERR(gsi->rx_qp)) {
+		mlx5_ib_warn(dev, "unable to create hardware GSI QP. error %ld\n",
+			     PTR_ERR(gsi->rx_qp));
+		ret = PTR_ERR(gsi->rx_qp);
+		goto err_free;
+	}
+
+	dev->devr.ports[init_attr->port_num - 1].gsi = gsi;
+
+	mutex_unlock(&dev->devr.mutex);
+
+	return &gsi->ibqp;
+
+err_free:
+	mutex_unlock(&dev->devr.mutex);
+	kfree(gsi);
+	return ERR_PTR(ret);
+}
+
+int mlx5_ib_gsi_destroy_qp(struct ib_qp *qp)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_gsi_qp *gsi = gsi_qp(qp);
+	const int port_num = gsi->port_num;
+	int ret;
+
+	mlx5_ib_dbg(dev, "destroying GSI QP\n");
+
+	mutex_lock(&dev->devr.mutex);
+	ret = ib_destroy_qp(gsi->rx_qp);
+	if (ret) {
+		mlx5_ib_warn(dev, "unable to destroy hardware GSI QP. error %d\n",
+			     ret);
+		mutex_unlock(&dev->devr.mutex);
+		return ret;
+	}
+	dev->devr.ports[port_num - 1].gsi = NULL;
+	mutex_unlock(&dev->devr.mutex);
+
+	kfree(gsi);
+
+	return 0;
+}
+
+int mlx5_ib_gsi_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
+			  int attr_mask)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_gsi_qp *gsi = gsi_qp(qp);
+	int ret;
+
+	mlx5_ib_dbg(dev, "modifying GSI QP to state %d\n", attr->qp_state);
+
+	mutex_lock(&gsi->mutex);
+	ret = ib_modify_qp(gsi->rx_qp, attr, attr_mask);
+	mutex_unlock(&gsi->mutex);
+
+	return ret;
+}
+
+int mlx5_ib_gsi_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
+			 int qp_attr_mask,
+			 struct ib_qp_init_attr *qp_init_attr)
+{
+	struct mlx5_ib_gsi_qp *gsi = gsi_qp(qp);
+	int ret;
+
+	mutex_lock(&gsi->mutex);
+	ret = ib_query_qp(gsi->rx_qp, qp_attr, qp_attr_mask, qp_init_attr);
+	qp_init_attr->cap = gsi->cap;
+	mutex_unlock(&gsi->mutex);
+
+	return ret;
+}
+
+int mlx5_ib_gsi_post_send(struct ib_qp *qp, struct ib_send_wr *wr,
+			  struct ib_send_wr **bad_wr)
+{
+	struct mlx5_ib_gsi_qp *gsi = gsi_qp(qp);
+
+	return ib_post_send(gsi->rx_qp, wr, bad_wr);
+}
+
+int mlx5_ib_gsi_post_recv(struct ib_qp *qp, struct ib_recv_wr *wr,
+			  struct ib_recv_wr **bad_wr)
+{
+	struct mlx5_ib_gsi_qp *gsi = gsi_qp(qp);
+
+	return ib_post_recv(gsi->rx_qp, wr, bad_wr);
+}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 03c418ccbc98..a2a16db62b5e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1965,6 +1965,8 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 
 	dev = container_of(devr, struct mlx5_ib_dev, devr);
 
+	mutex_init(&devr->mutex);
+
 	devr->p0 = mlx5_ib_alloc_pd(&dev->ib_dev, NULL, NULL);
 	if (IS_ERR(devr->p0)) {
 		ret = PTR_ERR(devr->p0);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8dc6cd818baf..81af9842ab29 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -163,6 +163,11 @@ struct mlx5_ib_flow_db {
 #define MLX5_IB_SEND_UMR_FAIL_IF_FREE (IB_SEND_RESERVED_START << 1)
 #define MLX5_IB_SEND_UMR_UPDATE_MTT (IB_SEND_RESERVED_START << 2)
 #define MLX5_IB_QPT_REG_UMR	IB_QPT_RESERVED1
+/*
+ * IB_QPT_GSI creates the software wrapper around GSI, and MLX5_IB_QPT_HW_GSI
+ * creates the actual hardware QP.
+ */
+#define MLX5_IB_QPT_HW_GSI	IB_QPT_RESERVED2
 #define MLX5_IB_WR_UMR		IB_WR_RESERVED1
 
 /* Private QP creation flags to be passed in ib_qp_init_attr.create_flags.
@@ -501,6 +506,12 @@ struct mlx5_mr_cache {
 	unsigned long		last_add;
 };
 
+struct mlx5_ib_gsi_qp;
+
+struct mlx5_ib_port_resources {
+	struct mlx5_ib_gsi_qp *gsi;
+};
+
 struct mlx5_ib_resources {
 	struct ib_cq	*c0;
 	struct ib_xrcd	*x0;
@@ -508,6 +519,9 @@ struct mlx5_ib_resources {
 	struct ib_pd	*p0;
 	struct ib_srq	*s0;
 	struct ib_srq	*s1;
+	struct mlx5_ib_port_resources ports[2];
+	/* Protects changes to the port resources */
+	struct mutex	mutex;
 };
 
 struct mlx5_roce {
@@ -753,6 +767,20 @@ static inline void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp)  {}
 __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
 			       int index);
 
+/* GSI QP helper functions */
+struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
+				    struct ib_qp_init_attr *init_attr);
+int mlx5_ib_gsi_destroy_qp(struct ib_qp *qp);
+int mlx5_ib_gsi_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
+			  int attr_mask);
+int mlx5_ib_gsi_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
+			 int qp_attr_mask,
+			 struct ib_qp_init_attr *qp_init_attr);
+int mlx5_ib_gsi_post_send(struct ib_qp *qp, struct ib_send_wr *wr,
+			  struct ib_send_wr **bad_wr);
+int mlx5_ib_gsi_post_recv(struct ib_qp *qp, struct ib_recv_wr *wr,
+			  struct ib_recv_wr **bad_wr);
+
 static inline void init_query_mad(struct ib_smp *mad)
 {
 	mad->base_version  = 1;
@@ -772,7 +800,7 @@ static inline u8 convert_access(int acc)
 
 static inline int is_qp1(enum ib_qp_type qp_type)
 {
-	return qp_type == IB_QPT_GSI;
+	return qp_type == MLX5_IB_QPT_HW_GSI;
 }
 
 #define MLX5_MAX_UMR_SHIFT 16
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 784ddf77fca2..c1196cc4a5e8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -288,7 +288,7 @@ static int sq_overhead(enum ib_qp_type qp_type)
 
 	case IB_QPT_UD:
 	case IB_QPT_SMI:
-	case IB_QPT_GSI:
+	case MLX5_IB_QPT_HW_GSI:
 		size += sizeof(struct mlx5_wqe_ctrl_seg) +
 			sizeof(struct mlx5_wqe_datagram_seg);
 		break;
@@ -590,7 +590,7 @@ static int to_mlx5_st(enum ib_qp_type type)
 	case IB_QPT_XRC_INI:
 	case IB_QPT_XRC_TGT:		return MLX5_QP_ST_XRC;
 	case IB_QPT_SMI:		return MLX5_QP_ST_QP0;
-	case IB_QPT_GSI:		return MLX5_QP_ST_QP1;
+	case MLX5_IB_QPT_HW_GSI:	return MLX5_QP_ST_QP1;
 	case IB_QPT_RAW_IPV6:		return MLX5_QP_ST_RAW_IPV6;
 	case IB_QPT_RAW_PACKET:
 	case IB_QPT_RAW_ETHERTYPE:	return MLX5_QP_ST_RAW_ETHERTYPE;
@@ -1506,7 +1506,7 @@ static void get_cqs(struct mlx5_ib_qp *qp,
 		break;
 
 	case IB_QPT_SMI:
-	case IB_QPT_GSI:
+	case MLX5_IB_QPT_HW_GSI:
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
@@ -1669,7 +1669,7 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_UC:
 	case IB_QPT_UD:
 	case IB_QPT_SMI:
-	case IB_QPT_GSI:
+	case MLX5_IB_QPT_HW_GSI:
 	case MLX5_IB_QPT_REG_UMR:
 		qp = kzalloc(sizeof(*qp), GFP_KERNEL);
 		if (!qp)
@@ -1698,6 +1698,9 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 
 		break;
 
+	case IB_QPT_GSI:
+		return mlx5_ib_gsi_create_qp(pd, init_attr);
+
 	case IB_QPT_RAW_IPV6:
 	case IB_QPT_RAW_ETHERTYPE:
 	case IB_QPT_MAX:
@@ -1716,6 +1719,9 @@ int mlx5_ib_destroy_qp(struct ib_qp *qp)
 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
 
+	if (unlikely(qp->qp_type == IB_QPT_GSI))
+		return mlx5_ib_gsi_destroy_qp(qp);
+
 	destroy_qp_common(dev, mqp);
 
 	kfree(mqp);
@@ -2196,7 +2202,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}
 
-	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI) {
+	if (is_sqp(ibqp->qp_type)) {
 		context->mtu_msgmax = (IB_MTU_256 << 5) | 8;
 	} else if (ibqp->qp_type == IB_QPT_UD ||
 		   ibqp->qp_type == MLX5_IB_QPT_REG_UMR) {
@@ -2379,11 +2385,18 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
+	enum ib_qp_type qp_type;
 	enum ib_qp_state cur_state, new_state;
 	int err = -EINVAL;
 	int port;
 	enum rdma_link_layer ll = IB_LINK_LAYER_UNSPECIFIED;
 
+	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
+		return mlx5_ib_gsi_modify_qp(ibqp, attr, attr_mask);
+
+	qp_type = (unlikely(ibqp->qp_type == MLX5_IB_QPT_HW_GSI)) ?
+		IB_QPT_GSI : ibqp->qp_type;
+
 	mutex_lock(&qp->mutex);
 
 	cur_state = attr_mask & IB_QP_CUR_STATE ? attr->cur_qp_state : qp->state;
@@ -2394,9 +2407,8 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		ll = dev->ib_dev.get_link_layer(&dev->ib_dev, port);
 	}
 
-	if (ibqp->qp_type != MLX5_IB_QPT_REG_UMR &&
-	    !ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask,
-				ll)) {
+	if (qp_type != MLX5_IB_QPT_REG_UMR &&
+	    !ib_modify_qp_is_ok(cur_state, new_state, qp_type, attr_mask, ll)) {
 		mlx5_ib_dbg(dev, "invalid QP state transition from %d to %d, qp_type %d, attr_mask 0x%x\n",
 			    cur_state, new_state, ibqp->qp_type, attr_mask);
 		goto out;
@@ -3227,13 +3239,13 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 {
 	struct mlx5_wqe_ctrl_seg *ctrl = NULL;  /* compiler warning */
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
-	struct mlx5_ib_qp *qp = to_mqp(ibqp);
+	struct mlx5_ib_qp *qp;
 	struct mlx5_ib_mr *mr;
 	struct mlx5_wqe_data_seg *dpseg;
 	struct mlx5_wqe_xrc_seg *xrc;
-	struct mlx5_bf *bf = qp->bf;
+	struct mlx5_bf *bf;
 	int uninitialized_var(size);
-	void *qend = qp->sq.qend;
+	void *qend;
 	unsigned long flags;
 	unsigned idx;
 	int err = 0;
@@ -3245,6 +3257,13 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	u8 next_fence = 0;
 	u8 fence;
 
+	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
+		return mlx5_ib_gsi_post_send(ibqp, wr, bad_wr);
+
+	qp = to_mqp(ibqp);
+	bf = qp->bf;
+	qend = qp->sq.qend;
+
 	spin_lock_irqsave(&qp->sq.lock, flags);
 
 	for (nreq = 0; wr; nreq++, wr = wr->next) {
@@ -3406,7 +3425,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 		case IB_QPT_UD:
 		case IB_QPT_SMI:
-		case IB_QPT_GSI:
+		case MLX5_IB_QPT_HW_GSI:
 			set_datagram_seg(seg, wr);
 			seg += sizeof(struct mlx5_wqe_datagram_seg);
 			size += sizeof(struct mlx5_wqe_datagram_seg) / 16;
@@ -3533,6 +3552,9 @@ int mlx5_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	int ind;
 	int i;
 
+	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
+		return mlx5_ib_gsi_post_recv(ibqp, wr, bad_wr);
+
 	spin_lock_irqsave(&qp->rq.lock, flags);
 
 	ind = qp->rq.head & (qp->rq.wqe_cnt - 1);
@@ -3853,6 +3875,10 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	int err = 0;
 	u8 raw_packet_qp_state;
 
+	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
+		return mlx5_ib_gsi_query_qp(ibqp, qp_attr, qp_attr_mask,
+					    qp_init_attr);
+
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	/*
 	 * Wait for any outstanding page faults, in case the user frees memory
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

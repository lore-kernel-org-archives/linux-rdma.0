From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 5/6] IB/mlx5: Add support for DC Initiator QP
Date: Tue,  2 Jan 2018 16:19:32 +0200
Message-ID: <20180102141933.24353-6-leon@kernel.org>
References: <20180102141933.24353-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102141933.24353-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

DC Initiator (DCI) QP is represented like any other QP in the hardware.
However, like any other transport QP there are attributes and settings
that are special to DCI QP and needs specific attention and care.
Make necessary changes to configure DCI QP.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 77 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f7f6fe618620..be721f3a36c3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -613,6 +613,7 @@ static int to_mlx5_st(enum ib_qp_type type)
 	case IB_QPT_XRC_TGT:		return MLX5_QP_ST_XRC;
 	case IB_QPT_SMI:		return MLX5_QP_ST_QP0;
 	case MLX5_IB_QPT_HW_GSI:	return MLX5_QP_ST_QP1;
+	case MLX5_IB_QPT_DCI:		return MLX5_QP_ST_DCI;
 	case IB_QPT_RAW_IPV6:		return MLX5_QP_ST_RAW_IPV6;
 	case IB_QPT_RAW_PACKET:
 	case IB_QPT_RAW_ETHERTYPE:	return MLX5_QP_ST_RAW_ETHERTYPE;
@@ -1044,6 +1045,7 @@ static void destroy_qp_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 static u32 get_rx_type(struct mlx5_ib_qp *qp, struct ib_qp_init_attr *attr)
 {
 	if (attr->srq || (attr->qp_type == IB_QPT_XRC_TGT) ||
+	    (attr->qp_type == MLX5_IB_QPT_DCI) ||
 	    (attr->qp_type == IB_QPT_XRC_INI))
 		return MLX5_SRQ_RQ;
 	else if (!qp->has_rq)
@@ -2249,6 +2251,14 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 		err = set_mlx_qp_type(dev, init_attr, &ucmd, udata);
 		if (err)
 			return ERR_PTR(err);
+
+		if (init_attr->qp_type == MLX5_IB_QPT_DCI) {
+			if (init_attr->cap.max_recv_wr ||
+			    init_attr->cap.max_recv_sge) {
+				mlx5_ib_dbg(dev, "DCI QP requires zero size receive queue\n");
+				return ERR_PTR(-EINVAL);
+			}
+		}
 	}
 
 	switch (init_attr->qp_type) {
@@ -2272,6 +2282,7 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_SMI:
 	case MLX5_IB_QPT_HW_GSI:
 	case MLX5_IB_QPT_REG_UMR:
+	case MLX5_IB_QPT_DCI:
 		qp = kzalloc(sizeof(*qp), GFP_KERNEL);
 		if (!qp)
 			return ERR_PTR(-ENOMEM);
@@ -2893,7 +2904,8 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (!context)
 		return -ENOMEM;
 
-	err = to_mlx5_st(ibqp->qp_type);
+	err = to_mlx5_st(ibqp->qp_type == IB_QPT_DRIVER ?
+			 qp->qp_sub_type : ibqp->qp_type);
 	if (err < 0) {
 		mlx5_ib_dbg(dev, "unsupported qp type %d\n", ibqp->qp_type);
 		goto out;
@@ -3052,7 +3064,8 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 
 	mlx5_cur = to_mlx5_state(cur_state);
 	mlx5_new = to_mlx5_state(new_state);
-	mlx5_st = to_mlx5_st(ibqp->qp_type);
+	mlx5_st = to_mlx5_st(ibqp->qp_type == IB_QPT_DRIVER ?
+			     qp->qp_sub_type : ibqp->qp_type);
 	if (mlx5_st < 0)
 		goto out;
 
@@ -3124,6 +3137,50 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	return err;
 }
 
+static inline bool is_valid_mask(int mask, int req, int opt)
+{
+	if ((mask & req) != req)
+		return false;
+
+	if (mask & ~(req | opt))
+		return false;
+
+	return true;
+}
+
+/* check valid transition for driver QP types
+ * for now the only QP type that this function supports is DCI
+ */
+static bool modify_dci_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state new_state,
+				enum ib_qp_attr_mask attr_mask)
+{
+	int req = IB_QP_STATE;
+	int opt = 0;
+
+	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
+		req |= IB_QP_PKEY_INDEX | IB_QP_PORT;
+		return is_valid_mask(attr_mask, req, opt);
+	} else if (cur_state == IB_QPS_INIT && new_state == IB_QPS_INIT) {
+		opt = IB_QP_PKEY_INDEX | IB_QP_PORT;
+		return is_valid_mask(attr_mask, req, opt);
+	} else if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
+		req |= IB_QP_PATH_MTU;
+		opt = IB_QP_PKEY_INDEX;
+		return is_valid_mask(attr_mask, req, opt);
+	} else if (cur_state == IB_QPS_RTR && new_state == IB_QPS_RTS) {
+		req |= IB_QP_TIMEOUT | IB_QP_RETRY_CNT | IB_QP_RNR_RETRY |
+		       IB_QP_MAX_QP_RD_ATOMIC | IB_QP_SQ_PSN;
+		opt = IB_QP_MIN_RNR_TIMER;
+		return is_valid_mask(attr_mask, req, opt);
+	} else if (cur_state == IB_QPS_RTS && new_state == IB_QPS_RTS) {
+		opt = IB_QP_MIN_RNR_TIMER;
+		return is_valid_mask(attr_mask, req, opt);
+	} else if (cur_state != IB_QPS_RESET && new_state == IB_QPS_ERR) {
+		return is_valid_mask(attr_mask, req, opt);
+	}
+	return false;
+}
+
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
@@ -3141,8 +3198,12 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
 		return mlx5_ib_gsi_modify_qp(ibqp, attr, attr_mask);
 
-	qp_type = (unlikely(ibqp->qp_type == MLX5_IB_QPT_HW_GSI)) ?
-		IB_QPT_GSI : ibqp->qp_type;
+	if (ibqp->qp_type == IB_QPT_DRIVER)
+		qp_type = qp->qp_sub_type;
+	else
+		qp_type = (unlikely(ibqp->qp_type == MLX5_IB_QPT_HW_GSI)) ?
+			IB_QPT_GSI : ibqp->qp_type;
+
 
 	mutex_lock(&qp->mutex);
 
@@ -3161,10 +3222,16 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			goto out;
 		}
 	} else if (qp_type != MLX5_IB_QPT_REG_UMR &&
-	    !ib_modify_qp_is_ok(cur_state, new_state, qp_type, attr_mask, ll)) {
+		   qp_type != MLX5_IB_QPT_DCI &&
+		   !ib_modify_qp_is_ok(cur_state, new_state, qp_type, attr_mask, ll)) {
 		mlx5_ib_dbg(dev, "invalid QP state transition from %d to %d, qp_type %d, attr_mask 0x%x\n",
 			    cur_state, new_state, ibqp->qp_type, attr_mask);
 		goto out;
+	} else if (qp_type == MLX5_IB_QPT_DCI &&
+		   !modify_dci_qp_is_ok(cur_state, new_state, attr_mask)) {
+		mlx5_ib_dbg(dev, "invalid QP state transition from %d to %d, qp_type %d, attr_mask 0x%x\n",
+			    cur_state, new_state, qp_type, attr_mask);
+		goto out;
 	}
 
 	if ((attr_mask & IB_QP_PORT) &&
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

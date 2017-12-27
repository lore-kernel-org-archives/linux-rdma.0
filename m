From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 1/6] net/mlx5: Add DCT command interface
Date: Wed, 27 Dec 2017 19:15:35 +0200
Message-ID: <20171227171540.1646-2-leon@kernel.org>
References: <20171227171540.1646-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227171540.1646-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a missing command interface to work with a DCT. It includes: creating,
destroying and get events for.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 124 ++++++++++++++++++++++++---
 include/linux/mlx5/device.h                  |   9 ++
 include/linux/mlx5/driver.h                  |   8 ++
 include/linux/mlx5/qp.h                      |  12 +++
 5 files changed, 149 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 60771865c99c..7d3d503fa675 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -417,7 +417,11 @@ static irqreturn_t mlx5_eq_int(int irq, void *eq_ptr)
 			cqn = be32_to_cpu(eqe->data.comp.cqn) & 0xffffff;
 			mlx5_cq_completion(dev, cqn);
 			break;
-
+		case MLX5_EVENT_TYPE_DCT_DRAINED:
+			rsn = be32_to_cpu(eqe->data.dct.dctn) & 0xffffff;
+			rsn |= (MLX5_RES_DCT << MLX5_USER_INDEX_LEN);
+			mlx5_rsc_event(dev, rsn, eqe->type);
+			break;
 		case MLX5_EVENT_TYPE_PATH_MIG:
 		case MLX5_EVENT_TYPE_COMM_EST:
 		case MLX5_EVENT_TYPE_SQ_DRAINED:
@@ -715,6 +719,9 @@ int mlx5_start_eqs(struct mlx5_core_dev *dev)
 
 	if (MLX5_CAP_GEN(dev, fpga))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_FPGA_ERROR);
+	if (MLX5_CAP_GEN_MAX(dev, dct))
+		async_event_mask |= (1ull << MLX5_EVENT_TYPE_DCT_DRAINED);
+
 
 	err = mlx5_create_map_eq(dev, &table->cmd_eq, MLX5_EQ_VEC_CMD,
 				 MLX5_NUM_CMD_EQE, 1ull << MLX5_EVENT_TYPE_CMD,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index db9e665ab104..b907fef91ef3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -98,6 +98,11 @@ static u64 sq_allowed_event_types(void)
 	return BIT(MLX5_EVENT_TYPE_WQ_CATAS_ERROR);
 }
 
+static u64 dct_allowed_event_types(void)
+{
+	return BIT(MLX5_EVENT_TYPE_DCT_DRAINED);
+}
+
 static bool is_event_type_allowed(int rsc_type, int event_type)
 {
 	switch (rsc_type) {
@@ -107,6 +112,8 @@ static bool is_event_type_allowed(int rsc_type, int event_type)
 		return BIT(event_type) & rq_allowed_event_types();
 	case MLX5_EVENT_QUEUE_TYPE_SQ:
 		return BIT(event_type) & sq_allowed_event_types();
+	case MLX5_EVENT_QUEUE_TYPE_DCT:
+		return BIT(event_type) & dct_allowed_event_types();
 	default:
 		WARN(1, "Event arrived for unknown resource type");
 		return false;
@@ -116,6 +123,7 @@ static bool is_event_type_allowed(int rsc_type, int event_type)
 void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 {
 	struct mlx5_core_rsc_common *common = mlx5_get_rsc(dev, rsn);
+	struct mlx5_core_dct *dct;
 	struct mlx5_core_qp *qp;
 
 	if (!common)
@@ -134,7 +142,11 @@ void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 		qp = (struct mlx5_core_qp *)common;
 		qp->event(qp, event_type);
 		break;
-
+	case MLX5_RES_DCT:
+		dct = (struct mlx5_core_dct *)common;
+		if (event_type == MLX5_EVENT_TYPE_DCT_DRAINED)
+			complete(&dct->drained);
+		break;
 	default:
 		mlx5_core_warn(dev, "invalid resource type for 0x%x\n", rsn);
 	}
@@ -142,9 +154,9 @@ void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 	mlx5_core_put_rsc(common);
 }
 
-static int create_qprqsq_common(struct mlx5_core_dev *dev,
-				struct mlx5_core_qp *qp,
-				int rsc_type)
+static int create_resource_common(struct mlx5_core_dev *dev,
+				  struct mlx5_core_qp *qp,
+				  int rsc_type)
 {
 	struct mlx5_qp_table *table = &dev->priv.qp_table;
 	int err;
@@ -165,8 +177,8 @@ static int create_qprqsq_common(struct mlx5_core_dev *dev,
 	return 0;
 }
 
-static void destroy_qprqsq_common(struct mlx5_core_dev *dev,
-				  struct mlx5_core_qp *qp)
+static void destroy_resource_common(struct mlx5_core_dev *dev,
+				    struct mlx5_core_qp *qp)
 {
 	struct mlx5_qp_table *table = &dev->priv.qp_table;
 	unsigned long flags;
@@ -179,6 +191,39 @@ static void destroy_qprqsq_common(struct mlx5_core_dev *dev,
 	wait_for_completion(&qp->common.free);
 }
 
+int mlx5_core_create_dct(struct mlx5_core_dev *dev,
+			 struct mlx5_core_dct *dct,
+			 u32 *in, int inlen)
+{
+	u32 out[MLX5_ST_SZ_DW(create_dct_out)]   = {0};
+	u32 din[MLX5_ST_SZ_DW(destroy_dct_in)]   = {0};
+	u32 dout[MLX5_ST_SZ_DW(destroy_dct_out)] = {0};
+	struct mlx5_core_qp *qp = &dct->mqp;
+	int err;
+
+	init_completion(&dct->drained);
+	MLX5_SET(create_dct_in, in, opcode, MLX5_CMD_OP_CREATE_DCT);
+
+	err = mlx5_cmd_exec(dev, in, inlen, &out, sizeof(out));
+	if (err) {
+		mlx5_core_warn(dev, "create DCT failed, ret %d\n", err);
+		return err;
+	}
+
+	qp->qpn = MLX5_GET(create_dct_out, out, dctn);
+	err = create_resource_common(dev, qp, MLX5_RES_DCT);
+	if (err)
+		goto err_cmd;
+
+	return 0;
+err_cmd:
+	MLX5_SET(destroy_dct_in, din, opcode, MLX5_CMD_OP_DESTROY_DCT);
+	MLX5_SET(destroy_dct_in, din, dctn, qp->qpn);
+	mlx5_cmd_exec(dev, (void *)&in, sizeof(din), (void *)&out, sizeof(dout));
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_core_create_dct);
+
 int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 			struct mlx5_core_qp *qp,
 			u32 *in, int inlen)
@@ -197,7 +242,7 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
 	mlx5_core_dbg(dev, "qpn = 0x%x\n", qp->qpn);
 
-	err = create_qprqsq_common(dev, qp, MLX5_RES_QP);
+	err = create_resource_common(dev, qp, MLX5_RES_QP);
 	if (err)
 		goto err_cmd;
 
@@ -220,6 +265,47 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_core_create_qp);
 
+static int mlx5_core_drain_dct(struct mlx5_core_dev *dev,
+			       struct mlx5_core_dct *dct)
+{
+	u32 out[MLX5_ST_SZ_DW(drain_dct_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(drain_dct_in)]   = {0};
+	struct mlx5_core_qp *qp = &dct->mqp;
+
+	MLX5_SET(drain_dct_in, in, opcode, MLX5_CMD_OP_DRAIN_DCT);
+	MLX5_SET(drain_dct_in, in, dctn, qp->qpn);
+	return mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
+			     (void *)&out, sizeof(out));
+}
+
+int mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
+			  struct mlx5_core_dct *dct)
+{
+	u32 out[MLX5_ST_SZ_DW(destroy_dct_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_dct_in)]   = {0};
+	struct mlx5_core_qp *qp = &dct->mqp;
+	int err;
+
+	err = mlx5_core_drain_dct(dev, dct);
+	if (err) {
+		if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
+			goto destroy;
+		} else {
+			mlx5_core_warn(dev, "failed drain DCT 0x%x with error 0x%x\n", qp->qpn, err);
+			return err;
+		}
+	}
+	wait_for_completion(&dct->drained);
+destroy:
+	destroy_resource_common(dev, &dct->mqp);
+	MLX5_SET(destroy_dct_in, in, opcode, MLX5_CMD_OP_DESTROY_DCT);
+	MLX5_SET(destroy_dct_in, in, dctn, qp->qpn);
+	err = mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
+			    (void *)&out, sizeof(out));
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_core_destroy_dct);
+
 int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
 			 struct mlx5_core_qp *qp)
 {
@@ -229,7 +315,7 @@ int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
 
 	mlx5_debug_qp_remove(dev, qp);
 
-	destroy_qprqsq_common(dev, qp);
+	destroy_resource_common(dev, qp);
 
 	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
 	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
@@ -405,6 +491,20 @@ int mlx5_core_qp_query(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 }
 EXPORT_SYMBOL_GPL(mlx5_core_qp_query);
 
+int mlx5_core_dct_query(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct,
+			u32 *out, int outlen)
+{
+	u32 in[MLX5_ST_SZ_DW(query_dct_in)] = {0};
+	struct mlx5_core_qp *qp = &dct->mqp;
+
+	MLX5_SET(query_dct_in, in, opcode, MLX5_CMD_OP_QUERY_DCT);
+	MLX5_SET(query_dct_in, in, dctn, qp->qpn);
+
+	return mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
+			     (void *)out, outlen);
+}
+EXPORT_SYMBOL_GPL(mlx5_core_dct_query);
+
 int mlx5_core_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn)
 {
 	u32 out[MLX5_ST_SZ_DW(alloc_xrcd_out)] = {0};
@@ -441,7 +541,7 @@ int mlx5_core_create_rq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 		return err;
 
 	rq->qpn = rqn;
-	err = create_qprqsq_common(dev, rq, MLX5_RES_RQ);
+	err = create_resource_common(dev, rq, MLX5_RES_RQ);
 	if (err)
 		goto err_destroy_rq;
 
@@ -457,7 +557,7 @@ EXPORT_SYMBOL(mlx5_core_create_rq_tracked);
 void mlx5_core_destroy_rq_tracked(struct mlx5_core_dev *dev,
 				  struct mlx5_core_qp *rq)
 {
-	destroy_qprqsq_common(dev, rq);
+	destroy_resource_common(dev, rq);
 	mlx5_core_destroy_rq(dev, rq->qpn);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_rq_tracked);
@@ -473,7 +573,7 @@ int mlx5_core_create_sq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 		return err;
 
 	sq->qpn = sqn;
-	err = create_qprqsq_common(dev, sq, MLX5_RES_SQ);
+	err = create_resource_common(dev, sq, MLX5_RES_SQ);
 	if (err)
 		goto err_destroy_sq;
 
@@ -489,7 +589,7 @@ EXPORT_SYMBOL(mlx5_core_create_sq_tracked);
 void mlx5_core_destroy_sq_tracked(struct mlx5_core_dev *dev,
 				  struct mlx5_core_qp *sq)
 {
-	destroy_qprqsq_common(dev, sq);
+	destroy_resource_common(dev, sq);
 	mlx5_core_destroy_sq(dev, sq->qpn);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_sq_tracked);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 2ff9f48ebec3..e5258ee4e38b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -291,6 +291,7 @@ enum {
 	MLX5_EVENT_QUEUE_TYPE_QP = 0,
 	MLX5_EVENT_QUEUE_TYPE_RQ = 1,
 	MLX5_EVENT_QUEUE_TYPE_SQ = 2,
+	MLX5_EVENT_QUEUE_TYPE_DCT = 6,
 };
 
 enum mlx5_event {
@@ -326,6 +327,8 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_PAGE_FAULT	   = 0xc,
 	MLX5_EVENT_TYPE_NIC_VPORT_CHANGE   = 0xd,
 
+	MLX5_EVENT_TYPE_DCT_DRAINED        = 0x1c,
+
 	MLX5_EVENT_TYPE_FPGA_ERROR         = 0x20,
 };
 
@@ -618,6 +621,11 @@ struct mlx5_eqe_pps {
 	u8		rsvd2[12];
 } __packed;
 
+struct mlx5_eqe_dct {
+	__be32  reserved[6];
+	__be32  dctn;
+};
+
 union ev_data {
 	__be32				raw[7];
 	struct mlx5_eqe_cmd		cmd;
@@ -633,6 +641,7 @@ union ev_data {
 	struct mlx5_eqe_vport_change	vport_change;
 	struct mlx5_eqe_port_module	port_module;
 	struct mlx5_eqe_pps		pps;
+	struct mlx5_eqe_dct             dct;
 } __packed;
 
 struct mlx5_eqe {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4d1ed35fdbb4..b5eb5c55dcaf 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -154,6 +154,13 @@ enum mlx5_dcbx_oper_mode {
 	MLX5E_DCBX_PARAM_VER_OPER_AUTO  = 0x3,
 };
 
+enum mlx5_dct_atomic_mode {
+	MLX5_ATOMIC_MODE_DCT_OFF        = 20,
+	MLX5_ATOMIC_MODE_DCT_NONE       = 0 << MLX5_ATOMIC_MODE_DCT_OFF,
+	MLX5_ATOMIC_MODE_DCT_IB_COMP    = 1 << MLX5_ATOMIC_MODE_DCT_OFF,
+	MLX5_ATOMIC_MODE_DCT_CX         = 2 << MLX5_ATOMIC_MODE_DCT_OFF,
+};
+
 enum {
 	MLX5_ATOMIC_OPS_CMP_SWAP	= 1 << 0,
 	MLX5_ATOMIC_OPS_FETCH_ADD	= 1 << 1,
@@ -432,6 +439,7 @@ enum mlx5_res_type {
 	MLX5_RES_SRQ	= 3,
 	MLX5_RES_XSRQ	= 4,
 	MLX5_RES_XRQ	= 5,
+	MLX5_RES_DCT	= MLX5_EVENT_QUEUE_TYPE_DCT,
 };
 
 struct mlx5_core_rsc_common {
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 62af7512dabb..4778d41085d4 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -473,6 +473,11 @@ struct mlx5_core_qp {
 	int			pid;
 };
 
+struct mlx5_core_dct {
+	struct mlx5_core_qp	mqp;
+	struct completion	drained;
+};
+
 struct mlx5_qp_path {
 	u8			fl_free_ar;
 	u8			rsvd3;
@@ -549,6 +554,9 @@ static inline struct mlx5_core_mkey *__mlx5_mr_lookup(struct mlx5_core_dev *dev,
 	return radix_tree_lookup(&dev->priv.mkey_table.tree, key);
 }
 
+int mlx5_core_create_dct(struct mlx5_core_dev *dev,
+			 struct mlx5_core_dct *qp,
+			 u32 *in, int inlen);
 int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 			struct mlx5_core_qp *qp,
 			u32 *in,
@@ -558,8 +566,12 @@ int mlx5_core_qp_modify(struct mlx5_core_dev *dev, u16 opcode,
 			struct mlx5_core_qp *qp);
 int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
 			 struct mlx5_core_qp *qp);
+int mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
+			  struct mlx5_core_dct *dct);
 int mlx5_core_qp_query(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 		       u32 *out, int outlen);
+int mlx5_core_dct_query(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct,
+			u32 *out, int outlen);
 
 int mlx5_core_set_delay_drop(struct mlx5_core_dev *dev,
 			     u32 timeout_usec);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

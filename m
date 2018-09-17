From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 02/25] net/mlx5: Set uid as part of QP commands
Date: Mon, 17 Sep 2018 14:03:55 +0300
Message-ID: <20180917110418.18937-3-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of QP commands so that the firmware can manage the
QP object in a secured way.

That will enable using a QP that was created by verbs application to
be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 45 +++++++++++++++++-----------
 include/linux/mlx5/mlx5_ifc.h                | 22 +++++++-------
 include/linux/mlx5/qp.h                      |  1 +
 3 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 4ca07bfb6b14..04f72a1cdbcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -240,6 +240,7 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 	if (err)
 		return err;
 
+	qp->uid = MLX5_GET(create_qp_in, in, uid);
 	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
 	mlx5_core_dbg(dev, "qpn = 0x%x\n", qp->qpn);
 
@@ -261,6 +262,7 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 	memset(dout, 0, sizeof(dout));
 	MLX5_SET(destroy_qp_in, din, opcode, MLX5_CMD_OP_DESTROY_QP);
 	MLX5_SET(destroy_qp_in, din, qpn, qp->qpn);
+	MLX5_SET(destroy_qp_in, din, uid, qp->uid);
 	mlx5_cmd_exec(dev, din, sizeof(din), dout, sizeof(dout));
 	return err;
 }
@@ -320,6 +322,7 @@ int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
 
 	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
 	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
+	MLX5_SET(destroy_qp_in, in, uid, qp->uid);
 	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 	if (err)
 		return err;
@@ -373,7 +376,7 @@ static void mbox_free(struct mbox_info *mbox)
 
 static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
 				u32 opt_param_mask, void *qpc,
-				struct mbox_info *mbox)
+				struct mbox_info *mbox, u16 uid)
 {
 	mbox->out = NULL;
 	mbox->in = NULL;
@@ -381,26 +384,32 @@ static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
 #define MBOX_ALLOC(mbox, typ)  \
 	mbox_alloc(mbox, MLX5_ST_SZ_BYTES(typ##_in), MLX5_ST_SZ_BYTES(typ##_out))
 
-#define MOD_QP_IN_SET(typ, in, _opcode, _qpn) \
-	MLX5_SET(typ##_in, in, opcode, _opcode); \
-	MLX5_SET(typ##_in, in, qpn, _qpn)
-
-#define MOD_QP_IN_SET_QPC(typ, in, _opcode, _qpn, _opt_p, _qpc) \
-	MOD_QP_IN_SET(typ, in, _opcode, _qpn); \
-	MLX5_SET(typ##_in, in, opt_param_mask, _opt_p); \
-	memcpy(MLX5_ADDR_OF(typ##_in, in, qpc), _qpc, MLX5_ST_SZ_BYTES(qpc))
+#define MOD_QP_IN_SET(typ, in, _opcode, _qpn, _uid) \
+	do { \
+		MLX5_SET(typ##_in, in, opcode, _opcode); \
+		MLX5_SET(typ##_in, in, qpn, _qpn); \
+		MLX5_SET(typ##_in, in, uid, _uid); \
+	} while (0)
+
+#define MOD_QP_IN_SET_QPC(typ, in, _opcode, _qpn, _opt_p, _qpc, _uid) \
+	do { \
+		MOD_QP_IN_SET(typ, in, _opcode, _qpn, _uid); \
+		MLX5_SET(typ##_in, in, opt_param_mask, _opt_p); \
+		memcpy(MLX5_ADDR_OF(typ##_in, in, qpc), \
+		       _qpc, MLX5_ST_SZ_BYTES(qpc)); \
+	} while (0)
 
 	switch (opcode) {
 	/* 2RST & 2ERR */
 	case MLX5_CMD_OP_2RST_QP:
 		if (MBOX_ALLOC(mbox, qp_2rst))
 			return -ENOMEM;
-		MOD_QP_IN_SET(qp_2rst, mbox->in, opcode, qpn);
+		MOD_QP_IN_SET(qp_2rst, mbox->in, opcode, qpn, uid);
 		break;
 	case MLX5_CMD_OP_2ERR_QP:
 		if (MBOX_ALLOC(mbox, qp_2err))
 			return -ENOMEM;
-		MOD_QP_IN_SET(qp_2err, mbox->in, opcode, qpn);
+		MOD_QP_IN_SET(qp_2err, mbox->in, opcode, qpn, uid);
 		break;
 
 	/* MODIFY with QPC */
@@ -408,37 +417,37 @@ static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
 		if (MBOX_ALLOC(mbox, rst2init_qp))
 			return -ENOMEM;
 		MOD_QP_IN_SET_QPC(rst2init_qp, mbox->in, opcode, qpn,
-				  opt_param_mask, qpc);
+				  opt_param_mask, qpc, uid);
 		break;
 	case MLX5_CMD_OP_INIT2RTR_QP:
 		if (MBOX_ALLOC(mbox, init2rtr_qp))
 			return -ENOMEM;
 		MOD_QP_IN_SET_QPC(init2rtr_qp, mbox->in, opcode, qpn,
-				  opt_param_mask, qpc);
+				  opt_param_mask, qpc, uid);
 		break;
 	case MLX5_CMD_OP_RTR2RTS_QP:
 		if (MBOX_ALLOC(mbox, rtr2rts_qp))
 			return -ENOMEM;
 		MOD_QP_IN_SET_QPC(rtr2rts_qp, mbox->in, opcode, qpn,
-				  opt_param_mask, qpc);
+				  opt_param_mask, qpc, uid);
 		break;
 	case MLX5_CMD_OP_RTS2RTS_QP:
 		if (MBOX_ALLOC(mbox, rts2rts_qp))
 			return -ENOMEM;
 		MOD_QP_IN_SET_QPC(rts2rts_qp, mbox->in, opcode, qpn,
-				  opt_param_mask, qpc);
+				  opt_param_mask, qpc, uid);
 		break;
 	case MLX5_CMD_OP_SQERR2RTS_QP:
 		if (MBOX_ALLOC(mbox, sqerr2rts_qp))
 			return -ENOMEM;
 		MOD_QP_IN_SET_QPC(sqerr2rts_qp, mbox->in, opcode, qpn,
-				  opt_param_mask, qpc);
+				  opt_param_mask, qpc, uid);
 		break;
 	case MLX5_CMD_OP_INIT2INIT_QP:
 		if (MBOX_ALLOC(mbox, init2init_qp))
 			return -ENOMEM;
 		MOD_QP_IN_SET_QPC(init2init_qp, mbox->in, opcode, qpn,
-				  opt_param_mask, qpc);
+				  opt_param_mask, qpc, uid);
 		break;
 	default:
 		mlx5_core_err(dev, "Unknown transition for modify QP: OP(0x%x) QPN(0x%x)\n",
@@ -456,7 +465,7 @@ int mlx5_core_qp_modify(struct mlx5_core_dev *dev, u16 opcode,
 	int err;
 
 	err = modify_qp_mbox_alloc(dev, opcode, qp->qpn,
-				   opt_param_mask, qpc, &mbox);
+				   opt_param_mask, qpc, &mbox, qp->uid);
 	if (err)
 		return err;
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e62a0825d35c..e5a0d3ecfaad 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3395,7 +3395,7 @@ struct mlx5_ifc_sqerr2rts_qp_out_bits {
 
 struct mlx5_ifc_sqerr2rts_qp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -3425,7 +3425,7 @@ struct mlx5_ifc_sqd2rts_qp_out_bits {
 
 struct mlx5_ifc_sqd2rts_qp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -3630,7 +3630,7 @@ struct mlx5_ifc_rts2rts_qp_out_bits {
 
 struct mlx5_ifc_rts2rts_qp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -3660,7 +3660,7 @@ struct mlx5_ifc_rtr2rts_qp_out_bits {
 
 struct mlx5_ifc_rtr2rts_qp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -3690,7 +3690,7 @@ struct mlx5_ifc_rst2init_qp_out_bits {
 
 struct mlx5_ifc_rst2init_qp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -5193,7 +5193,7 @@ struct mlx5_ifc_qp_2rst_out_bits {
 
 struct mlx5_ifc_qp_2rst_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -5215,7 +5215,7 @@ struct mlx5_ifc_qp_2err_out_bits {
 
 struct mlx5_ifc_qp_2err_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -5790,7 +5790,7 @@ struct mlx5_ifc_init2rtr_qp_out_bits {
 
 struct mlx5_ifc_init2rtr_qp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -5820,7 +5820,7 @@ struct mlx5_ifc_init2init_qp_out_bits {
 
 struct mlx5_ifc_init2init_qp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6231,7 +6231,7 @@ struct mlx5_ifc_destroy_qp_out_bits {
 
 struct mlx5_ifc_destroy_qp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6896,7 +6896,7 @@ struct mlx5_ifc_create_qp_out_bits {
 
 struct mlx5_ifc_create_qp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 4778d41085d4..fbe322c966bc 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -471,6 +471,7 @@ struct mlx5_core_qp {
 	int			qpn;
 	struct mlx5_rsc_debug	*dbg;
 	int			pid;
+	u16			uid;
 };
 
 struct mlx5_core_dct {
-- 
2.14.4

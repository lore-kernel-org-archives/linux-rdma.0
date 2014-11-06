From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 3/5] mlx5_core: Add DC support at mlx5 core layer
Date: Thu,  6 Nov 2014 17:52:37 +0200
Message-ID: <1415289159-4376-4-git-send-email-eli@mellanox.com>
References: <1415289159-4376-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415289159-4376-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, richardg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update debugfs, implement DC commands and handle events.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 110 +++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c      |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/qp.c      | 185 ++++++++++++++++++++++
 include/linux/mlx5/device.h                       |  12 ++
 include/linux/mlx5/driver.h                       |  24 ++-
 include/linux/mlx5/mlx5_ifc.h                     | 179 +++++++++++++++++++++
 include/linux/mlx5/qp.h                           |  39 ++++-
 8 files changed, 566 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 10e1f1a18255..3e115dee235a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -35,6 +35,7 @@
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/mlx5_ifc.h>
 #include "mlx5_core.h"
 
 enum {
@@ -62,6 +63,22 @@ static char *qp_fields[] = {
 };
 
 enum {
+	DCT_PID,
+	DCT_STATE,
+	DCT_MTU,
+	DCT_KEY_VIOL,
+	DCT_CQN,
+};
+
+static char *dct_fields[] = {
+	[DCT_PID]	= "pid",
+	[DCT_STATE]	= "state",
+	[DCT_MTU]	= "mtu",
+	[DCT_KEY_VIOL]	= "key_violations",
+	[DCT_CQN]	= "cqn",
+};
+
+enum {
 	EQ_NUM_EQES,
 	EQ_INTR,
 	EQ_LOG_PG_SZ,
@@ -122,6 +139,26 @@ void mlx5_qp_debugfs_cleanup(struct mlx5_core_dev *dev)
 	debugfs_remove_recursive(dev->priv.qp_debugfs);
 }
 
+int mlx5_dct_debugfs_init(struct mlx5_core_dev *dev)
+{
+	if (!mlx5_debugfs_root)
+		return 0;
+
+	dev->priv.dct_debugfs = debugfs_create_dir("DCTs",  dev->priv.dbg_root);
+	if (!dev->priv.dct_debugfs)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void mlx5_dct_debugfs_cleanup(struct mlx5_core_dev *dev)
+{
+	if (!mlx5_debugfs_root)
+		return;
+
+	debugfs_remove_recursive(dev->priv.dct_debugfs);
+}
+
 int mlx5_eq_debugfs_init(struct mlx5_core_dev *dev)
 {
 	if (!mlx5_debugfs_root)
@@ -355,6 +392,51 @@ out:
 	return param;
 }
 
+static u64 dct_read_field(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct,
+			  int index, int *is_str)
+{
+	void *out;
+	void *dctc;
+	int out_sz = MLX5_ST_SZ_BYTES(query_dct_out);
+	u64 param = 0;
+	int err;
+
+	out = kzalloc(out_sz, GFP_KERNEL);
+	if (!out)
+		return param;
+
+	err = mlx5_core_dct_query(dev, dct, out);
+	if (err) {
+		mlx5_core_warn(dev, "failed to query dct\n");
+		goto out;
+	}
+
+	dctc = MLX5_ADDR_OF(query_dct_out, out, dct_context_entry);
+	*is_str = 0;
+	switch (index) {
+	case DCT_PID:
+		param = dct->pid;
+		break;
+	case DCT_STATE:
+		param = (u64)mlx5_dct_state_str(MLX5_GET(dctc, dctc, state));
+		*is_str = 1;
+		break;
+	case DCT_MTU:
+		param = ib_mtu_enum_to_int(MLX5_GET(dctc, dctc, mtu));
+		break;
+	case DCT_KEY_VIOL:
+		param = MLX5_GET(dctc, dctc, dc_access_key_violation_count);
+		break;
+	case DCT_CQN:
+		param = MLX5_GET(dctc, dctc, cqn);
+		break;
+	}
+
+out:
+	kfree(out);
+	return param;
+}
+
 static u64 eq_read_field(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 			 int index)
 {
@@ -457,6 +539,10 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 		field = cq_read_field(d->dev, d->object, desc->i);
 		break;
 
+	case MLX5_DBG_RSC_DCT:
+		field = dct_read_field(d->dev, d->object, desc->i, &is_str);
+		break;
+
 	default:
 		mlx5_core_warn(d->dev, "invalid resource type %d\n", d->type);
 		return -EINVAL;
@@ -558,6 +644,30 @@ void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp)
 		rem_res_tree(qp->dbg);
 }
 
+int mlx5_debug_dct_add(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct)
+{
+	int err;
+
+	if (!mlx5_debugfs_root)
+		return 0;
+
+	err = add_res_tree(dev, MLX5_DBG_RSC_DCT, dev->priv.dct_debugfs,
+			   &dct->dbg, dct->dctn, dct_fields,
+			   ARRAY_SIZE(dct_fields), dct);
+	if (err)
+		dct->dbg = NULL;
+
+	return err;
+}
+
+void mlx5_debug_dct_remove(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct)
+{
+	if (!mlx5_debugfs_root)
+		return;
+
+	if (dct->dbg)
+		rem_res_tree(dct->dbg);
+}
 
 int mlx5_debug_eq_add(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index ad2c96a02a53..941077ea7a7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -68,7 +68,9 @@ enum {
 			       (1ull << MLX5_EVENT_TYPE_PORT_CHANGE)	    | \
 			       (1ull << MLX5_EVENT_TYPE_SRQ_CATAS_ERROR)    | \
 			       (1ull << MLX5_EVENT_TYPE_SRQ_LAST_WQE)	    | \
-			       (1ull << MLX5_EVENT_TYPE_SRQ_RQ_LIMIT))
+			       (1ull << MLX5_EVENT_TYPE_SRQ_RQ_LIMIT)	    | \
+			       (1ull << MLX5_EVENT_TYPE_DCT_DRAINED)	    | \
+			       (1ull << MLX5_EVENT_TYPE_DCT_KEY_VIOLATION))
 
 struct map_eq_in {
 	u64	mask;
@@ -157,6 +159,11 @@ static const char *eqe_type_str(u8 type)
 		return "MLX5_EVENT_TYPE_CMD";
 	case MLX5_EVENT_TYPE_PAGE_REQUEST:
 		return "MLX5_EVENT_TYPE_PAGE_REQUEST";
+	case MLX5_EVENT_TYPE_DCT_DRAINED:
+		return "MLX5_EVENT_TYPE_DCT_DRAINED";
+	case MLX5_EVENT_TYPE_DCT_KEY_VIOLATION:
+		return "MLX5_EVENT_TYPE_DCT_KEY_VIOLATION";
+
 	default:
 		return "Unrecognized event";
 	}
@@ -216,6 +223,12 @@ static int mlx5_eq_int(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 			mlx5_cq_completion(dev, cqn);
 			break;
 
+		case MLX5_EVENT_TYPE_DCT_DRAINED:
+		case MLX5_EVENT_TYPE_DCT_KEY_VIOLATION:
+			rsn = be32_to_cpu(eqe->data.dct.dctn) & 0xffffff;
+			mlx5_rsc_event(dev, rsn, eqe->type);
+			break;
+
 		case MLX5_EVENT_TYPE_PATH_MIG:
 		case MLX5_EVENT_TYPE_COMM_EST:
 		case MLX5_EVENT_TYPE_SQ_DRAINED:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ecc6341e728a..44864d584660 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -434,6 +434,9 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 	/* disable checksum */
 	cur_caps->gen.flags &= ~MLX5_DEV_CAP_FLAG_CMDIF_CSUM;
 
+	if (max_caps->gen.flags & MLX5_DEV_CAP_FLAG_DCT)
+		cur_caps->gen.flags |= MLX5_DEV_CAP_FLAG_DCT;
+
 	copy_rw_fields(MLX5_ADDR_OF(set_hca_cap_in, set_ctx, hca_capability_struct),
 		       cur_caps);
 	err = set_caps(dev, set_ctx, set_sz);
@@ -640,6 +643,7 @@ static int mlx5_dev_init(struct mlx5_core_dev *dev, struct pci_dev *pdev)
 	mlx5_init_qp_table(dev);
 	mlx5_init_srq_table(dev);
 	mlx5_init_mr_table(dev);
+	mlx5_init_dct_table(dev);
 
 	return 0;
 
@@ -692,6 +696,8 @@ static void mlx5_dev_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 
+	mlx5_cleanup_dct_table(dev);
+	mlx5_cleanup_mr_table(dev);
 	mlx5_cleanup_srq_table(dev);
 	mlx5_cleanup_qp_table(dev);
 	mlx5_cleanup_cq_table(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 5261a2b0da43..65e0df5880f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -36,6 +36,7 @@
 #include <linux/mlx5/cmd.h>
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/mlx5_ifc.h>
 
 #include "mlx5_core.h"
 
@@ -70,6 +71,7 @@ void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common)
 void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 {
 	struct mlx5_core_rsc_common *common = mlx5_get_rsc(dev, rsn);
+	struct mlx5_core_dct *dct;
 	struct mlx5_core_qp *qp;
 
 	if (!common)
@@ -81,6 +83,14 @@ void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 		qp->event(qp, event_type);
 		break;
 
+	case MLX5_RES_DCT:
+		dct = (struct mlx5_core_dct *)common;
+		if (event_type == MLX5_EVENT_TYPE_DCT_DRAINED)
+			complete(&dct->drained);
+		else
+			dct->event(dct, event_type);
+		break;
+
 	default:
 		mlx5_core_warn(dev, "invalid resource type for 0x%x\n", rsn);
 	}
@@ -259,6 +269,16 @@ void mlx5_cleanup_qp_table(struct mlx5_core_dev *dev)
 	mlx5_qp_debugfs_cleanup(dev);
 }
 
+void mlx5_init_dct_table(struct mlx5_core_dev *dev)
+{
+	mlx5_dct_debugfs_init(dev);
+}
+
+void mlx5_cleanup_dct_table(struct mlx5_core_dev *dev)
+{
+	mlx5_dct_debugfs_cleanup(dev);
+}
+
 int mlx5_core_qp_query(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 		       struct mlx5_query_qp_mbox_out *out, int outlen)
 {
@@ -322,3 +342,168 @@ int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn)
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_core_xrcd_dealloc);
+
+int mlx5_core_create_dct(struct mlx5_core_dev *dev,
+			 struct mlx5_core_dct *dct,
+			 void *in)
+{
+	struct mlx5_qp_table *table = &dev->priv.qp_table;
+	const int in_sz = MLX5_ST_SZ_BYTES(create_dct_in);
+	u8 out[MLX5_ST_SZ_BYTES(create_dct_out)];
+	u8 din[MLX5_ST_SZ_BYTES(destroy_dct_in)];
+	u8 dout[MLX5_ST_SZ_BYTES(destroy_dct_out)];
+	int err;
+
+	init_completion(&dct->drained);
+	memset(&out, 0, sizeof(out));
+	MLX5_SET(create_dct_in, in, opcode, MLX5_CMD_OP_CREATE_DCT);
+
+	err = mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
+	if (err) {
+		mlx5_core_warn(dev, "create DCT failed, ret %d", err);
+		return err;
+	}
+
+	if (mlx5_get_out_cmd_status(out))
+		return mlx5_cmd_status_to_err_v2(out);
+
+	dct->dctn = MLX5_GET(create_dct_out, out, dct_number);
+
+	dct->common.res = MLX5_RES_DCT;
+	spin_lock_irq(&table->lock);
+	err = radix_tree_insert(&table->tree, dct->dctn, dct);
+	spin_unlock_irq(&table->lock);
+	if (err) {
+		mlx5_core_warn(dev, "err %d", err);
+		goto err_cmd;
+	}
+
+	err = mlx5_debug_dct_add(dev, dct);
+	if (err)
+		mlx5_core_dbg(dev, "failed adding DCT 0x%x to debug file system\n",
+			      dct->dctn);
+
+	dct->pid = current->pid;
+	atomic_set(&dct->common.refcount, 1);
+	init_completion(&dct->common.free);
+
+	return 0;
+
+err_cmd:
+	memset(din, 0, sizeof(din));
+	memset(dout, 0, sizeof(dout));
+	MLX5_SET(destroy_dct_in, din, opcode, MLX5_CMD_OP_DESTROY_DCT);
+	MLX5_SET(destroy_dct_in, din, dct_number, dct->dctn);
+	if (mlx5_cmd_exec(dev, din, sizeof(din), out, sizeof(dout)))
+		mlx5_core_warn(dev, "destroy DCT failed\n");
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_core_create_dct);
+
+static int mlx5_core_drain_dct(struct mlx5_core_dev *dev,
+			       struct mlx5_core_dct *dct)
+{
+	u8 out[MLX5_ST_SZ_BYTES(drain_dct_out)];
+	u8 in[MLX5_ST_SZ_BYTES(drain_dct_in)];
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	MLX5_SET(drain_dct_in, in, opcode, MLX5_CMD_OP_DRAIN_DCT);
+	MLX5_SET(drain_dct_in, in, dct_number, dct->dctn);
+	err = mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	if (mlx5_get_out_cmd_status(out))
+		return mlx5_cmd_status_to_err_v2(out);
+
+	return 0;
+}
+
+int mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
+			  struct mlx5_core_dct *dct)
+{
+	struct mlx5_qp_table *table = &dev->priv.qp_table;
+	u8 out[MLX5_ST_SZ_BYTES(destroy_dct_out)];
+	u8 in[MLX5_ST_SZ_BYTES(destroy_dct_in)];
+	unsigned long flags;
+	int err;
+
+	err = mlx5_core_drain_dct(dev, dct);
+	if (err) {
+		mlx5_core_warn(dev, "failed drain DCT 0x%x\n", dct->dctn);
+		return err;
+	}
+
+	wait_for_completion(&dct->drained);
+
+	mlx5_debug_dct_remove(dev, dct);
+
+	spin_lock_irqsave(&table->lock, flags);
+	if (radix_tree_delete(&table->tree, dct->dctn) != dct)
+		mlx5_core_warn(dev, "dct delete differs\n");
+	spin_unlock_irqrestore(&table->lock, flags);
+
+	mlx5_core_put_rsc(&dct->common);
+	wait_for_completion(&dct->common.free);
+
+	memset(in, 0, sizeof(in));
+	memset(out, 0, sizeof(out));
+	MLX5_SET(destroy_dct_in, in, opcode, MLX5_CMD_OP_DESTROY_DCT);
+	MLX5_SET(destroy_dct_in, in, dct_number, dct->dctn);
+	err = mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	if (mlx5_get_out_cmd_status(out))
+		return mlx5_cmd_status_to_err_v2(out);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_core_destroy_dct);
+
+int mlx5_core_dct_query(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct,
+			void *out)
+{
+	u8 in[MLX5_ST_SZ_BYTES(query_dct_in)];
+	int out_sz = MLX5_ST_SZ_BYTES(query_dct_out);
+	int err;
+
+	memset(in, 0, sizeof(in));
+	memset(out, 0, out_sz);
+	MLX5_SET(query_dct_in, in, opcode, MLX5_CMD_OP_QUERY_DCT);
+	MLX5_SET(query_dct_in, in, dct_number, dct->dctn);
+	err = mlx5_cmd_exec(dev, &in, sizeof(in), out, out_sz);
+	if (err)
+		return err;
+
+	if (mlx5_get_out_cmd_status(out))
+		return mlx5_cmd_status_to_err_v2(out);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_core_dct_query);
+
+int mlx5_core_arm_dct(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct)
+{
+	u8 out[MLX5_ST_SZ_BYTES(arm_dct_out)];
+	u8 in[MLX5_ST_SZ_BYTES(arm_dct_in)];
+	int err;
+
+	memset(in, 0, sizeof(in));
+	memset(out, 0, sizeof(out));
+
+	MLX5_SET(arm_dct_in, in, opcode, MLX5_CMD_OP_ARM_DCT_FOR_KEY_VIOLATION);
+	MLX5_SET(arm_dct_in, in, dct_number, dct->dctn);
+	err = mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	if (mlx5_get_out_cmd_status(out))
+		return mlx5_cmd_status_to_err_v2(out);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_core_arm_dct);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 6e9661105dfa..40db09d6c828 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -206,6 +206,8 @@ enum mlx5_event {
 
 	MLX5_EVENT_TYPE_CMD		   = 0x0a,
 	MLX5_EVENT_TYPE_PAGE_REQUEST	   = 0xb,
+	MLX5_EVENT_TYPE_DCT_DRAINED	   = 0x1c,
+	MLX5_EVENT_TYPE_DCT_KEY_VIOLATION  = 0x1d,
 };
 
 enum {
@@ -241,6 +243,10 @@ enum {
 };
 
 enum {
+	MLX5_DCT_CS_RES_64	= 2,
+};
+
+enum {
 	MLX5_OPCODE_NOP			= 0x00,
 	MLX5_OPCODE_SEND_INVAL		= 0x01,
 	MLX5_OPCODE_RDMA_WRITE		= 0x08,
@@ -449,6 +455,11 @@ struct mlx5_eqe_page_req {
 	__be32		rsvd1[5];
 };
 
+struct mlx5_eqe_dct {
+	__be32	reserved[6];
+	__be32	dctn;
+};
+
 union ev_data {
 	__be32				raw[7];
 	struct mlx5_eqe_cmd		cmd;
@@ -460,6 +471,7 @@ union ev_data {
 	struct mlx5_eqe_congestion	cong;
 	struct mlx5_eqe_stall_vl	stall_vl;
 	struct mlx5_eqe_page_req	req_pages;
+	struct mlx5_eqe_dct		dct;
 } __packed;
 
 struct mlx5_eqe {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index bdca5d94e6fc..47177f6c6f95 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -116,7 +116,6 @@ enum {
 	MLX5_REG_PUDE		 = 0x5009,
 	MLX5_REG_PMPE		 = 0x5010,
 	MLX5_REG_PELC		 = 0x500e,
-	MLX5_REG_PMLP		 = 0, /* TBD */
 	MLX5_REG_NODE_DESC	 = 0x6001,
 	MLX5_REG_HOST_ENDIANNESS = 0x7004,
 };
@@ -125,6 +124,7 @@ enum dbg_rsc_type {
 	MLX5_DBG_RSC_QP,
 	MLX5_DBG_RSC_EQ,
 	MLX5_DBG_RSC_CQ,
+	MLX5_DBG_RSC_DCT,
 };
 
 struct mlx5_field_desc {
@@ -393,6 +393,7 @@ struct mlx5_core_mr {
 
 enum mlx5_res_type {
 	MLX5_RES_QP,
+	MLX5_RES_DCT,
 };
 
 struct mlx5_core_rsc_common {
@@ -401,6 +402,16 @@ struct mlx5_core_rsc_common {
 	struct completion	free;
 };
 
+struct mlx5_core_dct {
+	struct mlx5_core_rsc_common	common; /* must be first */
+	int			dctn;
+	struct completion	drained;
+	struct mlx5_rsc_debug	*dbg;
+	int			pid;
+
+	void (*event)(struct mlx5_core_dct *, enum mlx5_event);
+};
+
 struct mlx5_core_srq {
 	u32		srqn;
 	int		max;
@@ -498,6 +509,10 @@ struct mlx5_priv {
 	struct dentry	       *cmdif_debugfs;
 	/* end: qp staff */
 
+	/* start: dct stuff */
+	struct dentry	       *dct_debugfs;
+	/* end: dct stuff */
+
 	/* start: cq staff */
 	struct mlx5_cq_table	cq_table;
 	/* end: cq staff */
@@ -764,6 +779,8 @@ int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
 			 int npsvs, u32 *sig_index);
 int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num);
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common);
+int mlx5_dct_debugfs_init(struct mlx5_core_dev *dev);
+void mlx5_dct_debugfs_cleanup(struct mlx5_core_dev *dev);
 
 static inline u32 mlx5_mkey_to_idx(u32 mkey)
 {
@@ -832,4 +849,9 @@ static inline const char *caps_opmod_str(u16 opmod)
 	}
 }
 
+static inline int mlx5_get_out_cmd_status(void *ptr)
+{
+	return *(u8 *)ptr;
+}
+
 #endif /* MLX5_DRIVER_H */
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a3e6148066ce..5b0feb248220 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -366,4 +366,183 @@ struct mlx5_ifc_atomic_cap_bits {
 	u8         reserved_6[0x720];
 };
 
+struct mlx5_ifc_create_dct_out_bits {
+	u8         status[0x8];
+	u8         reserved_0[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_1[0x8];
+	u8         dct_number[0x18];
+
+	u8         reserved_2[0x20];
+};
+
+struct mlx5_ifc_dctc_bits {
+	u8         reserved_0[0x4];
+	u8         state[0x4];
+	u8         reserved_1[0x18];
+
+	u8         reserved_2[0x8];
+	u8         sw_context[0x18];
+
+	u8         reserved_3[0x8];
+	u8         cqn[0x18];
+
+	u8         counter_set_id[0x8];
+	u8         atomic_mode[0x4];
+	u8         rre[0x1];
+	u8         rwe[0x1];
+	u8         rae[0x1];
+	u8         atomic_like_write_en[0x1];
+	u8         latency_sensitive[0x1];
+	u8         rlky[0x1];
+	u8         free_ar[0x1];
+	u8         reserved_4[0xd];
+
+	u8         reserved_5[0x8];
+	u8         cs_res[0x8];
+	u8         reserved_6[0x3];
+	u8         min_rnr_nak[0x5];
+	u8         reserved_7[0x8];
+
+	u8         reserved_8[0x8];
+	u8         srqn[0x18];
+
+	u8         reserved_9[0x8];
+	u8         pd[0x18];
+
+	u8         tclass[0x8];
+	u8         reserved_10[0x4];
+	u8         flow_label[0x14];
+
+	u8         dc_access_key[0x40];
+
+	u8         reserved_11[0x5];
+	u8         mtu[0x3];
+	u8         port[0x8];
+	u8         pkey_index[0x10];
+
+	u8         reserved_12[0x8];
+	u8         my_addr_index[0x8];
+	u8         reserved_13[0x8];
+	u8         hop_limit[0x8];
+
+	u8         dc_access_key_violation_count[0x20];
+
+	u8         reserved_14[0x14];
+	u8         dei_cfi[0x1];
+	u8         eth_prio[0x3];
+	u8         ecn[0x2];
+	u8         dscp[0x6];
+
+	u8         reserved_15[0x40];
+};
+
+struct mlx5_ifc_create_dct_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_0[0x10];
+
+	u8         reserved_1[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_2[0x40];
+
+	struct mlx5_ifc_dctc_bits dct_context_entry;
+
+	u8         reserved_3[0x180];
+};
+
+struct mlx5_ifc_drain_dct_out_bits {
+	u8         status[0x8];
+	u8         reserved_0[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_1[0x40];
+};
+
+struct mlx5_ifc_drain_dct_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_0[0x10];
+
+	u8         reserved_1[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_2[0x8];
+	u8         dct_number[0x18];
+
+	u8         reserved_3[0x20];
+};
+
+struct mlx5_ifc_destroy_dct_out_bits {
+	u8         status[0x8];
+	u8         reserved_0[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_1[0x40];
+};
+
+struct mlx5_ifc_destroy_dct_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_0[0x10];
+
+	u8         reserved_1[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_2[0x8];
+	u8         dct_number[0x18];
+
+	u8         reserved_3[0x20];
+};
+
+struct mlx5_ifc_query_dct_out_bits {
+	u8         status[0x8];
+	u8         reserved_0[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_1[0x40];
+
+	struct mlx5_ifc_dctc_bits dct_context_entry;
+
+	u8         reserved_2[0x180];
+};
+
+struct mlx5_ifc_query_dct_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_0[0x10];
+
+	u8         reserved_1[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_2[0x8];
+	u8         dct_number[0x18];
+
+	u8         reserved_3[0x20];
+};
+
+struct mlx5_ifc_arm_dct_out_bits {
+	u8         status[0x8];
+	u8         reserved_0[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_1[0x40];
+};
+
+struct mlx5_ifc_arm_dct_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_0[0x10];
+
+	u8         reserved_1[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_2[0x8];
+	u8         dct_number[0x18];
+
+	u8         reserved_3[0x20];
+};
+
 #endif /* MLX5_IFC_H */
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 3fa075daeb1d..094160d59d99 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -91,8 +91,7 @@ enum {
 	MLX5_QP_ST_UD				= 0x2,
 	MLX5_QP_ST_XRC				= 0x3,
 	MLX5_QP_ST_MLX				= 0x4,
-	MLX5_QP_ST_DCI				= 0x5,
-	MLX5_QP_ST_DCT				= 0x6,
+	MLX5_QP_ST_DC				= 0x5,
 	MLX5_QP_ST_QP0				= 0x7,
 	MLX5_QP_ST_QP1				= 0x8,
 	MLX5_QP_ST_RAW_ETHERTYPE		= 0x9,
@@ -130,6 +129,12 @@ enum {
 };
 
 enum {
+	MLX5_DCT_BIT_RRE	= 1 << 19,
+	MLX5_DCT_BIT_RWE	= 1 << 18,
+	MLX5_DCT_BIT_RAE	= 1 << 17,
+};
+
+enum {
 	MLX5_WQE_CTRL_CQ_UPDATE		= 2 << 2,
 	MLX5_WQE_CTRL_SOLICITED		= 1 << 1,
 };
@@ -160,6 +165,12 @@ enum {
 };
 
 enum {
+	MLX5_DCT_STATE_ACTIVE	= 0,
+	MLX5_DCT_STATE_DRAINING	= 1,
+	MLX5_DCT_STATE_DRAINED	= 2
+};
+
+enum {
 	MLX5_RCV_DBR	= 0,
 	MLX5_SND_DBR	= 1,
 };
@@ -547,8 +558,20 @@ int mlx5_core_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn);
 int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn);
 void mlx5_init_qp_table(struct mlx5_core_dev *dev);
 void mlx5_cleanup_qp_table(struct mlx5_core_dev *dev);
+void mlx5_init_dct_table(struct mlx5_core_dev *dev);
+void mlx5_cleanup_dct_table(struct mlx5_core_dev *dev);
 int mlx5_debug_qp_add(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
 void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
+int mlx5_core_create_dct(struct mlx5_core_dev *dev,
+			 struct mlx5_core_dct *dct,
+			 void *in);
+int mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
+			  struct mlx5_core_dct *dct);
+int mlx5_core_dct_query(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct,
+			void *out);
+int mlx5_core_arm_dct(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct);
+int mlx5_debug_dct_add(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct);
+void mlx5_debug_dct_remove(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct);
 
 static inline const char *mlx5_qp_type_str(int type)
 {
@@ -595,4 +618,16 @@ static inline const char *mlx5_qp_state_str(int state)
 	}
 }
 
+static inline const char *mlx5_dct_state_str(int state)
+{
+	switch (state) {
+	case MLX5_DCT_STATE_ACTIVE:
+		return "ACTIVE";
+	case MLX5_DCT_STATE_DRAINING:
+		return "DRAINING";
+	case MLX5_DCT_STATE_DRAINED:
+		return "DRAINED";
+	default: return "Invalid DCT state";
+	}
+}
 #endif /* MLX5_QP_H */
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

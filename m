From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 10/14] net/mlx5_core: Improve debugfs readability
Date: Tue, 14 Jan 2014 17:45:19 +0200
Message-ID: <1389714323-20130-11-git-send-email-eli@mellanox.com>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389714323-20130-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use strings to display transport service or state of QPs. Use numerical value
for MTU of a QP.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 39 +++++++++++++++++---
 include/linux/mlx5/qp.h                           | 45 +++++++++++++++++++++++
 2 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 80f6d12..10e1f1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -275,7 +275,7 @@ void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev)
 }
 
 static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
-			 int index)
+			 int index, int *is_str)
 {
 	struct mlx5_query_qp_mbox_out *out;
 	struct mlx5_qp_context *ctx;
@@ -293,19 +293,40 @@ static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 		goto out;
 	}
 
+	*is_str = 0;
 	ctx = &out->ctx;
 	switch (index) {
 	case QP_PID:
 		param = qp->pid;
 		break;
 	case QP_STATE:
-		param = be32_to_cpu(ctx->flags) >> 28;
+		param = (u64)mlx5_qp_state_str(be32_to_cpu(ctx->flags) >> 28);
+		*is_str = 1;
 		break;
 	case QP_XPORT:
-		param = (be32_to_cpu(ctx->flags) >> 16) & 0xff;
+		param = (u64)mlx5_qp_type_str((be32_to_cpu(ctx->flags) >> 16) & 0xff);
+		*is_str = 1;
 		break;
 	case QP_MTU:
-		param = ctx->mtu_msgmax >> 5;
+		switch (ctx->mtu_msgmax >> 5) {
+		case IB_MTU_256:
+			param = 256;
+			break;
+		case IB_MTU_512:
+			param = 512;
+			break;
+		case IB_MTU_1024:
+			param = 1024;
+			break;
+		case IB_MTU_2048:
+			param = 2048;
+			break;
+		case IB_MTU_4096:
+			param = 4096;
+			break;
+		default:
+			param = 0;
+		}
 		break;
 	case QP_N_RECV:
 		param = 1 << ((ctx->rq_size_stride >> 3) & 0xf);
@@ -414,6 +435,7 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 	struct mlx5_field_desc *desc;
 	struct mlx5_rsc_debug *d;
 	char tbuf[18];
+	int is_str = 0;
 	u64 field;
 	int ret;
 
@@ -424,7 +446,7 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 	d = (void *)(desc - desc->i) - sizeof(*d);
 	switch (d->type) {
 	case MLX5_DBG_RSC_QP:
-		field = qp_read_field(d->dev, d->object, desc->i);
+		field = qp_read_field(d->dev, d->object, desc->i, &is_str);
 		break;
 
 	case MLX5_DBG_RSC_EQ:
@@ -440,7 +462,12 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 		return -EINVAL;
 	}
 
-	ret = snprintf(tbuf, sizeof(tbuf), "0x%llx\n", field);
+
+	if (is_str)
+		ret = snprintf(tbuf, sizeof(tbuf), "%s\n", (const char *)field);
+	else
+		ret = snprintf(tbuf, sizeof(tbuf), "0x%llx\n", field);
+
 	if (ret > 0) {
 		if (copy_to_user(buf, tbuf, ret))
 			return -EFAULT;
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index d9e3eac..d51eff7 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -464,4 +464,49 @@ void mlx5_cleanup_qp_table(struct mlx5_core_dev *dev);
 int mlx5_debug_qp_add(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
 void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
 
+static inline const char *mlx5_qp_type_str(int type)
+{
+	switch (type) {
+	case MLX5_QP_ST_RC: return "RC";
+	case MLX5_QP_ST_UC: return "C";
+	case MLX5_QP_ST_UD: return "UD";
+	case MLX5_QP_ST_XRC: return "XRC";
+	case MLX5_QP_ST_MLX: return "MLX";
+	case MLX5_QP_ST_QP0: return "QP0";
+	case MLX5_QP_ST_QP1: return "QP1";
+	case MLX5_QP_ST_RAW_ETHERTYPE: return "RAW_ETHERTYPE";
+	case MLX5_QP_ST_RAW_IPV6: return "RAW_IPV6";
+	case MLX5_QP_ST_SNIFFER: return "SNIFFER";
+	case MLX5_QP_ST_SYNC_UMR: return "SYNC_UMR";
+	case MLX5_QP_ST_PTP_1588: return "PTP_1588";
+	case MLX5_QP_ST_REG_UMR: return "REG_UMR";
+	default: return "Invalid transport type";
+	}
+}
+
+static inline const char *mlx5_qp_state_str(int state)
+{
+	switch (state) {
+	case MLX5_QP_STATE_RST:
+	return "RST";
+	case MLX5_QP_STATE_INIT:
+	return "INIT";
+	case MLX5_QP_STATE_RTR:
+	return "RTR";
+	case MLX5_QP_STATE_RTS:
+	return "RTS";
+	case MLX5_QP_STATE_SQER:
+	return "SQER";
+	case MLX5_QP_STATE_SQD:
+	return "SQD";
+	case MLX5_QP_STATE_ERR:
+	return "ERR";
+	case MLX5_QP_STATE_SQ_DRAINING:
+	return "SQ_DRAINING";
+	case MLX5_QP_STATE_SUSPENDED:
+	return "SUSPENDED";
+	default: return "Invalid QP state";
+	}
+}
+
 #endif /* MLX5_QP_H */
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

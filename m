From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 04/10] mlx5: Add support to tag matching SRQ type
Date: Mon, 23 Oct 2017 16:17:55 +0300
Message-ID: <1508764681-4531-5-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Create command QP for a tag-matching SRQ.  Command QP used for
inserting/removing entries from the tag matching list. This command QP
is hidden from the users in the mlx5_srq structure.
New verb ibv_post_srq_ops() will be added in next patch to use it.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.h  |   1 +
 providers/mlx5/verbs.c | 140 +++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 124 insertions(+), 17 deletions(-)

diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 46fce28..d16b5f5 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -360,6 +360,7 @@ struct mlx5_srq {
 	__be32			       *db;
 	uint16_t			counter;
 	int				wq_sig;
+	struct ibv_qp		       *cmd_qp;
 };
 
 struct wr_list {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 2315a0d..a26b631 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -739,6 +739,13 @@ int mlx5_destroy_srq(struct ibv_srq *srq)
 	struct mlx5_srq *msrq = to_msrq(srq);
 	struct mlx5_context *ctx = to_mctx(srq->context);
 
+	if (msrq->cmd_qp) {
+		ret = mlx5_destroy_qp(msrq->cmd_qp);
+		if (ret)
+			return ret;
+		msrq->cmd_qp = NULL;
+	}
+
 	ret = ibv_cmd_destroy_srq(srq);
 	if (ret)
 		return ret;
@@ -1822,9 +1829,94 @@ int mlx5_close_xrcd(struct ibv_xrcd *ib_xrcd)
 	return ret;
 }
 
-static struct ibv_srq *
-mlx5_create_xrc_srq(struct ibv_context *context,
-		    struct ibv_srq_init_attr_ex *attr)
+static struct ibv_qp *
+create_cmd_qp(struct ibv_context *context,
+	      struct ibv_srq_init_attr_ex *srq_attr,
+	      struct ibv_srq *srq)
+{
+	struct ibv_qp_init_attr_ex init_attr = {};
+	FILE *fp = to_mctx(context)->dbg_fp;
+	struct ibv_port_attr port_attr;
+	struct ibv_modify_qp qcmd = {};
+	struct ibv_qp_attr attr = {};
+	struct ibv_query_port pcmd;
+	struct ibv_qp *qp;
+	int attr_mask;
+	int port = 1;
+	int ret;
+
+	ret = ibv_cmd_query_port(context, port, &port_attr,
+				 &pcmd, sizeof(pcmd));
+	if (ret) {
+		mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
+		return NULL;
+	}
+
+	init_attr.qp_type = IBV_QPT_RC;
+	init_attr.srq = srq;
+	/* Command QP will be used to pass MLX5_OPCODE_TAG_MATCHING messages
+	 * to add/remove tag matching list entries.
+	 * WQ size is based on max_ops parameter holding max number of
+	 * outstanding list operations.
+	 */
+	init_attr.cap.max_send_wr = srq_attr->tm_cap.max_ops;
+	/* Tag matching list entry will point to a single sge buffer */
+	init_attr.cap.max_send_sge = 1;
+	init_attr.comp_mask = IBV_QP_INIT_ATTR_PD;
+	init_attr.pd = srq_attr->pd;
+	init_attr.send_cq = srq_attr->cq;
+	init_attr.recv_cq = srq_attr->cq;
+
+	qp = create_qp(context, &init_attr);
+	if (!qp)
+		return NULL;
+
+	attr.qp_state = IBV_QPS_INIT;
+	attr.port_num = port;
+	attr_mask = IBV_QP_STATE | IBV_QP_PKEY_INDEX
+		  | IBV_QP_PORT | IBV_QP_ACCESS_FLAGS;
+
+	ret = ibv_cmd_modify_qp(qp, &attr, attr_mask, &qcmd, sizeof(qcmd));
+	if (ret) {
+		mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
+		goto err;
+	}
+
+	attr.qp_state = IBV_QPS_RTR;
+	attr.path_mtu = IBV_MTU_256;
+	attr.dest_qp_num = qp->qp_num; /* Loopback */
+	attr.ah_attr.dlid = port_attr.lid;
+	attr.ah_attr.port_num = port;
+	attr_mask = IBV_QP_STATE | IBV_QP_AV | IBV_QP_PATH_MTU
+		  | IBV_QP_DEST_QPN | IBV_QP_RQ_PSN
+		  | IBV_QP_MAX_DEST_RD_ATOMIC | IBV_QP_MIN_RNR_TIMER;
+
+	ret = ibv_cmd_modify_qp(qp, &attr, attr_mask, &qcmd, sizeof(qcmd));
+	if (ret) {
+		mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
+		goto err;
+	}
+
+	attr.qp_state = IBV_QPS_RTS;
+	attr_mask = IBV_QP_STATE | IBV_QP_TIMEOUT | IBV_QP_RETRY_CNT
+		  | IBV_QP_RNR_RETRY | IBV_QP_SQ_PSN
+		  | IBV_QP_MAX_QP_RD_ATOMIC;
+
+	ret = ibv_cmd_modify_qp(qp, &attr, attr_mask, &qcmd, sizeof(qcmd));
+	if (ret) {
+		mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
+		goto err;
+	}
+
+	return qp;
+
+err:
+	mlx5_destroy_qp(qp);
+	return NULL;
+}
+
+struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
+				   struct ibv_srq_init_attr_ex *attr)
 {
 	int err;
 	struct mlx5_create_srq_ex cmd;
@@ -1836,6 +1928,24 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 	int uidx;
 	FILE *fp = ctx->dbg_fp;
 
+	if (!(attr->comp_mask & IBV_SRQ_INIT_ATTR_TYPE) ||
+	    (attr->srq_type == IBV_SRQT_BASIC))
+		return mlx5_create_srq(attr->pd,
+				       (struct ibv_srq_init_attr *)attr);
+
+	if (attr->srq_type != IBV_SRQT_XRC &&
+	    attr->srq_type != IBV_SRQT_TM) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	/* An extended CQ is required to read TM information from */
+	if (attr->srq_type == IBV_SRQT_TM &&
+	    !(attr->cq && (to_mcq(attr->cq)->flags & MLX5_CQ_FLAGS_EXTENDED))) {
+		errno = EINVAL;
+		return NULL;
+	}
+
 	msrq = calloc(1, sizeof(*msrq));
 	if (!msrq)
 		return NULL;
@@ -1914,10 +2024,16 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 	if (err)
 		goto err_free_uidx;
 
+	if (attr->srq_type == IBV_SRQT_TM) {
+		msrq->cmd_qp = create_cmd_qp(context, attr, ibsrq);
+		if (!msrq->cmd_qp)
+			goto err_destroy;
+	}
+
 	if (!ctx->cqe_version) {
 		err = mlx5_store_srq(to_mctx(context), resp.srqn, msrq);
 		if (err)
-			goto err_destroy;
+			goto err_free_cmd;
 
 		pthread_mutex_unlock(&ctx->srq_table_mutex);
 	}
@@ -1928,6 +2044,9 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 
 	return ibsrq;
 
+err_free_cmd:
+	if (msrq->cmd_qp)
+		mlx5_destroy_qp(msrq->cmd_qp);
 err_destroy:
 	ibv_cmd_destroy_srq(ibsrq);
 
@@ -1950,19 +2069,6 @@ err:
 	return NULL;
 }
 
-struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
-				   struct ibv_srq_init_attr_ex *attr)
-{
-	if (!(attr->comp_mask & IBV_SRQ_INIT_ATTR_TYPE) ||
-	    (attr->srq_type == IBV_SRQT_BASIC))
-		return mlx5_create_srq(attr->pd,
-				       (struct ibv_srq_init_attr *)attr);
-	else if (attr->srq_type == IBV_SRQT_XRC)
-		return mlx5_create_xrc_srq(context, attr);
-
-	return NULL;
-}
-
 int mlx5_query_device_ex(struct ibv_context *context,
 			 const struct ibv_query_device_ex_input *input,
 			 struct ibv_device_attr_ex *attr,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

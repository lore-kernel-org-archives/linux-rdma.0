From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/6] mlx4: Add support for RSS QP
Date: Tue, 12 Sep 2017 15:53:06 +0300
Message-ID: <1505220788-23849-5-git-send-email-yishaih@mellanox.com>
References: <1505220788-23849-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505220788-23849-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support to work with a RSS QP by using an indirection table
object and RX Hash attributes as a driver data upon QP creation.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4-abi.h |  14 ++++++
 providers/mlx4/mlx4.h     |   6 +++
 providers/mlx4/verbs.c    | 106 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+)

diff --git a/providers/mlx4/mlx4-abi.h b/providers/mlx4/mlx4-abi.h
index 1cf6d5b..4f2132c 100644
--- a/providers/mlx4/mlx4-abi.h
+++ b/providers/mlx4/mlx4-abi.h
@@ -141,6 +141,20 @@ struct mlx4_create_qp {
 	__u32				inl_recv_sz;
 };
 
+struct mlx4_create_qp_drv_ex_rss {
+	__u64		hash_fields_mask; /* enum ibv_rx_hash_fields */
+	__u8		hash_function; /* enum ibv_rx_hash_function_flags */
+	__u8		reserved[7];
+	__u8		hash_key[40];
+	__u32		comp_mask;
+	__u32		reserved1;
+};
+
+struct mlx4_create_qp_ex_rss {
+	struct ibv_create_qp_ex		 ibv_cmd;
+	struct mlx4_create_qp_drv_ex_rss drv_ex;
+};
+
 struct mlx4_create_qp_drv_ex {
 	__u64		buf_addr;
 	__u64		db_addr;
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 13a561f..83dd551 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -198,6 +198,11 @@ struct mlx4_wq {
 	int				offset;
 };
 
+enum mlx4_rsc_type {
+	MLX4_RSC_TYPE_QP	= 0,
+	MLX4_RSC_TYPE_RSS_QP	= 1,
+};
+
 struct mlx4_qp {
 	union {
 		struct verbs_qp		verbs_qp;
@@ -216,6 +221,7 @@ struct mlx4_qp {
 	struct mlx4_wq			rq;
 
 	uint8_t				link_layer;
+	uint8_t				type; /* enum mlx4_rsc_type */
 	uint32_t			qp_cap_cache;
 };
 
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 369f437..5f2266a 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -745,6 +745,70 @@ int mlx4_destroy_srq(struct ibv_srq *srq)
 	return 0;
 }
 
+static int mlx4_cmd_create_qp_ex_rss(struct ibv_context *context,
+				     struct ibv_qp_init_attr_ex *attr,
+				     struct mlx4_create_qp *cmd,
+				     struct mlx4_qp *qp)
+{
+	struct mlx4_create_qp_ex_rss cmd_ex = {};
+	struct mlx4_create_qp_resp_ex resp;
+	int ret;
+
+	if (attr->rx_hash_conf.rx_hash_key_len !=
+	    sizeof(cmd_ex.drv_ex.hash_key)) {
+		errno = ENOTSUP;
+		return errno;
+	}
+
+	cmd_ex.drv_ex.hash_fields_mask =
+		attr->rx_hash_conf.rx_hash_fields_mask;
+	cmd_ex.drv_ex.hash_function =
+		attr->rx_hash_conf.rx_hash_function;
+	memcpy(cmd_ex.drv_ex.hash_key, attr->rx_hash_conf.rx_hash_key,
+	       sizeof(cmd_ex.drv_ex.hash_key));
+
+	ret = ibv_cmd_create_qp_ex2(context, &qp->verbs_qp,
+				    sizeof(qp->verbs_qp), attr,
+				    &cmd_ex.ibv_cmd, sizeof(cmd_ex.ibv_cmd),
+				    sizeof(cmd_ex), &resp.ibv_resp,
+				    sizeof(resp.ibv_resp), sizeof(resp));
+	return ret;
+}
+
+static struct ibv_qp *_mlx4_create_qp_ex_rss(struct ibv_context *context,
+					     struct ibv_qp_init_attr_ex *attr)
+{
+	struct mlx4_create_qp cmd = {};
+	struct mlx4_qp *qp;
+	int ret;
+
+	if (!(attr->comp_mask & IBV_QP_INIT_ATTR_RX_HASH) ||
+	    !(attr->comp_mask & IBV_QP_INIT_ATTR_IND_TABLE))
+		return NULL;
+
+	if (attr->qp_type != IBV_QPT_RAW_PACKET)
+		return NULL;
+
+	qp = calloc(1, sizeof(*qp));
+	if (!qp)
+		return NULL;
+
+	if (pthread_spin_init(&qp->sq.lock, PTHREAD_PROCESS_PRIVATE) ||
+	    pthread_spin_init(&qp->rq.lock, PTHREAD_PROCESS_PRIVATE))
+		goto err;
+
+	ret = mlx4_cmd_create_qp_ex_rss(context, attr, &cmd, qp);
+	if (ret)
+		goto err;
+
+	qp->type = MLX4_RSC_TYPE_RSS_QP;
+
+	return &qp->verbs_qp.qp;
+err:
+	free(qp);
+	return NULL;
+}
+
 static int mlx4_cmd_create_qp_ex(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr,
 				 struct mlx4_create_qp *cmd,
@@ -792,6 +856,11 @@ static struct ibv_qp *create_qp_ex(struct ibv_context *context,
 	struct mlx4_qp		 *qp;
 	int			  ret;
 
+	if (attr->comp_mask & (IBV_QP_INIT_ATTR_RX_HASH |
+			       IBV_QP_INIT_ATTR_IND_TABLE)) {
+		return _mlx4_create_qp_ex_rss(context, attr);
+	}
+
 	/* Sanity check QP size before proceeding */
 	if (ctx->max_qp_wr) { /* mlx4_query_device succeeded */
 		if (attr->cap.max_send_wr  > ctx->max_qp_wr ||
@@ -987,6 +1056,9 @@ int mlx4_query_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 	struct mlx4_qp *qp = to_mqp(ibqp);
 	int ret;
 
+	if (qp->type == MLX4_RSC_TYPE_RSS_QP)
+		return ENOTSUP;
+
 	ret = ibv_cmd_query_qp(ibqp, attr, attr_mask, init_attr, &cmd, sizeof cmd);
 	if (ret)
 		return ret;
@@ -1000,6 +1072,20 @@ int mlx4_query_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 	return 0;
 }
 
+static int _mlx4_modify_qp_rss(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+			       int attr_mask)
+{
+	struct ibv_modify_qp cmd = {};
+
+	if (attr_mask & ~(IBV_QP_STATE | IBV_QP_PORT))
+		return ENOTSUP;
+
+	if (attr->qp_state > IBV_QPS_RTR)
+		return ENOTSUP;
+
+	return ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof(cmd));
+}
+
 int mlx4_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		    int attr_mask)
 {
@@ -1009,6 +1095,9 @@ int mlx4_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	struct ibv_device_attr device_attr;
 	int ret;
 
+	if (mqp->type == MLX4_RSC_TYPE_RSS_QP)
+		return _mlx4_modify_qp_rss(qp, attr, attr_mask);
+
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (attr_mask & IBV_QP_PORT) {
 		ret = ibv_query_port(qp->context, attr->port_num,
@@ -1108,11 +1197,28 @@ static void mlx4_unlock_cqs(struct ibv_qp *qp)
 	}
 }
 
+static int _mlx4_destroy_qp_rss(struct ibv_qp *ibqp)
+{
+	struct mlx4_qp *qp = to_mqp(ibqp);
+	int ret;
+
+	ret = ibv_cmd_destroy_qp(ibqp);
+	if (ret && !cleanup_on_fatal(ret))
+		return ret;
+
+	free(qp);
+
+	return 0;
+}
+
 int mlx4_destroy_qp(struct ibv_qp *ibqp)
 {
 	struct mlx4_qp *qp = to_mqp(ibqp);
 	int ret;
 
+	if (qp->type == MLX4_RSC_TYPE_RSS_QP)
+		return _mlx4_destroy_qp_rss(ibqp);
+
 	pthread_mutex_lock(&to_mctx(ibqp->context)->qp_table_mutex);
 	ret = ibv_cmd_destroy_qp(ibqp);
 	if (ret && !cleanup_on_fatal(ret)) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

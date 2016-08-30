From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 3/5] Add RSS QP support
Date: Tue, 30 Aug 2016 18:38:41 +0300
Message-ID: <1472571523-12067-4-git-send-email-yishaih@mellanox.com>
References: <1472571523-12067-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472571523-12067-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add RSS QP support, it includes:
- Detect the request based on input comp_mask.
- Use the vendor channel to pass RX hashing configuration.
- Return an error upon query/modify of such a QP.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h | 11 +++++++++++
 src/mlx5.h     |  1 +
 src/verbs.c    | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 74acfd3..90f998e 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -149,6 +149,17 @@ struct mlx5_create_qp_ex {
 	struct mlx5_create_qp_drv_ex drv_ex;
 };
 
+struct mlx5_create_qp_ex_rss {
+	struct ibv_create_qp_ex	ibv_cmd;
+	__u64 rx_hash_fields_mask; /* enum ibv_rx_hash_fields */
+	__u8 rx_hash_function; /* enum ibv_rx_hash_function_flags */
+	__u8 rx_key_len;
+	__u8 reserved[6];
+	__u8 rx_hash_key[128];
+	__u32   comp_mask;
+	__u32   reserved1;
+};
+
 struct mlx5_create_qp_resp_ex {
 	struct ibv_create_qp_resp_ex	ibv_resp;
 	__u32				uuar_index;
diff --git a/src/mlx5.h b/src/mlx5.h
index e51d67f..40817d8 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -497,6 +497,7 @@ struct mlx5_qp {
 	int				atomics_enabled;
 	uint32_t			max_tso;
 	uint16_t			max_tso_header;
+	int                             rss_qp;
 };
 
 struct mlx5_av {
diff --git a/src/verbs.c b/src/verbs.c
index 10b8190..a80d377 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1128,6 +1128,37 @@ static void mlx5_free_qp_buf(struct mlx5_qp *qp)
 		free(qp->sq.wr_data);
 }
 
+static int mlx5_cmd_create_rss_qp(struct ibv_context *context,
+				 struct ibv_qp_init_attr_ex *attr,
+				 struct mlx5_qp *qp)
+{
+	struct mlx5_create_qp_ex_rss cmd_ex_rss = {};
+	struct mlx5_create_qp_resp_ex resp = {};
+	int ret;
+
+	if (attr->rx_hash_conf.rx_hash_key_len > sizeof(cmd_ex_rss.rx_hash_key)) {
+		errno = EINVAL;
+		return errno;
+	}
+
+	cmd_ex_rss.rx_hash_fields_mask = attr->rx_hash_conf.rx_hash_fields_mask;
+	cmd_ex_rss.rx_hash_function = attr->rx_hash_conf.rx_hash_function;
+	cmd_ex_rss.rx_key_len = attr->rx_hash_conf.rx_hash_key_len;
+	memcpy(cmd_ex_rss.rx_hash_key, attr->rx_hash_conf.rx_hash_key,
+			attr->rx_hash_conf.rx_hash_key_len);
+
+	ret = ibv_cmd_create_qp_ex2(context, &qp->verbs_qp,
+					    sizeof(qp->verbs_qp), attr,
+					    &cmd_ex_rss.ibv_cmd, sizeof(cmd_ex_rss.ibv_cmd),
+					    sizeof(cmd_ex_rss), &resp.ibv_resp,
+					    sizeof(resp.ibv_resp), sizeof(resp));
+	if (ret)
+		return ret;
+
+	qp->rss_qp = 1;
+	return 0;
+}
+
 static int mlx5_cmd_create_qp_ex(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr,
 				 struct mlx5_create_qp *cmd,
@@ -1160,12 +1191,16 @@ enum {
 	MLX5_CREATE_QP_SUP_COMP_MASK = (IBV_QP_INIT_ATTR_PD |
 					IBV_QP_INIT_ATTR_XRCD |
 					IBV_QP_INIT_ATTR_CREATE_FLAGS |
-					IBV_QP_INIT_ATTR_MAX_TSO_HEADER),
+					IBV_QP_INIT_ATTR_MAX_TSO_HEADER |
+					IBV_QP_INIT_ATTR_IND_TABLE |
+					IBV_QP_INIT_ATTR_RX_HASH),
 };
 
 enum {
 	MLX5_CREATE_QP_EX2_COMP_MASK = (IBV_QP_INIT_ATTR_CREATE_FLAGS |
-					IBV_QP_INIT_ATTR_MAX_TSO_HEADER),
+					IBV_QP_INIT_ATTR_MAX_TSO_HEADER |
+					IBV_QP_INIT_ATTR_IND_TABLE |
+					IBV_QP_INIT_ATTR_RX_HASH),
 };
 
 struct ibv_qp *create_qp(struct ibv_context *context,
@@ -1203,6 +1238,14 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	memset(&resp, 0, sizeof(resp));
 	memset(&resp_ex, 0, sizeof(resp_ex));
 
+	if (attr->comp_mask & IBV_QP_INIT_ATTR_RX_HASH) {
+		ret = mlx5_cmd_create_rss_qp(context, attr, qp);
+		if (ret)
+			goto err;
+
+		return ibqp;
+	}
+
 	qp->wq_sig = qp_sig_enabled();
 	if (qp->wq_sig)
 		cmd.flags |= MLX5_QP_FLAG_SIGNATURE;
@@ -1410,6 +1453,13 @@ int mlx5_destroy_qp(struct ibv_qp *ibqp)
 	struct mlx5_context *ctx = to_mctx(ibqp->context);
 	int ret;
 
+	if (qp->rss_qp) {
+		ret = ibv_cmd_destroy_qp(ibqp);
+		if (ret)
+			return ret;
+		goto free;
+	}
+
 	if (!ctx->cqe_version)
 		pthread_mutex_lock(&ctx->qp_table_mutex);
 
@@ -1440,6 +1490,7 @@ int mlx5_destroy_qp(struct ibv_qp *ibqp)
 
 	mlx5_free_db(ctx, qp->db);
 	mlx5_free_qp_buf(qp);
+free:
 	free(qp);
 
 	return 0;
@@ -1452,6 +1503,9 @@ int mlx5_query_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 	struct mlx5_qp *qp = to_mqp(ibqp);
 	int ret;
 
+	if (qp->rss_qp)
+		return ENOSYS;
+
 	ret = ibv_cmd_query_qp(ibqp, attr, attr_mask, init_attr, &cmd, sizeof(cmd));
 	if (ret)
 		return ret;
@@ -1474,6 +1528,9 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	int ret;
 	uint32_t *db;
 
+	if (mqp->rss_qp)
+		return ENOSYS;
+
 	if (attr_mask & IBV_QP_PORT) {
 		switch (qp->qp_type) {
 		case IBV_QPT_RAW_PACKET:
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

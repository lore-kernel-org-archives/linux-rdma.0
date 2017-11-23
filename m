From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/3] mlx5: Add tunnel offloads support in direct verbs
Date: Thu, 23 Nov 2017 15:53:25 +0200
Message-ID: <1511445206-18951-3-git-send-email-yishaih@mellanox.com>
References: <1511445206-18951-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511445206-18951-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to enable offloading such as checksum and LRO for incoming
tunneling traffic, the QP should be created with tunnel offloads flag -
MLX5DV_QP_CREATE_TUNNEL_OFFLOAD.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/ibverbs-providers.symbols |  1 +
 providers/mlx5/libmlx5.map       |  1 +
 providers/mlx5/mlx5-abi.h        |  3 ++-
 providers/mlx5/mlx5dv.h          | 17 +++++++++++++
 providers/mlx5/verbs.c           | 52 +++++++++++++++++++++++++++++++++++-----
 5 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index 08ff906..b95d59c 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -15,3 +15,4 @@ libmlx5.so.1 ibverbs-providers #MINVER#
  mlx5dv_create_cq@MLX5_1.1 14
  mlx5dv_set_context_attr@MLX5_1.2 15
  mlx5dv_create_wq@MLX5_1.3 16
+ mlx5dv_create_qp@MLX5_1.3 16
diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
index b1402dc..1dfb4f7 100644
--- a/providers/mlx5/libmlx5.map
+++ b/providers/mlx5/libmlx5.map
@@ -21,4 +21,5 @@ MLX5_1.2 {
 MLX5_1.3 {
 	global:
 		mlx5dv_create_wq;
+		mlx5dv_create_qp;
 } MLX5_1.2;
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index e1aa618..b0b6704 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -43,6 +43,7 @@
 enum {
 	MLX5_QP_FLAG_SIGNATURE		= 1 << 0,
 	MLX5_QP_FLAG_SCATTER_CQE	= 1 << 1,
+	MLX5_QP_FLAG_TUNNEL_OFFLOADS	= 1 << 2,
 };
 
 enum {
@@ -182,7 +183,7 @@ struct mlx5_create_qp_ex_rss {
 	__u8 reserved[6];
 	__u8 rx_hash_key[128];
 	__u32   comp_mask;
-	__u32   reserved1;
+	__u32   create_flags;
 };
 
 struct mlx5_create_qp_resp_ex {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 9a30546..95a1697 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -126,6 +126,23 @@ struct mlx5dv_cq_init_attr {
 struct ibv_cq_ex *mlx5dv_create_cq(struct ibv_context *context,
 				   struct ibv_cq_init_attr_ex *cq_attr,
 				   struct mlx5dv_cq_init_attr *mlx5_cq_attr);
+
+enum mlx5dv_qp_create_flags {
+	MLX5DV_QP_CREATE_TUNNEL_OFFLOADS = 1 << 0,
+};
+
+enum mlx5dv_qp_init_attr_mask {
+	MLX5DV_QP_INIT_ATTR_MASK_QP_CREATE_FLAGS	= 1 << 0,
+};
+
+struct mlx5dv_qp_init_attr {
+	uint64_t comp_mask;	/* Use enum mlx5dv_qp_init_attr_mask */
+	uint32_t create_flags;	/* Use enum mlx5dv_qp_create_flags */
+};
+
+struct ibv_qp *mlx5dv_create_qp(struct ibv_context *context,
+				struct ibv_qp_init_attr_ex *qp_attr,
+				struct mlx5dv_qp_init_attr *mlx5_qp_attr);
 /*
  * Most device capabilities are exported by ibv_query_device(...),
  * but there is HW device-specific information which is important
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index d8ec300..7d36434 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1210,7 +1210,8 @@ static void mlx5_free_qp_buf(struct mlx5_qp *qp)
 
 static int mlx5_cmd_create_rss_qp(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr,
-				 struct mlx5_qp *qp)
+				 struct mlx5_qp *qp,
+				 uint32_t mlx5_create_flags)
 {
 	struct mlx5_create_qp_ex_rss cmd_ex_rss = {};
 	struct mlx5_create_qp_resp_ex resp = {};
@@ -1224,6 +1225,7 @@ static int mlx5_cmd_create_rss_qp(struct ibv_context *context,
 	cmd_ex_rss.rx_hash_fields_mask = attr->rx_hash_conf.rx_hash_fields_mask;
 	cmd_ex_rss.rx_hash_function = attr->rx_hash_conf.rx_hash_function;
 	cmd_ex_rss.rx_key_len = attr->rx_hash_conf.rx_hash_key_len;
+	cmd_ex_rss.create_flags = mlx5_create_flags;
 	memcpy(cmd_ex_rss.rx_hash_key, attr->rx_hash_conf.rx_hash_key,
 			attr->rx_hash_conf.rx_hash_key_len);
 
@@ -1277,6 +1279,10 @@ enum {
 };
 
 enum {
+	MLX5_DV_CREATE_QP_SUP_COMP_MASK = MLX5DV_QP_INIT_ATTR_MASK_QP_CREATE_FLAGS
+};
+
+enum {
 	MLX5_CREATE_QP_EX2_COMP_MASK = (IBV_QP_INIT_ATTR_CREATE_FLAGS |
 					IBV_QP_INIT_ATTR_MAX_TSO_HEADER |
 					IBV_QP_INIT_ATTR_IND_TABLE |
@@ -1284,7 +1290,8 @@ enum {
 };
 
 static struct ibv_qp *create_qp(struct ibv_context *context,
-			 struct ibv_qp_init_attr_ex *attr)
+				struct ibv_qp_init_attr_ex *attr,
+				struct mlx5dv_qp_init_attr *mlx5_qp_attr)
 {
 	struct mlx5_create_qp		cmd;
 	struct mlx5_create_qp_resp	resp;
@@ -1295,6 +1302,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 	struct ibv_qp		       *ibqp;
 	int32_t				usr_idx = 0;
 	uint32_t			uuar_index;
+	uint32_t			mlx5_create_flags = 0;
 	FILE *fp = ctx->dbg_fp;
 
 	if (attr->comp_mask & ~MLX5_CREATE_QP_SUP_COMP_MASK)
@@ -1327,14 +1335,39 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 	memset(&resp, 0, sizeof(resp));
 	memset(&resp_ex, 0, sizeof(resp_ex));
 
+	if (mlx5_qp_attr) {
+		if (!check_comp_mask(mlx5_qp_attr->comp_mask,
+				     MLX5_DV_CREATE_QP_SUP_COMP_MASK)) {
+			mlx5_dbg(fp, MLX5_DBG_QP,
+				 "Unsupported vendor comp_mask for create_qp\n");
+			errno = EINVAL;
+			goto err;
+		}
+
+		if (mlx5_qp_attr->comp_mask &
+		    MLX5DV_QP_INIT_ATTR_MASK_QP_CREATE_FLAGS) {
+			if (mlx5_qp_attr->create_flags &
+			    MLX5DV_QP_CREATE_TUNNEL_OFFLOADS) {
+				mlx5_create_flags = MLX5_QP_FLAG_TUNNEL_OFFLOADS;
+			} else {
+				mlx5_dbg(fp, MLX5_DBG_QP,
+					 "Unsupported creation flags requested for create_qp\n");
+				errno = EINVAL;
+				goto err;
+			}
+		}
+	}
+
 	if (attr->comp_mask & IBV_QP_INIT_ATTR_RX_HASH) {
-		ret = mlx5_cmd_create_rss_qp(context, attr, qp);
+		ret = mlx5_cmd_create_rss_qp(context, attr, qp,
+					     mlx5_create_flags);
 		if (ret)
 			goto err;
 
 		return ibqp;
 	}
 
+	cmd.flags = mlx5_create_flags;
 	qp->wq_sig = qp_sig_enabled();
 	if (qp->wq_sig)
 		cmd.flags |= MLX5_QP_FLAG_SIGNATURE;
@@ -1488,7 +1521,7 @@ struct ibv_qp *mlx5_create_qp(struct ibv_pd *pd,
 	memcpy(&attrx, attr, sizeof(*attr));
 	attrx.comp_mask = IBV_QP_INIT_ATTR_PD;
 	attrx.pd = pd;
-	qp = create_qp(pd->context, &attrx);
+	qp = create_qp(pd->context, &attrx, NULL);
 	if (qp)
 		memcpy(attr, &attrx, sizeof(*attr));
 
@@ -1825,7 +1858,14 @@ int mlx5_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid)
 struct ibv_qp *mlx5_create_qp_ex(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr)
 {
-	return create_qp(context, attr);
+	return create_qp(context, attr, NULL);
+}
+
+struct ibv_qp *mlx5dv_create_qp(struct ibv_context *context,
+				struct ibv_qp_init_attr_ex *qp_attr,
+				struct mlx5dv_qp_init_attr *mlx5_qp_attr)
+{
+	return create_qp(context, qp_attr, mlx5_qp_attr);
 }
 
 int mlx5_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num)
@@ -1910,7 +1950,7 @@ create_cmd_qp(struct ibv_context *context,
 	init_attr.send_cq = srq_attr->cq;
 	init_attr.recv_cq = srq_attr->cq;
 
-	qp = create_qp(context, &init_attr);
+	qp = create_qp(context, &init_attr, NULL);
 	if (!qp)
 		return NULL;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

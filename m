From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 4/4] mlx5: Destroy and modify a DC target QP
Date: Sun, 21 Jan 2018 18:16:59 +0200
Message-ID: <1516551419-12829-5-git-send-email-yishaih@mellanox.com>
References: <1516551419-12829-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516551419-12829-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Changes mlx5_destroy_qp() and mlx5_modify_qp() to handle DC target QP.

Since DCT QP is a software abstraction for a DC target hardware object
the flow to destroy and modify need a special treatment. When destroying
a DCT there are no resources that needs to be released besides the
memory that this QP takes.

Also, a DC target QP is created in hardware only when it is modified to
RTR. Therefore the QPN should be taken from the response of the command
to modify a QP and put in the software QP. For that we have to use the
interface that allows to get data from the vendor channel of the
response.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  6 ++++
 providers/mlx5/verbs.c    | 76 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 6d5793f..3e4207c 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -329,4 +329,10 @@ struct mlx5_query_device_ex_resp {
 	__u32				reserved;
 };
 
+struct mlx5_modify_qp_resp_ex {
+	struct ibv_modify_qp_resp_ex base;
+	__u32  response_length;
+	__u32  dctn;
+};
+
 #endif /* MLX5_ABI_H */
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 800a5e7..ff29b61 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1915,8 +1915,16 @@ int mlx5_destroy_qp(struct ibv_qp *ibqp)
 		__mlx5_cq_clean(to_mcq(ibqp->send_cq), qp->rsc.rsn, NULL);
 
 	if (!ctx->cqe_version) {
-		if (qp->sq.wqe_cnt || qp->rq.wqe_cnt)
-			mlx5_clear_qp(ctx, ibqp->qp_num);
+		if (qp->dc_type == MLX5DV_DCTYPE_DCT) {
+			/* The QP was inserted to the tracking table only after
+			 * that it was modifed to RTR
+			 */
+			if (ibqp->state == IBV_QPS_RTR)
+				mlx5_clear_qp(ctx, ibqp->qp_num);
+		} else {
+			if (qp->sq.wqe_cnt || qp->rq.wqe_cnt)
+				mlx5_clear_qp(ctx, ibqp->qp_num);
+		}
 	}
 
 	mlx5_unlock_cqs(ibqp);
@@ -1925,8 +1933,10 @@ int mlx5_destroy_qp(struct ibv_qp *ibqp)
 	else if (!is_xrc_tgt(ibqp->qp_type))
 		mlx5_clear_uidx(ctx, qp->rsc.rsn);
 
-	mlx5_free_db(ctx, qp->db);
-	mlx5_free_qp_buf(qp);
+	if (qp->dc_type != MLX5DV_DCTYPE_DCT) {
+		mlx5_free_db(ctx, qp->db);
+		mlx5_free_qp_buf(qp);
+	}
 free:
 	if (mparent_domain)
 		atomic_fetch_sub(&mparent_domain->mpd.refcount, 1);
@@ -1963,6 +1973,61 @@ enum {
 	MLX5_MODIFY_QP_EX_ATTR_MASK = IBV_QP_RATE_LIMIT,
 };
 
+static int modify_dct(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+		      int attr_mask)
+{
+	struct ibv_modify_qp_ex cmd_ex = {};
+	struct mlx5_modify_qp_resp_ex resp = {};
+	struct mlx5_qp *mqp = to_mqp(qp);
+	struct mlx5_context *context = to_mctx(qp->context);
+	int min_resp_size;
+	bool dct_create;
+	int ret;
+
+	ret = ibv_cmd_modify_qp_ex(qp, attr, attr_mask,
+				   &cmd_ex,
+				   sizeof(cmd_ex), sizeof(cmd_ex),
+				   &resp.base,
+				   sizeof(resp.base), sizeof(resp));
+	if (ret)
+		return ret;
+
+	/* dct is created in hardware and gets unique qp number when QP
+	 * is modified to RTR so operations that require QP number need
+	 * to be delayed to this time
+	 */
+	dct_create =
+		(attr_mask & IBV_QP_STATE) &&
+		(attr->qp_state == IBV_QPS_RTR);
+
+	if (!dct_create)
+		return 0;
+
+	min_resp_size =
+		offsetof(typeof(resp), dctn) +
+		sizeof(resp.dctn) -
+		sizeof(resp.base);
+
+	if (resp.response_length < min_resp_size) {
+		errno = EINVAL;
+		return errno;
+	}
+
+	qp->qp_num = resp.dctn;
+
+	if (!context->cqe_version) {
+		pthread_mutex_lock(&context->qp_table_mutex);
+		ret = mlx5_store_qp(context, qp->qp_num, mqp);
+		if (!ret)
+			mqp->rsc.rsn = qp->qp_num;
+		else
+			errno = ENOMEM;
+		pthread_mutex_unlock(&context->qp_table_mutex);
+		return ret ? errno : 0;
+	}
+	return 0;
+}
+
 int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		   int attr_mask)
 {
@@ -1974,6 +2039,9 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	int ret;
 	__be32 *db;
 
+	if (mqp->dc_type == MLX5DV_DCTYPE_DCT)
+		return modify_dct(qp, attr, attr_mask);
+
 	if (mqp->rss_qp)
 		return ENOSYS;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

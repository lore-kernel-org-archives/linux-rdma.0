From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 libmlx5 6/6] fix undefined uuar_index value assignment
Date: Wed, 27 Jul 2016 21:31:55 -0400
Message-ID: <1469669515-23720-1-git-send-email-jarod@redhat.com>
References: <1469647047-7544-7-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469647047-7544-7-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the case of (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK) being not
true, uuar_index gets set to resp.uuar_index, but nothing ever initializes
resp.uuar_index.

That said, both this case, and the true case, it looks like uuar_index
never gets assigned to anything but 0. In the true path, resp_ex gets
memset to 0, and then nothing ever sets uuar_index. Not sure what the
intended use was here, but ultimately, uuar_index is always going to be 0
with this patch (0 or undetermined garbage before).

Additionally, I'm not sure if the cmd and resp size parameters passed to
ibv_cmd_create_qp_ex() are correct, but they're at least larger than they
might be, which should be fine. I think. But I'm just guessing here.

v2: only check flag once, save to local var, memset() resp and resp_ex
accordingly within this function.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/verbs.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index d64e406..c68864a 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1098,7 +1098,6 @@ static int mlx5_cmd_create_qp_ex(struct ibv_context *context,
 	struct mlx5_create_qp_ex cmd_ex;
 	int ret;
 
-	memset(resp, 0, sizeof(*resp));
 	memset(&cmd_ex, 0, sizeof(cmd_ex));
 	memcpy(&cmd_ex.ibv_cmd.base, &cmd->ibv_cmd.user_handle,
 	       offsetof(typeof(cmd->ibv_cmd), is_srq) +
@@ -1140,6 +1139,7 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	struct ibv_qp		       *ibqp;
 	uint32_t			usr_idx = 0;
 	uint32_t			uuar_index;
+	uint8_t				use_ex2 = 0;
 #ifdef MLX5_DEBUG
 	FILE *fp = ctx->dbg_fp;
 #endif
@@ -1147,6 +1147,9 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	if (attr->comp_mask & ~MLX5_CREATE_QP_SUP_COMP_MASK)
 		return NULL;
 
+	if (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK)
+		use_ex2 = 1;
+
 	qp = calloc(1, sizeof(*qp));
 	if (!qp) {
 		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
@@ -1156,6 +1159,10 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	qp->ibv_qp = ibqp;
 
 	memset(&cmd, 0, sizeof(cmd));
+	if (use_ex2)
+		memset(&resp_ex, 0, sizeof(resp_ex));
+	else
+		memset(&resp, 0, sizeof(resp));
 
 	qp->wq_sig = qp_sig_enabled();
 	if (qp->wq_sig)
@@ -1235,7 +1242,7 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 		cmd.uidx = usr_idx;
 	}
 
-	if (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK)
+	if (use_ex2)
 		ret = mlx5_cmd_create_qp_ex(context, attr, &cmd, qp, &resp_ex);
 	else
 		ret = ibv_cmd_create_qp_ex(context, &qp->verbs_qp, sizeof(qp->verbs_qp),
@@ -1246,8 +1253,8 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 		goto err_free_uidx;
 	}
 
-	uuar_index = (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK) ?
-			resp_ex.uuar_index : resp.uuar_index;
+	uuar_index = use_ex2 ? resp_ex.uuar_index : resp.uuar_index;
+
 	if (!ctx->cqe_version) {
 		if (qp->sq.wqe_cnt || qp->rq.wqe_cnt) {
 			ret = mlx5_store_qp(ctx, ibqp->qp_num, qp);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4] Add support for ibv_cmd_create_qp_ex2
Date: Tue, 27 Oct 2015 14:55:41 +0200
Message-ID: <1445950541-11255-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add an extension verb mlx4_cmd_create_qp_ex that follows the
standard extension verb mechanism.
This function is called from mlx4_create_qp_ex but supports the
extension verbs functions and stores the creation flags.

In addition, check that the comp_mask values of struct
ibv_qp_init_attr_ex are valid.


Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4-abi.h | 18 ++++++++++++++++++
 src/verbs.c    | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/src/mlx4-abi.h b/src/mlx4-abi.h
index b48f6fc..ac21fa8 100644
--- a/src/mlx4-abi.h
+++ b/src/mlx4-abi.h
@@ -111,4 +111,22 @@ struct mlx4_create_qp {
 	__u8				reserved[5];
 };
 
+struct mlx4_create_qp_drv_ex {
+	__u64		buf_addr;
+	__u64		db_addr;
+	__u8		log_sq_bb_count;
+	__u8		log_sq_stride;
+	__u8		sq_no_prefetch;	/* was reserved in ABI 2 */
+	__u8		reserved[5];
+};
+
+struct mlx4_create_qp_ex {
+	struct ibv_create_qp_ex		ibv_cmd;
+	struct mlx4_create_qp_drv_ex	drv_ex;
+};
+
+struct mlx4_create_qp_resp_ex {
+	struct ibv_create_qp_resp_ex	ibv_resp;
+};
+
 #endif /* MLX4_ABI_H */
diff --git a/src/verbs.c b/src/verbs.c
index 2cb1f8a..2cf240d 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -458,6 +458,43 @@ int mlx4_destroy_srq(struct ibv_srq *srq)
 	return 0;
 }
 
+static int mlx4_cmd_create_qp_ex(struct ibv_context *context,
+				 struct ibv_qp_init_attr_ex *attr,
+				 struct mlx4_create_qp *cmd,
+				 struct mlx4_qp *qp)
+{
+	struct mlx4_create_qp_ex cmd_ex;
+	struct mlx4_create_qp_resp_ex resp;
+	int ret;
+
+	memset(&cmd_ex, 0, sizeof(cmd_ex));
+	memcpy(&cmd_ex.ibv_cmd.base, &cmd->ibv_cmd.user_handle,
+	       offsetof(typeof(cmd->ibv_cmd), is_srq) +
+	       sizeof(cmd->ibv_cmd.is_srq) -
+	       offsetof(typeof(cmd->ibv_cmd), user_handle));
+
+	memcpy(&cmd_ex.drv_ex, &cmd->buf_addr,
+	       offsetof(typeof(*cmd), sq_no_prefetch) +
+	       sizeof(cmd->sq_no_prefetch) - sizeof(cmd->ibv_cmd));
+
+	ret = ibv_cmd_create_qp_ex2(context, &qp->verbs_qp,
+				    sizeof(qp->verbs_qp), attr,
+				    &cmd_ex.ibv_cmd, sizeof(cmd_ex.ibv_cmd),
+				    sizeof(cmd_ex), &resp.ibv_resp,
+				    sizeof(resp.ibv_resp), sizeof(resp));
+	return ret;
+}
+
+enum {
+	MLX4_CREATE_QP_SUP_COMP_MASK = (IBV_QP_INIT_ATTR_PD |
+					IBV_QP_INIT_ATTR_XRCD |
+					IBV_QP_INIT_ATTR_CREATE_FLAGS),
+};
+
+enum {
+	MLX4_CREATE_QP_EX2_COMP_MASK = (IBV_QP_INIT_ATTR_CREATE_FLAGS),
+};
+
 struct ibv_qp *mlx4_create_qp_ex(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr)
 {
@@ -474,6 +511,9 @@ struct ibv_qp *mlx4_create_qp_ex(struct ibv_context *context,
 	    attr->cap.max_inline_data > 1024)
 		return NULL;
 
+	if (attr->comp_mask & ~MLX4_CREATE_QP_SUP_COMP_MASK)
+		return NULL;
+
 	qp = calloc(1, sizeof *qp);
 	if (!qp)
 		return NULL;
@@ -529,12 +569,15 @@ struct ibv_qp *mlx4_create_qp_ex(struct ibv_context *context,
 		; /* nothing */
 	cmd.sq_no_prefetch = 0;	/* OK for ABI 2: just a reserved field */
 	memset(cmd.reserved, 0, sizeof cmd.reserved);
-
 	pthread_mutex_lock(&to_mctx(context)->qp_table_mutex);
 
-	ret = ibv_cmd_create_qp_ex(context, &qp->verbs_qp,
-				   sizeof(qp->verbs_qp), attr,
-				   &cmd.ibv_cmd, sizeof cmd, &resp, sizeof resp);
+	if (attr->comp_mask & MLX4_CREATE_QP_EX2_COMP_MASK)
+		ret = mlx4_cmd_create_qp_ex(context, attr, &cmd, qp);
+	else
+		ret = ibv_cmd_create_qp_ex(context, &qp->verbs_qp,
+					   sizeof(qp->verbs_qp), attr,
+					   &cmd.ibv_cmd, sizeof(cmd), &resp,
+					   sizeof(resp));
 	if (ret)
 		goto err_rq_db;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

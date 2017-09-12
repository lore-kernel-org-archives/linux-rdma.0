From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/6] mlx4: Add support for WQ indirection table related verbs
Date: Tue, 12 Sep 2017 15:53:05 +0300
Message-ID: <1505220788-23849-4-git-send-email-yishaih@mellanox.com>
References: <1505220788-23849-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505220788-23849-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

To enable RSS functionality the IB indirection table object should
be used.
This patch implements the related verbs as of create and destroy
an indirection table.
In downstream patches the indirection table will be used as part
of RSS QP creation.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4.c  |  2 ++
 providers/mlx4/mlx4.h  |  3 +++
 providers/mlx4/verbs.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+)

diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 6158924..5daea3b 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -259,6 +259,8 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, create_wq, mlx4_create_wq);
 	verbs_set_ctx_op(verbs_ctx, modify_wq, mlx4_modify_wq);
 	verbs_set_ctx_op(verbs_ctx, destroy_wq, mlx4_destroy_wq);
+	verbs_set_ctx_op(verbs_ctx, create_rwq_ind_table, mlx4_create_rwq_ind_table);
+	verbs_set_ctx_op(verbs_ctx, destroy_rwq_ind_table, mlx4_destroy_rwq_ind_table);
 
 	return 0;
 
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 204542b..13a561f 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -411,5 +411,8 @@ struct ibv_wq *mlx4_create_wq(struct ibv_context *context,
 			      struct ibv_wq_init_attr *attr);
 int mlx4_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr);
 int mlx4_destroy_wq(struct ibv_wq *wq);
+struct ibv_rwq_ind_table *mlx4_create_rwq_ind_table(struct ibv_context *context,
+						    struct ibv_rwq_ind_table_init_attr *init_attr);
+int mlx4_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table);
 
 #endif /* MLX4_H */
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 5ded2c5..369f437 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -1441,3 +1441,58 @@ int mlx4_destroy_wq(struct ibv_wq *ibwq)
 
 	return 0;
 }
+
+struct ibv_rwq_ind_table *mlx4_create_rwq_ind_table(struct ibv_context *context,
+						    struct ibv_rwq_ind_table_init_attr *init_attr)
+{
+	struct ibv_create_rwq_ind_table *cmd;
+	struct ibv_create_rwq_ind_table_resp resp = {};
+	struct ibv_rwq_ind_table *ind_table;
+	uint32_t required_tbl_size;
+	unsigned int num_tbl_entries;
+	int cmd_size;
+	int err;
+
+	num_tbl_entries = 1 << init_attr->log_ind_tbl_size;
+	/* Data must be u64 aligned */
+	required_tbl_size =
+		(num_tbl_entries * sizeof(uint32_t)) < sizeof(uint64_t) ?
+			sizeof(uint64_t) : (num_tbl_entries * sizeof(uint32_t));
+
+	cmd_size = required_tbl_size + sizeof(*cmd);
+	cmd = calloc(1, cmd_size);
+	if (!cmd)
+		return NULL;
+
+	ind_table = calloc(1, sizeof(*ind_table));
+	if (!ind_table)
+		goto free_cmd;
+
+	err = ibv_cmd_create_rwq_ind_table(context, init_attr, ind_table, cmd,
+					   cmd_size, cmd_size, &resp,
+					   sizeof(resp), sizeof(resp));
+	if (err)
+		goto err;
+
+	free(cmd);
+	return ind_table;
+
+err:
+	free(ind_table);
+free_cmd:
+	free(cmd);
+	return NULL;
+}
+
+int mlx4_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table)
+{
+	int ret;
+
+	ret = ibv_cmd_destroy_rwq_ind_table(rwq_ind_table);
+
+	if (ret && !cleanup_on_fatal(ret))
+		return ret;
+
+	free(rwq_ind_table);
+	return 0;
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

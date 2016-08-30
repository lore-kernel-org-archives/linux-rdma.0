From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 2/5] Add support for Receive WQ indirection table verbs
Date: Tue, 30 Aug 2016 18:38:40 +0300
Message-ID: <1472571523-12067-3-git-send-email-yishaih@mellanox.com>
References: <1472571523-12067-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472571523-12067-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add support for Receive WQ indirection table verbs, it includes:
create/destroy Receive WQ indirection table.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h |  8 ++++++++
 src/mlx5.c     |  2 ++
 src/mlx5.h     |  3 +++
 src/verbs.c    | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index c750cc8..74acfd3 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -202,6 +202,14 @@ struct mlx5_modify_wq {
 	__u32			reserved;
 };
 
+struct mlx5_create_rwq_ind_table_resp {
+	struct ibv_create_rwq_ind_table_resp ibv_resp;
+};
+
+struct mlx5_destroy_rwq_ind_table {
+	struct ibv_destroy_rwq_ind_table ibv_cmd;
+};
+
 struct mlx5_resize_cq {
 	struct ibv_resize_cq		ibv_cmd;
 	__u64				buf_addr;
diff --git a/src/mlx5.c b/src/mlx5.c
index 5b69f36..af5797c 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -748,6 +748,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_wq, mlx5_create_wq);
 	verbs_set_ctx_op(v_ctx, modify_wq, mlx5_modify_wq);
 	verbs_set_ctx_op(v_ctx, destroy_wq, mlx5_destroy_wq);
+	verbs_set_ctx_op(v_ctx, create_rwq_ind_table, mlx5_create_rwq_ind_table);
+	verbs_set_ctx_op(v_ctx, destroy_rwq_ind_table, mlx5_destroy_rwq_ind_table);
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
diff --git a/src/mlx5.h b/src/mlx5.h
index fd3ca96..e51d67f 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -763,6 +763,9 @@ struct ibv_wq *mlx5_create_wq(struct ibv_context *context,
 			      struct ibv_wq_init_attr *attr);
 int mlx5_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr);
 int mlx5_destroy_wq(struct ibv_wq *wq);
+struct ibv_rwq_ind_table *mlx5_create_rwq_ind_table(struct ibv_context *context,
+						    struct ibv_rwq_ind_table_init_attr *init_attr);
+int mlx5_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table);
 struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
 				   struct ibv_srq_init_attr_ex *attr);
 
diff --git a/src/verbs.c b/src/verbs.c
index 787dedf..10b8190 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1993,3 +1993,58 @@ int mlx5_destroy_wq(struct ibv_wq *wq)
 
 	return 0;
 }
+
+struct ibv_rwq_ind_table *mlx5_create_rwq_ind_table(struct ibv_context *context,
+						    struct ibv_rwq_ind_table_init_attr *init_attr)
+{
+	struct ibv_create_rwq_ind_table *cmd;
+	struct mlx5_create_rwq_ind_table_resp resp;
+	struct ibv_rwq_ind_table *ind_table;
+	uint32_t required_tbl_size;
+	int num_tbl_entries;
+	int cmd_size;
+	int err;
+
+	num_tbl_entries = 1 << init_attr->log_ind_tbl_size;
+	/* Data must be u64 aligned */
+	required_tbl_size = (num_tbl_entries * sizeof(uint32_t)) < sizeof(uint64_t) ?
+			sizeof(uint64_t) : (num_tbl_entries * sizeof(uint32_t));
+
+	cmd_size = required_tbl_size + sizeof(*cmd);
+	cmd = calloc(1, cmd_size);
+	if (!cmd)
+		return NULL;
+
+	memset(&resp, 0, sizeof(resp));
+	ind_table = calloc(1, sizeof(*ind_table));
+	if (!ind_table)
+		goto free_cmd;
+
+	err = ibv_cmd_create_rwq_ind_table(context, init_attr, ind_table, cmd,
+					   cmd_size, cmd_size, &resp.ibv_resp, sizeof(resp.ibv_resp),
+					   sizeof(resp));
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
+int mlx5_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table)
+{
+	int ret;
+
+	ret = ibv_cmd_destroy_rwq_ind_table(rwq_ind_table);
+
+	if (ret)
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

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/2] Align flow steering commands with other objects
Date: Wed,  8 Nov 2017 18:18:16 +0200
Message-ID: <1510157897-10384-2-git-send-email-yishaih@mellanox.com>
References: <1510157897-10384-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510157897-10384-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch aligns ibv_cmd_create/destroy_flow with creation/destruction
of other objects as of QP/CQ/SRQ,etc.

The above APIs expect to issue the commands with the kernel but not to
make the allocation/destruction of ibv_flow. This is the logic for other
objects around.

This change enables in the following patch some specific mlx4 handling
around cleanup on fatal in the destroy flow.

Note:
The change is done in one patch which involves verbs and providers as done
in the kernel in such cases when an internal API is changed.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c       | 15 +++++----------
 libibverbs/driver.h    |  3 ++-
 providers/mlx4/mlx4.c  |  4 ++--
 providers/mlx4/mlx4.h  |  2 ++
 providers/mlx4/verbs.c | 30 ++++++++++++++++++++++++++++++
 providers/mlx5/mlx5.c  |  4 ++--
 providers/mlx5/mlx5.h  |  2 ++
 providers/mlx5/verbs.c | 29 +++++++++++++++++++++++++++++
 8 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 713a13c..30813b4 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1864,12 +1864,12 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 	return 0;
 }
 
-struct ibv_flow *ibv_cmd_create_flow(struct ibv_qp *qp,
-				     struct ibv_flow_attr *flow_attr)
+int ibv_cmd_create_flow(struct ibv_qp *qp,
+			struct ibv_flow *flow_id,
+			struct ibv_flow_attr *flow_attr)
 {
 	struct ibv_create_flow *cmd;
 	struct ibv_create_flow_resp resp;
-	struct ibv_flow *flow_id;
 	size_t cmd_size;
 	size_t written_size;
 	int i, err;
@@ -1879,9 +1879,6 @@ struct ibv_flow *ibv_cmd_create_flow(struct ibv_qp *qp,
 	cmd_size = sizeof(*cmd) + (flow_attr->num_of_specs *
 				  sizeof(struct ibv_kern_spec));
 	cmd = alloca(cmd_size);
-	flow_id = malloc(sizeof(*flow_id));
-	if (!flow_id)
-		return NULL;
 	memset(cmd, 0, cmd_size);
 
 	cmd->qp_handle = qp->handle;
@@ -1916,10 +1913,9 @@ struct ibv_flow *ibv_cmd_create_flow(struct ibv_qp *qp,
 
 	flow_id->context = qp->context;
 	flow_id->handle = resp.flow_handle;
-	return flow_id;
+	return 0;
 err:
-	free(flow_id);
-	return NULL;
+	return errno;
 }
 
 int ibv_cmd_destroy_flow(struct ibv_flow *flow_id)
@@ -1933,7 +1929,6 @@ int ibv_cmd_destroy_flow(struct ibv_flow *flow_id)
 
 	if (write(flow_id->context->cmd_fd, &cmd, sizeof(cmd)) != sizeof(cmd))
 		ret = errno;
-	free(flow_id);
 	return ret;
 }
 
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index a3cdbe1..5b19442 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -355,7 +355,8 @@ int ibv_cmd_destroy_ah(struct ibv_ah *ah);
 int ibv_cmd_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
 int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
 
-struct ibv_flow *ibv_cmd_create_flow(struct ibv_qp *qp,
+int ibv_cmd_create_flow(struct ibv_qp *qp,
+				     struct ibv_flow *flow_id,
 				     struct ibv_flow_attr *flow_attr);
 int ibv_cmd_destroy_flow(struct ibv_flow *flow_id);
 int ibv_cmd_create_wq(struct ibv_context *context,
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 6de0bee..5261f68 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -246,8 +246,8 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, get_srq_num, verbs_get_srq_num);
 	verbs_set_ctx_op(verbs_ctx, create_qp_ex, mlx4_create_qp_ex);
 	verbs_set_ctx_op(verbs_ctx, open_qp, mlx4_open_qp);
-	verbs_set_ctx_op(verbs_ctx, ibv_create_flow, ibv_cmd_create_flow);
-	verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
+	verbs_set_ctx_op(verbs_ctx, ibv_create_flow, mlx4_create_flow);
+	verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, mlx4_destroy_flow);
 	verbs_set_ctx_op(verbs_ctx, create_cq_ex, mlx4_create_cq_ex);
 	verbs_set_ctx_op(verbs_ctx, query_device_ex, mlx4_query_device_ex);
 	verbs_set_ctx_op(verbs_ctx, query_rt_values, mlx4_query_rt_values);
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 14f2720..5786a10 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -424,5 +424,7 @@ struct ibv_rwq_ind_table *mlx4_create_rwq_ind_table(struct ibv_context *context,
 int mlx4_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table);
 int mlx4_post_wq_recv(struct ibv_wq *ibwq, struct ibv_recv_wr *wr,
 		      struct ibv_recv_wr **bad_wr);
+struct ibv_flow *mlx4_create_flow(struct ibv_qp *qp, struct ibv_flow_attr *flow_attr);
+int mlx4_destroy_flow(struct ibv_flow *flow_id);
 
 #endif /* MLX4_H */
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index b966ef2..7ecaeb1 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -1519,6 +1519,36 @@ int mlx4_modify_wq(struct ibv_wq *ibwq, struct ibv_wq_attr *attr)
 	return ret;
 }
 
+struct ibv_flow *mlx4_create_flow(struct ibv_qp *qp, struct ibv_flow_attr *flow_attr)
+{
+	struct ibv_flow *flow_id;
+	int ret;
+
+	flow_id = calloc(1, sizeof *flow_id);
+	if (!flow_id)
+		return NULL;
+
+	ret = ibv_cmd_create_flow(qp, flow_id, flow_attr);
+	if (!ret)
+		return flow_id;
+
+	free(flow_id);
+	return NULL;
+}
+
+int mlx4_destroy_flow(struct ibv_flow *flow_id)
+{
+	int ret;
+
+	ret = ibv_cmd_destroy_flow(flow_id);
+
+	if (ret)
+		return ret;
+
+	free(flow_id);
+	return 0;
+}
+
 int mlx4_destroy_wq(struct ibv_wq *ibwq)
 {
 	struct mlx4_context *mcontext = to_mctx(ibwq->context);
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 16f9891..cbdfc40 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -1000,8 +1000,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
 	verbs_set_ctx_op(v_ctx, query_rt_values, mlx5_query_rt_values);
-	verbs_set_ctx_op(v_ctx, ibv_create_flow, ibv_cmd_create_flow);
-	verbs_set_ctx_op(v_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
+	verbs_set_ctx_op(v_ctx, ibv_create_flow, mlx5_create_flow);
+	verbs_set_ctx_op(v_ctx, ibv_destroy_flow, mlx5_destroy_flow);
 	verbs_set_ctx_op(v_ctx, create_cq_ex, mlx5_create_cq_ex);
 	verbs_set_ctx_op(v_ctx, create_wq, mlx5_create_wq);
 	verbs_set_ctx_op(v_ctx, modify_wq, mlx5_modify_wq);
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index fafafe7..5978e2e 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -745,6 +745,8 @@ int mlx5_destroy_wq(struct ibv_wq *wq);
 struct ibv_rwq_ind_table *mlx5_create_rwq_ind_table(struct ibv_context *context,
 						    struct ibv_rwq_ind_table_init_attr *init_attr);
 int mlx5_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table);
+struct ibv_flow *mlx5_create_flow(struct ibv_qp *qp, struct ibv_flow_attr *flow_attr);
+int mlx5_destroy_flow(struct ibv_flow *flow_id);
 struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
 				   struct ibv_srq_init_attr_ex *attr);
 int mlx5_post_srq_ops(struct ibv_srq *srq,
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 486de04..fea81f9 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -2325,6 +2325,35 @@ int mlx5_destroy_wq(struct ibv_wq *wq)
 	return 0;
 }
 
+struct ibv_flow *mlx5_create_flow(struct ibv_qp *qp, struct ibv_flow_attr *flow_attr)
+{
+	struct ibv_flow *flow_id;
+	int ret;
+
+	flow_id = calloc(1, sizeof *flow_id);
+	if (!flow_id)
+		return NULL;
+
+	ret = ibv_cmd_create_flow(qp, flow_id, flow_attr);
+	if (!ret)
+		return flow_id;
+
+	free(flow_id);
+	return NULL;
+}
+
+int mlx5_destroy_flow(struct ibv_flow *flow_id)
+{
+	int ret;
+
+	ret = ibv_cmd_destroy_flow(flow_id);
+	if (ret)
+		return ret;
+
+	free(flow_id);
+	return 0;
+}
+
 struct ibv_rwq_ind_table *mlx5_create_rwq_ind_table(struct ibv_context *context,
 						    struct ibv_rwq_ind_table_init_attr *init_attr)
 {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

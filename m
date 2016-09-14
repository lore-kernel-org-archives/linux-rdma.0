From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 2/7] Introduce Receive Work Queue indirection table and its verbs
Date: Wed, 14 Sep 2016 16:56:23 +0300
Message-ID: <1473861388-22064-3-git-send-email-yishaih@mellanox.com>
References: <1473861388-22064-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473861388-22064-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Introduce Receive Work Queue (WQ) indirection table and its
create/destroy verbs. This object can be used to spread incoming
traffic to different receive Work Queues.

A Receive WQ indirection table points to variable size of WQs.  This
table is given to a QP in downstream patches.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/driver.h   | 11 ++++++-
 include/infiniband/kern-abi.h | 29 +++++++++++++++++-
 include/infiniband/verbs.h    | 71 +++++++++++++++++++++++++++++++++++++++++++
 src/cmd.c                     | 68 +++++++++++++++++++++++++++++++++++++++++
 src/libibverbs.map            |  2 ++
 5 files changed, 179 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 706445b..72866a0 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -250,7 +250,16 @@ int ibv_cmd_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr,
 		      struct ibv_modify_wq *cmd, size_t cmd_core_size,
 		      size_t cmd_size);
 int ibv_cmd_destroy_wq(struct ibv_wq *wq);
-
+int ibv_cmd_create_rwq_ind_table(struct ibv_context *context,
+				 struct ibv_rwq_ind_table_init_attr *init_attr,
+				 struct ibv_rwq_ind_table *rwq_ind_table,
+				 struct ibv_create_rwq_ind_table *cmd,
+				 size_t cmd_core_size,
+				 size_t cmd_size,
+				 struct ibv_create_rwq_ind_table_resp *resp,
+				 size_t resp_core_size,
+				 size_t resp_size);
+int ibv_cmd_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table);
 int ibv_dontfork_range(void *base, size_t size);
 int ibv_dofork_range(void *base, size_t size);
 
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 081918f..674045b 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -119,7 +119,9 @@ enum {
 	IB_USER_VERBS_CMD_DESTROY_FLOW,
 	IB_USER_VERBS_CMD_CREATE_WQ,
 	IB_USER_VERBS_CMD_MODIFY_WQ,
-	IB_USER_VERBS_CMD_DESTROY_WQ
+	IB_USER_VERBS_CMD_DESTROY_WQ,
+	IB_USER_VERBS_CMD_CREATE_RWQ_IND_TBL,
+	IB_USER_VERBS_CMD_DESTROY_RWQ_IND_TBL,
 };
 
 /*
@@ -1131,6 +1133,8 @@ enum {
 	IB_USER_VERBS_CMD_CREATE_WQ_V2 = -1,
 	IB_USER_VERBS_CMD_MODIFY_WQ_V2 = -1,
 	IB_USER_VERBS_CMD_DESTROY_WQ_V2 = -1,
+	IB_USER_VERBS_CMD_CREATE_RWQ_IND_TBL_V2 = -1,
+	IB_USER_VERBS_CMD_DESTROY_RWQ_IND_TBL_V2 = -1,
 };
 
 struct ibv_modify_srq_v3 {
@@ -1206,4 +1210,27 @@ struct ibv_modify_wq  {
 	__u32 curr_wq_state;
 };
 
+struct ibv_create_rwq_ind_table {
+	struct ex_hdr hdr;
+	__u32 comp_mask;
+	__u32 log_ind_tbl_size;
+	/* Following are wq handles based on log_ind_tbl_size, must be 64 bytes aligned.
+	 * __u32 wq_handle1
+	 * __u32 wq_handle2
+	 */
+};
+
+struct ibv_create_rwq_ind_table_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u32 ind_tbl_handle;
+	__u32 ind_tbl_num;
+};
+
+struct ibv_destroy_rwq_ind_table {
+	struct ex_hdr hdr;
+	__u32 comp_mask;
+	__u32 ind_tbl_handle;
+};
+
 #endif /* KERN_ABI_H */
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index c549bd3..491e254 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -652,6 +652,34 @@ struct ibv_wq_attr {
 	enum	ibv_wq_state	curr_wq_state;
 };
 
+/*
+ * Receive Work Queue Indirection Table.
+ * It's used in order to distribute incoming packets between different
+ * Receive Work Queues. Associating Receive WQs with different CPU cores
+ * allows to workload the traffic between different CPU cores.
+ * The Indirection Table can contain only WQs of type IBV_WQT_RQ.
+*/
+struct ibv_rwq_ind_table {
+	struct ibv_context *context;
+	int ind_tbl_handle;
+	int ind_tbl_num;
+	uint32_t comp_mask;
+};
+
+enum ibv_ind_table_init_attr_mask {
+	IBV_CREATE_IND_TABLE_RESERVED = (1 << 0)
+};
+
+/*
+ * Receive Work Queue Indirection Table attributes
+ */
+struct ibv_rwq_ind_table_init_attr {
+	uint32_t log_ind_tbl_size;
+	/* Each entry is a pointer to a Receive Work Queue */
+	struct ibv_wq **ind_tbl;
+	uint32_t comp_mask;
+};
+
 enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
@@ -1339,6 +1367,9 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*destroy_rwq_ind_table)(struct ibv_rwq_ind_table *rwq_ind_table);
+	struct ibv_rwq_ind_table *(*create_rwq_ind_table)(struct ibv_context *context,
+							  struct ibv_rwq_ind_table_init_attr *init_attr);
 	int (*destroy_wq)(struct ibv_wq *wq);
 	int (*modify_wq)(struct ibv_wq *wq, struct ibv_wq_attr *wq_attr);
 	struct ibv_wq * (*create_wq)(struct ibv_context *context,
@@ -2032,6 +2063,46 @@ static inline int ibv_destroy_wq(struct ibv_wq *wq)
 	return vctx->destroy_wq(wq);
 }
 
+/*
+ * ibv_create_rwq_ind_table - Creates a receive work queue Indirection Table
+ * @context: ibv_context.
+ * @init_attr: A list of initial attributes required to create the Indirection Table.
+ * Return Value
+ * ibv_create_rwq_ind_table returns a pointer to the created
+ * Indirection Table, or NULL if the request fails.
+ */
+static inline struct ibv_rwq_ind_table *ibv_create_rwq_ind_table(struct ibv_context *context,
+								 struct ibv_rwq_ind_table_init_attr *init_attr)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(context, create_rwq_ind_table);
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	return vctx->create_rwq_ind_table(context, init_attr);
+}
+
+/*
+ * ibv_destroy_rwq_ind_table - Destroys the specified Indirection Table.
+ * @rwq_ind_table: The Indirection Table to destroy.
+ * Return Value
+ * ibv_destroy_rwq_ind_table() returns 0 on success, or the value of errno
+ * on failure (which indicates the failure reason).
+*/
+static inline int ibv_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(rwq_ind_table->context, destroy_rwq_ind_table);
+	if (!vctx)
+		return ENOSYS;
+
+	return vctx->destroy_rwq_ind_table(rwq_ind_table);
+}
+
 /**
  * ibv_post_send - Post a list of work requests to a send queue.
  *
diff --git a/src/cmd.c b/src/cmd.c
index 6599eca..11f5de9 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1757,3 +1757,71 @@ int ibv_cmd_destroy_wq(struct ibv_wq *wq)
 
 	return ret;
 }
+
+int ibv_cmd_create_rwq_ind_table(struct ibv_context *context,
+				 struct ibv_rwq_ind_table_init_attr *init_attr,
+				 struct ibv_rwq_ind_table *rwq_ind_table,
+				 struct ibv_create_rwq_ind_table *cmd,
+				 size_t cmd_core_size,
+				 size_t cmd_size,
+				 struct ibv_create_rwq_ind_table_resp *resp,
+				 size_t resp_core_size,
+				 size_t resp_size)
+{
+	int err, i;
+	uint32_t required_tbl_size, alloc_tbl_size;
+	uint32_t *tbl_start;
+	int num_tbl_entries;
+
+	if (init_attr->comp_mask >= IBV_CREATE_IND_TABLE_RESERVED)
+		return EINVAL;
+
+	alloc_tbl_size = cmd_core_size - sizeof(*cmd);
+	num_tbl_entries = 1 << init_attr->log_ind_tbl_size;
+
+	/* Data must be u64 aligned */
+	required_tbl_size = (num_tbl_entries * sizeof(uint32_t)) < sizeof(uint64_t) ?
+			sizeof(uint64_t) : (num_tbl_entries * sizeof(uint32_t));
+
+	if (alloc_tbl_size < required_tbl_size)
+		return EINVAL;
+
+	tbl_start = (uint32_t *)((uint8_t *)cmd + sizeof(*cmd));
+	for (i = 0; i < num_tbl_entries; i++)
+		tbl_start[i] = init_attr->ind_tbl[i]->handle;
+
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size,
+			       CREATE_RWQ_IND_TBL, resp,
+			       resp_core_size, resp_size);
+	cmd->log_ind_tbl_size = init_attr->log_ind_tbl_size;
+	cmd->comp_mask = 0;
+
+	err = write(context->cmd_fd, cmd, cmd_size);
+	if (err != cmd_size)
+		return errno;
+
+	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	if (resp->response_length < resp_core_size)
+		return EINVAL;
+
+	rwq_ind_table->ind_tbl_handle = resp->ind_tbl_handle;
+	rwq_ind_table->ind_tbl_num = resp->ind_tbl_num;
+	rwq_ind_table->context = context;
+	return 0;
+}
+
+int ibv_cmd_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table)
+{
+	struct ibv_destroy_rwq_ind_table cmd;
+	int ret = 0;
+
+	memset(&cmd, 0, sizeof(cmd));
+	IBV_INIT_CMD_EX(&cmd, sizeof(cmd), DESTROY_RWQ_IND_TBL);
+	cmd.ind_tbl_handle = rwq_ind_table->ind_tbl_handle;
+
+	if (write(rwq_ind_table->context->cmd_fd, &cmd, sizeof(cmd)) != sizeof(cmd))
+		ret = errno;
+
+	return ret;
+}
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 78a06dd..4de9d64 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -125,5 +125,7 @@ IBVERBS_1.3 {
 		ibv_cmd_create_wq;
 		ibv_cmd_modify_wq;
 		ibv_cmd_destroy_wq;
+		ibv_cmd_create_rwq_ind_table;
+		ibv_cmd_destroy_rwq_ind_table;
 
 } IBVERBS_1.0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

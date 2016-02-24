From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 3/8] Add support for extended ibv_create_cq
Date: Wed, 24 Feb 2016 11:41:59 +0200
Message-ID: <1456306924-31298-4-git-send-email-yishaih@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456306924-31298-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add ibv_create_cq_ex. This extended verb follows
the extension verbs scheme and hence could be
extendible in the future for more features.

The new command supports creation flags with timestamp.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/driver.h   |  9 +++++++
 include/infiniband/kern-abi.h | 20 ++++++++++++++
 include/infiniband/verbs.h    | 63 +++++++++++++++++++++++++++++++++++++++++++
 src/cmd.c                     | 42 +++++++++++++++++++++++++++++
 src/device.c                  | 44 ++++++++++++++++++++++++++++++
 src/ibverbs.h                 |  5 ++++
 src/libibverbs.map            |  1 +
 7 files changed, 184 insertions(+)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 053ad5f..176eef0 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -155,6 +155,15 @@ int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      int comp_vector, struct ibv_cq *cq,
 		      struct ibv_create_cq *cmd, size_t cmd_size,
 		      struct ibv_create_cq_resp *resp, size_t resp_size);
+int ibv_cmd_create_cq_ex(struct ibv_context *context,
+			 struct ibv_cq_init_attr_ex *cq_attr,
+			 struct ibv_cq *cq,
+			 struct ibv_create_cq_ex *cmd,
+			 size_t cmd_core_size,
+			 size_t cmd_size,
+			 struct ibv_create_cq_resp_ex *resp,
+			 size_t resp_core_size,
+			 size_t resp_size);
 int ibv_cmd_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
 int ibv_cmd_req_notify_cq(struct ibv_cq *cq, int solicited_only);
 #define IBV_CMD_RESIZE_CQ_HAS_RESP_PARAMS
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index b196a04..2012879 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -112,6 +112,8 @@ enum {
 					    IB_USER_VERBS_CMD_QUERY_DEVICE,
 	IB_USER_VERBS_CMD_CREATE_QP_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
 					 IB_USER_VERBS_CMD_CREATE_QP,
+	IB_USER_VERBS_CMD_CREATE_CQ_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
+					 IB_USER_VERBS_CMD_CREATE_CQ,
 	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_EXTENDED_MASK +
 					IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_CMD_DESTROY_FLOW
@@ -445,6 +447,23 @@ struct ibv_create_cq_resp {
 	__u32 cqe;
 };
 
+struct ibv_create_cq_ex {
+	struct ex_hdr	hdr;
+	__u64		user_handle;
+	__u32		cqe;
+	__u32		comp_vector;
+	__s32		comp_channel;
+	__u32		comp_mask;
+	__u32		flags;
+	__u32		reserved;
+};
+
+struct ibv_create_cq_resp_ex {
+	struct ibv_create_cq_resp	base;
+	__u32				comp_mask;
+	__u32				response_length;
+};
+
 struct ibv_kern_wc {
 	__u64  wr_id;
 	__u32  status;
@@ -1100,6 +1119,7 @@ enum {
 	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 = -1,
 	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_QP_EX_V2 = -1,
+	IB_USER_VERBS_CMD_CREATE_CQ_EX_V2 = -1,
 };
 
 struct ibv_modify_srq_v3 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 3ddf07c..a64e320 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1118,6 +1118,42 @@ struct ibv_context {
 	void		       *abi_compat;
 };
 
+enum ibv_cq_init_attr_mask {
+	IBV_CQ_INIT_ATTR_FLAGS		= 1 << 0,
+	IBV_CQ_INIT_ATTR_RESERVED	= 1 << 1
+};
+
+enum ibv_create_cq_attr_flags {
+	IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP	= 1 << 0,
+};
+
+struct ibv_cq_init_attr_ex {
+	/* Minimum number of entries required for CQ */
+	int			cqe;
+	/* Consumer-supplied context returned for completion events */
+	void			*cq_context;
+	/* Completion channel where completion events will be queued.
+	 * May be NULL if completion events will not be used.
+	 */
+	struct ibv_comp_channel *channel;
+	/* Completion vector used to signal completion events.
+	 *  Must be >= 0 and < context->num_comp_vectors.
+	 */
+	int			comp_vector;
+	/* The wc_flags that should be returned in ibv_poll_cq_ex.
+	 * Or'ed bit of enum ibv_wc_flags_ex.
+	 */
+	uint64_t		wc_flags;
+	/* compatibility mask (extended verb). Or'd flags of
+	 * enum ibv_cq_init_attr_mask
+	 */
+	uint32_t		comp_mask;
+	/* create cq attr flags - one or more flags from
+	 * enum ibv_create_cq_attr_flags
+	 */
+	uint32_t		flags;
+};
+
 enum verbs_context_mask {
 	VERBS_CONTEXT_XRCD	= 1 << 0,
 	VERBS_CONTEXT_SRQ	= 1 << 1,
@@ -1134,6 +1170,9 @@ struct ibv_poll_cq_ex_attr {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	struct ibv_cq *(*create_cq_ex)(struct ibv_context *context,
+				       struct ibv_cq_init_attr_ex *);
+	struct verbs_ex_private *priv;
 	int (*poll_cq_ex)(struct ibv_cq *ibcq,
 			  struct ibv_wc_ex *wc,
 			  struct ibv_poll_cq_ex_attr *attr);
@@ -1428,6 +1467,30 @@ struct ibv_cq *ibv_create_cq(struct ibv_context *context, int cqe,
 			     int comp_vector);
 
 /**
+ * ibv_create_cq_ex - Create a completion queue
+ * @context - Context CQ will be attached to
+ * @cq_attr - Attributes to create the CQ with
+ */
+static inline
+struct ibv_cq *ibv_create_cq_ex(struct ibv_context *context,
+				struct ibv_cq_init_attr_ex *cq_attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(context, create_cq_ex);
+
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	if (cq_attr->comp_mask & ~(IBV_CQ_INIT_ATTR_RESERVED - 1)) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	return vctx->create_cq_ex(context, cq_attr);
+}
+
+/**
  * ibv_resize_cq - Modifies the capacity of the CQ.
  * @cq: The CQ to resize.
  * @cqe: The minimum size of the CQ.
diff --git a/src/cmd.c b/src/cmd.c
index e22a24b..0e03740 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -459,6 +459,48 @@ int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 	return 0;
 }
 
+int ibv_cmd_create_cq_ex(struct ibv_context *context,
+			 struct ibv_cq_init_attr_ex *cq_attr,
+			 struct ibv_cq *cq,
+			 struct ibv_create_cq_ex *cmd,
+			 size_t cmd_core_size,
+			 size_t cmd_size,
+			 struct ibv_create_cq_resp_ex *resp,
+			 size_t resp_core_size,
+			 size_t resp_size)
+{
+	int err;
+
+	memset(cmd, 0, cmd_core_size);
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, CREATE_CQ_EX, resp,
+			       resp_core_size, resp_size);
+
+	if (cq_attr->comp_mask & ~(IBV_CQ_INIT_ATTR_RESERVED - 1))
+		return EINVAL;
+
+	cmd->user_handle   = (uintptr_t)cq;
+	cmd->cqe           = cq_attr->cqe;
+	cmd->comp_vector   = cq_attr->comp_vector;
+	cmd->comp_channel  = cq_attr->channel ? cq_attr->channel->fd : -1;
+	cmd->comp_mask = 0;
+
+	if (cmd_core_size >= offsetof(struct ibv_create_cq_ex, flags) +
+	    sizeof(cmd->flags) && cq_attr->comp_mask & IBV_CQ_INIT_ATTR_FLAGS)
+		cmd->flags = cq_attr->flags;
+
+	err = write(context->cmd_fd, cmd, cmd_size);
+	if (err != cmd_size)
+		return errno;
+
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	cq->handle  = resp->base.cq_handle;
+	cq->cqe     = resp->base.cqe;
+	cq->context = context;
+
+	return 0;
+}
+
 int ibv_cmd_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 {
 	struct ibv_poll_cq       cmd;
diff --git a/src/device.c b/src/device.c
index f2b889c..bff5836 100644
--- a/src/device.c
+++ b/src/device.c
@@ -122,6 +122,33 @@ uint64_t __ibv_get_device_guid(struct ibv_device *device)
 }
 default_symver(__ibv_get_device_guid, ibv_get_device_guid);
 
+struct ibv_cq *__lib_ibv_create_cq_ex(struct ibv_context *context,
+				      struct ibv_cq_init_attr_ex *cq_attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx(context);
+	struct ibv_cq *cq;
+
+	pthread_mutex_lock(&context->mutex);
+
+	cq = vctx->priv->create_cq_ex(context, cq_attr);
+
+	if (cq) {
+		cq->context		   = context;
+		cq->channel		   = cq_attr->channel;
+		if (cq->channel)
+			++cq->channel->refcnt;
+		cq->cq_context		   = cq_attr->cq_context;
+		cq->comp_events_completed  = 0;
+		cq->async_events_completed = 0;
+		pthread_mutex_init(&cq->mutex, NULL);
+		pthread_cond_init(&cq->cond, NULL);
+	}
+
+	pthread_mutex_unlock(&context->mutex);
+
+	return cq;
+}
+
 struct ibv_context *__ibv_open_device(struct ibv_device *device)
 {
 	struct verbs_device *verbs_device = verbs_get_device(device);
@@ -148,6 +175,8 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 		if (!context)
 			goto err;
 	} else {
+		struct verbs_ex_private *priv;
+
 		/* Library now allocates the context */
 		context_ex = calloc(1, sizeof(*context_ex) +
 				       verbs_device->size_of_context);
@@ -156,6 +185,14 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 			goto err;
 		}
 
+		priv = calloc(1, sizeof(*priv));
+		if (!priv) {
+			errno = ENOMEM;
+			free(context_ex);
+			goto err;
+		}
+
+		context_ex->priv = priv;
 		context_ex->context.abi_compat  = __VERBS_ABI_IS_EXTENDED;
 		context_ex->sz = sizeof(*context_ex);
 
@@ -177,6 +214,11 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 		 */
 		context_ex->ABI_placeholder1 = (void (*)(void)) context_ex->ibv_create_flow;
 		context_ex->ABI_placeholder2 = (void (*)(void)) context_ex->ibv_destroy_flow;
+
+		if (context_ex->create_cq_ex) {
+			priv->create_cq_ex = context_ex->create_cq_ex;
+			context_ex->create_cq_ex = __lib_ibv_create_cq_ex;
+		}
 	}
 
 	context->device = device;
@@ -186,6 +228,7 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 	return context;
 
 verbs_err:
+	free(context_ex->priv);
 	free(context_ex);
 err:
 	close(cmd_fd);
@@ -204,6 +247,7 @@ int __ibv_close_device(struct ibv_context *context)
 	if (context_ex) {
 		struct verbs_device *verbs_device = verbs_get_device(context->device);
 		verbs_device->uninit_context(verbs_device, context);
+		free(context_ex->priv);
 		free(context_ex);
 	} else {
 		context->device->ops.free_context(context);
diff --git a/src/ibverbs.h b/src/ibverbs.h
index ff206f9..ceecb5d 100644
--- a/src/ibverbs.h
+++ b/src/ibverbs.h
@@ -81,6 +81,11 @@ extern HIDDEN int abi_ver;
 
 HIDDEN int ibverbs_init(struct ibv_device ***list);
 
+struct verbs_ex_private {
+	struct ibv_cq *(*create_cq_ex)(struct ibv_context *context,
+				       struct ibv_cq_init_attr_ex *);
+};
+
 #define IBV_INIT_CMD(cmd, size, opcode)					\
 	do {								\
 		if (abi_ver > 2)					\
diff --git a/src/libibverbs.map b/src/libibverbs.map
index a150416..282699c 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -115,6 +115,7 @@ IBVERBS_1.1 {
 		ibv_cmd_create_srq_ex;
 		ibv_cmd_create_qp_ex;
 		ibv_cmd_create_qp_ex2;
+		ibv_cmd_create_cq_ex;
 		ibv_cmd_open_qp;
 		ibv_cmd_rereg_mr;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

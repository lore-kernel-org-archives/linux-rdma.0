From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 3/5] Add support for extended ibv_create_cq
Date: Tue, 27 Oct 2015 18:51:38 +0200
Message-ID: <1445964700-13235-4-git-send-email-matanb@mellanox.com>
References: <1445964700-13235-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445964700-13235-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding ibv_create_cq_ex. This extended verbs follows
the extension verbs scheme and hence could be
extendible in the future for more features.
The new command supports creation flags with timestamp.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                   |  3 +-
 include/infiniband/driver.h   |  9 ++++++
 include/infiniband/kern-abi.h | 24 +++++++++++++--
 include/infiniband/verbs.h    | 63 ++++++++++++++++++++++++++++++++++++++
 man/ibv_create_cq_ex.3        | 71 +++++++++++++++++++++++++++++++++++++++++++
 src/cmd.c                     | 42 +++++++++++++++++++++++++
 src/device.c                  | 44 +++++++++++++++++++++++++++
 src/ibverbs.h                 |  5 +++
 src/libibverbs.map            |  1 +
 9 files changed, 259 insertions(+), 3 deletions(-)
 create mode 100644 man/ibv_create_cq_ex.3

diff --git a/Makefile.am b/Makefile.am
index 339bcec..b6399d6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -64,7 +64,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
     man/ibv_get_srq_num.3 man/ibv_open_qp.3 \
-    man/ibv_query_device_ex.3 man/ibv_poll_cq_ex.3
+    man/ibv_query_device_ex.3 man/ibv_poll_cq_ex.3 \
+    man/ibv_create_cq_ex.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 8227df0..0d53554 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -144,6 +144,15 @@ int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      int comp_vector, struct ibv_cq *cq,
 		      struct ibv_create_cq *cmd, size_t cmd_size,
 		      struct ibv_create_cq_resp *resp, size_t resp_size);
+int ibv_cmd_create_cq_ex(struct ibv_context *context,
+			 struct ibv_create_cq_attr_ex *cq_attr,
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
index cce6ade..b2dcda6 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -110,9 +110,11 @@ enum {
 enum {
 	IB_USER_VERBS_CMD_QUERY_DEVICE_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
 					    IB_USER_VERBS_CMD_QUERY_DEVICE,
+	IB_USER_VERBS_CMD_CREATE_CQ_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
+						IB_USER_VERBS_CMD_CREATE_CQ,
 	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_EXTENDED_MASK +
 					IB_USER_VERBS_CMD_THRESHOLD,
-	IB_USER_VERBS_CMD_DESTROY_FLOW
+	IB_USER_VERBS_CMD_DESTROY_FLOW,
 };
 
 /*
@@ -400,6 +402,23 @@ struct ibv_create_cq_resp {
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
@@ -1033,7 +1052,8 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_FLOW_V2 = -1,
 	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 = -1,
-	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1
+	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1,
+	IB_USER_VERBS_CMD_CREATE_CQ_EX_V2 = -1,
 };
 
 struct ibv_modify_srq_v3 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 51b880b..f80126a 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1193,6 +1193,42 @@ struct ibv_context {
 	void		       *abi_compat;
 };
 
+enum ibv_create_cq_attr {
+	IBV_CREATE_CQ_ATTR_FLAGS	= 1 << 0,
+	IBV_CREATE_CQ_ATTR_RESERVED	= 1 << 1
+};
+
+enum ibv_create_cq_attr_flags {
+	IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP	= 1 << 0,
+};
+
+struct ibv_create_cq_attr_ex {
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
+	 * enum ibv_create_cq_attr
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
@@ -1209,6 +1245,9 @@ struct ibv_poll_cq_ex_attr {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	struct ibv_cq *(*create_cq_ex)(struct ibv_context *context,
+				       struct ibv_create_cq_attr_ex *);
+	void *priv;
 	int (*poll_cq_ex)(struct ibv_cq *ibcq,
 			  struct ibv_wc_ex *wc,
 			  struct ibv_poll_cq_ex_attr *attr);
@@ -1449,6 +1488,30 @@ struct ibv_cq *ibv_create_cq(struct ibv_context *context, int cqe,
 			     int comp_vector);
 
 /**
+ * ibv_create_cq_ex - Create a completion queue
+ * @context - Context CQ will be attached to
+ * @cq_attr - Attributes to create the CQ with
+ */
+static inline
+struct ibv_cq *ibv_create_cq_ex(struct ibv_context *context,
+				struct ibv_create_cq_attr_ex *cq_attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(context, create_cq_ex);
+
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	if (cq_attr->comp_mask & ~(IBV_CREATE_CQ_ATTR_RESERVED - 1)) {
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
diff --git a/man/ibv_create_cq_ex.3 b/man/ibv_create_cq_ex.3
new file mode 100644
index 0000000..9f9e049
--- /dev/null
+++ b/man/ibv_create_cq_ex.3
@@ -0,0 +1,71 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_CREATE_CQ_EX 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_create_cq_ex \- create a completion queue (CQ)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_cq *ibv_create_cq_ex(struct ibv_context " "*context" ",
+.BI "                                struct ibv_create_cq_attr_ex " "*cq_attr" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_create_cq_ex()
+creates a completion queue (CQ) for RDMA device context
+.I context\fR.
+The argument
+.I cq_attr
+is a pointer to struct ibv_create_cq_attr_ex as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_create_cq_attr_ex {
+.in +8
+int                     cqe;               /* Minimum number of entries required for CQ */
+void                    *cq_context;       /* Consumer-supplied context returned for completion events */
+struct ibv_comp_channel *channel;          /* Completion channel where completion events will be queued. May be NULL if completion events will not be used. */
+int                     comp_vector;       /* Completion vector used to signal completion events. Must be >= 0 and < context->num_comp_vectors. */
+uint64_t                wc_flags;          /* The wc_flags that should be returned in ibv_poll_cq_ex. Or'ed bit of enum ibv_wc_flags_ex. */
+uint32_t                comp_mask;         /* compatibility mask (extended verb). Or'd flags of enum ibv_create_cq_attr */
+uint32_t                flags;             /* create cq attr flags - one or more flags from enum ibv_create_cq_attr_flags */
+.in -8
+};
+
+enum ibv_wc_flags_ex {
+        IBV_WC_EX_GRH                        = 1 << 0,  /* Output only */
+        IBV_WC_EX_IMM                        = 1 << 1,  /* Output only  */
+        IBV_WC_EX_WITH_BYTE_LEN              = 1 << 2,  /* Require byte len in WC */
+        IBV_WC_EX_WITH_IMM                   = 1 << 3,  /* Require immediate in WC */
+        IBV_WC_EX_WITH_QP_NUM                = 1 << 4,  /* Require QP number in WC */
+        IBV_WC_EX_WITH_SRC_QP                = 1 << 5,  /* Require source QP in WC */
+        IBV_WC_EX_WITH_PKEY_INDEX            = 1 << 6,  /* Require pkey index in WC */
+        IBV_WC_EX_WITH_SLID                  = 1 << 7,  /* Require slid in WC */
+        IBV_WC_EX_WITH_SL                    = 1 << 8,  /* Require sl in WC */
+        IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 9,  /* Require dlid path bits in WC */
+        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 10, /* Require completion timestamp in WC /*
+};
+
+
+enum ibv_create_cq_attr {
+        IBV_CREATE_CQ_ATTR_FLAGS             = 1 << 0,
+};
+.SH "RETURN VALUE"
+.B ibv_create_cq_ex()
+returns a pointer to the CQ, or NULL if the request fails.
+.SH "NOTES"
+.B ibv_create_cq_ex()
+may create a CQ with size greater than or equal to the requested
+size. Check the cqe attribute in the returned CQ for the actual size.
+.PP
+CQ should be destroyed with ibv_destroy_cq.
+.PP
+.SH "SEE ALSO"
+.BR ibv_create_cq (3),
+.BR ibv_destroy_cq (3),
+.BR ibv_resize_cq (3),
+.BR ibv_req_notify_cq (3),
+.BR ibv_ack_cq_events (3),
+.BR ibv_create_qp (3)
+.SH "AUTHORS"
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/src/cmd.c b/src/cmd.c
index a65b6b9..173c362 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -393,6 +393,48 @@ int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 	return 0;
 }
 
+int ibv_cmd_create_cq_ex(struct ibv_context *context,
+			 struct ibv_create_cq_attr_ex *cq_attr,
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
+	if (cq_attr->comp_mask & ~(IBV_CREATE_CQ_ATTR_RESERVED - 1))
+		return EINVAL;
+
+	cmd->user_handle   = (uintptr_t)cq;
+	cmd->cqe           = cq_attr->cqe;
+	cmd->comp_vector   = cq_attr->comp_vector;
+	cmd->comp_channel  = cq_attr->channel ? cq_attr->channel->fd : -1;
+	cmd->comp_mask = 0;
+
+	if (cmd_core_size >= offsetof(struct ibv_create_cq_ex, flags) +
+	    sizeof(cmd->flags) && cq_attr->comp_mask & IBV_CREATE_CQ_ATTR_FLAGS)
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
index f2b889c..6b1ea6f 100644
--- a/src/device.c
+++ b/src/device.c
@@ -122,6 +122,33 @@ uint64_t __ibv_get_device_guid(struct ibv_device *device)
 }
 default_symver(__ibv_get_device_guid, ibv_get_device_guid);
 
+struct ibv_cq *__lib_ibv_create_cq_ex(struct ibv_context *context,
+				      struct ibv_create_cq_attr_ex *cq_attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx(context);
+	struct ibv_cq *cq;
+
+	pthread_mutex_lock(&context->mutex);
+
+	cq = ((struct verbs_ex_private *)vctx->priv)->create_cq_ex(context, cq_attr);
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
index b3feb89..9df7fc8 100644
--- a/src/ibverbs.h
+++ b/src/ibverbs.h
@@ -81,6 +81,11 @@ extern HIDDEN int abi_ver;
 
 HIDDEN int ibverbs_init(struct ibv_device ***list);
 
+struct verbs_ex_private {
+	struct ibv_cq *(*create_cq_ex)(struct ibv_context *context,
+				       struct ibv_create_cq_attr_ex *);
+};
+
 #define IBV_INIT_CMD(cmd, size, opcode)					\
 	do {								\
 		if (abi_ver > 2)					\
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 3b40a0f..7fb72ef 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -47,6 +47,7 @@ IBVERBS_1.0 {
 		ibv_cmd_reg_mr;
 		ibv_cmd_dereg_mr;
 		ibv_cmd_create_cq;
+		ibv_cmd_create_cq_ex;
 		ibv_cmd_poll_cq;
 		ibv_cmd_req_notify_cq;
 		ibv_cmd_resize_cq;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

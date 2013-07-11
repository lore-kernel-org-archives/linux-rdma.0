From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V7 libibverbs 3/7] Add support for XRC SRQs
Date: Thu, 11 Jul 2013 18:04:19 +0300
Message-ID: <1373555063-31790-4-git-send-email-yishaih@mellanox.com>
References: <1373555063-31790-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373555063-31790-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

XRC support requires the use of a new type of SRQ.
XRC shared receive queues: xrc srq's are similar to normal
srq's, except that they are bound to an xrcd, rather
than to a protection domain.  Based on the current spec
and implementation, they are only usable with xrc qps.  To
support xrc srq's, we define a new srq_init_attr structure
to include an srq type and other needed information.

The kernel ABI is also updated to allow creating extended
SRQs.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Changes from V6:
ibv_cmd_create_srq_ex - verify input size, deleted redundant check.
verbs_get_srq_num - use srq_num as in/out, 0 may be valid value,
 function returns fail/success.

 include/infiniband/driver.h   |   32 +++++++++++++++++
 include/infiniband/kern-abi.h |   21 +++++++++++-
 include/infiniband/verbs.h    |   62 +++++++++++++++++++++++++++++++++-
 src/cmd.c                     |   75 +++++++++++++++++++++++++++++++++++++++++
 src/libibverbs.map            |    2 +
 5 files changed, 190 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 08d8a82..11f52c2 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -64,6 +64,23 @@ struct verbs_xrcd {
 	uint32_t		handle;
 };
 
+enum verbs_srq_mask {
+	VERBS_SRQ_TYPE		= 1 << 0,
+	VERBS_SRQ_XRCD		= 1 << 1,
+	VERBS_SRQ_CQ		= 1 << 2,
+	VERBS_SRQ_NUM		= 1 << 3,
+	VERBS_SRQ_RESERVED	= 1 << 4
+};
+
+struct verbs_srq {
+	struct ibv_srq		srq;
+	uint32_t		comp_mask;
+	enum ibv_srq_type	srq_type;
+	struct verbs_xrcd      *xrcd;
+	struct ibv_cq	       *cq;
+	uint32_t		srq_num;
+};
+
 typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
 						   int abi_version);
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
@@ -119,6 +136,11 @@ int ibv_cmd_create_srq(struct ibv_pd *pd,
 		       struct ibv_srq *srq, struct ibv_srq_init_attr *attr,
 		       struct ibv_create_srq *cmd, size_t cmd_size,
 		       struct ibv_create_srq_resp *resp, size_t resp_size);
+int ibv_cmd_create_srq_ex(struct ibv_context *context,
+			  struct verbs_srq *srq, int vsrq_sz,
+			  struct ibv_srq_init_attr_ex *attr_ex,
+			  struct ibv_create_xsrq *cmd, size_t cmd_size,
+			  struct ibv_create_srq_resp *resp, size_t resp_size);
 int ibv_cmd_modify_srq(struct ibv_srq *srq,
 		       struct ibv_srq_attr *srq_attr,
 		       int srq_attr_mask,
@@ -163,4 +185,14 @@ const char *ibv_get_sysfs_path(void);
 int ibv_read_sysfs_file(const char *dir, const char *file,
 			char *buf, size_t size);
 
+static inline int verbs_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num)
+{
+	struct verbs_srq *vsrq = container_of(srq, struct verbs_srq, srq);
+	if (vsrq->comp_mask & VERBS_SRQ_NUM) {
+		*srq_num = vsrq->srq_num;
+		return 0;
+	}
+	return ENOSYS;
+}
+
 #endif /* INFINIBAND_DRIVER_H */
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 6f40ad2..ef93cc3 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -88,6 +88,7 @@ enum {
 	IB_USER_VERBS_CMD_POST_SRQ_RECV,
 	IB_USER_VERBS_CMD_OPEN_XRCD,
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
+	IB_USER_VERBS_CMD_CREATE_XSRQ
 };
 
 /*
@@ -730,11 +731,28 @@ struct ibv_create_srq {
 	__u64 driver_data[0];
 };
 
+struct ibv_create_xsrq {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u64 response;
+	__u64 user_handle;
+	__u32 srq_type;
+	__u32 pd_handle;
+	__u32 max_wr;
+	__u32 max_sge;
+	__u32 srq_limit;
+	__u32 reserved;
+	__u32 xrcd_handle;
+	__u32 cq_handle;
+	__u64 driver_data[0];
+};
+
 struct ibv_create_srq_resp {
 	__u32 srq_handle;
 	__u32 max_wr;
 	__u32 max_sge;
-	__u32 reserved;
+	__u32 srqn;
 };
 
 struct ibv_modify_srq {
@@ -829,6 +847,7 @@ enum {
 	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL_V2 = -1,
 	IB_USER_VERBS_CMD_OPEN_XRCD_V2 = -1,
 	IB_USER_VERBS_CMD_CLOSE_XRCD_V2 = -1,
+	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1
 };
 
 struct ibv_modify_srq_v3 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ae57296..8a7b2c4 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -450,6 +450,30 @@ struct ibv_srq_init_attr {
 	struct ibv_srq_attr	attr;
 };
 
+enum ibv_srq_type {
+	IBV_SRQT_BASIC,
+	IBV_SRQT_XRC
+};
+
+enum ibv_srq_init_attr_mask {
+	IBV_SRQ_INIT_ATTR_TYPE		= 1 << 0,
+	IBV_SRQ_INIT_ATTR_PD		= 1 << 1,
+	IBV_SRQ_INIT_ATTR_XRCD		= 1 << 2,
+	IBV_SRQ_INIT_ATTR_CQ		= 1 << 3,
+	IBV_SRQ_INIT_ATTR_RESERVED	= 1 << 4
+};
+
+struct ibv_srq_init_attr_ex {
+	void		       *srq_context;
+	struct ibv_srq_attr	attr;
+
+	uint32_t		comp_mask;
+	enum ibv_srq_type	srq_type;
+	struct ibv_pd	       *pd;
+	struct ibv_xrcd	       *xrcd;
+	struct ibv_cq	       *cq;
+};
+
 enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
@@ -770,11 +794,15 @@ struct ibv_context {
 
 enum verbs_context_mask {
 	VERBS_CONTEXT_XRCD	= 1 << 0,
-	VERBS_CONTEXT_RESERVED	= 1 << 1
+	VERBS_CONTEXT_SRQ	= 1 << 1,
+	VERBS_CONTEXT_RESERVED	= 1 << 2
 };
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*get_srq_num)(struct ibv_srq *srq, uint32_t *srq_num);
+	struct ibv_srq *	(*create_srq_ex)(struct ibv_context *context,
+						 struct ibv_srq_init_attr_ex *srq_init_attr_ex);
 	struct ibv_xrcd *	(*open_xrcd)(struct ibv_context *context,
 					     struct ibv_xrcd_init_attr *xrcd_init_attr);
 	int			(*close_xrcd)(struct ibv_xrcd *xrcd);
@@ -1059,6 +1087,28 @@ static inline int ibv_req_notify_cq(struct ibv_cq *cq, int solicited_only)
 struct ibv_srq *ibv_create_srq(struct ibv_pd *pd,
 			       struct ibv_srq_init_attr *srq_init_attr);
 
+static inline struct ibv_srq *
+ibv_create_srq_ex(struct ibv_context *context,
+		  struct ibv_srq_init_attr_ex *srq_init_attr_ex)
+{
+	struct verbs_context *vctx;
+	uint32_t mask = srq_init_attr_ex->comp_mask;
+
+	if (!(mask & ~(IBV_SRQ_INIT_ATTR_PD | IBV_SRQ_INIT_ATTR_TYPE)) &&
+	    (mask & IBV_SRQ_INIT_ATTR_PD) &&
+	    (!(mask & IBV_SRQ_INIT_ATTR_TYPE) ||
+	     (srq_init_attr_ex->srq_type == IBV_SRQT_BASIC)))
+		return ibv_create_srq(srq_init_attr_ex->pd,
+				      (struct ibv_srq_init_attr *)srq_init_attr_ex);
+
+	vctx = verbs_get_ctx_op(context, create_srq_ex);
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+	return vctx->create_srq_ex(context, srq_init_attr_ex);
+}
+
 /**
  * ibv_modify_srq - Modifies the attributes for the specified SRQ.
  * @srq: The SRQ to modify.
@@ -1083,6 +1133,16 @@ int ibv_modify_srq(struct ibv_srq *srq,
  */
 int ibv_query_srq(struct ibv_srq *srq, struct ibv_srq_attr *srq_attr);
 
+static inline int ibv_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(srq->context, get_srq_num);
+
+	if (!vctx)
+		return ENOSYS;
+
+	return vctx->get_srq_num(srq, srq_num);
+}
+
 /**
  * ibv_destroy_srq - Destroys the specified SRQ.
  * @srq: The SRQ to destroy.
diff --git a/src/cmd.c b/src/cmd.c
index f3d590a..fae2846 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -442,6 +442,81 @@ int ibv_cmd_create_srq(struct ibv_pd *pd,
 	return 0;
 }
 
+int ibv_cmd_create_srq_ex(struct ibv_context *context,
+			  struct verbs_srq *srq, int vsrq_sz,
+			  struct ibv_srq_init_attr_ex *attr_ex,
+			  struct ibv_create_xsrq *cmd, size_t cmd_size,
+			  struct ibv_create_srq_resp *resp, size_t resp_size)
+{
+	struct verbs_xrcd *vxrcd = NULL;
+
+	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_XSRQ, resp, resp_size);
+
+	if (attr_ex->comp_mask >= IBV_SRQ_INIT_ATTR_RESERVED)
+		return ENOSYS;
+
+	if (!(attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_PD))
+		return EINVAL;
+
+	cmd->user_handle = (uintptr_t) srq;
+	cmd->pd_handle   = attr_ex->pd->handle;
+	cmd->max_wr      = attr_ex->attr.max_wr;
+	cmd->max_sge     = attr_ex->attr.max_sge;
+	cmd->srq_limit   = attr_ex->attr.srq_limit;
+
+	cmd->srq_type = (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_TYPE) ?
+			attr_ex->srq_type : IBV_SRQT_BASIC;
+	if (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_XRCD) {
+		if (!(attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_CQ))
+			return EINVAL;
+
+		vxrcd = container_of(attr_ex->xrcd, struct verbs_xrcd, xrcd);
+		cmd->xrcd_handle = vxrcd->handle;
+		cmd->cq_handle   = attr_ex->cq->handle;
+	}
+
+	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	srq->srq.handle           = resp->srq_handle;
+	srq->srq.context          = context;
+	srq->srq.srq_context      = attr_ex->srq_context;
+	srq->srq.pd               = attr_ex->pd;
+	srq->srq.events_completed = 0;
+	pthread_mutex_init(&srq->srq.mutex, NULL);
+	pthread_cond_init(&srq->srq.cond, NULL);
+
+	/*
+	 * check that the last field is available.
+	 * If it is than all the others exist as well
+	 */
+	if (vext_field_avail(struct verbs_srq, srq_num, vsrq_sz)) {
+		srq->comp_mask = IBV_SRQ_INIT_ATTR_TYPE;
+		srq->srq_type = (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_TYPE) ?
+				attr_ex->srq_type : IBV_SRQT_BASIC;
+		if (srq->srq_type == IBV_SRQT_XRC) {
+			srq->comp_mask |= VERBS_SRQ_NUM;
+			srq->srq_num = resp->srqn;
+		}
+		if (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_XRCD) {
+			srq->comp_mask |= VERBS_SRQ_XRCD;
+			srq->xrcd = vxrcd;
+		}
+		if (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_CQ) {
+			srq->comp_mask |= VERBS_SRQ_CQ;
+			srq->cq = attr_ex->cq;
+		}
+	}
+
+	attr_ex->attr.max_wr = resp->max_wr;
+	attr_ex->attr.max_sge = resp->max_sge;
+
+	return 0;
+}
+
+
 static int ibv_cmd_modify_srq_v3(struct ibv_srq *srq,
 				 struct ibv_srq_attr *srq_attr,
 				 int srq_attr_mask,
diff --git a/src/libibverbs.map b/src/libibverbs.map
index c190eb9..a4b089f 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -103,4 +103,6 @@ IBVERBS_1.1 {
 
 		ibv_cmd_open_xrcd;
 		ibv_cmd_close_xrcd;
+		ibv_cmd_create_srq_ex;
+
 } IBVERBS_1.0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

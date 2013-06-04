From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH libibverbs v6 5/7] libibverbs: Add ibv_open_qp
Date: Tue,  4 Jun 2013 11:49:49 -0700
Message-ID: <1370371791-15018-6-git-send-email-sean.hefty@intel.com>
References: <1370371791-15018-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370371791-15018-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

XRC receive QPs are shareable across multiple processes.  Allow
any process with access to the xrc domain to open an existing
QP.  After opening the QP, the process will receive events
related to the QP and be able to modify the QP.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/driver.h   |    4 +++
 include/infiniband/kern-abi.h |   20 ++++++++++++++++-
 include/infiniband/verbs.h    |   35 +++++++++++++++++++++++++++++++-
 src/cmd.c                     |   45 +++++++++++++++++++++++++++++++++++++++++
 src/libibverbs.map            |    1 +
 5 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index d43ae07..a63d1e9 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -166,6 +166,10 @@ int ibv_cmd_create_qp_ex(struct ibv_context *context,
 			 struct verbs_qp *qp, struct ibv_qp_init_attr_ex *attr_ex,
 			 struct ibv_create_qp *cmd, size_t cmd_size,
 			 struct ibv_create_qp_resp *resp, size_t resp_size);
+int ibv_cmd_open_qp(struct ibv_context *context,
+		    struct verbs_qp *qp, struct ibv_qp_open_attr *attr,
+		    struct ibv_open_qp *cmd, size_t cmd_size,
+		    struct ibv_create_qp_resp *resp, size_t resp_size);
 int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *qp_attr,
 		     int attr_mask,
 		     struct ibv_qp_init_attr *qp_init_attr,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index bad0289..d7d7081 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -88,7 +88,8 @@ enum {
 	IB_USER_VERBS_CMD_POST_SRQ_RECV,
 	IB_USER_VERBS_CMD_OPEN_XRCD,
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
-	IB_USER_VERBS_CMD_CREATE_XSRQ
+	IB_USER_VERBS_CMD_CREATE_XSRQ,
+	IB_USER_VERBS_CMD_OPEN_QP
 };
 
 /*
@@ -476,6 +477,20 @@ struct ibv_create_qp {
 	__u64 driver_data[0];
 };
 
+struct ibv_open_qp {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u64 response;
+	__u64 user_handle;
+	__u32 pd_handle;
+	__u32 qpn;
+	__u8  qp_type;
+	__u8  reserved[7];
+	__u64 driver_data[0];
+};
+
+/* also used for open response */
 struct ibv_create_qp_resp {
 	__u32 qp_handle;
 	__u32 qpn;
@@ -852,7 +867,8 @@ enum {
 	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL_V2 = -1,
 	IB_USER_VERBS_CMD_OPEN_XRCD_V2 = -1,
 	IB_USER_VERBS_CMD_CLOSE_XRCD_V2 = -1,
-	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1
+	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1,
+	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1
 };
 
 struct ibv_modify_srq_v3 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 86d6ce6..4b3c832 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -520,6 +520,22 @@ struct ibv_qp_init_attr_ex {
 	struct ibv_xrcd	       *xrcd;
 };
 
+enum ibv_qp_open_attr_mask {
+	IBV_QP_OPEN_ATTR_NUM		= 1 << 0,
+	IBV_QP_OPEN_ATTR_CONTEXT	= 1 << 1,
+	IBV_QP_OPEN_ATTR_XRCD		= 1 << 2,
+	IBV_QP_OPEN_ATTR_TYPE		= 1 << 3,
+	IBV_QP_OPEN_ATTR_RESERVED	= 1 << 4
+ };
+
+struct ibv_qp_open_attr {
+	uint32_t		comp_mask;
+	uint32_t		qp_num;
+	struct ibv_xrcd        *xrcd;
+	void		       *qp_context;
+	enum ibv_qp_type	qp_type;
+};
+
 enum ibv_qp_attr_mask {
 	IBV_QP_STATE			= 1 << 	0,
 	IBV_QP_CUR_STATE		= 1 << 	1,
@@ -551,7 +567,8 @@ enum ibv_qp_state {
 	IBV_QPS_RTS,
 	IBV_QPS_SQD,
 	IBV_QPS_SQE,
-	IBV_QPS_ERR
+	IBV_QPS_ERR,
+	IBV_QPS_UNKNOWN
 };
 
 enum ibv_mig_state {
@@ -827,6 +844,8 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	struct ibv_qp *		(*open_qp)(struct ibv_context *context,
+					   struct ibv_qp_open_attr *attr);
 	struct ibv_qp *		(*create_qp_ex)(struct ibv_context *context,
 						struct ibv_qp_init_attr_ex *qp_init_attr_ex);
 	uint32_t		(*get_srq_num)(struct ibv_srq *srq);
@@ -1214,6 +1233,20 @@ ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_ini
 }
 
 /**
+ * ibv_open_qp - Open a shareable queue pair.
+ */
+static inline struct ibv_qp *
+ibv_open_qp(struct ibv_context *context, struct ibv_qp_open_attr *qp_open_attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(context, open_qp);
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+	return vctx->open_qp(context, qp_open_attr);
+}
+
+/**
  * ibv_modify_qp - Modify a queue pair.
  */
 int ibv_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
diff --git a/src/cmd.c b/src/cmd.c
index 2786bed..f415d17 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -750,6 +750,51 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 	return 0;
 }
 
+int ibv_cmd_open_qp(struct ibv_context *context, struct verbs_qp *qp,
+		    struct ibv_qp_open_attr *attr,
+		    struct ibv_open_qp *cmd, size_t cmd_size,
+		    struct ibv_create_qp_resp *resp, size_t resp_size)
+{
+	struct verbs_xrcd *xrcd;
+	IBV_INIT_CMD_RESP(cmd, cmd_size, OPEN_QP, resp, resp_size);
+
+	if (attr->comp_mask >= IBV_QP_OPEN_ATTR_RESERVED)
+		return ENOSYS;
+
+	if (!(attr->comp_mask & IBV_QP_OPEN_ATTR_XRCD) ||
+	    !(attr->comp_mask & IBV_QP_OPEN_ATTR_NUM) ||
+	    !(attr->comp_mask & IBV_QP_OPEN_ATTR_TYPE))
+		return EINVAL;
+
+	xrcd = container_of(attr->xrcd, struct verbs_xrcd, xrcd);
+	cmd->user_handle = (uintptr_t) qp;
+	cmd->pd_handle   = xrcd->handle;
+	cmd->qpn         = attr->qp_num;
+	cmd->qp_type     = attr->qp_type;
+
+	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	qp->qp.handle     = resp->qp_handle;
+	qp->qp.context    = context;
+	qp->qp.qp_context = attr->qp_context;
+	qp->qp.pd	  = NULL;
+	qp->qp.send_cq	  = qp->qp.recv_cq = NULL;
+	qp->qp.srq	  = NULL;
+	qp->qp.qp_num	  = attr->qp_num;
+	qp->qp.qp_type	  = attr->qp_type;
+	qp->qp.state	  = IBV_QPS_UNKNOWN;
+	qp->qp.events_completed = 0;
+	pthread_mutex_init(&qp->qp.mutex, NULL);
+	pthread_cond_init(&qp->qp.cond, NULL);
+	qp->comp_mask	  = VERBS_QP_XRCD;
+	qp->xrcd	  = xrcd;
+
+	return 0;
+}
+
 int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		     int attr_mask,
 		     struct ibv_qp_init_attr *init_attr,
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 8626699..9685487 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -105,5 +105,6 @@ IBVERBS_1.1 {
 		ibv_cmd_close_xrcd;
 		ibv_cmd_create_srq_ex;
 		ibv_cmd_create_qp_ex;
+		ibv_cmd_open_qp;
 		
 } IBVERBS_1.0;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 5/7] libibverbs: Add ibv_open_qp
Date: Fri, 28 Sep 2012 00:01:53 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A97D71@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC receive QPs are shareable across multiple processes.  Allow
any process with access to the xrc domain to open an existing
QP.  After opening the QP, the process will receive events
related to the QP and be able to modify the QP.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
changes from v1:
Similar to patch 2 changes for xrcd's.

 include/infiniband/driver.h   |    4 ++++
 include/infiniband/kern-abi.h |   20 ++++++++++++++++--
 include/infiniband/verbs.h    |   35 +++++++++++++++++++++++++++++++-
 src/cmd.c                     |   45 +++++++++++++++++++++++++++++++++++++++++
 src/libibverbs.map            |    1 +
 5 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 6bbb10d..c5b9f90 100644
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
index b6d5ce9..e24fa4f 100644
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
 
 struct ibv_destroy_cq_v1 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index a8dd0a5..34450a2 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -486,6 +486,22 @@ struct ibv_qp_init_attr_ex {
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
@@ -517,7 +533,8 @@ enum ibv_qp_state {
 	IBV_QPS_RTS,
 	IBV_QPS_SQD,
 	IBV_QPS_SQE,
-	IBV_QPS_ERR
+	IBV_QPS_ERR,
+	IBV_QPS_UNKNOWN
 };
 
 enum ibv_mig_state {
@@ -789,6 +806,8 @@ struct verbs_context {
 	int (*drv_new_func1) ();	new corresponding provider call of func1
 	int (*lib_new_func1) ();	New library call func1
 	*/
+	struct ibv_qp *		(*open_qp)(struct ibv_context *context,
+					   struct ibv_qp_open_attr *attr);
 	struct ibv_qp *		(*create_qp_ex)(struct ibv_context *context,
 						struct ibv_qp_init_attr_ex *qp_init_attr_ex);
 	uint32_t		(*get_srq_num)(struct ibv_srq *srq);
@@ -1162,6 +1181,20 @@ ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_ini
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
index b8ab132..132f9bc 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -809,6 +809,51 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
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
index 4249793..5ad8312 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -102,5 +102,6 @@ IBVERBS_1.1 {
 		ibv_cmd_close_xrcd;
 		ibv_cmd_create_srq_ex;
 		ibv_cmd_create_qp_ex;
+		ibv_cmd_open_qp;
 		
 } IBVERBS_1.0;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

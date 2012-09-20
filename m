From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/8] libibverbs: libibverbs: Add ibv_open_qp
Date: Thu, 20 Sep 2012 21:43:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8E811@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC receive QPs are shareable across multiple processes.  Allow
any process with access to the xrc domain to open an existing
QP.  After opening the QP, the process will receive events
related to the QP and be able to modify the QP.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/driver.h   |    4 ++++
 include/infiniband/kern-abi.h |   20 ++++++++++++++++++--
 include/infiniband/verbs.h    |   25 ++++++++++++++++++++++++-
 src/cmd.c                     |   22 ++++++++++++++++++++++
 src/libibverbs.map            |    2 ++
 src/verbs.c                   |   36 ++++++++++++++++++++++++++++++++++++
 6 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index c86109d..968888f 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -126,6 +126,10 @@ int ibv_cmd_create_qp_ex(struct ibv_pd *pd,
 			 struct ibv_qp *qp, struct ibv_qp_init_attr_ex *attr_ex,
 			 struct ibv_create_qp *cmd, size_t cmd_size,
 			 struct ibv_create_qp_resp *resp, size_t resp_size);
+int ibv_cmd_open_qp(struct ibv_xrcd *xrcd,
+		    struct ibv_qp *qp, struct ibv_qp_open_attr *attr,
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
index 9524095..a3bf14c 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -504,6 +504,20 @@ struct ibv_qp_init_attr_ex {
 	struct ibv_xrcd	       *xrcd;
 };
 
+enum ibv_qp_open_attr_mask {
+	IBV_QP_OPEN_ATTR_CONTEXT	= 1 << 0,
+	IBV_QP_OPEN_ATTR_NUM		= 1 << 1,
+	IBV_QP_OPEN_ATTR_TYPE		= 1 << 2,
+	IBV_QP_OPEN_ATTR_RESERVED	= 1 << 3
+ };
+
+struct ibv_qp_open_attr {
+	uint32_t		comp_mask;
+	uint32_t		qp_num;
+	void		       *qp_context;
+	enum ibv_qp_type	qp_type;
+};
+
 enum ibv_qp_attr_mask {
 	IBV_QP_STATE			= 1 << 	0,
 	IBV_QP_CUR_STATE		= 1 << 	1,
@@ -535,7 +549,8 @@ enum ibv_qp_state {
 	IBV_QPS_RTS,
 	IBV_QPS_SQD,
 	IBV_QPS_SQE,
-	IBV_QPS_ERR
+	IBV_QPS_ERR,
+	IBV_QPS_UNKNOWN
 };
 
 enum ibv_mig_state {
@@ -848,6 +863,8 @@ struct verbs_context {
 	int (*drv_new_func1) ();	new corresponding provider call of func1
 	int (*lib_new_func1) ();	New library call func1
 	*/
+	struct ibv_qp *		(*open_qp)(struct ibv_xrcd *xrcd,
+					   struct ibv_qp_open_attr *attr);
 	struct ibv_qp *		(*create_qp_ex)(struct ibv_pd *pd,
 						struct ibv_qp_init_attr_ex *qp_init_attr_ex);
 	struct ibv_srq *	(*create_srq_ex)(struct ibv_pd *pd,
@@ -1171,6 +1188,12 @@ struct ibv_qp *ibv_create_qp_ex(struct ibv_pd *pd,
 				struct ibv_qp_init_attr_ex *qp_init_attr_ex);
 
 /**
+ * ibv_open_qp - Open a shareable queue pair.
+ */
+struct ibv_qp *ibv_open_qp(struct ibv_xrcd *xrcd,
+			   struct ibv_qp_open_attr *qp_open_attr);
+
+/**
  * ibv_modify_qp - Modify a queue pair.
  */
 int ibv_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
diff --git a/src/cmd.c b/src/cmd.c
index 005bf94..be4fac7 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -716,6 +716,28 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 	return ret;
 }
 
+int ibv_cmd_open_qp(struct ibv_xrcd *xrcd, struct ibv_qp *qp,
+		    struct ibv_qp_open_attr *attr,
+		    struct ibv_open_qp *cmd, size_t cmd_size,
+		    struct ibv_create_qp_resp *resp, size_t resp_size)
+{
+	IBV_INIT_CMD_RESP(cmd, cmd_size, OPEN_QP, resp, resp_size);
+
+	cmd->user_handle = (uintptr_t) qp;
+	cmd->pd_handle   = xrcd->handle;
+	cmd->qpn         = attr->qp_num;
+	cmd->qp_type     = attr->qp_type;
+
+	if (write(xrcd->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	qp->handle     = resp->qp_handle;
+
+	return 0;
+}
+
 int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		     int attr_mask,
 		     struct ibv_qp_init_attr *init_attr,
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 9ee1cf2..93903c2 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -106,5 +106,7 @@ IBVERBS_1.1 {
 		ibv_cmd_create_srq_ex;
 		ibv_create_qp_ex;
 		ibv_cmd_create_qp_ex;
+		ibv_open_qp;
+		ibv_cmd_open_qp;
 		
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index 02f08aa..e42695e 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -527,6 +527,42 @@ struct ibv_qp *__ibv_create_qp(struct ibv_pd *pd,
 }
 default_symver(__ibv_create_qp, ibv_create_qp);
 
+struct ibv_qp *__ibv_open_qp(struct ibv_xrcd *xrcd,
+			     struct ibv_qp_open_attr *qp_open_attr)
+{
+	struct verbs_context *context_ex;
+	struct ibv_qp *qp;
+
+	context_ex = verbs_get_ctx(xrcd->context);
+	if (!context_ex->open_qp ||
+	    qp_open_attr->comp_mask >= IBV_QP_OPEN_ATTR_RESERVED) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	qp = context_ex->open_qp(xrcd, qp_open_attr);
+	if (qp) {
+		qp->context    = xrcd->context;
+		qp->qp_context = qp_open_attr->qp_context;
+
+		qp->pd = NULL;
+		qp->send_cq = qp->recv_cq = NULL;
+		qp->srq = NULL;
+		qp->comp_mask |= IBV_QP_XRCD;
+		qp->xrcd = xrcd;
+
+		qp->qp_num  = qp_open_attr->qp_num;
+		qp->qp_type = qp_open_attr->qp_type;
+		qp->state   = IBV_QPS_UNKNOWN;
+		qp->events_completed = 0;
+		pthread_mutex_init(&qp->mutex, NULL);
+		pthread_cond_init(&qp->cond, NULL);
+	}
+
+	return qp;
+}
+default_symver(__ibv_open_qp, ibv_open_qp);
+
 int __ibv_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		   int attr_mask,
 		   struct ibv_qp_init_attr *init_attr)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

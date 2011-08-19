From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6 v2] libibverbs: Add ibv_open_qp()
Date: Fri, 19 Aug 2011 02:47:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41B7A@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC receive QPs are shareable across multiple processes.  Allow
any process with access to the xrc domain to open an existing
QP.  After opening the QP, the process will receive events
related to the QP and be able to modify the QP.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Submitting this change separate from xrc support, since the corresponding
kernel changes are new and have not been discussed.

 include/infiniband/driver.h   |    4 ++++
 include/infiniband/kern-abi.h |   18 +++++++++++++++++-
 include/infiniband/verbs.h    |   17 ++++++++++++++++-
 src/cmd.c                     |   22 ++++++++++++++++++++++
 src/libibverbs.map            |    2 ++
 src/verbs.c                   |   29 +++++++++++++++++++++++++++++
 6 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 9aea854..7fad2a2 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -122,6 +122,10 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 		      struct ibv_qp *qp, struct ibv_qp_init_attr *attr,
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
index 36cd133..32a14c7 100644
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
@@ -475,6 +476,20 @@ struct ibv_create_qp {
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
@@ -852,6 +867,7 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_XRCD_V2 = -1,
 	IB_USER_VERBS_CMD_CLOSE_XRCD_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1,
+	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1,
 };
 
 struct ibv_destroy_cq_v1 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 183d171..81077d8 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -450,6 +450,12 @@ struct ibv_qp_init_attr {
 	} ext;
 };
 
+struct ibv_qp_open_attr {
+	void		       *qp_context;
+	uint32_t		qp_num;
+	enum ibv_qp_type	qp_type;
+};
+
 enum ibv_qp_attr_mask {
 	IBV_QP_STATE			= 1 << 	0,
 	IBV_QP_CUR_STATE		= 1 << 	1,
@@ -481,7 +487,8 @@ enum ibv_qp_state {
 	IBV_QPS_RTS,
 	IBV_QPS_SQD,
 	IBV_QPS_SQE,
-	IBV_QPS_ERR
+	IBV_QPS_ERR,
+	IBV_QPS_UNKNOWN
 };
 
 enum ibv_mig_state {
@@ -757,6 +764,8 @@ struct ibv_xrc_ops {
 	struct ibv_xrcd *	(*open_xrcd)(struct ibv_context *context,
 					     int fd, int oflags);
 	int			(*close_xrcd)(struct ibv_xrcd *xrcd);
+	struct ibv_qp *		(*open_qp)(struct ibv_xrcd *xrcd,
+					   struct ibv_qp_open_attr *attr);
 };
 
 struct ibv_context {
@@ -1072,6 +1081,12 @@ struct ibv_qp *ibv_create_qp(struct ibv_pd *pd,
 			     struct ibv_qp_init_attr *qp_init_attr);
 
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
index 6d82d94..582d8b2 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -734,6 +734,28 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 	return 0;
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
index c2f7bb4..efd6712 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -108,4 +108,6 @@ IBVERBS_1.1 {
 		ibv_open_xrcd;
 		ibv_close_xrcd;
 		ibv_create_xsrq;
+		ibv_cmd_open_qp;
+		ibv_open_qp;
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index 40dbef5..1631610 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -502,6 +502,35 @@ struct ibv_qp *__ibv_create_qp(struct ibv_pd *pd,
 }
 default_symver(__ibv_create_qp, ibv_create_qp);
 
+struct ibv_qp *__ibv_open_qp(struct ibv_xrcd *xrcd,
+			     struct ibv_qp_open_attr *qp_open_attr)
+{
+	struct ibv_xrc_ops *ops;
+	struct ibv_qp *qp;
+
+	ops = ibv_get_ext_ops(xrcd->context, IBV_XRC_OPS);
+	qp = ops->open_qp(xrcd, qp_open_attr);
+	if (qp) {
+		qp->context    = xrcd->context;
+		qp->qp_context = qp_open_attr->qp_context;
+
+		qp->pd = NULL;
+		qp->send_cq = qp->recv_cq = NULL;
+		qp->srq = NULL;
+		qp->ext.xrc_recv.xrcd = xrcd;
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

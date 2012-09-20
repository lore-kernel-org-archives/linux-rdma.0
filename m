From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/8] libibverbs: libibverbs: Add support for XRC QPs
Date: Thu, 20 Sep 2012 21:43:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8E80B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC queue pairs: xrc defines two new types of QPs.  The
initiator, or send-side, xrc qp behaves similar to a send-
only RC qp.  xrc send qp's are managed through the existing
QP functions.  The send_wr structure is extended in a back-
wards compatible way to support posting sends on a send xrc
qp, which require specifying the remote xrc srq.

The target, or receive-side, xrc qp behaves differently
than other implemented qp's.  A recv xrc qp can be created,
modified, and destroyed like other qp's through the existing
calls.  The qp_init_attr structure is extended for xrc qp's.

Because xrc recv qp's are bound to an xrcd, rather than a pd,
it is intended to be used among multiple processes.  Any process
with access to an xrcd may allocate and connect an xrc recv qp.
The actual xrc recv qp is allocated and managed by the kernel.
If the owning process explicit destroys the xrc recv qp, it is
destroyed.  However, if the xrc recv qp is left open when the
user process exits or closes its device, then the lifetime of
the xrc recv qp is bound with the lifetime of the xrcd.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/driver.h   |    4 ++
 include/infiniband/kern-abi.h |    5 +++
 include/infiniband/verbs.h    |   39 +++++++++++++++++++--
 src/cmd.c                     |   76 +++++++++++++++++++++++++++++------------
 src/libibverbs.map            |    2 +
 src/verbs.c                   |   60 ++++++++++++++++++++++++++++----
 6 files changed, 151 insertions(+), 35 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index cac48ab..c86109d 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -122,6 +122,10 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 		      struct ibv_qp *qp, struct ibv_qp_init_attr *attr,
 		      struct ibv_create_qp *cmd, size_t cmd_size,
 		      struct ibv_create_qp_resp *resp, size_t resp_size);
+int ibv_cmd_create_qp_ex(struct ibv_pd *pd,
+			 struct ibv_qp *qp, struct ibv_qp_init_attr_ex *attr_ex,
+			 struct ibv_create_qp *cmd, size_t cmd_size,
+			 struct ibv_create_qp_resp *resp, size_t resp_size);
 int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *qp_attr,
 		     int attr_mask,
 		     struct ibv_qp_init_attr *qp_init_attr,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 3d72fa7..b6d5ce9 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -617,6 +617,11 @@ struct ibv_kern_send_wr {
 			__u32 remote_qkey;
 			__u32 reserved;
 		} ud;
+		struct {
+			__u64 reserved[3];
+			__u32 reserved2;
+			__u32 remote_srqn;
+		} xrc;
 	} wr;
 };
 
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 8756fed..9524095 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -106,7 +106,8 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_SYS_IMAGE_GUID	= 1 << 11,
 	IBV_DEVICE_RC_RNR_NAK_GEN	= 1 << 12,
 	IBV_DEVICE_SRQ_RESIZE		= 1 << 13,
-	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14
+	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14,
+	IBV_DEVICE_XRC			= 1 << 20
 };
 
 enum ibv_atomic_cap {
@@ -462,7 +463,9 @@ struct ibv_srq_init_attr_ex {
 enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
-	IBV_QPT_UD
+	IBV_QPT_UD,
+	IBV_QPT_XRC_SEND = 9,
+	IBV_QPT_XRC_RECV
 };
 
 struct ibv_qp_cap {
@@ -483,6 +486,24 @@ struct ibv_qp_init_attr {
 	int			sq_sig_all;
 };
 
+enum ibv_qp_init_attr_mask {
+	IBV_QP_INIT_ATTR_XRCD		= 1 << 0,
+	IBV_QP_INIT_ATTR_RESERVED	= 1 << 1
+};
+
+struct ibv_qp_init_attr_ex {
+	void		       *qp_context;
+	struct ibv_cq	       *send_cq;
+	struct ibv_cq	       *recv_cq;
+	struct ibv_srq	       *srq;
+	struct ibv_qp_cap	cap;
+	enum ibv_qp_type	qp_type;
+	int			sq_sig_all;
+
+	uint64_t		comp_mask;
+	struct ibv_xrcd	       *xrcd;
+};
+
 enum ibv_qp_attr_mask {
 	IBV_QP_STATE			= 1 << 	0,
 	IBV_QP_CUR_STATE		= 1 << 	1,
@@ -598,6 +619,11 @@ struct ibv_send_wr {
 			uint32_t	remote_qpn;
 			uint32_t	remote_qkey;
 		} ud;
+		struct {
+			uint64_t	reserved[3];
+			uint32_t	reserved2;
+			uint32_t	remote_srqn;
+		} xrc;
 	} wr;
 };
 
@@ -643,7 +669,8 @@ struct ibv_srq {
 };
 
 enum ibv_qp_mask {
-	IBV_QP_RESERVED			= 1 << 0
+	IBV_QP_XRCD			= 1 << 0,
+	IBV_QP_RESERVED			= 1 << 1
 };
 
 struct ibv_qp {
@@ -663,6 +690,7 @@ struct ibv_qp {
 	uint32_t		events_completed;
 
 	uint32_t		comp_mask;
+	struct ibv_xrcd	       *xrcd;
 };
 
 enum ibv_comp_channel_mask {
@@ -820,6 +848,8 @@ struct verbs_context {
 	int (*drv_new_func1) ();	new corresponding provider call of func1
 	int (*lib_new_func1) ();	New library call func1
 	*/
+	struct ibv_qp *		(*create_qp_ex)(struct ibv_pd *pd,
+						struct ibv_qp_init_attr_ex *qp_init_attr_ex);
 	struct ibv_srq *	(*create_srq_ex)(struct ibv_pd *pd,
 						 struct ibv_srq_init_attr_ex *srq_init_attr_ex);
 	struct ibv_xrcd *	(*open_xrcd)(struct ibv_context *context,
@@ -1137,6 +1167,9 @@ static inline int ibv_post_srq_recv(struct ibv_srq *srq,
 struct ibv_qp *ibv_create_qp(struct ibv_pd *pd,
 			     struct ibv_qp_init_attr *qp_init_attr);
 
+struct ibv_qp *ibv_create_qp_ex(struct ibv_pd *pd,
+				struct ibv_qp_init_attr_ex *qp_init_attr_ex);
+
 /**
  * ibv_modify_qp - Modify a queue pair.
  */
diff --git a/src/cmd.c b/src/cmd.c
index 58326c7..005bf94 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -628,43 +628,56 @@ int ibv_cmd_destroy_srq(struct ibv_srq *srq)
 	return 0;
 }
 
-int ibv_cmd_create_qp(struct ibv_pd *pd,
-		      struct ibv_qp *qp, struct ibv_qp_init_attr *attr,
-		      struct ibv_create_qp *cmd, size_t cmd_size,
-		      struct ibv_create_qp_resp *resp, size_t resp_size)
+int ibv_cmd_create_qp_ex(struct ibv_pd *pd,
+			 struct ibv_qp *qp, struct ibv_qp_init_attr_ex *attr_ex,
+			 struct ibv_create_qp *cmd, size_t cmd_size,
+			 struct ibv_create_qp_resp *resp, size_t resp_size)
 {
+	struct ibv_context *context;
+
 	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_QP, resp, resp_size);
 
 	cmd->user_handle     = (uintptr_t) qp;
-	cmd->pd_handle 	     = pd->handle;
-	cmd->send_cq_handle  = attr->send_cq->handle;
-	cmd->recv_cq_handle  = attr->recv_cq->handle;
-	cmd->srq_handle      = attr->srq ? attr->srq->handle : 0;
-	cmd->max_send_wr     = attr->cap.max_send_wr;
-	cmd->max_recv_wr     = attr->cap.max_recv_wr;
-	cmd->max_send_sge    = attr->cap.max_send_sge;
-	cmd->max_recv_sge    = attr->cap.max_recv_sge;
-	cmd->max_inline_data = attr->cap.max_inline_data;
-	cmd->sq_sig_all	     = attr->sq_sig_all;
-	cmd->qp_type 	     = attr->qp_type;
-	cmd->is_srq 	     = !!attr->srq;
+
+	if (attr_ex->comp_mask & IBV_QP_INIT_ATTR_XRCD) {
+		context		= attr_ex->xrcd->context;
+		cmd->pd_handle	= attr_ex->xrcd->handle;
+	} else {
+		context		= pd->context;
+		cmd->pd_handle	= pd->handle;
+		cmd->send_cq_handle = attr_ex->send_cq->handle;
+
+		if (attr_ex->qp_type != IBV_QPT_XRC_SEND) {
+			cmd->recv_cq_handle = attr_ex->recv_cq->handle;
+			cmd->srq_handle = attr_ex->srq ? attr_ex->srq->handle : 0;
+		}
+	}
+
+	cmd->max_send_wr     = attr_ex->cap.max_send_wr;
+	cmd->max_recv_wr     = attr_ex->cap.max_recv_wr;
+	cmd->max_send_sge    = attr_ex->cap.max_send_sge;
+	cmd->max_recv_sge    = attr_ex->cap.max_recv_sge;
+	cmd->max_inline_data = attr_ex->cap.max_inline_data;
+	cmd->sq_sig_all	     = attr_ex->sq_sig_all;
+	cmd->qp_type 	     = attr_ex->qp_type;
+	cmd->is_srq 	     = !!attr_ex->srq;
 	cmd->reserved	     = 0;
 
-	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
+	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
 	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	qp->handle 		  = resp->qp_handle;
 	qp->qp_num 		  = resp->qpn;
-	qp->context		  = pd->context;
+	qp->context		  = context;
 
 	if (abi_ver > 3) {
-		attr->cap.max_recv_sge    = resp->max_recv_sge;
-		attr->cap.max_send_sge    = resp->max_send_sge;
-		attr->cap.max_recv_wr     = resp->max_recv_wr;
-		attr->cap.max_send_wr     = resp->max_send_wr;
-		attr->cap.max_inline_data = resp->max_inline_data;
+		attr_ex->cap.max_recv_sge    = resp->max_recv_sge;
+		attr_ex->cap.max_send_sge    = resp->max_send_sge;
+		attr_ex->cap.max_recv_wr     = resp->max_recv_wr;
+		attr_ex->cap.max_send_wr     = resp->max_send_wr;
+		attr_ex->cap.max_inline_data = resp->max_inline_data;
 	}
 
 	if (abi_ver == 4) {
@@ -686,6 +699,23 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 	return 0;
 }
 
+int ibv_cmd_create_qp(struct ibv_pd *pd,
+		      struct ibv_qp *qp, struct ibv_qp_init_attr *attr,
+		      struct ibv_create_qp *cmd, size_t cmd_size,
+		      struct ibv_create_qp_resp *resp, size_t resp_size)
+{
+	struct ibv_qp_init_attr_ex attr_ex;
+	int ret;
+
+	memcpy(&attr_ex, attr, sizeof *attr);
+	attr_ex.comp_mask = 0;
+	ret = ibv_cmd_create_qp_ex(pd, qp, &attr_ex, cmd, cmd_size, resp, resp_size);
+	if (!ret)
+		memcpy(attr, &attr_ex, sizeof *attr);
+
+	return ret;
+}
+
 int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		     int attr_mask,
 		     struct ibv_qp_init_attr *init_attr,
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 92bfabd..9ee1cf2 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -104,5 +104,7 @@ IBVERBS_1.1 {
 		ibv_cmd_close_xrcd;
 		ibv_create_srq_ex;
 		ibv_cmd_create_srq_ex;
+		ibv_create_qp_ex;
+		ibv_cmd_create_qp_ex;
 		
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index a645173..02f08aa 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -462,19 +462,45 @@ int __ibv_destroy_srq(struct ibv_srq *srq)
 }
 default_symver(__ibv_destroy_srq, ibv_destroy_srq);
 
-struct ibv_qp *__ibv_create_qp(struct ibv_pd *pd,
-			       struct ibv_qp_init_attr *qp_init_attr)
+struct ibv_qp *__ibv_create_qp_ex(struct ibv_pd *pd,
+				  struct ibv_qp_init_attr_ex *qp_init_attr_ex)
 {
-	struct ibv_qp *qp = pd->context->ops.create_qp(pd, qp_init_attr);
+	struct verbs_context *context_ex;
+	struct ibv_context *context = NULL;
+	struct ibv_qp *qp;
+
+	if (pd) {
+		context = pd->context;
+	} else {
+		if (qp_init_attr_ex->comp_mask & IBV_QP_INIT_ATTR_XRCD)
+			context = qp_init_attr_ex->xrcd->context;
+	}
+	if (!context) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	context_ex = verbs_get_ctx(context);
+	if (qp_init_attr_ex->comp_mask) {
+		if (!context_ex->create_qp_ex ||
+		    qp_init_attr_ex->comp_mask >= IBV_QP_INIT_ATTR_RESERVED) {
+			errno = ENOSYS;
+			return NULL;
+		}
+		qp = context_ex->create_qp_ex(pd, qp_init_attr_ex);
+	} else {
+		qp = context->ops.create_qp(pd, (struct ibv_qp_init_attr *)
+						qp_init_attr_ex);
+	}
 
 	if (qp) {
-		qp->context    	     = pd->context;
-		qp->qp_context 	     = qp_init_attr->qp_context;
+		qp->context    	     = context;
+		qp->qp_context 	     = qp_init_attr_ex->qp_context;
 		qp->pd         	     = pd;
-		qp->send_cq    	     = qp_init_attr->send_cq;
-		qp->recv_cq    	     = qp_init_attr->recv_cq;
-		qp->srq        	     = qp_init_attr->srq;
-		qp->qp_type          = qp_init_attr->qp_type;
+		qp->send_cq    	     = qp_init_attr_ex->send_cq;
+		qp->recv_cq    	     = qp_init_attr_ex->recv_cq;
+		qp->srq        	     = qp_init_attr_ex->srq;
+		qp->qp_type          = qp_init_attr_ex->qp_type;
 		qp->state	     = IBV_QPS_RESET;
 		qp->events_completed = 0;
 		pthread_mutex_init(&qp->mutex, NULL);
@@ -483,6 +509,22 @@ struct ibv_qp *__ibv_create_qp(struct ibv_pd *pd,
 
 	return qp;
 }
+default_symver(__ibv_create_qp_ex, ibv_create_qp_ex);
+
+struct ibv_qp *__ibv_create_qp(struct ibv_pd *pd,
+			       struct ibv_qp_init_attr *qp_init_attr)
+{
+	struct ibv_qp_init_attr_ex qp_init_attr_ex;
+	struct ibv_qp *qp;
+
+	memcpy(&qp_init_attr_ex, qp_init_attr, sizeof *qp_init_attr);
+	qp_init_attr_ex.comp_mask = 0;
+	qp = ibv_create_qp_ex(pd, &qp_init_attr_ex);
+	if (qp)
+		memcpy(qp_init_attr, &qp_init_attr_ex, sizeof *qp_init_attr);
+
+	return qp;
+}
 default_symver(__ibv_create_qp, ibv_create_qp);
 
 int __ibv_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

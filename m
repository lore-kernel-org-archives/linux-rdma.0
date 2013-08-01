From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V9 libibverbs 4/7] Add support for XRC QPs
Date: Thu,  1 Aug 2013 18:04:16 +0300
Message-ID: <1375369459-9231-5-git-send-email-yishaih@mellanox.com>
References: <1375369459-9231-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375369459-9231-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

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
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/driver.h   |   15 ++++++
 include/infiniband/kern-abi.h |    5 ++
 include/infiniband/verbs.h    |   55 ++++++++++++++++++++++-
 src/cmd.c                     |   96 ++++++++++++++++++++++++++++++++++++++++-
 src/libibverbs.map            |    1 +
 5 files changed, 168 insertions(+), 4 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 11f52c2..91b5b12 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -81,6 +81,16 @@ struct verbs_srq {
 	uint32_t		srq_num;
 };
 
+enum verbs_qp_mask {
+	VERBS_QP_XRCD		= 1 << 0,
+	VERBS_QP_RESERVED	= 1 << 1
+};
+
+struct verbs_qp {
+	struct ibv_qp		qp;
+	uint32_t		comp_mask;
+	struct verbs_xrcd       *xrcd;
+};
 typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
 						   int abi_version);
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
@@ -154,6 +164,11 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 		      struct ibv_qp *qp, struct ibv_qp_init_attr *attr,
 		      struct ibv_create_qp *cmd, size_t cmd_size,
 		      struct ibv_create_qp_resp *resp, size_t resp_size);
+int ibv_cmd_create_qp_ex(struct ibv_context *context,
+			 struct verbs_qp *qp, int vqp_sz,
+			 struct ibv_qp_init_attr_ex *attr_ex,
+			 struct ibv_create_qp *cmd, size_t cmd_size,
+			 struct ibv_create_qp_resp *resp, size_t resp_size);
 int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *qp_attr,
 		     int attr_mask,
 		     struct ibv_qp_init_attr *qp_init_attr,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index ef93cc3..65f3ffd 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -618,6 +618,11 @@ struct ibv_kern_send_wr {
 			__u32 reserved;
 		} ud;
 	} wr;
+	union {
+		struct {
+			__u32 remote_srqn;
+		} xrc;
+	} qp_type;
 };
 
 struct ibv_post_send {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 1048d5d..a2c932a 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -110,7 +110,8 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_SYS_IMAGE_GUID	= 1 << 11,
 	IBV_DEVICE_RC_RNR_NAK_GEN	= 1 << 12,
 	IBV_DEVICE_SRQ_RESIZE		= 1 << 13,
-	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14
+	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14,
+	IBV_DEVICE_XRC			= 1 << 20
 };
 
 enum ibv_atomic_cap {
@@ -479,7 +480,9 @@ enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
 	IBV_QPT_UD,
-	IBV_QPT_RAW_PACKET = 8
+	IBV_QPT_RAW_PACKET = 8,
+	IBV_QPT_XRC_SEND = 9,
+	IBV_QPT_XRC_RECV
 };
 
 struct ibv_qp_cap {
@@ -500,6 +503,26 @@ struct ibv_qp_init_attr {
 	int			sq_sig_all;
 };
 
+enum ibv_qp_init_attr_mask {
+	IBV_QP_INIT_ATTR_PD		= 1 << 0,
+	IBV_QP_INIT_ATTR_XRCD		= 1 << 1,
+	IBV_QP_INIT_ATTR_RESERVED	= 1 << 2
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
+	uint32_t		comp_mask;
+	struct ibv_pd	       *pd;
+	struct ibv_xrcd	       *xrcd;
+};
+
 enum ibv_qp_attr_mask {
 	IBV_QP_STATE			= 1 << 	0,
 	IBV_QP_CUR_STATE		= 1 << 	1,
@@ -616,6 +639,11 @@ struct ibv_send_wr {
 			uint32_t	remote_qkey;
 		} ud;
 	} wr;
+	union {
+		struct {
+			uint32_t    remote_srqn;
+		} xrc;
+	} qp_type;
 };
 
 struct ibv_recv_wr {
@@ -796,11 +824,14 @@ struct ibv_context {
 enum verbs_context_mask {
 	VERBS_CONTEXT_XRCD	= 1 << 0,
 	VERBS_CONTEXT_SRQ	= 1 << 1,
-	VERBS_CONTEXT_RESERVED	= 1 << 2
+	VERBS_CONTEXT_QP	= 1 << 2,
+	VERBS_CONTEXT_RESERVED	= 1 << 3
 };
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	struct ibv_qp *(*create_qp_ex)(struct ibv_context *context,
+			struct ibv_qp_init_attr_ex *qp_init_attr_ex);
 	int (*get_srq_num)(struct ibv_srq *srq, uint32_t *srq_num);
 	struct ibv_srq *	(*create_srq_ex)(struct ibv_context *context,
 						 struct ibv_srq_init_attr_ex *srq_init_attr_ex);
@@ -1173,6 +1204,24 @@ static inline int ibv_post_srq_recv(struct ibv_srq *srq,
 struct ibv_qp *ibv_create_qp(struct ibv_pd *pd,
 			     struct ibv_qp_init_attr *qp_init_attr);
 
+static inline struct ibv_qp *
+ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_init_attr_ex)
+{
+	struct verbs_context *vctx;
+	uint32_t mask = qp_init_attr_ex->comp_mask;
+
+	if (mask == IBV_QP_INIT_ATTR_PD)
+		return ibv_create_qp(qp_init_attr_ex->pd,
+				     (struct ibv_qp_init_attr *)qp_init_attr_ex);
+
+	vctx = verbs_get_ctx_op(context, create_qp_ex);
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+	return vctx->create_qp_ex(context, qp_init_attr_ex);
+}
+
 /**
  * ibv_modify_qp - Modify a queue pair.
  */
diff --git a/src/cmd.c b/src/cmd.c
index fae2846..463b95b 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -610,6 +610,100 @@ int ibv_cmd_destroy_srq(struct ibv_srq *srq)
 	return 0;
 }
 
+int ibv_cmd_create_qp_ex(struct ibv_context *context,
+			 struct verbs_qp *qp, int vqp_sz,
+			 struct ibv_qp_init_attr_ex *attr_ex,
+			 struct ibv_create_qp *cmd, size_t cmd_size,
+			 struct ibv_create_qp_resp *resp, size_t resp_size)
+{
+	struct verbs_xrcd *vxrcd = NULL;
+
+	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_QP, resp, resp_size);
+
+	if (attr_ex->comp_mask >= IBV_QP_INIT_ATTR_RESERVED)
+		return ENOSYS;
+
+	cmd->user_handle     = (uintptr_t) qp;
+
+	if (attr_ex->comp_mask & IBV_QP_INIT_ATTR_XRCD) {
+		vxrcd = container_of(attr_ex->xrcd, struct verbs_xrcd, xrcd);
+		cmd->pd_handle	= vxrcd->handle;
+	} else {
+		if (!(attr_ex->comp_mask & IBV_QP_INIT_ATTR_PD))
+			return EINVAL;
+
+		cmd->pd_handle	= attr_ex->pd->handle;
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
+	cmd->qp_type         = attr_ex->qp_type;
+	cmd->is_srq	     = !!attr_ex->srq;
+	cmd->reserved	     = 0;
+
+	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	if (abi_ver > 3) {
+		attr_ex->cap.max_recv_sge    = resp->max_recv_sge;
+		attr_ex->cap.max_send_sge    = resp->max_send_sge;
+		attr_ex->cap.max_recv_wr     = resp->max_recv_wr;
+		attr_ex->cap.max_send_wr     = resp->max_send_wr;
+		attr_ex->cap.max_inline_data = resp->max_inline_data;
+	}
+
+	if (abi_ver == 4) {
+		struct ibv_create_qp_resp_v4 *resp_v4 =
+			(struct ibv_create_qp_resp_v4 *)resp;
+
+		memmove((void *)resp + sizeof *resp,
+			(void *)resp_v4 + sizeof *resp_v4,
+			resp_size - sizeof *resp);
+	} else if (abi_ver <= 3) {
+		struct ibv_create_qp_resp_v3 *resp_v3 =
+			(struct ibv_create_qp_resp_v3 *)resp;
+
+		memmove((void *)resp + sizeof *resp,
+			(void *)resp_v3 + sizeof *resp_v3,
+			resp_size - sizeof *resp);
+	}
+
+	qp->qp.handle		= resp->qp_handle;
+	qp->qp.qp_num		= resp->qpn;
+	qp->qp.context		= context;
+	qp->qp.qp_context	= attr_ex->qp_context;
+	qp->qp.pd		= attr_ex->pd;
+	qp->qp.send_cq		= attr_ex->send_cq;
+	qp->qp.recv_cq		= attr_ex->recv_cq;
+	qp->qp.srq		= attr_ex->srq;
+	qp->qp.qp_type		= attr_ex->qp_type;
+	qp->qp.state		= IBV_QPS_RESET;
+	qp->qp.events_completed = 0;
+	pthread_mutex_init(&qp->qp.mutex, NULL);
+	pthread_cond_init(&qp->qp.cond, NULL);
+
+	qp->comp_mask = 0;
+	if (vext_field_avail(struct verbs_qp, xrcd, vqp_sz) &&
+			    (attr_ex->comp_mask & IBV_QP_INIT_ATTR_XRCD)) {
+		qp->comp_mask |= VERBS_QP_XRCD;
+		qp->xrcd = vxrcd;
+	}
+
+	return 0;
+}
+
 int ibv_cmd_create_qp(struct ibv_pd *pd,
 		      struct ibv_qp *qp, struct ibv_qp_init_attr *attr,
 		      struct ibv_create_qp *cmd, size_t cmd_size,
@@ -618,7 +712,7 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_QP, resp, resp_size);
 
 	cmd->user_handle     = (uintptr_t) qp;
-	cmd->pd_handle 	     = pd->handle;
+	cmd->pd_handle       = pd->handle;
 	cmd->send_cq_handle  = attr->send_cq->handle;
 	cmd->recv_cq_handle  = attr->recv_cq->handle;
 	cmd->srq_handle      = attr->srq ? attr->srq->handle : 0;
diff --git a/src/libibverbs.map b/src/libibverbs.map
index a4b089f..6db5291 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -104,5 +104,6 @@ IBVERBS_1.1 {
 		ibv_cmd_open_xrcd;
 		ibv_cmd_close_xrcd;
 		ibv_cmd_create_srq_ex;
+		ibv_cmd_create_qp_ex;
 
 } IBVERBS_1.0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 2/2] libibverbs: Using extensions to define XRC support
Date: Sat, 4 Jun 2011 00:39:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373012B6C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Define a common libibverbs extension to support XRC.

XRC introduces several new concepts and structures:

XRC domains: xrcd's are a type of protection domain used to
associate shared receive queues with xrc queue pairs.  Since
xrcd are meant to be shared among multiple processes, we
introduce new APIs to open/close xrcd's.

XRC shared receive queues: xrc srq's are similar to normal
srq's, except that they are bound to an xrcd, rather
than to a protection domain.  Based on the current spec
and implementation, they are only usable with xrc qps.  To
support xrc srq's, we extend the existing srq_init_attr
structure to include an srq type and other needed information.
The extended fields are ignored unless extensions are being
used to support existing applications.

XRC queue pairs: xrc defines two new types of QPs.  The
initiator, or send-side, xrc qp behaves similar to a send-
only RC qp.  xrc send qp's are managed through the existing
QP functions.  The send_wr structure is extended in a back-
wards compatible way to support posting sends on a send xrc
qp, which require specifying the remote xrc srq.

The target, or receive-side, xrc qp behaves differently
than other implemented qp's.  A recv xrc qp can be created,
modified, and destroyed like other qp's through the existing
calls.  The qp_init_attr structure is extended for xrc qp's,
with extension support dependent upon the qp_type being
defined correctly.

Because xrc recv qp's are bound to an xrcd, rather than a pd,
it is intended to be used among multiple processes.  Any process
with access to an xrcd may allocate and connect an xrc recv qp.
The actual xrc recv qp is allocated and managed by the kernel.
If the owning process explicit destroys the xrc recv qp, it is
destroyed.  However, if the xrc recv qp is left open when the
user process exits or closes its device, then the lifetime of
the xrc recv qp is bound with the lifetime of the xrcd.

The user to kernel ABI is extended to account for opening/
closing the xrcd and the creation of the extended srq type.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/driver.h   |    9 +++
 include/infiniband/kern-abi.h |   53 +++++++++++++++++++
 include/infiniband/verbs.h    |   57 ++++++++++++++++++++-
 src/cmd.c                     |  112 ++++++++++++++++++++++++++++++++++++++---
 src/libibverbs.map            |    4 +
 src/verbs.c                   |   32 +++++++++---
 6 files changed, 249 insertions(+), 18 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index e48abfd..9aea854 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -76,6 +76,11 @@ int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
 		     struct ibv_alloc_pd *cmd, size_t cmd_size,
 		     struct ibv_alloc_pd_resp *resp, size_t resp_size);
 int ibv_cmd_dealloc_pd(struct ibv_pd *pd);
+int ibv_cmd_open_xrcd(struct ibv_context *context, struct ibv_xrcd *xrcd,
+		      int fd, int oflags,
+		      struct ibv_open_xrcd *cmd, size_t cmd_size,
+		      struct ibv_open_xrcd_resp *resp, size_t resp_size);
+int ibv_cmd_close_xrcd(struct ibv_xrcd *xrcd);
 #define IBV_CMD_REG_MR_HAS_RESP_PARAMS
 int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   uint64_t hca_va, int access,
@@ -100,6 +105,10 @@ int ibv_cmd_create_srq(struct ibv_pd *pd,
 		       struct ibv_srq *srq, struct ibv_srq_init_attr *attr,
 		       struct ibv_create_srq *cmd, size_t cmd_size,
 		       struct ibv_create_srq_resp *resp, size_t resp_size);
+int ibv_cmd_create_xsrq(struct ibv_pd *pd,
+			struct ibv_srq *srq, struct ibv_srq_init_attr *attr,
+			struct ibv_create_xsrq *cmd, size_t cmd_size,
+			struct ibv_create_srq_resp *resp, size_t resp_size);
 int ibv_cmd_modify_srq(struct ibv_srq *srq,
 		       struct ibv_srq_attr *srq_attr,
 		       int srq_attr_mask,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 0db083a..36cd133 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -85,7 +85,10 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_OPEN_XRCD,
+	IB_USER_VERBS_CMD_CLOSE_XRCD,
+	IB_USER_VERBS_CMD_CREATE_XSRQ
 };
 
 /*
@@ -245,6 +248,27 @@ struct ibv_dealloc_pd {
 	__u32 pd_handle;
 };
 
+struct ibv_open_xrcd {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u64 response;
+	__u32 fd;
+	__u32 oflags;
+	__u64 driver_data[0];
+};
+
+struct ibv_open_xrcd_resp {
+	__u32 xrcd_handle;
+};
+
+struct ibv_close_xrcd {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u32 xrcd_handle;
+};
+
 struct ibv_reg_mr {
 	__u32 command;
 	__u16 in_words;
@@ -592,6 +616,11 @@ struct ibv_kern_send_wr {
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
 
@@ -706,11 +735,28 @@ struct ibv_create_srq {
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
@@ -803,6 +849,9 @@ enum {
 	 * trick opcodes in IBV_INIT_CMD() doesn't break.
 	 */
 	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL_V2 = -1,
+	IB_USER_VERBS_CMD_OPEN_XRCD_V2 = -1,
+	IB_USER_VERBS_CMD_CLOSE_XRCD_V2 = -1,
+	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1,
 };
 
 struct ibv_destroy_cq_v1 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index b82cd3a..7c6c750 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2004 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2004, 2011 Intel Corporation.  All rights reserved.
  * Copyright (c) 2005, 2006, 2007 Cisco Systems, Inc.  All rights reserved.
  * Copyright (c) 2005 PathScale, Inc.  All rights reserved.
  *
@@ -299,6 +299,11 @@ struct ibv_pd {
 	uint32_t		handle;
 };
 
+struct ibv_xrcd {
+	struct ibv_context     *context;
+	uint32_t		handle;
+};
+
 enum ibv_rereg_mr_flags {
 	IBV_REREG_MR_CHANGE_TRANSLATION	= (1 << 0),
 	IBV_REREG_MR_CHANGE_PD		= (1 << 1),
@@ -400,7 +405,9 @@ struct ibv_srq_init_attr {
 enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
-	IBV_QPT_UD
+	IBV_QPT_UD,
+	IBV_QPT_XRC_SEND,
+	IBV_QPT_XRC_RECV
 };
 
 struct ibv_qp_cap {
@@ -419,6 +426,13 @@ struct ibv_qp_init_attr {
 	struct ibv_qp_cap	cap;
 	enum ibv_qp_type	qp_type;
 	int			sq_sig_all;
+
+	/* Following fields only available if device supports extensions */
+	union {
+		struct {
+			struct ibv_xrcd *xrcd;
+		} xrc_recv;
+	} ext;
 };
 
 enum ibv_qp_attr_mask {
@@ -536,6 +550,11 @@ struct ibv_send_wr {
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
 
@@ -555,6 +574,11 @@ struct ibv_mw_bind {
 	int			mw_access_flags;
 };
 
+enum ibv_srq_type {
+	IBV_SRQT_BASIC,
+	IBV_SRQT_XRC
+};
+
 struct ibv_srq {
 	struct ibv_context     *context;
 	void		       *srq_context;
@@ -564,6 +588,16 @@ struct ibv_srq {
 	pthread_mutex_t		mutex;
 	pthread_cond_t		cond;
 	uint32_t		events_completed;
+
+	/* Following fields only available if device supports extensions */
+	enum ibv_srq_type	srq_type;
+	union {
+		struct {
+			uint32_t	 srq_num;
+			struct ibv_xrcd *xrcd;
+			struct ibv_cq   *cq;
+		} xrc;
+	} ext;
 };
 
 struct ibv_qp {
@@ -581,6 +615,13 @@ struct ibv_qp {
 	pthread_mutex_t		mutex;
 	pthread_cond_t		cond;
 	uint32_t		events_completed;
+
+	/* Following fields only available if device supports extensions */
+	union {
+		struct {
+			struct ibv_xrcd *xrcd;
+		} xrc_recv;
+	} ext;
 };
 
 struct ibv_comp_channel {
@@ -700,6 +741,18 @@ struct ibv_context_ops {
 	void			(*async_event)(struct ibv_async_event *event);
 };
 
+#define IBV_XRC_OPS "ibv_xrc"
+
+struct ibv_xrc_ops {
+	struct ibv_xrcd *	(*open_xrcd)(struct ibv_context *context,
+					     int fd, int oflags);
+	int			(*close_xrcd)(struct ibv_xrcd *xrcd);
+	struct ibv_src *	(*create_srq)(struct ibv_pd *pd,
+					      struct ibv_xrcd *xrcd,
+					      struct ibv_cq *cq,
+					      struct ibv_srq_init_attr *attr);
+};
+
 struct ibv_context {
 	struct ibv_device      *device;
 	struct ibv_context_ops	ops;
diff --git a/src/cmd.c b/src/cmd.c
index cbd5288..8fc0dce 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -230,6 +230,39 @@ int ibv_cmd_dealloc_pd(struct ibv_pd *pd)
 	return 0;
 }
 
+int ibv_cmd_open_xrcd(struct ibv_context *context, struct ibv_xrcd *xrcd,
+		      int fd, int oflags,
+		      struct ibv_open_xrcd *cmd, size_t cmd_size,
+		      struct ibv_open_xrcd_resp *resp, size_t resp_size)
+{
+	IBV_INIT_CMD_RESP(cmd, cmd_size, OPEN_XRCD, resp, resp_size);
+
+	cmd->fd = fd;
+	cmd->oflags = oflags;
+	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	xrcd->handle  = resp->xrcd_handle;
+	xrcd->context = context;
+
+	return 0;
+}
+
+int ibv_cmd_close_xrcd(struct ibv_xrcd *xrcd)
+{
+	struct ibv_close_xrcd cmd;
+
+	IBV_INIT_CMD(&cmd, sizeof cmd, CLOSE_XRCD);
+	cmd.xrcd_handle = xrcd->handle;
+
+	if (write(xrcd->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
+		return errno;
+
+	return 0;
+}
+
 int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   uint64_t hca_va, int access,
 		   struct ibv_mr *mr, struct ibv_reg_mr *cmd,
@@ -480,6 +513,58 @@ int ibv_cmd_create_srq(struct ibv_pd *pd,
 			resp_size - sizeof *resp);
 	}
 
+	if (ibv_get_ext_support(pd->context->device))
+		srq->srq_type = IBV_SRQT_BASIC;
+
+	return 0;
+}
+
+int ibv_cmd_create_xsrq(struct ibv_pd *pd,
+			struct ibv_srq *srq, struct ibv_srq_init_attr *attr,
+			struct ibv_create_xsrq *cmd, size_t cmd_size,
+			struct ibv_create_srq_resp *resp, size_t resp_size)
+{
+	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_XSRQ, resp, resp_size);
+	cmd->user_handle = (uintptr_t) srq;
+	cmd->pd_handle 	 = pd->handle;
+	cmd->max_wr      = attr->attr.max_wr;
+	cmd->max_sge     = attr->attr.max_sge;
+	cmd->srq_limit   = attr->attr.srq_limit;
+
+	cmd->srq_type = srq->srq_type;
+	switch (srq->srq_type) {
+	case IBV_SRQT_XRC:
+		cmd->xrcd_handle = srq->ext.xrc.xrcd->handle;
+		cmd->cq_handle   = srq->ext.xrc.cq->handle;
+		break;
+	default:
+		break;
+	}
+
+	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	srq->handle  = resp->srq_handle;
+	srq->context = pd->context;
+	srq->pd = pd;
+	srq->srq_context = attr->srq_context;
+	srq->events_completed = 0;
+	pthread_mutex_init(&srq->mutex, NULL);
+	pthread_cond_init(&srq->cond, NULL);
+
+	attr->attr.max_wr = resp->max_wr;
+	attr->attr.max_sge = resp->max_sge;
+
+	switch (srq->srq_type) {
+	case IBV_SRQT_XRC:
+		srq->ext.xrc.srq_num = resp->srqn;
+		break;
+	default:
+		break;
+	}
+
 	return 0;
 }
 
@@ -597,13 +682,26 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 		      struct ibv_create_qp *cmd, size_t cmd_size,
 		      struct ibv_create_qp_resp *resp, size_t resp_size)
 {
+	struct ibv_context *context;
+
 	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_QP, resp, resp_size);
 
 	cmd->user_handle     = (uintptr_t) qp;
-	cmd->pd_handle 	     = pd->handle;
-	cmd->send_cq_handle  = attr->send_cq->handle;
-	cmd->recv_cq_handle  = attr->recv_cq->handle;
-	cmd->srq_handle      = attr->srq ? attr->srq->handle : 0;
+
+	if (attr->qp_type == IBV_QPT_XRC_RECV) {
+		context             = attr->ext.xrc_recv.xrcd->context;
+		cmd->pd_handle      = attr->ext.xrc_recv.xrcd->handle;
+	} else {
+		context             = pd->context;
+		cmd->pd_handle      = pd->handle;
+		cmd->send_cq_handle = attr->send_cq->handle;
+
+		if (attr->qp_type != IBV_QPT_XRC_SEND) {
+			cmd->recv_cq_handle = attr->recv_cq->handle;
+			cmd->srq_handle     = attr->srq ? attr->srq->handle : 0;
+		}
+	}
+	
 	cmd->max_send_wr     = attr->cap.max_send_wr;
 	cmd->max_recv_wr     = attr->cap.max_recv_wr;
 	cmd->max_send_sge    = attr->cap.max_send_sge;
@@ -619,9 +717,9 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
-	qp->handle 		  = resp->qp_handle;
-	qp->qp_num 		  = resp->qpn;
-	qp->context		  = pd->context;
+	qp->handle  	    = resp->qp_handle;
+	qp->qp_num  	    = resp->qpn;
+	qp->context	    = context;
 
 	if (abi_ver > 3) {
 		attr->cap.max_recv_sge    = resp->max_recv_sge;
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 422e07f..c31cca3 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -101,4 +101,8 @@ IBVERBS_1.1 {
 		ibv_have_ext_ops;
 		ibv_get_device_ext_ops;
 		ibv_get_ext_ops;
+
+		ibv_cmd_open_xrcd;
+		ibv_cmd_close_xrcd;
+		ibv_cmd_create_xsrq;
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index a34a784..f6576df 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -407,15 +407,33 @@ default_symver(__ibv_destroy_srq, ibv_destroy_srq);
 struct ibv_qp *__ibv_create_qp(struct ibv_pd *pd,
 			       struct ibv_qp_init_attr *qp_init_attr)
 {
-	struct ibv_qp *qp = pd->context->ops.create_qp(pd, qp_init_attr);
+	struct ibv_context *context;
+	struct ibv_qp *qp;
 
+	context = pd ? pd->context : qp_init_attr->ext.xrc_recv.xrcd->context;
+	qp = context->ops.create_qp(pd, qp_init_attr);
 	if (qp) {
-		qp->context    	     = pd->context;
-		qp->qp_context 	     = qp_init_attr->qp_context;
-		qp->pd         	     = pd;
-		qp->send_cq    	     = qp_init_attr->send_cq;
-		qp->recv_cq    	     = qp_init_attr->recv_cq;
-		qp->srq        	     = qp_init_attr->srq;
+		qp->context    = context;
+		qp->qp_context = qp_init_attr->qp_context;
+
+		if (qp_init_attr->qp_type == IBV_QPT_XRC_RECV) {
+			qp->pd = NULL;
+			qp->send_cq = qp->recv_cq = NULL;
+			qp->srq = NULL;
+			qp->ext.xrc_recv.xrcd = qp_init_attr->ext.xrc_recv.xrcd;
+		} else {
+			if (qp_init_attr->qp_type == IBV_QPT_XRC_SEND) {
+				qp->recv_cq = NULL;
+				qp->srq = NULL;
+			} else {
+				qp->recv_cq = qp_init_attr->recv_cq;
+				qp->srq     = qp_init_attr->srq;
+			}
+		
+			qp->pd      = pd;
+			qp->send_cq = qp_init_attr->send_cq;
+		}
+
 		qp->qp_type          = qp_init_attr->qp_type;
 		qp->state	     = IBV_QPS_RESET;
 		qp->events_completed = 0;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

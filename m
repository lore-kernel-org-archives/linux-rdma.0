From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs] Expose QP block self multicast loopback creation flag
Date: Tue, 27 Oct 2015 14:53:01 +0200
Message-ID: <1445950381-10723-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add QP creation flag which indicates that the QP will not receive self
multicast loopback traffic.

ibv_cmd_create_qp_ex was already defined but could not get extended, add
ibv_cmd_create_qp_ex2 which follows the extension scheme and hence could
be extendible in the future for more features.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Hi Doug,
This is the user space equivalent for the loopback prevention patches that were
acceptad into 4.4 ib-next.

 include/infiniband/driver.h   |   9 ++
 include/infiniband/kern-abi.h |  53 +++++++----
 include/infiniband/verbs.h    |   9 +-
 src/cmd.c                     | 200 ++++++++++++++++++++++++++++++------------
 src/libibverbs.map            |   1 +
 5 files changed, 200 insertions(+), 72 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 8227df0..b7f1fae 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -179,6 +179,15 @@ int ibv_cmd_create_qp_ex(struct ibv_context *context,
 			 struct ibv_qp_init_attr_ex *attr_ex,
 			 struct ibv_create_qp *cmd, size_t cmd_size,
 			 struct ibv_create_qp_resp *resp, size_t resp_size);
+int ibv_cmd_create_qp_ex2(struct ibv_context *context,
+			  struct verbs_qp *qp, int vqp_sz,
+			  struct ibv_qp_init_attr_ex *qp_attr,
+			  struct ibv_create_qp_ex *cmd,
+			  size_t cmd_core_size,
+			  size_t cmd_size,
+			  struct ibv_create_qp_resp_ex *resp,
+			  size_t resp_core_size,
+			  size_t resp_size);
 int ibv_cmd_open_qp(struct ibv_context *context,
 		    struct verbs_qp *qp,  int vqp_sz,
 		    struct ibv_qp_open_attr *attr,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 800c5ab..2278f63 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -110,6 +110,8 @@ enum {
 enum {
 	IB_USER_VERBS_CMD_QUERY_DEVICE_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
 					    IB_USER_VERBS_CMD_QUERY_DEVICE,
+	IB_USER_VERBS_CMD_CREATE_QP_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
+					 IB_USER_VERBS_CMD_CREATE_QP,
 	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_EXTENDED_MASK +
 					IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_CMD_DESTROY_FLOW
@@ -527,28 +529,35 @@ struct ibv_kern_qp_attr {
 	__u8	reserved[5];
 };
 
+#define IBV_CREATE_QP_COMMON	\
+	__u64 user_handle;	\
+	__u32 pd_handle;	\
+	__u32 send_cq_handle;	\
+	__u32 recv_cq_handle;	\
+	__u32 srq_handle;	\
+	__u32 max_send_wr;	\
+	__u32 max_recv_wr;	\
+	__u32 max_send_sge;	\
+	__u32 max_recv_sge;	\
+	__u32 max_inline_data;	\
+	__u8  sq_sig_all;	\
+	__u8  qp_type;		\
+	__u8  is_srq;		\
+	__u8  reserved
+
 struct ibv_create_qp {
 	__u32 command;
 	__u16 in_words;
 	__u16 out_words;
 	__u64 response;
-	__u64 user_handle;
-	__u32 pd_handle;
-	__u32 send_cq_handle;
-	__u32 recv_cq_handle;
-	__u32 srq_handle;
-	__u32 max_send_wr;
-	__u32 max_recv_wr;
-	__u32 max_send_sge;
-	__u32 max_recv_sge;
-	__u32 max_inline_data;
-	__u8  sq_sig_all;
-	__u8  qp_type;
-	__u8  is_srq;
-	__u8  reserved;
+	IBV_CREATE_QP_COMMON;
 	__u64 driver_data[0];
 };
 
+struct ibv_create_qp_common {
+	IBV_CREATE_QP_COMMON;
+};
+
 struct ibv_open_qp {
 	__u32 command;
 	__u16 in_words;
@@ -574,6 +583,19 @@ struct ibv_create_qp_resp {
 	__u32 reserved;
 };
 
+struct ibv_create_qp_ex {
+	struct ex_hdr	hdr;
+	struct ibv_create_qp_common base;
+	__u32 comp_mask;
+	__u32 create_flags;
+};
+
+struct ibv_create_qp_resp_ex {
+	struct ibv_create_qp_resp base;
+	__u32 comp_mask;
+	__u32 response_length;
+};
+
 struct ibv_qp_dest {
 	__u8  dgid[16];
 	__u32 flow_label;
@@ -1031,7 +1053,8 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_FLOW_V2 = -1,
 	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 = -1,
-	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1
+	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1,
+	IB_USER_VERBS_CMD_CREATE_QP_EX_V2 = -1,
 };
 
 struct ibv_modify_srq_v3 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ae22768..941e5dc 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -580,7 +580,12 @@ struct ibv_qp_init_attr {
 enum ibv_qp_init_attr_mask {
 	IBV_QP_INIT_ATTR_PD		= 1 << 0,
 	IBV_QP_INIT_ATTR_XRCD		= 1 << 1,
-	IBV_QP_INIT_ATTR_RESERVED	= 1 << 2
+	IBV_QP_INIT_ATTR_CREATE_FLAGS  = 1 << 2,
+	IBV_QP_INIT_ATTR_RESERVED	= 1 << 3
+};
+
+enum ibv_qp_create_flags {
+	IBV_QP_CREATE_BLOCK_SELF_MCAST_LB       = 1 << 1,
 };
 
 struct ibv_qp_init_attr_ex {
@@ -595,6 +600,8 @@ struct ibv_qp_init_attr_ex {
 	uint32_t		comp_mask;
 	struct ibv_pd	       *pd;
 	struct ibv_xrcd	       *xrcd;
+	uint32_t                create_flags;
+
 };
 
 enum ibv_qp_open_attr_mask {
diff --git a/src/cmd.c b/src/cmd.c
index e1914e9..6a19adb 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -677,6 +677,143 @@ int ibv_cmd_destroy_srq(struct ibv_srq *srq)
 	return 0;
 }
 
+static int create_qp_ex_common(struct verbs_qp *qp,
+			       struct ibv_qp_init_attr_ex *qp_attr,
+			       struct verbs_xrcd *vxrcd,
+			       struct ibv_create_qp_common *cmd)
+{
+	cmd->user_handle = (uintptr_t)qp;
+
+	if (qp_attr->comp_mask & IBV_QP_INIT_ATTR_XRCD) {
+		vxrcd = container_of(qp_attr->xrcd, struct verbs_xrcd, xrcd);
+		cmd->pd_handle	= vxrcd->handle;
+	} else {
+		if (!(qp_attr->comp_mask & IBV_QP_INIT_ATTR_PD))
+			return EINVAL;
+
+		cmd->pd_handle	= qp_attr->pd->handle;
+		cmd->send_cq_handle = qp_attr->send_cq->handle;
+
+		if (qp_attr->qp_type != IBV_QPT_XRC_SEND) {
+			cmd->recv_cq_handle = qp_attr->recv_cq->handle;
+			cmd->srq_handle = qp_attr->srq ? qp_attr->srq->handle :
+							 0;
+		}
+	}
+
+	cmd->max_send_wr     = qp_attr->cap.max_send_wr;
+	cmd->max_recv_wr     = qp_attr->cap.max_recv_wr;
+	cmd->max_send_sge    = qp_attr->cap.max_send_sge;
+	cmd->max_recv_sge    = qp_attr->cap.max_recv_sge;
+	cmd->max_inline_data = qp_attr->cap.max_inline_data;
+	cmd->sq_sig_all	     = qp_attr->sq_sig_all;
+	cmd->qp_type         = qp_attr->qp_type;
+	cmd->is_srq	     = !!qp_attr->srq;
+	cmd->reserved	     = 0;
+
+	return 0;
+}
+
+static void create_qp_handle_resp_common(struct ibv_context *context,
+					 struct verbs_qp *qp,
+					 struct ibv_qp_init_attr_ex *qp_attr,
+					 struct ibv_create_qp_resp *resp,
+					 struct verbs_xrcd *vxrcd,
+					 int vqp_sz)
+{
+	if (abi_ver > 3) {
+		qp_attr->cap.max_recv_sge    = resp->max_recv_sge;
+		qp_attr->cap.max_send_sge    = resp->max_send_sge;
+		qp_attr->cap.max_recv_wr     = resp->max_recv_wr;
+		qp_attr->cap.max_send_wr     = resp->max_send_wr;
+		qp_attr->cap.max_inline_data = resp->max_inline_data;
+	}
+
+	qp->qp.handle		= resp->qp_handle;
+	qp->qp.qp_num		= resp->qpn;
+	qp->qp.context		= context;
+	qp->qp.qp_context	= qp_attr->qp_context;
+	qp->qp.pd		= qp_attr->pd;
+	qp->qp.send_cq		= qp_attr->send_cq;
+	qp->qp.recv_cq		= qp_attr->recv_cq;
+	qp->qp.srq		= qp_attr->srq;
+	qp->qp.qp_type		= qp_attr->qp_type;
+	qp->qp.state		= IBV_QPS_RESET;
+	qp->qp.events_completed = 0;
+	pthread_mutex_init(&qp->qp.mutex, NULL);
+	pthread_cond_init(&qp->qp.cond, NULL);
+
+	qp->comp_mask = 0;
+	if (vext_field_avail(struct verbs_qp, xrcd, vqp_sz) &&
+	    (qp_attr->comp_mask & IBV_QP_INIT_ATTR_XRCD)) {
+		qp->comp_mask |= VERBS_QP_XRCD;
+		qp->xrcd = vxrcd;
+	}
+}
+
+enum {
+	CREATE_QP_EX2_SUP_CREATE_FLAGS = IBV_QP_CREATE_BLOCK_SELF_MCAST_LB,
+};
+
+int ibv_cmd_create_qp_ex2(struct ibv_context *context,
+			  struct verbs_qp *qp, int vqp_sz,
+			  struct ibv_qp_init_attr_ex *qp_attr,
+			  struct ibv_create_qp_ex *cmd,
+			  size_t cmd_core_size,
+			  size_t cmd_size,
+			  struct ibv_create_qp_resp_ex *resp,
+			  size_t resp_core_size,
+			  size_t resp_size)
+{
+	struct verbs_xrcd *vxrcd = NULL;
+	int err;
+
+	if (qp_attr->comp_mask >= IBV_QP_INIT_ATTR_RESERVED)
+		return EINVAL;
+
+	if (resp_core_size <
+	    offsetof(struct ibv_create_qp_resp_ex, response_length) +
+	    sizeof(resp->response_length))
+			return EINVAL;
+	resp->response_length = 0;
+
+	memset(cmd, 0, cmd_core_size);
+
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, CREATE_QP_EX, resp,
+			       resp_core_size, resp_size);
+
+	err = create_qp_ex_common(qp, qp_attr, vxrcd, &cmd->base);
+	if (err)
+		return err;
+
+	if (qp_attr->comp_mask & IBV_QP_INIT_ATTR_CREATE_FLAGS) {
+		if (qp_attr->create_flags & ~CREATE_QP_EX2_SUP_CREATE_FLAGS)
+			return EINVAL;
+		if (cmd_core_size < offsetof(struct ibv_create_qp_ex, create_flags) +
+				    sizeof(qp_attr->create_flags))
+			return EINVAL;
+		cmd->create_flags = qp_attr->create_flags;
+	}
+
+	cmd->comp_mask = 0;
+
+	err = write(context->cmd_fd, cmd, cmd_size);
+	if (err != cmd_size)
+		return errno;
+
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	if (resp->response_length <
+	    offsetof(struct ibv_create_qp_resp_ex, response_length) +
+	    sizeof(resp->response_length))
+		return EINVAL;
+
+	create_qp_handle_resp_common(context, qp, qp_attr, &resp->base, vxrcd,
+				     vqp_sz);
+
+	return 0;
+}
+
 int ibv_cmd_create_qp_ex(struct ibv_context *context,
 			 struct verbs_qp *qp, int vqp_sz,
 			 struct ibv_qp_init_attr_ex *attr_ex,
@@ -684,52 +821,22 @@ int ibv_cmd_create_qp_ex(struct ibv_context *context,
 			 struct ibv_create_qp_resp *resp, size_t resp_size)
 {
 	struct verbs_xrcd *vxrcd = NULL;
+	int err;
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_QP, resp, resp_size);
 
 	if (attr_ex->comp_mask >= IBV_QP_INIT_ATTR_RESERVED)
 		return ENOSYS;
 
-	cmd->user_handle     = (uintptr_t) qp;
-
-	if (attr_ex->comp_mask & IBV_QP_INIT_ATTR_XRCD) {
-		vxrcd = container_of(attr_ex->xrcd, struct verbs_xrcd, xrcd);
-		cmd->pd_handle	= vxrcd->handle;
-	} else {
-		if (!(attr_ex->comp_mask & IBV_QP_INIT_ATTR_PD))
-			return EINVAL;
-
-		cmd->pd_handle	= attr_ex->pd->handle;
-		cmd->send_cq_handle = attr_ex->send_cq->handle;
-
-		if (attr_ex->qp_type != IBV_QPT_XRC_SEND) {
-			cmd->recv_cq_handle = attr_ex->recv_cq->handle;
-			cmd->srq_handle = attr_ex->srq ? attr_ex->srq->handle : 0;
-		}
-	}
-
-	cmd->max_send_wr     = attr_ex->cap.max_send_wr;
-	cmd->max_recv_wr     = attr_ex->cap.max_recv_wr;
-	cmd->max_send_sge    = attr_ex->cap.max_send_sge;
-	cmd->max_recv_sge    = attr_ex->cap.max_recv_sge;
-	cmd->max_inline_data = attr_ex->cap.max_inline_data;
-	cmd->sq_sig_all	     = attr_ex->sq_sig_all;
-	cmd->qp_type         = attr_ex->qp_type;
-	cmd->is_srq	     = !!attr_ex->srq;
-	cmd->reserved	     = 0;
+	err = create_qp_ex_common(qp, attr_ex, vxrcd,
+				  (struct ibv_create_qp_common *)&cmd->user_handle);
+	if (err)
+		return err;
 
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
-
-	if (abi_ver > 3) {
-		attr_ex->cap.max_recv_sge    = resp->max_recv_sge;
-		attr_ex->cap.max_send_sge    = resp->max_send_sge;
-		attr_ex->cap.max_recv_wr     = resp->max_recv_wr;
-		attr_ex->cap.max_send_wr     = resp->max_send_wr;
-		attr_ex->cap.max_inline_data = resp->max_inline_data;
-	}
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	if (abi_ver == 4) {
 		struct ibv_create_qp_resp_v4 *resp_v4 =
@@ -747,26 +854,7 @@ int ibv_cmd_create_qp_ex(struct ibv_context *context,
 			resp_size - sizeof *resp);
 	}
 
-	qp->qp.handle		= resp->qp_handle;
-	qp->qp.qp_num		= resp->qpn;
-	qp->qp.context		= context;
-	qp->qp.qp_context	= attr_ex->qp_context;
-	qp->qp.pd		= attr_ex->pd;
-	qp->qp.send_cq		= attr_ex->send_cq;
-	qp->qp.recv_cq		= attr_ex->recv_cq;
-	qp->qp.srq		= attr_ex->srq;
-	qp->qp.qp_type		= attr_ex->qp_type;
-	qp->qp.state		= IBV_QPS_RESET;
-	qp->qp.events_completed = 0;
-	pthread_mutex_init(&qp->qp.mutex, NULL);
-	pthread_cond_init(&qp->qp.cond, NULL);
-
-	qp->comp_mask = 0;
-	if (vext_field_avail(struct verbs_qp, xrcd, vqp_sz) &&
-			    (attr_ex->comp_mask & IBV_QP_INIT_ATTR_XRCD)) {
-		qp->comp_mask |= VERBS_QP_XRCD;
-		qp->xrcd = vxrcd;
-	}
+	create_qp_handle_resp_common(context, qp, attr_ex, resp, vxrcd, vqp_sz);
 
 	return 0;
 }
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 3b40a0f..b302f5e 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -111,6 +111,7 @@ IBVERBS_1.1 {
 		ibv_cmd_close_xrcd;
 		ibv_cmd_create_srq_ex;
 		ibv_cmd_create_qp_ex;
+		ibv_cmd_create_qp_ex2;
 		ibv_cmd_open_qp;
 
 } IBVERBS_1.0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs] Add QP creation flags, support blocking self multicast loopback
Date: Thu, 11 Feb 2016 15:54:09 +0200
Message-ID: <1455198849-32192-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add QP creation flags, specifically add a flag to indicate that
the QP will not receive self multicast loopback traffic.

To pass the QP creation flags to the kernel need to add
ibv_cmd_create_qp_ex2 API which follows the extended scheme
and uses the CREATE_QP_EX command.
ibv_cmd_create_qp_ex API doesn't follow the extended scheme,
it uses the CREATE_QP command and can't be used.

To prevent code duplication common code of above 2
functions was shared.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Doug,

This patch from Eran addressed some issues that we
found in some extra code review on V0,
details below.

It's sent over previous features for libibverbs
rereg_mr and memory window that are pending your
merge.

Patch can be taken also from my public GIT 
at openfabrics.

git://openfabrics.org/~yishaih/libibverbs.git

branch: for-upstream. (on top of previous features)
branch: mc_loopback_prev (on top of master)

Yishai
 
Change from v0:
- Improve commit message.
- Drop some redundant code at ibv_cmd_create_qp_ex2.
- Fix error checking as part of ibv_cmd_create_qp_ex.


 include/infiniband/driver.h   |   9 ++
 include/infiniband/kern-abi.h |  53 ++++++++----
 include/infiniband/verbs.h    |   9 +-
 src/cmd.c                     | 194 +++++++++++++++++++++++++++++-------------
 src/libibverbs.map            |   1 +
 5 files changed, 193 insertions(+), 73 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 1b0802d..053ad5f 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -190,6 +190,15 @@ int ibv_cmd_create_qp_ex(struct ibv_context *context,
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
index d4ef58e..31da4be 100644
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
@@ -570,28 +572,35 @@ struct ibv_kern_qp_attr {
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
@@ -617,6 +626,19 @@ struct ibv_create_qp_resp {
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
@@ -1074,7 +1096,8 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_FLOW_V2 = -1,
 	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 = -1,
-	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1
+	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1,
+	IB_USER_VERBS_CMD_CREATE_QP_EX_V2 = -1,
 };
 
 struct ibv_modify_srq_v3 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 8eb1f08..6451d0f 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -600,7 +600,12 @@ struct ibv_qp_init_attr {
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
@@ -615,6 +620,8 @@ struct ibv_qp_init_attr_ex {
 	uint32_t		comp_mask;
 	struct ibv_pd	       *pd;
 	struct ibv_xrcd	       *xrcd;
+	uint32_t                create_flags;
+
 };
 
 enum ibv_qp_open_attr_mask {
diff --git a/src/cmd.c b/src/cmd.c
index 9aa072e..b8c51ce 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -743,6 +743,135 @@ int ibv_cmd_destroy_srq(struct ibv_srq *srq)
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
+		return EINVAL;
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
+	err = write(context->cmd_fd, cmd, cmd_size);
+	if (err != cmd_size)
+		return errno;
+
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
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
@@ -750,52 +879,22 @@ int ibv_cmd_create_qp_ex(struct ibv_context *context,
 			 struct ibv_create_qp_resp *resp, size_t resp_size)
 {
 	struct verbs_xrcd *vxrcd = NULL;
+	int err;
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_QP, resp, resp_size);
 
-	if (attr_ex->comp_mask >= IBV_QP_INIT_ATTR_RESERVED)
+	if (attr_ex->comp_mask > (IBV_QP_INIT_ATTR_XRCD | IBV_QP_INIT_ATTR_PD))
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
@@ -813,26 +912,7 @@ int ibv_cmd_create_qp_ex(struct ibv_context *context,
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
index d934b50..a150416 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -114,6 +114,7 @@ IBVERBS_1.1 {
 		ibv_cmd_close_xrcd;
 		ibv_cmd_create_srq_ex;
 		ibv_cmd_create_qp_ex;
+		ibv_cmd_create_qp_ex2;
 		ibv_cmd_open_qp;
 		ibv_cmd_rereg_mr;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

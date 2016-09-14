From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 1/7] Introduce Work Queue object and its verbs
Date: Wed, 14 Sep 2016 16:56:22 +0300
Message-ID: <1473861388-22064-2-git-send-email-yishaih@mellanox.com>
References: <1473861388-22064-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473861388-22064-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Introduce Work Queue object and its create/destroy/modify verbs.

QP can be created without internal WQs "packaged" inside it,
this QP can be configured to use "external" WQ object as its
receive/send queue.

WQ is a necessary component for RSS technology since RSS mechanism
is supposed to distribute the traffic between multiple Receive Work
Queues.

WQ associated (many to one) with Completion Queue and it owns WQ
properties (PD, WQ size, etc.).
WQ has a type, this patch introduces the IBV_WQT_RQ (i.e.receive
queue), it may be extend to others such as IBV_WQT_SQ. (send queue).

WQ from type IBV_WQT_RQ contains receive work requests and as such
exposes post receive function to be used to post a list of work
requests (WRs) to its receive queue.

PD is an attribute of a work queue (i.e. send/receive queue), it's
used by the hardware for security validation before scattering to a
memory region which is pointed by the WQ. For that, an external WQ
object
needs a PD, letting the hardware makes that validation.

When accessing a memory region that is pointed by the WQ its PD
is used and not the QP's PD, this behavior is similar to a SRQ and a QP.

WQ context is subject to a well-defined state transitions done by
the modify_wq verb.
When WQ is created its initial state becomes IBV_WQS_RESET.
>From IBV_WQS_RESET it can be modified to itself or to IBV_WQS_RDY.
>From IBV_WQS_RDY it can be modified to itself, to IBV_WQS_RESET
      or to IBV_WQS_ERR.
>From IBV_WQS_ERR it can be modified to IBV_WQS_RESET.

Note: transition to IBV_WQS_ERR might occur implicitly in case there
      was some HW error.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/driver.h   |  14 ++++
 include/infiniband/kern-abi.h |  49 ++++++++++++-
 include/infiniband/verbs.h    | 160 ++++++++++++++++++++++++++++++++++++++++++
 src/cmd.c                     |  98 ++++++++++++++++++++++++++
 src/libibverbs.map            |   7 ++
 5 files changed, 327 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 65fa44f..706445b 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -236,6 +236,20 @@ int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t l
 struct ibv_flow *ibv_cmd_create_flow(struct ibv_qp *qp,
 				     struct ibv_flow_attr *flow_attr);
 int ibv_cmd_destroy_flow(struct ibv_flow *flow_id);
+int ibv_cmd_create_wq(struct ibv_context *context,
+		      struct ibv_wq_init_attr *wq_init_attr,
+		      struct ibv_wq *wq,
+		      struct ibv_create_wq *cmd,
+		      size_t cmd_core_size,
+		      size_t cmd_size,
+		      struct ibv_create_wq_resp *resp,
+		      size_t resp_core_size,
+		      size_t resp_size);
+
+int ibv_cmd_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr,
+		      struct ibv_modify_wq *cmd, size_t cmd_core_size,
+		      size_t cmd_size);
+int ibv_cmd_destroy_wq(struct ibv_wq *wq);
 
 int ibv_dontfork_range(void *base, size_t size);
 int ibv_dofork_range(void *base, size_t size);
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index f70fa44..081918f 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -116,7 +116,10 @@ enum {
 						IB_USER_VERBS_CMD_CREATE_CQ,
 	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_EXTENDED_MASK +
 					IB_USER_VERBS_CMD_THRESHOLD,
-	IB_USER_VERBS_CMD_DESTROY_FLOW
+	IB_USER_VERBS_CMD_DESTROY_FLOW,
+	IB_USER_VERBS_CMD_CREATE_WQ,
+	IB_USER_VERBS_CMD_MODIFY_WQ,
+	IB_USER_VERBS_CMD_DESTROY_WQ
 };
 
 /*
@@ -1125,6 +1128,9 @@ enum {
 	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_QP_EX_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_CQ_EX_V2 = -1,
+	IB_USER_VERBS_CMD_CREATE_WQ_V2 = -1,
+	IB_USER_VERBS_CMD_MODIFY_WQ_V2 = -1,
+	IB_USER_VERBS_CMD_DESTROY_WQ_V2 = -1,
 };
 
 struct ibv_modify_srq_v3 {
@@ -1159,4 +1165,45 @@ struct ibv_create_srq_resp_v5 {
 	__u32 srq_handle;
 };
 
+struct ibv_create_wq {
+	struct ex_hdr hdr;
+	__u32 comp_mask;
+	__u32 wq_type;
+	__u64 user_handle;
+	__u32 pd_handle;
+	__u32 cq_handle;
+	__u32 max_wr;
+	__u32 max_sge;
+};
+
+struct ibv_create_wq_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u32 wq_handle;
+	__u32 max_wr;
+	__u32 max_sge;
+	__u32 wqn;
+};
+
+struct ibv_destroy_wq {
+	struct ex_hdr hdr;
+	__u32 comp_mask;
+	__u32 wq_handle;
+};
+
+struct ibv_destroy_wq_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u32 events_reported;
+	__u32 reserved;
+};
+
+struct ibv_modify_wq  {
+	struct ex_hdr hdr;
+	__u32 attr_mask;
+	__u32 wq_handle;
+	__u32 wq_state;
+	__u32 curr_wq_state;
+};
+
 #endif /* KERN_ABI_H */
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ec541e3..c549bd3 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -612,6 +612,46 @@ struct ibv_srq_init_attr_ex {
 	struct ibv_cq	       *cq;
 };
 
+enum ibv_wq_type {
+	IBV_WQT_RQ
+};
+
+enum ibv_wq_init_attr_mask {
+	IBV_WQ_INIT_ATTR_RESERVED	= 1 << 0,
+};
+
+struct ibv_wq_init_attr {
+	void		       *wq_context;
+	enum ibv_wq_type	wq_type;
+	uint32_t		max_wr;
+	uint32_t		max_sge;
+	struct	ibv_pd	       *pd;
+	struct	ibv_cq	       *cq;
+	uint32_t		comp_mask;
+};
+
+enum ibv_wq_state {
+	IBV_WQS_RESET,
+	IBV_WQS_RDY,
+	IBV_WQS_ERR,
+	IBV_WQS_UNKNOWN
+};
+
+enum ibv_wq_attr_mask {
+	IBV_WQ_ATTR_STATE	= 1 << 0,
+	IBV_WQ_ATTR_CURR_STATE	= 1 << 1,
+	IBV_WQ_ATTR_RESERVED	= 1 << 2
+};
+
+struct ibv_wq_attr {
+	/* enum ibv_wq_attr_mask */
+	uint32_t		attr_mask;
+	/* Move the WQ to this state */
+	enum	ibv_wq_state	wq_state;
+	/* Assume this is the current WQ state */
+	enum	ibv_wq_state	curr_wq_state;
+};
+
 enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
@@ -849,6 +889,35 @@ struct ibv_srq {
 	uint32_t		events_completed;
 };
 
+/*
+ * Work Queue. QP can be created without internal WQs "packaged" inside it,
+ * this QP can be configured to use "external" WQ object as its
+ * receive/send queue.
+ * WQ associated (many to one) with Completion Queue it owns WQ properties
+ * (PD, WQ size etc).
+ * WQ of type IBV_WQT_RQ:
+ * - Contains receive WQEs, in this case its PD serves as scatter as well.
+ * - Exposes post receive function to be used to post a list of work
+ *   requests (WRs) to its receive queue.
+ */
+struct ibv_wq {
+	struct ibv_context     *context;
+	void		       *wq_context;
+	struct	ibv_pd	       *pd;
+	struct	ibv_cq	       *cq;
+	uint32_t		wq_num;
+	uint32_t		handle;
+	enum ibv_wq_state       state;
+	enum ibv_wq_type	wq_type;
+	int (*post_recv)(struct ibv_wq *current,
+			 struct ibv_recv_wr *recv_wr,
+			 struct ibv_recv_wr **bad_recv_wr);
+	pthread_mutex_t		mutex;
+	pthread_cond_t		cond;
+	uint32_t		events_completed;
+	uint32_t		comp_mask;
+};
+
 struct ibv_qp {
 	struct ibv_context     *context;
 	void		       *qp_context;
@@ -997,6 +1066,13 @@ static inline uint64_t ibv_wc_read_completion_ts(struct ibv_cq_ex *cq)
 	return cq->read_completion_ts(cq);
 }
 
+static inline int ibv_post_wq_recv(struct ibv_wq *wq,
+				   struct ibv_recv_wr *recv_wr,
+				   struct ibv_recv_wr **bad_recv_wr)
+{
+	return wq->post_recv(wq, recv_wr, bad_recv_wr);
+}
+
 struct ibv_ah {
 	struct ibv_context     *context;
 	struct ibv_pd	       *pd;
@@ -1263,6 +1339,10 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*destroy_wq)(struct ibv_wq *wq);
+	int (*modify_wq)(struct ibv_wq *wq, struct ibv_wq_attr *wq_attr);
+	struct ibv_wq * (*create_wq)(struct ibv_context *context,
+				     struct ibv_wq_init_attr *wq_init_attr);
 	int (*query_rt_values)(struct ibv_context *context,
 			       struct ibv_values_ex *values);
 	struct ibv_cq_ex *(*create_cq_ex)(struct ibv_context *context,
@@ -1872,6 +1952,86 @@ int ibv_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
  */
 int ibv_destroy_qp(struct ibv_qp *qp);
 
+/*
+ * ibv_create_wq - Creates a WQ associated with the specified protection
+ * domain.
+ * @context: ibv_context.
+ * @wq_init_attr: A list of initial attributes required to create the
+ * WQ. If WQ creation succeeds, then the attributes are updated to
+ * the actual capabilities of the created WQ.
+ *
+ * wq_init_attr->max_wr and wq_init_attr->max_sge determine
+ * the requested size of the WQ, and set to the actual values allocated
+ * on return.
+ * If ibv_create_wq() succeeds, then max_wr and max_sge will always be
+ * at least as large as the requested values.
+ *
+ * Return Value
+ * ibv_create_wq() returns a pointer to the created WQ, or NULL if the request
+ * fails.
+ */
+static inline struct ibv_wq *ibv_create_wq(struct ibv_context *context,
+					   struct ibv_wq_init_attr *wq_init_attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(context, create_wq);
+	struct ibv_wq *wq;
+
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	wq = vctx->create_wq(context, wq_init_attr);
+	if (wq) {
+		wq->events_completed = 0;
+		pthread_mutex_init(&wq->mutex, NULL);
+		pthread_cond_init(&wq->cond, NULL);
+	}
+
+	return wq;
+}
+
+/*
+ * ibv_modify_wq - Modifies the attributes for the specified WQ.
+ * @wq: The WQ to modify.
+ * @wq_attr: On input, specifies the WQ attributes to modify.
+ *    wq_attr->attr_mask: A bit-mask used to specify which attributes of the WQ
+ *    are being modified.
+ * On output, the current values of selected WQ attributes are returned.
+ *
+ * Return Value
+ * ibv_modify_wq() returns 0 on success, or the value of errno
+ * on failure (which indicates the failure reason).
+ *
+*/
+static inline int ibv_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *wq_attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(wq->context, modify_wq);
+
+	if (!vctx)
+		return ENOSYS;
+
+	return vctx->modify_wq(wq, wq_attr);
+}
+
+/*
+ * ibv_destroy_wq - Destroys the specified WQ.
+ * @ibv_wq: The WQ to destroy.
+ * Return Value
+ * ibv_destroy_wq() returns 0 on success, or the value of errno
+ * on failure (which indicates the failure reason).
+*/
+static inline int ibv_destroy_wq(struct ibv_wq *wq)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(wq->context, destroy_wq);
+	if (!vctx)
+		return ENOSYS;
+
+	return vctx->destroy_wq(wq);
+}
+
 /**
  * ibv_post_send - Post a list of work requests to a send queue.
  *
diff --git a/src/cmd.c b/src/cmd.c
index 4b3304f..6599eca 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1659,3 +1659,101 @@ int ibv_cmd_destroy_flow(struct ibv_flow *flow_id)
 	free(flow_id);
 	return ret;
 }
+
+int ibv_cmd_create_wq(struct ibv_context *context,
+		      struct ibv_wq_init_attr *wq_init_attr,
+		      struct ibv_wq *wq,
+		      struct ibv_create_wq *cmd,
+		      size_t cmd_core_size,
+		      size_t cmd_size,
+		      struct ibv_create_wq_resp *resp,
+		      size_t resp_core_size,
+		      size_t resp_size)
+{
+	int err;
+
+	if (wq_init_attr->comp_mask >= IBV_WQ_INIT_ATTR_RESERVED)
+		return EINVAL;
+
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size,
+			       CREATE_WQ, resp,
+			       resp_core_size, resp_size);
+
+	cmd->user_handle   = (uintptr_t)wq;
+	cmd->pd_handle           = wq_init_attr->pd->handle;
+	cmd->cq_handle   = wq_init_attr->cq->handle;
+	cmd->wq_type = wq_init_attr->wq_type;
+	cmd->max_sge = wq_init_attr->max_sge;
+	cmd->max_wr = wq_init_attr->max_wr;
+	cmd->comp_mask = 0;
+
+	err = write(context->cmd_fd, cmd, cmd_size);
+	if (err != cmd_size)
+		return errno;
+
+	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	if (resp->response_length < resp_core_size)
+		return EINVAL;
+
+	wq->handle  = resp->wq_handle;
+	wq_init_attr->max_wr = resp->max_wr;
+	wq_init_attr->max_sge = resp->max_sge;
+	wq->wq_num = resp->wqn;
+	wq->context = context;
+	wq->cq = wq_init_attr->cq;
+	wq->pd = wq_init_attr->pd;
+	wq->wq_type = wq_init_attr->wq_type;
+
+	return 0;
+}
+
+int ibv_cmd_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr,
+		      struct ibv_modify_wq *cmd, size_t cmd_core_size,
+		      size_t cmd_size)
+{
+	if (attr->attr_mask >= IBV_WQ_ATTR_RESERVED)
+		return EINVAL;
+
+	memset(cmd, 0, cmd_core_size);
+	IBV_INIT_CMD_EX(cmd, cmd_size, MODIFY_WQ);
+
+	cmd->curr_wq_state = attr->curr_wq_state;
+	cmd->wq_state = attr->wq_state;
+	cmd->wq_handle = wq->handle;
+	cmd->attr_mask = attr->attr_mask;
+
+	if (write(wq->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	if (attr->attr_mask & IBV_WQ_ATTR_STATE)
+		wq->state = attr->wq_state;
+
+	return 0;
+}
+
+int ibv_cmd_destroy_wq(struct ibv_wq *wq)
+{
+	struct ibv_destroy_wq cmd;
+	struct ibv_destroy_wq_resp resp;
+	int ret = 0;
+
+	memset(&cmd, 0, sizeof(cmd));
+	memset(&resp, 0, sizeof(resp));
+
+	IBV_INIT_CMD_RESP_EX(&cmd, sizeof(cmd), DESTROY_WQ, &resp, sizeof(resp));
+	cmd.wq_handle = wq->handle;
+
+	if (write(wq->context->cmd_fd, &cmd, sizeof(cmd)) != sizeof(cmd))
+		return errno;
+
+	if (resp.response_length < sizeof(resp))
+		return EINVAL;
+
+	pthread_mutex_lock(&wq->mutex);
+	while (wq->events_completed != resp.events_reported)
+		pthread_cond_wait(&wq->cond, &wq->mutex);
+	pthread_mutex_unlock(&wq->mutex);
+
+	return ret;
+}
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 5134bd9..78a06dd 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -118,5 +118,12 @@ IBVERBS_1.1 {
 		ibv_cmd_create_qp_ex2;
 		ibv_cmd_open_qp;
 		ibv_cmd_rereg_mr;
+};
+
+IBVERBS_1.3 {
+        global:
+		ibv_cmd_create_wq;
+		ibv_cmd_modify_wq;
+		ibv_cmd_destroy_wq;
 
 } IBVERBS_1.0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

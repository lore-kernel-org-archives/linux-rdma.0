From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] livibverbs: Add support for XRC SRQs
Date: Thu, 20 Sep 2012 21:43:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8E801@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC support requires the use of a new type of SRQ.

XRC shared receive queues: xrc srq's are similar to normal
srq's, except that they are bound to an xrcd, rather
than to a protection domain.  Based on the current spec
and implementation, they are only usable with xrc qps.  To
support xrc srq's, we define a new srq_init_attr structure
to include an srq type and other needed information.

The kernel ABI is also updated to allow creating extended
SRQs.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/driver.h   |    4 +++
 include/infiniband/kern-abi.h |   21 ++++++++++++++++-
 include/infiniband/verbs.h    |   37 ++++++++++++++++++++++++++++++
 src/cmd.c                     |   38 +++++++++++++++++++++++++++++++
 src/libibverbs.map            |    2 ++
 src/verbs.c                   |   50 ++++++++++++++++++++++++++++++++++++-----
 6 files changed, 144 insertions(+), 8 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 193b0dd..cac48ab 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -105,6 +105,10 @@ int ibv_cmd_create_srq(struct ibv_pd *pd,
 		       struct ibv_srq *srq, struct ibv_srq_init_attr *attr,
 		       struct ibv_create_srq *cmd, size_t cmd_size,
 		       struct ibv_create_srq_resp *resp, size_t resp_size);
+int ibv_cmd_create_srq_ex(struct ibv_pd *pd,
+			  struct ibv_srq *srq, struct ibv_srq_init_attr_ex *attr_ex,
+			  struct ibv_create_xsrq *cmd, size_t cmd_size,
+			  struct ibv_create_srq_resp *resp, size_t resp_size);
 int ibv_cmd_modify_srq(struct ibv_srq *srq,
 		       struct ibv_srq_attr *srq_attr,
 		       int srq_attr_mask,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index d7c673f..3d72fa7 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -88,6 +88,7 @@ enum {
 	IB_USER_VERBS_CMD_POST_SRQ_RECV,
 	IB_USER_VERBS_CMD_OPEN_XRCD,
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
+	IB_USER_VERBS_CMD_CREATE_XSRQ
 };
 
 /*
@@ -730,11 +731,28 @@ struct ibv_create_srq {
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
@@ -829,6 +847,7 @@ enum {
 	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL_V2 = -1,
 	IB_USER_VERBS_CMD_OPEN_XRCD_V2 = -1,
 	IB_USER_VERBS_CMD_CLOSE_XRCD_V2 = -1,
+	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1
 };
 
 struct ibv_destroy_cq_v1 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 6e02c9a..8756fed 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -437,6 +437,28 @@ struct ibv_srq_init_attr {
 	struct ibv_srq_attr	attr;
 };
 
+enum ibv_srq_type {
+	IBV_SRQT_BASIC,
+	IBV_SRQT_XRC
+};
+
+enum ibv_srq_init_attr_mask {
+	IBV_SRQ_INIT_ATTR_TYPE		= 1 << 0,
+	IBV_SRQ_INIT_ATTR_XRCD		= 1 << 1,
+	IBV_SRQ_INIT_ATTR_CQ		= 1 << 2,
+	IBV_SRQ_INIT_ATTR_RESERVED	= 1 << 3
+};
+
+struct ibv_srq_init_attr_ex {
+	void		       *srq_context;
+	struct ibv_srq_attr	attr;
+
+	uint64_t		comp_mask;
+	enum ibv_srq_type	srq_type;
+	struct ibv_xrcd	       *xrcd;
+	struct ibv_cq	       *cq;
+};
+
 enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
@@ -596,7 +618,11 @@ struct ibv_mw_bind {
 };
 
 enum ibv_srq_mask {
-	IBV_SRQ_RESERVED		= 1 << 0
+	IBV_SRQ_TYPE		= 1 << 0,
+	IBV_SRQ_XRCD		= 1 << 1,
+	IBV_SRQ_CQ		= 1 << 2,
+	IBV_SRQ_NUM		= 1 << 3,
+	IBV_SRQ_RESERVED	= 1 << 4
 };
 
 struct ibv_srq {
@@ -610,6 +636,10 @@ struct ibv_srq {
 	uint32_t		events_completed;
 
 	uint32_t		comp_mask;
+	enum ibv_srq_type	srq_type;
+	struct ibv_xrcd	       *xrcd;
+	struct ibv_cq	       *cq;
+	uint32_t		srq_num;
 };
 
 enum ibv_qp_mask {
@@ -790,6 +820,8 @@ struct verbs_context {
 	int (*drv_new_func1) ();	new corresponding provider call of func1
 	int (*lib_new_func1) ();	New library call func1
 	*/
+	struct ibv_srq *	(*create_srq_ex)(struct ibv_pd *pd,
+						 struct ibv_srq_init_attr_ex *srq_init_attr_ex);
 	struct ibv_xrcd *	(*open_xrcd)(struct ibv_context *context,
 					     int fd, int oflags);
 	int			(*close_xrcd)(struct ibv_xrcd *xrcd);
@@ -1052,6 +1084,9 @@ static inline int ibv_req_notify_cq(struct ibv_cq *cq, int solicited_only)
 struct ibv_srq *ibv_create_srq(struct ibv_pd *pd,
 			       struct ibv_srq_init_attr *srq_init_attr);
 
+struct ibv_srq *ibv_create_srq_ex(struct ibv_pd *pd,
+				  struct ibv_srq_init_attr_ex *srq_init_attr_ex);
+
 /**
  * ibv_modify_srq - Modifies the attributes for the specified SRQ.
  * @srq: The SRQ to modify.
diff --git a/src/cmd.c b/src/cmd.c
index 4a98c64..58326c7 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -481,6 +481,44 @@ int ibv_cmd_create_srq(struct ibv_pd *pd,
 	return 0;
 }
 
+int ibv_cmd_create_srq_ex(struct ibv_pd *pd,
+			  struct ibv_srq *srq, struct ibv_srq_init_attr_ex *attr_ex,
+			  struct ibv_create_xsrq *cmd, size_t cmd_size,
+			  struct ibv_create_srq_resp *resp, size_t resp_size)
+{
+	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_XSRQ, resp, resp_size);
+	cmd->user_handle = (uintptr_t) srq;
+	cmd->pd_handle   = pd->handle;
+	cmd->max_wr      = attr_ex->attr.max_wr;
+	cmd->max_sge     = attr_ex->attr.max_sge;
+	cmd->srq_limit   = attr_ex->attr.srq_limit;
+
+	cmd->srq_type = (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_TYPE) ?
+			attr_ex->srq_type : IBV_SRQT_BASIC;
+	if (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_XRCD)
+		cmd->xrcd_handle = attr_ex->xrcd->handle;
+	if (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_CQ)
+		cmd->cq_handle   = attr_ex->cq->handle;
+
+	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	srq->handle  = resp->srq_handle;
+	srq->context = pd->context;
+	if (cmd->srq_type == IBV_SRQT_XRC) {
+		srq->comp_mask |= IBV_SRQ_NUM;
+		srq->srq_num = resp->srqn;
+	}
+
+	attr_ex->attr.max_wr = resp->max_wr;
+	attr_ex->attr.max_sge = resp->max_sge;
+
+	return 0;
+}
+
+
 static int ibv_cmd_modify_srq_v3(struct ibv_srq *srq,
 				 struct ibv_srq_attr *srq_attr,
 				 int srq_attr_mask,
diff --git a/src/libibverbs.map b/src/libibverbs.map
index f21bffe..92bfabd 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -102,5 +102,7 @@ IBVERBS_1.1 {
 		ibv_close_xrcd;
 		ibv_cmd_open_xrcd;
 		ibv_cmd_close_xrcd;
+		ibv_create_srq_ex;
+		ibv_cmd_create_srq_ex;
 		
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index ea99ab0..a645173 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -382,26 +382,64 @@ void __ibv_ack_cq_events(struct ibv_cq *cq, unsigned int nevents)
 }
 default_symver(__ibv_ack_cq_events, ibv_ack_cq_events);
 
-struct ibv_srq *__ibv_create_srq(struct ibv_pd *pd,
-				 struct ibv_srq_init_attr *srq_init_attr)
+struct ibv_srq *__ibv_create_srq_ex(struct ibv_pd *pd,
+				    struct ibv_srq_init_attr_ex *srq_init_attr_ex)
 {
+	struct verbs_context *context_ex = verbs_get_ctx(pd->context);
 	struct ibv_srq *srq;
 
-	if (!pd->context->ops.create_srq)
-		return NULL;
+	if (srq_init_attr_ex->comp_mask) {
+		if (!context_ex->create_srq_ex ||
+		    srq_init_attr_ex->comp_mask >= IBV_SRQ_INIT_ATTR_RESERVED) {
+			errno = ENOSYS;
+			return NULL;
+		}
+
+		srq = context_ex->create_srq_ex(pd, srq_init_attr_ex);
+	} else {
+		srq = pd->context->ops.create_srq(pd, (struct ibv_srq_init_attr *)
+						      srq_init_attr_ex);
+	}
 
-	srq = pd->context->ops.create_srq(pd, srq_init_attr);
 	if (srq) {
 		srq->context          = pd->context;
-		srq->srq_context      = srq_init_attr->srq_context;
+		srq->srq_context      = srq_init_attr_ex->srq_context;
 		srq->pd               = pd;
 		srq->events_completed = 0;
 		pthread_mutex_init(&srq->mutex, NULL);
 		pthread_cond_init(&srq->cond, NULL);
+
+		srq->comp_mask |= IBV_SRQ_INIT_ATTR_TYPE;
+		srq->srq_type = (srq_init_attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_TYPE) ?
+				srq_init_attr_ex->srq_type : IBV_SRQT_BASIC;
+		if (srq_init_attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_XRCD) {
+			srq->comp_mask |= IBV_SRQ_XRCD;
+			srq->xrcd = srq_init_attr_ex->xrcd;
+		}
+		if (srq_init_attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_CQ) {
+			srq->comp_mask |= IBV_SRQ_CQ;
+			srq->cq = srq_init_attr_ex->cq;
+		}
 	}
 
 	return srq;
 }
+default_symver(__ibv_create_srq_ex, ibv_create_srq_ex);
+
+struct ibv_srq *__ibv_create_srq(struct ibv_pd *pd,
+				 struct ibv_srq_init_attr *srq_init_attr)
+{
+	struct ibv_srq_init_attr_ex srq_init_attr_ex;
+	struct ibv_srq *srq;
+
+	memcpy(&srq_init_attr_ex, srq_init_attr, sizeof *srq_init_attr);
+	srq_init_attr_ex.comp_mask = 0;
+	srq = ibv_create_srq_ex(pd, &srq_init_attr_ex);
+	if (srq)
+		memcpy(srq_init_attr, &srq_init_attr_ex, sizeof *srq_init_attr);
+
+	return srq;
+}
 default_symver(__ibv_create_srq, ibv_create_srq);
 
 int __ibv_modify_srq(struct ibv_srq *srq,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

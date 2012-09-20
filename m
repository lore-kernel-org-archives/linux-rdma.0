From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/8] libibverbs: Introduce XRC domains
Date: Thu, 20 Sep 2012 21:43:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8E7FB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC introduces several new concepts and structures, one of
which is the XRC domain.

XRC domains: xrcd's are a type of protection domain used to
associate shared receive queues with xrc queue pairs.  Since
xrcd are meant to be shared among multiple processes, we
introduce new APIs to open/close xrcd's.

The user to kernel ABI is extended to account for opening/
closing the xrcd.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/driver.h   |    5 +++++
 include/infiniband/kern-abi.h |   27 ++++++++++++++++++++++++++-
 include/infiniband/verbs.h    |   30 +++++++++++++++++++++++++++---
 src/cmd.c                     |   34 ++++++++++++++++++++++++++++++++++
 src/libibverbs.map            |    6 ++++++
 src/verbs.c                   |   26 ++++++++++++++++++++++++++
 6 files changed, 124 insertions(+), 4 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 5af0d7f..193b0dd 100644
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
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 619ea7e..d7c673f 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -85,7 +85,9 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_OPEN_XRCD,
+	IB_USER_VERBS_CMD_CLOSE_XRCD,
 };
 
 /*
@@ -246,6 +248,27 @@ struct ibv_dealloc_pd {
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
@@ -804,6 +827,8 @@ enum {
 	 * trick opcodes in IBV_INIT_CMD() doesn't break.
 	 */
 	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL_V2 = -1,
+	IB_USER_VERBS_CMD_OPEN_XRCD_V2 = -1,
+	IB_USER_VERBS_CMD_CLOSE_XRCD_V2 = -1,
 };
 
 struct ibv_destroy_cq_v1 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index f3cb2fc..6e02c9a 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2004 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2004, 2011-2012 Intel Corporation.  All rights reserved.
  * Copyright (c) 2005, 2006, 2007 Cisco Systems, Inc.  All rights reserved.
  * Copyright (c) 2005 PathScale, Inc.  All rights reserved.
  *
@@ -317,6 +317,18 @@ struct ibv_pd {
 	uint32_t		comp_mask;
 };
 
+enum ibv_xrcd_mask {
+	IBV_XRCD_CONTEXT	= 1 << 0,
+	IBV_XRCD_HANDLE		= 1 << 1,
+	IBV_XRCD_RESERVED	= 1 << 2
+};
+
+struct ibv_xrcd {
+	uint64_t		comp_mask;
+	struct ibv_context     *context;
+	uint32_t		handle;
+};
+
 enum ibv_rereg_mr_flags {
 	IBV_REREG_MR_CHANGE_TRANSLATION	= (1 << 0),
 	IBV_REREG_MR_CHANGE_PD		= (1 << 1),
@@ -774,11 +786,13 @@ struct ibv_context {
 };
 
 struct verbs_context {
-
 	/*  "grows up" - new fields go here
 	int (*drv_new_func1) ();	new corresponding provider call of func1
 	int (*lib_new_func1) ();	New library call func1
 	*/
+	struct ibv_xrcd *	(*open_xrcd)(struct ibv_context *context,
+					     int fd, int oflags);
+	int			(*close_xrcd)(struct ibv_xrcd *xrcd);
 	size_t sz;	/* Set by library on struct allocation,must be
 			* located right before struct ibv_context
 			*/
@@ -873,7 +887,7 @@ static inline int ___ibv_query_port(struct ibv_context *context,
 				    uint8_t port_num,
 				    struct ibv_port_attr *port_attr)
 {
-	/* For compatability when running with old libibverbs */
+	/* For compatibility when running with old libibverbs */
 	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
 	port_attr->reserved   = 0;
 
@@ -906,6 +920,16 @@ struct ibv_pd *ibv_alloc_pd(struct ibv_context *context);
 int ibv_dealloc_pd(struct ibv_pd *pd);
 
 /**
+ * ibv_open_xrcd - Open an extended connection domain
+ */
+struct ibv_xrcd *ibv_open_xrcd(struct ibv_context *context, int fd, int oflags);
+
+/**
+ * ibv_close_xrcd - Close an extended connection domain
+ */
+int ibv_close_xrcd(struct ibv_xrcd *xrcd);
+
+/**
  * ibv_reg_mr - Register a memory region
  */
 struct ibv_mr *ibv_reg_mr(struct ibv_pd *pd, void *addr,
diff --git a/src/cmd.c b/src/cmd.c
index dab8930..4a98c64 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -194,6 +194,40 @@ int ibv_cmd_dealloc_pd(struct ibv_pd *pd)
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
+	xrcd->comp_mask = IBV_XRCD_CONTEXT | IBV_XRCD_HANDLE;
+	xrcd->context = context;
+	xrcd->handle  = resp->xrcd_handle;
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
diff --git a/src/libibverbs.map b/src/libibverbs.map
index ee9adea..f21bffe 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -97,4 +97,10 @@ IBVERBS_1.1 {
 		ibv_port_state_str;
 		ibv_event_type_str;
 		ibv_wc_status_str;
+		
+		ibv_open_xrcd;
+		ibv_close_xrcd;
+		ibv_cmd_open_xrcd;
+		ibv_cmd_close_xrcd;
+		
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index 7973afc..ea99ab0 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -154,6 +154,32 @@ int __ibv_dealloc_pd(struct ibv_pd *pd)
 }
 default_symver(__ibv_dealloc_pd, ibv_dealloc_pd);
 
+struct ibv_xrcd *__ibv_open_xrcd(struct ibv_context *context, int fd, int oflags)
+{
+	struct verbs_context *context_ex = verbs_get_ctx(context);
+	struct ibv_xrcd *xrcd;
+
+	if (!context_ex->open_xrcd) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	xrcd = context_ex->open_xrcd(context, fd, oflags);
+	if (xrcd)
+		xrcd->context = context;
+
+	return xrcd;
+}
+default_symver(__ibv_open_xrcd, ibv_open_xrcd);
+
+int __ibv_close_xrcd(struct ibv_xrcd *xrcd)
+{
+	struct verbs_context *context_ex = verbs_get_ctx(xrcd->context);
+
+	return context_ex->close_xrcd(xrcd);
+}
+default_symver(__ibv_close_xrcd, ibv_close_xrcd);
+
 struct ibv_mr *__ibv_reg_mr(struct ibv_pd *pd, void *addr,
 			    size_t length, int access)
 {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 2/7] libibverbs: libibverbs: Introduce XRC domains
Date: Fri, 28 Sep 2012 22:53:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A981A6@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
change from v2:
Used structure to specify initial xrcd attributes in place
of direct function parameters.

 include/infiniband/driver.h   |   16 ++++++++++++
 include/infiniband/kern-abi.h |   27 +++++++++++++++++++-
 include/infiniband/verbs.h    |   55 +++++++++++++++++++++++++++++++++++++++--
 src/cmd.c                     |   41 +++++++++++++++++++++++++++++++
 src/libibverbs.map            |    4 +++
 5 files changed, 139 insertions(+), 4 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index f22f287..ce88442 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -53,6 +53,17 @@
  */
 #define IBV_DEVICE_LIBRARY_EXTENSION rdmav2
 
+enum verbs_xrcd_mask {
+	VERBS_XRCD_HANDLE	= 1 << 0,
+	VERBS_XRCD_RESERVED	= 1 << 1
+};
+
+struct verbs_xrcd {
+	struct ibv_xrcd		xrcd;
+	uint64_t		comp_mask;
+	uint32_t		handle;
+};
+
 typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
 						   int abi_version);
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
@@ -78,6 +89,11 @@ int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
 		     struct ibv_alloc_pd *cmd, size_t cmd_size,
 		     struct ibv_alloc_pd_resp *resp, size_t resp_size);
 int ibv_cmd_dealloc_pd(struct ibv_pd *pd);
+int ibv_cmd_open_xrcd(struct ibv_context *context, struct verbs_xrcd *xrcd,
+		      struct ibv_xrcd_init_attr *attr,
+		      struct ibv_open_xrcd *cmd, size_t cmd_size,
+		      struct ibv_open_xrcd_resp *resp, size_t resp_size);
+int ibv_cmd_close_xrcd(struct verbs_xrcd *xrcd);
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
index b196b83..cf8299a 100644
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
@@ -39,6 +39,7 @@
 #include <stdint.h>
 #include <pthread.h>
 #include <stddef.h>
+#include <errno.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -312,6 +313,22 @@ struct ibv_pd {
 	uint32_t		handle;
 };
 
+enum ibv_xrcd_init_attr_mask {
+	IBV_XRCD_INIT_ATTR_FD	    = 1 << 0,
+	IBV_XRCD_INIT_ATTR_OFLAGS   = 1 << 1,
+	IBV_XRCD_INIT_ATTR_RESERVED = 1 << 2
+};
+
+struct ibv_xrcd_init_attr {
+	uint32_t comp_mask;
+	int	 fd;
+	int	 oflags;
+};
+
+struct ibv_xrcd {
+	struct ibv_context     *context;
+};
+
 enum ibv_rereg_mr_flags {
 	IBV_REREG_MR_CHANGE_TRANSLATION	= (1 << 0),
 	IBV_REREG_MR_CHANGE_PD		= (1 << 1),
@@ -728,11 +745,15 @@ struct ibv_context {
 };
 
 enum verbs_context_mask {
-	VERBS_CONTEXT_RESERVED = 1 << 0
+	VERBS_CONTEXT_XRCD	= 1 << 0,
+	VERBS_CONTEXT_RESERVED	= 1 << 1
 };
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	struct ibv_xrcd *	(*open_xrcd)(struct ibv_context *context,
+					     struct ibv_xrcd_init_attr *xrcd_init_attr);
+	int			(*close_xrcd)(struct ibv_xrcd *xrcd);
 	uint64_t has_comp_mask;
 	size_t   sz;	/* Must be immediately before struct ibv_context */
 	struct ibv_context context;/* Must be last field in the struct */
@@ -745,6 +766,11 @@ static inline struct verbs_context *verbs_get_ctx(
 		NULL : container_of(ctx, struct verbs_context, context);
 }
 
+#define verbs_get_ctx_op(ctx, op) ({ \
+	struct verbs_context *vctx = verbs_get_ctx(ctx); \
+	(!vctx || (vctx->sz < sizeof(*vctx) - offsetof(struct verbs_context, op)) || \
+	 !vctx->op) ? NULL : vctx; })
+
 static inline struct verbs_device *verbs_get_device(
 					const struct ibv_device *dev)
 {
@@ -830,7 +856,7 @@ static inline int ___ibv_query_port(struct ibv_context *context,
 				    uint8_t port_num,
 				    struct ibv_port_attr *port_attr)
 {
-	/* For compatability when running with old libibverbs */
+	/* For compatibility when running with old libibverbs */
 	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
 	port_attr->reserved   = 0;
 
@@ -863,6 +889,29 @@ struct ibv_pd *ibv_alloc_pd(struct ibv_context *context);
 int ibv_dealloc_pd(struct ibv_pd *pd);
 
 /**
+ * ibv_open_xrcd - Open an extended connection domain
+ */
+static inline struct ibv_xrcd *
+ibv_open_xrcd(struct ibv_context *context, struct ibv_xrcd_init_attr *xrcd_init_attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(context, open_xrcd);
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+	return vctx->open_xrcd(context, xrcd_init_attr);
+}
+
+/**
+ * ibv_close_xrcd - Close an extended connection domain
+ */
+static inline int ibv_close_xrcd(struct ibv_xrcd *xrcd)
+{
+	struct verbs_context *vctx = verbs_get_ctx(xrcd->context);
+	return vctx->close_xrcd(xrcd);
+}
+
+/**
  * ibv_reg_mr - Register a memory region
  */
 struct ibv_mr *ibv_reg_mr(struct ibv_pd *pd, void *addr,
diff --git a/src/cmd.c b/src/cmd.c
index dab8930..f0fb1dc 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -194,6 +194,47 @@ int ibv_cmd_dealloc_pd(struct ibv_pd *pd)
 	return 0;
 }
 
+int ibv_cmd_open_xrcd(struct ibv_context *context, struct verbs_xrcd *xrcd,
+		      struct ibv_xrcd_init_attr *attr,
+		      struct ibv_open_xrcd *cmd, size_t cmd_size,
+		      struct ibv_open_xrcd_resp *resp, size_t resp_size)
+{
+	IBV_INIT_CMD_RESP(cmd, cmd_size, OPEN_XRCD, resp, resp_size);
+
+	if (attr->comp_mask >= IBV_XRCD_INIT_ATTR_RESERVED)
+		return ENOSYS;
+
+	if (!(attr->comp_mask & IBV_XRCD_INIT_ATTR_FD) ||
+	    !(attr->comp_mask & IBV_XRCD_INIT_ATTR_OFLAGS))
+		return EINVAL;
+
+	cmd->fd = attr->fd;
+	cmd->oflags = attr->oflags;
+	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	xrcd->xrcd.context = context;
+	xrcd->comp_mask = VERBS_XRCD_HANDLE;
+	xrcd->handle  = resp->xrcd_handle;
+
+	return 0;
+}
+
+int ibv_cmd_close_xrcd(struct verbs_xrcd *xrcd)
+{
+	struct ibv_close_xrcd cmd;
+
+	IBV_INIT_CMD(&cmd, sizeof cmd, CLOSE_XRCD);
+	cmd.xrcd_handle = xrcd->handle;
+
+	if (write(xrcd->xrcd.context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
+		return errno;
+
+	return 0;
+}
+
 int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   uint64_t hca_va, int access,
 		   struct ibv_mr *mr, struct ibv_reg_mr *cmd,
diff --git a/src/libibverbs.map b/src/libibverbs.map
index ee9adea..9a15f3f 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -97,4 +97,8 @@ IBVERBS_1.1 {
 		ibv_port_state_str;
 		ibv_event_type_str;
 		ibv_wc_status_str;
+		
+		ibv_cmd_open_xrcd;
+		ibv_cmd_close_xrcd;
+		
 } IBVERBS_1.0;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

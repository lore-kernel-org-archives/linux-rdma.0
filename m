From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V7 libibverbs 2/7] Introduce XRC domains
Date: Thu, 11 Jul 2013 18:04:18 +0300
Message-ID: <1373555063-31790-3-git-send-email-yishaih@mellanox.com>
References: <1373555063-31790-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373555063-31790-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

XRC introduces several new concepts and structures, one of
which is the XRC domain.

XRC domains: xrcd's are a type of protection domain used to
associate shared receive queues with xrc queue pairs.  Since
xrcd are meant to be shared among multiple processes, we
introduce new APIs to open/close xrcd's.

The user to kernel ABI is extended to account for opening/
closing the xrcd.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Changes from V6:
verbs_xrcd - use uint32 for comp_mask. 
verbs_context - save place for ABI compatibility with OFED.
ibv_cmd_open_xrcd - verify input size.

 include/infiniband/driver.h   |   17 +++++++++++++
 include/infiniband/kern-abi.h |   27 +++++++++++++++++++++-
 include/infiniband/verbs.h    |   51 ++++++++++++++++++++++++++++++++++++++--
 src/cmd.c                     |   45 ++++++++++++++++++++++++++++++++++++
 src/libibverbs.map            |    3 ++
 5 files changed, 139 insertions(+), 4 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index f22f287..08d8a82 100644
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
+	uint32_t		comp_mask;
+	uint32_t		handle;
+};
+
 typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
 						   int abi_version);
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
@@ -78,6 +89,12 @@ int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
 		     struct ibv_alloc_pd *cmd, size_t cmd_size,
 		     struct ibv_alloc_pd_resp *resp, size_t resp_size);
 int ibv_cmd_dealloc_pd(struct ibv_pd *pd);
+int ibv_cmd_open_xrcd(struct ibv_context *context, struct verbs_xrcd *xrcd,
+		      int vxrcd_size,
+		      struct ibv_xrcd_init_attr *attr,
+		      struct ibv_open_xrcd *cmd, size_t cmd_size,
+		      struct ibv_open_xrcd_resp *resp, size_t resp_size);
+int ibv_cmd_close_xrcd(struct verbs_xrcd *xrcd);
 #define IBV_CMD_REG_MR_HAS_RESP_PARAMS
 int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   uint64_t hca_va, int access,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index e7f8981..6f40ad2 100644
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
 
 struct ibv_modify_srq_v3 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 429beae..ae57296 100644
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
@@ -314,6 +315,22 @@ struct ibv_pd {
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
@@ -752,11 +769,16 @@ struct ibv_context {
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
+	void	*func_reserved[6]; /* Save place for ABI compatibility with OFED */
 	uint64_t has_comp_mask;
 	size_t   sz;	/* Must be immediately before struct ibv_context */
 	struct ibv_context context;/* Must be last field in the struct */
@@ -859,7 +881,7 @@ static inline int ___ibv_query_port(struct ibv_context *context,
 				    uint8_t port_num,
 				    struct ibv_port_attr *port_attr)
 {
-	/* For compatability when running with old libibverbs */
+	/* For compatibility when running with old libibverbs */
 	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
 	port_attr->reserved   = 0;
 
@@ -892,6 +914,29 @@ struct ibv_pd *ibv_alloc_pd(struct ibv_context *context);
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
index 86350fd..f3d590a 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -194,6 +194,51 @@ int ibv_cmd_dealloc_pd(struct ibv_pd *pd)
 	return 0;
 }
 
+int ibv_cmd_open_xrcd(struct ibv_context *context, struct verbs_xrcd *xrcd,
+		      int vxrcd_size,
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
+	xrcd->comp_mask = 0;
+	if (vext_field_avail(struct verbs_xrcd, handle, vxrcd_size)) {
+		xrcd->comp_mask = VERBS_XRCD_HANDLE;
+		xrcd->handle  = resp->xrcd_handle;
+	}
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
index 6e35c37..c190eb9 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -100,4 +100,7 @@ IBVERBS_1.1 {
 
 		ibv_rate_to_mbps;
 		mbps_to_ibv_rate;
+
+		ibv_cmd_open_xrcd;
+		ibv_cmd_close_xrcd;
 } IBVERBS_1.0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

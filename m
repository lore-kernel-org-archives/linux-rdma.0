From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 02/12] rpcrdma: infrastructure for static trace points in
 rpcrdma.ko
Date: Wed, 20 Dec 2017 16:30:31 -0500
Message-ID: <20171220213031.29321.61016.stgit@manet.1015granger.net>
References: <20171220210236.29321.59307.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171220210236.29321.59307.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/trace/events/rpcrdma.h  |   15 +++++++++++++++
 net/sunrpc/xprtrdma/module.c    |   12 +++++++-----
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 ++
 3 files changed, 24 insertions(+), 5 deletions(-)
 create mode 100644 include/trace/events/rpcrdma.h

diff --git a/include/trace/events/rpcrdma.h b/include/trace/events/rpcrdma.h
new file mode 100644
index 0000000..e7ca063
--- /dev/null
+++ b/include/trace/events/rpcrdma.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright (c) 2017 Oracle.  All rights reserved.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rpcrdma
+
+#if !defined(_TRACE_RPCRDMA_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RPCRDMA_H
+
+#include <linux/tracepoint.h>
+#include <trace/events/rdma.h>
+
+#endif /* _TRACE_RPCRDMA_H */
+
+#include <trace/define_trace.h>
diff --git a/net/sunrpc/xprtrdma/module.c b/net/sunrpc/xprtrdma/module.c
index 560712b..a762d19 100644
--- a/net/sunrpc/xprtrdma/module.c
+++ b/net/sunrpc/xprtrdma/module.c
@@ -1,18 +1,20 @@
 /*
- * Copyright (c) 2015 Oracle.  All rights reserved.
+ * Copyright (c) 2015, 2017 Oracle.  All rights reserved.
  */
 
 /* rpcrdma.ko module initialization
  */
 
+#include <linux/types.h>
+#include <linux/compiler.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sunrpc/svc_rdma.h>
-#include "xprt_rdma.h"
 
-#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
-# define RPCDBG_FACILITY	RPCDBG_TRANS
-#endif
+#include <asm/swab.h>
+
+#define CREATE_TRACE_POINTS
+#include "xprt_rdma.h"
 
 MODULE_AUTHOR("Open Grid Computing and Network Appliance, Inc.");
 MODULE_DESCRIPTION("RPC/RDMA Transport");
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 28ae1fb..a1ca1b6 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -675,3 +675,5 @@ static inline void rpcrdma_set_xdrlen(struct xdr_buf *xdr, size_t len)
 extern struct xprt_class xprt_rdma_bc;
 
 #endif				/* _LINUX_SUNRPC_XPRT_RDMA_H */
+
+#include <trace/events/rpcrdma.h>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

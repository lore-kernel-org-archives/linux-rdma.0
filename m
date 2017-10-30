From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/4] xprtrdma: Update copyright notices
Date: Mon, 30 Oct 2017 16:22:14 -0400
Message-ID: <20171030202214.8146.73099.stgit@manet.1015granger.net>
References: <20171030201903.8146.45897.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030201903.8146.45897.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Credit work contributed by Oracle engineers since 2014.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/rpc_rdma.h |    1 +
 net/sunrpc/xprtrdma/rpc_rdma.c  |    1 +
 net/sunrpc/xprtrdma/transport.c |    1 +
 net/sunrpc/xprtrdma/verbs.c     |    1 +
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
 5 files changed, 5 insertions(+)

diff --git a/include/linux/sunrpc/rpc_rdma.h b/include/linux/sunrpc/rpc_rdma.h
index 840afac..8f144db 100644
--- a/include/linux/sunrpc/rpc_rdma.h
+++ b/include/linux/sunrpc/rpc_rdma.h
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2015-2017 Oracle. All rights reserved.
  * Copyright (c) 2003-2007 Network Appliance, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 45cb549..ed34dc0 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014-2017 Oracle.  All rights reserved.
  * Copyright (c) 2003-2007 Network Appliance, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index dcc2df0..04494bb 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014-2017 Oracle.  All rights reserved.
  * Copyright (c) 2003-2007 Network Appliance, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index be61c29..710b3f7 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014-2017 Oracle.  All rights reserved.
  * Copyright (c) 2003-2007 Network Appliance, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 8b9954c..51686d9 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014-2017 Oracle.  All rights reserved.
  * Copyright (c) 2003-2007 Network Appliance, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

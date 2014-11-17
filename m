From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 3/3] xprtrdma: Replace array of connection strings
Date: Sun, 16 Nov 2014 21:30:05 -0500
Message-ID: <20141117023005.4079.11846.stgit@manet.1015granger.net>
References: <20141117022038.4079.66922.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141117022038.4079.66922.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use the generic helper instead.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c     |   27 +--------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
 2 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 61c4129..bd8cfe7 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -313,31 +313,6 @@ rpcrdma_flush_cqs(struct rpcrdma_ep *ep)
 	rpcrdma_sendcq_upcall(ep->rep_attr.send_cq, ep);
 }
 
-#ifdef RPC_DEBUG
-static const char * const conn[] = {
-	"address resolved",
-	"address error",
-	"route resolved",
-	"route error",
-	"connect request",
-	"connect response",
-	"connect error",
-	"unreachable",
-	"rejected",
-	"established",
-	"disconnected",
-	"device removal",
-	"multicast join",
-	"multicast error",
-	"address change",
-	"timewait exit",
-};
-
-#define CONNECTION_MSG(status)						\
-	((status) < ARRAY_SIZE(conn) ?					\
-		conn[(status)] : "unrecognized connection error")
-#endif
-
 static int
 rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
 {
@@ -404,7 +379,7 @@ connected:
 		dprintk("RPC:       %s: %pI4:%u (ep 0x%p): %s\n",
 			__func__, &addr->sin_addr.s_addr,
 			ntohs(addr->sin_port), ep,
-			CONNECTION_MSG(event->event));
+			rdma_cm_event_str(event->event));
 		break;
 	}
 
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index ac7fc9a..bed6969 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -47,6 +47,7 @@
 
 #include <rdma/rdma_cm.h>		/* RDMA connection api */
 #include <rdma/ib_verbs.h>		/* RDMA verbs api */
+#include <rdma/ib_str.h>		/* RDMA error strings api */
 
 #include <linux/sunrpc/clnt.h> 		/* rpc_xprt */
 #include <linux/sunrpc/rpc_rdma.h> 	/* RPC/RDMA protocol */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

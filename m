From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 19/24] xprtrdma: Use macros for reconnection timeout
	constants
Date: Wed, 28 May 2014 10:34:32 -0400
Message-ID: <20140528143432.23214.89037.stgit@manet.1015granger.net>
References: <20140528142521.23214.39655.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140528142521.23214.39655.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: Ensure the same max and min constant values are used
everywhere when setting reconnect timeouts.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/transport.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index d18b2a3..6b84d7d 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -149,6 +149,11 @@ static struct ctl_table sunrpc_table[] = {
 
 #endif
 
+#define RPCRDMA_BIND_TO		(60U * HZ)
+#define RPCRDMA_INIT_REEST_TO	(5U * HZ)
+#define RPCRDMA_MAX_REEST_TO	(30U * HZ)
+#define RPCRDMA_IDLE_DISC_TO	(5U * 60 * HZ)
+
 static struct rpc_xprt_ops xprt_rdma_procs;	/* forward reference */
 
 static void
@@ -285,9 +290,9 @@ xprt_setup_rdma(struct xprt_create *args)
 
 	/* 60 second timeout, no retries */
 	xprt->timeout = &xprt_rdma_default_timeout;
-	xprt->bind_timeout = (60U * HZ);
-	xprt->reestablish_timeout = (5U * HZ);
-	xprt->idle_timeout = (5U * 60 * HZ);
+	xprt->bind_timeout = RPCRDMA_BIND_TO;
+	xprt->reestablish_timeout = RPCRDMA_INIT_REEST_TO;
+	xprt->idle_timeout = RPCRDMA_IDLE_DISC_TO;
 
 	xprt->resvport = 0;		/* privileged port not needed */
 	xprt->tsh_size = 0;		/* RPC-RDMA handles framing */
@@ -432,10 +437,10 @@ xprt_rdma_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 		schedule_delayed_work(&r_xprt->rdma_connect,
 			xprt->reestablish_timeout);
 		xprt->reestablish_timeout <<= 1;
-		if (xprt->reestablish_timeout > (30 * HZ))
-			xprt->reestablish_timeout = (30 * HZ);
-		else if (xprt->reestablish_timeout < (5 * HZ))
-			xprt->reestablish_timeout = (5 * HZ);
+		if (xprt->reestablish_timeout > RPCRDMA_MAX_REEST_TO)
+			xprt->reestablish_timeout = RPCRDMA_MAX_REEST_TO;
+		else if (xprt->reestablish_timeout < RPCRDMA_INIT_REEST_TO)
+			xprt->reestablish_timeout = RPCRDMA_INIT_REEST_TO;
 	} else {
 		schedule_delayed_work(&r_xprt->rdma_connect, 0);
 		if (!RPC_IS_ASYNC(task))

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

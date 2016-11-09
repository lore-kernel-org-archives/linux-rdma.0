From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 06/14] xprtrdma: Address coverity complaint about
 wait_for_completion()
Date: Wed, 09 Nov 2016 14:05:38 -0500
Message-ID: <20161109190538.15007.22961.stgit@manet.1015granger.net>
References: <20161109184735.15007.96507.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109184735.15007.96507.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> ** CID 114101:  Error handling issues  (CHECKED_RETURN)
> /net/sunrpc/xprtrdma/verbs.c: 355 in rpcrdma_create_id()

Commit 5675add36e76 ("RPC/RDMA: harden connection logic against
missing/late rdma_cm upcalls.") replaced wait_for_completion() calls
with these two call sites.

The original wait_for_completion() calls were added in the initial
commit of verbs.c, which was commit c56c65fb67d6 ("RPCRDMA: rpc rdma
verbs interface implementation"), but these returned void.

rpcrdma_create_id() is called by the RDMA connect worker, which
probably won't ever be interrupted. It is also called by
rpcrdma_ia_open which is in the synchronous mount path, and ^C is
possible there.

Add a bit of logic at those two call sites to return if the waits
return ERESTARTSYS.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 451f5f2..cbb1885 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -331,6 +331,7 @@ static void rpcrdma_destroy_id(struct rdma_cm_id *id)
 rpcrdma_create_id(struct rpcrdma_xprt *xprt,
 			struct rpcrdma_ia *ia, struct sockaddr *addr)
 {
+	unsigned long wtimeout = msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1;
 	struct rdma_cm_id *id;
 	int rc;
 
@@ -352,8 +353,12 @@ static void rpcrdma_destroy_id(struct rdma_cm_id *id)
 			__func__, rc);
 		goto out;
 	}
-	wait_for_completion_interruptible_timeout(&ia->ri_done,
-				msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
+	rc = wait_for_completion_interruptible_timeout(&ia->ri_done, wtimeout);
+	if (rc < 0) {
+		dprintk("RPC:       %s: wait() exited: %i\n",
+			__func__, rc);
+		goto out;
+	}
 
 	/* FIXME:
 	 * Until xprtrdma supports DEVICE_REMOVAL, the provider must
@@ -376,8 +381,12 @@ static void rpcrdma_destroy_id(struct rdma_cm_id *id)
 			__func__, rc);
 		goto put;
 	}
-	wait_for_completion_interruptible_timeout(&ia->ri_done,
-				msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
+	rc = wait_for_completion_interruptible_timeout(&ia->ri_done, wtimeout);
+	if (rc < 0) {
+		dprintk("RPC:       %s: wait() exited: %i\n",
+			__func__, rc);
+		goto put;
+	}
 	rc = ia->ri_async_rc;
 	if (rc)
 		goto put;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

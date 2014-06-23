From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 11/13] xprtrdma: Clean up rpcrdma_ep_disconnect()
Date: Mon, 23 Jun 2014 18:40:31 -0400
Message-ID: <20140623224031.1634.30045.stgit@manet.1015granger.net>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140623223201.1634.83888.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The return code is used only for dprintk's that are already
redundant.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |    2 +-
 net/sunrpc/xprtrdma/verbs.c     |   13 +++----------
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 +-
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index f6d280b..2faac49 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -414,7 +414,7 @@ xprt_rdma_close(struct rpc_xprt *xprt)
 	if (r_xprt->rx_ep.rep_connected > 0)
 		xprt->reestablish_timeout = 0;
 	xprt_disconnect_done(xprt);
-	(void) rpcrdma_ep_disconnect(&r_xprt->rx_ep, &r_xprt->rx_ia);
+	rpcrdma_ep_disconnect(&r_xprt->rx_ep, &r_xprt->rx_ia);
 }
 
 static void
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 52f57f7..b6c52c7 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -838,10 +838,7 @@ rpcrdma_ep_destroy(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 	cancel_delayed_work_sync(&ep->rep_connect_worker);
 
 	if (ia->ri_id->qp) {
-		rc = rpcrdma_ep_disconnect(ep, ia);
-		if (rc)
-			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
-				" returned %i\n", __func__, rc);
+		rpcrdma_ep_disconnect(ep, ia);
 		rdma_destroy_qp(ia->ri_id);
 		ia->ri_id->qp = NULL;
 	}
@@ -879,10 +876,7 @@ rpcrdma_ep_connect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 		struct rpcrdma_xprt *xprt;
 retry:
 		dprintk("RPC:       %s: reconnecting...\n", __func__);
-		rc = rpcrdma_ep_disconnect(ep, ia);
-		if (rc && rc != -ENOTCONN)
-			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
-				" status %i\n", __func__, rc);
+		rpcrdma_ep_disconnect(ep, ia);
 
 		xprt = container_of(ia, struct rpcrdma_xprt, rx_ia);
 		id = rpcrdma_create_id(xprt, ia,
@@ -988,7 +982,7 @@ out:
  * This call is not reentrant, and must not be made in parallel
  * on the same endpoint.
  */
-int
+void
 rpcrdma_ep_disconnect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 {
 	int rc;
@@ -1004,7 +998,6 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 		dprintk("RPC:       %s: rdma_disconnect %i\n", __func__, rc);
 		ep->rep_connected = rc;
 	}
-	return rc;
 }
 
 /*
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 7a140fe..4f7de2a 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -343,7 +343,7 @@ int rpcrdma_ep_create(struct rpcrdma_ep *, struct rpcrdma_ia *,
 				struct rpcrdma_create_data_internal *);
 void rpcrdma_ep_destroy(struct rpcrdma_ep *, struct rpcrdma_ia *);
 int rpcrdma_ep_connect(struct rpcrdma_ep *, struct rpcrdma_ia *);
-int rpcrdma_ep_disconnect(struct rpcrdma_ep *, struct rpcrdma_ia *);
+void rpcrdma_ep_disconnect(struct rpcrdma_ep *, struct rpcrdma_ia *);
 
 int rpcrdma_ep_post(struct rpcrdma_ia *, struct rpcrdma_ep *,
 				struct rpcrdma_req *);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

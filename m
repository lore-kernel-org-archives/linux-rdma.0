From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 12/14] xprtrdma: Simplify synopsis of rpcrdma_ep_connect()
Date: Wed, 09 Nov 2016 14:06:28 -0500
Message-ID: <20161109190628.15007.67246.stgit@manet.1015granger.net>
References: <20161109184735.15007.96507.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109184735.15007.96507.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: Make the rpcrdma_xprt visible in the whole function.
The caller has it already, so eliminate the container_of noise, and
just pass it in explicitly.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |    2 +-
 net/sunrpc/xprtrdma/verbs.c     |   17 +++++++----------
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 +-
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 534c178..349903b 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -259,7 +259,7 @@
 
 	dprintk("RPC:       %s: %sconnect\n", __func__,
 			r_xprt->rx_ep.rep_connected != 0 ? "re" : "");
-	rc = rpcrdma_ep_connect(&r_xprt->rx_ep, &r_xprt->rx_ia);
+	rc = rpcrdma_ep_connect(r_xprt);
 	if (rc)
 		xprt_wake_pending_tasks(xprt, rc);
 
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 11d0774..901c3ab 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -634,26 +634,25 @@ static void rpcrdma_destroy_id(struct rdma_cm_id *id)
 	ib_free_cq(ep->rep_attr.send_cq);
 }
 
-/*
- * Connect unconnected endpoint.
- */
 int
-rpcrdma_ep_connect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
+rpcrdma_ep_connect(struct rpcrdma_xprt *r_xprt)
 {
+	struct rpcrdma_ep *ep = &r_xprt->rx_ep;
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	struct rdma_cm_id *id, *old;
 	int rc = 0;
 	int retry_count = 0;
 
 	if (ep->rep_connected != 0) {
-		struct rpcrdma_xprt *xprt;
+		struct sockaddr *sap;
+
 retry:
 		dprintk("RPC:       %s: reconnecting...\n", __func__);
 
 		rpcrdma_ep_disconnect(ep, ia);
 
-		xprt = container_of(ia, struct rpcrdma_xprt, rx_ia);
-		id = rpcrdma_create_id(xprt, ia,
-				(struct sockaddr *)&xprt->rx_data.addr);
+		sap = (struct sockaddr *)&r_xprt->rx_data.addr;
+		id = rpcrdma_create_id(r_xprt, ia, sap);
 		if (IS_ERR(id)) {
 			rc = -EHOSTUNREACH;
 			goto out;
@@ -735,12 +734,10 @@ static void rpcrdma_destroy_id(struct rdma_cm_id *id)
 		}
 		rc = ep->rep_connected;
 	} else {
-		struct rpcrdma_xprt *r_xprt;
 		unsigned int extras;
 
 		dprintk("RPC:       %s: connected\n", __func__);
 
-		r_xprt = container_of(ia, struct rpcrdma_xprt, rx_ia);
 		extras = r_xprt->rx_buf.rb_bc_srv_max_requests;
 
 		if (extras) {
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index e35efd4..74760d9 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -489,7 +489,7 @@ struct rpcrdma_xprt {
 int rpcrdma_ep_create(struct rpcrdma_ep *, struct rpcrdma_ia *,
 				struct rpcrdma_create_data_internal *);
 void rpcrdma_ep_destroy(struct rpcrdma_ep *, struct rpcrdma_ia *);
-int rpcrdma_ep_connect(struct rpcrdma_ep *, struct rpcrdma_ia *);
+int rpcrdma_ep_connect(struct rpcrdma_xprt *r_xprt);
 void rpcrdma_conn_func(struct rpcrdma_ep *ep);
 void rpcrdma_ep_disconnect(struct rpcrdma_ep *, struct rpcrdma_ia *);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

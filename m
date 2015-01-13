From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 13/20] xprtrdma: Simplify synopsis of
 rpcrdma_buffer_create()
Date: Tue, 13 Jan 2015 11:26:31 -0500
Message-ID: <20150113162631.14086.69242.stgit@manet.1015granger.net>
References: <20150113161440.14086.24801.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150113161440.14086.24801.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: There is one call site for rpcrdma_buffer_create(). All of
the arguments there are fields of an rpcrdma_xprt.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |    3 +--
 net/sunrpc/xprtrdma/verbs.c     |    7 +++++--
 net/sunrpc/xprtrdma/xprt_rdma.h |    4 +---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index a487bde..808b3c5 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -364,8 +364,7 @@ xprt_setup_rdma(struct xprt_create *args)
 	 * any inline data. Also specify any padding which will be provided
 	 * from a preregistered zero buffer.
 	 */
-	rc = rpcrdma_buffer_create(&new_xprt->rx_buf, new_ep, &new_xprt->rx_ia,
-				&new_xprt->rx_data);
+	rc = rpcrdma_buffer_create(new_xprt);
 	if (rc)
 		goto out3;
 
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 958b372..fd71501 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1161,9 +1161,11 @@ out_free:
 }
 
 int
-rpcrdma_buffer_create(struct rpcrdma_buffer *buf, struct rpcrdma_ep *ep,
-	struct rpcrdma_ia *ia, struct rpcrdma_create_data_internal *cdata)
+rpcrdma_buffer_create(struct rpcrdma_xprt *r_xprt)
 {
+	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
+	struct rpcrdma_create_data_internal *cdata = &r_xprt->rx_data;
 	char *p;
 	size_t len, rlen, wlen;
 	int i, rc;
@@ -1200,6 +1202,7 @@ rpcrdma_buffer_create(struct rpcrdma_buffer *buf, struct rpcrdma_ep *ep,
 	 * Register the zeroed pad buffer, if any.
 	 */
 	if (cdata->padding) {
+		struct rpcrdma_ep *ep = &r_xprt->rx_ep;
 		rc = rpcrdma_register_internal(ia, p, cdata->padding,
 					    &ep->rep_pad_mr, &ep->rep_pad);
 		if (rc)
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 2b4e778..5c2fac3 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -354,9 +354,7 @@ int rpcrdma_ep_post_recv(struct rpcrdma_ia *, struct rpcrdma_ep *,
 /*
  * Buffer calls - xprtrdma/verbs.c
  */
-int rpcrdma_buffer_create(struct rpcrdma_buffer *, struct rpcrdma_ep *,
-				struct rpcrdma_ia *,
-				struct rpcrdma_create_data_internal *);
+int rpcrdma_buffer_create(struct rpcrdma_xprt *);
 void rpcrdma_buffer_destroy(struct rpcrdma_buffer *);
 
 struct rpcrdma_req *rpcrdma_buffer_get(struct rpcrdma_buffer *);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

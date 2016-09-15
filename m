From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 12/22] xprtrdma: Simplify rpcrdma_ep_post_recv()
Date: Thu, 15 Sep 2016 10:56:35 -0400
Message-ID: <20160915145634.11080.17108.stgit@manet.1015granger.net>
References: <20160915143440.11080.89241.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915143440.11080.89241.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

Since commit fc66448549bb ("xprtrdma: Split the completion queue"),
rpcrdma_ep_post_recv() no longer uses the "ep" argument.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/backchannel.c |    2 +-
 net/sunrpc/xprtrdma/rpc_rdma.c    |    2 +-
 net/sunrpc/xprtrdma/verbs.c       |    9 ++-------
 net/sunrpc/xprtrdma/xprt_rdma.h   |    3 +--
 4 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/sunrpc/xprtrdma/backchannel.c b/net/sunrpc/xprtrdma/backchannel.c
index a19530d..887ef44 100644
--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -397,7 +397,7 @@ out_overflow:
 out_short:
 	pr_warn("RPC/RDMA short backward direction call\n");
 
-	if (rpcrdma_ep_post_recv(&r_xprt->rx_ia, &r_xprt->rx_ep, rep))
+	if (rpcrdma_ep_post_recv(&r_xprt->rx_ia, rep))
 		xprt_disconnect_done(xprt);
 	else
 		pr_warn("RPC:       %s: reposting rep %p\n",
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 68a39c0..6187cee 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1141,6 +1141,6 @@ out_duplicate:
 
 repost:
 	r_xprt->rx_stats.bad_reply_count++;
-	if (rpcrdma_ep_post_recv(&r_xprt->rx_ia, &r_xprt->rx_ep, rep))
+	if (rpcrdma_ep_post_recv(&r_xprt->rx_ia, rep))
 		rpcrdma_recv_buffer_put(rep);
 }
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 1f7f4a9..7b189fe 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1265,7 +1265,7 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
 	int i, rc;
 
 	if (rep) {
-		rc = rpcrdma_ep_post_recv(ia, ep, rep);
+		rc = rpcrdma_ep_post_recv(ia, rep);
 		if (rc)
 			return rc;
 		req->rl_reply = NULL;
@@ -1300,12 +1300,8 @@ out_postsend_err:
 	return -ENOTCONN;
 }
 
-/*
- * (Re)post a receive buffer.
- */
 int
 rpcrdma_ep_post_recv(struct rpcrdma_ia *ia,
-		     struct rpcrdma_ep *ep,
 		     struct rpcrdma_rep *rep)
 {
 	struct ib_recv_wr recv_wr, *recv_wr_fail;
@@ -1344,7 +1340,6 @@ rpcrdma_ep_post_extra_recv(struct rpcrdma_xprt *r_xprt, unsigned int count)
 {
 	struct rpcrdma_buffer *buffers = &r_xprt->rx_buf;
 	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
-	struct rpcrdma_ep *ep = &r_xprt->rx_ep;
 	struct rpcrdma_rep *rep;
 	int rc;
 
@@ -1355,7 +1350,7 @@ rpcrdma_ep_post_extra_recv(struct rpcrdma_xprt *r_xprt, unsigned int count)
 		rep = rpcrdma_buffer_get_rep_locked(buffers);
 		spin_unlock(&buffers->rb_lock);
 
-		rc = rpcrdma_ep_post_recv(ia, ep, rep);
+		rc = rpcrdma_ep_post_recv(ia, rep);
 		if (rc)
 			goto out_rc;
 	}
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 4875af7..decd134 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -457,8 +457,7 @@ void rpcrdma_ep_disconnect(struct rpcrdma_ep *, struct rpcrdma_ia *);
 
 int rpcrdma_ep_post(struct rpcrdma_ia *, struct rpcrdma_ep *,
 				struct rpcrdma_req *);
-int rpcrdma_ep_post_recv(struct rpcrdma_ia *, struct rpcrdma_ep *,
-				struct rpcrdma_rep *);
+int rpcrdma_ep_post_recv(struct rpcrdma_ia *, struct rpcrdma_rep *);
 
 /*
  * Buffer calls - xprtrdma/verbs.c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

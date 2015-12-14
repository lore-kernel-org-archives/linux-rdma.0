From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 01/11] xprtrdma: Fix additional uses of
 spin_lock_irqsave(rb_lock)
Date: Mon, 14 Dec 2015 16:17:46 -0500
Message-ID: <20151214211746.16295.38958.stgit@manet.1015granger.net>
References: <20151214211317.16295.70115.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214211317.16295.70115.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

rb_lock critical sections added in rpcrdma_ep_post_extra_recv()
should have first been converted to use normal spin_lock now that
the reply handler is a work queue.

The backchannel set up code should use the appropriate helper
instead of open-coding a rb_recv_bufs list add.

Problem introduced by glib patch re-ordering on my part.

Fixes: f531a5dbc451 ('xprtrdma: Pre-allocate backward rpc_rqst')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/backchannel.c |    6 +-----
 net/sunrpc/xprtrdma/verbs.c       |    7 +++----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprtrdma/backchannel.c b/net/sunrpc/xprtrdma/backchannel.c
index 2dcb44f..11d2cfb 100644
--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -84,9 +84,7 @@ out_fail:
 static int rpcrdma_bc_setup_reps(struct rpcrdma_xprt *r_xprt,
 				 unsigned int count)
 {
-	struct rpcrdma_buffer *buffers = &r_xprt->rx_buf;
 	struct rpcrdma_rep *rep;
-	unsigned long flags;
 	int rc = 0;
 
 	while (count--) {
@@ -98,9 +96,7 @@ static int rpcrdma_bc_setup_reps(struct rpcrdma_xprt *r_xprt,
 			break;
 		}
 
-		spin_lock_irqsave(&buffers->rb_lock, flags);
-		list_add(&rep->rr_list, &buffers->rb_recv_bufs);
-		spin_unlock_irqrestore(&buffers->rb_lock, flags);
+		rpcrdma_recv_buffer_put(rep);
 	}
 
 	return rc;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 650034b..f23f3d6 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1329,15 +1329,14 @@ rpcrdma_ep_post_extra_recv(struct rpcrdma_xprt *r_xprt, unsigned int count)
 	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	struct rpcrdma_ep *ep = &r_xprt->rx_ep;
 	struct rpcrdma_rep *rep;
-	unsigned long flags;
 	int rc;
 
 	while (count--) {
-		spin_lock_irqsave(&buffers->rb_lock, flags);
+		spin_lock(&buffers->rb_lock);
 		if (list_empty(&buffers->rb_recv_bufs))
 			goto out_reqbuf;
 		rep = rpcrdma_buffer_get_rep_locked(buffers);
-		spin_unlock_irqrestore(&buffers->rb_lock, flags);
+		spin_unlock(&buffers->rb_lock);
 
 		rc = rpcrdma_ep_post_recv(ia, ep, rep);
 		if (rc)
@@ -1347,7 +1346,7 @@ rpcrdma_ep_post_extra_recv(struct rpcrdma_xprt *r_xprt, unsigned int count)
 	return 0;
 
 out_reqbuf:
-	spin_unlock_irqrestore(&buffers->rb_lock, flags);
+	spin_unlock(&buffers->rb_lock);
 	pr_warn("%s: no extra receive buffers\n", __func__);
 	return -ENOMEM;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

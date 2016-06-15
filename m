From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 11/24] xprtrdma: Reply buffer exhaustion can be
 catastrophic
Date: Tue, 14 Jun 2016 23:16:46 -0400
Message-ID: <20160615031646.14794.58266.stgit@manet.1015granger.net>
References: <20160615030626.14794.43805.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160615030626.14794.43805.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Not having an rpcrdma_rep at call_allocate time can be a problem.
It means that send_request can't post a receive buffer to catch
the RPC's reply. Possible consequences are RPC timeouts or even
transport deadlock.

Instead of allowing an RPC to proceed if an rpcrdma_rep is
not available, return NULL to force call_allocate to wait and
try again.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index b80e767f..8b8abd6 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1004,8 +1004,6 @@ rpcrdma_put_mw(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mw *mw)
 
 /*
  * Get a set of request/reply buffers.
- *
- * Reply buffer (if available) is attached to send buffer upon return.
  */
 struct rpcrdma_req *
 rpcrdma_buffer_get(struct rpcrdma_buffer *buffers)
@@ -1024,13 +1022,13 @@ rpcrdma_buffer_get(struct rpcrdma_buffer *buffers)
 
 out_reqbuf:
 	spin_unlock(&buffers->rb_lock);
-	pr_warn("RPC:       %s: out of request buffers\n", __func__);
+	pr_warn("rpcrdma: out of request buffers (%p)\n", buffers);
 	return NULL;
 out_repbuf:
+	list_add(&req->rl_free, &buffers->rb_send_bufs);
 	spin_unlock(&buffers->rb_lock);
-	pr_warn("RPC:       %s: out of reply buffers\n", __func__);
-	req->rl_reply = NULL;
-	return req;
+	pr_warn("rpcrdma: out of reply buffers (%p)\n", buffers);
+	return NULL;
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

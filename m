From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 08/16] xprtrdma: Saving IRQs no longer needed for rb_lock
Date: Fri, 16 Oct 2015 09:25:06 -0400
Message-ID: <20151016132506.6819.30436.stgit@oracle-122.nfsv4bat.org>
References: <20151016131958.6819.98407.stgit@oracle-122.nfsv4bat.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151016131958.6819.98407.stgit-SEkpj4eus7zuCzdexAEDLOpQh6Td+b7Z@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Now that RPC replies are processed in a workqueue, there's no need
to disable IRQs when managing send and receive buffers. This saves
noticeable overhead per RPC.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Tested-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index a4102fc..2dca18d 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1065,24 +1065,23 @@ struct rpcrdma_req *
 rpcrdma_buffer_get(struct rpcrdma_buffer *buffers)
 {
 	struct rpcrdma_req *req;
-	unsigned long flags;
 
-	spin_lock_irqsave(&buffers->rb_lock, flags);
+	spin_lock(&buffers->rb_lock);
 	if (list_empty(&buffers->rb_send_bufs))
 		goto out_reqbuf;
 	req = rpcrdma_buffer_get_req_locked(buffers);
 	if (list_empty(&buffers->rb_recv_bufs))
 		goto out_repbuf;
 	req->rl_reply = rpcrdma_buffer_get_rep_locked(buffers);
-	spin_unlock_irqrestore(&buffers->rb_lock, flags);
+	spin_unlock(&buffers->rb_lock);
 	return req;
 
 out_reqbuf:
-	spin_unlock_irqrestore(&buffers->rb_lock, flags);
+	spin_unlock(&buffers->rb_lock);
 	pr_warn("RPC:       %s: out of request buffers\n", __func__);
 	return NULL;
 out_repbuf:
-	spin_unlock_irqrestore(&buffers->rb_lock, flags);
+	spin_unlock(&buffers->rb_lock);
 	pr_warn("RPC:       %s: out of reply buffers\n", __func__);
 	req->rl_reply = NULL;
 	return req;
@@ -1097,16 +1096,15 @@ rpcrdma_buffer_put(struct rpcrdma_req *req)
 {
 	struct rpcrdma_buffer *buffers = req->rl_buffer;
 	struct rpcrdma_rep *rep = req->rl_reply;
-	unsigned long flags;
 
 	req->rl_niovs = 0;
 	req->rl_reply = NULL;
 
-	spin_lock_irqsave(&buffers->rb_lock, flags);
+	spin_lock(&buffers->rb_lock);
 	list_add_tail(&req->rl_free, &buffers->rb_send_bufs);
 	if (rep)
 		list_add_tail(&rep->rr_list, &buffers->rb_recv_bufs);
-	spin_unlock_irqrestore(&buffers->rb_lock, flags);
+	spin_unlock(&buffers->rb_lock);
 }
 
 /*
@@ -1117,12 +1115,11 @@ void
 rpcrdma_recv_buffer_get(struct rpcrdma_req *req)
 {
 	struct rpcrdma_buffer *buffers = req->rl_buffer;
-	unsigned long flags;
 
-	spin_lock_irqsave(&buffers->rb_lock, flags);
+	spin_lock(&buffers->rb_lock);
 	if (!list_empty(&buffers->rb_recv_bufs))
 		req->rl_reply = rpcrdma_buffer_get_rep_locked(buffers);
-	spin_unlock_irqrestore(&buffers->rb_lock, flags);
+	spin_unlock(&buffers->rb_lock);
 }
 
 /*
@@ -1133,11 +1130,10 @@ void
 rpcrdma_recv_buffer_put(struct rpcrdma_rep *rep)
 {
 	struct rpcrdma_buffer *buffers = &rep->rr_rxprt->rx_buf;
-	unsigned long flags;
 
-	spin_lock_irqsave(&buffers->rb_lock, flags);
+	spin_lock(&buffers->rb_lock);
 	list_add_tail(&rep->rr_list, &buffers->rb_recv_bufs);
-	spin_unlock_irqrestore(&buffers->rb_lock, flags);
+	spin_unlock(&buffers->rb_lock);
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

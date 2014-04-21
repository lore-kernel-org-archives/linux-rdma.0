From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 04/17] xprtrdma: RPC/RDMA must invoke
	xprt_wake_pending_tasks() in process context
Date: Mon, 21 Apr 2014 18:01:21 -0400
Message-ID: <20140421220121.12569.75378.stgit@manet.1015granger.net>
References: <20140421214442.12569.8950.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140421214442.12569.8950.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

An IB provider can invoke rpcrdma_conn_func() in an IRQ context,
thus rpcrdma_conn_func() cannot be allowed to directly invoke
generic RPC functions like xprt_wake_pending_tasks().

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 net/sunrpc/xprtrdma/rpc_rdma.c  |   22 +++++++++++++++-------
 net/sunrpc/xprtrdma/verbs.c     |    3 +++
 net/sunrpc/xprtrdma/xprt_rdma.h |    3 +++
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 400aa1b..c296468 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -676,15 +676,11 @@ rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
 	rqst->rq_private_buf = rqst->rq_rcv_buf;
 }
 
-/*
- * This function is called when an async event is posted to
- * the connection which changes the connection state. All it
- * does at this point is mark the connection up/down, the rpc
- * timers do the rest.
- */
 void
-rpcrdma_conn_func(struct rpcrdma_ep *ep)
+rpcrdma_connect_worker(struct work_struct *work)
 {
+	struct rpcrdma_ep *ep =
+		container_of(work, struct rpcrdma_ep, rep_connect_worker.work);
 	struct rpc_xprt *xprt = ep->rep_xprt;
 
 	spin_lock_bh(&xprt->transport_lock);
@@ -701,6 +697,18 @@ rpcrdma_conn_func(struct rpcrdma_ep *ep)
 }
 
 /*
+ * This function is called when an async event is posted to
+ * the connection which changes the connection state. All it
+ * does at this point is mark the connection up/down, the rpc
+ * timers do the rest.
+ */
+void
+rpcrdma_conn_func(struct rpcrdma_ep *ep)
+{
+	schedule_delayed_work(&ep->rep_connect_worker, 0);
+}
+
+/*
  * This function is called when memory window unbind which we are waiting
  * for completes. Just use rr_func (zeroed by upcall) to signal completion.
  */
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 8f9704e..9cb88f3 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -742,6 +742,7 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 	INIT_CQCOUNT(ep);
 	ep->rep_ia = ia;
 	init_waitqueue_head(&ep->rep_connect_wait);
+	INIT_DELAYED_WORK(&ep->rep_connect_worker, rpcrdma_connect_worker);
 
 	/*
 	 * Create a single cq for receive dto and mw_bind (only ever
@@ -817,6 +818,8 @@ rpcrdma_ep_destroy(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 	dprintk("RPC:       %s: entering, connected is %d\n",
 		__func__, ep->rep_connected);
 
+	cancel_delayed_work_sync(&ep->rep_connect_worker);
+
 	if (ia->ri_id->qp) {
 		rc = rpcrdma_ep_disconnect(ep, ia);
 		if (rc)
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 98340a3..c620d13 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -43,6 +43,7 @@
 #include <linux/wait.h> 		/* wait_queue_head_t, etc */
 #include <linux/spinlock.h> 		/* spinlock_t, etc */
 #include <linux/atomic.h>			/* atomic_t, etc */
+#include <linux/workqueue.h>		/* struct work_struct */
 
 #include <rdma/rdma_cm.h>		/* RDMA connection api */
 #include <rdma/ib_verbs.h>		/* RDMA verbs api */
@@ -87,6 +88,7 @@ struct rpcrdma_ep {
 	struct rpc_xprt		*rep_xprt;	/* for rep_func */
 	struct rdma_conn_param	rep_remote_cma;
 	struct sockaddr_storage	rep_remote_addr;
+	struct delayed_work	rep_connect_worker;
 };
 
 #define INIT_CQCOUNT(ep) atomic_set(&(ep)->rep_cqcount, (ep)->rep_cqinit)
@@ -336,6 +338,7 @@ int rpcrdma_deregister_external(struct rpcrdma_mr_seg *,
 /*
  * RPC/RDMA connection management calls - xprtrdma/rpc_rdma.c
  */
+void rpcrdma_connect_worker(struct work_struct *);
 void rpcrdma_conn_func(struct rpcrdma_ep *);
 void rpcrdma_reply_handler(struct rpcrdma_rep *);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/6] SUNRPC: Trace xprt_timer events
Date: Wed, 03 Jan 2018 15:38:25 -0500
Message-ID: <20180103203825.29209.3356.stgit@manet.1015granger.net>
References: <20180103203540.29209.4620.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103203540.29209.4620.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Track RPC timeouts: report the XID and the server address to match
the content of network capture.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/trace/events/sunrpc.h   |    4 ++++
 net/sunrpc/xprt.c               |    2 +-
 net/sunrpc/xprtrdma/transport.c |    2 --
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 8c153f6..7804d85 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -390,6 +390,10 @@
 			__entry->status)
 );
 
+DEFINE_EVENT(rpc_xprt_event, xprt_timer,
+	TP_PROTO(struct rpc_xprt *xprt, __be32 xid, int status),
+	TP_ARGS(xprt, xid, status));
+
 DEFINE_EVENT(rpc_xprt_event, xprt_lookup_rqst,
 	TP_PROTO(struct rpc_xprt *xprt, __be32 xid, int status),
 	TP_ARGS(xprt, xid, status));
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 33b74fd..2436fd1 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -940,8 +940,8 @@ static void xprt_timer(struct rpc_task *task)
 
 	if (task->tk_status != -ETIMEDOUT)
 		return;
-	dprintk("RPC: %5u xprt_timer\n", task->tk_pid);
 
+	trace_xprt_timer(xprt, req->rq_xid, task->tk_status);
 	if (!req->rq_reply_bytes_recvd) {
 		if (xprt->ops->timer)
 			xprt->ops->timer(xprt, task);
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index b90179a..4b1ecfe 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -516,8 +516,6 @@
 static void
 xprt_rdma_timer(struct rpc_xprt *xprt, struct rpc_task *task)
 {
-	dprintk("RPC: %5u %s: xprt = %p\n", task->tk_pid, __func__, xprt);
-
 	xprt_force_disconnect(xprt);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 5/7] sunrpc: Enable calls to rpc_call_null_helper() from
 other modules
Date: Thu, 26 Jan 2017 12:56:11 -0500
Message-ID: <20170126175611.5794.20844.stgit@manet.1015granger.net>
References: <20170126174806.5794.14678.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170126174806.5794.14678.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'd like to emit an RPC ping from rpcrdma.ko.

authnull_ops is not visible outside the sunrpc.ko module, so fold
the common case into rpc_call_null_helper, and export it.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/clnt.h |    5 +++++
 net/sunrpc/clnt.c           |   21 +++++++++++----------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 85cc819..a79237d 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -173,6 +173,11 @@ int		rpc_call_async(struct rpc_clnt *clnt,
 			       void *calldata);
 int		rpc_call_sync(struct rpc_clnt *clnt,
 			      const struct rpc_message *msg, int flags);
+struct rpc_task *rpc_call_null_helper(struct rpc_clnt *clnt,
+				      struct rpc_xprt *xprt,
+				      struct rpc_cred *cred, int flags,
+				      const struct rpc_call_ops *ops,
+				      void *data);
 struct rpc_task *rpc_call_null(struct rpc_clnt *clnt, struct rpc_cred *cred,
 			       int flags);
 int		rpc_restart_call_prepare(struct rpc_task *);
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 1efbe48..decaf97 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2520,7 +2520,6 @@ static int rpc_ping(struct rpc_clnt *clnt)
 	return err;
 }
 
-static
 struct rpc_task *rpc_call_null_helper(struct rpc_clnt *clnt,
 		struct rpc_xprt *xprt, struct rpc_cred *cred, int flags,
 		const struct rpc_call_ops *ops, void *data)
@@ -2537,9 +2536,17 @@ struct rpc_task *rpc_call_null_helper(struct rpc_clnt *clnt,
 		.callback_data = data,
 		.flags = flags,
 	};
+	struct rpc_task *task;
 
-	return rpc_run_task(&task_setup_data);
+	if (!cred)
+		msg.rpc_cred = authnull_ops.lookup_cred(NULL, NULL, 0);
+	task = rpc_run_task(&task_setup_data);
+	if (!cred)
+		put_rpccred(msg.rpc_cred);
+
+	return task;
 }
+EXPORT_SYMBOL_GPL(rpc_call_null_helper);
 
 struct rpc_task *rpc_call_null(struct rpc_clnt *clnt, struct rpc_cred *cred, int flags)
 {
@@ -2586,7 +2593,6 @@ int rpc_clnt_test_and_add_xprt(struct rpc_clnt *clnt,
 		void *dummy)
 {
 	struct rpc_cb_add_xprt_calldata *data;
-	struct rpc_cred *cred;
 	struct rpc_task *task;
 
 	data = kmalloc(sizeof(*data), GFP_NOFS);
@@ -2595,11 +2601,9 @@ int rpc_clnt_test_and_add_xprt(struct rpc_clnt *clnt,
 	data->xps = xprt_switch_get(xps);
 	data->xprt = xprt_get(xprt);
 
-	cred = authnull_ops.lookup_cred(NULL, NULL, 0);
-	task = rpc_call_null_helper(clnt, xprt, cred,
+	task = rpc_call_null_helper(clnt, xprt, NULL,
 			RPC_TASK_SOFT|RPC_TASK_SOFTCONN|RPC_TASK_ASYNC,
 			&rpc_cb_add_xprt_call_ops, data);
-	put_rpccred(cred);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	rpc_put_task(task);
@@ -2630,7 +2634,6 @@ int rpc_clnt_setup_test_and_add_xprt(struct rpc_clnt *clnt,
 				     struct rpc_xprt *xprt,
 				     void *data)
 {
-	struct rpc_cred *cred;
 	struct rpc_task *task;
 	struct rpc_add_xprt_test *xtest = (struct rpc_add_xprt_test *)data;
 	int status = -EADDRINUSE;
@@ -2642,11 +2645,9 @@ int rpc_clnt_setup_test_and_add_xprt(struct rpc_clnt *clnt,
 		goto out_err;
 
 	/* Test the connection */
-	cred = authnull_ops.lookup_cred(NULL, NULL, 0);
-	task = rpc_call_null_helper(clnt, xprt, cred,
+	task = rpc_call_null_helper(clnt, xprt, NULL,
 				    RPC_TASK_SOFT | RPC_TASK_SOFTCONN,
 				    NULL, NULL);
-	put_rpccred(cred);
 	if (IS_ERR(task)) {
 		status = PTR_ERR(task);
 		goto out_err;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

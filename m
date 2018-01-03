From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/6] SUNRPC: Micro-optimize __rpc_execute
Date: Wed, 03 Jan 2018 15:38:49 -0500
Message-ID: <20180103203849.29209.23116.stgit@manet.1015granger.net>
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

The common case: There are 13 to 14 actions per RPC, and tk_callback
is non-NULL in only one of them. There's no need to store a NULL in
the tk_callback field during each FSM step.

This slightly improves throughput results in dbench and other multi-
threaded benchmarks on my two-socket client on 56Gb InfiniBand, but
will probably be inconsequential on slower systems.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/sched.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index c292a5e..896691a 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -755,21 +755,19 @@ static void __rpc_execute(struct rpc_task *task)
 		void (*do_action)(struct rpc_task *);
 
 		/*
-		 * Execute any pending callback first.
+		 * Perform the next FSM step or a pending callback.
+		 *
+		 * tk_action may be NULL if the task has been killed.
+		 * In particular, note that rpc_killall_tasks may
+		 * do this at any time, so beware when dereferencing.
 		 */
-		do_action = task->tk_callback;
-		task->tk_callback = NULL;
-		if (do_action == NULL) {
-			/*
-			 * Perform the next FSM step.
-			 * tk_action may be NULL if the task has been killed.
-			 * In particular, note that rpc_killall_tasks may
-			 * do this at any time, so beware when dereferencing.
-			 */
-			do_action = task->tk_action;
-			if (do_action == NULL)
-				break;
+		do_action = task->tk_action;
+		if (task->tk_callback) {
+			do_action = task->tk_callback;
+			task->tk_callback = NULL;
 		}
+		if (!do_action)
+			break;
 		trace_rpc_task_run_action(task->tk_client, task, do_action);
 		do_action(task);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

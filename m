From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] SUNRPC: task_run_action should display tk_callback
Date: Wed, 03 Jan 2018 15:38:41 -0500
Message-ID: <20180103203841.29209.13773.stgit@manet.1015granger.net>
References: <20180103203540.29209.4620.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103203540.29209.4620.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This shows up in every RPC:

     kworker/4:1-19772 [004]  3467.373443: rpc_task_run_action:  task:4711@2 flags=0e81 state=0005 status=0 action=call_status
     kworker/4:1-19772 [004]  3467.373444: rpc_task_run_action:  task:4711@2 flags=0e81 state=0005 status=0 action=call_status

What's actually going on is that the first iteration of the RPC
scheduler is invoking the function in tk_callback (in this case,
xprt_timer), then invoking call_status on the next iteration.

Feeding do_action, rather than tk_action, to the "task_run_action"
trace point will now always display the correct FSM step.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index b1b49ed..c292a5e 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -770,7 +770,7 @@ static void __rpc_execute(struct rpc_task *task)
 			if (do_action == NULL)
 				break;
 		}
-		trace_rpc_task_run_action(task->tk_client, task, task->tk_action);
+		trace_rpc_task_run_action(task->tk_client, task, do_action);
 		do_action(task);
 
 		/*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

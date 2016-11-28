From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 1/2] IB/rxe: Wait for tasklets to finish before tearing down QP
Date: Mon, 28 Nov 2016 09:37:23 -0500
Message-ID: <1480343844-8381-2-git-send-email-andrew.boyer@dell.com>
References: <1480343844-8381-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480343844-8381-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The system may crash when a malformed request is received and
the error is detected by the responder.

NodeA: $ ibv_rc_pingpong -g 0 -d rxe0 -i 1 -n 1 -s 50000
NodeB: $ ibv_rc_pingpong -g 0 -d rxe0 -i 1 -n 1 -s 1024 <NodeA_ip>

The responder generates a receive error on node B since the incoming
SEND is oversized. If the client tears down the QP before the responder
or the completer finish running, a page fault may occur.

The fix makes the destroy operation spin until the tasks complete, which
appears to be original intent of the design.

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_task.c | 19 +++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_task.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
index 1e19bf8..1e9a28f 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -121,6 +121,7 @@ int rxe_init_task(void *obj, struct rxe_task *task,
 	task->arg	= arg;
 	task->func	= func;
 	snprintf(task->name, sizeof(task->name), "%s", name);
+	task->destroyed	= false;
 
 	tasklet_init(&task->tasklet, rxe_do_task, (unsigned long)task);
 
@@ -132,11 +133,29 @@ int rxe_init_task(void *obj, struct rxe_task *task,
 
 void rxe_cleanup_task(struct rxe_task *task)
 {
+	unsigned long flags;
+	bool idle = false;
+
+	/*
+	 * Mark the task, then wait for it to finish. It might be
+	 * running in a non-tasklet (direct call) context.
+	 */
+	task->destroyed = true;
+
+	do {
+		spin_lock_irqsave(&task->state_lock, flags);
+		idle = (task->state == TASK_STATE_START);
+		spin_unlock_irqrestore(&task->state_lock, flags);
+	} while (!idle);
+
 	tasklet_kill(&task->tasklet);
 }
 
 void rxe_run_task(struct rxe_task *task, int sched)
 {
+	if (task->destroyed)
+		return;
+
 	if (sched)
 		tasklet_schedule(&task->tasklet);
 	else
diff --git a/drivers/infiniband/sw/rxe/rxe_task.h b/drivers/infiniband/sw/rxe/rxe_task.h
index d14aa6d..08ff42d 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.h
+++ b/drivers/infiniband/sw/rxe/rxe_task.h
@@ -54,6 +54,7 @@ struct rxe_task {
 	int			(*func)(void *arg);
 	int			ret;
 	char			name[16];
+	bool			destroyed;
 };
 
 /*
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 14/32] IB/rxe: RXE tasks handling
Date: Tue, 22 Sep 2015 10:30:57 +0300
Message-ID: <1442907075-13228-15-git-send-email-kamalh@mellanox.com>
References: <1442907075-13228-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442907075-13228-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A 'task' is a short function that returns 0 as long as it needs to be
called again. rxe tasks are based on the kernel's tasklet infrastructure.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/rxe/rxe_task.c | 154 +++++++++++++++++++++++++++++++++++++++++
 drivers/staging/rxe/rxe_task.h |  95 +++++++++++++++++++++++++
 2 files changed, 249 insertions(+)
 create mode 100644 drivers/staging/rxe/rxe_task.c
 create mode 100644 drivers/staging/rxe/rxe_task.h

diff --git a/drivers/staging/rxe/rxe_task.c b/drivers/staging/rxe/rxe_task.c
new file mode 100644
index 0000000..162fa1a
--- /dev/null
+++ b/drivers/staging/rxe/rxe_task.c
@@ -0,0 +1,154 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/hardirq.h>
+
+#include "rxe_task.h"
+
+int __rxe_do_task(struct rxe_task *task)
+
+{
+	int ret;
+
+	while ((ret = task->func(task->arg)) == 0)
+		;
+
+	task->ret = ret;
+
+	return ret;
+}
+
+/*
+ * this locking is due to a potential race where
+ * a second caller finds the task already running
+ * but looks just after the last call to func
+ */
+void rxe_do_task(unsigned long data)
+{
+	int cont;
+	int ret;
+	unsigned long flags;
+	struct rxe_task *task = (struct rxe_task *)data;
+
+	spin_lock_irqsave(&task->state_lock, flags);
+	switch (task->state) {
+	case TASK_STATE_START:
+		task->state = TASK_STATE_BUSY;
+		spin_unlock_irqrestore(&task->state_lock, flags);
+		break;
+
+	case TASK_STATE_BUSY:
+		task->state = TASK_STATE_ARMED;
+		/* fall through to */
+	case TASK_STATE_ARMED:
+		spin_unlock_irqrestore(&task->state_lock, flags);
+		return;
+
+	default:
+		spin_unlock_irqrestore(&task->state_lock, flags);
+		pr_warn("bad state = %d in rxe_do_task\n", task->state);
+		return;
+	}
+
+	do {
+		cont = 0;
+		ret = task->func(task->arg);
+
+		spin_lock_irqsave(&task->state_lock, flags);
+		switch (task->state) {
+		case TASK_STATE_BUSY:
+			if (ret)
+				task->state = TASK_STATE_START;
+			else
+				cont = 1;
+			break;
+
+		/* soneone tried to run the task since the last time we called
+		 * func, so we will call one more time regardless of the
+		 * return value
+		 */
+		case TASK_STATE_ARMED:
+			task->state = TASK_STATE_BUSY;
+			cont = 1;
+			break;
+
+		default:
+			pr_warn("bad state = %d in rxe_do_task\n",
+				task->state);
+		}
+		spin_unlock_irqrestore(&task->state_lock, flags);
+	} while (cont);
+
+	task->ret = ret;
+}
+
+int rxe_init_task(void *obj, struct rxe_task *task,
+		  void *arg, int (*func)(void *), char *name)
+{
+	task->obj	= obj;
+	task->arg	= arg;
+	task->func	= func;
+	snprintf(task->name, sizeof(task->name), "%s", name);
+
+	tasklet_init(&task->tasklet, rxe_do_task, (unsigned long)task);
+
+	task->state = TASK_STATE_START;
+	spin_lock_init(&task->state_lock);
+
+	return 0;
+}
+
+void rxe_cleanup_task(struct rxe_task *task)
+{
+	tasklet_kill(&task->tasklet);
+}
+
+void rxe_run_task(struct rxe_task *task, int sched)
+{
+	if (sched)
+		tasklet_schedule(&task->tasklet);
+	else
+		rxe_do_task((unsigned long)task);
+}
+
+void rxe_disable_task(struct rxe_task *task)
+{
+	tasklet_disable(&task->tasklet);
+}
+
+void rxe_enable_task(struct rxe_task *task)
+{
+	tasklet_enable(&task->tasklet);
+}
diff --git a/drivers/staging/rxe/rxe_task.h b/drivers/staging/rxe/rxe_task.h
new file mode 100644
index 0000000..1183662
--- /dev/null
+++ b/drivers/staging/rxe/rxe_task.h
@@ -0,0 +1,95 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef RXE_TASK_H
+#define RXE_TASK_H
+
+enum {
+	TASK_STATE_START	= 0,
+	TASK_STATE_BUSY		= 1,
+	TASK_STATE_ARMED	= 2,
+};
+
+/*
+ * data structure to describe a 'task' which is a short
+ * function that returns 0 as long as it needs to be
+ * called again.
+ */
+struct rxe_task {
+	void			*obj;
+	struct tasklet_struct	tasklet;
+	int			state;
+	spinlock_t		state_lock; /* spinlock for task state */
+	void			*arg;
+	int			(*func)(void *arg);
+	int			ret;
+	char			name[16];
+};
+
+/*
+ * init rxe_task structure
+ *	arg  => parameter to pass to fcn
+ *	fcn  => function to call until it returns != 0
+ */
+int rxe_init_task(void *obj, struct rxe_task *task,
+		  void *arg, int (*func)(void *), char *name);
+
+/* cleanup task */
+void rxe_cleanup_task(struct rxe_task *task);
+
+/*
+ * raw call to func in loop without any checking
+ * can call when tasklets are disabled
+ */
+int __rxe_do_task(struct rxe_task *task);
+
+/*
+ * common function called by any of the main tasklets
+ * If there is any chance that there is additional
+ * work to do someone must reschedule the task before
+ * leaving
+ */
+void rxe_do_task(unsigned long data);
+
+/* run a task, else schedule it to run as a tasklet, The decision
+ * to run or schedule tasklet is based on the parameter sched.
+ * */
+void rxe_run_task(struct rxe_task *task, int sched);
+
+/* keep a task from scheduling */
+void rxe_disable_task(struct rxe_task *task);
+
+/* allow task to run */
+void rxe_enable_task(struct rxe_task *task);
+
+#endif /* RXE_TASK_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

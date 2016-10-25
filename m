From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 7/8] IB/mthca: Replace counting semaphore event_sem with wait_event
Date: Tue, 25 Oct 2016 17:31:58 +0530
Message-ID: <1477396919-27669-8-git-send-email-binoy.jayan@linaro.org>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477396919-27669-1-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Counting semaphores are going away in the future, so replace the semaphore
mthca_cmd::event_sem with a conditional wait_event.

Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_cmd.c | 37 ++++++++++++++++++++++++---------
 drivers/infiniband/hw/mthca/mthca_dev.h |  3 ++-
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 49c6e19..87c475c 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -405,6 +405,26 @@ void mthca_cmd_event(struct mthca_dev *dev,
 	complete(&context->done);
 }
 
+/* Similar to atomic_cmpxchg but with the complimentary condition. Returns
+ * index to a free node. It also sets cmd->free_head to 'new' so it ensures
+ * atomicity between a call to 'wait_event' and manipulating the free_head.
+ */
+
+static inline int atomic_free_node(struct mthca_cmd *cmd, int new)
+{
+	int orig;
+
+	spin_lock(&cmd->context_lock);
+
+	orig = cmd->free_head;
+	if (likely(cmd->free_head != -1))
+		cmd->free_head = new;
+
+	spin_unlock(&cmd->context_lock);
+
+	return orig;
+}
+
 static int mthca_cmd_wait(struct mthca_dev *dev,
 			  u64 in_param,
 			  u64 *out_param,
@@ -414,14 +434,14 @@ static int mthca_cmd_wait(struct mthca_dev *dev,
 			  u16 op,
 			  unsigned long timeout)
 {
-	int err = 0;
+	int orig_free_head, err = 0;
 	struct mthca_cmd_context *context;
 
-	down(&dev->cmd.event_sem);
+	wait_event(dev->cmd.wq,
+		  (orig_free_head = atomic_free_node(&dev->cmd, -1)) != -1);
 
 	spin_lock(&dev->cmd.context_lock);
-	BUG_ON(dev->cmd.free_head < 0);
-	context = &dev->cmd.context[dev->cmd.free_head];
+	context = &dev->cmd.context[orig_free_head];
 	context->token += dev->cmd.token_mask + 1;
 	dev->cmd.free_head = context->next;
 	spin_unlock(&dev->cmd.context_lock);
@@ -458,8 +478,8 @@ static int mthca_cmd_wait(struct mthca_dev *dev,
 	context->next = dev->cmd.free_head;
 	dev->cmd.free_head = context - dev->cmd.context;
 	spin_unlock(&dev->cmd.context_lock);
+	wake_up(&dev->cmd.wq);
 
-	up(&dev->cmd.event_sem);
 	return err;
 }
 
@@ -571,7 +591,7 @@ int mthca_cmd_use_events(struct mthca_dev *dev)
 	dev->cmd.context[dev->cmd.max_cmds - 1].next = -1;
 	dev->cmd.free_head = 0;
 
-	sema_init(&dev->cmd.event_sem, dev->cmd.max_cmds);
+	init_waitqueue_head(&dev->cmd.wq);
 	spin_lock_init(&dev->cmd.context_lock);
 
 	for (dev->cmd.token_mask = 1;
@@ -590,12 +610,9 @@ int mthca_cmd_use_events(struct mthca_dev *dev)
  */
 void mthca_cmd_use_polling(struct mthca_dev *dev)
 {
-	int i;
-
 	dev->cmd.flags &= ~MTHCA_CMD_USE_EVENTS;
 
-	for (i = 0; i < dev->cmd.max_cmds; ++i)
-		down(&dev->cmd.event_sem);
+	dev->cmd.free_head = -1;
 
 	kfree(dev->cmd.context);
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 87ab964..2fc86db 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -46,6 +46,7 @@
 #include <linux/list.h>
 #include <linux/semaphore.h>
 
+#include <rdma/ib_sa.h>
 #include "mthca_provider.h"
 #include "mthca_doorbell.h"
 
@@ -121,7 +122,7 @@ struct mthca_cmd {
 	struct pci_pool          *pool;
 	struct mutex              hcr_mutex;
 	struct mutex		  poll_mutex;
-	struct semaphore 	  event_sem;
+	wait_queue_head_t	  wq;
 	int              	  max_cmds;
 	spinlock_t                context_lock;
 	int                       free_head;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

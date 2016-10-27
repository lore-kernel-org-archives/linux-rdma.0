From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v4 07/10] IB/mthca: Replace counting semaphore event_sem with wait_event
Date: Thu, 27 Oct 2016 12:29:11 +0530
Message-ID: <1477551554-30349-8-git-send-email-binoy.jayan@linaro.org>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Counting semaphores are going away in the future, so replace the semaphore
mthca_cmd::event_sem with a conditional wait_event.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/hw/mthca/mthca_cmd.c | 47 ++++++++++++++++++++++-----------
 drivers/infiniband/hw/mthca/mthca_dev.h |  3 ++-
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 49c6e19..d6a048a 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -405,6 +405,34 @@ void mthca_cmd_event(struct mthca_dev *dev,
 	complete(&context->done);
 }
 
+static inline struct mthca_cmd_context *
+mthca_try_get_context(struct mthca_cmd *cmd)
+{
+	struct mthca_cmd_context *context = NULL;
+
+	spin_lock(&cmd->context_lock);
+
+	if (cmd->free_head < 0)
+		goto out;
+
+	context = &cmd->context[cmd->free_head];
+	context->token += cmd->token_mask + 1;
+	cmd->free_head = context->next;
+out:
+	spin_unlock(&cmd->context_lock);
+	return context;
+}
+
+/* wait for and acquire a free context */
+static inline struct mthca_cmd_context *
+mthca_get_free_context(struct mthca_cmd *cmd)
+{
+	struct mthca_cmd_context *context;
+
+	wait_event(cmd->wq, (context = mthca_try_get_context(cmd)));
+	return context;
+}
+
 static int mthca_cmd_wait(struct mthca_dev *dev,
 			  u64 in_param,
 			  u64 *out_param,
@@ -417,15 +445,7 @@ static int mthca_cmd_wait(struct mthca_dev *dev,
 	int err = 0;
 	struct mthca_cmd_context *context;
 
-	down(&dev->cmd.event_sem);
-
-	spin_lock(&dev->cmd.context_lock);
-	BUG_ON(dev->cmd.free_head < 0);
-	context = &dev->cmd.context[dev->cmd.free_head];
-	context->token += dev->cmd.token_mask + 1;
-	dev->cmd.free_head = context->next;
-	spin_unlock(&dev->cmd.context_lock);
-
+	context = mthca_get_free_context(&dev->cmd);
 	init_completion(&context->done);
 
 	err = mthca_cmd_post(dev, in_param,
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

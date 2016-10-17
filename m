From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 7/8] IB/mthca: Replace counting semaphore event_sem with wait condition
Date: Mon, 17 Oct 2016 22:01:01 +0530
Message-ID: <1476721862-7070-8-git-send-email-binoy.jayan@linaro.org>
References: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Counting semaphores are going away in the future, so replace the semaphore
mthca_cmd::event_sem with an open-coded implementation.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/hw/mthca/mthca_cmd.c | 12 ++++++++----
 drivers/infiniband/hw/mthca/mthca_dev.h |  3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 0cb58ea..5b8d5ea 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -417,7 +417,8 @@ static int mthca_cmd_wait(struct mthca_dev *dev,
 	int err = 0;
 	struct mthca_cmd_context *context;
 
-	down(&dev->cmd.event_sem);
+	wait_event(dev->cmd.event_sem.wq,
+		   atomic_add_unless(&dev->cmd.event_sem.count, -1, 0));
 
 	spin_lock(&dev->cmd.context_lock);
 	BUG_ON(dev->cmd.free_head < 0);
@@ -459,7 +460,8 @@ static int mthca_cmd_wait(struct mthca_dev *dev,
 	dev->cmd.free_head = context - dev->cmd.context;
 	spin_unlock(&dev->cmd.context_lock);
 
-	up(&dev->cmd.event_sem);
+	if (atomic_inc_return(&dev->cmd.event_sem.count) == 1)
+		wake_up(&dev->cmd.event_sem.wq);
 	return err;
 }
 
@@ -571,7 +573,8 @@ int mthca_cmd_use_events(struct mthca_dev *dev)
 	dev->cmd.context[dev->cmd.max_cmds - 1].next = -1;
 	dev->cmd.free_head = 0;
 
-	sema_init(&dev->cmd.event_sem, dev->cmd.max_cmds);
+	init_waitqueue_head(&dev->cmd.event_sem.wq);
+	atomic_set(&dev->cmd.event_sem.count, dev->cmd.max_cmds);
 	spin_lock_init(&dev->cmd.context_lock);
 
 	for (dev->cmd.token_mask = 1;
@@ -597,7 +600,8 @@ void mthca_cmd_use_polling(struct mthca_dev *dev)
 	dev->cmd.flags &= ~MTHCA_CMD_USE_EVENTS;
 
 	for (i = 0; i < dev->cmd.max_cmds; ++i)
-		down(&dev->cmd.event_sem);
+		wait_event(dev->cmd.event_sem.wq,
+			   atomic_add_unless(&dev->cmd.event_sem.count, -1, 0));
 
 	kfree(dev->cmd.context);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 87ab964..1f88835c 100644
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
+	struct ib_semaphore 	  event_sem;
 	int              	  max_cmds;
 	spinlock_t                context_lock;
 	int                       free_head;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

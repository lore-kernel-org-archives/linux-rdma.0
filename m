From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 4/8] IB/mthca: Replace semaphore poll_sem with mutex
Date: Mon, 17 Oct 2016 22:00:58 +0530
Message-ID: <1476721862-7070-5-git-send-email-binoy.jayan@linaro.org>
References: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

The semaphore 'poll_sem' is a simple mutex, so it should be written as one.
Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/hw/mthca/mthca_cmd.c | 10 +++++-----
 drivers/infiniband/hw/mthca/mthca_cmd.h |  1 +
 drivers/infiniband/hw/mthca/mthca_dev.h |  2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index c7f49bb..0cb58ea 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -347,7 +347,7 @@ static int mthca_cmd_poll(struct mthca_dev *dev,
 	unsigned long end;
 	u8 status;
 
-	down(&dev->cmd.poll_sem);
+	mutex_lock(&dev->cmd.poll_mutex);
 
 	err = mthca_cmd_post(dev, in_param,
 			     out_param ? *out_param : 0,
@@ -382,7 +382,7 @@ static int mthca_cmd_poll(struct mthca_dev *dev,
 	}
 
 out:
-	up(&dev->cmd.poll_sem);
+	mutex_unlock(&dev->cmd.poll_mutex);
 	return err;
 }
 
@@ -520,7 +520,7 @@ static int mthca_cmd_imm(struct mthca_dev *dev,
 int mthca_cmd_init(struct mthca_dev *dev)
 {
 	mutex_init(&dev->cmd.hcr_mutex);
-	sema_init(&dev->cmd.poll_sem, 1);
+	mutex_init(&dev->cmd.poll_mutex);
 	dev->cmd.flags = 0;
 
 	dev->hcr = ioremap(pci_resource_start(dev->pdev, 0) + MTHCA_HCR_BASE,
@@ -582,7 +582,7 @@ int mthca_cmd_use_events(struct mthca_dev *dev)
 
 	dev->cmd.flags |= MTHCA_CMD_USE_EVENTS;
 
-	down(&dev->cmd.poll_sem);
+	mutex_lock(&dev->cmd.poll_mutex);
 
 	return 0;
 }
@@ -601,7 +601,7 @@ void mthca_cmd_use_polling(struct mthca_dev *dev)
 
 	kfree(dev->cmd.context);
 
-	up(&dev->cmd.poll_sem);
+	mutex_unlock(&dev->cmd.poll_mutex);
 }
 
 struct mthca_mailbox *mthca_alloc_mailbox(struct mthca_dev *dev,
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.h b/drivers/infiniband/hw/mthca/mthca_cmd.h
index d2e5b19..a7f197e 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.h
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.h
@@ -35,6 +35,7 @@
 #ifndef MTHCA_CMD_H
 #define MTHCA_CMD_H
 
+#include <linux/mutex.h>
 #include <rdma/ib_verbs.h>
 
 #define MTHCA_MAILBOX_SIZE 4096
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 4393a02..87ab964 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -120,7 +120,7 @@ enum {
 struct mthca_cmd {
 	struct pci_pool          *pool;
 	struct mutex              hcr_mutex;
-	struct semaphore 	  poll_sem;
+	struct mutex		  poll_mutex;
 	struct semaphore 	  event_sem;
 	int              	  max_cmds;
 	spinlock_t                context_lock;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

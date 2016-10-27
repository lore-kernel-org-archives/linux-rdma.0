From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 04/10] IB/mthca: Replace semaphore poll_sem with mutex
Date: Thu, 27 Oct 2016 12:29:08 +0530
Message-ID: <1477551554-30349-5-git-send-email-binoy.jayan@linaro.org>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477551554-30349-1-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The semaphore 'poll_sem' is a simple mutex, so it should be written as one.
Semaphores are going away in the future. So replace it with a mutex. Also,
remove mutex_[un]lock from mthca_cmd_use_events and mthca_cmd_use_polling
respectively.

Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_cmd.c | 10 +++-------
 drivers/infiniband/hw/mthca/mthca_cmd.h |  1 +
 drivers/infiniband/hw/mthca/mthca_dev.h |  2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index c7f49bb..49c6e19 100644
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
@@ -582,8 +582,6 @@ int mthca_cmd_use_events(struct mthca_dev *dev)
 
 	dev->cmd.flags |= MTHCA_CMD_USE_EVENTS;
 
-	down(&dev->cmd.poll_sem);
-
 	return 0;
 }
 
@@ -600,8 +598,6 @@ void mthca_cmd_use_polling(struct mthca_dev *dev)
 		down(&dev->cmd.event_sem);
 
 	kfree(dev->cmd.context);
-
-	up(&dev->cmd.poll_sem);
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

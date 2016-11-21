From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v5 4/9] IB/mthca: Replace semaphore poll_sem with mutex
Date: Mon, 21 Nov 2016 11:38:11 +0530
Message-ID: <1479708496-9828-5-git-send-email-binoy.jayan@linaro.org>
References: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Jenny Derzhavetz <jennyf@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Steve Wise <swise@opengridcomputing.com>, Mark Bloch <markb@mellanox.com>, Tatyana E Nikolova <tatyana.e.nikolova@intel.com>, Matan Barak <matanb@mellanox.com>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

The semaphore 'poll_sem' is a simple mutex, so it should be written as one.
Semaphores are going away in the future. So replace it with a mutex. Also,
remove mutex_[un]lock from mthca_cmd_use_events and mthca_cmd_use_polling
respectively.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
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

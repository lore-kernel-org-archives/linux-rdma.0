From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v3 3/9] IB/hns: Replace semaphore poll_sem with mutex
Date: Wed, 26 Oct 2016 13:31:08 +0530
Message-ID: <1477468874-16328-4-git-send-email-binoy.jayan@linaro.org>
References: <1477468874-16328-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477468874-16328-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

The semaphore 'poll_sem' is a simple mutex, so it should be written as one.
Semaphores are going away in the future. So replace the semaphore 'poll_sem'
with a mutex. Also, remove mutex_[un]lock from mthca_cmd_use_events and
mthca_cmd_use_polling respectively.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.c    | 11 ++++-------
 drivers/infiniband/hw/hns/hns_roce_device.h |  3 ++-
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
index 2a0b6c0..51a0675 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
@@ -119,7 +119,7 @@ static int hns_roce_cmd_mbox_post_hw(struct hns_roce_dev *hr_dev, u64 in_param,
 	return ret;
 }
 
-/* this should be called with "poll_sem" */
+/* this should be called with "poll_mutex" */
 static int __hns_roce_cmd_mbox_poll(struct hns_roce_dev *hr_dev, u64 in_param,
 				    u64 out_param, unsigned long in_modifier,
 				    u8 op_modifier, u16 op,
@@ -167,10 +167,10 @@ static int hns_roce_cmd_mbox_poll(struct hns_roce_dev *hr_dev, u64 in_param,
 {
 	int ret;
 
-	down(&hr_dev->cmd.poll_sem);
+	mutex_lock(&hr_dev->cmd.poll_mutex);
 	ret = __hns_roce_cmd_mbox_poll(hr_dev, in_param, out_param, in_modifier,
 				       op_modifier, op, timeout);
-	up(&hr_dev->cmd.poll_sem);
+	mutex_unlock(&hr_dev->cmd.poll_mutex);
 
 	return ret;
 }
@@ -275,7 +275,7 @@ int hns_roce_cmd_init(struct hns_roce_dev *hr_dev)
 	struct device *dev = &hr_dev->pdev->dev;
 
 	mutex_init(&hr_dev->cmd.hcr_mutex);
-	sema_init(&hr_dev->cmd.poll_sem, 1);
+	mutex_init(&hr_dev->cmd.poll_mutex);
 	hr_dev->cmd.use_events = 0;
 	hr_dev->cmd.toggle = 1;
 	hr_dev->cmd.max_cmds = CMD_MAX_NUM;
@@ -319,8 +319,6 @@ int hns_roce_cmd_use_events(struct hns_roce_dev *hr_dev)
 	hr_cmd->token_mask = CMD_TOKEN_MASK;
 	hr_cmd->use_events = 1;
 
-	down(&hr_cmd->poll_sem);
-
 	return 0;
 }
 
@@ -335,7 +333,6 @@ void hns_roce_cmd_use_polling(struct hns_roce_dev *hr_dev)
 		down(&hr_cmd->event_sem);
 
 	kfree(hr_cmd->context);
-	up(&hr_cmd->poll_sem);
 }
 
 struct hns_roce_cmd_mailbox
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 3417315..2afe075 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -34,6 +34,7 @@
 #define _HNS_ROCE_DEVICE_H
 
 #include <rdma/ib_verbs.h>
+#include <linux/mutex.h>
 
 #define DRV_NAME "hns_roce"
 
@@ -358,7 +359,7 @@ struct hns_roce_cmdq {
 	struct dma_pool		*pool;
 	u8 __iomem		*hcr;
 	struct mutex		hcr_mutex;
-	struct semaphore	poll_sem;
+	struct mutex		poll_mutex;
 	/*
 	* Event mode: cmd register mutex protection,
 	* ensure to not exceed max_cmds and user use limit region
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

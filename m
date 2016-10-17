From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 6/8] IB/hns: Replace counting semaphore event_sem with wait condition
Date: Mon, 17 Oct 2016 22:01:00 +0530
Message-ID: <1476721862-7070-7-git-send-email-binoy.jayan@linaro.org>
References: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Counting semaphores are going away in the future, so replace the semaphore
hns_roce_cmdq::event_sem with an open-coded implementation.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.c    | 16 ++++++++++++----
 drivers/infiniband/hw/hns/hns_roce_device.h |  3 ++-
 include/rdma/ib_sa.h                        |  5 +++++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
index 1421fdb..3e76717 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
@@ -248,10 +248,14 @@ static int hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
 {
 	int ret = 0;
 
-	down(&hr_dev->cmd.event_sem);
+	wait_event(hr_dev->cmd.event_sem.wq,
+		   atomic_add_unless(&hr_dev->cmd.event_sem.count, -1, 0));
+
 	ret = __hns_roce_cmd_mbox_wait(hr_dev, in_param, out_param,
 				       in_modifier, op_modifier, op, timeout);
-	up(&hr_dev->cmd.event_sem);
+
+	if (atomic_inc_return(&hr_dev->cmd.event_sem.count) == 1)
+		wake_up(&hr_dev->cmd.event_sem.wq);
 
 	return ret;
 }
@@ -313,7 +317,9 @@ int hns_roce_cmd_use_events(struct hns_roce_dev *hr_dev)
 	hr_cmd->context[hr_cmd->max_cmds - 1].next = -1;
 	hr_cmd->free_head = 0;
 
-	sema_init(&hr_cmd->event_sem, hr_cmd->max_cmds);
+	init_waitqueue_head(&hr_cmd->event_sem.wq);
+	atomic_set(&hr_cmd->event_sem.count, hr_cmd->max_cmds);
+
 	spin_lock_init(&hr_cmd->context_lock);
 
 	hr_cmd->token_mask = CMD_TOKEN_MASK;
@@ -332,7 +338,9 @@ void hns_roce_cmd_use_polling(struct hns_roce_dev *hr_dev)
 	hr_cmd->use_events = 0;
 
 	for (i = 0; i < hr_cmd->max_cmds; ++i)
-		down(&hr_cmd->event_sem);
+		wait_event(hr_cmd->event_sem.wq,
+			   atomic_add_unless(
+			   &hr_dev->cmd.event_sem.count, -1, 0));
 
 	kfree(hr_cmd->context);
 	mutex_unlock(&hr_cmd->poll_mutex);
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 2afe075..6aed04a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -34,6 +34,7 @@
 #define _HNS_ROCE_DEVICE_H
 
 #include <rdma/ib_verbs.h>
+#include <rdma/ib_sa.h>
 #include <linux/mutex.h>
 
 #define DRV_NAME "hns_roce"
@@ -364,7 +365,7 @@ struct hns_roce_cmdq {
 	* Event mode: cmd register mutex protection,
 	* ensure to not exceed max_cmds and user use limit region
 	*/
-	struct semaphore	event_sem;
+	struct ib_semaphore	event_sem;
 	int			max_cmds;
 	spinlock_t		context_lock;
 	int			free_head;
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 5ee7aab..1901042 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -291,6 +291,11 @@ struct ib_sa_service_rec {
 #define IB_SA_GUIDINFO_REC_GID6		IB_SA_COMP_MASK(10)
 #define IB_SA_GUIDINFO_REC_GID7		IB_SA_COMP_MASK(11)
 
+struct ib_semaphore {
+	wait_queue_head_t wq;
+	atomic_t count;
+};
+
 struct ib_sa_guidinfo_rec {
 	__be16	lid;
 	u8	block_num;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

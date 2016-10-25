From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v2 6/8] IB/hns: Replace counting semaphore event_sem with wait_event
Date: Tue, 25 Oct 2016 17:31:57 +0530
Message-ID: <1477396919-27669-7-git-send-email-binoy.jayan@linaro.org>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Counting semaphores are going away in the future, so replace the semaphore
mthca_cmd::event_sem with a conditional wait_event.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.c    | 37 +++++++++++++++++++++--------
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 +-
 2 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
index 51a0675..efc5c48 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
@@ -189,6 +189,26 @@ void hns_roce_cmd_event(struct hns_roce_dev *hr_dev, u16 token, u8 status,
 	complete(&context->done);
 }
 
+/* Similar to atomic_cmpxchg but with the complimentary condition. Returns
+ * index to a free node. It also sets cmd->free_head to 'new' so it ensures
+ * atomicity between a call to 'wait_event' and manipulating the free_head.
+ */
+
+static inline int atomic_free_node(struct hns_roce_cmdq *cmd, int new)
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
 /* this should be called with "use_events" */
 static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
 				    u64 out_param, unsigned long in_modifier,
@@ -198,11 +218,12 @@ static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
 	struct hns_roce_cmdq *cmd = &hr_dev->cmd;
 	struct device *dev = &hr_dev->pdev->dev;
 	struct hns_roce_cmd_context *context;
-	int ret = 0;
+	int orig_free_head, ret = 0;
+
+	wait_event(cmd->wq, (orig_free_head = atomic_free_node(cmd, -1)) != -1);
 
 	spin_lock(&cmd->context_lock);
-	WARN_ON(cmd->free_head < 0);
-	context = &cmd->context[cmd->free_head];
+	context = &cmd->context[orig_free_head];
 	context->token += cmd->token_mask + 1;
 	cmd->free_head = context->next;
 	spin_unlock(&cmd->context_lock);
@@ -238,6 +259,7 @@ static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
 	context->next = cmd->free_head;
 	cmd->free_head = context - cmd->context;
 	spin_unlock(&cmd->context_lock);
+	wake_up(&cmd->wq);
 
 	return ret;
 }
@@ -248,10 +270,8 @@ static int hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
 {
 	int ret = 0;
 
-	down(&hr_dev->cmd.event_sem);
 	ret = __hns_roce_cmd_mbox_wait(hr_dev, in_param, out_param,
 				       in_modifier, op_modifier, op, timeout);
-	up(&hr_dev->cmd.event_sem);
 
 	return ret;
 }
@@ -313,7 +333,7 @@ int hns_roce_cmd_use_events(struct hns_roce_dev *hr_dev)
 	hr_cmd->context[hr_cmd->max_cmds - 1].next = -1;
 	hr_cmd->free_head = 0;
 
-	sema_init(&hr_cmd->event_sem, hr_cmd->max_cmds);
+	init_waitqueue_head(&hr_cmd->wq);
 	spin_lock_init(&hr_cmd->context_lock);
 
 	hr_cmd->token_mask = CMD_TOKEN_MASK;
@@ -325,12 +345,9 @@ int hns_roce_cmd_use_events(struct hns_roce_dev *hr_dev)
 void hns_roce_cmd_use_polling(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_cmdq *hr_cmd = &hr_dev->cmd;
-	int i;
 
 	hr_cmd->use_events = 0;
-
-	for (i = 0; i < hr_cmd->max_cmds; ++i)
-		down(&hr_cmd->event_sem);
+	hr_cmd->free_head = -1;
 
 	kfree(hr_cmd->context);
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 2afe075..ac95f52 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -364,7 +364,7 @@ struct hns_roce_cmdq {
 	* Event mode: cmd register mutex protection,
 	* ensure to not exceed max_cmds and user use limit region
 	*/
-	struct semaphore	event_sem;
+	wait_queue_head_t       wq;
 	int			max_cmds;
 	spinlock_t		context_lock;
 	int			free_head;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

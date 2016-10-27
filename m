From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v4 06/10] IB/hns: Replace counting semaphore event_sem with wait_event
Date: Thu, 27 Oct 2016 12:29:10 +0530
Message-ID: <1477551554-30349-7-git-send-email-binoy.jayan@linaro.org>
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
 drivers/infiniband/hw/hns/hns_roce_cmd.c    | 46 ++++++++++++++++++++---------
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 +-
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
index 51a0675..12ef3d8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
@@ -189,6 +189,34 @@ void hns_roce_cmd_event(struct hns_roce_dev *hr_dev, u16 token, u8 status,
 	complete(&context->done);
 }
 
+static inline struct hns_roce_cmd_context *
+hns_roce_try_get_context(struct hns_roce_cmdq *cmd)
+{
+	struct hns_roce_cmd_context *context = NULL;
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
+static inline struct hns_roce_cmd_context *
+hns_roce_get_free_context(struct hns_roce_cmdq *cmd)
+{
+	struct hns_roce_cmd_context *context;
+
+	wait_event(cmd->wq, (context = hns_roce_try_get_context(cmd)));
+	return context;
+}
+
 /* this should be called with "use_events" */
 static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
 				    u64 out_param, unsigned long in_modifier,
@@ -200,13 +228,7 @@ static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
 	struct hns_roce_cmd_context *context;
 	int ret = 0;
 
-	spin_lock(&cmd->context_lock);
-	WARN_ON(cmd->free_head < 0);
-	context = &cmd->context[cmd->free_head];
-	context->token += cmd->token_mask + 1;
-	cmd->free_head = context->next;
-	spin_unlock(&cmd->context_lock);
-
+	context = hns_roce_get_free_context(cmd);
 	init_completion(&context->done);
 
 	ret = hns_roce_cmd_mbox_post_hw(hr_dev, in_param, out_param,
@@ -238,6 +260,7 @@ static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
 	context->next = cmd->free_head;
 	cmd->free_head = context - cmd->context;
 	spin_unlock(&cmd->context_lock);
+	wake_up(&cmd->wq);
 
 	return ret;
 }
@@ -248,10 +271,8 @@ static int hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
 {
 	int ret = 0;
 
-	down(&hr_dev->cmd.event_sem);
 	ret = __hns_roce_cmd_mbox_wait(hr_dev, in_param, out_param,
 				       in_modifier, op_modifier, op, timeout);
-	up(&hr_dev->cmd.event_sem);
 
 	return ret;
 }
@@ -313,7 +334,7 @@ int hns_roce_cmd_use_events(struct hns_roce_dev *hr_dev)
 	hr_cmd->context[hr_cmd->max_cmds - 1].next = -1;
 	hr_cmd->free_head = 0;
 
-	sema_init(&hr_cmd->event_sem, hr_cmd->max_cmds);
+	init_waitqueue_head(&hr_cmd->wq);
 	spin_lock_init(&hr_cmd->context_lock);
 
 	hr_cmd->token_mask = CMD_TOKEN_MASK;
@@ -325,12 +346,9 @@ int hns_roce_cmd_use_events(struct hns_roce_dev *hr_dev)
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

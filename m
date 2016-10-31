From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: Fix unknown fabric callback queue-full errors
Date: Mon, 31 Oct 2016 05:25:52 +0000
Message-ID: <1477891554-26222-2-git-send-email-nab@linux-iscsi.org>
References: <1477891554-26222-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1477891554-26222-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>, Steve Wise <swise@opengridcomputing.com>, Sagi Grimberg <sagi@grimberg.me>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a set of queue-full response handling
bugs, where outgoing responses are leaked when a fabric
driver is propagating non -EAGAIN or -ENOMEM errors
to target-core.

It introduces TRANSPORT_COMPLETE_QF_ERR state used to
signal when CHECK_CONDITION status should be generated,
when fabric driver ->write_pending(), ->queue_data_in(),
or ->queue_status() callbacks fail with non -EAGAIN or
-ENOMEM errors, and data-transfer should not be retried.

Note all fabric driver -EAGAIN and -ENOMEM errors are
still retried indefinately with associated data-transfer
callbacks, following existing queue-full logic.

Also fix two missing ->queue_status() queue-full cases
related to CMD_T_ABORTED w/ TAS status handling.

Reported-by: Potnuri Bharat Teja <bharat@chelsio.com>
Cc: Potnuri Bharat Teja <bharat@chelsio.com>
Reported-by: Steve Wise <swise@opengridcomputing.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 102 ++++++++++++++++++++++-----------
 include/target/target_core_base.h      |   1 +
 2 files changed, 69 insertions(+), 34 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7dfefd6..489aa95 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -64,8 +64,9 @@
 struct kmem_cache *t10_alua_lba_map_mem_cache;
 
 static void transport_complete_task_attr(struct se_cmd *cmd);
+static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason);
 static void transport_handle_queue_full(struct se_cmd *cmd,
-		struct se_device *dev);
+		struct se_device *dev, int err, bool write_pending);
 static int transport_put_cmd(struct se_cmd *cmd);
 static void target_complete_ok_work(struct work_struct *work);
 
@@ -811,7 +812,8 @@ void target_qf_do_work(struct work_struct *work)
 
 		if (cmd->t_state == TRANSPORT_COMPLETE_QF_WP)
 			transport_write_pending_qf(cmd);
-		else if (cmd->t_state == TRANSPORT_COMPLETE_QF_OK)
+		else if (cmd->t_state == TRANSPORT_COMPLETE_QF_OK ||
+			 cmd->t_state == TRANSPORT_COMPLETE_QF_ERR)
 			transport_complete_qf(cmd);
 	}
 }
@@ -1720,7 +1722,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		}
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret == -EAGAIN || ret == -ENOMEM)
+		if (ret)
 			goto queue_full;
 		goto check_stop;
 	default:
@@ -1731,7 +1733,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	}
 
 	ret = transport_send_check_condition_and_sense(cmd, sense_reason, 0);
-	if (ret == -EAGAIN || ret == -ENOMEM)
+	if (ret)
 		goto queue_full;
 
 check_stop:
@@ -1740,8 +1742,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	return;
 
 queue_full:
-	cmd->t_state = TRANSPORT_COMPLETE_QF_OK;
-	transport_handle_queue_full(cmd, cmd->se_dev);
+	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
 EXPORT_SYMBOL(transport_generic_request_failure);
 
@@ -1980,13 +1981,29 @@ static void transport_complete_qf(struct se_cmd *cmd)
 	int ret = 0;
 
 	transport_complete_task_attr(cmd);
+	/*
+	 * If a fabric driver ->write_pending() or ->queue_data_in() callback
+	 * has returned neither -ENOMEM or -EAGAIN, assume it's fatal and
+	 * the same callbacks should not be retried.  Return CHECK_CONDITION
+	 * if a scsi_status is not already set.
+	 *
+	 * If a fabric driver ->queue_status() has returned non zero, always
+	 * keep retrying no matter what..
+	 */
+	if (cmd->t_state == TRANSPORT_COMPLETE_QF_ERR) {
+		if (cmd->scsi_status)
+			goto queue_status;
 
-	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
-		trace_target_cmd_complete(cmd);
-		ret = cmd->se_tfo->queue_status(cmd);
-		goto out;
+		cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
+		cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
+		cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
+		translate_sense_reason(cmd, TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+		goto queue_status;
 	}
 
+	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
+		goto queue_status;
+
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
 		if (cmd->scsi_status)
@@ -2010,19 +2027,33 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		break;
 	}
 
-out:
 	if (ret < 0) {
-		transport_handle_queue_full(cmd, cmd->se_dev);
+		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 		return;
 	}
 	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
-static void transport_handle_queue_full(
-	struct se_cmd *cmd,
-	struct se_device *dev)
+static void transport_handle_queue_full(struct se_cmd *cmd, struct se_device *dev,
+					int err, bool write_pending)
 {
+	/*
+	 * -EAGAIN or -ENOMEM signals retry of ->write_pending() and/or
+	 * ->queue_data_in() callbacks from new process context.
+	 *
+	 * Otherwise for other errors, transport_complete_qf() will send
+	 * CHECK_CONDITION via ->queue_status() instead of attempting to
+	 * retry associated fabric driver data-transfer callbacks.
+	 */
+	if (err == -EAGAIN || err == -ENOMEM) {
+		cmd->t_state = (write_pending) ? TRANSPORT_COMPLETE_QF_WP :
+						 TRANSPORT_COMPLETE_QF_OK;
+	} else {
+		pr_warn_ratelimited("Got unknown fabric queue status: %d\n", err);
+		cmd->t_state = TRANSPORT_COMPLETE_QF_ERR;
+	}
+
 	spin_lock_irq(&dev->qf_cmd_lock);
 	list_add_tail(&cmd->se_qf_node, &cmd->se_dev->qf_cmd_list);
 	atomic_inc_mb(&dev->dev_qf_count);
@@ -2086,7 +2117,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		WARN_ON(!cmd->scsi_status);
 		ret = transport_send_check_condition_and_sense(
 					cmd, 0, 1);
-		if (ret == -EAGAIN || ret == -ENOMEM)
+		if (ret)
 			goto queue_full;
 
 		transport_lun_remove_cmd(cmd);
@@ -2112,7 +2143,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		} else if (rc) {
 			ret = transport_send_check_condition_and_sense(cmd,
 						rc, 0);
-			if (ret == -EAGAIN || ret == -ENOMEM)
+			if (ret)
 				goto queue_full;
 
 			transport_lun_remove_cmd(cmd);
@@ -2137,7 +2168,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		if (target_read_prot_action(cmd)) {
 			ret = transport_send_check_condition_and_sense(cmd,
 						cmd->pi_err, 0);
-			if (ret == -EAGAIN || ret == -ENOMEM)
+			if (ret)
 				goto queue_full;
 
 			transport_lun_remove_cmd(cmd);
@@ -2147,7 +2178,7 @@ static void target_complete_ok_work(struct work_struct *work)
 
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_data_in(cmd);
-		if (ret == -EAGAIN || ret == -ENOMEM)
+		if (ret)
 			goto queue_full;
 		break;
 	case DMA_TO_DEVICE:
@@ -2160,7 +2191,7 @@ static void target_complete_ok_work(struct work_struct *work)
 			atomic_long_add(cmd->data_length,
 					&cmd->se_lun->lun_stats.tx_data_octets);
 			ret = cmd->se_tfo->queue_data_in(cmd);
-			if (ret == -EAGAIN || ret == -ENOMEM)
+			if (ret)
 				goto queue_full;
 			break;
 		}
@@ -2169,7 +2200,7 @@ static void target_complete_ok_work(struct work_struct *work)
 queue_status:
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret == -EAGAIN || ret == -ENOMEM)
+		if (ret)
 			goto queue_full;
 		break;
 	default:
@@ -2183,8 +2214,8 @@ static void target_complete_ok_work(struct work_struct *work)
 queue_full:
 	pr_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p,"
 		" data_direction: %d\n", cmd, cmd->data_direction);
-	cmd->t_state = TRANSPORT_COMPLETE_QF_OK;
-	transport_handle_queue_full(cmd, cmd->se_dev);
+
+	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
 
 void target_free_sgl(struct scatterlist *sgl, int nents)
@@ -2434,18 +2465,14 @@ void transport_kunmap_data_sg(struct se_cmd *cmd)
 	transport_cmd_check_stop(cmd, false, true);
 
 	ret = cmd->se_tfo->write_pending(cmd);
-	if (ret == -EAGAIN || ret == -ENOMEM)
+	if (ret)
 		goto queue_full;
 
-	/* fabric drivers should only return -EAGAIN or -ENOMEM as error */
-	WARN_ON(ret);
-
-	return (!ret) ? 0 : TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	return 0;
 
 queue_full:
 	pr_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
-	cmd->t_state = TRANSPORT_COMPLETE_QF_WP;
-	transport_handle_queue_full(cmd, cmd->se_dev);
+	transport_handle_queue_full(cmd, cmd->se_dev, ret, true);
 	return 0;
 }
 EXPORT_SYMBOL(transport_generic_new_cmd);
@@ -2455,10 +2482,10 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 	int ret;
 
 	ret = cmd->se_tfo->write_pending(cmd);
-	if (ret == -EAGAIN || ret == -ENOMEM) {
+	if (ret) {
 		pr_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n",
 			 cmd);
-		transport_handle_queue_full(cmd, cmd->se_dev);
+		transport_handle_queue_full(cmd, cmd->se_dev, ret, true);
 	}
 }
 
@@ -2951,6 +2978,8 @@ static int __transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 	__releases(&cmd->t_state_lock)
 	__acquires(&cmd->t_state_lock)
 {
+	int ret;
+
 	assert_spin_locked(&cmd->t_state_lock);
 	WARN_ON_ONCE(!irqs_disabled());
 
@@ -2974,7 +3003,9 @@ static int __transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 	trace_target_cmd_complete(cmd);
 
 	spin_unlock_irq(&cmd->t_state_lock);
-	cmd->se_tfo->queue_status(cmd);
+	ret = cmd->se_tfo->queue_status(cmd);
+	if (ret)
+		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 	spin_lock_irq(&cmd->t_state_lock);
 
 	return 1;
@@ -2995,6 +3026,7 @@ int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 void transport_send_task_abort(struct se_cmd *cmd)
 {
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->se_cmd_flags & (SCF_SENT_CHECK_CONDITION)) {
@@ -3030,7 +3062,9 @@ void transport_send_task_abort(struct se_cmd *cmd)
 		 cmd->t_task_cdb[0], cmd->tag);
 
 	trace_target_cmd_complete(cmd);
-	cmd->se_tfo->queue_status(cmd);
+	ret = cmd->se_tfo->queue_status(cmd);
+	if (ret)
+		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
 
 static void target_tmr_work(struct work_struct *work)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c211900..6a5e439 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -119,6 +119,7 @@ enum transport_state_table {
 	TRANSPORT_ISTATE_PROCESSING = 11,
 	TRANSPORT_COMPLETE_QF_WP = 18,
 	TRANSPORT_COMPLETE_QF_OK = 19,
+	TRANSPORT_COMPLETE_QF_ERR = 20,
 };
 
 /* Used for struct se_cmd->se_cmd_flags */
-- 
1.9.1

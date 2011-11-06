From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] ib_srpt: Fix Last WQE handling
Date: Sun, 6 Nov 2011 18:31:17 +0100
Message-ID: <201111061831.17756.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make sure that the last WQE event is handled properly if it arrives
before the QP has been transitioned into the error state. Rearrange
the thread that processes IB completions such that the per-channel
wait queue can be eliminated. Remove the printk() statements that
announce the start and stop of the completion processing thread.

This patch has been generated against the LIO tree of a few weeks
ago.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   48 +++++++++++++++------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    8 ++---
 2 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b3947fe..8fe7623 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -260,12 +260,10 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 		ib_cm_notify(ch->cm_id, event->event);
 		break;
 	case IB_EVENT_QP_LAST_WQE_REACHED:
-		if (srpt_test_and_set_ch_state(ch, CH_DRAINING,
-					       CH_RELEASING))
-			srpt_release_channel(ch);
-		else
-			pr_debug("%s: state %d - ignored LAST_WQE.\n",
-				 ch->sess_name, srpt_get_ch_state(ch));
+		pr_debug("%s; state %d: received LAST WQE event.\n",
+			 ch->sess_name, srpt_get_ch_state(ch));
+		ch->last_wqe_received = true;
+		wake_up_process(ch->thread);
 		break;
 	default:
 		printk(KERN_ERR "received unrecognized IB QP event %d\n",
@@ -2119,7 +2117,7 @@ static void srpt_completion(struct ib_cq *cq, void *ctx)
 {
 	struct srpt_rdma_ch *ch = ctx;
 
-	wake_up_interruptible(&ch->wait_queue);
+	wake_up_process(ch->thread);
 }
 
 static int srpt_compl_thread(void *arg)
@@ -2131,15 +2129,23 @@ static int srpt_compl_thread(void *arg)
 
 	ch = arg;
 	BUG_ON(!ch);
-	printk(KERN_INFO "Session %s: kernel thread %s (PID %d) started\n",
-	       ch->sess_name, ch->thread->comm, current->pid);
+
+	while (!kthread_should_stop() && !ch->last_wqe_received) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		srpt_process_completion(ch->cq, ch);
+		schedule();
+	}
+
+	set_current_state(TASK_RUNNING);
+	srpt_process_completion(ch->cq, ch);
+	srpt_release_channel(ch);
+
 	while (!kthread_should_stop()) {
-		wait_event_interruptible(ch->wait_queue,
-			(srpt_process_completion(ch->cq, ch),
-			 kthread_should_stop()));
+		set_current_state(TASK_INTERRUPTIBLE);
+		srpt_process_completion(ch->cq, ch);
+		schedule();
 	}
-	printk(KERN_INFO "Session %s: kernel thread %s (PID %d) stopped\n",
-	       ch->sess_name, ch->thread->comm, current->pid);
+
 	return 0;
 }
 
@@ -2196,8 +2202,6 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (ret)
 		goto err_destroy_qp;
 
-	init_waitqueue_head(&ch->wait_queue);
-
 	pr_debug("creating thread for session %s\n", ch->sess_name);
 
 	ch->thread = kthread_run(srpt_compl_thread, ch, "ib_srpt_compl");
@@ -2268,7 +2272,6 @@ static void __srpt_close_ch(struct srpt_rdma_ch *ch)
 	case CH_DISCONNECTING:
 		break;
 	case CH_DRAINING:
-	case CH_RELEASING:
 		break;
 	}
 }
@@ -2360,12 +2363,7 @@ static struct srpt_rdma_ch *srpt_find_channel(struct srpt_device *sdev,
 }
 
 /**
- * srpt_release_channel() - Release channel resources.
- *
- * Schedules the actual release because:
- * - Calling the ib_destroy_cm_id() call from inside an IB CM callback would
- *   trigger a deadlock.
- * - It is not safe to call TCM transport_* functions from interrupt context.
+ * srpt_release_channel() - Schedule releasing channel resources.
  */
 static void srpt_release_channel(struct srpt_rdma_ch *ch)
 {
@@ -2689,7 +2687,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	goto out;
 
 release_channel:
-	srpt_set_ch_state(ch, CH_RELEASING);
+	srpt_set_ch_state(ch, CH_DRAINING);
 	transport_deregister_session_configfs(ch->sess);
 
 deregister_session:
@@ -2794,7 +2792,6 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
 		break;
 	case CH_DISCONNECTING:
 	case CH_DRAINING:
-	case CH_RELEASING:
 		__WARN();
 		break;
 	}
@@ -3006,7 +3003,6 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 		break;
 	case CH_DISCONNECTING:
 	case CH_DRAINING:
-	case CH_RELEASING:
 		pr_debug("cmd with tag %lld: channel disconnecting\n",
 			 ioctx->tag);
 		srpt_set_cmd_state(ioctx, SRPT_STATE_DATA_IN);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 045fb7b..e1b444b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -237,20 +237,17 @@ struct srpt_send_ioctx {
  * @CH_DISCONNECTING:    DREQ has been received; waiting for DREP
  *                       or DREQ has been send and waiting for DREP
  *                       or .
- * @CH_DRAINING:	 QP is in ERR state; waiting for last WQE event.
- * @CH_RELEASING:	 Last WQE event has been received; releasing resources.
+ * @CH_DRAINING:	 QP is in ERR state.
  */
 enum rdma_ch_state {
 	CH_CONNECTING,
 	CH_LIVE,
 	CH_DISCONNECTING,
 	CH_DRAINING,
-	CH_RELEASING
 };
 
 /**
  * struct srpt_rdma_ch - RDMA channel.
- * @wait_queue:    Allows the kernel thread to wait for more work.
  * @thread:        Kernel thread that processes the IB queues associated with
  *                 the channel.
  * @cm_id:         IB CM ID associated with the channel.
@@ -278,10 +275,10 @@ enum rdma_ch_state {
  * @sess:          Session information associated with this SRP channel.
  * @sess_name:     Session name.
  * @release_work:  Allows scheduling of srpt_release_channel().
+ * @last_wqe_received: Whether the Last WQE event has already been received.
  * @release_done:  Enables waiting for srpt_release_channel() completion.
  */
 struct srpt_rdma_ch {
-	wait_queue_head_t	wait_queue;
 	struct task_struct	*thread;
 	struct ib_cm_id		*cm_id;
 	struct ib_qp		*qp;
@@ -304,6 +301,7 @@ struct srpt_rdma_ch {
 	struct se_session	*sess;
 	u8			sess_name[36];
 	struct work_struct	release_work;
+	bool			last_wqe_received;
 	struct completion	*release_done;
 };
 
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 7/7] ib_srpt: Fix session unregistration races
Date: Sun, 9 Jan 2011 17:28:58 +0100
Message-ID: <201101091728.58910.bvanassche@acm.org>
References: <201101091723.41399.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201101091723.41399.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the following race conditions related to session unregistration:
- If the memory subsystem does reorder the atomic accesses to the
  variables ch->state and ch->processing_compl it can happen that a new
  SCST command is issued for a session after unregistration of that
  session did start.
- If a session was unregistered because a DREQ had been received it could
  happen that the cm_id was destroyed before a DREP had been sent.

Code changes:
- Moved all code for IB disconnection into the function srpt_del_close_ch().
- Invoking scst_unregister_session() is now deferred until the last WQE event
  has been received.
- Destroying the cm_id does now happen when the CM has reported that this is
  safe instead of when scst_unregister_session() finished.
- Eliminated the variable ch->processing_compl.
- Document the meaning of the channel states.
- Fixed an incorrect comment.
- Do not attempt to invoke ib_post_recv() after the QP has been reset.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/scst/srpt/ib_srpt.c |  190 +++++++++++++++++++++++++++----------------
 drivers/scst/srpt/ib_srpt.h |   14 +++-
 2 files changed, 132 insertions(+), 72 deletions(-)

diff --git a/drivers/scst/srpt/ib_srpt.c b/drivers/scst/srpt/ib_srpt.c
index edd90f1..73b3fd4 100644
--- a/drivers/scst/srpt/ib_srpt.c
+++ b/drivers/scst/srpt/ib_srpt.c
@@ -143,7 +143,8 @@ static void srpt_remove_one(struct ib_device *device);
 static void srpt_unregister_mad_agent(struct srpt_device *sdev);
 static void srpt_unmap_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 				    struct srpt_send_ioctx *ioctx);
-static void srpt_release_channel(struct scst_session *scst_sess);
+static void srpt_release_channel(struct kref *obj);
+static void srpt_release_channel_qp(struct scst_session *scst_sess);
 
 static struct ib_client srpt_client = {
 	.name = DRV_NAME,
@@ -263,6 +264,31 @@ static void srpt_srq_event(struct ib_event *event, void *ctx)
 }
 
 /**
+ * srpt_unregister_channel() - Unregister channel resources.
+ *
+ * Notes:
+ * - Must only be called after the channel has been removed from the channel
+ *   list.
+ * - Invokes ib_destroy_cm_id(ch->cm_id) and kfree(ch) asynchronously.
+ */
+static void srpt_unregister_channel(struct srpt_rdma_ch *ch)
+{
+	if (!srpt_test_and_set_channel_state(ch, CH_DRAINING,
+					     CH_DISCONNECTING))
+		return;
+
+	PRINT_INFO("unregistering session %s.", ch->sess_name);
+
+	/*
+	 * At this point it is guaranteed that no new commands will be sent to
+	 * the SCST core for channel ch, which is a requirement for
+	 * scst_unregister_session().
+	 */
+
+	scst_unregister_session(ch->scst_sess, 0, srpt_release_channel_qp);
+}
+
+/**
  * srpt_qp_event() - QP event callback function.
  */
 static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
@@ -276,11 +302,7 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 		ib_cm_notify(ch->cm_id, event->event);
 		break;
 	case IB_EVENT_QP_LAST_WQE_REACHED:
-		if (srpt_test_and_set_channel_state(ch, CH_LIVE,
-						    CH_DISCONNECTING)) {
-			PRINT_INFO("disconnected session %s.", ch->sess_name);
-			ib_send_cm_dreq(ch->cm_id, NULL, 0);
-		}
+		srpt_unregister_channel(ch);
 		break;
 	default:
 		PRINT_ERROR("received unrecognized IB QP event %d",
@@ -1707,8 +1729,8 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 		goto out;
 	}
 
-	if (unlikely(ch_state == CH_DISCONNECTING))
-		goto post_recv;
+	if (unlikely(ch_state != CH_LIVE))
+		goto out;
 
 	if (srp_cmd->opcode == SRP_CMD || srp_cmd->opcode == SRP_TSK_MGMT) {
 		if (!send_ioctx)
@@ -1720,8 +1742,6 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 		}
 	}
 
-	WARN_ON(ch_state != CH_LIVE);
-
 	switch (srp_cmd->opcode) {
 	case SRP_CMD:
 		srpt_handle_cmd(ch, recv_ioctx, send_ioctx, context);
@@ -1747,7 +1767,6 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 		break;
 	}
 
-post_recv:
 	srpt_post_recv(ch->sport->sdev, recv_ioctx);
 out:
 	return;
@@ -1878,7 +1897,6 @@ static void srpt_completion(struct ib_cq *cq, void *ctx)
 	struct srpt_rdma_ch *ch = ctx;
 
 	BUG_ON(!ch);
-	atomic_inc(&ch->processing_compl);
 	switch (thread) {
 	case MODE_IB_COMPLETION_IN_THREAD:
 		wake_up_interruptible(&ch->wait_queue);
@@ -1890,7 +1908,6 @@ static void srpt_completion(struct ib_cq *cq, void *ctx)
 		srpt_process_completion(cq, ch, SCST_CONTEXT_TASKLET);
 		break;
 	}
-	atomic_dec(&ch->processing_compl);
 }
 
 static int srpt_compl_thread(void *arg)
@@ -2007,20 +2024,45 @@ static void srpt_destroy_ch_ib(struct srpt_rdma_ch *ch)
 }
 
 /**
- * srpt_unregister_channel() - Start RDMA channel disconnection.
+ * __srpt_del_close_ch() - Delete and close an RDMA channel.
+ *
+ * Delete a channel from the channel list, reset the QP and make sure
+ * all resources associated with the channel will be deallocated at an
+ * appropriate time.
  *
- * Note: The caller must hold ch->sdev->spinlock.
+ * Notes:
+ * - The caller must hold ch->sport->sdev->spinlock.
+ * - Invokes ib_destroy_cm_id(ch->cm_id) and kfree(ch) either synchronously
+ *   or asynchronously.
  */
-static void srpt_unregister_channel(struct srpt_rdma_ch *ch)
+static void __srpt_del_close_ch(struct srpt_rdma_ch *ch,
+				enum srpt_channel_close_action a)
 	__acquires(&ch->sport->sdev->spinlock)
 	__releases(&ch->sport->sdev->spinlock)
 {
 	struct srpt_device *sdev;
+	enum rdma_ch_state prev_state;
 	int ret;
 
 	sdev = ch->sport->sdev;
 	list_del(&ch->list);
-	srpt_set_ch_state(ch, CH_DISCONNECTING);
+	prev_state = srpt_set_ch_state(ch, CH_DRAINING);
+	if (prev_state == CH_DRAINING || prev_state == CH_DISCONNECTING)
+		return;
+	switch (a) {
+	case close_action_rej:
+		if (prev_state == CH_CONNECTING) {
+			ib_send_cm_rej(ch->cm_id, IB_CM_REJ_NO_RESOURCES,
+				       NULL, 0, NULL, 0);
+			break;
+		}
+		/* fall through */
+	case close_action_send_dreq:
+		ib_send_cm_dreq(ch->cm_id, NULL, 0);
+		break;
+	case close_action_nop:
+		break;
+	}
 	spin_unlock_irq(&sdev->spinlock);
 
 	ret = srpt_ch_qp_err(ch);
@@ -2028,18 +2070,36 @@ static void srpt_unregister_channel(struct srpt_rdma_ch *ch)
 		PRINT_ERROR("Setting queue pair in error state failed: %d",
 			    ret);
 
-	while (atomic_read(&ch->processing_compl))
-		;
+	switch (prev_state) {
+	case CH_CONNECTING:
+		srpt_unregister_channel(ch);
+	case CH_LIVE:
+		/* Defer srpt_unregister_channel() until last WQE event */
+		break;
+	case CH_DRAINING:
+	case CH_DISCONNECTING:
+		__WARN();
+		break;
+	}
 
-	/*
-	 * At this point it is guaranteed that no new commands will be sent to
-	 * the SCST core for channel ch, which is a requirement for
-	 * scst_unregister_session().
-	 */
+	spin_lock_irq(&sdev->spinlock);
+}
 
-	TRACE_DBG("unregistering session %p", ch->scst_sess);
-	scst_unregister_session(ch->scst_sess, 0, srpt_release_channel);
+/**
+ * srpt_del_close_ch() - Close an RDMA channel.
+ *
+ * Note: Invokes ib_destroy_cm_id(ch->cm_id) and kfree(ch) synchronously or
+ * asynchronously.
+ */
+static void srpt_del_close_ch(struct srpt_rdma_ch *ch,
+			      enum srpt_channel_close_action a)
+{
+	struct srpt_device *sdev;
+
+	sdev = ch->sport->sdev;
 	spin_lock_irq(&sdev->spinlock);
+	__srpt_del_close_ch(ch, a);
+	spin_unlock_irq(&sdev->spinlock);
 }
 
 /**
@@ -2066,7 +2126,7 @@ static void srpt_release_channel_by_cmid(struct ib_cm_id *cm_id)
 	spin_lock_irq(&sdev->spinlock);
 	list_for_each_entry(ch, &sdev->rch_list, list) {
 		if (ch->cm_id == cm_id) {
-			srpt_unregister_channel(ch);
+			kref_put(&ch->kref, srpt_release_channel);
 			break;
 		}
 	}
@@ -2102,7 +2162,21 @@ static struct srpt_rdma_ch *srpt_find_channel(struct srpt_device *sdev,
 }
 
 /**
- * srpt_release_channel() - Release all resources associated with an RDMA channel.
+ * srpt_release_channel() - Release non-QP channel resources.
+ */
+static void srpt_release_channel(struct kref *obj)
+{
+	struct srpt_rdma_ch *ch = container_of(obj, struct srpt_rdma_ch, kref);
+
+	TRACE_DBG("%s(%p)", __func__, ch);
+
+	ib_destroy_cm_id(ch->cm_id);
+
+	kfree(ch);
+}
+
+/**
+ * srpt_release_channel_qp() - Release QP channel resources.
  *
  * Notes:
  * - The caller must have removed the channel from the channel list before
@@ -2110,11 +2184,12 @@ static struct srpt_rdma_ch *srpt_find_channel(struct srpt_device *sdev,
  * - Must be called as a callback function via scst_unregister_session(). Never
  *   call this function directly because doing so would trigger several race
  *   conditions.
- * - Do not access ch->sport or ch->sport->sdev in this function because the
- *   memory that was allocated for the sport and/or sdev data structures may
- *   already have been freed at the time this function is called.
+ * - Accessing ch->sport or ch->sport->sdev in this function is safe because
+ *   these data structure are deallocated after scst_unregister_target()
+ *   has returned, and that function only returns after unregistration of all
+ *   associated sessions has finished.
  */
-static void srpt_release_channel(struct scst_session *scst_sess)
+static void srpt_release_channel_qp(struct scst_session *scst_sess)
 {
 	struct srpt_rdma_ch *ch;
 
@@ -2122,9 +2197,7 @@ static void srpt_release_channel(struct scst_session *scst_sess)
 	BUG_ON(!ch);
 	WARN_ON(srpt_get_ch_state(ch) != CH_DISCONNECTING);
 
-	TRACE_DBG("destroying cm_id %p", ch->cm_id);
-	BUG_ON(!ch->cm_id);
-	ib_destroy_cm_id(ch->cm_id);
+	TRACE_DBG("%s(%s/%p)", __func__, scst_sess->initiator_name, ch->cm_id);
 
 	srpt_destroy_ch_ib(ch);
 
@@ -2132,7 +2205,7 @@ static void srpt_release_channel(struct scst_session *scst_sess)
 			     ch->sport->sdev, ch->rq_size,
 			     srp_max_rsp_size, DMA_TO_DEVICE);
 
-	kfree(ch);
+	kref_put(&ch->kref, srpt_release_channel);
 }
 
 /**
@@ -2256,40 +2329,16 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			    && param->port == ch->sport->port
 			    && param->listen_id == ch->sport->sdev->cm_id
 			    && ch->cm_id) {
-				enum rdma_ch_state prev_state;
-
 				/* found an existing channel */
 				TRACE_DBG("Found existing channel name= %s"
 					  " cm_id= %p state= %d",
 					  ch->sess_name, ch->cm_id,
 					  srpt_get_ch_state(ch));
 
-				prev_state = srpt_set_ch_state(ch,
-						CH_DISCONNECTING);
-				if (prev_state == CH_CONNECTING)
-					srpt_unregister_channel(ch);
-
-				spin_unlock_irq(&sdev->spinlock);
+				__srpt_del_close_ch(ch, close_action_rej);
 
 				rsp->rsp_flags =
 					SRP_LOGIN_RSP_MULTICHAN_TERMINATED;
-
-				if (prev_state == CH_LIVE) {
-					ib_send_cm_dreq(ch->cm_id, NULL, 0);
-					PRINT_INFO("disconnected"
-					  " session %s because a new"
-					  " SRP_LOGIN_REQ has been received.",
-					  ch->sess_name);
-				} else if (prev_state == CH_CONNECTING) {
-					PRINT_ERROR("%s", "rejected"
-					  " SRP_LOGIN_REQ because another login"
-					  " request is being processed.");
-					ib_send_cm_rej(ch->cm_id,
-						       IB_CM_REJ_NO_RESOURCES,
-						       NULL, 0, NULL, 0);
-				}
-
-				spin_lock_irq(&sdev->spinlock);
 			}
 		}
 
@@ -2328,9 +2377,15 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	 * for the SRP protocol to the SCST SCSI command queue size.
 	 */
 	ch->rq_size = min(SRPT_RQ_SIZE, scst_get_max_lun_commands(NULL, 0));
-	atomic_set(&ch->processing_compl, 0);
 	spin_lock_init(&ch->spinlock);
 	ch->state = CH_CONNECTING;
+	/*
+	 * Initialize kref to 2 such that the session resources are only
+	 * released after the connection manager has released the cm_id and
+	 * SCST session unregistration finished.
+	 */
+	kref_init(&ch->kref);
+	kref_get(&ch->kref);
 	INIT_LIST_HEAD(&ch->cmd_wait_list);
 
 	ch->ioctx_ring = (struct srpt_send_ioctx **)
@@ -2505,13 +2560,8 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 			srpt_handle_new_iu(ch, ioctx, NULL,
 					   SCST_CONTEXT_THREAD);
 		}
-		if (ret && srpt_test_and_set_channel_state(ch, CH_LIVE,
-			CH_DISCONNECTING)) {
-			TRACE_DBG("cm_id=%p sess_name=%s state=%d",
-				  cm_id, ch->sess_name,
-				  srpt_get_ch_state(ch));
-			ib_send_cm_dreq(ch->cm_id, NULL, 0);
-		}
+		if (ret)
+			srpt_del_close_ch(ch, close_action_send_dreq);
 	}
 
 out:
@@ -3269,7 +3319,7 @@ static int srpt_release(struct scst_tgt *scst_tgt)
 	spin_lock_irq(&sdev->spinlock);
 	while (!list_empty(&sdev->rch_list)) {
 		ch = list_first_entry(&sdev->rch_list, typeof(*ch), list);
-		srpt_unregister_channel(ch);
+		__srpt_del_close_ch(ch, close_action_send_dreq);
 	}
 	spin_unlock_irq(&sdev->spinlock);
 
diff --git a/drivers/scst/srpt/ib_srpt.h b/drivers/scst/srpt/ib_srpt.h
index e14d192..26e213e 100644
--- a/drivers/scst/srpt/ib_srpt.h
+++ b/drivers/scst/srpt/ib_srpt.h
@@ -225,13 +225,24 @@ struct srpt_mgmt_ioctx {
 
 /**
  * enum rdma_ch_state - SRP channel state.
+ * @CH_CONNECTING:	QP is in RTR state; waiting for RTU.
+ * @CH_LIVE:		QP is in RTS state.
+ * @CH_DRAINING:	QP is in ERR state; waiting for last WQE event.
+ * @CH_DISCONNECTING:	Last WQE event has been received.
  */
 enum rdma_ch_state {
 	CH_CONNECTING,
 	CH_LIVE,
+	CH_DRAINING,
 	CH_DISCONNECTING
 };
 
+enum srpt_channel_close_action {
+	close_action_nop,
+	close_action_send_dreq,
+	close_action_rej,
+};
+
 /**
  * struct srpt_rdma_ch - RDMA channel.
  * @wait_queue:    Allows the kernel thread to wait for more work.
@@ -239,7 +250,6 @@ enum rdma_ch_state {
  *                 the channel.
  * @cm_id:         IB CM ID associated with the channel.
  * @rq_size:       IB receive queue size.
- * @processing_compl: whether or not an IB completion is being processed.
  * @qp:            IB queue pair used for communicating over this channel.
  * @sq_wr_avail:   number of work requests available in the send queue.
  * @cq:            IB completion queue for this channel.
@@ -267,7 +277,6 @@ struct srpt_rdma_ch {
 	struct ib_cm_id		*cm_id;
 	struct ib_qp		*qp;
 	int			rq_size;
-	atomic_t		processing_compl;
 	struct ib_cq		*cq;
 	atomic_t		sq_wr_avail;
 	struct srpt_port	*sport;
@@ -281,6 +290,7 @@ struct srpt_rdma_ch {
 	struct srpt_send_ioctx	**ioctx_ring;
 	struct ib_wc		wc[16];
 	enum rdma_ch_state	state;
+	struct kref		kref;
 	struct list_head	list;
 	struct list_head	cmd_wait_list;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

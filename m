From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/7] ib_srpt: Make channel state names more brief
Date: Sun, 9 Jan 2011 17:26:11 +0100
Message-ID: <201101091726.11938.bvanassche@acm.org>
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

Make the channel state names more brief. Change the return value of
srpt_test_and_set_channel_state() from enum into bool.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/scst/srpt/ib_srpt.c |   53 ++++++++++++++++++++----------------------
 drivers/scst/srpt/ib_srpt.h |    6 ++--
 2 files changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/scst/srpt/ib_srpt.c b/drivers/scst/srpt/ib_srpt.c
index 5dc072e..a308ce1 100644
--- a/drivers/scst/srpt/ib_srpt.c
+++ b/drivers/scst/srpt/ib_srpt.c
@@ -159,14 +159,14 @@ static struct ib_client srpt_client = {
  * @new: state to change the channel state to if the current state matches the
  *       argument 'old'.
  *
- * Returns the previous channel state.
+ * Returns true if and only if the channel state has been set to the new state.
  */
-static enum rdma_ch_state
+static bool
 srpt_test_and_set_channel_state(struct srpt_rdma_ch *ch,
 				enum rdma_ch_state old,
 				enum rdma_ch_state new)
 {
-	return atomic_cmpxchg(&ch->state, old, new);
+	return atomic_cmpxchg(&ch->state, old, new) == old;
 }
 
 /**
@@ -244,8 +244,8 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 		ib_cm_notify(ch->cm_id, event->event);
 		break;
 	case IB_EVENT_QP_LAST_WQE_REACHED:
-		if (srpt_test_and_set_channel_state(ch, RDMA_CHANNEL_LIVE,
-			RDMA_CHANNEL_DISCONNECTING) == RDMA_CHANNEL_LIVE) {
+		if (srpt_test_and_set_channel_state(ch, CH_LIVE,
+						    CH_DISCONNECTING)) {
 			PRINT_INFO("disconnected session %s.", ch->sess_name);
 			ib_send_cm_dreq(ch->cm_id, NULL, 0);
 		}
@@ -1659,12 +1659,12 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 
 	ch_state = atomic_read(&ch->state);
 	srp_cmd = recv_ioctx->ioctx.buf;
-	if (unlikely(ch_state == RDMA_CHANNEL_CONNECTING)) {
+	if (unlikely(ch_state == CH_CONNECTING)) {
 		list_add_tail(&recv_ioctx->wait_list, &ch->cmd_wait_list);
 		goto out;
 	}
 
-	if (unlikely(ch_state == RDMA_CHANNEL_DISCONNECTING))
+	if (unlikely(ch_state == CH_DISCONNECTING))
 		goto post_recv;
 
 	if (srp_cmd->opcode == SRP_CMD || srp_cmd->opcode == SRP_TSK_MGMT) {
@@ -1677,7 +1677,7 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 		}
 	}
 
-	WARN_ON(ch_state != RDMA_CHANNEL_LIVE);
+	WARN_ON(ch_state != CH_LIVE);
 
 	switch (srp_cmd->opcode) {
 	case SRP_CMD:
@@ -1785,7 +1785,7 @@ static void srpt_process_send_completion(struct ib_cq *cq,
 
 	while (unlikely(opcode == IB_WC_SEND
 			&& !list_empty(&ch->cmd_wait_list)
-			&& atomic_read(&ch->state) == RDMA_CHANNEL_LIVE
+			&& atomic_read(&ch->state) == CH_LIVE
 			&& (send_ioctx = srpt_get_send_ioctx(ch)) != NULL)) {
 		struct srpt_recv_ioctx *recv_ioctx;
 
@@ -1978,7 +1978,7 @@ static void srpt_unregister_channel(struct srpt_rdma_ch *ch)
 
 	sdev = ch->sport->sdev;
 	list_del(&ch->list);
-	atomic_set(&ch->state, RDMA_CHANNEL_DISCONNECTING);
+	atomic_set(&ch->state, CH_DISCONNECTING);
 	spin_unlock_irq(&sdev->spinlock);
 
 	qp_attr.qp_state = IB_QPS_ERR;
@@ -2079,7 +2079,7 @@ static void srpt_release_channel(struct scst_session *scst_sess)
 
 	ch = scst_sess_get_tgt_priv(scst_sess);
 	BUG_ON(!ch);
-	WARN_ON(atomic_read(&ch->state) != RDMA_CHANNEL_DISCONNECTING);
+	WARN_ON(atomic_read(&ch->state) != CH_DISCONNECTING);
 
 	TRACE_DBG("destroying cm_id %p", ch->cm_id);
 	BUG_ON(!ch->cm_id);
@@ -2224,8 +2224,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 					  atomic_read(&ch->state));
 
 				prev_state = atomic_xchg(&ch->state,
-						RDMA_CHANNEL_DISCONNECTING);
-				if (prev_state == RDMA_CHANNEL_CONNECTING)
+						CH_DISCONNECTING);
+				if (prev_state == CH_CONNECTING)
 					srpt_unregister_channel(ch);
 
 				spin_unlock_irq(&sdev->spinlock);
@@ -2233,14 +2233,13 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 				rsp->rsp_flags =
 					SRP_LOGIN_RSP_MULTICHAN_TERMINATED;
 
-				if (prev_state == RDMA_CHANNEL_LIVE) {
+				if (prev_state == CH_LIVE) {
 					ib_send_cm_dreq(ch->cm_id, NULL, 0);
 					PRINT_INFO("disconnected"
 					  " session %s because a new"
 					  " SRP_LOGIN_REQ has been received.",
 					  ch->sess_name);
-				} else if (prev_state ==
-					 RDMA_CHANNEL_CONNECTING) {
+				} else if (prev_state == CH_CONNECTING) {
 					PRINT_ERROR("%s", "rejected"
 					  " SRP_LOGIN_REQ because another login"
 					  " request is being processed.");
@@ -2289,7 +2288,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	 */
 	ch->rq_size = min(SRPT_RQ_SIZE, scst_get_max_lun_commands(NULL, 0));
 	atomic_set(&ch->processing_compl, 0);
-	atomic_set(&ch->state, RDMA_CHANNEL_CONNECTING);
+	atomic_set(&ch->state, CH_CONNECTING);
 	INIT_LIST_HEAD(&ch->cmd_wait_list);
 
 	spin_lock_init(&ch->spinlock);
@@ -2400,7 +2399,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	goto out;
 
 release_channel:
-	atomic_set(&ch->state, RDMA_CHANNEL_DISCONNECTING);
+	atomic_set(&ch->state, CH_DISCONNECTING);
 	scst_unregister_session(ch->scst_sess, 0, NULL);
 	ch->scst_sess = NULL;
 
@@ -2454,8 +2453,7 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 	if (!ch)
 		goto out;
 
-	if (srpt_test_and_set_channel_state(ch, RDMA_CHANNEL_CONNECTING,
-			RDMA_CHANNEL_LIVE) == RDMA_CHANNEL_CONNECTING) {
+	if (srpt_test_and_set_channel_state(ch, CH_CONNECTING, CH_LIVE)) {
 		struct srpt_recv_ioctx *ioctx, *ioctx_tmp;
 
 		ret = srpt_ch_qp_rts(ch, ch->qp);
@@ -2466,9 +2464,8 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 			srpt_handle_new_iu(ch, ioctx, NULL,
 					   SCST_CONTEXT_THREAD);
 		}
-		if (ret && srpt_test_and_set_channel_state(ch,
-			RDMA_CHANNEL_LIVE,
-			RDMA_CHANNEL_DISCONNECTING) == RDMA_CHANNEL_LIVE) {
+		if (ret && srpt_test_and_set_channel_state(ch, CH_LIVE,
+			CH_DISCONNECTING)) {
 			TRACE_DBG("cm_id=%p sess_name=%s state=%d",
 				  cm_id, ch->sess_name,
 				  atomic_read(&ch->state));
@@ -2509,13 +2506,13 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
 	TRACE_DBG("cm_id= %p ch->state= %d", cm_id, atomic_read(&ch->state));
 
 	switch (atomic_read(&ch->state)) {
-	case RDMA_CHANNEL_LIVE:
-	case RDMA_CHANNEL_CONNECTING:
+	case CH_LIVE:
+	case CH_CONNECTING:
 		ib_send_cm_drep(ch->cm_id, NULL, 0);
 		PRINT_INFO("Received DREQ and sent DREP for session %s.",
 			   ch->sess_name);
 		break;
-	case RDMA_CHANNEL_DISCONNECTING:
+	case CH_DISCONNECTING:
 	default:
 		break;
 	}
@@ -2980,13 +2977,13 @@ static int srpt_rdy_to_xfer(struct scst_cmd *scmnd)
 	BUG_ON(!ch);
 
 	ch_state = atomic_read(&ch->state);
-	if (ch_state == RDMA_CHANNEL_DISCONNECTING) {
+	if (ch_state == CH_DISCONNECTING) {
 		TRACE_DBG("cmd with tag %lld: channel disconnecting",
 			  scst_cmd_get_tag(scmnd));
 		srpt_set_cmd_state(ioctx, SRPT_STATE_DATA_IN);
 		ret = SCST_TGT_RES_FATAL_ERROR;
 		goto out;
-	} else if (ch_state == RDMA_CHANNEL_CONNECTING) {
+	} else if (ch_state == CH_CONNECTING) {
 		ret = SCST_TGT_RES_QUEUE_FULL;
 		goto out;
 	}
diff --git a/drivers/scst/srpt/ib_srpt.h b/drivers/scst/srpt/ib_srpt.h
index b8f14d4..8f69345 100644
--- a/drivers/scst/srpt/ib_srpt.h
+++ b/drivers/scst/srpt/ib_srpt.h
@@ -227,9 +227,9 @@ struct srpt_mgmt_ioctx {
  * enum rdma_ch_state - SRP channel state.
  */
 enum rdma_ch_state {
-	RDMA_CHANNEL_CONNECTING,
-	RDMA_CHANNEL_LIVE,
-	RDMA_CHANNEL_DISCONNECTING
+	CH_CONNECTING,
+	CH_LIVE,
+	CH_DISCONNECTING
 };
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

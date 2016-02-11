From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 17/21] IB/srpt: Detect session shutdown reliably
Date: Thu, 11 Feb 2016 11:08:53 -0800
Message-ID: <56BCDC45.1030409@sandisk.com>
References: <56BCDAAD.7030906@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BCDAAD.7030906-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The Last WQE Reached event is only generated after one or more work
requests have been queued on the QP associated with a session. Since
session shutdown can start before any work requests have been queued,
use a zero-length RDMA write to wait until a QP has been drained.

Additionally, rework the code for closing and disconnecting a session.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 282 +++++++++++++++++-----------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  18 ++-
 2 files changed, 150 insertions(+), 150 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c96e139..85f6943 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -92,10 +92,11 @@ MODULE_PARM_DESC(srpt_service_guid,
 
 static struct ib_client srpt_client;
 static void srpt_release_cmd(struct se_cmd *se_cmd);
-static void srpt_release_channel(struct srpt_rdma_ch *ch);
+static void srpt_free_ch(struct kref *kref);
 static int srpt_queue_status(struct se_cmd *cmd);
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc);
+static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc);
 
 /*
  * The only allowed channel state changes are those that change the channel
@@ -175,6 +176,23 @@ static void srpt_srq_event(struct ib_event *event, void *ctx)
 	pr_info("SRQ event %d\n", event->event);
 }
 
+static const char *get_ch_state_name(enum rdma_ch_state s)
+{
+	switch (s) {
+	case CH_CONNECTING:
+		return "connecting";
+	case CH_LIVE:
+		return "live";
+	case CH_DISCONNECTING:
+		return "disconnecting";
+	case CH_DRAINING:
+		return "draining";
+	case CH_DISCONNECTED:
+		return "disconnected";
+	}
+	return "???";
+}
+
 /**
  * srpt_qp_event() - QP event callback function.
  */
@@ -188,11 +206,9 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 		ib_cm_notify(ch->cm_id, event->event);
 		break;
 	case IB_EVENT_QP_LAST_WQE_REACHED:
-		if (srpt_set_ch_state(ch, CH_RELEASING))
-			srpt_release_channel(ch);
-		else
-			pr_debug("%s: state %d - ignored LAST_WQE.\n",
-				 ch->sess_name, ch->state);
+		pr_debug("%s-%d, state %s: received Last WQE event.\n",
+			 ch->sess_name, ch->qp->qp_num,
+			 get_ch_state_name(ch->state));
 		break;
 	default:
 		pr_err("received unrecognized IB QP event %d\n", event->event);
@@ -795,6 +811,37 @@ out:
 }
 
 /**
+ * srpt_zerolength_write() - Perform a zero-length RDMA write.
+ *
+ * A quote from the InfiniBand specification: C9-88: For an HCA responder
+ * using Reliable Connection service, for each zero-length RDMA READ or WRITE
+ * request, the R_Key shall not be validated, even if the request includes
+ * Immediate data.
+ */
+static int srpt_zerolength_write(struct srpt_rdma_ch *ch)
+{
+	struct ib_send_wr wr, *bad_wr;
+
+	memset(&wr, 0, sizeof(wr));
+	wr.opcode = IB_WR_RDMA_WRITE;
+	wr.wr_cqe = &ch->zw_cqe;
+	wr.send_flags = IB_SEND_SIGNALED;
+	return ib_post_send(ch->qp, &wr, &bad_wr);
+}
+
+static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct srpt_rdma_ch *ch = cq->cq_context;
+
+	WARN(wc->status == IB_WC_SUCCESS, "%s-%d: QP not in error state\n",
+	     ch->sess_name, ch->qp->qp_num);
+	if (srpt_set_ch_state(ch, CH_DISCONNECTED))
+		schedule_work(&ch->release_work);
+	else
+		WARN_ONCE("%s-%d\n", ch->sess_name, ch->qp->qp_num);
+}
+
+/**
  * srpt_get_desc_tbl() - Parse the data descriptors of an SRP_CMD request.
  * @ioctx: Pointer to the I/O context associated with the request.
  * @srp_cmd: Pointer to the SRP_CMD request data.
@@ -1816,110 +1863,102 @@ static void srpt_destroy_ch_ib(struct srpt_rdma_ch *ch)
 }
 
 /**
- * __srpt_close_ch() - Close an RDMA channel by setting the QP error state.
+ * srpt_close_ch() - Close an RDMA channel.
  *
- * Reset the QP and make sure all resources associated with the channel will
- * be deallocated at an appropriate time.
+ * Make sure all resources associated with the channel will be deallocated at
+ * an appropriate time.
  *
- * Note: The caller must hold ch->sport->sdev->spinlock.
+ * Returns true if and only if the channel state has been modified into
+ * CH_DRAINING.
  */
-static void __srpt_close_ch(struct srpt_rdma_ch *ch)
+static bool srpt_close_ch(struct srpt_rdma_ch *ch)
 {
-	enum rdma_ch_state prev_state;
-	unsigned long flags;
+	int ret;
 
-	spin_lock_irqsave(&ch->spinlock, flags);
-	prev_state = ch->state;
-	switch (prev_state) {
-	case CH_CONNECTING:
-	case CH_LIVE:
-		ch->state = CH_DISCONNECTING;
-		break;
-	default:
-		break;
+	if (!srpt_set_ch_state(ch, CH_DRAINING)) {
+		pr_debug("%s-%d: already closed\n", ch->sess_name,
+			 ch->qp->qp_num);
+		return false;
 	}
-	spin_unlock_irqrestore(&ch->spinlock, flags);
 
-	switch (prev_state) {
-	case CH_CONNECTING:
-		ib_send_cm_rej(ch->cm_id, IB_CM_REJ_NO_RESOURCES, NULL, 0,
-			       NULL, 0);
-		/* fall through */
-	case CH_LIVE:
-		if (ib_send_cm_dreq(ch->cm_id, NULL, 0) < 0)
-			pr_err("sending CM DREQ failed.\n");
-		break;
-	case CH_DISCONNECTING:
-		break;
-	case CH_DRAINING:
-	case CH_RELEASING:
-		break;
-	}
-}
+	kref_get(&ch->kref);
 
-/**
- * srpt_close_ch() - Close an RDMA channel.
- */
-static void srpt_close_ch(struct srpt_rdma_ch *ch)
-{
-	struct srpt_device *sdev = ch->sport->sdev;
+	ret = srpt_ch_qp_err(ch);
+	if (ret < 0)
+		pr_err("%s-%d: changing queue pair into error state failed: %d\n",
+		       ch->sess_name, ch->qp->qp_num, ret);
 
-	mutex_lock(&sdev->mutex);
-	__srpt_close_ch(ch);
-	mutex_unlock(&sdev->mutex);
-}
+	pr_debug("%s-%d: queued zerolength write\n", ch->sess_name,
+		 ch->qp->qp_num);
+	ret = srpt_zerolength_write(ch);
+	if (ret < 0) {
+		pr_err("%s-%d: queuing zero-length write failed: %d\n",
+		       ch->sess_name, ch->qp->qp_num, ret);
+		if (srpt_set_ch_state(ch, CH_DISCONNECTED))
+			schedule_work(&ch->release_work);
+		else
+			WARN_ON_ONCE(true);
+	}
 
-/**
- * srpt_shutdown_session() - Whether or not a session may be shut down.
- */
-static int srpt_shutdown_session(struct se_session *se_sess)
-{
-	return 1;
+	kref_put(&ch->kref, srpt_free_ch);
+
+	return true;
 }
 
-/**
- * srpt_drain_channel() - Drain a channel by resetting the IB queue pair.
- * @cm_id: Pointer to the CM ID of the channel to be drained.
- *
- * Note: Must be called from inside srpt_cm_handler to avoid a race between
- * accessing sdev->spinlock and the call to kfree(sdev) in srpt_remove_one()
- * (the caller of srpt_cm_handler holds the cm_id spinlock; srpt_remove_one()
- * waits until all target sessions for the associated IB device have been
- * unregistered and target session registration involves a call to
- * ib_destroy_cm_id(), which locks the cm_id spinlock and hence waits until
- * this function has finished).
+/*
+ * Change the channel state into CH_DISCONNECTING. If a channel has not yet
+ * reached the connected state, close it. If a channel is in the connected
+ * state, send a DREQ. If a DREQ has been received, send a DREP. Note: it is
+ * the responsibility of the caller to ensure that this function is not
+ * invoked concurrently with the code that accepts a connection. This means
+ * that this function must either be invoked from inside a CM callback
+ * function or that it must be invoked with the srpt_port.mutex held.
  */
-static void srpt_drain_channel(struct srpt_rdma_ch *ch)
+static int srpt_disconnect_ch(struct srpt_rdma_ch *ch)
 {
 	int ret;
-	bool do_reset = false;
 
-	WARN_ON_ONCE(irqs_disabled());
+	if (!srpt_set_ch_state(ch, CH_DISCONNECTING))
+		return -ENOTCONN;
+
+	ret = ib_send_cm_dreq(ch->cm_id, NULL, 0);
+	if (ret < 0)
+		ret = ib_send_cm_drep(ch->cm_id, NULL, 0);
+
+	if (ret < 0 && srpt_close_ch(ch))
+		ret = 0;
+
+	return ret;
+}
 
-	do_reset = srpt_set_ch_state(ch, CH_DRAINING);
+static void __srpt_close_all_ch(struct srpt_device *sdev)
+{
+	struct srpt_rdma_ch *ch;
 
-	if (do_reset) {
-		if (ch->sess)
-			srpt_shutdown_session(ch->sess);
+	lockdep_assert_held(&sdev->mutex);
 
-		ret = srpt_ch_qp_err(ch);
-		if (ret < 0)
-			pr_err("Setting queue pair in error state"
-			       " failed: %d\n", ret);
+	list_for_each_entry(ch, &sdev->rch_list, list) {
+		if (srpt_disconnect_ch(ch) >= 0)
+			pr_info("Closing channel %s-%d because target %s has been disabled\n",
+				ch->sess_name, ch->qp->qp_num,
+				sdev->device->name);
+		srpt_close_ch(ch);
 	}
 }
 
 /**
- * srpt_release_channel() - Release channel resources.
- *
- * Schedules the actual release because:
- * - Calling the ib_destroy_cm_id() call from inside an IB CM callback would
- *   trigger a deadlock.
- * - It is not safe to call TCM transport_* functions from interrupt context.
+ * srpt_shutdown_session() - Whether or not a session may be shut down.
  */
-static void srpt_release_channel(struct srpt_rdma_ch *ch)
+static int srpt_shutdown_session(struct se_session *se_sess)
+{
+	return 1;
+}
+
+static void srpt_free_ch(struct kref *kref)
 {
-	schedule_work(&ch->release_work);
+	struct srpt_rdma_ch *ch = container_of(kref, struct srpt_rdma_ch, kref);
+
+	kfree(ch);
 }
 
 static void srpt_release_channel_work(struct work_struct *w)
@@ -1961,7 +2000,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 
 	wake_up(&sdev->ch_releaseQ);
 
-	kfree(ch);
+	kref_put(&ch->kref, srpt_free_ch);
 }
 
 /**
@@ -2046,17 +2085,10 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			    && param->port == ch->sport->port
 			    && param->listen_id == ch->sport->sdev->cm_id
 			    && ch->cm_id) {
-				if (ch->state != CH_CONNECTING
-				    && ch->state != CH_LIVE)
+				if (srpt_disconnect_ch(ch) < 0)
 					continue;
-
-				/* found an existing channel */
-				pr_debug("Found existing channel %s"
-					 " cm_id= %p state= %d\n",
-					 ch->sess_name, ch->cm_id, ch->state);
-
-				__srpt_close_ch(ch);
-
+				pr_info("Relogin - closed existing channel %s\n",
+					ch->sess_name);
 				rsp->rsp_flags =
 					SRP_LOGIN_RSP_MULTICHAN_TERMINATED;
 			}
@@ -2087,6 +2119,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto reject;
 	}
 
+	kref_init(&ch->kref);
+	ch->zw_cqe.done = srpt_zerolength_write_done;
 	INIT_WORK(&ch->release_work, srpt_release_channel_work);
 	memcpy(ch->i_port_id, req->initiator_port_id, 16);
 	memcpy(ch->t_port_id, req->target_port_id, 16);
@@ -2214,7 +2248,7 @@ try_again:
 	goto out;
 
 release_channel:
-	srpt_set_ch_state(ch, CH_RELEASING);
+	srpt_disconnect_ch(ch);
 	transport_deregister_session_configfs(ch->sess);
 	transport_deregister_session(ch->sess);
 	ch->sess = NULL;
@@ -2262,7 +2296,6 @@ static void srpt_cm_rej_recv(struct srpt_rdma_ch *ch,
 	pr_info("Received CM REJ for ch %s-%d; reason %d; private data %s.\n",
 		ch->sess_name, ch->qp->qp_num, reason, priv ? : "(?)");
 	kfree(priv);
-	srpt_drain_channel(ch);
 }
 
 /**
@@ -2291,40 +2324,6 @@ static void srpt_cm_rtu_recv(struct srpt_rdma_ch *ch)
 }
 
 /**
- * srpt_cm_dreq_recv() - Process reception of a DREQ message.
- */
-static void srpt_cm_dreq_recv(struct srpt_rdma_ch *ch)
-{
-	unsigned long flags;
-	bool send_drep = false;
-
-	pr_debug("ch %s-%d state %d\n", ch->sess_name, ch->qp->qp_num,
-		 ch->state);
-
-	spin_lock_irqsave(&ch->spinlock, flags);
-	switch (ch->state) {
-	case CH_CONNECTING:
-	case CH_LIVE:
-		send_drep = true;
-		ch->state = CH_DISCONNECTING;
-		break;
-	case CH_DISCONNECTING:
-	case CH_DRAINING:
-	case CH_RELEASING:
-		WARN(true, "unexpected channel state %d\n", ch->state);
-		break;
-	}
-	spin_unlock_irqrestore(&ch->spinlock, flags);
-
-	if (send_drep) {
-		if (ib_send_cm_drep(ch->cm_id, NULL, 0) < 0)
-			pr_err("Sending IB DREP failed.\n");
-		pr_info("Received DREQ and sent DREP for session %s.\n",
-			ch->sess_name);
-	}
-}
-
-/**
  * srpt_cm_handler() - IB connection manager callback function.
  *
  * A non-zero return value will cause the caller destroy the CM ID.
@@ -2355,22 +2354,21 @@ static int srpt_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		srpt_cm_rtu_recv(ch);
 		break;
 	case IB_CM_DREQ_RECEIVED:
-		srpt_cm_dreq_recv(ch);
+		srpt_disconnect_ch(ch);
 		break;
 	case IB_CM_DREP_RECEIVED:
 		pr_info("Received CM DREP message for ch %s-%d.\n",
 			ch->sess_name, ch->qp->qp_num);
-		srpt_drain_channel(ch);
+		srpt_close_ch(ch);
 		break;
 	case IB_CM_TIMEWAIT_EXIT:
 		pr_info("Received CM TimeWait exit for ch %s-%d.\n",
 			ch->sess_name, ch->qp->qp_num);
-		srpt_drain_channel(ch);
+		srpt_close_ch(ch);
 		break;
 	case IB_CM_REP_ERROR:
 		pr_info("Received CM REP error for ch %s-%d.\n", ch->sess_name,
 			ch->qp->qp_num);
-		srpt_drain_channel(ch);
 		break;
 	case IB_CM_DREQ_ERROR:
 		pr_info("Received CM DREQ ERROR event.\n");
@@ -2510,7 +2508,7 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 		break;
 	case CH_DISCONNECTING:
 	case CH_DRAINING:
-	case CH_RELEASING:
+	case CH_DISCONNECTED:
 		pr_debug("cmd with tag %lld: channel disconnecting\n",
 			 ioctx->cmd.tag);
 		srpt_set_cmd_state(ioctx, SRPT_STATE_DATA_IN);
@@ -2656,16 +2654,16 @@ static void srpt_refresh_port_work(struct work_struct *work)
  */
 static int srpt_release_sdev(struct srpt_device *sdev)
 {
-	struct srpt_rdma_ch *ch, *tmp_ch;
-	int res;
+	int i, res;
 
 	WARN_ON_ONCE(irqs_disabled());
 
 	BUG_ON(!sdev);
 
 	mutex_lock(&sdev->mutex);
-	list_for_each_entry_safe(ch, tmp_ch, &sdev->rch_list, list)
-		__srpt_close_ch(ch);
+	for (i = 0; i < ARRAY_SIZE(sdev->port); i++)
+		sdev->port[i].enabled = false;
+	__srpt_close_all_ch(sdev);
 	mutex_unlock(&sdev->mutex);
 
 	res = wait_event_interruptible(sdev->ch_releaseQ,
@@ -2962,7 +2960,7 @@ static void srpt_close_session(struct se_session *se_sess)
 	BUG_ON(ch->release_done);
 	ch->release_done = &release_done;
 	wait = !list_empty(&ch->list);
-	__srpt_close_ch(ch);
+	srpt_disconnect_ch(ch);
 	mutex_unlock(&sdev->mutex);
 
 	if (!wait)
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 5883295..af9b8b5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -218,20 +218,20 @@ struct srpt_send_ioctx {
 
 /**
  * enum rdma_ch_state - SRP channel state.
- * @CH_CONNECTING:	 QP is in RTR state; waiting for RTU.
- * @CH_LIVE:		 QP is in RTS state.
- * @CH_DISCONNECTING:    DREQ has been received; waiting for DREP
- *                       or DREQ has been send and waiting for DREP
- *                       or .
- * @CH_DRAINING:	 QP is in ERR state; waiting for last WQE event.
- * @CH_RELEASING:	 Last WQE event has been received; releasing resources.
+ * @CH_CONNECTING:    QP is in RTR state; waiting for RTU.
+ * @CH_LIVE:	      QP is in RTS state.
+ * @CH_DISCONNECTING: DREQ has been sent and waiting for DREP or DREQ has
+ *                    been received.
+ * @CH_DRAINING:      DREP has been received or waiting for DREP timed out
+ *                    and last work request has been queued.
+ * @CH_DISCONNECTED:  Last completion has been received.
  */
 enum rdma_ch_state {
 	CH_CONNECTING,
 	CH_LIVE,
 	CH_DISCONNECTING,
 	CH_DRAINING,
-	CH_RELEASING
+	CH_DISCONNECTED,
 };
 
 /**
@@ -267,6 +267,8 @@ struct srpt_rdma_ch {
 	struct ib_cm_id		*cm_id;
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
+	struct ib_cqe		zw_cqe;
+	struct kref		kref;
 	int			rq_size;
 	u32			rsp_size;
 	atomic_t		sq_wr_avail;
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

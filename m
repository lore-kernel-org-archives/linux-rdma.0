From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] ib_srpt: Source code cleanup
Date: Tue, 8 Nov 2011 20:48:29 +0100
Message-ID: <201111082048.29209.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Address the review comments posted by Christoph Hellwig on May 18,
2011 and that haven't been addressed yet (see also
http://lkml.org/lkml/2011/5/18/63):
- Eliminate the srpt_sdev_name(), srpt_get_ch_state() and
  srpt_get_cmd_state() helper functions.
- Convert the printk() call in srpt_srq_event() into pr_debug().

Also, remove the test from srpt_handle_new_iu() that ignores a new
incoming request if the channel state equals CH_DISCONNECTING or
CH_DRAINING. That test is not necessary since during session
shutdown arrival of new requests is prevented by transitioning the
QP into the error state.

Change one occurrence of if (e) ... else WARN_ON(!e) into
if (e) ... else __WARN().

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   80 ++++++++-------------------------
 1 files changed, 19 insertions(+), 61 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 87bf7a8..7699b49 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -116,27 +116,6 @@ enum dma_data_direction opposite_dma_dir(enum dma_data_direction dir)
 	}
 }
 
-/**
- * srpt_sdev_name() - Return the name associated with the HCA.
- *
- * Examples are ib0, ib1, ...
- */
-static inline const char *srpt_sdev_name(struct srpt_device *sdev)
-{
-	return sdev->device->name;
-}
-
-static enum rdma_ch_state srpt_get_ch_state(struct srpt_rdma_ch *ch)
-{
-	unsigned long flags;
-	enum rdma_ch_state state;
-
-	spin_lock_irqsave(&ch->spinlock, flags);
-	state = ch->state;
-	spin_unlock_irqrestore(&ch->spinlock, flags);
-	return state;
-}
-
 static enum rdma_ch_state
 srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new_state)
 {
@@ -189,7 +168,7 @@ static void srpt_event_handler(struct ib_event_handler *handler,
 		return;
 
 	pr_debug("ASYNC event= %d on device= %s\n", event->event,
-		 srpt_sdev_name(sdev));
+		 sdev->device->name);
 
 	switch (event->event) {
 	case IB_EVENT_PORT_ERR:
@@ -223,7 +202,7 @@ static void srpt_event_handler(struct ib_event_handler *handler,
  */
 static void srpt_srq_event(struct ib_event *event, void *ctx)
 {
-	printk(KERN_INFO "SRQ event %d\n", event->event);
+	pr_debug("SRQ event %d\n", event->event);
 }
 
 /**
@@ -232,7 +211,7 @@ static void srpt_srq_event(struct ib_event *event, void *ctx)
 static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 {
 	pr_debug("QP event %d on cm_id=%p sess_name=%s state=%d\n",
-		 event->event, ch->cm_id, ch->sess_name, srpt_get_ch_state(ch));
+		 event->event, ch->cm_id, ch->sess_name, ch->state);
 
 	switch (event->event) {
 	case IB_EVENT_COMM_EST:
@@ -240,7 +219,7 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 		break;
 	case IB_EVENT_QP_LAST_WQE_REACHED:
 		pr_debug("%s; state %d: received LAST WQE event.\n",
-			 ch->sess_name, srpt_get_ch_state(ch));
+			 ch->sess_name, ch->state);
 		ch->last_wqe_received = true;
 		wake_up_process(ch->thread);
 		break;
@@ -709,22 +688,6 @@ static void srpt_free_ioctx_ring(struct srpt_ioctx **ioctx_ring,
 }
 
 /**
- * srpt_get_cmd_state() - Get the state of a SCSI command.
- */
-static enum srpt_command_state srpt_get_cmd_state(struct srpt_send_ioctx *ioctx)
-{
-	enum srpt_command_state state;
-	unsigned long flags;
-
-	BUG_ON(!ioctx);
-
-	spin_lock_irqsave(&ioctx->spinlock, flags);
-	state = ioctx->state;
-	spin_unlock_irqrestore(&ioctx->spinlock, flags);
-	return state;
-}
-
-/**
  * srpt_set_cmd_state() - Set the state of a SCSI command.
  *
  * Does not modify the state of aborted commands. Returns the previous command
@@ -1306,7 +1269,7 @@ static void srpt_put_send_ioctx(struct srpt_send_ioctx *ioctx)
 	ch = ioctx->ch;
 	BUG_ON(!ch);
 
-	WARN_ON(srpt_get_cmd_state(ioctx) != SRPT_STATE_DONE);
+	WARN_ON(ioctx->state != SRPT_STATE_DONE);
 
 	srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
 	transport_generic_free_cmd(&ioctx->cmd, 0);
@@ -1437,7 +1400,7 @@ static void srpt_handle_send_err_comp(struct srpt_rdma_ch *ch, u64 wr_id)
 
 	index = idx_from_wr_id(wr_id);
 	ioctx = ch->ioctx_ring[index];
-	state = srpt_get_cmd_state(ioctx);
+	state = ioctx->state;
 	cmd = &ioctx->cmd;
 
 	WARN_ON(state != SRPT_STATE_CMD_RSP_SENT
@@ -1497,11 +1460,11 @@ static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
 			transport_generic_handle_data(&ioctx->cmd);
 		else
 			printk(KERN_ERR "%s[%d]: wrong state = %d\n", __func__,
-			       __LINE__, srpt_get_cmd_state(ioctx));
+			       __LINE__, ioctx->state);
 	} else if (opcode == SRPT_RDMA_ABORT) {
 		ioctx->rdma_aborted = true;
 	} else {
-		WARN_ON(opcode != SRPT_RDMA_READ_LAST);
+		__WARN();
 		printk(KERN_ERR "%s[%d]: scmnd == NULL (opcode %d)", __func__,
 				__LINE__, opcode);
 	}
@@ -1518,7 +1481,7 @@ static void srpt_handle_rdma_err_comp(struct srpt_rdma_ch *ch,
 	enum srpt_command_state state;
 
 	cmd = &ioctx->cmd;
-	state = srpt_get_cmd_state(ioctx);
+	state = ioctx->state;
 	switch (opcode) {
 	case SRPT_RDMA_READ_LAST:
 		if (ioctx->n_rdma <= 0) {
@@ -1830,7 +1793,7 @@ static int srpt_rx_mgmt_fn_tag(struct srpt_send_ioctx *ioctx, u64 tag)
 		target = ch->ioctx_ring[i];
 		if (target->cmd.se_lun == ioctx->cmd.se_lun &&
 		    target->tag == tag &&
-		    srpt_get_cmd_state(target) != SRPT_STATE_DONE) {
+		    target->state != SRPT_STATE_DONE) {
 			ret = 0;
 			/* now let the target core abort &target->cmd; */
 			break;
@@ -1934,7 +1897,6 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 			       struct srpt_send_ioctx *send_ioctx)
 {
 	struct srp_cmd *srp_cmd;
-	enum rdma_ch_state ch_state;
 
 	BUG_ON(!ch);
 	BUG_ON(!recv_ioctx);
@@ -1943,15 +1905,11 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 				   recv_ioctx->ioctx.dma, srp_max_req_size,
 				   DMA_FROM_DEVICE);
 
-	ch_state = srpt_get_ch_state(ch);
-	if (unlikely(ch_state == CH_CONNECTING)) {
+	if (unlikely(ch->state == CH_CONNECTING)) {
 		list_add_tail(&recv_ioctx->wait_list, &ch->cmd_wait_list);
 		goto out;
 	}
 
-	if (unlikely(ch_state != CH_LIVE))
-		goto out;
-
 	srp_cmd = recv_ioctx->ioctx.buf;
 	if (srp_cmd->opcode == SRP_CMD || srp_cmd->opcode == SRP_TSK_MGMT) {
 		if (!send_ioctx)
@@ -2068,7 +2026,7 @@ static void srpt_process_send_completion(struct ib_cq *cq,
 
 	while (unlikely(opcode == SRPT_SEND
 			&& !list_empty(&ch->cmd_wait_list)
-			&& srpt_get_ch_state(ch) == CH_LIVE
+			&& ch->state == CH_LIVE
 			&& (send_ioctx = srpt_get_send_ioctx(ch)) != NULL)) {
 		struct srpt_recv_ioctx *recv_ioctx;
 
@@ -2520,7 +2478,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			    && ch->cm_id) {
 				enum rdma_ch_state ch_state;
 
-				ch_state = srpt_get_ch_state(ch);
+				ch_state = ch->state;
 				if (ch_state != CH_CONNECTING
 				    && ch_state != CH_LIVE)
 					continue;
@@ -2768,7 +2726,7 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
 	ch = srpt_find_channel(cm_id->context, cm_id);
 	BUG_ON(!ch);
 
-	pr_debug("cm_id= %p ch->state= %d\n", cm_id, srpt_get_ch_state(ch));
+	pr_debug("cm_id= %p ch->state= %d\n", cm_id, ch->state);
 
 	spin_lock_irqsave(&ch->spinlock, flags);
 	switch (ch->state) {
@@ -2982,7 +2940,7 @@ static int srpt_write_pending_status(struct se_cmd *se_cmd)
 	struct srpt_send_ioctx *ioctx;
 
 	ioctx = container_of(se_cmd, struct srpt_send_ioctx, cmd);
-	return srpt_get_cmd_state(ioctx) == SRPT_STATE_NEED_DATA;
+	return ioctx->state == SRPT_STATE_NEED_DATA;
 }
 
 /*
@@ -3004,7 +2962,7 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 	ch = ioctx->ch;
 	BUG_ON(!ch);
 
-	ch_state = srpt_get_ch_state(ch);
+	ch_state = ch->state;
 	switch (ch_state) {
 	case CH_CONNECTING:
 		/* This code should never be reached. */
@@ -3312,7 +3270,7 @@ static void srpt_add_one(struct ib_device *device)
 
 		if (srpt_refresh_port(sport)) {
 			printk(KERN_ERR "MAD registration failed for %s-%d.\n",
-			       srpt_sdev_name(sdev), i);
+			       sdev->device->name, i);
 			goto err_ring;
 		}
 		snprintf(sport->port_guid, sizeof(sport->port_guid),
@@ -3532,7 +3490,7 @@ static void srpt_close_session(struct se_session *se_sess)
 	ch = se_sess->fabric_sess_ptr;
 	WARN_ON(ch->sess != se_sess);
 
-	pr_debug("ch %p state %d\n", ch, srpt_get_ch_state(ch));
+	pr_debug("ch %p state %d\n", ch, ch->state);
 
 	sdev = ch->sport->sdev;
 	spin_lock_irq(&sdev->spinlock);
@@ -3595,7 +3553,7 @@ static int srpt_get_tcm_cmd_state(struct se_cmd *se_cmd)
 	struct srpt_send_ioctx *ioctx;
 
 	ioctx = container_of(se_cmd, struct srpt_send_ioctx, cmd);
-	return srpt_get_cmd_state(ioctx);
+	return ioctx->state;
 }
 
 static u16 srpt_set_fabric_sense_len(struct se_cmd *cmd, u32 sense_length)
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

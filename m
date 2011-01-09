From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 6/7] ib_srpt: Use locking to protect channel state
Date: Sun, 9 Jan 2011 17:28:18 +0100
Message-ID: <201101091728.18489.bvanassche@acm.org>
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

Protect the channel state against concurrent access via locking instead
of atomic operations.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/scst/srpt/ib_srpt.c |   62 ++++++++++++++++++++++++++++++++----------
 drivers/scst/srpt/ib_srpt.h |    4 +-
 2 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/scst/srpt/ib_srpt.c b/drivers/scst/srpt/ib_srpt.c
index 66f11f6..edd90f1 100644
--- a/drivers/scst/srpt/ib_srpt.c
+++ b/drivers/scst/srpt/ib_srpt.c
@@ -151,6 +151,30 @@ static struct ib_client srpt_client = {
 	.remove = srpt_remove_one
 };
 
+static enum rdma_ch_state srpt_get_ch_state(struct srpt_rdma_ch *ch)
+{
+	unsigned long flags;
+	enum rdma_ch_state state;
+
+	spin_lock_irqsave(&ch->spinlock, flags);
+	state = ch->state;
+	spin_unlock_irqrestore(&ch->spinlock, flags);
+	return state;
+}
+
+static enum rdma_ch_state
+srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new_state)
+{
+	unsigned long flags;
+	enum rdma_ch_state prev;
+
+	spin_lock_irqsave(&ch->spinlock, flags);
+	prev = ch->state;
+	ch->state = new_state;
+	spin_unlock_irqrestore(&ch->spinlock, flags);
+	return prev;
+}
+
 /**
  * srpt_test_and_set_channel_state() - Test and set the channel state.
  *
@@ -166,7 +190,15 @@ srpt_test_and_set_channel_state(struct srpt_rdma_ch *ch,
 				enum rdma_ch_state old,
 				enum rdma_ch_state new)
 {
-	return atomic_cmpxchg(&ch->state, old, new) == old;
+	unsigned long flags;
+	enum rdma_ch_state prev;
+
+	spin_lock_irqsave(&ch->spinlock, flags);
+	prev = ch->state;
+	if (prev == old)
+		ch->state = new;
+	spin_unlock_irqrestore(&ch->spinlock, flags);
+	return prev == old;
 }
 
 /**
@@ -237,7 +269,7 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 {
 	TRACE_DBG("QP event %d on cm_id=%p sess_name=%s state=%d",
 		  event->event, ch->cm_id, ch->sess_name,
-		  atomic_read(&ch->state));
+		  srpt_get_ch_state(ch));
 
 	switch (event->event) {
 	case IB_EVENT_COMM_EST:
@@ -1668,7 +1700,7 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 				   recv_ioctx->ioctx.dma, srp_max_req_size,
 				   DMA_FROM_DEVICE);
 
-	ch_state = atomic_read(&ch->state);
+	ch_state = srpt_get_ch_state(ch);
 	srp_cmd = recv_ioctx->ioctx.buf;
 	if (unlikely(ch_state == CH_CONNECTING)) {
 		list_add_tail(&recv_ioctx->wait_list, &ch->cmd_wait_list);
@@ -1796,7 +1828,7 @@ static void srpt_process_send_completion(struct ib_cq *cq,
 
 	while (unlikely(opcode == IB_WC_SEND
 			&& !list_empty(&ch->cmd_wait_list)
-			&& atomic_read(&ch->state) == CH_LIVE
+			&& srpt_get_ch_state(ch) == CH_LIVE
 			&& (send_ioctx = srpt_get_send_ioctx(ch)) != NULL)) {
 		struct srpt_recv_ioctx *recv_ioctx;
 
@@ -1988,7 +2020,7 @@ static void srpt_unregister_channel(struct srpt_rdma_ch *ch)
 
 	sdev = ch->sport->sdev;
 	list_del(&ch->list);
-	atomic_set(&ch->state, CH_DISCONNECTING);
+	srpt_set_ch_state(ch, CH_DISCONNECTING);
 	spin_unlock_irq(&sdev->spinlock);
 
 	ret = srpt_ch_qp_err(ch);
@@ -2088,7 +2120,7 @@ static void srpt_release_channel(struct scst_session *scst_sess)
 
 	ch = scst_sess_get_tgt_priv(scst_sess);
 	BUG_ON(!ch);
-	WARN_ON(atomic_read(&ch->state) != CH_DISCONNECTING);
+	WARN_ON(srpt_get_ch_state(ch) != CH_DISCONNECTING);
 
 	TRACE_DBG("destroying cm_id %p", ch->cm_id);
 	BUG_ON(!ch->cm_id);
@@ -2230,9 +2262,9 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 				TRACE_DBG("Found existing channel name= %s"
 					  " cm_id= %p state= %d",
 					  ch->sess_name, ch->cm_id,
-					  atomic_read(&ch->state));
+					  srpt_get_ch_state(ch));
 
-				prev_state = atomic_xchg(&ch->state,
+				prev_state = srpt_set_ch_state(ch,
 						CH_DISCONNECTING);
 				if (prev_state == CH_CONNECTING)
 					srpt_unregister_channel(ch);
@@ -2297,10 +2329,10 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	 */
 	ch->rq_size = min(SRPT_RQ_SIZE, scst_get_max_lun_commands(NULL, 0));
 	atomic_set(&ch->processing_compl, 0);
-	atomic_set(&ch->state, CH_CONNECTING);
+	spin_lock_init(&ch->spinlock);
+	ch->state = CH_CONNECTING;
 	INIT_LIST_HEAD(&ch->cmd_wait_list);
 
-	spin_lock_init(&ch->spinlock);
 	ch->ioctx_ring = (struct srpt_send_ioctx **)
 		srpt_alloc_ioctx_ring(ch->sport->sdev, ch->rq_size,
 				      sizeof(*ch->ioctx_ring[0]),
@@ -2408,7 +2440,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	goto out;
 
 release_channel:
-	atomic_set(&ch->state, CH_DISCONNECTING);
+	srpt_set_ch_state(ch, CH_DISCONNECTING);
 	scst_unregister_session(ch->scst_sess, 0, NULL);
 	ch->scst_sess = NULL;
 
@@ -2477,7 +2509,7 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 			CH_DISCONNECTING)) {
 			TRACE_DBG("cm_id=%p sess_name=%s state=%d",
 				  cm_id, ch->sess_name,
-				  atomic_read(&ch->state));
+				  srpt_get_ch_state(ch));
 			ib_send_cm_dreq(ch->cm_id, NULL, 0);
 		}
 	}
@@ -2512,9 +2544,9 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
 		goto out;
 	}
 
-	TRACE_DBG("cm_id= %p ch->state= %d", cm_id, atomic_read(&ch->state));
+	TRACE_DBG("cm_id= %p ch->state= %d", cm_id, srpt_get_ch_state(ch));
 
-	switch (atomic_read(&ch->state)) {
+	switch (srpt_get_ch_state(ch)) {
 	case CH_LIVE:
 	case CH_CONNECTING:
 		ib_send_cm_drep(ch->cm_id, NULL, 0);
@@ -2985,7 +3017,7 @@ static int srpt_rdy_to_xfer(struct scst_cmd *scmnd)
 	WARN_ON(ch != scst_sess_get_tgt_priv(scst_cmd_get_session(scmnd)));
 	BUG_ON(!ch);
 
-	ch_state = atomic_read(&ch->state);
+	ch_state = srpt_get_ch_state(ch);
 	if (ch_state == CH_DISCONNECTING) {
 		TRACE_DBG("cmd with tag %lld: channel disconnecting",
 			  scst_cmd_get_tag(scmnd));
diff --git a/drivers/scst/srpt/ib_srpt.h b/drivers/scst/srpt/ib_srpt.h
index 8f69345..e14d192 100644
--- a/drivers/scst/srpt/ib_srpt.h
+++ b/drivers/scst/srpt/ib_srpt.h
@@ -256,7 +256,7 @@ enum rdma_ch_state {
  * @cmd_wait_list: list of SCST commands that arrived before the RTU event. This
  *                 list contains struct srpt_ioctx elements and is protected
  *                 against concurrent modification by the cm_id spinlock.
- * @spinlock:      Protects free_list.
+ * @spinlock:      Protects free_list and state.
  * @free_list:     Head of list with free send I/O contexts.
  * @scst_sess:     SCST session information associated with this SRP channel.
  * @sess_name:     SCST session name.
@@ -280,7 +280,7 @@ struct srpt_rdma_ch {
 	struct list_head	free_list;
 	struct srpt_send_ioctx	**ioctx_ring;
 	struct ib_wc		wc[16];
-	atomic_t		state;
+	enum rdma_ch_state	state;
 	struct list_head	list;
 	struct list_head	cmd_wait_list;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

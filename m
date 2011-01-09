From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/7] ib_srpt: Protect I/O context state by a spinlock
Date: Sun, 9 Jan 2011 17:25:31 +0100
Message-ID: <201101091725.32017.bvanassche@acm.org>
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

Convert the I/O context state from an atomic variable into a regular
variable protected by a spinlock. Modify srpt_test_and_set_cmd_state()
such that it returns a boolean instead of a state.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/scst/srpt/ib_srpt.c |   96 +++++++++++++++++++++++++++---------------
 drivers/scst/srpt/ib_srpt.h |    3 +-
 2 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/drivers/scst/srpt/ib_srpt.c b/drivers/scst/srpt/ib_srpt.c
index 4c9c700..5dc072e 100644
--- a/drivers/scst/srpt/ib_srpt.c
+++ b/drivers/scst/srpt/ib_srpt.c
@@ -722,9 +722,15 @@ static void srpt_free_ioctx_ring(struct srpt_ioctx **ioctx_ring,
  */
 static enum srpt_command_state srpt_get_cmd_state(struct srpt_send_ioctx *ioctx)
 {
+	enum srpt_command_state state;
+	unsigned long flags;
+
 	BUG_ON(!ioctx);
 
-	return atomic_read(&ioctx->state);
+	spin_lock_irqsave(&ioctx->spinlock, flags);
+	state = ioctx->state;
+	spin_unlock_irqrestore(&ioctx->spinlock, flags);
+	return state;
 }
 
 /**
@@ -738,13 +744,15 @@ static enum srpt_command_state srpt_set_cmd_state(struct srpt_send_ioctx *ioctx,
 						  enum srpt_command_state new)
 {
 	enum srpt_command_state previous;
+	unsigned long flags;
 
 	BUG_ON(!ioctx);
 
-	do {
-		previous = atomic_read(&ioctx->state);
-	} while (previous != SRPT_STATE_DONE
-	       && atomic_cmpxchg(&ioctx->state, previous, new) != previous);
+	spin_lock_irqsave(&ioctx->spinlock, flags);
+	previous = ioctx->state;
+	if (previous != SRPT_STATE_DONE)
+		ioctx->state = new;
+	spin_unlock_irqrestore(&ioctx->spinlock, flags);
 
 	return previous;
 }
@@ -754,18 +762,25 @@ static enum srpt_command_state srpt_set_cmd_state(struct srpt_send_ioctx *ioctx,
  * @old: State to compare against.
  * @new: New state to be set if the current state matches 'old'.
  *
- * Returns the previous command state.
+ * Returns true if and only if the previous command state was equal to 'old'.
  */
-static enum srpt_command_state
-srpt_test_and_set_cmd_state(struct srpt_send_ioctx *ioctx,
-			    enum srpt_command_state old,
-			    enum srpt_command_state new)
+static bool srpt_test_and_set_cmd_state(struct srpt_send_ioctx *ioctx,
+					enum srpt_command_state old,
+					enum srpt_command_state new)
 {
+	enum srpt_command_state previous;
+	unsigned long flags;
+
 	WARN_ON(!ioctx);
 	WARN_ON(old == SRPT_STATE_DONE);
 	WARN_ON(new == SRPT_STATE_NEW);
 
-	return atomic_cmpxchg(&ioctx->state, old, new);
+	spin_lock_irqsave(&ioctx->spinlock, flags);
+	previous = ioctx->state;
+	if (previous == old)
+		ioctx->state = new;
+	spin_unlock_irqrestore(&ioctx->spinlock, flags);
+	return previous == old;
 }
 
 /**
@@ -1052,7 +1067,8 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 		return ioctx;
 
 	BUG_ON(ioctx->ch != ch);
-	atomic_set(&ioctx->state, SRPT_STATE_NEW);
+	spin_lock_init(&ioctx->spinlock);
+	ioctx->state = SRPT_STATE_NEW;
 	ioctx->n_rbuf = 0;
 	ioctx->rbufs = NULL;
 	ioctx->n_rdma = 0;
@@ -1108,6 +1124,7 @@ static void srpt_abort_scst_cmd(struct srpt_send_ioctx *ioctx,
 {
 	struct scst_cmd *scmnd;
 	enum srpt_command_state state;
+	unsigned long flags;
 
 	BUG_ON(!ioctx);
 
@@ -1118,16 +1135,22 @@ static void srpt_abort_scst_cmd(struct srpt_send_ioctx *ioctx,
 	 * ensures that srpt_xmit_response() will call this function a second
 	 * time.
 	 */
-	state = srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA,
-					    SRPT_STATE_DATA_IN);
-	if (state != SRPT_STATE_NEED_DATA) {
-		state = srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_DATA_IN,
-						    SRPT_STATE_DONE);
-		if (state != SRPT_STATE_DATA_IN) {
-			state = srpt_test_and_set_cmd_state(ioctx,
-				    SRPT_STATE_CMD_RSP_SENT, SRPT_STATE_DONE);
-		}
+
+	spin_lock_irqsave(&ioctx->spinlock, flags);
+	state = ioctx->state;
+	switch (state) {
+	case SRPT_STATE_NEED_DATA:
+		ioctx->state = SRPT_STATE_DATA_IN;
+		break;
+	case SRPT_STATE_DATA_IN:
+	case SRPT_STATE_CMD_RSP_SENT:
+		ioctx->state = SRPT_STATE_DONE;
+		break;
+	default:
+		break;
 	}
+	spin_unlock_irqrestore(&ioctx->spinlock, flags);
+
 	if (state == SRPT_STATE_DONE)
 		goto out;
 
@@ -1263,7 +1286,6 @@ static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
 				  struct srpt_send_ioctx *ioctx,
 				  enum scst_exec_context context)
 {
-	enum srpt_command_state state;
 	struct scst_cmd *scmnd;
 
 	EXTRACHECKS_WARN_ON(ioctx->n_rdma <= 0);
@@ -1271,14 +1293,13 @@ static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
 
 	scmnd = ioctx->scmnd;
 	if (scmnd) {
-		state = srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA,
-						    SRPT_STATE_DATA_IN);
-		if (state == SRPT_STATE_NEED_DATA)
+		if (srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA,
+						SRPT_STATE_DATA_IN))
 			scst_rx_data(ioctx->scmnd, SCST_RX_STATUS_SUCCESS,
 				     context);
 		else
 			PRINT_ERROR("%s[%d]: wrong state = %d", __func__,
-				    __LINE__, state);
+				    __LINE__, srpt_get_cmd_state(ioctx));
 	} else
 		PRINT_ERROR("%s[%d]: scmnd == NULL", __func__, __LINE__);
 }
@@ -2986,6 +3007,7 @@ static int srpt_xmit_response(struct scst_cmd *scmnd)
 	struct srpt_rdma_ch *ch;
 	struct srpt_send_ioctx *ioctx;
 	enum srpt_command_state state;
+	unsigned long flags;
 	int ret;
 	scst_data_direction dir;
 	int resp_len;
@@ -2998,15 +3020,21 @@ static int srpt_xmit_response(struct scst_cmd *scmnd)
 	ch = scst_sess_get_tgt_priv(scst_cmd_get_session(scmnd));
 	BUG_ON(!ch);
 
-	state = srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_NEW,
-					    SRPT_STATE_CMD_RSP_SENT);
-	if (state != SRPT_STATE_NEW) {
-		state = srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_DATA_IN,
-						    SRPT_STATE_CMD_RSP_SENT);
-		if (state != SRPT_STATE_DATA_IN)
-			PRINT_ERROR("Unexpected command state %d",
-				    srpt_get_cmd_state(ioctx));
+	spin_lock_irqsave(&ioctx->spinlock, flags);
+	state = ioctx->state;
+	switch (state) {
+	case SRPT_STATE_NEW:
+		ioctx->state = SRPT_STATE_CMD_RSP_SENT;
+	case SRPT_STATE_DATA_IN:
+		ioctx->state = SRPT_STATE_CMD_RSP_SENT;
+		break;
+	default:
+		PRINT_ERROR("Unexpected command state %d",
+			    srpt_get_cmd_state(ioctx));
+		break;
 	}
+	spin_unlock_irqrestore(&ioctx->spinlock, flags);
+
 
 	if (unlikely(scst_cmd_aborted(scmnd))) {
 		atomic_inc(&ch->req_lim_delta);
diff --git a/drivers/scst/srpt/ib_srpt.h b/drivers/scst/srpt/ib_srpt.h
index 3e893d9..b8f14d4 100644
--- a/drivers/scst/srpt/ib_srpt.h
+++ b/drivers/scst/srpt/ib_srpt.h
@@ -209,7 +209,8 @@ struct srpt_send_ioctx {
 
 	struct scst_cmd		*scmnd;
 	scst_data_direction	dir;
-	atomic_t		state;
+	spinlock_t		spinlock;
+	enum srpt_command_state	state;
 };
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

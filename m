From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 05/21] IB/srpt: Inline srpt_get_ch_state()
Date: Thu, 11 Feb 2016 11:04:43 -0800
Message-ID: <56BCDB4B.1090904@sandisk.com>
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

The callers of srpt_get_ch_state() can access ch->state safely without
using locking. Hence inline this function.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 42 ++++++++++-------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index babc15b..6d1a137 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -109,17 +109,6 @@ enum dma_data_direction opposite_dma_dir(enum dma_data_direction dir)
 	}
 }
 
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
@@ -216,7 +205,7 @@ static void srpt_srq_event(struct ib_event *event, void *ctx)
 static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 {
 	pr_debug("QP event %d on cm_id=%p sess_name=%s state=%d\n",
-		 event->event, ch->cm_id, ch->sess_name, srpt_get_ch_state(ch));
+		 event->event, ch->cm_id, ch->sess_name, ch->state);
 
 	switch (event->event) {
 	case IB_EVENT_COMM_EST:
@@ -228,7 +217,7 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 			srpt_release_channel(ch);
 		else
 			pr_debug("%s: state %d - ignored LAST_WQE.\n",
-				 ch->sess_name, srpt_get_ch_state(ch));
+				 ch->sess_name, ch->state);
 		break;
 	default:
 		pr_err("received unrecognized IB QP event %d\n", event->event);
@@ -1733,7 +1722,6 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 			       struct srpt_send_ioctx *send_ioctx)
 {
 	struct srp_cmd *srp_cmd;
-	enum rdma_ch_state ch_state;
 
 	BUG_ON(!ch);
 	BUG_ON(!recv_ioctx);
@@ -1742,13 +1730,12 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 				   recv_ioctx->ioctx.dma, srp_max_req_size,
 				   DMA_FROM_DEVICE);
 
-	ch_state = srpt_get_ch_state(ch);
-	if (unlikely(ch_state == CH_CONNECTING)) {
+	if (unlikely(ch->state == CH_CONNECTING)) {
 		list_add_tail(&recv_ioctx->wait_list, &ch->cmd_wait_list);
 		goto out;
 	}
 
-	if (unlikely(ch_state != CH_LIVE))
+	if (unlikely(ch->state != CH_LIVE))
 		goto out;
 
 	srp_cmd = recv_ioctx->ioctx.buf;
@@ -1857,7 +1844,7 @@ static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
 
 out:
 	while (!list_empty(&ch->cmd_wait_list) &&
-	       srpt_get_ch_state(ch) == CH_LIVE &&
+	       ch->state == CH_LIVE &&
 	       (ioctx = srpt_get_send_ioctx(ch)) != NULL) {
 		struct srpt_recv_ioctx *recv_ioctx;
 
@@ -2238,17 +2225,14 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			    && param->port == ch->sport->port
 			    && param->listen_id == ch->sport->sdev->cm_id
 			    && ch->cm_id) {
-				enum rdma_ch_state ch_state;
-
-				ch_state = srpt_get_ch_state(ch);
-				if (ch_state != CH_CONNECTING
-				    && ch_state != CH_LIVE)
+				if (ch->state != CH_CONNECTING
+				    && ch->state != CH_LIVE)
 					continue;
 
 				/* found an existing channel */
 				pr_debug("Found existing channel %s"
 					 " cm_id= %p state= %d\n",
-					 ch->sess_name, ch->cm_id, ch_state);
+					 ch->sess_name, ch->cm_id, ch->state);
 
 				__srpt_close_ch(ch);
 
@@ -2499,7 +2483,7 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
 	ch = srpt_find_channel(cm_id->context, cm_id);
 	BUG_ON(!ch);
 
-	pr_debug("cm_id= %p ch->state= %d\n", cm_id, srpt_get_ch_state(ch));
+	pr_debug("cm_id= %p ch->state= %d\n", cm_id, ch->state);
 
 	spin_lock_irqsave(&ch->spinlock, flags);
 	switch (ch->state) {
@@ -2691,7 +2675,6 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 	struct srpt_rdma_ch *ch;
 	struct srpt_send_ioctx *ioctx;
 	enum srpt_command_state new_state;
-	enum rdma_ch_state ch_state;
 	int ret;
 
 	ioctx = container_of(se_cmd, struct srpt_send_ioctx, cmd);
@@ -2702,10 +2685,9 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 	ch = ioctx->ch;
 	BUG_ON(!ch);
 
-	ch_state = srpt_get_ch_state(ch);
-	switch (ch_state) {
+	switch (ch->state) {
 	case CH_CONNECTING:
-		WARN(true, "unexpected channel state %d\n", ch_state);
+		WARN(true, "unexpected channel state %d\n", ch->state);
 		ret = -EINVAL;
 		goto out;
 	case CH_LIVE:
@@ -3171,7 +3153,7 @@ static void srpt_close_session(struct se_session *se_sess)
 	ch = se_sess->fabric_sess_ptr;
 	WARN_ON(ch->sess != se_sess);
 
-	pr_debug("ch %p state %d\n", ch, srpt_get_ch_state(ch));
+	pr_debug("ch %p state %d\n", ch, ch->state);
 
 	sdev = ch->sport->sdev;
 	spin_lock_irq(&sdev->spinlock);
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

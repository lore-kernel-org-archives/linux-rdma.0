From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 07/15] IB/srpt: Simplify channel state management
Date: Tue, 5 Jan 2016 15:23:45 +0100
Message-ID: <568BD1F1.5050107@sandisk.com>
References: <568BD0FC.70207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568BD0FC.70207-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The only allowed channel state changes are those that change
the channel state into a state with a higher numerical value.
This allows to merge the functions srpt_set_ch_state() and
srpt_test_and_set_ch_state() into a single function.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 42 +++++++++--------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9cb1a14..a27414d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -96,37 +96,21 @@ static int srpt_queue_status(struct se_cmd *cmd);
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc);
 
-static enum rdma_ch_state
-srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new_state)
+static bool srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new)
 {
 	unsigned long flags;
 	enum rdma_ch_state prev;
+	bool changed = false;
 
 	spin_lock_irqsave(&ch->spinlock, flags);
 	prev = ch->state;
-	ch->state = new_state;
-	spin_unlock_irqrestore(&ch->spinlock, flags);
-	return prev;
-}
-
-/**
- * srpt_test_and_set_ch_state() - Test and set the channel state.
- *
- * Returns true if and only if the channel state has been set to the new state.
- */
-static bool
-srpt_test_and_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state old,
-			   enum rdma_ch_state new)
-{
-	unsigned long flags;
-	enum rdma_ch_state prev;
-
-	spin_lock_irqsave(&ch->spinlock, flags);
-	prev = ch->state;
-	if (prev == old)
+	if (new > prev) {
 		ch->state = new;
+		changed = true;
+	}
 	spin_unlock_irqrestore(&ch->spinlock, flags);
-	return prev == old;
+
+	return changed;
 }
 
 /**
@@ -199,8 +183,7 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 		ib_cm_notify(ch->cm_id, event->event);
 		break;
 	case IB_EVENT_QP_LAST_WQE_REACHED:
-		if (srpt_test_and_set_ch_state(ch, CH_DRAINING,
-					       CH_RELEASING))
+		if (srpt_set_ch_state(ch, CH_RELEASING))
 			srpt_release_channel(ch);
 		else
 			pr_debug("%s: state %d - ignored LAST_WQE.\n",
@@ -1946,12 +1929,7 @@ static void srpt_drain_channel(struct ib_cm_id *cm_id)
 	spin_lock_irq(&sdev->spinlock);
 	list_for_each_entry(ch, &sdev->rch_list, list) {
 		if (ch->cm_id == cm_id) {
-			do_reset = srpt_test_and_set_ch_state(ch,
-					CH_CONNECTING, CH_DRAINING) ||
-				   srpt_test_and_set_ch_state(ch,
-					CH_LIVE, CH_DRAINING) ||
-				   srpt_test_and_set_ch_state(ch,
-					CH_DISCONNECTING, CH_DRAINING);
+			do_reset = srpt_set_ch_state(ch, CH_DRAINING);
 			break;
 		}
 	}
@@ -2368,7 +2346,7 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 	ch = srpt_find_channel(cm_id->context, cm_id);
 	BUG_ON(!ch);
 
-	if (srpt_test_and_set_ch_state(ch, CH_CONNECTING, CH_LIVE)) {
+	if (srpt_set_ch_state(ch, CH_LIVE)) {
 		struct srpt_recv_ioctx *ioctx, *ioctx_tmp;
 
 		ret = srpt_ch_qp_rts(ch, ch->qp);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

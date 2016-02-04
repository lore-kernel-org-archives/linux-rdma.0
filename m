From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 08/21] IB/srpt: Simplify channel state management
Date: Thu, 4 Feb 2016 14:49:28 -0800
Message-ID: <56B3D578.7010301@sandisk.com>
References: <56B3D453.7030409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B3D453.7030409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The only allowed channel state changes are those that change
the channel state into a state with a higher numerical value.
This allows to merge the functions srpt_set_ch_state() and
srpt_test_and_set_ch_state() into a single function.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 44 +++++++++++------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0128040..89c674c 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -96,37 +96,25 @@ static int srpt_queue_status(struct se_cmd *cmd);
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc);
 
-static enum rdma_ch_state
-srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new_state)
-{
-	unsigned long flags;
-	enum rdma_ch_state prev;
-
-	spin_lock_irqsave(&ch->spinlock, flags);
-	prev = ch->state;
-	ch->state = new_state;
-	spin_unlock_irqrestore(&ch->spinlock, flags);
-	return prev;
-}
-
-/**
- * srpt_test_and_set_ch_state() - Test and set the channel state.
- *
- * Returns true if and only if the channel state has been set to the new state.
+/*
+ * The only allowed channel state changes are those that change the channel
+ * state into a state with a higher numerical value. Hence the new > prev test.
  */
-static bool
-srpt_test_and_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state old,
-			   enum rdma_ch_state new)
+static bool srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new)
 {
 	unsigned long flags;
 	enum rdma_ch_state prev;
+	bool changed = false;
 
 	spin_lock_irqsave(&ch->spinlock, flags);
 	prev = ch->state;
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
@@ -199,8 +187,7 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 		ib_cm_notify(ch->cm_id, event->event);
 		break;
 	case IB_EVENT_QP_LAST_WQE_REACHED:
-		if (srpt_test_and_set_ch_state(ch, CH_DRAINING,
-					       CH_RELEASING))
+		if (srpt_set_ch_state(ch, CH_RELEASING))
 			srpt_release_channel(ch);
 		else
 			pr_debug("%s: state %d - ignored LAST_WQE.\n",
@@ -1947,12 +1934,7 @@ static void srpt_drain_channel(struct ib_cm_id *cm_id)
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
@@ -2353,7 +2335,7 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 	ch = srpt_find_channel(cm_id->context, cm_id);
 	BUG_ON(!ch);
 
-	if (srpt_test_and_set_ch_state(ch, CH_CONNECTING, CH_LIVE)) {
+	if (srpt_set_ch_state(ch, CH_LIVE)) {
 		struct srpt_recv_ioctx *ioctx, *ioctx_tmp;
 
 		ret = srpt_ch_qp_rts(ch, ch->qp);
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

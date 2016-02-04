From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 14/21] IB/srpt: Eliminate srpt_find_channel()
Date: Thu, 4 Feb 2016 14:56:32 -0800
Message-ID: <56B3D720.3080303@sandisk.com>
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

In the CM REQ message handler, store the channel pointer in
cm_id->context such that the function srpt_find_channel() is no
longer needed. Additionally, make the CM event messages more
informative.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 94 +++++++++++------------------------
 1 file changed, 29 insertions(+), 65 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index dca07f1..8473515 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1890,25 +1890,14 @@ static int srpt_shutdown_session(struct se_session *se_sess)
  * ib_destroy_cm_id(), which locks the cm_id spinlock and hence waits until
  * this function has finished).
  */
-static void srpt_drain_channel(struct ib_cm_id *cm_id)
+static void srpt_drain_channel(struct srpt_rdma_ch *ch)
 {
-	struct srpt_device *sdev;
-	struct srpt_rdma_ch *ch;
 	int ret;
 	bool do_reset = false;
 
 	WARN_ON_ONCE(irqs_disabled());
 
-	sdev = cm_id->context;
-	BUG_ON(!sdev);
-	spin_lock_irq(&sdev->spinlock);
-	list_for_each_entry(ch, &sdev->rch_list, list) {
-		if (ch->cm_id == cm_id) {
-			do_reset = srpt_set_ch_state(ch, CH_DRAINING);
-			break;
-		}
-	}
-	spin_unlock_irq(&sdev->spinlock);
+	do_reset = srpt_set_ch_state(ch, CH_DRAINING);
 
 	if (do_reset) {
 		if (ch->sess)
@@ -1922,34 +1911,6 @@ static void srpt_drain_channel(struct ib_cm_id *cm_id)
 }
 
 /**
- * srpt_find_channel() - Look up an RDMA channel.
- * @cm_id: Pointer to the CM ID of the channel to be looked up.
- *
- * Return NULL if no matching RDMA channel has been found.
- */
-static struct srpt_rdma_ch *srpt_find_channel(struct srpt_device *sdev,
-					      struct ib_cm_id *cm_id)
-{
-	struct srpt_rdma_ch *ch;
-	bool found;
-
-	WARN_ON_ONCE(irqs_disabled());
-	BUG_ON(!sdev);
-
-	found = false;
-	spin_lock_irq(&sdev->spinlock);
-	list_for_each_entry(ch, &sdev->rch_list, list) {
-		if (ch->cm_id == cm_id) {
-			found = true;
-			break;
-		}
-	}
-	spin_unlock_irq(&sdev->spinlock);
-
-	return found ? ch : NULL;
-}
-
-/**
  * srpt_release_channel() - Release channel resources.
  *
  * Schedules the actual release because:
@@ -2132,6 +2093,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	memcpy(ch->t_port_id, req->target_port_id, 16);
 	ch->sport = &sdev->port[param->port - 1];
 	ch->cm_id = cm_id;
+	cm_id->context = ch;
 	/*
 	 * Avoid QUEUE_FULL conditions by limiting the number of buffers used
 	 * for the SRP protocol to the command queue size.
@@ -2285,10 +2247,14 @@ out:
 	return ret;
 }
 
-static void srpt_cm_rej_recv(struct ib_cm_id *cm_id)
+static void srpt_cm_rej_recv(struct srpt_rdma_ch *ch,
+			     enum ib_cm_rej_reason reason,
+			     const u8 *private_data,
+			     u8 private_data_len)
 {
-	pr_info("Received IB REJ for cm_id %p.\n", cm_id);
-	srpt_drain_channel(cm_id);
+	pr_info("Received CM REJ for ch %s-%d; reason %d.\n",
+		ch->sess_name, ch->qp->qp_num, reason);
+	srpt_drain_channel(ch);
 }
 
 /**
@@ -2297,14 +2263,10 @@ static void srpt_cm_rej_recv(struct ib_cm_id *cm_id)
  * An IB_CM_RTU_RECEIVED message indicates that the connection is established
  * and that the recipient may begin transmitting (RTU = ready to use).
  */
-static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
+static void srpt_cm_rtu_recv(struct srpt_rdma_ch *ch)
 {
-	struct srpt_rdma_ch *ch;
 	int ret;
 
-	ch = srpt_find_channel(cm_id->context, cm_id);
-	BUG_ON(!ch);
-
 	if (srpt_set_ch_state(ch, CH_LIVE)) {
 		struct srpt_recv_ioctx *ioctx, *ioctx_tmp;
 
@@ -2323,16 +2285,13 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 /**
  * srpt_cm_dreq_recv() - Process reception of a DREQ message.
  */
-static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
+static void srpt_cm_dreq_recv(struct srpt_rdma_ch *ch)
 {
-	struct srpt_rdma_ch *ch;
 	unsigned long flags;
 	bool send_drep = false;
 
-	ch = srpt_find_channel(cm_id->context, cm_id);
-	BUG_ON(!ch);
-
-	pr_debug("cm_id= %p ch->state= %d\n", cm_id, ch->state);
+	pr_debug("ch %s-%d state %d\n", ch->sess_name, ch->qp->qp_num,
+		 ch->state);
 
 	spin_lock_irqsave(&ch->spinlock, flags);
 	switch (ch->state) {
@@ -2369,6 +2328,7 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
  */
 static int srpt_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 {
+	struct srpt_rdma_ch *ch = cm_id->context;
 	int ret;
 
 	ret = 0;
@@ -2378,27 +2338,31 @@ static int srpt_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 				       event->private_data);
 		break;
 	case IB_CM_REJ_RECEIVED:
-		srpt_cm_rej_recv(cm_id);
+		srpt_cm_rej_recv(ch, event->param.rej_rcvd.reason,
+				 event->private_data,
+				 IB_CM_REJ_PRIVATE_DATA_SIZE);
 		break;
 	case IB_CM_RTU_RECEIVED:
 	case IB_CM_USER_ESTABLISHED:
-		srpt_cm_rtu_recv(cm_id);
+		srpt_cm_rtu_recv(ch);
 		break;
 	case IB_CM_DREQ_RECEIVED:
-		srpt_cm_dreq_recv(cm_id);
+		srpt_cm_dreq_recv(ch);
 		break;
 	case IB_CM_DREP_RECEIVED:
-		pr_info("Received CM DREP message for cm_id %p.\n",
-			cm_id);
-		srpt_drain_channel(cm_id);
+		pr_info("Received CM DREP message for ch %s-%d.\n",
+			ch->sess_name, ch->qp->qp_num);
+		srpt_drain_channel(ch);
 		break;
 	case IB_CM_TIMEWAIT_EXIT:
-		pr_info("Received CM TimeWait exit for cm_id %p.\n", cm_id);
-		srpt_drain_channel(cm_id);
+		pr_info("Received CM TimeWait exit for ch %s-%d.\n",
+			ch->sess_name, ch->qp->qp_num);
+		srpt_drain_channel(ch);
 		break;
 	case IB_CM_REP_ERROR:
-		pr_info("Received CM REP error for cm_id %p.\n", cm_id);
-		srpt_drain_channel(cm_id);
+		pr_info("Received CM REP error for ch %s-%d.\n", ch->sess_name,
+			ch->qp->qp_num);
+		srpt_drain_channel(ch);
 		break;
 	case IB_CM_DREQ_ERROR:
 		pr_info("Received CM DREQ ERROR event.\n");
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

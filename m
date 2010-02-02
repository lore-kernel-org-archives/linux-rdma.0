From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/srp: reduce number of interrupts
Date: Tue, 2 Feb 2010 20:23:54 +0100
Message-ID: <201002022023.54554.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The patch below reduces the number of IB interrupts from two interrupts per
srp_queuecommand() call to one. Send completion events are now processed via
polling instead of letting the HCA trigger an interrupt for each send
completion event. Receive completion events still trigger an interrupt.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 54c8fe2..f259ab2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -80,7 +80,8 @@ MODULE_PARM_DESC(mellanox_workarounds,
 
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
-static void srp_completion(struct ib_cq *cq, void *target_ptr);
+static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
+static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
 
 static struct scsi_transport_template *ib_srp_transport_template;
@@ -227,14 +228,22 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	if (!init_attr)
 		return -ENOMEM;
 
-	target->cq = ib_create_cq(target->srp_host->srp_dev->dev,
-				  srp_completion, NULL, target, SRP_CQ_SIZE, 0);
-	if (IS_ERR(target->cq)) {
-		ret = PTR_ERR(target->cq);
+	target->recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
+			     srp_recv_completion, NULL, target, SRP_RQ_SIZE, 0);
+	if (IS_ERR(target->recv_cq)) {
+		ret = PTR_ERR(target->recv_cq);
 		goto out;
 	}
 
-	ib_req_notify_cq(target->cq, IB_CQ_NEXT_COMP);
+	target->send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
+			     srp_send_completion, NULL, target, SRP_SQ_SIZE, 0);
+	if (IS_ERR(target->send_cq)) {
+		ret = PTR_ERR(target->send_cq);
+		ib_destroy_cq(target->recv_cq);
+		goto out;
+	}
+
+	ib_req_notify_cq(target->recv_cq, IB_CQ_NEXT_COMP);
 
 	init_attr->event_handler       = srp_qp_event;
 	init_attr->cap.max_send_wr     = SRP_SQ_SIZE;
@@ -243,20 +252,22 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	init_attr->cap.max_send_sge    = 1;
 	init_attr->sq_sig_type         = IB_SIGNAL_ALL_WR;
 	init_attr->qp_type             = IB_QPT_RC;
-	init_attr->send_cq             = target->cq;
-	init_attr->recv_cq             = target->cq;
+	init_attr->send_cq             = target->send_cq;
+	init_attr->recv_cq             = target->recv_cq;
 
 	target->qp = ib_create_qp(target->srp_host->srp_dev->pd, init_attr);
 	if (IS_ERR(target->qp)) {
 		ret = PTR_ERR(target->qp);
-		ib_destroy_cq(target->cq);
+		ib_destroy_cq(target->send_cq);
+		ib_destroy_cq(target->recv_cq);
 		goto out;
 	}
 
 	ret = srp_init_qp(target, target->qp);
 	if (ret) {
 		ib_destroy_qp(target->qp);
-		ib_destroy_cq(target->cq);
+		ib_destroy_cq(target->send_cq);
+		ib_destroy_cq(target->recv_cq);
 		goto out;
 	}
 
@@ -270,7 +281,8 @@ static void srp_free_target_ib(struct srp_target_port *target)
 	int i;
 
 	ib_destroy_qp(target->qp);
-	ib_destroy_cq(target->cq);
+	ib_destroy_cq(target->send_cq);
+	ib_destroy_cq(target->recv_cq);
 
 	for (i = 0; i < SRP_RQ_SIZE; ++i)
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
@@ -568,7 +580,9 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
-	while (ib_poll_cq(target->cq, 1, &wc) > 0)
+	while (ib_poll_cq(target->recv_cq, 1, &wc) > 0)
+		; /* nothing */
+	while (ib_poll_cq(target->send_cq, 1, &wc) > 0)
 		; /* nothing */
 
 	spin_lock_irq(target->scsi_host->host_lock);
@@ -851,7 +865,7 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 	struct srp_iu *iu;
 	u8 opcode;
 
-	iu = target->rx_ring[wc->wr_id & ~SRP_OP_RECV];
+	iu = target->rx_ring[wc->wr_id];
 
 	dev = target->srp_host->srp_dev->dev;
 	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_ti_iu_len,
@@ -898,7 +912,7 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 				      DMA_FROM_DEVICE);
 }
 
-static void srp_completion(struct ib_cq *cq, void *target_ptr)
+static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
 	struct ib_wc wc;
@@ -907,17 +921,31 @@ static void srp_completion(struct ib_cq *cq, void *target_ptr)
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		if (wc.status) {
 			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed %s status %d\n",
-				     wc.wr_id & SRP_OP_RECV ? "receive" : "send",
+				     PFX "failed receive status %d\n",
 				     wc.status);
 			target->qp_in_error = 1;
 			break;
 		}
 
-		if (wc.wr_id & SRP_OP_RECV)
-			srp_handle_recv(target, &wc);
-		else
-			++target->tx_tail;
+		srp_handle_recv(target, &wc);
+	}
+}
+
+static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
+{
+	struct srp_target_port *target = target_ptr;
+	struct ib_wc wc;
+
+	while (ib_poll_cq(cq, 1, &wc) > 0) {
+		if (wc.status) {
+			shost_printk(KERN_ERR, target->scsi_host,
+				     PFX "failed send status %d\n",
+				     wc.status);
+			target->qp_in_error = 1;
+			break;
+		}
+
+		++target->tx_tail;
 	}
 }
 
@@ -930,7 +958,7 @@ static int __srp_post_recv(struct srp_target_port *target)
 	int ret;
 
 	next 	 = target->rx_head & (SRP_RQ_SIZE - 1);
-	wr.wr_id = next | SRP_OP_RECV;
+	wr.wr_id = next;
 	iu 	 = target->rx_ring[next];
 
 	list.addr   = iu->dma;
@@ -970,6 +998,8 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 {
 	s32 min = (req_type == SRP_REQ_TASK_MGMT) ? 1 : 2;
 
+	srp_send_completion(target->send_cq, target);
+
 	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
 		return NULL;
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e185b90..5a80eac 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -60,7 +60,6 @@ enum {
 	SRP_RQ_SHIFT    	= 6,
 	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
 	SRP_SQ_SIZE		= SRP_RQ_SIZE - 1,
-	SRP_CQ_SIZE		= SRP_SQ_SIZE + SRP_RQ_SIZE,
 
 	SRP_TAG_TSK_MGMT	= 1 << (SRP_RQ_SHIFT + 1),
 
@@ -69,8 +68,6 @@ enum {
 	SRP_FMR_DIRTY_SIZE	= SRP_FMR_POOL_SIZE / 4
 };
 
-#define SRP_OP_RECV		(1 << 31)
-
 enum srp_target_state {
 	SRP_TARGET_LIVE,
 	SRP_TARGET_CONNECTING,
@@ -133,7 +130,8 @@ struct srp_target_port {
 	int			path_query_id;
 
 	struct ib_cm_id	       *cm_id;
-	struct ib_cq	       *cq;
+	struct ib_cq	       *recv_cq;
+	struct ib_cq	       *send_cq;
 	struct ib_qp	       *qp;
 
 	int			max_ti_iu_len;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

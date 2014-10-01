From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 13/21] IB/iser: Use single CQ for RX and TX
Date: Wed,  1 Oct 2014 14:02:09 +0300
Message-ID: <1412161337-25285-14-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This will solve a possible condition where we might miss TX
completion (flush error) during session teardown. Since
we are using a single CQ, we don't need to actively drain
the TX CQ, instead just wait for flush_completion (when
counters reach zero) and remove iser_poll_for_flush_errors.

This patch might introduce a minor performance regression
on its own, but the next patches will enhance performance
utilizing a single CQ for RX and TX.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    9 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |    3 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     |  227 ++++++++++++--------------
 3 files changed, 114 insertions(+), 125 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 2bc34aa..1617c5c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -271,16 +271,14 @@ struct iscsi_iser_task;
  * struct iser_comp - iSER completion context
  *
  * @device:     pointer to device handle
- * @rx_cq:      RX completion queue
- * @tx_cq:      TX completion queue
+ * @cq:         completion queue
  * @tasklet:    Tasklet handle
  * @active_qps: Number of active QPs attached
  *              to completion context
  */
 struct iser_comp {
 	struct iser_device      *device;
-	struct ib_cq		*rx_cq;
-	struct ib_cq		*tx_cq;
+	struct ib_cq		*cq;
 	struct tasklet_struct	 tasklet;
 	int                      active_qps;
 };
@@ -342,6 +340,7 @@ struct fast_reg_descriptor {
  * @device:              reference to iser device
  * @comp:                iser completion context
  * @pi_support:          Indicate device T10-PI support
+ * @flush_comp:          completes when all connection completions consumed
  * @lock:                protects fmr/fastreg pool
  * @union.fmr:
  *     @pool:            FMR pool for fast registrations
@@ -361,6 +360,7 @@ struct ib_conn {
 	struct iser_device          *device;
 	struct iser_comp	    *comp;
 	bool			     pi_support;
+	struct completion	     flush_comp;
 	spinlock_t		     lock;
 	union {
 		struct {
@@ -395,6 +395,7 @@ struct iser_conn {
 	u64			     login_req_dma, login_resp_dma;
 	unsigned int 		     rx_desc_head;
 	struct iser_rx_desc	     *rx_descs;
+	u32                          num_rx_descs;
 };
 
 struct iscsi_iser_task {
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 1231745..359c0b8 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -272,7 +272,8 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 	if (iser_alloc_login_buf(iser_conn))
 		goto alloc_login_buf_fail;
 
-	iser_conn->rx_descs = kmalloc(session->cmds_max *
+	iser_conn->num_rx_descs = session->cmds_max;
+	iser_conn->rx_descs = kmalloc(iser_conn->num_rx_descs *
 				sizeof(struct iser_rx_desc), GFP_KERNEL);
 	if (!iser_conn->rx_descs)
 		goto rx_desc_alloc_fail;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index e31ac57..eedc27a 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -39,14 +39,14 @@
 #include "iscsi_iser.h"
 
 #define ISCSI_ISER_MAX_CONN	8
-#define ISER_MAX_RX_CQ_LEN	(ISER_QP_MAX_RECV_DTOS * ISCSI_ISER_MAX_CONN)
-#define ISER_MAX_TX_CQ_LEN	(ISER_QP_MAX_REQ_DTOS  * ISCSI_ISER_MAX_CONN)
+#define ISER_MAX_RX_LEN		(ISER_QP_MAX_RECV_DTOS * ISCSI_ISER_MAX_CONN)
+#define ISER_MAX_TX_LEN		(ISER_QP_MAX_REQ_DTOS  * ISCSI_ISER_MAX_CONN)
+#define ISER_MAX_CQ_LEN		(ISER_MAX_RX_LEN + ISER_MAX_TX_LEN)
 
 static int iser_cq_poll_limit = 512;
 
 static void iser_cq_tasklet_fn(unsigned long data);
 static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
-static int iser_drain_tx_cq(struct iser_comp *comp);
 
 static void iser_cq_event_callback(struct ib_event *cause, void *context)
 {
@@ -117,26 +117,17 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		struct iser_comp *comp = &device->comps[i];
 
 		comp->device = device;
-		comp->rx_cq = ib_create_cq(device->ib_device,
-					   iser_cq_callback,
-					   iser_cq_event_callback,
-					   (void *)comp,
-					   ISER_MAX_RX_CQ_LEN, i);
-		if (IS_ERR(comp->rx_cq)) {
-			comp->rx_cq = NULL;
+		comp->cq = ib_create_cq(device->ib_device,
+					iser_cq_callback,
+					iser_cq_event_callback,
+					(void *)comp,
+					ISER_MAX_CQ_LEN, i);
+		if (IS_ERR(comp->cq)) {
+			comp->cq = NULL;
 			goto cq_err;
 		}
 
-		comp->tx_cq = ib_create_cq(device->ib_device, NULL,
-					   iser_cq_event_callback,
-					   (void *)comp,
-					   ISER_MAX_TX_CQ_LEN, i);
-		if (IS_ERR(comp->tx_cq)) {
-			comp->tx_cq = NULL;
-			goto cq_err;
-		}
-
-		if (ib_req_notify_cq(comp->rx_cq, IB_CQ_NEXT_COMP))
+		if (ib_req_notify_cq(comp->cq, IB_CQ_NEXT_COMP))
 			goto cq_err;
 
 		tasklet_init(&comp->tasklet, iser_cq_tasklet_fn,
@@ -165,10 +156,8 @@ cq_err:
 	for (i = 0; i < device->comps_used; i++) {
 		struct iser_comp *comp = &device->comps[i];
 
-		if (comp->tx_cq)
-			ib_destroy_cq(comp->tx_cq);
-		if (comp->rx_cq)
-			ib_destroy_cq(comp->rx_cq);
+		if (comp->cq)
+			ib_destroy_cq(comp->cq);
 	}
 	ib_dealloc_pd(device->pd);
 pd_err:
@@ -189,10 +178,8 @@ static void iser_free_device_ib_res(struct iser_device *device)
 		struct iser_comp *comp = &device->comps[i];
 
 		tasklet_kill(&comp->tasklet);
-		ib_destroy_cq(comp->tx_cq);
-		ib_destroy_cq(comp->rx_cq);
-		comp->tx_cq = NULL;
-		comp->rx_cq = NULL;
+		ib_destroy_cq(comp->cq);
+		comp->cq = NULL;
 	}
 
 	(void)ib_unregister_event_handler(&device->event_handler);
@@ -462,8 +449,8 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 
 	init_attr.event_handler = iser_qp_event_callback;
 	init_attr.qp_context	= (void *)ib_conn;
-	init_attr.send_cq	= ib_conn->comp->tx_cq;
-	init_attr.recv_cq	= ib_conn->comp->rx_cq;
+	init_attr.send_cq	= ib_conn->comp->cq;
+	init_attr.recv_cq	= ib_conn->comp->cq;
 	init_attr.cap.max_recv_wr  = ISER_QP_MAX_RECV_DTOS;
 	init_attr.cap.max_send_sge = 2;
 	init_attr.cap.max_recv_sge = 1;
@@ -641,33 +628,6 @@ void iser_conn_release(struct iser_conn *iser_conn)
 }
 
 /**
- * iser_poll_for_flush_errors - Don't settle for less than all.
- * @struct ib_conn: IB context of the connection
- *
- * This routine is called when the QP is in error state
- * It polls the send CQ until all flush errors are consumed and
- * returns when all flush errors were processed.
- */
-static void iser_poll_for_flush_errors(struct ib_conn *ib_conn)
-{
-	int count = 0;
-
-	while (ib_conn->post_recv_buf_count > 0 ||
-	       atomic_read(&ib_conn->post_send_buf_count) > 0) {
-		msleep(100);
-		if (atomic_read(&ib_conn->post_send_buf_count) > 0)
-			iser_drain_tx_cq(ib_conn->comp);
-
-		count++;
-		/* Don't flood with prints */
-		if (count % 30 == 0)
-			iser_dbg("post_recv %d post_send %d",
-				 ib_conn->post_recv_buf_count,
-				 atomic_read(&ib_conn->post_send_buf_count));
-	}
-}
-
-/**
  * triggers start of the disconnect procedures and wait for them to be done
  * Called with state mutex held
  */
@@ -698,7 +658,7 @@ int iser_conn_terminate(struct iser_conn *iser_conn)
 			iser_err("Failed to disconnect, conn: 0x%p err %d\n",
 				 iser_conn, err);
 
-		iser_poll_for_flush_errors(ib_conn);
+		wait_for_completion(&ib_conn->flush_comp);
 	}
 
 	return 1;
@@ -908,6 +868,7 @@ void iser_conn_init(struct iser_conn *iser_conn)
 	iser_conn->state = ISER_CONN_INIT;
 	iser_conn->ib_conn.post_recv_buf_count = 0;
 	atomic_set(&iser_conn->ib_conn.post_send_buf_count, 0);
+	init_completion(&iser_conn->ib_conn.flush_comp);
 	init_completion(&iser_conn->stop_completion);
 	init_completion(&iser_conn->ib_completion);
 	init_completion(&iser_conn->up_completion);
@@ -1156,8 +1117,30 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc)
 }
 
 /**
+ * is_iser_tx_desc - Indicate if the completion wr_id
+ *     is a TX descriptor or not.
+ * @iser_conn: iser connection
+ * @wr_id: completion WR identifier
+ *
+ * Since we cannot rely on wc opcode in FLUSH errors
+ * we must work around it by checking if the wr_id address
+ * falls in the iser connection rx_descs buffer. If so
+ * it is an RX descriptor, otherwize it is a TX.
+ */
+static inline bool
+is_iser_tx_desc(struct iser_conn *iser_conn, void *wr_id)
+{
+	void *start = iser_conn->rx_descs;
+	int len = iser_conn->num_rx_descs * sizeof(*iser_conn->rx_descs);
+
+	if (wr_id >= start && wr_id < start + len)
+		return false;
+
+	return true;
+}
+
+/**
  * iser_handle_comp_error() - Handle error completion
- * @desc:      iser TX descriptor
  * @ib_conn:   connection RDMA resources
  * @wc:        work completion
  *
@@ -1167,8 +1150,7 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc)
  *        connection is failed (in case we passed bind stage).
  */
 static void
-iser_handle_comp_error(struct iser_tx_desc *desc,
-		       struct ib_conn *ib_conn,
+iser_handle_comp_error(struct ib_conn *ib_conn,
 		       struct ib_wc *wc)
 {
 	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
@@ -1179,85 +1161,90 @@ iser_handle_comp_error(struct iser_tx_desc *desc,
 			iscsi_conn_failure(iser_conn->iscsi_conn,
 					   ISCSI_ERR_CONN_FAILED);
 
-	if (desc && desc->type == ISCSI_TX_DATAOUT)
-		kmem_cache_free(ig.desc_cache, desc);
+	if (is_iser_tx_desc(iser_conn, (void *)wc->wr_id)) {
+		struct iser_tx_desc *desc = (struct iser_tx_desc *)wc->wr_id;
+
+		atomic_dec(&ib_conn->post_send_buf_count);
+		if (desc->type == ISCSI_TX_DATAOUT)
+			kmem_cache_free(ig.desc_cache, desc);
+	} else {
+		ib_conn->post_recv_buf_count--;
+	}
 }
 
-static int iser_drain_tx_cq(struct iser_comp *comp)
+/**
+ * iser_handle_wc - handle a single work completion
+ * @wc: work completion
+ *
+ * Soft-IRQ context, work completion can be either
+ * SEND or RECV, and can turn out successful or
+ * with error (or flush error).
+ */
+static void iser_handle_wc(struct ib_wc *wc)
 {
-	struct ib_cq *cq = comp->tx_cq;
-	struct ib_wc  wc;
-	struct iser_tx_desc *tx_desc;
 	struct ib_conn *ib_conn;
-	int completed_tx = 0;
+	struct iser_tx_desc *tx_desc;
+	struct iser_rx_desc *rx_desc;
 
-	while (ib_poll_cq(cq, 1, &wc) == 1) {
-		tx_desc	= (struct iser_tx_desc *) (unsigned long) wc.wr_id;
-		ib_conn = wc.qp->qp_context;
-		if (wc.status == IB_WC_SUCCESS) {
-			if (wc.opcode == IB_WC_SEND)
-				iser_snd_completion(tx_desc, ib_conn);
-			else
-				iser_err("expected opcode %d got %d\n",
-					IB_WC_SEND, wc.opcode);
+	ib_conn = wc->qp->qp_context;
+	if (wc->status == IB_WC_SUCCESS) {
+		if (wc->opcode == IB_WC_RECV) {
+			rx_desc = (struct iser_rx_desc *)wc->wr_id;
+			iser_rcv_completion(rx_desc, wc->byte_len,
+					    ib_conn);
+		} else
+		if (wc->opcode == IB_WC_SEND) {
+			tx_desc = (struct iser_tx_desc *)wc->wr_id;
+			iser_snd_completion(tx_desc, ib_conn);
+			atomic_dec(&ib_conn->post_send_buf_count);
 		} else {
-			iser_err("tx id %llx status %d vend_err %x\n",
-				 wc.wr_id, wc.status, wc.vendor_err);
-			if (wc.wr_id != ISER_FASTREG_LI_WRID) {
-				atomic_dec(&ib_conn->post_send_buf_count);
-				iser_handle_comp_error(tx_desc, ib_conn, &wc);
-			}
+			iser_err("Unknown wc opcode %d\n", wc->opcode);
 		}
-		completed_tx++;
+	} else {
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			iser_err("wr id %llx status %d vend_err %x\n",
+				 wc->wr_id, wc->status, wc->vendor_err);
+		else
+			iser_dbg("flush error: wr id %llx\n", wc->wr_id);
+
+		if (wc->wr_id != ISER_FASTREG_LI_WRID)
+			iser_handle_comp_error(ib_conn, wc);
+
+		/* complete in case all flush errors were consumed */
+		if (ib_conn->post_recv_buf_count == 0 &&
+		    atomic_read(&ib_conn->post_send_buf_count) == 0)
+			complete(&ib_conn->flush_comp);
 	}
-	return completed_tx;
 }
 
-
+/**
+ * iser_cq_tasklet_fn - iSER completion polling loop
+ * @data: iSER completion context
+ *
+ * Soft-IRQ context, polling connection CQ until
+ * either CQ was empty or we exausted polling budget
+ */
 static void iser_cq_tasklet_fn(unsigned long data)
 {
 	struct iser_comp *comp = (struct iser_comp *)data;
-	struct ib_cq *cq = comp->rx_cq;
+	struct ib_cq *cq = comp->cq;
 	struct ib_wc wc;
-	struct iser_rx_desc *desc;
-	unsigned long xfer_len;
-	struct ib_conn *ib_conn;
-	int completed_tx, completed_rx = 0;
-
-	/* First do tx drain, so in a case where we have rx flushes and a successful
-	 * tx completion we will still go through completion error handling.
-	 */
-	completed_tx = iser_drain_tx_cq(comp);
+	int completed = 0;
 
 	while (ib_poll_cq(cq, 1, &wc) == 1) {
-		desc	 = (struct iser_rx_desc *) (unsigned long) wc.wr_id;
-		BUG_ON(desc == NULL);
-		ib_conn = wc.qp->qp_context;
-		if (wc.status == IB_WC_SUCCESS) {
-			if (wc.opcode == IB_WC_RECV) {
-				xfer_len = (unsigned long)wc.byte_len;
-				iser_rcv_completion(desc, xfer_len, ib_conn);
-			} else
-				iser_err("expected opcode %d got %d\n",
-					IB_WC_RECV, wc.opcode);
-		} else {
-			if (wc.status != IB_WC_WR_FLUSH_ERR)
-				iser_err("rx id %llx status %d vend_err %x\n",
-					wc.wr_id, wc.status, wc.vendor_err);
-			ib_conn->post_recv_buf_count--;
-			iser_handle_comp_error(NULL, ib_conn, &wc);
-		}
-		completed_rx++;
-		if (!(completed_rx & 63))
-			completed_tx += iser_drain_tx_cq(comp);
-		if (completed_rx >= iser_cq_poll_limit)
+		iser_handle_wc(&wc);
+
+		if (++completed >= iser_cq_poll_limit)
 			break;
 	}
-	/* #warning "it is assumed here that arming CQ only once its empty" *
-	 * " would not cause interrupts to be missed"                       */
+
+	/*
+	 * It is assumed here that arming CQ only once its empty
+	 * would not cause interrupts to be missed.
+	 */
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 
-	iser_dbg("got %d rx %d tx completions\n", completed_rx, completed_tx);
+	iser_dbg("got %d completions\n", completed);
 }
 
 static void iser_cq_callback(struct ib_cq *cq, void *cq_context)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

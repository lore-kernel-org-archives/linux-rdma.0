From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 04/9] ib/iser: use different CQ for send completions
Date: Wed, 3 Feb 2010 17:36:43 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002031735530.11944@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002031721280.11944-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use a different CQ for send completions, where send completions are
being polled by the interrupt driven recv completion handler.
As such, interrupts aren't used for the send CQ.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    3
 drivers/infiniband/ulp/iser/iser_verbs.c |  110 ++++++++++++++++++++-----------
 2 files changed, 76 insertions(+), 37 deletions(-)

Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.h
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -247,7 +247,8 @@ struct iser_rx_desc {
 struct iser_device {
 	struct ib_device             *ib_device;
 	struct ib_pd	             *pd;
-	struct ib_cq	             *cq;
+	struct ib_cq	             *rx_cq;
+	struct ib_cq	             *tx_cq;
 	struct ib_mr	             *mr;
 	struct tasklet_struct	     cq_tasklet;
 	struct list_head             ig_list; /* entry in ig devices list */
Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -37,9 +37,8 @@
 #include "iscsi_iser.h"

 #define ISCSI_ISER_MAX_CONN	8
-#define ISER_MAX_CQ_LEN		((ISER_QP_MAX_RECV_DTOS + \
-				ISER_QP_MAX_REQ_DTOS) *   \
-				 ISCSI_ISER_MAX_CONN)
+#define ISER_MAX_RX_CQ_LEN	(ISER_QP_MAX_RECV_DTOS * ISCSI_ISER_MAX_CONN)
+#define ISER_MAX_TX_CQ_LEN	(ISER_QP_MAX_REQ_DTOS  * ISCSI_ISER_MAX_CONN)

 static void iser_cq_tasklet_fn(unsigned long data);
 static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
@@ -67,15 +66,23 @@ static int iser_create_device_ib_res(str
 	if (IS_ERR(device->pd))
 		goto pd_err;

-	device->cq = ib_create_cq(device->ib_device,
+	device->rx_cq = ib_create_cq(device->ib_device,
 				  iser_cq_callback,
 				  iser_cq_event_callback,
 				  (void *)device,
-				  ISER_MAX_CQ_LEN, 0);
-	if (IS_ERR(device->cq))
-		goto cq_err;
+				  ISER_MAX_RX_CQ_LEN, 0);
+	if (IS_ERR(device->rx_cq))
+		goto rx_cq_err;

-	if (ib_req_notify_cq(device->cq, IB_CQ_NEXT_COMP))
+	device->tx_cq = ib_create_cq(device->ib_device,
+				  NULL, iser_cq_event_callback,
+				  (void *)device,
+				  ISER_MAX_TX_CQ_LEN, 0);
+
+	if (IS_ERR(device->tx_cq))
+		goto tx_cq_err;
+
+	if (ib_req_notify_cq(device->rx_cq, IB_CQ_NEXT_COMP))
 		goto cq_arm_err;

 	tasklet_init(&device->cq_tasklet,
@@ -93,8 +100,10 @@ static int iser_create_device_ib_res(str
 dma_mr_err:
 	tasklet_kill(&device->cq_tasklet);
 cq_arm_err:
-	ib_destroy_cq(device->cq);
-cq_err:
+	ib_destroy_cq(device->tx_cq);
+tx_cq_err:
+	ib_destroy_cq(device->rx_cq);
+rx_cq_err:
 	ib_dealloc_pd(device->pd);
 pd_err:
 	iser_err("failed to allocate an IB resource\n");
@@ -112,11 +121,13 @@ static void iser_free_device_ib_res(stru
 	tasklet_kill(&device->cq_tasklet);

 	(void)ib_dereg_mr(device->mr);
-	(void)ib_destroy_cq(device->cq);
+	(void)ib_destroy_cq(device->tx_cq);
+	(void)ib_destroy_cq(device->rx_cq);
 	(void)ib_dealloc_pd(device->pd);

 	device->mr = NULL;
-	device->cq = NULL;
+	device->tx_cq = NULL;
+	device->rx_cq = NULL;
 	device->pd = NULL;
 }

@@ -179,8 +190,8 @@ static int iser_create_ib_conn_res(struc

 	init_attr.event_handler = iser_qp_event_callback;
 	init_attr.qp_context	= (void *)ib_conn;
-	init_attr.send_cq	= device->cq;
-	init_attr.recv_cq	= device->cq;
+	init_attr.send_cq	= device->tx_cq;
+	init_attr.recv_cq	= device->rx_cq;
 	init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS;
 	init_attr.cap.max_recv_wr  = ISER_QP_MAX_RECV_DTOS;
 	init_attr.cap.max_send_sge = MAX_REGD_BUF_VECTOR_LEN;
@@ -772,18 +783,8 @@ int iser_post_send(struct iser_desc *tx_
 static void iser_handle_comp_error(struct iser_desc *desc,
 				struct iser_conn *ib_conn)
 {
-	struct iser_rx_desc *rx       = (struct iser_rx_desc *)desc;
-	struct iser_rx_desc *rx_first = ib_conn->rx_descs;
-	struct iser_rx_desc *rx_last  = rx_first + (ISER_QP_MAX_RECV_DTOS - 1);
-
-	if ((char *)desc == ib_conn->login_buf ||
-			(rx_first <= rx && rx <= rx_last))
-		ib_conn->post_recv_buf_count--;
-	 else { /* type is TX control/command/dataout */
-		if (desc->type == ISCSI_TX_DATAOUT)
-			kmem_cache_free(ig.desc_cache, desc);
-		atomic_dec(&ib_conn->post_send_buf_count);
-	}
+	if (desc && desc->type == ISCSI_TX_DATAOUT)
+		kmem_cache_free(ig.desc_cache, desc);

 	if (ib_conn->post_recv_buf_count == 0 &&
 	    atomic_read(&ib_conn->post_send_buf_count) == 0) {
@@ -804,37 +805,74 @@ static void iser_handle_comp_error(struc
 	}
 }

+static int iser_drain_tx_cq(struct iser_device  *device)
+{
+	struct ib_cq  *cq = device->tx_cq;
+	struct ib_wc  wc;
+	struct iser_desc *tx_desc;
+	struct iser_conn *ib_conn;
+	int completed_tx = 0;
+
+	while (ib_poll_cq(cq, 1, &wc) == 1) {
+		tx_desc	= (struct iser_desc *) (unsigned long) wc.wr_id;
+		ib_conn = wc.qp->qp_context;
+		if (wc.status == IB_WC_SUCCESS) {
+			if (wc.opcode == IB_WC_SEND)
+				iser_snd_completion(tx_desc);
+			else
+				iser_err("expected opcode %d got %d\n",
+					IB_WC_SEND, wc.opcode);
+		} else {
+			iser_err("tx id %llx status %d vend_err %x\n",
+				wc.wr_id, wc.status, wc.vendor_err);
+			atomic_dec(&ib_conn->post_send_buf_count);
+			iser_handle_comp_error(tx_desc, ib_conn);
+		}
+		completed_tx++;
+	}
+	return completed_tx;
+}
+
+
 static void iser_cq_tasklet_fn(unsigned long data)
 {
 	 struct iser_device  *device = (struct iser_device *)data;
-	 struct ib_cq	     *cq = device->cq;
+	 struct ib_cq	     *cq = device->rx_cq;
 	 struct ib_wc	     wc;
-	 struct iser_desc    *desc;
+	 struct iser_rx_desc *desc;
 	 unsigned long	     xfer_len;
 	struct iser_conn *ib_conn;
+	int completed_tx, completed_rx;
+	completed_tx = completed_rx = 0;

 	while (ib_poll_cq(cq, 1, &wc) == 1) {
-		desc	 = (struct iser_desc *) (unsigned long) wc.wr_id;
+		desc	 = (struct iser_rx_desc *) (unsigned long) wc.wr_id;
 		BUG_ON(desc == NULL);
 		ib_conn = wc.qp->qp_context;
-
 		if (wc.status == IB_WC_SUCCESS) {
 			if (wc.opcode == IB_WC_RECV) {
 				xfer_len = (unsigned long)wc.byte_len;
-				iser_rcv_completion((struct iser_rx_desc *)desc,
-							xfer_len, ib_conn);
-			} else /* type == ISCSI_TX_CONTROL/SCSI_CMD/DOUT */
-				iser_snd_completion(desc);
+				iser_rcv_completion(desc, xfer_len, ib_conn);
+			} else
+				iser_err("expected opcode %d got %d\n",
+					IB_WC_RECV, wc.opcode);
 		} else {
 			if (wc.status != IB_WC_WR_FLUSH_ERR)
-				iser_err("id %llx status %d vend_err %x\n",
+				iser_err("rx id %llx status %d vend_err %x\n",
 					wc.wr_id, wc.status, wc.vendor_err);
-			iser_handle_comp_error(desc, ib_conn);
+			ib_conn->post_recv_buf_count--;
+			iser_handle_comp_error(NULL, ib_conn);
 		}
+		completed_rx++;
+		if (!(completed_rx & 63))
+			completed_tx += iser_drain_tx_cq(device);
 	}
 	/* #warning "it is assumed here that arming CQ only once its empty" *
 	 * " would not cause interrupts to be missed"                       */
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+
+	completed_tx += iser_drain_tx_cq(device);
+	iser_dbg("got %d rx %d tx completions\n", completed_rx, completed_tx);
 }

 static void iser_cq_callback(struct ib_cq *cq, void *cq_context)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

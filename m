From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 14/21] IB/iser: Use beacon to indicate all completions were consumed
Date: Wed,  1 Oct 2014 14:02:10 +0300
Message-ID: <1412161337-25285-15-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Avoid post_send counting (atomic) in the IO path just to keep
track of how many completions we need to consume. Use a beacon
post to indicate that all prior posts completed.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    5 ++-
 drivers/infiniband/ulp/iser/iser_initiator.c |    8 +-----
 drivers/infiniband/ulp/iser/iser_verbs.c     |   32 ++++++++++++++-----------
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 1617c5c..4fcb256 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -150,6 +150,7 @@
 #define ISER_RSV			0x04
 
 #define ISER_FASTREG_LI_WRID		0xffffffffffffffffULL
+#define ISER_BEACON_WRID		0xfffffffffffffffeULL
 
 struct iser_hdr {
 	u8      flags;
@@ -335,11 +336,11 @@ struct fast_reg_descriptor {
  * @cma_id:              rdma_cm connection maneger handle
  * @qp:                  Connection Queue-pair
  * @post_recv_buf_count: post receive counter
- * @post_send_buf_count: post send counter
  * @rx_wr:               receive work request for batch posts
  * @device:              reference to iser device
  * @comp:                iser completion context
  * @pi_support:          Indicate device T10-PI support
+ * @beacon:              beacon send wr to signal all flush errors were drained
  * @flush_comp:          completes when all connection completions consumed
  * @lock:                protects fmr/fastreg pool
  * @union.fmr:
@@ -355,11 +356,11 @@ struct ib_conn {
 	struct rdma_cm_id           *cma_id;
 	struct ib_qp	            *qp;
 	int                          post_recv_buf_count;
-	atomic_t                     post_send_buf_count;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
 	struct iser_device          *device;
 	struct iser_comp	    *comp;
 	bool			     pi_support;
+	struct ib_send_wr	     beacon;
 	struct completion	     flush_comp;
 	spinlock_t		     lock;
 	union {
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 359c0b8..ffbdf92 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -350,12 +350,10 @@ static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 		return 0;
 
 	/*
-	 * Check that there is one posted recv buffer (for the last login
-	 * response) and no posted send buffers left - they must have been
-	 * consumed during previous login phases.
+	 * Check that there is one posted recv buffer
+	 * (for the last login response).
 	 */
 	WARN_ON(ib_conn->post_recv_buf_count != 1);
-	WARN_ON(atomic_read(&ib_conn->post_send_buf_count) != 0);
 
 	if (session->discovery_sess) {
 		iser_info("Discovery session, re-using login RX buffer\n");
@@ -634,8 +632,6 @@ void iser_snd_completion(struct iser_tx_desc *tx_desc,
 		tx_desc = NULL;
 	}
 
-	atomic_dec(&ib_conn->post_send_buf_count);
-
 	if (tx_desc && tx_desc->type == ISCSI_TX_CONTROL) {
 		/* this arithmetic is legal by libiscsi dd_data allocation */
 		task = (void *) ((long)(void *)tx_desc -
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index eedc27a..805a9bd 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -41,7 +41,8 @@
 #define ISCSI_ISER_MAX_CONN	8
 #define ISER_MAX_RX_LEN		(ISER_QP_MAX_RECV_DTOS * ISCSI_ISER_MAX_CONN)
 #define ISER_MAX_TX_LEN		(ISER_QP_MAX_REQ_DTOS  * ISCSI_ISER_MAX_CONN)
-#define ISER_MAX_CQ_LEN		(ISER_MAX_RX_LEN + ISER_MAX_TX_LEN)
+#define ISER_MAX_CQ_LEN		(ISER_MAX_RX_LEN + ISER_MAX_TX_LEN + \
+				 ISCSI_ISER_MAX_CONN)
 
 static int iser_cq_poll_limit = 512;
 
@@ -457,10 +458,10 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 	init_attr.sq_sig_type	= IB_SIGNAL_REQ_WR;
 	init_attr.qp_type	= IB_QPT_RC;
 	if (ib_conn->pi_support) {
-		init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS;
+		init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS + 1;
 		init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
 	} else {
-		init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS;
+		init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS + 1;
 	}
 
 	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
@@ -634,6 +635,7 @@ void iser_conn_release(struct iser_conn *iser_conn)
 int iser_conn_terminate(struct iser_conn *iser_conn)
 {
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
+	struct ib_send_wr *bad_wr;
 	int err = 0;
 
 	/* terminate the iser conn only if the conn state is UP */
@@ -658,6 +660,11 @@ int iser_conn_terminate(struct iser_conn *iser_conn)
 			iser_err("Failed to disconnect, conn: 0x%p err %d\n",
 				 iser_conn, err);
 
+		/* post an indication that all flush errors were consumed */
+		err = ib_post_send(ib_conn->qp, &ib_conn->beacon, &bad_wr);
+		if (err)
+			iser_err("conn %p failed to post beacon", ib_conn);
+
 		wait_for_completion(&ib_conn->flush_comp);
 	}
 
@@ -867,7 +874,6 @@ void iser_conn_init(struct iser_conn *iser_conn)
 {
 	iser_conn->state = ISER_CONN_INIT;
 	iser_conn->ib_conn.post_recv_buf_count = 0;
-	atomic_set(&iser_conn->ib_conn.post_send_buf_count, 0);
 	init_completion(&iser_conn->ib_conn.flush_comp);
 	init_completion(&iser_conn->stop_completion);
 	init_completion(&iser_conn->ib_completion);
@@ -900,6 +906,9 @@ int iser_connect(struct iser_conn   *iser_conn,
 
 	iser_conn->state = ISER_CONN_PENDING;
 
+	ib_conn->beacon.wr_id = ISER_BEACON_WRID;
+	ib_conn->beacon.opcode = IB_WR_SEND;
+
 	ib_conn->cma_id = rdma_create_id(iser_cma_handler,
 					 (void *)iser_conn,
 					 RDMA_PS_TCP, IB_QPT_RC);
@@ -1106,13 +1115,10 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc)
 	send_wr.opcode	   = IB_WR_SEND;
 	send_wr.send_flags = IB_SEND_SIGNALED;
 
-	atomic_inc(&ib_conn->post_send_buf_count);
-
 	ib_ret = ib_post_send(ib_conn->qp, &send_wr, &send_wr_failed);
-	if (ib_ret) {
+	if (ib_ret)
 		iser_err("ib_post_send failed, ret:%d\n", ib_ret);
-		atomic_dec(&ib_conn->post_send_buf_count);
-	}
+
 	return ib_ret;
 }
 
@@ -1164,7 +1170,6 @@ iser_handle_comp_error(struct ib_conn *ib_conn,
 	if (is_iser_tx_desc(iser_conn, (void *)wc->wr_id)) {
 		struct iser_tx_desc *desc = (struct iser_tx_desc *)wc->wr_id;
 
-		atomic_dec(&ib_conn->post_send_buf_count);
 		if (desc->type == ISCSI_TX_DATAOUT)
 			kmem_cache_free(ig.desc_cache, desc);
 	} else {
@@ -1196,7 +1201,6 @@ static void iser_handle_wc(struct ib_wc *wc)
 		if (wc->opcode == IB_WC_SEND) {
 			tx_desc = (struct iser_tx_desc *)wc->wr_id;
 			iser_snd_completion(tx_desc, ib_conn);
-			atomic_dec(&ib_conn->post_send_buf_count);
 		} else {
 			iser_err("Unknown wc opcode %d\n", wc->opcode);
 		}
@@ -1207,12 +1211,12 @@ static void iser_handle_wc(struct ib_wc *wc)
 		else
 			iser_dbg("flush error: wr id %llx\n", wc->wr_id);
 
-		if (wc->wr_id != ISER_FASTREG_LI_WRID)
+		if (wc->wr_id != ISER_FASTREG_LI_WRID &&
+		    wc->wr_id != ISER_BEACON_WRID)
 			iser_handle_comp_error(ib_conn, wc);
 
 		/* complete in case all flush errors were consumed */
-		if (ib_conn->post_recv_buf_count == 0 &&
-		    atomic_read(&ib_conn->post_send_buf_count) == 0)
+		if (wc->wr_id == ISER_BEACON_WRID)
 			complete(&ib_conn->flush_comp);
 	}
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

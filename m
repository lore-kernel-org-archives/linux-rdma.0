From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH for-next 10/10] IB/iser: Support the remote invalidation exception
Date: Mon, 16 Nov 2015 18:37:41 +0200
Message-ID: <1447691861-3796-11-git-send-email-sagig@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf@mellanox.com>

Declare that we support remote invalidation and be able to detect
the invalidated rkey so we won't invalidate it locally. The spec
mandates that we must not rely on the taget remote invalidate our
rkey so we must check it upon a receive (scsi response) completion.

Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  3 +-
 drivers/infiniband/ulp/iser/iser_initiator.c | 55 +++++++++++++++++++++++++++-
 drivers/infiniband/ulp/iser/iser_verbs.c     | 19 +++++++---
 3 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 096d5234bbea..2e0a24ba18ed 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -519,6 +519,7 @@ struct iser_conn {
 	u32                          num_rx_descs;
 	unsigned short               scsi_sg_tablesize;
 	unsigned int                 scsi_max_sectors;
+	bool			     snd_w_inv;
 };
 
 /**
@@ -603,7 +604,7 @@ int iser_conn_terminate(struct iser_conn *iser_conn);
 void iser_release_work(struct work_struct *work);
 
 void iser_rcv_completion(struct iser_rx_desc *desc,
-			 unsigned long dto_xfer_len,
+			 struct ib_wc *wc,
 			 struct ib_conn *ib_conn);
 
 void iser_snd_completion(struct iser_tx_desc *desc,
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 6a968e350c14..df6a4b70ffc9 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -563,11 +563,57 @@ send_control_error:
 	return err;
 }
 
+static int
+iser_check_remote_inv(struct iser_conn *iser_conn,
+		      struct ib_wc *wc,
+		      struct iscsi_hdr *hdr)
+{
+	if (wc->wc_flags & IB_WC_WITH_INVALIDATE) {
+		struct iscsi_task *task;
+		struct iscsi_iser_task *iser_task;
+		u32 rkey = wc->ex.invalidate_rkey;
+
+		iser_dbg("conn %p: remote invalidation\n", iser_conn);
+		if (unlikely(!iser_conn->snd_w_inv)) {
+			iser_err("conn %p: unexepected remote invalidation,"
+				 "terminating connection\n", iser_conn);
+			return -EPROTO;
+		}
+
+		task = iscsi_itt_to_ctask(iser_conn->iscsi_conn, hdr->itt);
+		if (likely(task)) {
+			struct iser_mem_reg *reg;
+			struct iser_fr_desc *desc;
+
+			iser_task = task->dd_data;
+			if (iser_task->dir[ISER_DIR_IN])
+				reg = &iser_task->rdma_reg[ISER_DIR_IN];
+			else
+				reg = &iser_task->rdma_reg[ISER_DIR_OUT];
+			desc = reg->mem_h;
+
+			if (likely(rkey == desc->rsc.mr->rkey)) {
+				desc->rsc.mr_valid = 0;
+			} else if (likely(rkey == desc->pi_ctx->sig_mr->rkey)) {
+				desc->pi_ctx->sig_mr_valid = 0;
+			} else {
+				iser_err("invalidation of unknown rkey=0x%x\n", rkey);
+				return -EINVAL;
+			}
+		} else {
+			iser_err("failed to get task for itt=%d\n", hdr->itt);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * iser_rcv_dto_completion - recv DTO completion
  */
 void iser_rcv_completion(struct iser_rx_desc *rx_desc,
-			 unsigned long rx_xfer_len,
+			 struct ib_wc *wc,
 			 struct ib_conn *ib_conn)
 {
 	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
@@ -575,6 +621,7 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	struct iscsi_hdr *hdr;
 	u64 rx_dma;
 	int rx_buflen, outstanding, count, err;
+	unsigned long rx_xfer_len = wc->byte_len;
 
 	/* differentiate between login to all other PDUs */
 	if ((char *)rx_desc == iser_conn->login_resp_buf) {
@@ -593,6 +640,12 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	iser_dbg("op 0x%x itt 0x%x dlen %d\n", hdr->opcode,
 			hdr->itt, (int)(rx_xfer_len - ISER_HEADERS_LEN));
 
+	if (iser_check_remote_inv(iser_conn, wc, hdr)) {
+		iscsi_conn_failure(iser_conn->iscsi_conn,
+				   ISCSI_ERR_CONN_FAILED);
+		return;
+	}
+
 	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, rx_desc->data,
 			rx_xfer_len - ISER_HEADERS_LEN);
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 74161a566852..5dd7cbd8e2e2 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -847,7 +847,7 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
 	conn_param.rnr_retry_count     = 6;
 
 	memset(&req_hdr, 0, sizeof(req_hdr));
-	req_hdr.flags = (ISER_ZBVA_NOT_SUP | ISER_SEND_W_INV_NOT_SUP);
+	req_hdr.flags = ISER_ZBVA_NOT_SUP;
 	conn_param.private_data	= (void *)&req_hdr;
 	conn_param.private_data_len = sizeof(struct iser_cm_hdr);
 
@@ -862,7 +862,8 @@ failure:
 	iser_connect_error(cma_id);
 }
 
-static void iser_connected_handler(struct rdma_cm_id *cma_id)
+static void iser_connected_handler(struct rdma_cm_id *cma_id,
+				   const void *private_data)
 {
 	struct iser_conn *iser_conn;
 	struct ib_qp_attr attr;
@@ -876,6 +877,15 @@ static void iser_connected_handler(struct rdma_cm_id *cma_id)
 	(void)ib_query_qp(cma_id->qp, &attr, ~0, &init_attr);
 	iser_info("remote qpn:%x my qpn:%x\n", attr.dest_qp_num, cma_id->qp->qp_num);
 
+	if (private_data) {
+		u8 flags = *(u8 *)private_data;
+
+		iser_conn->snd_w_inv = !(flags & ISER_SEND_W_INV_NOT_SUP);
+	}
+
+	iser_info("conn %p: negotiated %s invalidation\n",
+		  iser_conn, iser_conn->snd_w_inv ? "remote" : "local");
+
 	iser_conn->state = ISER_CONN_UP;
 	complete(&iser_conn->up_completion);
 }
@@ -927,7 +937,7 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 		iser_route_handler(cma_id);
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
-		iser_connected_handler(cma_id);
+		iser_connected_handler(cma_id, event->param.conn.private_data);
 		break;
 	case RDMA_CM_EVENT_ADDR_ERROR:
 	case RDMA_CM_EVENT_ROUTE_ERROR:
@@ -1205,8 +1215,7 @@ static void iser_handle_wc(struct ib_wc *wc)
 	if (likely(wc->status == IB_WC_SUCCESS)) {
 		if (wc->opcode == IB_WC_RECV) {
 			rx_desc = (struct iser_rx_desc *)(uintptr_t)wc->wr_id;
-			iser_rcv_completion(rx_desc, wc->byte_len,
-					    ib_conn);
+			iser_rcv_completion(rx_desc, wc, ib_conn);
 		} else
 		if (wc->opcode == IB_WC_SEND) {
 			tx_desc = (struct iser_tx_desc *)(uintptr_t)wc->wr_id;
-- 
1.8.4.3

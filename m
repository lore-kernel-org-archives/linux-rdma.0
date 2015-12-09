From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 10/10] IB/iser: Support the remote invalidation exception
Date: Wed,  9 Dec 2015 14:12:08 +0200
Message-ID: <1449663128-368-11-git-send-email-sagig@mellanox.com>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1449663128-368-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf@mellanox.com>

Declare that we support remote invalidation in case we are:
1. using fastreg method
2. always registering memory

Detect the invalidated rkey from the work completion info so we
won't invalidate it locally. The spec mandates that we must not rely
on the target remote invalidate our rkey so we must check it upon
a receive (scsi response) completion.

Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  5 ++-
 drivers/infiniband/ulp/iser/iser_initiator.c | 59 +++++++++++++++++++++++++++-
 drivers/infiniband/ulp/iser/iser_memory.c    |  4 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     | 21 +++++++---
 4 files changed, 80 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index c79fdba6f969..e399d9a49df2 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -358,6 +358,7 @@ struct iser_reg_ops {
  *                 cpus and device max completion vectors
  * @comps:         Dinamically allocated array of completion handlers
  * @reg_ops:       Registration ops
+ * @remote_inv_sup: Remote invalidate is supported on this device
  */
 struct iser_device {
 	struct ib_device             *ib_device;
@@ -370,6 +371,7 @@ struct iser_device {
 	int			     comps_used;
 	struct iser_comp	     *comps;
 	struct iser_reg_ops          *reg_ops;
+	bool                         remote_inv_sup;
 };
 
 #define ISER_CHECK_GUARD	0xc0
@@ -519,6 +521,7 @@ struct iser_conn {
 	u32                          num_rx_descs;
 	unsigned short               scsi_sg_tablesize;
 	unsigned int                 scsi_max_sectors;
+	bool			     snd_w_inv;
 };
 
 /**
@@ -602,7 +605,7 @@ int iser_conn_terminate(struct iser_conn *iser_conn);
 void iser_release_work(struct work_struct *work);
 
 void iser_rcv_completion(struct iser_rx_desc *desc,
-			 unsigned long dto_xfer_len,
+			 struct ib_wc *wc,
 			 struct ib_conn *ib_conn);
 
 void iser_snd_completion(struct iser_tx_desc *desc,
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 6a968e350c14..cd12f89b3365 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -563,11 +563,61 @@ send_control_error:
 	return err;
 }
 
+static inline void
+iser_inv_desc(struct iser_fr_desc *desc, u32 rkey)
+{
+	if (likely(rkey == desc->rsc.mr->rkey))
+		desc->rsc.mr_valid = 0;
+	else if (likely(rkey == desc->pi_ctx->sig_mr->rkey))
+		desc->pi_ctx->sig_mr_valid = 0;
+}
+
+static int
+iser_check_remote_inv(struct iser_conn *iser_conn,
+		      struct ib_wc *wc,
+		      struct iscsi_hdr *hdr)
+{
+	if (wc->wc_flags & IB_WC_WITH_INVALIDATE) {
+		struct iscsi_task *task;
+		u32 rkey = wc->ex.invalidate_rkey;
+
+		iser_dbg("conn %p: remote invalidation for rkey %#x\n",
+			 iser_conn, rkey);
+
+		if (unlikely(!iser_conn->snd_w_inv)) {
+			iser_err("conn %p: unexepected remote invalidation, "
+				 "terminating connection\n", iser_conn);
+			return -EPROTO;
+		}
+
+		task = iscsi_itt_to_ctask(iser_conn->iscsi_conn, hdr->itt);
+		if (likely(task)) {
+			struct iscsi_iser_task *iser_task = task->dd_data;
+			struct iser_fr_desc *desc;
+
+			if (iser_task->dir[ISER_DIR_IN]) {
+				desc = iser_task->rdma_reg[ISER_DIR_IN].mem_h;
+				iser_inv_desc(desc, rkey);
+			}
+
+			if (iser_task->dir[ISER_DIR_OUT]) {
+				desc = iser_task->rdma_reg[ISER_DIR_OUT].mem_h;
+				iser_inv_desc(desc, rkey);
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
@@ -575,6 +625,7 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	struct iscsi_hdr *hdr;
 	u64 rx_dma;
 	int rx_buflen, outstanding, count, err;
+	unsigned long rx_xfer_len = wc->byte_len;
 
 	/* differentiate between login to all other PDUs */
 	if ((char *)rx_desc == iser_conn->login_resp_buf) {
@@ -593,6 +644,12 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
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
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index c008fc262aee..8a57d4eadda6 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -76,10 +76,10 @@ int iser_assign_reg_ops(struct iser_device *device)
 	    device->ib_device->map_phys_fmr && device->ib_device->unmap_fmr) {
 		iser_info("FMR supported, using FMR for registration\n");
 		device->reg_ops = &fmr_ops;
-	} else
-	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
+	} else if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
 		iser_info("FastReg supported, using FastReg for registration\n");
 		device->reg_ops = &fastreg_ops;
+		device->remote_inv_sup = iser_always_reg;
 	} else {
 		iser_err("IB device does not support FMRs nor FastRegs, can't register memory\n");
 		return -1;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 9ba5214f0e02..8d25c503d32b 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -847,7 +847,9 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
 	conn_param.rnr_retry_count     = 6;
 
 	memset(&req_hdr, 0, sizeof(req_hdr));
-	req_hdr.flags = (ISER_ZBVA_NOT_SUP | ISER_SEND_W_INV_NOT_SUP);
+	req_hdr.flags = ISER_ZBVA_NOT_SUP;
+	if (!device->remote_inv_sup)
+		req_hdr.flags |= ISER_SEND_W_INV_NOT_SUP;
 	conn_param.private_data	= (void *)&req_hdr;
 	conn_param.private_data_len = sizeof(struct iser_cm_hdr);
 
@@ -862,7 +864,8 @@ failure:
 	iser_connect_error(cma_id);
 }
 
-static void iser_connected_handler(struct rdma_cm_id *cma_id)
+static void iser_connected_handler(struct rdma_cm_id *cma_id,
+				   const void *private_data)
 {
 	struct iser_conn *iser_conn;
 	struct ib_qp_attr attr;
@@ -876,6 +879,15 @@ static void iser_connected_handler(struct rdma_cm_id *cma_id)
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
@@ -927,7 +939,7 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 		iser_route_handler(cma_id);
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
-		iser_connected_handler(cma_id);
+		iser_connected_handler(cma_id, event->param.conn.private_data);
 		break;
 	case RDMA_CM_EVENT_ADDR_ERROR:
 	case RDMA_CM_EVENT_ROUTE_ERROR:
@@ -1205,8 +1217,7 @@ static void iser_handle_wc(struct ib_wc *wc)
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

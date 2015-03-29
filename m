From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 03/18] iser-target: Use a single DMA MR and PD per device
Date: Sun, 29 Mar 2015 15:52:05 +0300
Message-ID: <1427633540-30352-4-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This is to favor the HCA cache hit rate using less MRs
and PDs. This commit partially reverts commit:
"eb6ab13 IB/isert: separate connection protection domains and dma MRs"

At the time I thought this would be needed.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   99 ++++++++++++++++--------------
 drivers/infiniband/ulp/isert/ib_isert.h |    4 +-
 2 files changed, 55 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 147029a..506c2eb 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -149,7 +149,7 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
 	if (device->pi_capable)
 		attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
 
-	ret = rdma_create_qp(cma_id, isert_conn->conn_pd, &attr);
+	ret = rdma_create_qp(cma_id, device->pd, &attr);
 	if (ret) {
 		isert_err("rdma_create_qp failed for cma_id %d\n", ret);
 		goto err;
@@ -174,7 +174,8 @@ isert_cq_event_callback(struct ib_event *e, void *context)
 static int
 isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_device *device = isert_conn->conn_device;
+	struct ib_device *ib_dev = device->ib_device;
 	struct iser_rx_desc *rx_desc;
 	struct ib_sge *rx_sg;
 	u64 dma_addr;
@@ -198,7 +199,7 @@ isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 		rx_sg = &rx_desc->rx_sg;
 		rx_sg->addr = rx_desc->dma_addr;
 		rx_sg->length = ISER_RX_PAYLOAD_SIZE;
-		rx_sg->lkey = isert_conn->conn_mr->lkey;
+		rx_sg->lkey = device->mr->lkey;
 	}
 
 	isert_conn->conn_rx_desc_head = 0;
@@ -309,8 +310,27 @@ isert_create_device_ib_res(struct isert_device *device)
 			goto out_cq;
 	}
 
+	device->pd = ib_alloc_pd(device->ib_device);
+	if (IS_ERR(device->pd)) {
+		ret = PTR_ERR(device->pd);
+		isert_err("failed to allocate pd, device %p, ret=%d\n",
+			  device, ret);
+		goto out_cq;
+	}
+
+	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(device->mr)) {
+		ret = PTR_ERR(device->mr);
+		isert_err("failed to create dma mr, device %p, ret=%d\n",
+			  device, ret);
+		goto out_mr;
+	}
+
+
 	return 0;
 
+out_mr:
+	ib_dealloc_pd(device->pd);
 out_cq:
 	for (i = 0; i < device->comps_used; i++) {
 		struct isert_comp *comp = &device->comps[i];
@@ -332,6 +352,8 @@ isert_free_device_ib_res(struct isert_device *device)
 
 	isert_info("device %p\n", device);
 
+	ib_dereg_mr(device->mr);
+	ib_dealloc_pd(device->pd);
 	for (i = 0; i < device->comps_used; i++) {
 		struct isert_comp *comp = &device->comps[i];
 
@@ -547,7 +569,7 @@ isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
 		}
 
 		ret = isert_create_fr_desc(device->ib_device,
-					   isert_conn->conn_pd, fr_desc);
+					   device->pd, fr_desc);
 		if (ret) {
 			isert_err("Failed to create fastreg descriptor err=%d\n",
 			       ret);
@@ -659,22 +681,6 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	isert_dbg("Using initiator_depth: %u\n", isert_conn->initiator_depth);
 
 	isert_conn->conn_device = device;
-	isert_conn->conn_pd = ib_alloc_pd(isert_conn->conn_device->ib_device);
-	if (IS_ERR(isert_conn->conn_pd)) {
-		ret = PTR_ERR(isert_conn->conn_pd);
-		isert_err("ib_alloc_pd failed for conn %p: ret=%d\n",
-		       isert_conn, ret);
-		goto out_pd;
-	}
-
-	isert_conn->conn_mr = ib_get_dma_mr(isert_conn->conn_pd,
-					   IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(isert_conn->conn_mr)) {
-		ret = PTR_ERR(isert_conn->conn_mr);
-		isert_err("ib_get_dma_mr failed for conn %p: ret=%d\n",
-		       isert_conn, ret);
-		goto out_mr;
-	}
 
 	ret = isert_conn_setup_qp(isert_conn, cma_id);
 	if (ret)
@@ -697,10 +703,6 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	return 0;
 
 out_conn_dev:
-	ib_dereg_mr(isert_conn->conn_mr);
-out_mr:
-	ib_dealloc_pd(isert_conn->conn_pd);
-out_pd:
 	isert_device_try_release(device);
 out_rsp_dma_map:
 	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
@@ -742,9 +744,6 @@ isert_connect_release(struct isert_conn *isert_conn)
 		ib_destroy_qp(isert_conn->conn_qp);
 	}
 
-	ib_dereg_mr(isert_conn->conn_mr);
-	ib_dealloc_pd(isert_conn->conn_pd);
-
 	if (isert_conn->login_buf) {
 		ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
 				    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
@@ -988,7 +987,8 @@ isert_create_send_desc(struct isert_conn *isert_conn,
 		       struct isert_cmd *isert_cmd,
 		       struct iser_tx_desc *tx_desc)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_device *device = isert_conn->conn_device;
+	struct ib_device *ib_dev = device->ib_device;
 
 	ib_dma_sync_single_for_cpu(ib_dev, tx_desc->dma_addr,
 				   ISER_HEADERS_LEN, DMA_TO_DEVICE);
@@ -999,8 +999,8 @@ isert_create_send_desc(struct isert_conn *isert_conn,
 	tx_desc->num_sge = 1;
 	tx_desc->isert_cmd = isert_cmd;
 
-	if (tx_desc->tx_sg[0].lkey != isert_conn->conn_mr->lkey) {
-		tx_desc->tx_sg[0].lkey = isert_conn->conn_mr->lkey;
+	if (tx_desc->tx_sg[0].lkey != device->mr->lkey) {
+		tx_desc->tx_sg[0].lkey = device->mr->lkey;
 		isert_dbg("tx_desc %p lkey mismatch, fixing\n", tx_desc);
 	}
 }
@@ -1009,7 +1009,8 @@ static int
 isert_init_tx_hdrs(struct isert_conn *isert_conn,
 		   struct iser_tx_desc *tx_desc)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_device *device = isert_conn->conn_device;
+	struct ib_device *ib_dev = device->ib_device;
 	u64 dma_addr;
 
 	dma_addr = ib_dma_map_single(ib_dev, (void *)tx_desc,
@@ -1022,7 +1023,7 @@ isert_init_tx_hdrs(struct isert_conn *isert_conn,
 	tx_desc->dma_addr = dma_addr;
 	tx_desc->tx_sg[0].addr	= tx_desc->dma_addr;
 	tx_desc->tx_sg[0].length = ISER_HEADERS_LEN;
-	tx_desc->tx_sg[0].lkey = isert_conn->conn_mr->lkey;
+	tx_desc->tx_sg[0].lkey = device->mr->lkey;
 
 	isert_dbg("Setup tx_sg[0].addr: 0x%llx length: %u lkey: 0x%x\n",
 		  tx_desc->tx_sg[0].addr, tx_desc->tx_sg[0].length,
@@ -1055,7 +1056,7 @@ isert_rdma_post_recvl(struct isert_conn *isert_conn)
 	memset(&sge, 0, sizeof(struct ib_sge));
 	sge.addr = isert_conn->login_req_dma;
 	sge.length = ISER_RX_LOGIN_SIZE;
-	sge.lkey = isert_conn->conn_mr->lkey;
+	sge.lkey = isert_conn->conn_device->mr->lkey;
 
 	isert_dbg("Setup sge: addr: %llx length: %d 0x%08x\n",
 		sge.addr, sge.length, sge.lkey);
@@ -1080,7 +1081,8 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 		   u32 length)
 {
 	struct isert_conn *isert_conn = conn->context;
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_device *device = isert_conn->conn_device;
+	struct ib_device *ib_dev = device->ib_device;
 	struct iser_tx_desc *tx_desc = &isert_conn->conn_login_tx_desc;
 	int ret;
 
@@ -1104,7 +1106,7 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 
 		tx_dsg->addr	= isert_conn->login_rsp_dma;
 		tx_dsg->length	= length;
-		tx_dsg->lkey	= isert_conn->conn_mr->lkey;
+		tx_dsg->lkey	= isert_conn->conn_device->mr->lkey;
 		tx_desc->num_sge = 2;
 	}
 	if (!login->login_failed) {
@@ -2103,7 +2105,8 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	if (cmd->se_cmd.sense_buffer &&
 	    ((cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
 	    (cmd->se_cmd.se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
-		struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+		struct isert_device *device = isert_conn->conn_device;
+		struct ib_device *ib_dev = device->ib_device;
 		struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
 		u32 padding, pdu_len;
 
@@ -2122,7 +2125,7 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_cmd->pdu_buf_len = pdu_len;
 		tx_dsg->addr	= isert_cmd->pdu_buf_dma;
 		tx_dsg->length	= pdu_len;
-		tx_dsg->lkey	= isert_conn->conn_mr->lkey;
+		tx_dsg->lkey	= device->mr->lkey;
 		isert_cmd->tx_desc.num_sge = 2;
 	}
 
@@ -2233,7 +2236,8 @@ isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_device *device = isert_conn->conn_device;
+	struct ib_device *ib_dev = device->ib_device;
 	struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
 	struct iscsi_reject *hdr =
 		(struct iscsi_reject *)&isert_cmd->tx_desc.iscsi_header;
@@ -2249,7 +2253,7 @@ isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	isert_cmd->pdu_buf_len = ISCSI_HDR_LEN;
 	tx_dsg->addr	= isert_cmd->pdu_buf_dma;
 	tx_dsg->length	= ISCSI_HDR_LEN;
-	tx_dsg->lkey	= isert_conn->conn_mr->lkey;
+	tx_dsg->lkey	= device->mr->lkey;
 	isert_cmd->tx_desc.num_sge = 2;
 
 	isert_init_send_wr(isert_conn, isert_cmd, send_wr);
@@ -2279,7 +2283,8 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 
 	if (txt_rsp_len) {
-		struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+		struct isert_device *device = isert_conn->conn_device;
+		struct ib_device *ib_dev = device->ib_device;
 		struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
 		void *txt_rsp_buf = cmd->buf_ptr;
 
@@ -2289,7 +2294,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 		isert_cmd->pdu_buf_len = txt_rsp_len;
 		tx_dsg->addr	= isert_cmd->pdu_buf_dma;
 		tx_dsg->length	= txt_rsp_len;
-		tx_dsg->lkey	= isert_conn->conn_mr->lkey;
+		tx_dsg->lkey	= device->mr->lkey;
 		isert_cmd->tx_desc.num_sge = 2;
 	}
 	isert_init_send_wr(isert_conn, isert_cmd, send_wr);
@@ -2306,7 +2311,8 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 {
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct scatterlist *sg_start, *tmp_sg;
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_device *device = isert_conn->conn_device;
+	struct ib_device *ib_dev = device->ib_device;
 	u32 sg_off, page_off;
 	int i = 0, sg_nents;
 
@@ -2330,7 +2336,7 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 		ib_sge->addr = ib_sg_dma_address(ib_dev, tmp_sg) + page_off;
 		ib_sge->length = min_t(u32, data_left,
 				ib_sg_dma_len(ib_dev, tmp_sg) - page_off);
-		ib_sge->lkey = isert_conn->conn_mr->lkey;
+		ib_sge->lkey = device->mr->lkey;
 
 		isert_dbg("RDMA ib_sge: addr: 0x%llx  length: %u lkey: %x\n",
 			  ib_sge->addr, ib_sge->length, ib_sge->lkey);
@@ -2491,7 +2497,8 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 		  enum isert_indicator ind,
 		  struct ib_sge *sge)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_device *device = isert_conn->conn_device;
+	struct ib_device *ib_dev = device->ib_device;
 	struct ib_mr *mr;
 	struct ib_fast_reg_page_list *frpl;
 	struct ib_send_wr fr_wr, inv_wr;
@@ -2500,7 +2507,7 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	u32 page_off;
 
 	if (mem->dma_nents == 1) {
-		sge->lkey = isert_conn->conn_mr->lkey;
+		sge->lkey = device->mr->lkey;
 		sge->addr = ib_sg_dma_address(ib_dev, &mem->sg[0]);
 		sge->length = ib_sg_dma_len(ib_dev, &mem->sg[0]);
 		isert_dbg("sge: addr: 0x%llx  length: %u lkey: %x\n",
@@ -2698,7 +2705,7 @@ isert_handle_prot_cmd(struct isert_conn *isert_conn,
 	if (!wr->fr_desc->pi_ctx) {
 		ret = isert_create_pi_ctx(wr->fr_desc,
 					  device->ib_device,
-					  isert_conn->conn_pd);
+					  device->pd);
 		if (ret) {
 			isert_err("conn %p failed to allocate pi_ctx\n",
 				  isert_conn);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 8dc8415..e386092 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -169,8 +169,6 @@ struct isert_conn {
 	struct completion	login_req_comp;
 	struct iser_tx_desc	conn_login_tx_desc;
 	struct rdma_cm_id	*conn_cm_id;
-	struct ib_pd		*conn_pd;
-	struct ib_mr		*conn_mr;
 	struct ib_qp		*conn_qp;
 	struct isert_device	*conn_device;
 	struct mutex		conn_mutex;
@@ -211,6 +209,8 @@ struct isert_device {
 	bool			pi_capable;
 	int			refcount;
 	struct ib_device	*ib_device;
+	struct ib_pd		*pd;
+	struct ib_mr		*mr;
 	struct isert_comp	*comps;
 	int                     comps_used;
 	struct list_head	dev_node;
-- 
1.7.1

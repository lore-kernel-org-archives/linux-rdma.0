From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 18/26] IB/isert: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:10 -0800
Message-ID: <20170112190718.6728-19-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 120 +++++++++++++++++---------------
 1 file changed, 63 insertions(+), 57 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 314e95516068..ca919d472bd5 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -189,9 +189,10 @@ isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 	rx_desc = isert_conn->rx_descs;
 
 	for (i = 0; i < ISERT_QP_MAX_RECV_DTOS; i++, rx_desc++)  {
-		dma_addr = ib_dma_map_single(ib_dev, (void *)rx_desc,
-					ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
-		if (ib_dma_mapping_error(ib_dev, dma_addr))
+		dma_addr = dma_map_single(ib_dev->dma_device, rx_desc,
+					  ISER_RX_PAYLOAD_SIZE,
+					  DMA_FROM_DEVICE);
+		if (dma_mapping_error(ib_dev->dma_device, dma_addr))
 			goto dma_map_fail;
 
 		rx_desc->dma_addr = dma_addr;
@@ -208,8 +209,8 @@ isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 dma_map_fail:
 	rx_desc = isert_conn->rx_descs;
 	for (j = 0; j < i; j++, rx_desc++) {
-		ib_dma_unmap_single(ib_dev, rx_desc->dma_addr,
-				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_single(ib_dev->dma_device, rx_desc->dma_addr,
+				 ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 	}
 	kfree(isert_conn->rx_descs);
 	isert_conn->rx_descs = NULL;
@@ -229,8 +230,8 @@ isert_free_rx_descriptors(struct isert_conn *isert_conn)
 
 	rx_desc = isert_conn->rx_descs;
 	for (i = 0; i < ISERT_QP_MAX_RECV_DTOS; i++, rx_desc++)  {
-		ib_dma_unmap_single(ib_dev, rx_desc->dma_addr,
-				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_single(ib_dev->dma_device, rx_desc->dma_addr,
+				 ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 	}
 
 	kfree(isert_conn->rx_descs);
@@ -410,13 +411,12 @@ isert_free_login_buf(struct isert_conn *isert_conn)
 {
 	struct ib_device *ib_dev = isert_conn->device->ib_device;
 
-	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
-			    ISER_RX_PAYLOAD_SIZE, DMA_TO_DEVICE);
+	dma_unmap_single(ib_dev->dma_device, isert_conn->login_rsp_dma,
+			 ISER_RX_PAYLOAD_SIZE, DMA_TO_DEVICE);
 	kfree(isert_conn->login_rsp_buf);
 
-	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
-			    ISER_RX_PAYLOAD_SIZE,
-			    DMA_FROM_DEVICE);
+	dma_unmap_single(ib_dev->dma_device, isert_conn->login_req_dma,
+			 ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 	kfree(isert_conn->login_req_buf);
 }
 
@@ -431,10 +431,11 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 	if (!isert_conn->login_req_buf)
 		return -ENOMEM;
 
-	isert_conn->login_req_dma = ib_dma_map_single(ib_dev,
-				isert_conn->login_req_buf,
-				ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
-	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_req_dma);
+	isert_conn->login_req_dma = dma_map_single(ib_dev->dma_device,
+						   isert_conn->login_req_buf,
+						   ISER_RX_PAYLOAD_SIZE,
+						   DMA_FROM_DEVICE);
+	ret = dma_mapping_error(ib_dev->dma_device, isert_conn->login_req_dma);
 	if (ret) {
 		isert_err("login_req_dma mapping error: %d\n", ret);
 		isert_conn->login_req_dma = 0;
@@ -447,10 +448,11 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 		goto out_unmap_login_req_buf;
 	}
 
-	isert_conn->login_rsp_dma = ib_dma_map_single(ib_dev,
-					isert_conn->login_rsp_buf,
-					ISER_RX_PAYLOAD_SIZE, DMA_TO_DEVICE);
-	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_rsp_dma);
+	isert_conn->login_rsp_dma = dma_map_single(ib_dev->dma_device,
+						   isert_conn->login_rsp_buf,
+						   ISER_RX_PAYLOAD_SIZE,
+						   DMA_TO_DEVICE);
+	ret = dma_mapping_error(ib_dev->dma_device, isert_conn->login_rsp_dma);
 	if (ret) {
 		isert_err("login_rsp_dma mapping error: %d\n", ret);
 		isert_conn->login_rsp_dma = 0;
@@ -462,8 +464,8 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 out_free_login_rsp_buf:
 	kfree(isert_conn->login_rsp_buf);
 out_unmap_login_req_buf:
-	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
-			    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+	dma_unmap_single(ib_dev->dma_device, isert_conn->login_req_dma,
+			 ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 out_free_login_req_buf:
 	kfree(isert_conn->login_req_buf);
 	return ret;
@@ -854,8 +856,8 @@ isert_login_post_send(struct isert_conn *isert_conn, struct iser_tx_desc *tx_des
 	struct ib_send_wr send_wr, *send_wr_failed;
 	int ret;
 
-	ib_dma_sync_single_for_device(ib_dev, tx_desc->dma_addr,
-				      ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	dma_sync_single_for_device(ib_dev->dma_device, tx_desc->dma_addr,
+				   ISER_HEADERS_LEN, DMA_TO_DEVICE);
 
 	tx_desc->tx_cqe.done = isert_login_send_done;
 
@@ -881,8 +883,8 @@ isert_create_send_desc(struct isert_conn *isert_conn,
 	struct isert_device *device = isert_conn->device;
 	struct ib_device *ib_dev = device->ib_device;
 
-	ib_dma_sync_single_for_cpu(ib_dev, tx_desc->dma_addr,
-				   ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(ib_dev->dma_device, tx_desc->dma_addr,
+				ISER_HEADERS_LEN, DMA_TO_DEVICE);
 
 	memset(&tx_desc->iser_header, 0, sizeof(struct iser_ctrl));
 	tx_desc->iser_header.flags = ISCSI_CTRL;
@@ -903,10 +905,10 @@ isert_init_tx_hdrs(struct isert_conn *isert_conn,
 	struct ib_device *ib_dev = device->ib_device;
 	u64 dma_addr;
 
-	dma_addr = ib_dma_map_single(ib_dev, (void *)tx_desc,
-			ISER_HEADERS_LEN, DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(ib_dev, dma_addr)) {
-		isert_err("ib_dma_mapping_error() failed\n");
+	dma_addr = dma_map_single(ib_dev->dma_device, (void *)tx_desc,
+				  ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	if (dma_mapping_error(ib_dev->dma_device, dma_addr)) {
+		isert_err("dma_mapping_error() failed\n");
 		return -ENOMEM;
 	}
 
@@ -992,13 +994,15 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 	if (length > 0) {
 		struct ib_sge *tx_dsg = &tx_desc->tx_sg[1];
 
-		ib_dma_sync_single_for_cpu(ib_dev, isert_conn->login_rsp_dma,
-					   length, DMA_TO_DEVICE);
+		dma_sync_single_for_cpu(ib_dev->dma_device,
+					isert_conn->login_rsp_dma,
+					length, DMA_TO_DEVICE);
 
 		memcpy(isert_conn->login_rsp_buf, login->rsp_buf, length);
 
-		ib_dma_sync_single_for_device(ib_dev, isert_conn->login_rsp_dma,
-					      length, DMA_TO_DEVICE);
+		dma_sync_single_for_device(ib_dev->dma_device,
+					   isert_conn->login_rsp_dma,
+					   length, DMA_TO_DEVICE);
 
 		tx_dsg->addr	= isert_conn->login_rsp_dma;
 		tx_dsg->length	= length;
@@ -1397,8 +1401,8 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
-	ib_dma_sync_single_for_cpu(ib_dev, rx_desc->dma_addr,
-			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(ib_dev->dma_device, rx_desc->dma_addr,
+				ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 
 	isert_dbg("DMA: 0x%llx, iSCSI opcode: 0x%02x, ITT: 0x%08x, flags: 0x%02x dlen: %d\n",
 		 rx_desc->dma_addr, hdr->opcode, hdr->itt, hdr->flags,
@@ -1432,8 +1436,8 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	isert_rx_opcode(isert_conn, rx_desc,
 			read_stag, read_va, write_stag, write_va);
 
-	ib_dma_sync_single_for_device(ib_dev, rx_desc->dma_addr,
-			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(ib_dev->dma_device, rx_desc->dma_addr,
+				   ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 }
 
 static void
@@ -1447,8 +1451,8 @@ isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
-	ib_dma_sync_single_for_cpu(ib_dev, isert_conn->login_req_dma,
-			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(ib_dev->dma_device, isert_conn->login_req_dma,
+				ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 
 	isert_conn->login_req_len = wc->byte_len - ISER_HEADERS_LEN;
 
@@ -1463,8 +1467,9 @@ isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	complete(&isert_conn->login_req_comp);
 	mutex_unlock(&isert_conn->mutex);
 
-	ib_dma_sync_single_for_device(ib_dev, isert_conn->login_req_dma,
-				ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(ib_dev->dma_device,
+				   isert_conn->login_req_dma,
+				   ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 }
 
 static void
@@ -1571,8 +1576,8 @@ isert_unmap_tx_desc(struct iser_tx_desc *tx_desc, struct ib_device *ib_dev)
 {
 	if (tx_desc->dma_addr != 0) {
 		isert_dbg("unmap single for tx_desc->dma_addr\n");
-		ib_dma_unmap_single(ib_dev, tx_desc->dma_addr,
-				    ISER_HEADERS_LEN, DMA_TO_DEVICE);
+		dma_unmap_single(ib_dev->dma_device, tx_desc->dma_addr,
+				 ISER_HEADERS_LEN, DMA_TO_DEVICE);
 		tx_desc->dma_addr = 0;
 	}
 }
@@ -1583,8 +1588,8 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
 {
 	if (isert_cmd->pdu_buf_dma != 0) {
 		isert_dbg("unmap single for isert_cmd->pdu_buf_dma\n");
-		ib_dma_unmap_single(ib_dev, isert_cmd->pdu_buf_dma,
-				    isert_cmd->pdu_buf_len, DMA_TO_DEVICE);
+		dma_unmap_single(ib_dev->dma_device, isert_cmd->pdu_buf_dma,
+				 isert_cmd->pdu_buf_len, DMA_TO_DEVICE);
 		isert_cmd->pdu_buf_dma = 0;
 	}
 
@@ -1841,10 +1846,10 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		hton24(hdr->dlength, (u32)cmd->se_cmd.scsi_sense_length);
 		pdu_len = cmd->se_cmd.scsi_sense_length + padding;
 
-		isert_cmd->pdu_buf_dma = ib_dma_map_single(ib_dev,
-				(void *)cmd->sense_buffer, pdu_len,
-				DMA_TO_DEVICE);
-		if (ib_dma_mapping_error(ib_dev, isert_cmd->pdu_buf_dma))
+		isert_cmd->pdu_buf_dma = dma_map_single(ib_dev->dma_device,
+							cmd->sense_buffer,
+							pdu_len, DMA_TO_DEVICE);
+		if (dma_mapping_error(ib_dev->dma_device, isert_cmd->pdu_buf_dma))
 			return -ENOMEM;
 
 		isert_cmd->pdu_buf_len = pdu_len;
@@ -1970,10 +1975,10 @@ isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 
 	hton24(hdr->dlength, ISCSI_HDR_LEN);
-	isert_cmd->pdu_buf_dma = ib_dma_map_single(ib_dev,
-			(void *)cmd->buf_ptr, ISCSI_HDR_LEN,
-			DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(ib_dev, isert_cmd->pdu_buf_dma))
+	isert_cmd->pdu_buf_dma = dma_map_single(ib_dev->dma_device,
+						cmd->buf_ptr, ISCSI_HDR_LEN,
+						DMA_TO_DEVICE);
+	if (dma_mapping_error(ib_dev->dma_device, isert_cmd->pdu_buf_dma))
 		return -ENOMEM;
 	isert_cmd->pdu_buf_len = ISCSI_HDR_LEN;
 	tx_dsg->addr	= isert_cmd->pdu_buf_dma;
@@ -2013,9 +2018,10 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 		struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
 		void *txt_rsp_buf = cmd->buf_ptr;
 
-		isert_cmd->pdu_buf_dma = ib_dma_map_single(ib_dev,
-				txt_rsp_buf, txt_rsp_len, DMA_TO_DEVICE);
-		if (ib_dma_mapping_error(ib_dev, isert_cmd->pdu_buf_dma))
+		isert_cmd->pdu_buf_dma =
+			dma_map_single(ib_dev->dma_device, txt_rsp_buf,
+				       txt_rsp_len, DMA_TO_DEVICE);
+		if (dma_mapping_error(ib_dev->dma_device, isert_cmd->pdu_buf_dma))
 			return -ENOMEM;
 
 		isert_cmd->pdu_buf_len = txt_rsp_len;
-- 
2.11.0

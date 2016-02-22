From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] IB/isert: Split and properly type the login buffer
Date: Mon, 22 Feb 2016 14:49:15 +0100
Message-ID: <1456148958-27973-3-git-send-email-hch@lst.de>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456148958-27973-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The login receive buffer is used as a iser_rx_desc, so type it as such
in struct isert_conn and allocate the exactly right space for it.  The
TX buffer is moved to a separate variable and properly sized as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 56 ++++++++++++++++-----------------
 drivers/infiniband/ulp/isert/ib_isert.h |  3 +-
 2 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 4dbb4a9..cd74195 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -597,10 +597,12 @@ isert_free_login_buf(struct isert_conn *isert_conn)
 
 	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
 			    ISER_RX_PAYLOAD_SIZE, DMA_TO_DEVICE);
+	kfree(isert_conn->login_rsp_buf);
+
 	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
-			    ISCSI_DEF_MAX_RECV_SEG_LEN,
+			    ISER_RX_PAYLOAD_SIZE,
 			    DMA_FROM_DEVICE);
-	kfree(isert_conn->login_buf);
+	kfree(isert_conn->login_req_buf);
 }
 
 static int
@@ -609,50 +611,48 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 {
 	int ret;
 
-	isert_conn->login_buf = kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
-					ISER_RX_PAYLOAD_SIZE, GFP_KERNEL);
-	if (!isert_conn->login_buf) {
+	isert_conn->login_req_buf = kzalloc(sizeof(*isert_conn->login_req_buf),
+			GFP_KERNEL);
+	if (!isert_conn->login_req_buf) {
 		isert_err("Unable to allocate isert_conn->login_buf\n");
 		return -ENOMEM;
 	}
 
-	isert_conn->login_req_buf = isert_conn->login_buf;
-	isert_conn->login_rsp_buf = isert_conn->login_buf +
-				    ISCSI_DEF_MAX_RECV_SEG_LEN;
-
-	isert_dbg("Set login_buf: %p login_req_buf: %p login_rsp_buf: %p\n",
-		 isert_conn->login_buf, isert_conn->login_req_buf,
-		 isert_conn->login_rsp_buf);
-
 	isert_conn->login_req_dma = ib_dma_map_single(ib_dev,
-				(void *)isert_conn->login_req_buf,
-				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_FROM_DEVICE);
-
+				isert_conn->login_req_buf,
+				ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_req_dma);
 	if (ret) {
 		isert_err("login_req_dma mapping error: %d\n", ret);
 		isert_conn->login_req_dma = 0;
-		goto out_login_buf;
+		goto out_free_login_req_buf;
+	}
+
+	isert_conn->login_rsp_buf = kzalloc(ISER_RX_PAYLOAD_SIZE, GFP_KERNEL);
+	if (!isert_conn->login_rsp_buf) {
+		isert_err("Unable to allocate isert_conn->login_rspbuf\n");
+		goto out_unmap_login_req_buf;
 	}
 
 	isert_conn->login_rsp_dma = ib_dma_map_single(ib_dev,
-					(void *)isert_conn->login_rsp_buf,
+					isert_conn->login_rsp_buf,
 					ISER_RX_PAYLOAD_SIZE, DMA_TO_DEVICE);
-
 	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_rsp_dma);
 	if (ret) {
 		isert_err("login_rsp_dma mapping error: %d\n", ret);
 		isert_conn->login_rsp_dma = 0;
-		goto out_req_dma_map;
+		goto out_free_login_rsp_buf;
 	}
 
 	return 0;
 
-out_req_dma_map:
+out_free_login_rsp_buf:
+	kfree(isert_conn->login_rsp_buf);
+out_unmap_login_req_buf:
 	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
-			    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_FROM_DEVICE);
-out_login_buf:
-	kfree(isert_conn->login_buf);
+			    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+out_free_login_req_buf:
+	kfree(isert_conn->login_req_buf);
 	return ret;
 }
 
@@ -773,7 +773,7 @@ isert_connect_release(struct isert_conn *isert_conn)
 		ib_destroy_qp(isert_conn->qp);
 	}
 
-	if (isert_conn->login_buf)
+	if (isert_conn->login_req_buf)
 		isert_free_login_buf(isert_conn);
 
 	isert_device_put(device);
@@ -1218,7 +1218,7 @@ post_send:
 static void
 isert_rx_login_req(struct isert_conn *isert_conn)
 {
-	struct iser_rx_desc *rx_desc = (void *)isert_conn->login_req_buf;
+	struct iser_rx_desc *rx_desc = isert_conn->login_req_buf;
 	int rx_buflen = isert_conn->login_req_len;
 	struct iscsi_conn *conn = isert_conn->conn;
 	struct iscsi_login *login = conn->conn_login;
@@ -1596,7 +1596,7 @@ isert_rcv_completion(struct iser_rx_desc *desc,
 	u64 rx_dma;
 	int rx_buflen;
 
-	if ((char *)desc == isert_conn->login_req_buf) {
+	if (desc == isert_conn->login_req_buf) {
 		rx_dma = isert_conn->login_req_dma;
 		rx_buflen = ISER_RX_PAYLOAD_SIZE;
 		isert_dbg("login_buf: Using rx_dma: 0x%llx, rx_buflen: %d\n",
@@ -1615,7 +1615,7 @@ isert_rcv_completion(struct iser_rx_desc *desc,
 		 hdr->opcode, hdr->itt, hdr->flags,
 		 (int)(xfer_len - ISER_HEADERS_LEN));
 
-	if ((char *)desc == isert_conn->login_req_buf) {
+	if (desc == isert_conn->login_req_buf) {
 		isert_conn->login_req_len = xfer_len - ISER_HEADERS_LEN;
 		if (isert_conn->conn) {
 			struct iscsi_login *login = isert_conn->conn->conn_login;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index bd5e9b6..1240cf8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -182,8 +182,7 @@ struct isert_conn {
 	u32			initiator_depth;
 	bool			pi_support;
 	u32			max_sge;
-	char			*login_buf;
-	char			*login_req_buf;
+	struct iser_rx_desc	*login_req_buf;
 	char			*login_rsp_buf;
 	u64			login_req_dma;
 	int			login_req_len;
-- 
2.1.4

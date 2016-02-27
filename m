From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 08/13] IB/isert: properly type the login buffer
Date: Sat, 27 Feb 2016 19:10:26 +0100
Message-ID: <1456596631-19418-9-git-send-email-hch@lst.de>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456596631-19418-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

and separate the request and the response separately, as it's not in a
performance critical path anyway.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 52 ++++++++++++++++-----------------
 drivers/infiniband/ulp/isert/ib_isert.h |  3 +-
 2 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 7c7ad3a..b3f953b 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -597,10 +597,12 @@ isert_free_login_buf(struct isert_conn *isert_conn)
 
 	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
 			    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
+	kfree(isert_conn->login_rsp_buf);
+
 	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
 			    ISCSI_DEF_MAX_RECV_SEG_LEN,
 			    DMA_FROM_DEVICE);
-	kfree(isert_conn->login_buf);
+	kfree(isert_conn->login_req_buf);
 }
 
 static int
@@ -609,50 +611,48 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 {
 	int ret;
 
-	isert_conn->login_buf = kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
-					ISER_RX_LOGIN_SIZE, GFP_KERNEL);
-	if (!isert_conn->login_buf) {
-		isert_err("Unable to allocate isert_conn->login_buf\n");
+	isert_conn->login_req_buf =
+		kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN, GFP_KERNEL);
+	if (!isert_conn->login_req_buf) {
+		isert_err("Unable to allocate isert_conn->login_req_buf\n");
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
+				isert_conn->login_req_buf,
 				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_FROM_DEVICE);
-
 	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_req_dma);
 	if (ret) {
 		isert_err("login_req_dma mapping error: %d\n", ret);
 		isert_conn->login_req_dma = 0;
-		goto out_login_buf;
+		goto out_free_login_req_buf;
+	}
+
+	isert_conn->login_rsp_buf = kzalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
+	if (!isert_conn->login_rsp_buf) {
+		isert_err("Unable to allocate isert_conn->login_rspbuf\n");
+		goto out_unmap_login_req_buf;
 	}
 
 	isert_conn->login_rsp_dma = ib_dma_map_single(ib_dev,
-					(void *)isert_conn->login_rsp_buf,
+					isert_conn->login_rsp_buf,
 					ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
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
 			    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_FROM_DEVICE);
-out_login_buf:
-	kfree(isert_conn->login_buf);
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
 		rx_buflen = ISER_RX_LOGIN_SIZE;
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
index 8d50453..1f15ff9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -184,8 +184,7 @@ struct isert_conn {
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

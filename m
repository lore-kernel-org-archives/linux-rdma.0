From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/5] IB/isert: Remove ISER_RECV_DATA_SEG_LEN
Date: Mon, 22 Feb 2016 14:49:14 +0100
Message-ID: <1456148958-27973-2-git-send-email-hch@lst.de>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456148958-27973-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is the same as ISCSI_DEF_MAX_RECV_SEG_LEN (and must be the same given
the structure layouts), so just use that constant instead.  This also
allows removing ISER_RX_LOGIN_SIZE in favor of ISER_RX_PAYLOAD_SIZE.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 10 +++++-----
 drivers/infiniband/ulp/isert/ib_isert.h |  8 +++-----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f121e61..4dbb4a9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -596,7 +596,7 @@ isert_free_login_buf(struct isert_conn *isert_conn)
 	struct ib_device *ib_dev = isert_conn->device->ib_device;
 
 	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
-			    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
+			    ISER_RX_PAYLOAD_SIZE, DMA_TO_DEVICE);
 	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
 			    ISCSI_DEF_MAX_RECV_SEG_LEN,
 			    DMA_FROM_DEVICE);
@@ -610,7 +610,7 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 	int ret;
 
 	isert_conn->login_buf = kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
-					ISER_RX_LOGIN_SIZE, GFP_KERNEL);
+					ISER_RX_PAYLOAD_SIZE, GFP_KERNEL);
 	if (!isert_conn->login_buf) {
 		isert_err("Unable to allocate isert_conn->login_buf\n");
 		return -ENOMEM;
@@ -637,7 +637,7 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 
 	isert_conn->login_rsp_dma = ib_dma_map_single(ib_dev,
 					(void *)isert_conn->login_rsp_buf,
-					ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
+					ISER_RX_PAYLOAD_SIZE, DMA_TO_DEVICE);
 
 	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_rsp_dma);
 	if (ret) {
@@ -1121,7 +1121,7 @@ isert_rdma_post_recvl(struct isert_conn *isert_conn)
 
 	memset(&sge, 0, sizeof(struct ib_sge));
 	sge.addr = isert_conn->login_req_dma;
-	sge.length = ISER_RX_LOGIN_SIZE;
+	sge.length = ISER_RX_PAYLOAD_SIZE;
 	sge.lkey = isert_conn->device->pd->local_dma_lkey;
 
 	isert_dbg("Setup sge: addr: %llx length: %d 0x%08x\n",
@@ -1598,7 +1598,7 @@ isert_rcv_completion(struct iser_rx_desc *desc,
 
 	if ((char *)desc == isert_conn->login_req_buf) {
 		rx_dma = isert_conn->login_req_dma;
-		rx_buflen = ISER_RX_LOGIN_SIZE;
+		rx_buflen = ISER_RX_PAYLOAD_SIZE;
 		isert_dbg("login_buf: Using rx_dma: 0x%llx, rx_buflen: %d\n",
 			 rx_dma, rx_buflen);
 	} else {
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 8d50453..bd5e9b6 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -36,9 +36,7 @@
 /* Constant PDU lengths calculations */
 #define ISER_HEADERS_LEN	(sizeof(struct iser_ctrl) + \
 				 sizeof(struct iscsi_hdr))
-#define ISER_RECV_DATA_SEG_LEN	8192
-#define ISER_RX_PAYLOAD_SIZE	(ISER_HEADERS_LEN + ISER_RECV_DATA_SEG_LEN)
-#define ISER_RX_LOGIN_SIZE	(ISER_HEADERS_LEN + ISCSI_DEF_MAX_RECV_SEG_LEN)
+#define ISER_RX_PAYLOAD_SIZE	(ISER_HEADERS_LEN + ISCSI_DEF_MAX_RECV_SEG_LEN)
 
 /* QP settings */
 /* Maximal bounds on received asynchronous PDUs */
@@ -62,7 +60,7 @@
 				ISERT_MAX_TX_MISC_PDUS	+ \
 				ISERT_MAX_RX_MISC_PDUS)
 
-#define ISER_RX_PAD_SIZE	(ISER_RECV_DATA_SEG_LEN + 4096 - \
+#define ISER_RX_PAD_SIZE	(ISCSI_DEF_MAX_RECV_SEG_LEN + 4096 - \
 		(ISER_RX_PAYLOAD_SIZE + sizeof(u64) + sizeof(struct ib_sge)))
 
 #define ISCSI_ISER_SG_TABLESIZE		256
@@ -92,7 +90,7 @@ enum iser_conn_state {
 struct iser_rx_desc {
 	struct iser_ctrl iser_header;
 	struct iscsi_hdr iscsi_header;
-	char		data[ISER_RECV_DATA_SEG_LEN];
+	char		data[ISCSI_DEF_MAX_RECV_SEG_LEN];
 	u64		dma_addr;
 	struct ib_sge	rx_sg;
 	char		pad[ISER_RX_PAD_SIZE];
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

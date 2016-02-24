From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 07/12] iser-target: Remove ISER_RECV_DATA_SEG_LEN
Date: Wed, 24 Feb 2016 19:24:04 +0200
Message-ID: <1456334649-21437-8-git-send-email-sagig@mellanox.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

This is the same as ISCSI_DEF_MAX_RECV_SEG_LEN (and must be the same given
the structure layouts), so just use that constant instead.  This also
allows removing ISER_RX_LOGIN_SIZE in favor of ISER_RX_PAYLOAD_SIZE.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 10 +++++-----
 drivers/infiniband/ulp/isert/ib_isert.h |  8 +++-----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 21f4f44de3ac..838d16ded772 100644
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
@@ -1122,7 +1122,7 @@ isert_rdma_post_recvl(struct isert_conn *isert_conn)
 
 	memset(&sge, 0, sizeof(struct ib_sge));
 	sge.addr = isert_conn->login_req_dma;
-	sge.length = ISER_RX_LOGIN_SIZE;
+	sge.length = ISER_RX_PAYLOAD_SIZE;
 	sge.lkey = isert_conn->device->pd->local_dma_lkey;
 
 	isert_dbg("Setup sge: addr: %llx length: %d 0x%08x\n",
@@ -1596,7 +1596,7 @@ isert_rcv_completion(struct iser_rx_desc *desc,
 
 	if ((char *)desc == isert_conn->login_req_buf) {
 		rx_dma = isert_conn->login_req_dma;
-		rx_buflen = ISER_RX_LOGIN_SIZE;
+		rx_buflen = ISER_RX_PAYLOAD_SIZE;
 		isert_dbg("login_buf: Using rx_dma: 0x%llx, rx_buflen: %d\n",
 			 rx_dma, rx_buflen);
 	} else {
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 9f916b12cf40..2ef2d6cdbe52 100644
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
@@ -93,7 +91,7 @@ enum iser_conn_state {
 struct iser_rx_desc {
 	struct iser_ctrl iser_header;
 	struct iscsi_hdr iscsi_header;
-	char		data[ISER_RECV_DATA_SEG_LEN];
+	char		data[ISCSI_DEF_MAX_RECV_SEG_LEN];
 	u64		dma_addr;
 	struct ib_sge	rx_sg;
 	char		pad[ISER_RX_PAD_SIZE];
-- 
1.8.4.3

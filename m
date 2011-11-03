From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2] ib/iser: use separate buffers for the login
 request/response
Date: Fri, 4 Nov 2011 00:19:46 +0200
Message-ID: <alpine.LRH.2.00.1111040018410.9030@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1111040013260.9030@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1111040013260.9030-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The driver counted on the transactional nature of iscsi login/text
flows and used the same buffer for both the request and the response.
We also went further and did DMA mapping only once, ala DMA_FROM_DEVICE,
which violates the DMA mapping API. Fix that by using different buffers,
one for requests and one for responses, and apply on each the correct
DMA mapping direction.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    3 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |   31 ++++++++++++++++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c     |   33 ++++++++++++++++++++-----
 3 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index db6f3ce..2982a14 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -257,7 +257,8 @@ struct iser_conn {
 	struct list_head	     conn_list;       /* entry in ig conn list */

 	char  			     *login_buf;
-	u64 			     login_dma;
+	char			     *login_req_buf, *login_resp_buf;
+	u64			     login_req_dma, login_resp_dma;
 	unsigned int 		     rx_desc_head;
 	struct iser_rx_desc	     *rx_descs;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index f299de6..a607542 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -221,8 +221,14 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn)
 	struct iser_device *device = ib_conn->device;

 	if (ib_conn->login_buf) {
-		ib_dma_unmap_single(device->ib_device, ib_conn->login_dma,
-			ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+		if (ib_conn->login_req_dma)
+			ib_dma_unmap_single(device->ib_device,
+				ib_conn->login_req_dma,
+				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+		if (ib_conn->login_resp_dma)
+			ib_dma_unmap_single(device->ib_device,
+				ib_conn->login_resp_dma,
+				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
 		kfree(ib_conn->login_buf);
 	}

@@ -394,6 +400,7 @@ int iser_send_control(struct iscsi_conn *conn,
 	unsigned long data_seg_len;
 	int err = 0;
 	struct iser_device *device;
+	struct iser_conn *ib_conn = iser_conn->ib_conn;

 	/* build the tx desc regd header and add it to the tx desc dto */
 	mdesc->type = ISCSI_TX_CONTROL;
@@ -409,9 +416,19 @@ int iser_send_control(struct iscsi_conn *conn,
 			iser_err("data present on non login task!!!\n");
 			goto send_control_error;
 		}
-		memcpy(iser_conn->ib_conn->login_buf, task->data,
+
+		ib_dma_sync_single_for_cpu(device->ib_device,
+			ib_conn->login_req_dma, task->data_count,
+			DMA_TO_DEVICE);
+
+		memcpy(iser_conn->ib_conn->login_req_buf, task->data,
 							task->data_count);
-		tx_dsg->addr    = iser_conn->ib_conn->login_dma;
+
+		ib_dma_sync_single_for_device(device->ib_device,
+			ib_conn->login_req_dma, task->data_count,
+			DMA_TO_DEVICE);
+
+		tx_dsg->addr    = iser_conn->ib_conn->login_req_dma;
 		tx_dsg->length  = task->data_count;
 		tx_dsg->lkey    = device->mr->lkey;
 		mdesc->num_sge = 2;
@@ -445,8 +462,8 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	int rx_buflen, outstanding, count, err;

 	/* differentiate between login to all other PDUs */
-	if ((char *)rx_desc == ib_conn->login_buf) {
-		rx_dma = ib_conn->login_dma;
+	if ((char *)rx_desc == ib_conn->login_resp_buf) {
+		rx_dma = ib_conn->login_resp_dma;
 		rx_buflen = ISER_RX_LOGIN_SIZE;
 	} else {
 		rx_dma = rx_desc->dma_addr;
@@ -473,7 +490,7 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	 * for the posted rx bufs refcount to become zero handles everything   */
 	conn->ib_conn->post_recv_buf_count--;

-	if (rx_dma == ib_conn->login_dma)
+	if (rx_dma == ib_conn->login_resp_dma)
 		return;

 	outstanding = ib_conn->post_recv_buf_count;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ede1475..cb8f7eb 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -155,20 +155,39 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 {
 	struct iser_device	*device;
 	struct ib_qp_init_attr	init_attr;
-	int			ret = -ENOMEM;
+	int			req_err, resp_err, ret = -ENOMEM;
 	struct ib_fmr_pool_param params;

 	BUG_ON(ib_conn->device == NULL);

 	device = ib_conn->device;

-	ib_conn->login_buf = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
+	ib_conn->login_buf = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
+					ISER_RX_LOGIN_SIZE, GFP_KERNEL);
 	if (!ib_conn->login_buf)
 		goto out_err;

-	ib_conn->login_dma = ib_dma_map_single(ib_conn->device->ib_device,
-				(void *)ib_conn->login_buf, ISER_RX_LOGIN_SIZE,
-				DMA_FROM_DEVICE);
+	ib_conn->login_req_buf  = ib_conn->login_buf;
+	ib_conn->login_resp_buf = ib_conn->login_buf + ISCSI_DEF_MAX_RECV_SEG_LEN;
+
+	ib_conn->login_req_dma = ib_dma_map_single(ib_conn->device->ib_device,
+				(void *)ib_conn->login_req_buf,
+				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+
+	ib_conn->login_resp_dma = ib_dma_map_single(ib_conn->device->ib_device,
+				(void *)ib_conn->login_resp_buf,
+				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+
+	req_err  = ib_dma_mapping_error(device->ib_device, ib_conn->login_req_dma);
+	resp_err = ib_dma_mapping_error(device->ib_device, ib_conn->login_resp_dma);
+
+	if (req_err || resp_err) {
+		if (req_err)
+			 ib_conn->login_req_dma = 0;
+		if (resp_err)
+			 ib_conn->login_resp_dma = 0;
+		goto out_err;
+	}

 	ib_conn->page_vec = kmalloc(sizeof(struct iser_page_vec) +
 				    (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE +1)),
@@ -658,11 +677,11 @@ int iser_post_recvl(struct iser_conn *ib_conn)
 	struct ib_sge	  sge;
 	int ib_ret;

-	sge.addr   = ib_conn->login_dma;
+	sge.addr   = ib_conn->login_resp_dma;
 	sge.length = ISER_RX_LOGIN_SIZE;
 	sge.lkey   = ib_conn->device->mr->lkey;

-	rx_wr.wr_id   = (unsigned long)ib_conn->login_buf;
+	rx_wr.wr_id   = (unsigned long)ib_conn->login_resp_buf;
 	rx_wr.sg_list = &sge;
 	rx_wr.num_sge = 1;
 	rx_wr.next    = NULL;
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

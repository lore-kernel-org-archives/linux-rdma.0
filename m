From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 17/26] IB/iser: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:09 -0800
Message-ID: <20170112190718.6728-18-bart.vanassche@sandisk.com>
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
 drivers/infiniband/ulp/iser/iscsi_iser.c     | 11 ++--
 drivers/infiniband/ulp/iser/iser_initiator.c | 88 +++++++++++++++-------------
 drivers/infiniband/ulp/iser/iser_memory.c    | 13 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c     |  6 +-
 4 files changed, 62 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 9104e6b8cac9..08a6875711b2 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -198,9 +198,9 @@ iser_initialize_task_headers(struct iscsi_task *task,
 		goto out;
 	}
 
-	dma_addr = ib_dma_map_single(device->ib_device, (void *)tx_desc,
-				ISER_HEADERS_LEN, DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(device->ib_device, dma_addr)) {
+	dma_addr = dma_map_single(device->ib_device->dma_device, tx_desc,
+				  ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	if (dma_mapping_error(device->ib_device->dma_device, dma_addr)) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -375,8 +375,9 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 		return;
 
 	if (likely(tx_desc->mapped)) {
-		ib_dma_unmap_single(device->ib_device, tx_desc->dma_addr,
-				    ISER_HEADERS_LEN, DMA_TO_DEVICE);
+		dma_unmap_single(device->ib_device->dma_device,
+				 tx_desc->dma_addr, ISER_HEADERS_LEN,
+				 DMA_TO_DEVICE);
 		tx_desc->mapped = false;
 	}
 
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 81ae2e30dd12..b3f01bb9a846 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -164,8 +164,9 @@ static void iser_create_send_desc(struct iser_conn	*iser_conn,
 {
 	struct iser_device *device = iser_conn->ib_conn.device;
 
-	ib_dma_sync_single_for_cpu(device->ib_device,
-		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(device->ib_device->dma_device,
+				tx_desc->dma_addr, ISER_HEADERS_LEN,
+				DMA_TO_DEVICE);
 
 	memset(&tx_desc->iser_header, 0, sizeof(struct iser_ctrl));
 	tx_desc->iser_header.flags = ISER_VER;
@@ -180,11 +181,11 @@ static void iser_free_login_buf(struct iser_conn *iser_conn)
 	if (!desc->req)
 		return;
 
-	ib_dma_unmap_single(device->ib_device, desc->req_dma,
-			    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+	dma_unmap_single(device->ib_device->dma_device, desc->req_dma,
+			 ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
 
-	ib_dma_unmap_single(device->ib_device, desc->rsp_dma,
-			    ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+	dma_unmap_single(device->ib_device->dma_device, desc->rsp_dma,
+			 ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
 
 	kfree(desc->req);
 	kfree(desc->rsp);
@@ -203,10 +204,10 @@ static int iser_alloc_login_buf(struct iser_conn *iser_conn)
 	if (!desc->req)
 		return -ENOMEM;
 
-	desc->req_dma = ib_dma_map_single(device->ib_device, desc->req,
-					  ISCSI_DEF_MAX_RECV_SEG_LEN,
-					  DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(device->ib_device,
+	desc->req_dma = dma_map_single(device->ib_device->dma_device, desc->req,
+				       ISCSI_DEF_MAX_RECV_SEG_LEN,
+				       DMA_TO_DEVICE);
+	if (dma_mapping_error(device->ib_device->dma_device,
 				desc->req_dma))
 		goto free_req;
 
@@ -214,10 +215,9 @@ static int iser_alloc_login_buf(struct iser_conn *iser_conn)
 	if (!desc->rsp)
 		goto unmap_req;
 
-	desc->rsp_dma = ib_dma_map_single(device->ib_device, desc->rsp,
-					   ISER_RX_LOGIN_SIZE,
-					   DMA_FROM_DEVICE);
-	if (ib_dma_mapping_error(device->ib_device,
+	desc->rsp_dma = dma_map_single(device->ib_device->dma_device, desc->rsp,
+				       ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(device->ib_device->dma_device,
 				desc->rsp_dma))
 		goto free_rsp;
 
@@ -226,9 +226,8 @@ static int iser_alloc_login_buf(struct iser_conn *iser_conn)
 free_rsp:
 	kfree(desc->rsp);
 unmap_req:
-	ib_dma_unmap_single(device->ib_device, desc->req_dma,
-			    ISCSI_DEF_MAX_RECV_SEG_LEN,
-			    DMA_TO_DEVICE);
+	dma_unmap_single(device->ib_device->dma_device, desc->req_dma,
+			 ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
 free_req:
 	kfree(desc->req);
 
@@ -265,9 +264,10 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 	rx_desc = iser_conn->rx_descs;
 
 	for (i = 0; i < iser_conn->qp_max_recv_dtos; i++, rx_desc++)  {
-		dma_addr = ib_dma_map_single(device->ib_device, (void *)rx_desc,
-					ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
-		if (ib_dma_mapping_error(device->ib_device, dma_addr))
+		dma_addr = dma_map_single(device->ib_device->dma_device,
+					  rx_desc, ISER_RX_PAYLOAD_SIZE,
+					  DMA_FROM_DEVICE);
+		if (dma_mapping_error(device->ib_device->dma_device, dma_addr))
 			goto rx_desc_dma_map_failed;
 
 		rx_desc->dma_addr = dma_addr;
@@ -284,8 +284,9 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 rx_desc_dma_map_failed:
 	rx_desc = iser_conn->rx_descs;
 	for (j = 0; j < i; j++, rx_desc++)
-		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
-				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_single(device->ib_device->dma_device,
+				 rx_desc->dma_addr, ISER_RX_PAYLOAD_SIZE,
+				 DMA_FROM_DEVICE);
 	kfree(iser_conn->rx_descs);
 	iser_conn->rx_descs = NULL;
 rx_desc_alloc_fail:
@@ -309,8 +310,9 @@ void iser_free_rx_descriptors(struct iser_conn *iser_conn)
 
 	rx_desc = iser_conn->rx_descs;
 	for (i = 0; i < iser_conn->qp_max_recv_dtos; i++, rx_desc++)
-		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
-				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_single(device->ib_device->dma_device,
+				 rx_desc->dma_addr, ISER_RX_PAYLOAD_SIZE,
+				 DMA_FROM_DEVICE);
 	kfree(iser_conn->rx_descs);
 	/* make sure we never redo any unmapping */
 	iser_conn->rx_descs = NULL;
@@ -522,13 +524,15 @@ int iser_send_control(struct iscsi_conn *conn,
 			goto send_control_error;
 		}
 
-		ib_dma_sync_single_for_cpu(device->ib_device, desc->req_dma,
-					   task->data_count, DMA_TO_DEVICE);
+		dma_sync_single_for_cpu(device->ib_device->dma_device,
+					desc->req_dma, task->data_count,
+					DMA_TO_DEVICE);
 
 		memcpy(desc->req, task->data, task->data_count);
 
-		ib_dma_sync_single_for_device(device->ib_device, desc->req_dma,
-					      task->data_count, DMA_TO_DEVICE);
+		dma_sync_single_for_device(device->ib_device->dma_device,
+					   desc->req_dma, task->data_count,
+					   DMA_TO_DEVICE);
 
 		tx_dsg->addr = desc->req_dma;
 		tx_dsg->length = task->data_count;
@@ -570,9 +574,9 @@ void iser_login_rsp(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
-	ib_dma_sync_single_for_cpu(ib_conn->device->ib_device,
-				   desc->rsp_dma, ISER_RX_LOGIN_SIZE,
-				   DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(ib_conn->device->ib_device->dma_device,
+				desc->rsp_dma, ISER_RX_LOGIN_SIZE,
+				DMA_FROM_DEVICE);
 
 	hdr = desc->rsp + sizeof(struct iser_ctrl);
 	data = desc->rsp + ISER_HEADERS_LEN;
@@ -583,9 +587,9 @@ void iser_login_rsp(struct ib_cq *cq, struct ib_wc *wc)
 
 	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, data, length);
 
-	ib_dma_sync_single_for_device(ib_conn->device->ib_device,
-				      desc->rsp_dma, ISER_RX_LOGIN_SIZE,
-				      DMA_FROM_DEVICE);
+	dma_sync_single_for_device(ib_conn->device->ib_device->dma_device,
+				   desc->rsp_dma, ISER_RX_LOGIN_SIZE,
+				   DMA_FROM_DEVICE);
 
 	ib_conn->post_recv_buf_count--;
 }
@@ -655,9 +659,9 @@ void iser_task_rsp(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
-	ib_dma_sync_single_for_cpu(ib_conn->device->ib_device,
-				   desc->dma_addr, ISER_RX_PAYLOAD_SIZE,
-				   DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(ib_conn->device->ib_device->dma_device,
+				desc->dma_addr, ISER_RX_PAYLOAD_SIZE,
+				DMA_FROM_DEVICE);
 
 	hdr = &desc->iscsi_header;
 	length = wc->byte_len - ISER_HEADERS_LEN;
@@ -673,9 +677,9 @@ void iser_task_rsp(struct ib_cq *cq, struct ib_wc *wc)
 
 	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, desc->data, length);
 
-	ib_dma_sync_single_for_device(ib_conn->device->ib_device,
-				      desc->dma_addr, ISER_RX_PAYLOAD_SIZE,
-				      DMA_FROM_DEVICE);
+	dma_sync_single_for_device(ib_conn->device->ib_device->dma_device,
+				   desc->dma_addr, ISER_RX_PAYLOAD_SIZE,
+				   DMA_FROM_DEVICE);
 
 	/* decrementing conn->post_recv_buf_count only --after-- freeing the   *
 	 * task eliminates the need to worry on tasks which are completed in   *
@@ -724,8 +728,8 @@ void iser_dataout_comp(struct ib_cq *cq, struct ib_wc *wc)
 	if (unlikely(wc->status != IB_WC_SUCCESS))
 		iser_err_comp(wc, "dataout");
 
-	ib_dma_unmap_single(device->ib_device, desc->dma_addr,
-			    ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	dma_unmap_single(device->ib_device->dma_device, desc->dma_addr,
+			 ISER_HEADERS_LEN, DMA_TO_DEVICE);
 	kmem_cache_free(ig.desc_cache, desc);
 }
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 9c3e9ab53a41..0633bb932216 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -145,9 +145,9 @@ static void iser_data_buf_dump(struct iser_data_buf *data,
 	for_each_sg(data->sg, sg, data->dma_nents, i)
 		iser_dbg("sg[%d] dma_addr:0x%lX page:0x%p "
 			 "off:0x%x sz:0x%x dma_len:0x%x\n",
-			 i, (unsigned long)ib_sg_dma_address(ibdev, sg),
+			 i, (unsigned long)sg_dma_address(sg),
 			 sg_page(sg), sg->offset,
-			 sg->length, ib_sg_dma_len(ibdev, sg));
+			 sg->length, sg_dma_len(sg));
 }
 
 static void iser_dump_page_vec(struct iser_page_vec *page_vec)
@@ -170,7 +170,8 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 	iser_task->dir[iser_dir] = 1;
 	dev = iser_task->iser_conn->ib_conn.device->ib_device;
 
-	data->dma_nents = ib_dma_map_sg(dev, data->sg, data->size, dma_dir);
+	data->dma_nents = dma_map_sg(dev->dma_device, data->sg, data->size,
+				     dma_dir);
 	if (data->dma_nents == 0) {
 		iser_err("dma_map_sg failed!!!\n");
 		return -EINVAL;
@@ -185,7 +186,7 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
 	struct ib_device *dev;
 
 	dev = iser_task->iser_conn->ib_conn.device->ib_device;
-	ib_dma_unmap_sg(dev, data->sg, data->size, dir);
+	dma_unmap_sg(dev->dma_device, data->sg, data->size, dir);
 }
 
 static int
@@ -204,8 +205,8 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 		reg->rkey = device->pd->unsafe_global_rkey;
 	else
 		reg->rkey = 0;
-	reg->sge.addr = ib_sg_dma_address(device->ib_device, &sg[0]);
-	reg->sge.length = ib_sg_dma_len(device->ib_device, &sg[0]);
+	reg->sge.addr = sg_dma_address(&sg[0]);
+	reg->sge.length = sg_dma_len(&sg[0]);
 
 	iser_dbg("Single DMA entry: lkey=0x%x, rkey=0x%x, addr=0x%llx,"
 		 " length=0x%x\n", reg->sge.lkey, reg->rkey,
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 8ae7a3beddb7..1f439ab917ae 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1077,9 +1077,9 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
 	struct ib_send_wr *bad_wr, *wr = iser_tx_next_wr(tx_desc);
 	int ib_ret;
 
-	ib_dma_sync_single_for_device(ib_conn->device->ib_device,
-				      tx_desc->dma_addr, ISER_HEADERS_LEN,
-				      DMA_TO_DEVICE);
+	dma_sync_single_for_device(ib_conn->device->ib_device->dma_device,
+				   tx_desc->dma_addr, ISER_HEADERS_LEN,
+				   DMA_TO_DEVICE);
 
 	wr->next = NULL;
 	wr->wr_cqe = &tx_desc->cqe;
-- 
2.11.0

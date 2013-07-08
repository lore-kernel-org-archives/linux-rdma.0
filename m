From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 2/3] IB/iser: Restructure allocation/deallocation of connection resources
Date: Mon,  8 Jul 2013 17:26:15 +0300
Message-ID: <1373293576-24916-3-git-send-email-ogerlitz@mellanox.com>
References: <1373293576-24916-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373293576-24916-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is a preparation step to a patch that accepts the number of max SCSI
commands to be supported for the session from the user space iSCSI tools.

Move the allocation of the login buffer, FMR pool and its associated
page vector from iser_create_ib_conn_res() which is called prior to
a point in time where we actually know how many commands should be
supported to iser_alloc_rx_descriptors() which is called during the
iscsi connection bind step where this quantity is known.

Also do small refactoring around the deallocation to make that path
similar to the allocation one.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 +
 drivers/infiniband/ulp/iser/iser_initiator.c |   92 ++++++++++++++++++-
 drivers/infiniband/ulp/iser/iser_verbs.c     |  128 ++++++++++++--------------
 3 files changed, 151 insertions(+), 71 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index d694bcd..fee8829 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -395,4 +395,6 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task);
 int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
 int iser_alloc_rx_descriptors(struct iser_conn *ib_conn);
+int iser_create_fmr_pool(struct iser_conn *ib_conn);
+void iser_free_fmr_pool(struct iser_conn *ib_conn);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index b6d81a8..626d950 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -170,6 +170,76 @@ static void iser_create_send_desc(struct iser_conn	*ib_conn,
 	}
 }
 
+static void iser_free_login_buf(struct iser_conn *ib_conn)
+{
+	if (!ib_conn->login_buf)
+		return;
+
+	if (ib_conn->login_req_dma)
+		ib_dma_unmap_single(ib_conn->device->ib_device,
+				    ib_conn->login_req_dma,
+				    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+
+	if (ib_conn->login_resp_dma)
+		ib_dma_unmap_single(ib_conn->device->ib_device,
+				    ib_conn->login_resp_dma,
+				    ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+
+	kfree(ib_conn->login_buf);
+
+	/* make sure we never redo any unmapping */
+	ib_conn->login_req_dma = 0;
+	ib_conn->login_resp_dma = 0;
+	ib_conn->login_buf = NULL;
+}
+
+static int iser_alloc_login_buf(struct iser_conn *ib_conn)
+{
+	struct iser_device	*device;
+	int			req_err, resp_err;
+
+	BUG_ON(ib_conn->device == NULL);
+
+	device = ib_conn->device;
+
+	ib_conn->login_buf = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
+				     ISER_RX_LOGIN_SIZE, GFP_KERNEL);
+	if (!ib_conn->login_buf)
+		goto out_err;
+
+	ib_conn->login_req_buf  = ib_conn->login_buf;
+	ib_conn->login_resp_buf = ib_conn->login_buf +
+						ISCSI_DEF_MAX_RECV_SEG_LEN;
+
+	ib_conn->login_req_dma = ib_dma_map_single(ib_conn->device->ib_device,
+				(void *)ib_conn->login_req_buf,
+				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+
+	ib_conn->login_resp_dma = ib_dma_map_single(ib_conn->device->ib_device,
+				(void *)ib_conn->login_resp_buf,
+				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+
+	req_err  = ib_dma_mapping_error(device->ib_device,
+					ib_conn->login_req_dma);
+	resp_err = ib_dma_mapping_error(device->ib_device,
+					ib_conn->login_resp_dma);
+
+	if (req_err || resp_err) {
+		if (req_err)
+			ib_conn->login_req_dma = 0;
+		if (resp_err)
+			ib_conn->login_resp_dma = 0;
+		goto free_login_buf;
+	}
+	return 0;
+
+free_login_buf:
+	iser_free_login_buf(ib_conn);
+
+out_err:
+	iser_err("unable to alloc or map login buf\n");
+	return -ENOMEM;
+}
 
 int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
 {
@@ -179,6 +249,12 @@ int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
 	struct ib_sge       *rx_sg;
 	struct iser_device  *device = ib_conn->device;
 
+	if (iser_create_fmr_pool(ib_conn))
+		goto create_fmr_pool_failed;
+
+	if (iser_alloc_login_buf(ib_conn))
+		goto alloc_login_buf_fail;
+
 	ib_conn->rx_descs = kmalloc(ISER_QP_MAX_RECV_DTOS *
 				sizeof(struct iser_rx_desc), GFP_KERNEL);
 	if (!ib_conn->rx_descs)
@@ -207,10 +283,14 @@ rx_desc_dma_map_failed:
 	rx_desc = ib_conn->rx_descs;
 	for (j = 0; j < i; j++, rx_desc++)
 		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
-			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 	kfree(ib_conn->rx_descs);
 	ib_conn->rx_descs = NULL;
 rx_desc_alloc_fail:
+	iser_free_login_buf(ib_conn);
+alloc_login_buf_fail:
+	iser_free_fmr_pool(ib_conn);
+create_fmr_pool_failed:
 	iser_err("failed allocating rx descriptors / data buffers\n");
 	return -ENOMEM;
 }
@@ -222,13 +302,19 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn)
 	struct iser_device *device = ib_conn->device;
 
 	if (!ib_conn->rx_descs)
-		return;
+		goto free_login_buf;
 
 	rx_desc = ib_conn->rx_descs;
 	for (i = 0; i < ISER_QP_MAX_RECV_DTOS; i++, rx_desc++)
 		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
-			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 	kfree(ib_conn->rx_descs);
+	/* make sure we never redo any unmapping */
+	ib_conn->rx_descs = NULL;
+
+free_login_buf:
+	iser_free_login_buf(ib_conn);
+	iser_free_fmr_pool(ib_conn);
 }
 
 static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 2c4941d..b72e349 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -178,56 +178,23 @@ static void iser_free_device_ib_res(struct iser_device *device)
 }
 
 /**
- * iser_create_ib_conn_res - Creates FMR pool and Queue-Pair (QP)
+ * iser_create_fmr_pool - Creates FMR pool and page_vector
  *
- * returns 0 on success, -1 on failure
+ * returns 0 on success, or errno code on failure
  */
-static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
+int iser_create_fmr_pool(struct iser_conn *ib_conn)
 {
-	struct iser_device	*device;
-	struct ib_qp_init_attr	init_attr;
-	int			req_err, resp_err, ret = -ENOMEM;
+	struct iser_device *device = ib_conn->device;
 	struct ib_fmr_pool_param params;
-	int index, min_index = 0;
-
-	BUG_ON(ib_conn->device == NULL);
-
-	device = ib_conn->device;
-
-	ib_conn->login_buf = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
-					ISER_RX_LOGIN_SIZE, GFP_KERNEL);
-	if (!ib_conn->login_buf)
-		goto out_err;
-
-	ib_conn->login_req_buf  = ib_conn->login_buf;
-	ib_conn->login_resp_buf = ib_conn->login_buf + ISCSI_DEF_MAX_RECV_SEG_LEN;
-
-	ib_conn->login_req_dma = ib_dma_map_single(ib_conn->device->ib_device,
-				(void *)ib_conn->login_req_buf,
-				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
-
-	ib_conn->login_resp_dma = ib_dma_map_single(ib_conn->device->ib_device,
-				(void *)ib_conn->login_resp_buf,
-				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
-
-	req_err  = ib_dma_mapping_error(device->ib_device, ib_conn->login_req_dma);
-	resp_err = ib_dma_mapping_error(device->ib_device, ib_conn->login_resp_dma);
-
-	if (req_err || resp_err) {
-		if (req_err)
-			ib_conn->login_req_dma = 0;
-		if (resp_err)
-			ib_conn->login_resp_dma = 0;
-		goto out_err;
-	}
+	int ret = -ENOMEM;
 
 	ib_conn->page_vec = kmalloc(sizeof(struct iser_page_vec) +
-				    (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE +1)),
+				    (sizeof(u64)*(ISCSI_ISER_SG_TABLESIZE+1)),
 				    GFP_KERNEL);
 	if (!ib_conn->page_vec)
-		goto out_err;
+		return ret;
 
-	ib_conn->page_vec->pages = (u64 *) (ib_conn->page_vec + 1);
+	ib_conn->page_vec->pages = (u64 *)(ib_conn->page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
 	/* when the first/last SG element are not start/end *
@@ -244,15 +211,56 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 				    IB_ACCESS_REMOTE_READ);
 
 	ib_conn->fmr_pool = ib_create_fmr_pool(device->pd, &params);
+	if (!IS_ERR(ib_conn->fmr_pool))
+		return 0;
+
+	/* no FMR => no need for page_vec */
+	kfree(ib_conn->page_vec);
+	ib_conn->page_vec = NULL;
+
 	ret = PTR_ERR(ib_conn->fmr_pool);
-	if (IS_ERR(ib_conn->fmr_pool) && ret != -ENOSYS) {
-		ib_conn->fmr_pool = NULL;
-		goto out_err;
-	} else if (ret == -ENOSYS) {
-		ib_conn->fmr_pool = NULL;
+	ib_conn->fmr_pool = NULL;
+	if (ret != -ENOSYS) {
+		iser_err("FMR allocation failed, err %d\n", ret);
+		return ret;
+	} else {
 		iser_warn("FMRs are not supported, using unaligned mode\n");
-		ret = 0;
+		return 0;
 	}
+}
+
+/**
+ * iser_free_fmr_pool - releases the FMR pool and page vec
+ */
+void iser_free_fmr_pool(struct iser_conn *ib_conn)
+{
+	iser_info("freeing conn %p fmr pool %p\n",
+		  ib_conn, ib_conn->fmr_pool);
+
+	if (ib_conn->fmr_pool != NULL)
+		ib_destroy_fmr_pool(ib_conn->fmr_pool);
+
+	ib_conn->fmr_pool = NULL;
+
+	kfree(ib_conn->page_vec);
+	ib_conn->page_vec = NULL;
+}
+
+/**
+ * iser_create_ib_conn_res - Queue-Pair (QP)
+ *
+ * returns 0 on success, -1 on failure
+ */
+static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
+{
+	struct iser_device	*device;
+	struct ib_qp_init_attr	init_attr;
+	int			ret = -ENOMEM;
+	int index, min_index = 0;
+
+	BUG_ON(ib_conn->device == NULL);
+
+	device = ib_conn->device;
 
 	memset(&init_attr, 0, sizeof init_attr);
 
@@ -282,9 +290,9 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 		goto out_err;
 
 	ib_conn->qp = ib_conn->cma_id->qp;
-	iser_info("setting conn %p cma_id %p: fmr_pool %p qp %p\n",
+	iser_info("setting conn %p cma_id %p qp %p\n",
 		  ib_conn, ib_conn->cma_id,
-		  ib_conn->fmr_pool, ib_conn->cma_id->qp);
+		  ib_conn->cma_id->qp);
 	return ret;
 
 out_err:
@@ -293,7 +301,7 @@ out_err:
 }
 
 /**
- * releases the FMR pool and QP objects, returns 0 on success,
+ * releases the QP objects, returns 0 on success,
  * -1 on failure
  */
 static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
@@ -301,13 +309,11 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
 	int cq_index;
 	BUG_ON(ib_conn == NULL);
 
-	iser_info("freeing conn %p cma_id %p fmr pool %p qp %p\n",
+	iser_info("freeing conn %p cma_id %p qp %p\n",
 		  ib_conn, ib_conn->cma_id,
-		  ib_conn->fmr_pool, ib_conn->qp);
+		  ib_conn->qp);
 
 	/* qp is created only once both addr & route are resolved */
-	if (ib_conn->fmr_pool != NULL)
-		ib_destroy_fmr_pool(ib_conn->fmr_pool);
 
 	if (ib_conn->qp != NULL) {
 		cq_index = ((struct iser_cq_desc *)ib_conn->qp->recv_cq->cq_context)->cq_index;
@@ -316,21 +322,7 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
 		rdma_destroy_qp(ib_conn->cma_id);
 	}
 
-	ib_conn->fmr_pool = NULL;
 	ib_conn->qp	  = NULL;
-	kfree(ib_conn->page_vec);
-
-	if (ib_conn->login_buf) {
-		if (ib_conn->login_req_dma)
-			ib_dma_unmap_single(ib_conn->device->ib_device,
-				ib_conn->login_req_dma,
-				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
-		if (ib_conn->login_resp_dma)
-			ib_dma_unmap_single(ib_conn->device->ib_device,
-				ib_conn->login_resp_dma,
-				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
-		kfree(ib_conn->login_buf);
-	}
 
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

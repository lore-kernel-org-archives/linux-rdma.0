From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 17/18] iser-target: Remove conn_ prefix from struct isert_conn members
Date: Sun, 29 Mar 2015 15:52:19 +0300
Message-ID: <1427633540-30352-18-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

These variables are always accessed via struct isert_conn so
no need to have a "conn_" prefix for them.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  264 +++++++++++++++---------------
 drivers/infiniband/ulp/isert/ib_isert.h |   32 ++--
 2 files changed, 148 insertions(+), 148 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 4a2800a..8f452f6 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -81,7 +81,7 @@ isert_qp_event_callback(struct ib_event *e, void *context)
 	isert_err("conn %p event: %d\n", isert_conn, e->event);
 	switch (e->event) {
 	case IB_EVENT_COMM_EST:
-		rdma_notify(isert_conn->conn_cm_id, IB_EVENT_COMM_EST);
+		rdma_notify(isert_conn->cm_id, IB_EVENT_COMM_EST);
 		break;
 	case IB_EVENT_QP_LAST_WQE_REACHED:
 		isert_warn("Reached TX IB_EVENT_QP_LAST_WQE_REACHED\n");
@@ -110,7 +110,7 @@ isert_query_device(struct ib_device *ib_dev, struct ib_device_attr *devattr)
 static struct isert_comp *
 isert_comp_get(struct isert_conn *isert_conn)
 {
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct isert_comp *comp;
 	int i, min = 0;
 
@@ -142,7 +142,7 @@ isert_create_qp(struct isert_conn *isert_conn,
 		struct isert_comp *comp,
 		struct rdma_cm_id *cma_id)
 {
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_qp_init_attr attr;
 	int ret;
 
@@ -185,9 +185,9 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
 	int ret;
 
 	comp = isert_comp_get(isert_conn);
-	isert_conn->conn_qp = isert_create_qp(isert_conn, comp, cma_id);
-	if (IS_ERR(isert_conn->conn_qp)) {
-		ret = PTR_ERR(isert_conn->conn_qp);
+	isert_conn->qp = isert_create_qp(isert_conn, comp, cma_id);
+	if (IS_ERR(isert_conn->qp)) {
+		ret = PTR_ERR(isert_conn->qp);
 		goto err;
 	}
 
@@ -206,19 +206,19 @@ isert_cq_event_callback(struct ib_event *e, void *context)
 static int
 isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 {
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_device *ib_dev = device->ib_device;
 	struct iser_rx_desc *rx_desc;
 	struct ib_sge *rx_sg;
 	u64 dma_addr;
 	int i, j;
 
-	isert_conn->conn_rx_descs = kzalloc(ISERT_QP_MAX_RECV_DTOS *
+	isert_conn->rx_descs = kzalloc(ISERT_QP_MAX_RECV_DTOS *
 				sizeof(struct iser_rx_desc), GFP_KERNEL);
-	if (!isert_conn->conn_rx_descs)
+	if (!isert_conn->rx_descs)
 		goto fail;
 
-	rx_desc = isert_conn->conn_rx_descs;
+	rx_desc = isert_conn->rx_descs;
 
 	for (i = 0; i < ISERT_QP_MAX_RECV_DTOS; i++, rx_desc++)  {
 		dma_addr = ib_dma_map_single(ib_dev, (void *)rx_desc,
@@ -234,18 +234,18 @@ isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 		rx_sg->lkey = device->mr->lkey;
 	}
 
-	isert_conn->conn_rx_desc_head = 0;
+	isert_conn->rx_desc_head = 0;
 
 	return 0;
 
 dma_map_fail:
-	rx_desc = isert_conn->conn_rx_descs;
+	rx_desc = isert_conn->rx_descs;
 	for (j = 0; j < i; j++, rx_desc++) {
 		ib_dma_unmap_single(ib_dev, rx_desc->dma_addr,
 				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 	}
-	kfree(isert_conn->conn_rx_descs);
-	isert_conn->conn_rx_descs = NULL;
+	kfree(isert_conn->rx_descs);
+	isert_conn->rx_descs = NULL;
 fail:
 	isert_err("conn %p failed to allocate rx descriptors\n", isert_conn);
 
@@ -255,21 +255,21 @@ fail:
 static void
 isert_free_rx_descriptors(struct isert_conn *isert_conn)
 {
-	struct ib_device *ib_dev = isert_conn->conn_device->ib_device;
+	struct ib_device *ib_dev = isert_conn->device->ib_device;
 	struct iser_rx_desc *rx_desc;
 	int i;
 
-	if (!isert_conn->conn_rx_descs)
+	if (!isert_conn->rx_descs)
 		return;
 
-	rx_desc = isert_conn->conn_rx_descs;
+	rx_desc = isert_conn->rx_descs;
 	for (i = 0; i < ISERT_QP_MAX_RECV_DTOS; i++, rx_desc++)  {
 		ib_dma_unmap_single(ib_dev, rx_desc->dma_addr,
 				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 	}
 
-	kfree(isert_conn->conn_rx_descs);
-	isert_conn->conn_rx_descs = NULL;
+	kfree(isert_conn->rx_descs);
+	isert_conn->rx_descs = NULL;
 }
 
 static void isert_cq_work(struct work_struct *);
@@ -471,13 +471,13 @@ isert_conn_free_fastreg_pool(struct isert_conn *isert_conn)
 	struct fast_reg_descriptor *fr_desc, *tmp;
 	int i = 0;
 
-	if (list_empty(&isert_conn->conn_fr_pool))
+	if (list_empty(&isert_conn->fr_pool))
 		return;
 
 	isert_info("Freeing conn %p fastreg pool", isert_conn);
 
 	list_for_each_entry_safe(fr_desc, tmp,
-				 &isert_conn->conn_fr_pool, list) {
+				 &isert_conn->fr_pool, list) {
 		list_del(&fr_desc->list);
 		ib_free_fast_reg_page_list(fr_desc->data_frpl);
 		ib_dereg_mr(fr_desc->data_mr);
@@ -491,9 +491,9 @@ isert_conn_free_fastreg_pool(struct isert_conn *isert_conn)
 		++i;
 	}
 
-	if (i < isert_conn->conn_fr_pool_size)
+	if (i < isert_conn->fr_pool_size)
 		isert_warn("Pool still has %d regions registered\n",
-			isert_conn->conn_fr_pool_size - i);
+			isert_conn->fr_pool_size - i);
 }
 
 static int
@@ -593,7 +593,7 @@ static int
 isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
 {
 	struct fast_reg_descriptor *fr_desc;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct se_session *se_sess = isert_conn->conn->sess->se_sess;
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
 	int i, ret, tag_num;
@@ -604,7 +604,7 @@ isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
 	tag_num = max_t(u32, ISCSIT_MIN_TAGS, se_nacl->queue_depth);
 	tag_num = (tag_num * 2) + ISCSIT_EXTRA_TAGS;
 
-	isert_conn->conn_fr_pool_size = 0;
+	isert_conn->fr_pool_size = 0;
 	for (i = 0; i < tag_num; i++) {
 		fr_desc = kzalloc(sizeof(*fr_desc), GFP_KERNEL);
 		if (!fr_desc) {
@@ -622,12 +622,12 @@ isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
 			goto err;
 		}
 
-		list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
-		isert_conn->conn_fr_pool_size++;
+		list_add_tail(&fr_desc->list, &isert_conn->fr_pool);
+		isert_conn->fr_pool_size++;
 	}
 
 	isert_dbg("Creating conn %p fastreg pool size=%d",
-		 isert_conn, isert_conn->conn_fr_pool_size);
+		 isert_conn, isert_conn->fr_pool_size);
 
 	return 0;
 
@@ -640,20 +640,20 @@ static void
 isert_init_conn(struct isert_conn *isert_conn)
 {
 	isert_conn->state = ISER_CONN_INIT;
-	INIT_LIST_HEAD(&isert_conn->conn_accept_node);
-	init_completion(&isert_conn->conn_login_comp);
+	INIT_LIST_HEAD(&isert_conn->accept_node);
+	init_completion(&isert_conn->login_comp);
 	init_completion(&isert_conn->login_req_comp);
-	init_completion(&isert_conn->conn_wait);
-	kref_init(&isert_conn->conn_kref);
-	mutex_init(&isert_conn->conn_mutex);
-	spin_lock_init(&isert_conn->conn_lock);
-	INIT_LIST_HEAD(&isert_conn->conn_fr_pool);
+	init_completion(&isert_conn->wait);
+	kref_init(&isert_conn->kref);
+	mutex_init(&isert_conn->mutex);
+	spin_lock_init(&isert_conn->pool_lock);
+	INIT_LIST_HEAD(&isert_conn->fr_pool);
 }
 
 static void
 isert_free_login_buf(struct isert_conn *isert_conn)
 {
-	struct ib_device *ib_dev = isert_conn->conn_device->ib_device;
+	struct ib_device *ib_dev = isert_conn->device->ib_device;
 
 	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
 			    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
@@ -741,7 +741,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		return -ENOMEM;
 
 	isert_init_conn(isert_conn);
-	isert_conn->conn_cm_id = cma_id;
+	isert_conn->cm_id = cma_id;
 
 	ret = isert_alloc_login_buf(isert_conn, cma_id->device);
 	if (ret)
@@ -752,7 +752,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		ret = PTR_ERR(device);
 		goto out_rsp_dma_map;
 	}
-	isert_conn->conn_device = device;
+	isert_conn->device = device;
 
 	/* Set max inflight RDMA READ requests */
 	isert_conn->initiator_depth = min_t(u8,
@@ -773,7 +773,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		goto out_conn_dev;
 
 	mutex_lock(&isert_np->np_accept_mutex);
-	list_add_tail(&isert_conn->conn_accept_node, &isert_np->np_accept_list);
+	list_add_tail(&isert_conn->accept_node, &isert_np->np_accept_list);
 	mutex_unlock(&isert_np->np_accept_mutex);
 
 	isert_info("np %p: Allow accept_np to continue\n", np);
@@ -793,7 +793,7 @@ out:
 static void
 isert_connect_release(struct isert_conn *isert_conn)
 {
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 
 	isert_dbg("conn %p\n", isert_conn);
 
@@ -803,14 +803,14 @@ isert_connect_release(struct isert_conn *isert_conn)
 		isert_conn_free_fastreg_pool(isert_conn);
 
 	isert_free_rx_descriptors(isert_conn);
-	if (isert_conn->conn_cm_id)
-		rdma_destroy_id(isert_conn->conn_cm_id);
+	if (isert_conn->cm_id)
+		rdma_destroy_id(isert_conn->cm_id);
 
-	if (isert_conn->conn_qp) {
-		struct isert_comp *comp = isert_conn->conn_qp->recv_cq->cq_context;
+	if (isert_conn->qp) {
+		struct isert_comp *comp = isert_conn->qp->recv_cq->cq_context;
 
 		isert_comp_put(comp);
-		ib_destroy_qp(isert_conn->conn_qp);
+		ib_destroy_qp(isert_conn->qp);
 	}
 
 	if (isert_conn->login_buf)
@@ -828,22 +828,22 @@ isert_connected_handler(struct rdma_cm_id *cma_id)
 
 	isert_info("conn %p\n", isert_conn);
 
-	if (!kref_get_unless_zero(&isert_conn->conn_kref)) {
+	if (!kref_get_unless_zero(&isert_conn->kref)) {
 		isert_warn("conn %p connect_release is running\n", isert_conn);
 		return;
 	}
 
-	mutex_lock(&isert_conn->conn_mutex);
+	mutex_lock(&isert_conn->mutex);
 	if (isert_conn->state != ISER_CONN_FULL_FEATURE)
 		isert_conn->state = ISER_CONN_UP;
-	mutex_unlock(&isert_conn->conn_mutex);
+	mutex_unlock(&isert_conn->mutex);
 }
 
 static void
-isert_release_conn_kref(struct kref *kref)
+isert_release_kref(struct kref *kref)
 {
 	struct isert_conn *isert_conn = container_of(kref,
-				struct isert_conn, conn_kref);
+				struct isert_conn, kref);
 
 	isert_info("conn %p final kref %s/%d\n", isert_conn, current->comm,
 		   current->pid);
@@ -854,7 +854,7 @@ isert_release_conn_kref(struct kref *kref)
 static void
 isert_put_conn(struct isert_conn *isert_conn)
 {
-	kref_put(&isert_conn->conn_kref, isert_release_conn_kref);
+	kref_put(&isert_conn->kref, isert_release_kref);
 }
 
 /**
@@ -866,7 +866,7 @@ isert_put_conn(struct isert_conn *isert_conn)
  * to TEMINATING and start teardown sequence (rdma_disconnect).
  * In case the connection state is UP, complete flush as well.
  *
- * This routine must be called with conn_mutex held. Thus it is
+ * This routine must be called with mutex held. Thus it is
  * safe to call multiple times.
  */
 static void
@@ -882,7 +882,7 @@ isert_conn_terminate(struct isert_conn *isert_conn)
 		isert_info("Terminating conn %p state %d\n",
 			   isert_conn, isert_conn->state);
 		isert_conn->state = ISER_CONN_TERMINATING;
-		err = rdma_disconnect(isert_conn->conn_cm_id);
+		err = rdma_disconnect(isert_conn->cm_id);
 		if (err)
 			isert_warn("Failed rdma_disconnect isert_conn %p\n",
 				   isert_conn);
@@ -931,12 +931,12 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 
 	isert_conn = cma_id->qp->qp_context;
 
-	mutex_lock(&isert_conn->conn_mutex);
+	mutex_lock(&isert_conn->mutex);
 	isert_conn_terminate(isert_conn);
-	mutex_unlock(&isert_conn->conn_mutex);
+	mutex_unlock(&isert_conn->mutex);
 
-	isert_info("conn %p completing conn_wait\n", isert_conn);
-	complete(&isert_conn->conn_wait);
+	isert_info("conn %p completing wait\n", isert_conn);
+	complete(&isert_conn->wait);
 
 	return 0;
 }
@@ -946,7 +946,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 
-	isert_conn->conn_cm_id = NULL;
+	isert_conn->cm_id = NULL;
 	isert_put_conn(isert_conn);
 
 	return -1;
@@ -993,11 +993,11 @@ isert_post_recv(struct isert_conn *isert_conn, u32 count)
 {
 	struct ib_recv_wr *rx_wr, *rx_wr_failed;
 	int i, ret;
-	unsigned int rx_head = isert_conn->conn_rx_desc_head;
+	unsigned int rx_head = isert_conn->rx_desc_head;
 	struct iser_rx_desc *rx_desc;
 
-	for (rx_wr = isert_conn->conn_rx_wr, i = 0; i < count; i++, rx_wr++) {
-		rx_desc		= &isert_conn->conn_rx_descs[rx_head];
+	for (rx_wr = isert_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
+		rx_desc		= &isert_conn->rx_descs[rx_head];
 		rx_wr->wr_id	= (uintptr_t)rx_desc;
 		rx_wr->sg_list	= &rx_desc->rx_sg;
 		rx_wr->num_sge	= 1;
@@ -1009,14 +1009,14 @@ isert_post_recv(struct isert_conn *isert_conn, u32 count)
 	rx_wr->next = NULL; /* mark end of work requests list */
 
 	isert_conn->post_recv_buf_count += count;
-	ret = ib_post_recv(isert_conn->conn_qp, isert_conn->conn_rx_wr,
+	ret = ib_post_recv(isert_conn->qp, isert_conn->rx_wr,
 				&rx_wr_failed);
 	if (ret) {
 		isert_err("ib_post_recv() failed with ret: %d\n", ret);
 		isert_conn->post_recv_buf_count -= count;
 	} else {
 		isert_dbg("Posted %d RX buffers\n", count);
-		isert_conn->conn_rx_desc_head = rx_head;
+		isert_conn->rx_desc_head = rx_head;
 	}
 	return ret;
 }
@@ -1024,7 +1024,7 @@ isert_post_recv(struct isert_conn *isert_conn, u32 count)
 static int
 isert_post_send(struct isert_conn *isert_conn, struct iser_tx_desc *tx_desc)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct ib_send_wr send_wr, *send_wr_failed;
 	int ret;
 
@@ -1038,7 +1038,7 @@ isert_post_send(struct isert_conn *isert_conn, struct iser_tx_desc *tx_desc)
 	send_wr.opcode	= IB_WR_SEND;
 	send_wr.send_flags = IB_SEND_SIGNALED;
 
-	ret = ib_post_send(isert_conn->conn_qp, &send_wr, &send_wr_failed);
+	ret = ib_post_send(isert_conn->qp, &send_wr, &send_wr_failed);
 	if (ret)
 		isert_err("ib_post_send() failed, ret: %d\n", ret);
 
@@ -1050,7 +1050,7 @@ isert_create_send_desc(struct isert_conn *isert_conn,
 		       struct isert_cmd *isert_cmd,
 		       struct iser_tx_desc *tx_desc)
 {
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_device *ib_dev = device->ib_device;
 
 	ib_dma_sync_single_for_cpu(ib_dev, tx_desc->dma_addr,
@@ -1072,7 +1072,7 @@ static int
 isert_init_tx_hdrs(struct isert_conn *isert_conn,
 		   struct iser_tx_desc *tx_desc)
 {
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_device *ib_dev = device->ib_device;
 	u64 dma_addr;
 
@@ -1119,7 +1119,7 @@ isert_rdma_post_recvl(struct isert_conn *isert_conn)
 	memset(&sge, 0, sizeof(struct ib_sge));
 	sge.addr = isert_conn->login_req_dma;
 	sge.length = ISER_RX_LOGIN_SIZE;
-	sge.lkey = isert_conn->conn_device->mr->lkey;
+	sge.lkey = isert_conn->device->mr->lkey;
 
 	isert_dbg("Setup sge: addr: %llx length: %d 0x%08x\n",
 		sge.addr, sge.length, sge.lkey);
@@ -1130,7 +1130,7 @@ isert_rdma_post_recvl(struct isert_conn *isert_conn)
 	rx_wr.num_sge = 1;
 
 	isert_conn->post_recv_buf_count++;
-	ret = ib_post_recv(isert_conn->conn_qp, &rx_wr, &rx_wr_fail);
+	ret = ib_post_recv(isert_conn->qp, &rx_wr, &rx_wr_fail);
 	if (ret) {
 		isert_err("ib_post_recv() failed: %d\n", ret);
 		isert_conn->post_recv_buf_count--;
@@ -1144,9 +1144,9 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 		   u32 length)
 {
 	struct isert_conn *isert_conn = conn->context;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_device *ib_dev = device->ib_device;
-	struct iser_tx_desc *tx_desc = &isert_conn->conn_login_tx_desc;
+	struct iser_tx_desc *tx_desc = &isert_conn->login_tx_desc;
 	int ret;
 
 	isert_create_send_desc(isert_conn, NULL, tx_desc);
@@ -1169,13 +1169,13 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 
 		tx_dsg->addr	= isert_conn->login_rsp_dma;
 		tx_dsg->length	= length;
-		tx_dsg->lkey	= isert_conn->conn_device->mr->lkey;
+		tx_dsg->lkey	= isert_conn->device->mr->lkey;
 		tx_desc->num_sge = 2;
 	}
 	if (!login->login_failed) {
 		if (login->login_complete) {
 			if (!conn->sess->sess_ops->SessionType &&
-			    isert_conn->conn_device->use_fastreg) {
+			    isert_conn->device->use_fastreg) {
 				ret = isert_conn_create_fastreg_pool(isert_conn);
 				if (ret) {
 					isert_err("Conn: %p failed to create"
@@ -1193,9 +1193,9 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 				return ret;
 
 			/* Now we are in FULL_FEATURE phase */
-			mutex_lock(&isert_conn->conn_mutex);
+			mutex_lock(&isert_conn->mutex);
 			isert_conn->state = ISER_CONN_FULL_FEATURE;
-			mutex_unlock(&isert_conn->conn_mutex);
+			mutex_unlock(&isert_conn->mutex);
 			goto post_send;
 		}
 
@@ -1254,7 +1254,7 @@ isert_rx_login_req(struct isert_conn *isert_conn)
 	memcpy(login->req_buf, &rx_desc->data[0], size);
 
 	if (login->first_request) {
-		complete(&isert_conn->conn_login_comp);
+		complete(&isert_conn->login_comp);
 		return;
 	}
 	schedule_delayed_work(&conn->login_work, 0);
@@ -1569,7 +1569,7 @@ isert_rcv_completion(struct iser_rx_desc *desc,
 		     struct isert_conn *isert_conn,
 		     u32 xfer_len)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct iscsi_hdr *hdr;
 	u64 rx_dma;
 	int rx_buflen, outstanding;
@@ -1601,9 +1601,9 @@ isert_rcv_completion(struct iser_rx_desc *desc,
 			if (login && !login->first_request)
 				isert_rx_login_req(isert_conn);
 		}
-		mutex_lock(&isert_conn->conn_mutex);
+		mutex_lock(&isert_conn->mutex);
 		complete(&isert_conn->login_req_comp);
-		mutex_unlock(&isert_conn->conn_mutex);
+		mutex_unlock(&isert_conn->mutex);
 	} else {
 		isert_rx_do_work(desc, isert_conn);
 	}
@@ -1635,7 +1635,7 @@ isert_map_data_buf(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 		   struct scatterlist *sg, u32 nents, u32 length, u32 offset,
 		   enum iser_ib_op_code op, struct isert_data_buf *data)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct ib_device *ib_dev = isert_conn->cm_id->device;
 
 	data->dma_dir = op == ISER_IB_RDMA_WRITE ?
 			      DMA_TO_DEVICE : DMA_FROM_DEVICE;
@@ -1666,7 +1666,7 @@ isert_map_data_buf(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 static void
 isert_unmap_data_buf(struct isert_conn *isert_conn, struct isert_data_buf *data)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct ib_device *ib_dev = isert_conn->cm_id->device;
 
 	ib_dma_unmap_sg(ib_dev, data->sg, data->nents, data->dma_dir);
 	memset(data, 0, sizeof(*data));
@@ -1712,9 +1712,9 @@ isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 			isert_unmap_data_buf(isert_conn, &wr->prot);
 			wr->fr_desc->ind &= ~ISERT_PROTECTED;
 		}
-		spin_lock_bh(&isert_conn->conn_lock);
-		list_add_tail(&wr->fr_desc->list, &isert_conn->conn_fr_pool);
-		spin_unlock_bh(&isert_conn->conn_lock);
+		spin_lock_bh(&isert_conn->pool_lock);
+		list_add_tail(&wr->fr_desc->list, &isert_conn->fr_pool);
+		spin_unlock_bh(&isert_conn->pool_lock);
 		wr->fr_desc = NULL;
 	}
 
@@ -1733,7 +1733,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd, bool comp_err)
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct iscsi_conn *conn = isert_conn->conn;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct iscsi_text_rsp *hdr;
 
 	isert_dbg("Cmd %p\n", isert_cmd);
@@ -1883,7 +1883,7 @@ isert_completion_rdma_write(struct iser_tx_desc *tx_desc,
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	int ret = 0;
 
 	if (wr->fr_desc && wr->fr_desc->ind & ISERT_PROTECTED) {
@@ -1909,7 +1909,7 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	int ret = 0;
 
 	if (wr->fr_desc && wr->fr_desc->ind & ISERT_PROTECTED) {
@@ -1944,7 +1944,7 @@ isert_do_control_comp(struct work_struct *work)
 	struct isert_cmd *isert_cmd = container_of(work,
 			struct isert_cmd, comp_work);
 	struct isert_conn *isert_conn = isert_cmd->conn;
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 
 	isert_dbg("Cmd %p i_state %d\n", isert_cmd, cmd->i_state);
@@ -1995,7 +1995,7 @@ static void
 isert_snd_completion(struct iser_tx_desc *tx_desc,
 		      struct isert_conn *isert_conn)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct isert_cmd *isert_cmd = tx_desc->isert_cmd;
 	struct isert_rdma_wr *wr;
 
@@ -2039,8 +2039,8 @@ isert_snd_completion(struct iser_tx_desc *tx_desc,
 static inline bool
 is_isert_tx_desc(struct isert_conn *isert_conn, void *wr_id)
 {
-	void *start = isert_conn->conn_rx_descs;
-	int len = ISERT_QP_MAX_RECV_DTOS * sizeof(*isert_conn->conn_rx_descs);
+	void *start = isert_conn->rx_descs;
+	int len = ISERT_QP_MAX_RECV_DTOS * sizeof(*isert_conn->rx_descs);
 
 	if (wr_id >= start && wr_id < start + len)
 		return false;
@@ -2052,11 +2052,11 @@ static void
 isert_cq_comp_err(struct isert_conn *isert_conn, struct ib_wc *wc)
 {
 	if (wc->wr_id == ISER_BEACON_WRID) {
-		isert_info("conn %p completing conn_wait_comp_err\n",
+		isert_info("conn %p completing wait_comp_err\n",
 			   isert_conn);
-		complete(&isert_conn->conn_wait_comp_err);
+		complete(&isert_conn->wait_comp_err);
 	} else if (is_isert_tx_desc(isert_conn, (void *)(uintptr_t)wc->wr_id)) {
-		struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+		struct ib_device *ib_dev = isert_conn->cm_id->device;
 		struct isert_cmd *isert_cmd;
 		struct iser_tx_desc *desc;
 
@@ -2136,7 +2136,7 @@ isert_post_response(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd)
 	struct ib_send_wr *wr_failed;
 	int ret;
 
-	ret = ib_post_send(isert_conn->conn_qp, &isert_cmd->tx_desc.send_wr,
+	ret = ib_post_send(isert_conn->qp, &isert_cmd->tx_desc.send_wr,
 			   &wr_failed);
 	if (ret) {
 		isert_err("ib_post_send failed with %d\n", ret);
@@ -2163,7 +2163,7 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	if (cmd->se_cmd.sense_buffer &&
 	    ((cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
 	    (cmd->se_cmd.se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
-		struct isert_device *device = isert_conn->conn_device;
+		struct isert_device *device = isert_conn->device;
 		struct ib_device *ib_dev = device->ib_device;
 		struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
 		u32 padding, pdu_len;
@@ -2199,7 +2199,7 @@ isert_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = conn->context;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 
 	spin_lock_bh(&conn->cmd_lock);
 	if (!list_empty(&cmd->i_conn_node))
@@ -2216,7 +2216,7 @@ static enum target_prot_op
 isert_get_sup_prot_ops(struct iscsi_conn *conn)
 {
 	struct isert_conn *isert_conn = conn->context;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 
 	if (conn->tpg->tpg_attrib.t10_pi) {
 		if (device->pi_capable) {
@@ -2294,7 +2294,7 @@ isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_device *ib_dev = device->ib_device;
 	struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
 	struct iscsi_reject *hdr =
@@ -2341,7 +2341,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 
 	if (txt_rsp_len) {
-		struct isert_device *device = isert_conn->conn_device;
+		struct isert_device *device = isert_conn->device;
 		struct ib_device *ib_dev = device->ib_device;
 		struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
 		void *txt_rsp_buf = cmd->buf_ptr;
@@ -2369,7 +2369,7 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 {
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct scatterlist *sg_start, *tmp_sg;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_device *ib_dev = device->ib_device;
 	u32 sg_off, page_off;
 	int i = 0, sg_nents;
@@ -2555,7 +2555,7 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 		  enum isert_indicator ind,
 		  struct ib_sge *sge)
 {
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_device *ib_dev = device->ib_device;
 	struct ib_mr *mr;
 	struct ib_fast_reg_page_list *frpl;
@@ -2613,7 +2613,7 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	else
 		wr->next = &fr_wr;
 
-	ret = ib_post_send(isert_conn->conn_qp, wr, &bad_wr);
+	ret = ib_post_send(isert_conn->qp, wr, &bad_wr);
 	if (ret) {
 		isert_err("fast registration failed, ret:%d\n", ret);
 		return ret;
@@ -2726,7 +2726,7 @@ isert_reg_sig_mr(struct isert_conn *isert_conn,
 	else
 		wr->next = &sig_wr;
 
-	ret = ib_post_send(isert_conn->conn_qp, wr, &bad_wr);
+	ret = ib_post_send(isert_conn->qp, wr, &bad_wr);
 	if (ret) {
 		isert_err("fast registration failed, ret:%d\n", ret);
 		goto err;
@@ -2756,7 +2756,7 @@ isert_handle_prot_cmd(struct isert_conn *isert_conn,
 		      struct isert_cmd *isert_cmd,
 		      struct isert_rdma_wr *wr)
 {
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct se_cmd *se_cmd = &isert_cmd->iscsi_cmd->se_cmd;
 	int ret;
 
@@ -2834,11 +2834,11 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		return ret;
 
 	if (wr->data.dma_nents != 1 || isert_prot_cmd(isert_conn, se_cmd)) {
-		spin_lock_irqsave(&isert_conn->conn_lock, flags);
-		fr_desc = list_first_entry(&isert_conn->conn_fr_pool,
+		spin_lock_irqsave(&isert_conn->pool_lock, flags);
+		fr_desc = list_first_entry(&isert_conn->fr_pool,
 					   struct fast_reg_descriptor, list);
 		list_del(&fr_desc->list);
-		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
+		spin_unlock_irqrestore(&isert_conn->pool_lock, flags);
 		wr->fr_desc = fr_desc;
 	}
 
@@ -2885,9 +2885,9 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 unmap_cmd:
 	if (fr_desc) {
-		spin_lock_irqsave(&isert_conn->conn_lock, flags);
-		list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
-		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
+		spin_lock_irqsave(&isert_conn->pool_lock, flags);
+		list_add_tail(&fr_desc->list, &isert_conn->fr_pool);
+		spin_unlock_irqrestore(&isert_conn->pool_lock, flags);
 	}
 	isert_unmap_data_buf(isert_conn, &wr->data);
 
@@ -2901,7 +2901,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct isert_conn *isert_conn = conn->context;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_send_wr *wr_failed;
 	int rc;
 
@@ -2930,7 +2930,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		wr->send_wr_num += 1;
 	}
 
-	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
+	rc = ib_post_send(isert_conn->qp, wr->send_wr, &wr_failed);
 	if (rc)
 		isert_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
 
@@ -2951,7 +2951,7 @@ isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct isert_conn *isert_conn = conn->context;
-	struct isert_device *device = isert_conn->conn_device;
+	struct isert_device *device = isert_conn->device;
 	struct ib_send_wr *wr_failed;
 	int rc;
 
@@ -2964,7 +2964,7 @@ isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 		return rc;
 	}
 
-	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
+	rc = ib_post_send(isert_conn->qp, wr->send_wr, &wr_failed);
 	if (rc)
 		isert_warn("ib_post_send() failed for IB_WR_RDMA_READ\n");
 
@@ -3117,7 +3117,7 @@ out:
 static int
 isert_rdma_accept(struct isert_conn *isert_conn)
 {
-	struct rdma_cm_id *cm_id = isert_conn->conn_cm_id;
+	struct rdma_cm_id *cm_id = isert_conn->cm_id;
 	struct rdma_conn_param cp;
 	int ret;
 
@@ -3161,8 +3161,8 @@ isert_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
 
 	isert_rx_login_req(isert_conn);
 
-	isert_info("before conn_login_comp conn: %p\n", conn);
-	ret = wait_for_completion_interruptible(&isert_conn->conn_login_comp);
+	isert_info("before login_comp conn: %p\n", conn);
+	ret = wait_for_completion_interruptible(&isert_conn->login_comp);
 	if (ret)
 		return ret;
 
@@ -3175,7 +3175,7 @@ static void
 isert_set_conn_info(struct iscsi_np *np, struct iscsi_conn *conn,
 		    struct isert_conn *isert_conn)
 {
-	struct rdma_cm_id *cm_id = isert_conn->conn_cm_id;
+	struct rdma_cm_id *cm_id = isert_conn->cm_id;
 	struct rdma_route *cm_route = &cm_id->route;
 	struct sockaddr_in *sock_in;
 	struct sockaddr_in6 *sock_in6;
@@ -3236,8 +3236,8 @@ accept_wait:
 		goto accept_wait;
 	}
 	isert_conn = list_first_entry(&isert_np->np_accept_list,
-			struct isert_conn, conn_accept_node);
-	list_del_init(&isert_conn->conn_accept_node);
+			struct isert_conn, accept_node);
+	list_del_init(&isert_conn->accept_node);
 	mutex_unlock(&isert_np->np_accept_mutex);
 
 	conn->context = isert_conn;
@@ -3271,7 +3271,7 @@ isert_free_np(struct iscsi_np *np)
 		isert_info("Still have isert connections, cleaning up...\n");
 		list_for_each_entry_safe(isert_conn, n,
 					 &isert_np->np_accept_list,
-					 conn_accept_node) {
+					 accept_node) {
 			isert_info("cleaning isert_conn %p state (%d)\n",
 				   isert_conn, isert_conn->state);
 			isert_connect_release(isert_conn);
@@ -3291,11 +3291,11 @@ static void isert_release_work(struct work_struct *work)
 
 	isert_info("Starting release conn %p\n", isert_conn);
 
-	wait_for_completion(&isert_conn->conn_wait);
+	wait_for_completion(&isert_conn->wait);
 
-	mutex_lock(&isert_conn->conn_mutex);
+	mutex_lock(&isert_conn->mutex);
 	isert_conn->state = ISER_CONN_DOWN;
-	mutex_unlock(&isert_conn->conn_mutex);
+	mutex_unlock(&isert_conn->mutex);
 
 	isert_info("Destroying conn %p\n", isert_conn);
 	isert_put_conn(isert_conn);
@@ -3333,15 +3333,15 @@ isert_wait4flush(struct isert_conn *isert_conn)
 
 	isert_info("conn %p\n", isert_conn);
 
-	init_completion(&isert_conn->conn_wait_comp_err);
+	init_completion(&isert_conn->wait_comp_err);
 	isert_conn->beacon.wr_id = ISER_BEACON_WRID;
 	/* post an indication that all flush errors were consumed */
-	if (ib_post_recv(isert_conn->conn_qp, &isert_conn->beacon, &bad_wr)) {
+	if (ib_post_recv(isert_conn->qp, &isert_conn->beacon, &bad_wr)) {
 		isert_err("conn %p failed to post beacon", isert_conn);
 		return;
 	}
 
-	wait_for_completion(&isert_conn->conn_wait_comp_err);
+	wait_for_completion(&isert_conn->wait_comp_err);
 }
 
 static void isert_wait_conn(struct iscsi_conn *conn)
@@ -3350,17 +3350,17 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 
 	isert_info("Starting conn %p\n", isert_conn);
 
-	mutex_lock(&isert_conn->conn_mutex);
+	mutex_lock(&isert_conn->mutex);
 	/*
-	 * Only wait for conn_wait_comp_err if the isert_conn made it
+	 * Only wait for wait_comp_err if the isert_conn made it
 	 * into full feature phase..
 	 */
 	if (isert_conn->state == ISER_CONN_INIT) {
-		mutex_unlock(&isert_conn->conn_mutex);
+		mutex_unlock(&isert_conn->mutex);
 		return;
 	}
 	isert_conn_terminate(isert_conn);
-	mutex_unlock(&isert_conn->conn_mutex);
+	mutex_unlock(&isert_conn->mutex);
 
 	isert_wait4cmds(conn);
 	isert_wait4flush(isert_conn);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 651c58e..9ec23a7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -159,25 +159,25 @@ struct isert_conn {
 	u64			login_req_dma;
 	int			login_req_len;
 	u64			login_rsp_dma;
-	unsigned int		conn_rx_desc_head;
-	struct iser_rx_desc	*conn_rx_descs;
-	struct ib_recv_wr	conn_rx_wr[ISERT_MIN_POSTED_RX];
+	unsigned int		rx_desc_head;
+	struct iser_rx_desc	*rx_descs;
+	struct ib_recv_wr	rx_wr[ISERT_MIN_POSTED_RX];
 	struct iscsi_conn	*conn;
-	struct list_head	conn_accept_node;
-	struct completion	conn_login_comp;
+	struct list_head	accept_node;
+	struct completion	login_comp;
 	struct completion	login_req_comp;
-	struct iser_tx_desc	conn_login_tx_desc;
-	struct rdma_cm_id	*conn_cm_id;
-	struct ib_qp		*conn_qp;
-	struct isert_device	*conn_device;
-	struct mutex		conn_mutex;
-	struct completion	conn_wait;
-	struct completion	conn_wait_comp_err;
-	struct kref		conn_kref;
-	struct list_head	conn_fr_pool;
-	int			conn_fr_pool_size;
+	struct iser_tx_desc	login_tx_desc;
+	struct rdma_cm_id	*cm_id;
+	struct ib_qp		*qp;
+	struct isert_device	*device;
+	struct mutex		mutex;
+	struct completion	wait;
+	struct completion	wait_comp_err;
+	struct kref		kref;
+	struct list_head	fr_pool;
+	int			fr_pool_size;
 	/* lock to protect fastreg pool */
-	spinlock_t		conn_lock;
+	spinlock_t		pool_lock;
 	struct work_struct	release_work;
 	struct ib_recv_wr       beacon;
 	bool                    logout_posted;
-- 
1.7.1

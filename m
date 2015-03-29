From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 13/18] iser-target: Split some logic in isert_connect_request to routines
Date: Sun, 29 Mar 2015 15:52:15 +0300
Message-ID: <1427633540-30352-14-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Move login buffer alloc/free code to dedicated
routines and introduce isert_conn_init which
initializes the connection lists and locks.

Simplifies and cleans up the code a little bit.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  118 ++++++++++++++++++-------------
 1 files changed, 70 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index d19271b..4fddc08 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -636,32 +636,9 @@ err:
 	return ret;
 }
 
-static int
-isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
+static void
+isert_init_conn(struct isert_conn *isert_conn)
 {
-	struct isert_np *isert_np = cma_id->context;
-	struct iscsi_np *np = isert_np->np;
-	struct isert_conn *isert_conn;
-	struct isert_device *device;
-	struct ib_device *ib_dev = cma_id->device;
-	int ret = 0;
-
-	spin_lock_bh(&np->np_thread_lock);
-	if (!np->enabled) {
-		spin_unlock_bh(&np->np_thread_lock);
-		isert_dbg("iscsi_np is not enabled, reject connect request\n");
-		return rdma_reject(cma_id, NULL, 0);
-	}
-	spin_unlock_bh(&np->np_thread_lock);
-
-	isert_dbg("cma_id: %p, portal: %p\n",
-		 cma_id, cma_id->context);
-
-	isert_conn = kzalloc(sizeof(struct isert_conn), GFP_KERNEL);
-	if (!isert_conn) {
-		isert_err("Unable to allocate isert_conn\n");
-		return -ENOMEM;
-	}
 	isert_conn->state = ISER_CONN_INIT;
 	INIT_LIST_HEAD(&isert_conn->conn_accept_node);
 	init_completion(&isert_conn->conn_login_comp);
@@ -671,20 +648,38 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	mutex_init(&isert_conn->conn_mutex);
 	spin_lock_init(&isert_conn->conn_lock);
 	INIT_LIST_HEAD(&isert_conn->conn_fr_pool);
+}
 
-	isert_conn->conn_cm_id = cma_id;
+static void
+isert_free_login_buf(struct isert_conn *isert_conn)
+{
+	struct ib_device *ib_dev = isert_conn->conn_device->ib_device;
+
+	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
+			    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
+	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
+			    ISCSI_DEF_MAX_RECV_SEG_LEN,
+			    DMA_FROM_DEVICE);
+	kfree(isert_conn->login_buf);
+}
+
+static int
+isert_alloc_login_buf(struct isert_conn *isert_conn,
+		      struct ib_device *ib_dev)
+{
+	int ret;
 
 	isert_conn->login_buf = kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
 					ISER_RX_LOGIN_SIZE, GFP_KERNEL);
 	if (!isert_conn->login_buf) {
 		isert_err("Unable to allocate isert_conn->login_buf\n");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	isert_conn->login_req_buf = isert_conn->login_buf;
 	isert_conn->login_rsp_buf = isert_conn->login_buf +
 				    ISCSI_DEF_MAX_RECV_SEG_LEN;
+
 	isert_dbg("Set login_buf: %p login_req_buf: %p login_rsp_buf: %p\n",
 		 isert_conn->login_buf, isert_conn->login_req_buf,
 		 isert_conn->login_rsp_buf);
@@ -695,8 +690,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 
 	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_req_dma);
 	if (ret) {
-		isert_err("ib_dma_mapping_error failed for login_req_dma: %d\n",
-		       ret);
+		isert_err("login_req_dma mapping error: %d\n", ret);
 		isert_conn->login_req_dma = 0;
 		goto out_login_buf;
 	}
@@ -707,12 +701,52 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 
 	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_rsp_dma);
 	if (ret) {
-		isert_err("ib_dma_mapping_error failed for login_rsp_dma: %d\n",
-		       ret);
+		isert_err("login_rsp_dma mapping error: %d\n", ret);
 		isert_conn->login_rsp_dma = 0;
 		goto out_req_dma_map;
 	}
 
+	return 0;
+
+out_req_dma_map:
+	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
+			    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_FROM_DEVICE);
+out_login_buf:
+	kfree(isert_conn->login_buf);
+	return ret;
+}
+
+static int
+isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
+{
+	struct isert_np *isert_np = cma_id->context;
+	struct iscsi_np *np = isert_np->np;
+	struct isert_conn *isert_conn;
+	struct isert_device *device;
+	int ret = 0;
+
+	spin_lock_bh(&np->np_thread_lock);
+	if (!np->enabled) {
+		spin_unlock_bh(&np->np_thread_lock);
+		isert_dbg("iscsi_np is not enabled, reject connect request\n");
+		return rdma_reject(cma_id, NULL, 0);
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
+	isert_dbg("cma_id: %p, portal: %p\n",
+		 cma_id, cma_id->context);
+
+	isert_conn = kzalloc(sizeof(struct isert_conn), GFP_KERNEL);
+	if (!isert_conn)
+		return -ENOMEM;
+
+	isert_init_conn(isert_conn);
+	isert_conn->conn_cm_id = cma_id;
+
+	ret = isert_alloc_login_buf(isert_conn, cma_id->device);
+	if (ret)
+		goto out;
+
 	device = isert_device_get(cma_id);
 	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
@@ -749,13 +783,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 out_conn_dev:
 	isert_device_put(device);
 out_rsp_dma_map:
-	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
-			    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
-out_req_dma_map:
-	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
-			    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_FROM_DEVICE);
-out_login_buf:
-	kfree(isert_conn->login_buf);
+	isert_free_login_buf(isert_conn);
 out:
 	kfree(isert_conn);
 	rdma_reject(cma_id, NULL, 0);
@@ -766,7 +794,6 @@ static void
 isert_connect_release(struct isert_conn *isert_conn)
 {
 	struct isert_device *device = isert_conn->conn_device;
-	struct ib_device *ib_dev = device->ib_device;
 
 	isert_dbg("conn %p\n", isert_conn);
 
@@ -784,14 +811,9 @@ isert_connect_release(struct isert_conn *isert_conn)
 		ib_destroy_qp(isert_conn->conn_qp);
 	}
 
-	if (isert_conn->login_buf) {
-		ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
-				    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
-		ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
-				    ISCSI_DEF_MAX_RECV_SEG_LEN,
-				    DMA_FROM_DEVICE);
-		kfree(isert_conn->login_buf);
-	}
+	if (isert_conn->login_buf)
+		isert_free_login_buf(isert_conn);
+
 	kfree(isert_conn);
 
 	if (device)
-- 
1.7.1

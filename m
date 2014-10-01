From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 01/21] IB/iser: Rename ib_conn -> iser_conn
Date: Wed,  1 Oct 2014 14:01:57 +0300
Message-ID: <1412161337-25285-2-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Two reasons why we choose to do this:
1. No point today calling struct iser_conn by another name ib_conn
2. In the next patches we will restructure iser control plane representation
   - struct iser_conn: connection logical representation
   - struct ib_conn: connection RDMA layout representation

This patch does not change any functionality

Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  125 +++++-----
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   44 ++--
 drivers/infiniband/ulp/iser/iser_initiator.c |  197 +++++++-------
 drivers/infiniband/ulp/iser/iser_memory.c    |   54 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c     |  375 +++++++++++++-------------
 5 files changed, 403 insertions(+), 392 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 93ce62f..1f3ad2b 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -147,8 +147,8 @@ static int iscsi_iser_pdu_alloc(struct iscsi_task *task, uint8_t opcode)
 int iser_initialize_task_headers(struct iscsi_task *task,
 						struct iser_tx_desc *tx_desc)
 {
-	struct iser_conn       *ib_conn   = task->conn->dd_data;
-	struct iser_device     *device    = ib_conn->device;
+	struct iser_conn       *iser_conn   = task->conn->dd_data;
+	struct iser_device     *device    = iser_conn->device;
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	u64 dma_addr;
 
@@ -162,7 +162,7 @@ int iser_initialize_task_headers(struct iscsi_task *task,
 	tx_desc->tx_sg[0].length = ISER_HEADERS_LEN;
 	tx_desc->tx_sg[0].lkey   = device->mr->lkey;
 
-	iser_task->ib_conn = ib_conn;
+	iser_task->iser_conn = iser_conn;
 	return 0;
 }
 /**
@@ -290,8 +290,8 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_tx_desc    *tx_desc   = &iser_task->desc;
-	struct iser_conn       *ib_conn	  = task->conn->dd_data;
-	struct iser_device     *device	  = ib_conn->device;
+	struct iser_conn       *iser_conn	  = task->conn->dd_data;
+	struct iser_device     *device	  = iser_conn->device;
 
 	ib_dma_unmap_single(device->ib_device,
 		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
@@ -344,7 +344,7 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 		     int is_leading)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 	struct iscsi_endpoint *ep;
 	int error;
 
@@ -360,30 +360,30 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 			 (unsigned long long)transport_eph);
 		return -EINVAL;
 	}
-	ib_conn = ep->dd_data;
+	iser_conn = ep->dd_data;
 
-	mutex_lock(&ib_conn->state_mutex);
-	if (ib_conn->state != ISER_CONN_UP) {
+	mutex_lock(&iser_conn->state_mutex);
+	if (iser_conn->state != ISER_CONN_UP) {
 		error = -EINVAL;
 		iser_err("iser_conn %p state is %d, teardown started\n",
-			 ib_conn, ib_conn->state);
+			 iser_conn, iser_conn->state);
 		goto out;
 	}
 
-	error = iser_alloc_rx_descriptors(ib_conn, conn->session);
+	error = iser_alloc_rx_descriptors(iser_conn, conn->session);
 	if (error)
 		goto out;
 
 	/* binds the iSER connection retrieved from the previously
 	 * connected ep_handle to the iSCSI layer connection. exchanges
 	 * connection pointers */
-	iser_info("binding iscsi conn %p to ib_conn %p\n", conn, ib_conn);
+	iser_info("binding iscsi conn %p to iser_conn %p\n", conn, iser_conn);
 
-	conn->dd_data = ib_conn;
-	ib_conn->iscsi_conn = conn;
+	conn->dd_data = iser_conn;
+	iser_conn->iscsi_conn = conn;
 
 out:
-	mutex_unlock(&ib_conn->state_mutex);
+	mutex_unlock(&iser_conn->state_mutex);
 	return error;
 }
 
@@ -391,11 +391,11 @@ static int
 iscsi_iser_conn_start(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *iscsi_conn;
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 
 	iscsi_conn = cls_conn->dd_data;
-	ib_conn = iscsi_conn->dd_data;
-	reinit_completion(&ib_conn->stop_completion);
+	iser_conn = iscsi_conn->dd_data;
+	reinit_completion(&iser_conn->stop_completion);
 
 	return iscsi_conn_start(cls_conn);
 }
@@ -404,18 +404,18 @@ static void
 iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iser_conn *ib_conn = conn->dd_data;
+	struct iser_conn *iser_conn = conn->dd_data;
 
-	iser_dbg("stopping iscsi_conn: %p, ib_conn: %p\n", conn, ib_conn);
+	iser_dbg("stopping iscsi_conn: %p, iser_conn: %p\n", conn, iser_conn);
 	iscsi_conn_stop(cls_conn, flag);
 
 	/*
 	 * Userspace may have goofed up and not bound the connection or
 	 * might have only partially setup the connection.
 	 */
-	if (ib_conn) {
+	if (iser_conn) {
 		conn->dd_data = NULL;
-		complete(&ib_conn->stop_completion);
+		complete(&iser_conn->stop_completion);
 	}
 }
 
@@ -447,7 +447,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct Scsi_Host *shost;
-	struct iser_conn *ib_conn = NULL;
+	struct iser_conn *iser_conn = NULL;
 
 	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 0);
 	if (!shost)
@@ -464,9 +464,9 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	 * the leading conn's ep so this will be NULL;
 	 */
 	if (ep) {
-		ib_conn = ep->dd_data;
-		if (ib_conn->pi_support) {
-			u32 sig_caps = ib_conn->device->dev_attr.sig_prot_cap;
+		iser_conn = ep->dd_data;
+		if (iser_conn->pi_support) {
+			u32 sig_caps = iser_conn->device->dev_attr.sig_prot_cap;
 
 			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
 			if (iser_pi_guard)
@@ -476,8 +476,8 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		}
 	}
 
-	if (iscsi_host_add(shost,
-			   ep ? ib_conn->device->ib_device->dma_device : NULL))
+	if (iscsi_host_add(shost, ep ?
+			   iser_conn->device->ib_device->dma_device : NULL))
 		goto free_host;
 
 	if (cmds_max > ISER_DEF_XMIT_CMDS_MAX) {
@@ -577,17 +577,17 @@ iscsi_iser_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *s
 static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
 				   enum iscsi_param param, char *buf)
 {
-	struct iser_conn *ib_conn = ep->dd_data;
+	struct iser_conn *iser_conn = ep->dd_data;
 	int len;
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
 	case ISCSI_PARAM_CONN_ADDRESS:
-		if (!ib_conn || !ib_conn->cma_id)
+		if (!iser_conn || !iser_conn->cma_id)
 			return -ENOTCONN;
 
 		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
-					&ib_conn->cma_id->route.addr.dst_addr,
+					&iser_conn->cma_id->route.addr.dst_addr,
 					param, buf);
 		break;
 	default:
@@ -602,24 +602,24 @@ iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		      int non_blocking)
 {
 	int err;
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 	struct iscsi_endpoint *ep;
 
 	ep = iscsi_create_endpoint(0);
 	if (!ep)
 		return ERR_PTR(-ENOMEM);
 
-	ib_conn = kzalloc(sizeof(*ib_conn), GFP_KERNEL);
-	if (!ib_conn) {
+	iser_conn = kzalloc(sizeof(*iser_conn), GFP_KERNEL);
+	if (!iser_conn) {
 		err = -ENOMEM;
 		goto failure;
 	}
 
-	ep->dd_data = ib_conn;
-	ib_conn->ep = ep;
-	iser_conn_init(ib_conn);
+	ep->dd_data = iser_conn;
+	iser_conn->ep = ep;
+	iser_conn_init(iser_conn);
 
-	err = iser_connect(ib_conn, NULL, dst_addr, non_blocking);
+	err = iser_connect(iser_conn, NULL, dst_addr, non_blocking);
 	if (err)
 		goto failure;
 
@@ -632,22 +632,22 @@ failure:
 static int
 iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 {
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 	int rc;
 
-	ib_conn = ep->dd_data;
-	rc = wait_for_completion_interruptible_timeout(&ib_conn->up_completion,
+	iser_conn = ep->dd_data;
+	rc = wait_for_completion_interruptible_timeout(&iser_conn->up_completion,
 						       msecs_to_jiffies(timeout_ms));
 	/* if conn establishment failed, return error code to iscsi */
 	if (rc == 0) {
-		mutex_lock(&ib_conn->state_mutex);
-		if (ib_conn->state == ISER_CONN_TERMINATING ||
-		    ib_conn->state == ISER_CONN_DOWN)
+		mutex_lock(&iser_conn->state_mutex);
+		if (iser_conn->state == ISER_CONN_TERMINATING ||
+		    iser_conn->state == ISER_CONN_DOWN)
 			rc = -1;
-		mutex_unlock(&ib_conn->state_mutex);
+		mutex_unlock(&iser_conn->state_mutex);
 	}
 
-	iser_info("ib conn %p rc = %d\n", ib_conn, rc);
+	iser_info("ib conn %p rc = %d\n", iser_conn, rc);
 
 	if (rc > 0)
 		return 1; /* success, this is the equivalent of POLLOUT */
@@ -660,12 +660,14 @@ iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 static void
 iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 {
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 
-	ib_conn = ep->dd_data;
-	iser_info("ep %p ib conn %p state %d\n", ep, ib_conn, ib_conn->state);
-	mutex_lock(&ib_conn->state_mutex);
-	iser_conn_terminate(ib_conn);
+	iser_conn = ep->dd_data;
+	iser_info("ep %p iser conn %p state %d\n",
+		  ep, iser_conn, iser_conn->state);
+
+	mutex_lock(&iser_conn->state_mutex);
+	iser_conn_terminate(iser_conn);
 
 	/*
 	 * if iser_conn and iscsi_conn are bound, we must wait for
@@ -673,14 +675,14 @@ iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 	 * the iser resources. Otherwise we are safe to free resources
 	 * immediately.
 	 */
-	if (ib_conn->iscsi_conn) {
-		INIT_WORK(&ib_conn->release_work, iser_release_work);
-		queue_work(release_wq, &ib_conn->release_work);
-		mutex_unlock(&ib_conn->state_mutex);
+	if (iser_conn->iscsi_conn) {
+		INIT_WORK(&iser_conn->release_work, iser_release_work);
+		queue_work(release_wq, &iser_conn->release_work);
+		mutex_unlock(&iser_conn->state_mutex);
 	} else {
-		ib_conn->state = ISER_CONN_DOWN;
-		mutex_unlock(&ib_conn->state_mutex);
-		iser_conn_release(ib_conn);
+		iser_conn->state = ISER_CONN_DOWN;
+		mutex_unlock(&iser_conn->state_mutex);
+		iser_conn_release(iser_conn);
 	}
 	iscsi_destroy_endpoint(ep);
 }
@@ -843,7 +845,7 @@ register_transport_failure:
 
 static void __exit iser_exit(void)
 {
-	struct iser_conn *ib_conn, *n;
+	struct iser_conn *iser_conn, *n;
 	int connlist_empty;
 
 	iser_dbg("Removing iSER datamover...\n");
@@ -856,8 +858,9 @@ static void __exit iser_exit(void)
 	if (!connlist_empty) {
 		iser_err("Error cleanup stage completed but we still have iser "
 			 "connections, destroying them anyway.\n");
-		list_for_each_entry_safe(ib_conn, n, &ig.connlist, conn_list) {
-			iser_conn_release(ib_conn);
+		list_for_each_entry_safe(iser_conn, n, &ig.connlist,
+					 conn_list) {
+			iser_conn_release(iser_conn);
 		}
 	}
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 9f0e0e3..ec34b8f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -179,7 +179,7 @@ struct iser_cm_hdr {
 /* Length of an object name string */
 #define ISER_OBJECT_NAME_SIZE		    64
 
-enum iser_ib_conn_state {
+enum iser_conn_state {
 	ISER_CONN_INIT,		   /* descriptor allocd, no conn          */
 	ISER_CONN_PENDING,	   /* in the process of being established */
 	ISER_CONN_UP,		   /* up and running                      */
@@ -281,9 +281,9 @@ struct iser_device {
 	int                          cq_active_qps[ISER_MAX_CQ];
 	int			     cqs_used;
 	struct iser_cq_desc	     *cq_desc;
-	int                          (*iser_alloc_rdma_reg_res)(struct iser_conn *ib_conn,
+	int                          (*iser_alloc_rdma_reg_res)(struct iser_conn *iser_conn,
 								unsigned cmds_max);
-	void                         (*iser_free_rdma_reg_res)(struct iser_conn *ib_conn);
+	void                         (*iser_free_rdma_reg_res)(struct iser_conn *iser_conn);
 	int                          (*iser_reg_rdma_mem)(struct iscsi_iser_task *iser_task,
 							  enum iser_data_dir cmd_dir);
 	void                         (*iser_unreg_rdma_mem)(struct iscsi_iser_task *iser_task,
@@ -320,7 +320,7 @@ struct fast_reg_descriptor {
 struct iser_conn {
 	struct iscsi_conn	     *iscsi_conn;
 	struct iscsi_endpoint	     *ep;
-	enum iser_ib_conn_state	     state;	    /* rdma connection state   */
+	enum iser_conn_state	     state;	    /* rdma connection state   */
 	atomic_t		     refcount;
 	spinlock_t		     lock;	    /* used for state changes  */
 	struct iser_device           *device;       /* device context          */
@@ -363,7 +363,7 @@ struct iser_conn {
 
 struct iscsi_iser_task {
 	struct iser_tx_desc          desc;
-	struct iser_conn	     *ib_conn;
+	struct iser_conn	     *iser_conn;
 	enum iser_task_status 	     status;
 	struct scsi_cmnd	     *sc;
 	int                          command_sent;  /* set if command  sent  */
@@ -419,25 +419,26 @@ void iscsi_iser_recv(struct iscsi_conn *conn,
 		     char                   *rx_data,
 		     int                    rx_data_len);
 
-void iser_conn_init(struct iser_conn *ib_conn);
+void iser_conn_init(struct iser_conn *iser_conn);
 
-void iser_conn_release(struct iser_conn *ib_conn);
+void iser_conn_release(struct iser_conn *iser_conn);
 
-void iser_conn_terminate(struct iser_conn *ib_conn);
+void iser_conn_terminate(struct iser_conn *iser_conn);
 
 void iser_release_work(struct work_struct *work);
 
 void iser_rcv_completion(struct iser_rx_desc *desc,
 			 unsigned long    dto_xfer_len,
-			struct iser_conn *ib_conn);
+			struct iser_conn *iser_conn);
 
-void iser_snd_completion(struct iser_tx_desc *desc, struct iser_conn *ib_conn);
+void iser_snd_completion(struct iser_tx_desc *desc,
+			 struct iser_conn *iser_conn);
 
 void iser_task_rdma_init(struct iscsi_iser_task *task);
 
 void iser_task_rdma_finalize(struct iscsi_iser_task *task);
 
-void iser_free_rx_descriptors(struct iser_conn *ib_conn);
+void iser_free_rx_descriptors(struct iser_conn *iser_conn);
 
 void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 				     struct iser_data_buf *mem,
@@ -449,12 +450,12 @@ int  iser_reg_rdma_mem_fmr(struct iscsi_iser_task *task,
 int  iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *task,
 			       enum iser_data_dir cmd_dir);
 
-int  iser_connect(struct iser_conn   *ib_conn,
+int  iser_connect(struct iser_conn   *iser_conn,
 		  struct sockaddr    *src_addr,
 		  struct sockaddr    *dst_addr,
 		  int                non_blocking);
 
-int  iser_reg_page_vec(struct iser_conn     *ib_conn,
+int  iser_reg_page_vec(struct iser_conn     *iser_conn,
 		       struct iser_page_vec *page_vec,
 		       struct iser_mem_reg  *mem_reg);
 
@@ -463,9 +464,9 @@ void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 			    enum iser_data_dir cmd_dir);
 
-int  iser_post_recvl(struct iser_conn *ib_conn);
-int  iser_post_recvm(struct iser_conn *ib_conn, int count);
-int  iser_post_send(struct iser_conn *ib_conn, struct iser_tx_desc *tx_desc);
+int  iser_post_recvl(struct iser_conn *iser_conn);
+int  iser_post_recvm(struct iser_conn *iser_conn, int count);
+int  iser_post_send(struct iser_conn *iser_conn, struct iser_tx_desc *tx_desc);
 
 int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 			    struct iser_data_buf       *data,
@@ -476,11 +477,12 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
 			      struct iser_data_buf *data);
 int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
-int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *session);
-int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max);
-void iser_free_fmr_pool(struct iser_conn *ib_conn);
-int iser_create_fastreg_pool(struct iser_conn *ib_conn, unsigned cmds_max);
-void iser_free_fastreg_pool(struct iser_conn *ib_conn);
+int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
+			      struct iscsi_session *session);
+int iser_create_fmr_pool(struct iser_conn *iser_conn, unsigned cmds_max);
+void iser_free_fmr_pool(struct iser_conn *iser_conn);
+int iser_create_fastreg_pool(struct iser_conn *iser_conn, unsigned cmds_max);
+void iser_free_fastreg_pool(struct iser_conn *iser_conn);
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 8d44a40..1f53ccb 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -49,7 +49,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_device  *device = iser_task->ib_conn->device;
+	struct iser_device  *device = iser_task->iser_conn->device;
 	struct iser_regd_buf *regd_buf;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
@@ -103,7 +103,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 		       unsigned int edtl)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_device  *device = iser_task->ib_conn->device;
+	struct iser_device  *device = iser_task->iser_conn->device;
 	struct iser_regd_buf *regd_buf;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
@@ -160,10 +160,10 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 }
 
 /* creates a new tx descriptor and adds header regd buffer */
-static void iser_create_send_desc(struct iser_conn	*ib_conn,
+static void iser_create_send_desc(struct iser_conn	*iser_conn,
 				  struct iser_tx_desc	*tx_desc)
 {
-	struct iser_device *device = ib_conn->device;
+	struct iser_device *device = iser_conn->device;
 
 	ib_dma_sync_single_for_cpu(device->ib_device,
 		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
@@ -179,103 +179,106 @@ static void iser_create_send_desc(struct iser_conn	*ib_conn,
 	}
 }
 
-static void iser_free_login_buf(struct iser_conn *ib_conn)
+static void iser_free_login_buf(struct iser_conn *iser_conn)
 {
-	if (!ib_conn->login_buf)
+	if (!iser_conn->login_buf)
 		return;
 
-	if (ib_conn->login_req_dma)
-		ib_dma_unmap_single(ib_conn->device->ib_device,
-				    ib_conn->login_req_dma,
+	if (iser_conn->login_req_dma)
+		ib_dma_unmap_single(iser_conn->device->ib_device,
+				    iser_conn->login_req_dma,
 				    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
 
-	if (ib_conn->login_resp_dma)
-		ib_dma_unmap_single(ib_conn->device->ib_device,
-				    ib_conn->login_resp_dma,
+	if (iser_conn->login_resp_dma)
+		ib_dma_unmap_single(iser_conn->device->ib_device,
+				    iser_conn->login_resp_dma,
 				    ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
 
-	kfree(ib_conn->login_buf);
+	kfree(iser_conn->login_buf);
 
 	/* make sure we never redo any unmapping */
-	ib_conn->login_req_dma = 0;
-	ib_conn->login_resp_dma = 0;
-	ib_conn->login_buf = NULL;
+	iser_conn->login_req_dma = 0;
+	iser_conn->login_resp_dma = 0;
+	iser_conn->login_buf = NULL;
 }
 
-static int iser_alloc_login_buf(struct iser_conn *ib_conn)
+static int iser_alloc_login_buf(struct iser_conn *iser_conn)
 {
 	struct iser_device	*device;
 	int			req_err, resp_err;
 
-	BUG_ON(ib_conn->device == NULL);
+	BUG_ON(iser_conn->device == NULL);
 
-	device = ib_conn->device;
+	device = iser_conn->device;
 
-	ib_conn->login_buf = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
+	iser_conn->login_buf = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
 				     ISER_RX_LOGIN_SIZE, GFP_KERNEL);
-	if (!ib_conn->login_buf)
+	if (!iser_conn->login_buf)
 		goto out_err;
 
-	ib_conn->login_req_buf  = ib_conn->login_buf;
-	ib_conn->login_resp_buf = ib_conn->login_buf +
+	iser_conn->login_req_buf  = iser_conn->login_buf;
+	iser_conn->login_resp_buf = iser_conn->login_buf +
 						ISCSI_DEF_MAX_RECV_SEG_LEN;
 
-	ib_conn->login_req_dma = ib_dma_map_single(ib_conn->device->ib_device,
-				(void *)ib_conn->login_req_buf,
-				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+	iser_conn->login_req_dma = ib_dma_map_single(device->ib_device,
+						     iser_conn->login_req_buf,
+						     ISCSI_DEF_MAX_RECV_SEG_LEN,
+						     DMA_TO_DEVICE);
 
-	ib_conn->login_resp_dma = ib_dma_map_single(ib_conn->device->ib_device,
-				(void *)ib_conn->login_resp_buf,
-				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+	iser_conn->login_resp_dma = ib_dma_map_single(device->ib_device,
+						      iser_conn->login_resp_buf,
+						      ISER_RX_LOGIN_SIZE,
+						      DMA_FROM_DEVICE);
 
 	req_err  = ib_dma_mapping_error(device->ib_device,
-					ib_conn->login_req_dma);
+					iser_conn->login_req_dma);
 	resp_err = ib_dma_mapping_error(device->ib_device,
-					ib_conn->login_resp_dma);
+					iser_conn->login_resp_dma);
 
 	if (req_err || resp_err) {
 		if (req_err)
-			ib_conn->login_req_dma = 0;
+			iser_conn->login_req_dma = 0;
 		if (resp_err)
-			ib_conn->login_resp_dma = 0;
+			iser_conn->login_resp_dma = 0;
 		goto free_login_buf;
 	}
 	return 0;
 
 free_login_buf:
-	iser_free_login_buf(ib_conn);
+	iser_free_login_buf(iser_conn);
 
 out_err:
 	iser_err("unable to alloc or map login buf\n");
 	return -ENOMEM;
 }
 
-int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *session)
+int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
+			      struct iscsi_session *session)
 {
 	int i, j;
 	u64 dma_addr;
 	struct iser_rx_desc *rx_desc;
 	struct ib_sge       *rx_sg;
-	struct iser_device  *device = ib_conn->device;
+	struct iser_device  *device = iser_conn->device;
 
-	ib_conn->qp_max_recv_dtos = session->cmds_max;
-	ib_conn->qp_max_recv_dtos_mask = session->cmds_max - 1; /* cmds_max is 2^N */
-	ib_conn->min_posted_rx = ib_conn->qp_max_recv_dtos >> 2;
+	iser_conn->qp_max_recv_dtos = session->cmds_max;
+	iser_conn->qp_max_recv_dtos_mask = session->cmds_max - 1; /* cmds_max is 2^N */
+	iser_conn->min_posted_rx = iser_conn->qp_max_recv_dtos >> 2;
 
-	if (device->iser_alloc_rdma_reg_res(ib_conn, session->scsi_cmds_max))
+	if (device->iser_alloc_rdma_reg_res(iser_conn, session->scsi_cmds_max))
 		goto create_rdma_reg_res_failed;
 
-	if (iser_alloc_login_buf(ib_conn))
+	if (iser_alloc_login_buf(iser_conn))
 		goto alloc_login_buf_fail;
 
-	ib_conn->rx_descs = kmalloc(session->cmds_max *
+	iser_conn->rx_descs = kmalloc(session->cmds_max *
 				sizeof(struct iser_rx_desc), GFP_KERNEL);
-	if (!ib_conn->rx_descs)
+	if (!iser_conn->rx_descs)
 		goto rx_desc_alloc_fail;
 
-	rx_desc = ib_conn->rx_descs;
+	rx_desc = iser_conn->rx_descs;
 
-	for (i = 0; i < ib_conn->qp_max_recv_dtos; i++, rx_desc++)  {
+	for (i = 0; i < iser_conn->qp_max_recv_dtos; i++, rx_desc++)  {
 		dma_addr = ib_dma_map_single(device->ib_device, (void *)rx_desc,
 					ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 		if (ib_dma_mapping_error(device->ib_device, dma_addr))
@@ -289,52 +292,52 @@ int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *s
 		rx_sg->lkey   = device->mr->lkey;
 	}
 
-	ib_conn->rx_desc_head = 0;
+	iser_conn->rx_desc_head = 0;
 	return 0;
 
 rx_desc_dma_map_failed:
-	rx_desc = ib_conn->rx_descs;
+	rx_desc = iser_conn->rx_descs;
 	for (j = 0; j < i; j++, rx_desc++)
 		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
 				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
-	kfree(ib_conn->rx_descs);
-	ib_conn->rx_descs = NULL;
+	kfree(iser_conn->rx_descs);
+	iser_conn->rx_descs = NULL;
 rx_desc_alloc_fail:
-	iser_free_login_buf(ib_conn);
+	iser_free_login_buf(iser_conn);
 alloc_login_buf_fail:
-	device->iser_free_rdma_reg_res(ib_conn);
+	device->iser_free_rdma_reg_res(iser_conn);
 create_rdma_reg_res_failed:
 	iser_err("failed allocating rx descriptors / data buffers\n");
 	return -ENOMEM;
 }
 
-void iser_free_rx_descriptors(struct iser_conn *ib_conn)
+void iser_free_rx_descriptors(struct iser_conn *iser_conn)
 {
 	int i;
 	struct iser_rx_desc *rx_desc;
-	struct iser_device *device = ib_conn->device;
+	struct iser_device *device = iser_conn->device;
 
-	if (!ib_conn->rx_descs)
+	if (!iser_conn->rx_descs)
 		goto free_login_buf;
 
 	if (device->iser_free_rdma_reg_res)
-		device->iser_free_rdma_reg_res(ib_conn);
+		device->iser_free_rdma_reg_res(iser_conn);
 
-	rx_desc = ib_conn->rx_descs;
-	for (i = 0; i < ib_conn->qp_max_recv_dtos; i++, rx_desc++)
+	rx_desc = iser_conn->rx_descs;
+	for (i = 0; i < iser_conn->qp_max_recv_dtos; i++, rx_desc++)
 		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
 				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
-	kfree(ib_conn->rx_descs);
+	kfree(iser_conn->rx_descs);
 	/* make sure we never redo any unmapping */
-	ib_conn->rx_descs = NULL;
+	iser_conn->rx_descs = NULL;
 
 free_login_buf:
-	iser_free_login_buf(ib_conn);
+	iser_free_login_buf(iser_conn);
 }
 
 static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 {
-	struct iser_conn *ib_conn = conn->dd_data;
+	struct iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_session *session = conn->session;
 
 	iser_dbg("req op %x flags %x\n", req->opcode, req->flags);
@@ -347,18 +350,18 @@ static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 	 * response) and no posted send buffers left - they must have been
 	 * consumed during previous login phases.
 	 */
-	WARN_ON(ib_conn->post_recv_buf_count != 1);
-	WARN_ON(atomic_read(&ib_conn->post_send_buf_count) != 0);
+	WARN_ON(iser_conn->post_recv_buf_count != 1);
+	WARN_ON(atomic_read(&iser_conn->post_send_buf_count) != 0);
 
 	if (session->discovery_sess) {
 		iser_info("Discovery session, re-using login RX buffer\n");
 		return 0;
 	} else
 		iser_info("Normal session, posting batch of RX %d buffers\n",
-			  ib_conn->min_posted_rx);
+			  iser_conn->min_posted_rx);
 
 	/* Initial post receive buffers */
-	if (iser_post_recvm(ib_conn, ib_conn->min_posted_rx))
+	if (iser_post_recvm(iser_conn, iser_conn->min_posted_rx))
 		return -ENOMEM;
 
 	return 0;
@@ -370,7 +373,7 @@ static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 int iser_send_command(struct iscsi_conn *conn,
 		      struct iscsi_task *task)
 {
-	struct iser_conn *ib_conn = conn->dd_data;
+	struct iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	unsigned long edtl;
 	int err;
@@ -383,7 +386,7 @@ int iser_send_command(struct iscsi_conn *conn,
 
 	/* build the tx desc regd header and add it to the tx desc dto */
 	tx_desc->type = ISCSI_TX_SCSI_COMMAND;
-	iser_create_send_desc(ib_conn, tx_desc);
+	iser_create_send_desc(iser_conn, tx_desc);
 
 	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
 		data_buf = &iser_task->data[ISER_DIR_IN];
@@ -423,7 +426,7 @@ int iser_send_command(struct iscsi_conn *conn,
 
 	iser_task->status = ISER_TASK_STATUS_STARTED;
 
-	err = iser_post_send(ib_conn, tx_desc);
+	err = iser_post_send(iser_conn, tx_desc);
 	if (!err)
 		return 0;
 
@@ -439,7 +442,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 		       struct iscsi_task *task,
 		       struct iscsi_data *hdr)
 {
-	struct iser_conn *ib_conn = conn->dd_data;
+	struct iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_tx_desc *tx_desc = NULL;
 	struct iser_regd_buf *regd_buf;
@@ -488,7 +491,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 		 itt, buf_offset, data_seg_len);
 
 
-	err = iser_post_send(ib_conn, tx_desc);
+	err = iser_post_send(iser_conn, tx_desc);
 	if (!err)
 		return 0;
 
@@ -501,7 +504,7 @@ send_data_out_error:
 int iser_send_control(struct iscsi_conn *conn,
 		      struct iscsi_task *task)
 {
-	struct iser_conn *ib_conn = conn->dd_data;
+	struct iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_tx_desc *mdesc = &iser_task->desc;
 	unsigned long data_seg_len;
@@ -510,9 +513,9 @@ int iser_send_control(struct iscsi_conn *conn,
 
 	/* build the tx desc regd header and add it to the tx desc dto */
 	mdesc->type = ISCSI_TX_CONTROL;
-	iser_create_send_desc(ib_conn, mdesc);
+	iser_create_send_desc(iser_conn, mdesc);
 
-	device = ib_conn->device;
+	device = iser_conn->device;
 
 	data_seg_len = ntoh24(task->hdr->dlength);
 
@@ -524,16 +527,16 @@ int iser_send_control(struct iscsi_conn *conn,
 		}
 
 		ib_dma_sync_single_for_cpu(device->ib_device,
-			ib_conn->login_req_dma, task->data_count,
+			iser_conn->login_req_dma, task->data_count,
 			DMA_TO_DEVICE);
 
-		memcpy(ib_conn->login_req_buf, task->data, task->data_count);
+		memcpy(iser_conn->login_req_buf, task->data, task->data_count);
 
 		ib_dma_sync_single_for_device(device->ib_device,
-			ib_conn->login_req_dma, task->data_count,
+			iser_conn->login_req_dma, task->data_count,
 			DMA_TO_DEVICE);
 
-		tx_dsg->addr    = ib_conn->login_req_dma;
+		tx_dsg->addr    = iser_conn->login_req_dma;
 		tx_dsg->length  = task->data_count;
 		tx_dsg->lkey    = device->mr->lkey;
 		mdesc->num_sge = 2;
@@ -542,7 +545,7 @@ int iser_send_control(struct iscsi_conn *conn,
 	if (task == conn->login_task) {
 		iser_dbg("op %x dsl %lx, posting login rx buffer\n",
 			 task->hdr->opcode, data_seg_len);
-		err = iser_post_recvl(ib_conn);
+		err = iser_post_recvl(iser_conn);
 		if (err)
 			goto send_control_error;
 		err = iser_post_rx_bufs(conn, task->hdr);
@@ -550,7 +553,7 @@ int iser_send_control(struct iscsi_conn *conn,
 			goto send_control_error;
 	}
 
-	err = iser_post_send(ib_conn, mdesc);
+	err = iser_post_send(iser_conn, mdesc);
 	if (!err)
 		return 0;
 
@@ -564,59 +567,59 @@ send_control_error:
  */
 void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 			 unsigned long rx_xfer_len,
-			 struct iser_conn *ib_conn)
+			 struct iser_conn *iser_conn)
 {
 	struct iscsi_hdr *hdr;
 	u64 rx_dma;
 	int rx_buflen, outstanding, count, err;
 
 	/* differentiate between login to all other PDUs */
-	if ((char *)rx_desc == ib_conn->login_resp_buf) {
-		rx_dma = ib_conn->login_resp_dma;
+	if ((char *)rx_desc == iser_conn->login_resp_buf) {
+		rx_dma = iser_conn->login_resp_dma;
 		rx_buflen = ISER_RX_LOGIN_SIZE;
 	} else {
 		rx_dma = rx_desc->dma_addr;
 		rx_buflen = ISER_RX_PAYLOAD_SIZE;
 	}
 
-	ib_dma_sync_single_for_cpu(ib_conn->device->ib_device, rx_dma,
-			rx_buflen, DMA_FROM_DEVICE);
+	ib_dma_sync_single_for_cpu(iser_conn->device->ib_device, rx_dma,
+				   rx_buflen, DMA_FROM_DEVICE);
 
 	hdr = &rx_desc->iscsi_header;
 
 	iser_dbg("op 0x%x itt 0x%x dlen %d\n", hdr->opcode,
 			hdr->itt, (int)(rx_xfer_len - ISER_HEADERS_LEN));
 
-	iscsi_iser_recv(ib_conn->iscsi_conn, hdr, rx_desc->data,
+	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, rx_desc->data,
 			rx_xfer_len - ISER_HEADERS_LEN);
 
-	ib_dma_sync_single_for_device(ib_conn->device->ib_device, rx_dma,
+	ib_dma_sync_single_for_device(iser_conn->device->ib_device, rx_dma,
 				      rx_buflen, DMA_FROM_DEVICE);
 
 	/* decrementing conn->post_recv_buf_count only --after-- freeing the   *
 	 * task eliminates the need to worry on tasks which are completed in   *
 	 * parallel to the execution of iser_conn_term. So the code that waits *
 	 * for the posted rx bufs refcount to become zero handles everything   */
-	ib_conn->post_recv_buf_count--;
+	iser_conn->post_recv_buf_count--;
 
-	if (rx_dma == ib_conn->login_resp_dma)
+	if (rx_dma == iser_conn->login_resp_dma)
 		return;
 
-	outstanding = ib_conn->post_recv_buf_count;
-	if (outstanding + ib_conn->min_posted_rx <= ib_conn->qp_max_recv_dtos) {
-		count = min(ib_conn->qp_max_recv_dtos - outstanding,
-						ib_conn->min_posted_rx);
-		err = iser_post_recvm(ib_conn, count);
+	outstanding = iser_conn->post_recv_buf_count;
+	if (outstanding + iser_conn->min_posted_rx <= iser_conn->qp_max_recv_dtos) {
+		count = min(iser_conn->qp_max_recv_dtos - outstanding,
+			    iser_conn->min_posted_rx);
+		err = iser_post_recvm(iser_conn, count);
 		if (err)
 			iser_err("posting %d rx bufs err %d\n", count, err);
 	}
 }
 
 void iser_snd_completion(struct iser_tx_desc *tx_desc,
-			struct iser_conn *ib_conn)
+			struct iser_conn *iser_conn)
 {
 	struct iscsi_task *task;
-	struct iser_device *device = ib_conn->device;
+	struct iser_device *device = iser_conn->device;
 
 	if (tx_desc->type == ISCSI_TX_DATAOUT) {
 		ib_dma_unmap_single(device->ib_device, tx_desc->dma_addr,
@@ -625,7 +628,7 @@ void iser_snd_completion(struct iser_tx_desc *tx_desc,
 		tx_desc = NULL;
 	}
 
-	atomic_dec(&ib_conn->post_send_buf_count);
+	atomic_dec(&iser_conn->post_send_buf_count);
 
 	if (tx_desc && tx_desc->type == ISCSI_TX_CONTROL) {
 		/* this arithmetic is legal by libiscsi dd_data allocation */
@@ -658,7 +661,7 @@ void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
 
 void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 {
-	struct iser_device *device = iser_task->ib_conn->device;
+	struct iser_device *device = iser_task->iser_conn->device;
 	int is_rdma_data_aligned = 1;
 	int is_rdma_prot_aligned = 1;
 	int prot_count = scsi_prot_sg_count(iser_task->sc);
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 47acd3a..ba09fbb 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -49,7 +49,7 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 					struct iser_data_buf *data_copy,
 					enum iser_data_dir cmd_dir)
 {
-	struct ib_device *dev = iser_task->ib_conn->device->ib_device;
+	struct ib_device *dev = iser_task->iser_conn->device->ib_device;
 	struct scatterlist *sgl = (struct scatterlist *)data->buf;
 	struct scatterlist *sg;
 	char *mem = NULL;
@@ -116,7 +116,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 	struct ib_device *dev;
 	unsigned long  cmd_data_len;
 
-	dev = iser_task->ib_conn->device->ib_device;
+	dev = iser_task->iser_conn->device->ib_device;
 
 	ib_dma_unmap_sg(dev, &data_copy->sg_single, 1,
 			(cmd_dir == ISER_DIR_OUT) ?
@@ -322,7 +322,7 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 	struct ib_device *dev;
 
 	iser_task->dir[iser_dir] = 1;
-	dev = iser_task->ib_conn->device->ib_device;
+	dev = iser_task->iser_conn->device->ib_device;
 
 	data->dma_nents = ib_dma_map_sg(dev, data->buf, data->size, dma_dir);
 	if (data->dma_nents == 0) {
@@ -337,7 +337,7 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
 {
 	struct ib_device *dev;
 
-	dev = iser_task->ib_conn->device->ib_device;
+	dev = iser_task->iser_conn->device->ib_device;
 	ib_dma_unmap_sg(dev, data->buf, data->size, DMA_FROM_DEVICE);
 }
 
@@ -348,7 +348,7 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 			      enum iser_data_dir cmd_dir,
 			      int aligned_len)
 {
-	struct iscsi_conn    *iscsi_conn = iser_task->ib_conn->iscsi_conn;
+	struct iscsi_conn    *iscsi_conn = iser_task->iser_conn->iscsi_conn;
 
 	iscsi_conn->fmr_unalign_cnt++;
 	iser_warn("rdma alignment violation (%d/%d aligned) or FMR not supported\n",
@@ -377,8 +377,8 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 			  enum iser_data_dir cmd_dir)
 {
-	struct iser_conn     *ib_conn = iser_task->ib_conn;
-	struct iser_device   *device = ib_conn->device;
+	struct iser_conn     *iser_conn = iser_task->iser_conn;
+	struct iser_device   *device = iser_conn->device;
 	struct ib_device     *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
 	struct iser_regd_buf *regd_buf;
@@ -418,8 +418,8 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 			 (unsigned long)regd_buf->reg.va,
 			 (unsigned long)regd_buf->reg.len);
 	} else { /* use FMR for multiple dma entries */
-		iser_page_vec_build(mem, ib_conn->fmr.page_vec, ibdev);
-		err = iser_reg_page_vec(ib_conn, ib_conn->fmr.page_vec,
+		iser_page_vec_build(mem, iser_conn->fmr.page_vec, ibdev);
+		err = iser_reg_page_vec(iser_conn, iser_conn->fmr.page_vec,
 					&regd_buf->reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
@@ -427,12 +427,12 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 				 mem->dma_nents,
 				 ntoh24(iser_task->desc.iscsi_header.dlength));
 			iser_err("page_vec: data_size = 0x%x, length = %d, offset = 0x%x\n",
-				 ib_conn->fmr.page_vec->data_size,
-				 ib_conn->fmr.page_vec->length,
-				 ib_conn->fmr.page_vec->offset);
-			for (i = 0; i < ib_conn->fmr.page_vec->length; i++)
+				 iser_conn->fmr.page_vec->data_size,
+				 iser_conn->fmr.page_vec->length,
+				 iser_conn->fmr.page_vec->offset);
+			for (i = 0; i < iser_conn->fmr.page_vec->length; i++)
 				iser_err("page_vec[%d] = 0x%llx\n", i,
-					 (unsigned long long) ib_conn->fmr.page_vec->pages[i]);
+					 (unsigned long long)iser_conn->fmr.page_vec->pages[i]);
 		}
 		if (err)
 			return err;
@@ -533,7 +533,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 		struct fast_reg_descriptor *desc, struct ib_sge *data_sge,
 		struct ib_sge *prot_sge, struct ib_sge *sig_sge)
 {
-	struct iser_conn *ib_conn = iser_task->ib_conn;
+	struct iser_conn *iser_conn = iser_task->iser_conn;
 	struct iser_pi_context *pi_ctx = desc->pi_ctx;
 	struct ib_send_wr sig_wr, inv_wr;
 	struct ib_send_wr *bad_wr, *wr = NULL;
@@ -579,7 +579,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	else
 		wr->next = &sig_wr;
 
-	ret = ib_post_send(ib_conn->qp, wr, &bad_wr);
+	ret = ib_post_send(iser_conn->qp, wr, &bad_wr);
 	if (ret) {
 		iser_err("reg_sig_mr failed, ret:%d\n", ret);
 		goto err;
@@ -609,8 +609,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 			    struct ib_sge *sge)
 {
 	struct fast_reg_descriptor *desc = regd_buf->reg.mem_h;
-	struct iser_conn *ib_conn = iser_task->ib_conn;
-	struct iser_device *device = ib_conn->device;
+	struct iser_conn *iser_conn = iser_task->iser_conn;
+	struct iser_device *device = iser_conn->device;
 	struct ib_device *ibdev = device->ib_device;
 	struct ib_mr *mr;
 	struct ib_fast_reg_page_list *frpl;
@@ -677,7 +677,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	else
 		wr->next = &fastreg_wr;
 
-	ret = ib_post_send(ib_conn->qp, wr, &bad_wr);
+	ret = ib_post_send(iser_conn->qp, wr, &bad_wr);
 	if (ret) {
 		iser_err("fast registration failed, ret:%d\n", ret);
 		return ret;
@@ -700,8 +700,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 			      enum iser_data_dir cmd_dir)
 {
-	struct iser_conn *ib_conn = iser_task->ib_conn;
-	struct iser_device *device = ib_conn->device;
+	struct iser_conn *iser_conn = iser_task->iser_conn;
+	struct iser_device *device = iser_conn->device;
 	struct ib_device *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
 	struct iser_regd_buf *regd_buf = &iser_task->rdma_regd[cmd_dir];
@@ -724,11 +724,11 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 	if (mem->dma_nents != 1 ||
 	    scsi_get_prot_op(iser_task->sc) != SCSI_PROT_NORMAL) {
-		spin_lock_irqsave(&ib_conn->lock, flags);
-		desc = list_first_entry(&ib_conn->fastreg.pool,
+		spin_lock_irqsave(&iser_conn->lock, flags);
+		desc = list_first_entry(&iser_conn->fastreg.pool,
 					struct fast_reg_descriptor, list);
 		list_del(&desc->list);
-		spin_unlock_irqrestore(&ib_conn->lock, flags);
+		spin_unlock_irqrestore(&iser_conn->lock, flags);
 		regd_buf->reg.mem_h = desc;
 	}
 
@@ -791,9 +791,9 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 	return 0;
 err_reg:
 	if (desc) {
-		spin_lock_irqsave(&ib_conn->lock, flags);
-		list_add_tail(&desc->list, &ib_conn->fastreg.pool);
-		spin_unlock_irqrestore(&ib_conn->lock, flags);
+		spin_lock_irqsave(&iser_conn->lock, flags);
+		list_add_tail(&desc->list, &iser_conn->fastreg.pool);
+		spin_unlock_irqrestore(&iser_conn->lock, flags);
 	}
 
 	return err;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 3bfec4b..778c166 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -213,19 +213,19 @@ static void iser_free_device_ib_res(struct iser_device *device)
  *
  * returns 0 on success, or errno code on failure
  */
-int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
+int iser_create_fmr_pool(struct iser_conn *iser_conn, unsigned cmds_max)
 {
-	struct iser_device *device = ib_conn->device;
+	struct iser_device *device = iser_conn->device;
 	struct ib_fmr_pool_param params;
 	int ret = -ENOMEM;
 
-	ib_conn->fmr.page_vec = kmalloc(sizeof(*ib_conn->fmr.page_vec) +
+	iser_conn->fmr.page_vec = kmalloc(sizeof(*iser_conn->fmr.page_vec) +
 					(sizeof(u64)*(ISCSI_ISER_SG_TABLESIZE + 1)),
 					GFP_KERNEL);
-	if (!ib_conn->fmr.page_vec)
+	if (!iser_conn->fmr.page_vec)
 		return ret;
 
-	ib_conn->fmr.page_vec->pages = (u64 *)(ib_conn->fmr.page_vec + 1);
+	iser_conn->fmr.page_vec->pages = (u64 *)(iser_conn->fmr.page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
 	/* when the first/last SG element are not start/end *
@@ -241,16 +241,16 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 				    IB_ACCESS_REMOTE_WRITE |
 				    IB_ACCESS_REMOTE_READ);
 
-	ib_conn->fmr.pool = ib_create_fmr_pool(device->pd, &params);
-	if (!IS_ERR(ib_conn->fmr.pool))
+	iser_conn->fmr.pool = ib_create_fmr_pool(device->pd, &params);
+	if (!IS_ERR(iser_conn->fmr.pool))
 		return 0;
 
 	/* no FMR => no need for page_vec */
-	kfree(ib_conn->fmr.page_vec);
-	ib_conn->fmr.page_vec = NULL;
+	kfree(iser_conn->fmr.page_vec);
+	iser_conn->fmr.page_vec = NULL;
 
-	ret = PTR_ERR(ib_conn->fmr.pool);
-	ib_conn->fmr.pool = NULL;
+	ret = PTR_ERR(iser_conn->fmr.pool);
+	iser_conn->fmr.pool = NULL;
 	if (ret != -ENOSYS) {
 		iser_err("FMR allocation failed, err %d\n", ret);
 		return ret;
@@ -263,18 +263,18 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 /**
  * iser_free_fmr_pool - releases the FMR pool and page vec
  */
-void iser_free_fmr_pool(struct iser_conn *ib_conn)
+void iser_free_fmr_pool(struct iser_conn *iser_conn)
 {
 	iser_info("freeing conn %p fmr pool %p\n",
-		  ib_conn, ib_conn->fmr.pool);
+		  iser_conn, iser_conn->fmr.pool);
 
-	if (ib_conn->fmr.pool != NULL)
-		ib_destroy_fmr_pool(ib_conn->fmr.pool);
+	if (iser_conn->fmr.pool != NULL)
+		ib_destroy_fmr_pool(iser_conn->fmr.pool);
 
-	ib_conn->fmr.pool = NULL;
+	iser_conn->fmr.pool = NULL;
 
-	kfree(ib_conn->fmr.page_vec);
-	ib_conn->fmr.page_vec = NULL;
+	kfree(iser_conn->fmr.page_vec);
+	iser_conn->fmr.page_vec = NULL;
 }
 
 static int
@@ -367,14 +367,14 @@ fast_reg_mr_failure:
  * for fast registration work requests.
  * returns 0 on success, or errno code on failure
  */
-int iser_create_fastreg_pool(struct iser_conn *ib_conn, unsigned cmds_max)
+int iser_create_fastreg_pool(struct iser_conn *iser_conn, unsigned cmds_max)
 {
-	struct iser_device	*device = ib_conn->device;
+	struct iser_device	*device = iser_conn->device;
 	struct fast_reg_descriptor	*desc;
 	int i, ret;
 
-	INIT_LIST_HEAD(&ib_conn->fastreg.pool);
-	ib_conn->fastreg.pool_size = 0;
+	INIT_LIST_HEAD(&iser_conn->fastreg.pool);
+	iser_conn->fastreg.pool_size = 0;
 	for (i = 0; i < cmds_max; i++) {
 		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
 		if (!desc) {
@@ -384,7 +384,7 @@ int iser_create_fastreg_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 		}
 
 		ret = iser_create_fastreg_desc(device->ib_device, device->pd,
-					       ib_conn->pi_support, desc);
+					       iser_conn->pi_support, desc);
 		if (ret) {
 			iser_err("Failed to create fastreg descriptor err=%d\n",
 				 ret);
@@ -392,31 +392,31 @@ int iser_create_fastreg_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 			goto err;
 		}
 
-		list_add_tail(&desc->list, &ib_conn->fastreg.pool);
-		ib_conn->fastreg.pool_size++;
+		list_add_tail(&desc->list, &iser_conn->fastreg.pool);
+		iser_conn->fastreg.pool_size++;
 	}
 
 	return 0;
 
 err:
-	iser_free_fastreg_pool(ib_conn);
+	iser_free_fastreg_pool(iser_conn);
 	return ret;
 }
 
 /**
  * iser_free_fastreg_pool - releases the pool of fast_reg descriptors
  */
-void iser_free_fastreg_pool(struct iser_conn *ib_conn)
+void iser_free_fastreg_pool(struct iser_conn *iser_conn)
 {
 	struct fast_reg_descriptor *desc, *tmp;
 	int i = 0;
 
-	if (list_empty(&ib_conn->fastreg.pool))
+	if (list_empty(&iser_conn->fastreg.pool))
 		return;
 
-	iser_info("freeing conn %p fr pool\n", ib_conn);
+	iser_info("freeing conn %p fr pool\n", iser_conn);
 
-	list_for_each_entry_safe(desc, tmp, &ib_conn->fastreg.pool, list) {
+	list_for_each_entry_safe(desc, tmp, &iser_conn->fastreg.pool, list) {
 		list_del(&desc->list);
 		ib_free_fast_reg_page_list(desc->data_frpl);
 		ib_dereg_mr(desc->data_mr);
@@ -430,9 +430,9 @@ void iser_free_fastreg_pool(struct iser_conn *ib_conn)
 		++i;
 	}
 
-	if (i < ib_conn->fastreg.pool_size)
+	if (i < iser_conn->fastreg.pool_size)
 		iser_warn("pool still has %d regions registered\n",
-			  ib_conn->fastreg.pool_size - i);
+			  iser_conn->fastreg.pool_size - i);
 }
 
 /**
@@ -440,16 +440,16 @@ void iser_free_fastreg_pool(struct iser_conn *ib_conn)
  *
  * returns 0 on success, -1 on failure
  */
-static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
+static int iser_create_ib_conn_res(struct iser_conn *iser_conn)
 {
 	struct iser_device	*device;
 	struct ib_qp_init_attr	init_attr;
 	int			ret = -ENOMEM;
 	int index, min_index = 0;
 
-	BUG_ON(ib_conn->device == NULL);
+	BUG_ON(iser_conn->device == NULL);
 
-	device = ib_conn->device;
+	device = iser_conn->device;
 
 	memset(&init_attr, 0, sizeof init_attr);
 
@@ -461,10 +461,10 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 			min_index = index;
 	device->cq_active_qps[min_index]++;
 	mutex_unlock(&ig.connlist_mutex);
-	iser_info("cq index %d used for ib_conn %p\n", min_index, ib_conn);
+	iser_info("cq index %d used for iser_conn %p\n", min_index, iser_conn);
 
 	init_attr.event_handler = iser_qp_event_callback;
-	init_attr.qp_context	= (void *)ib_conn;
+	init_attr.qp_context	= (void *)iser_conn;
 	init_attr.send_cq	= device->tx_cq[min_index];
 	init_attr.recv_cq	= device->rx_cq[min_index];
 	init_attr.cap.max_recv_wr  = ISER_QP_MAX_RECV_DTOS;
@@ -472,21 +472,21 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	init_attr.cap.max_recv_sge = 1;
 	init_attr.sq_sig_type	= IB_SIGNAL_REQ_WR;
 	init_attr.qp_type	= IB_QPT_RC;
-	if (ib_conn->pi_support) {
+	if (iser_conn->pi_support) {
 		init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS;
 		init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
 	} else {
 		init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS;
 	}
 
-	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
+	ret = rdma_create_qp(iser_conn->cma_id, device->pd, &init_attr);
 	if (ret)
 		goto out_err;
 
-	ib_conn->qp = ib_conn->cma_id->qp;
+	iser_conn->qp = iser_conn->cma_id->qp;
 	iser_info("setting conn %p cma_id %p qp %p\n",
-		  ib_conn, ib_conn->cma_id,
-		  ib_conn->cma_id->qp);
+		  iser_conn, iser_conn->cma_id,
+		  iser_conn->cma_id->qp);
 	return ret;
 
 out_err:
@@ -497,25 +497,25 @@ out_err:
 /**
  * releases the QP object
  */
-static void iser_free_ib_conn_res(struct iser_conn *ib_conn)
+static void iser_free_ib_conn_res(struct iser_conn *iser_conn)
 {
 	int cq_index;
-	BUG_ON(ib_conn == NULL);
+	BUG_ON(iser_conn == NULL);
 
 	iser_info("freeing conn %p cma_id %p qp %p\n",
-		  ib_conn, ib_conn->cma_id,
-		  ib_conn->qp);
+		  iser_conn, iser_conn->cma_id,
+		  iser_conn->qp);
 
 	/* qp is created only once both addr & route are resolved */
 
-	if (ib_conn->qp != NULL) {
-		cq_index = ((struct iser_cq_desc *)ib_conn->qp->recv_cq->cq_context)->cq_index;
-		ib_conn->device->cq_active_qps[cq_index]--;
+	if (iser_conn->qp != NULL) {
+		cq_index = ((struct iser_cq_desc *)iser_conn->qp->recv_cq->cq_context)->cq_index;
+		iser_conn->device->cq_active_qps[cq_index]--;
 
-		rdma_destroy_qp(ib_conn->cma_id);
+		rdma_destroy_qp(iser_conn->cma_id);
 	}
 
-	ib_conn->qp	  = NULL;
+	iser_conn->qp	  = NULL;
 }
 
 /**
@@ -572,75 +572,77 @@ static void iser_device_try_release(struct iser_device *device)
 /**
  * Called with state mutex held
  **/
-static int iser_conn_state_comp_exch(struct iser_conn *ib_conn,
-				     enum iser_ib_conn_state comp,
-				     enum iser_ib_conn_state exch)
+static int iser_conn_state_comp_exch(struct iser_conn *iser_conn,
+				     enum iser_conn_state comp,
+				     enum iser_conn_state exch)
 {
 	int ret;
 
-	if ((ret = (ib_conn->state == comp)))
-		ib_conn->state = exch;
+	ret = (iser_conn->state == comp);
+	if (ret)
+		iser_conn->state = exch;
+
 	return ret;
 }
 
 void iser_release_work(struct work_struct *work)
 {
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 	int rc;
 
-	ib_conn = container_of(work, struct iser_conn, release_work);
+	iser_conn = container_of(work, struct iser_conn, release_work);
 
 	/* wait for .conn_stop callback */
-	rc = wait_for_completion_timeout(&ib_conn->stop_completion, 30 * HZ);
+	rc = wait_for_completion_timeout(&iser_conn->stop_completion, 30 * HZ);
 	WARN_ON(rc == 0);
 
 	/* wait for the qp`s post send and post receive buffers to empty */
-	rc = wait_for_completion_timeout(&ib_conn->flush_completion, 30 * HZ);
+	rc = wait_for_completion_timeout(&iser_conn->flush_completion, 30 * HZ);
 	WARN_ON(rc == 0);
 
-	ib_conn->state = ISER_CONN_DOWN;
+	iser_conn->state = ISER_CONN_DOWN;
 
-	mutex_lock(&ib_conn->state_mutex);
-	ib_conn->state = ISER_CONN_DOWN;
-	mutex_unlock(&ib_conn->state_mutex);
+	mutex_lock(&iser_conn->state_mutex);
+	iser_conn->state = ISER_CONN_DOWN;
+	mutex_unlock(&iser_conn->state_mutex);
 
-	iser_conn_release(ib_conn);
+	iser_conn_release(iser_conn);
 }
 
 /**
  * Frees all conn objects and deallocs conn descriptor
  */
-void iser_conn_release(struct iser_conn *ib_conn)
+void iser_conn_release(struct iser_conn *iser_conn)
 {
-	struct iser_device  *device = ib_conn->device;
+	struct iser_device  *device = iser_conn->device;
 
 	mutex_lock(&ig.connlist_mutex);
-	list_del(&ib_conn->conn_list);
+	list_del(&iser_conn->conn_list);
 	mutex_unlock(&ig.connlist_mutex);
 
-	mutex_lock(&ib_conn->state_mutex);
-	BUG_ON(ib_conn->state != ISER_CONN_DOWN);
+	mutex_lock(&iser_conn->state_mutex);
+	BUG_ON(iser_conn->state != ISER_CONN_DOWN);
 
-	iser_free_rx_descriptors(ib_conn);
-	iser_free_ib_conn_res(ib_conn);
-	ib_conn->device = NULL;
+	iser_free_rx_descriptors(iser_conn);
+	iser_free_ib_conn_res(iser_conn);
+	iser_conn->device = NULL;
 	/* on EVENT_ADDR_ERROR there's no device yet for this conn */
 	if (device != NULL)
 		iser_device_try_release(device);
-	mutex_unlock(&ib_conn->state_mutex);
+	mutex_unlock(&iser_conn->state_mutex);
 
 	/* if cma handler context, the caller actually destroy the id */
-	if (ib_conn->cma_id != NULL) {
-		rdma_destroy_id(ib_conn->cma_id);
-		ib_conn->cma_id = NULL;
+	if (iser_conn->cma_id != NULL) {
+		rdma_destroy_id(iser_conn->cma_id);
+		iser_conn->cma_id = NULL;
 	}
-	kfree(ib_conn);
+	kfree(iser_conn);
 }
 
 /**
  * triggers start of the disconnect procedures and wait for them to be done
  */
-void iser_conn_terminate(struct iser_conn *ib_conn)
+void iser_conn_terminate(struct iser_conn *iser_conn)
 {
 	int err = 0;
 
@@ -649,11 +651,11 @@ void iser_conn_terminate(struct iser_conn *ib_conn)
 	 * the QP state to ERROR
 	 */
 
-	iser_conn_state_comp_exch(ib_conn, ISER_CONN_UP, ISER_CONN_TERMINATING);
-	err = rdma_disconnect(ib_conn->cma_id);
+	iser_conn_state_comp_exch(iser_conn, ISER_CONN_UP, ISER_CONN_TERMINATING);
+	err = rdma_disconnect(iser_conn->cma_id);
 	if (err)
 		iser_err("Failed to disconnect, conn: 0x%p err %d\n",
-			 ib_conn,err);
+			 iser_conn, err);
 }
 
 /**
@@ -661,10 +663,10 @@ void iser_conn_terminate(struct iser_conn *ib_conn)
  **/
 static void iser_connect_error(struct rdma_cm_id *cma_id)
 {
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 
-	ib_conn = (struct iser_conn *)cma_id->context;
-	ib_conn->state = ISER_CONN_DOWN;
+	iser_conn = (struct iser_conn *)cma_id->context;
+	iser_conn->state = ISER_CONN_DOWN;
 }
 
 /**
@@ -673,11 +675,11 @@ static void iser_connect_error(struct rdma_cm_id *cma_id)
 static void iser_addr_handler(struct rdma_cm_id *cma_id)
 {
 	struct iser_device *device;
-	struct iser_conn   *ib_conn;
+	struct iser_conn   *iser_conn;
 	int    ret;
 
-	ib_conn = (struct iser_conn *)cma_id->context;
-	if (ib_conn->state != ISER_CONN_PENDING)
+	iser_conn = (struct iser_conn *)cma_id->context;
+	if (iser_conn->state != ISER_CONN_PENDING)
 		/* bailout */
 		return;
 
@@ -688,7 +690,7 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 		return;
 	}
 
-	ib_conn->device = device;
+	iser_conn->device = device;
 
 	/* connection T10-PI support */
 	if (iser_pi_enable) {
@@ -696,10 +698,10 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 		      IB_DEVICE_SIGNATURE_HANDOVER)) {
 			iser_warn("T10-PI requested but not supported on %s, "
 				  "continue without T10-PI\n",
-				  ib_conn->device->ib_device->name);
-			ib_conn->pi_support = false;
+				  iser_conn->device->ib_device->name);
+			iser_conn->pi_support = false;
 		} else {
-			ib_conn->pi_support = true;
+			iser_conn->pi_support = true;
 		}
 	}
 
@@ -719,10 +721,10 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
 	struct rdma_conn_param conn_param;
 	int    ret;
 	struct iser_cm_hdr req_hdr;
-	struct iser_conn *ib_conn = (struct iser_conn *)cma_id->context;
-	struct iser_device *device = ib_conn->device;
+	struct iser_conn *iser_conn = (struct iser_conn *)cma_id->context;
+	struct iser_device *device = iser_conn->device;
 
-	if (ib_conn->state != ISER_CONN_PENDING)
+	if (iser_conn->state != ISER_CONN_PENDING)
 		/* bailout */
 		return;
 
@@ -755,34 +757,34 @@ failure:
 
 static void iser_connected_handler(struct rdma_cm_id *cma_id)
 {
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 	struct ib_qp_attr attr;
 	struct ib_qp_init_attr init_attr;
 
-	ib_conn = (struct iser_conn *)cma_id->context;
-	if (ib_conn->state != ISER_CONN_PENDING)
+	iser_conn = (struct iser_conn *)cma_id->context;
+	if (iser_conn->state != ISER_CONN_PENDING)
 		/* bailout */
 		return;
 
 	(void)ib_query_qp(cma_id->qp, &attr, ~0, &init_attr);
 	iser_info("remote qpn:%x my qpn:%x\n", attr.dest_qp_num, cma_id->qp->qp_num);
 
-	ib_conn->state = ISER_CONN_UP;
-	complete(&ib_conn->up_completion);
+	iser_conn->state = ISER_CONN_UP;
+	complete(&iser_conn->up_completion);
 }
 
 static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
 {
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 
-	ib_conn = (struct iser_conn *)cma_id->context;
+	iser_conn = (struct iser_conn *)cma_id->context;
 
 	/* getting here when the state is UP means that the conn is being *
 	 * terminated asynchronously from the iSCSI layer's perspective.  */
-	if (iser_conn_state_comp_exch(ib_conn, ISER_CONN_UP,
-					ISER_CONN_TERMINATING)){
-		if (ib_conn->iscsi_conn)
-			iscsi_conn_failure(ib_conn->iscsi_conn, ISCSI_ERR_CONN_FAILED);
+	if (iser_conn_state_comp_exch(iser_conn, ISER_CONN_UP,
+				      ISER_CONN_TERMINATING)){
+		if (iser_conn->iscsi_conn)
+			iscsi_conn_failure(iser_conn->iscsi_conn, ISCSI_ERR_CONN_FAILED);
 		else
 			iser_err("iscsi_iser connection isn't bound\n");
 	}
@@ -791,21 +793,21 @@ static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
 	 * block also exists in iser_handle_comp_error(), but it is needed here
 	 * for cases of no flushes at all, e.g. discovery over rdma.
 	 */
-	if (ib_conn->post_recv_buf_count == 0 &&
-	    (atomic_read(&ib_conn->post_send_buf_count) == 0)) {
-		complete(&ib_conn->flush_completion);
+	if (iser_conn->post_recv_buf_count == 0 &&
+	    (atomic_read(&iser_conn->post_send_buf_count) == 0)) {
+		complete(&iser_conn->flush_completion);
 	}
 }
 
 static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 
-	ib_conn = (struct iser_conn *)cma_id->context;
+	iser_conn = (struct iser_conn *)cma_id->context;
 	iser_info("event %d status %d conn %p id %p\n",
 		  event->event, event->status, cma_id->context, cma_id);
 
-	mutex_lock(&ib_conn->state_mutex);
+	mutex_lock(&iser_conn->state_mutex);
 	switch (event->event) {
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
 		iser_addr_handler(cma_id);
@@ -833,82 +835,82 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 		iser_err("Unexpected RDMA CM event (%d)\n", event->event);
 		break;
 	}
-	mutex_unlock(&ib_conn->state_mutex);
+	mutex_unlock(&iser_conn->state_mutex);
 	return 0;
 }
 
-void iser_conn_init(struct iser_conn *ib_conn)
+void iser_conn_init(struct iser_conn *iser_conn)
 {
-	ib_conn->state = ISER_CONN_INIT;
-	ib_conn->post_recv_buf_count = 0;
-	atomic_set(&ib_conn->post_send_buf_count, 0);
-	init_completion(&ib_conn->stop_completion);
-	init_completion(&ib_conn->flush_completion);
-	init_completion(&ib_conn->up_completion);
-	INIT_LIST_HEAD(&ib_conn->conn_list);
-	spin_lock_init(&ib_conn->lock);
-	mutex_init(&ib_conn->state_mutex);
+	iser_conn->state = ISER_CONN_INIT;
+	iser_conn->post_recv_buf_count = 0;
+	atomic_set(&iser_conn->post_send_buf_count, 0);
+	init_completion(&iser_conn->stop_completion);
+	init_completion(&iser_conn->flush_completion);
+	init_completion(&iser_conn->up_completion);
+	INIT_LIST_HEAD(&iser_conn->conn_list);
+	spin_lock_init(&iser_conn->lock);
+	mutex_init(&iser_conn->state_mutex);
 }
 
  /**
  * starts the process of connecting to the target
  * sleeps until the connection is established or rejected
  */
-int iser_connect(struct iser_conn   *ib_conn,
+int iser_connect(struct iser_conn   *iser_conn,
 		 struct sockaddr    *src_addr,
 		 struct sockaddr    *dst_addr,
 		 int                 non_blocking)
 {
 	int err = 0;
 
-	mutex_lock(&ib_conn->state_mutex);
+	mutex_lock(&iser_conn->state_mutex);
 
-	sprintf(ib_conn->name, "%pISp", dst_addr);
+	sprintf(iser_conn->name, "%pISp", dst_addr);
 
-	iser_info("connecting to: %s\n", ib_conn->name);
+	iser_info("connecting to: %s\n", iser_conn->name);
 
 	/* the device is known only --after-- address resolution */
-	ib_conn->device = NULL;
+	iser_conn->device = NULL;
 
-	ib_conn->state = ISER_CONN_PENDING;
+	iser_conn->state = ISER_CONN_PENDING;
 
-	ib_conn->cma_id = rdma_create_id(iser_cma_handler,
-					     (void *)ib_conn,
+	iser_conn->cma_id = rdma_create_id(iser_cma_handler,
+					     (void *)iser_conn,
 					     RDMA_PS_TCP, IB_QPT_RC);
-	if (IS_ERR(ib_conn->cma_id)) {
-		err = PTR_ERR(ib_conn->cma_id);
+	if (IS_ERR(iser_conn->cma_id)) {
+		err = PTR_ERR(iser_conn->cma_id);
 		iser_err("rdma_create_id failed: %d\n", err);
 		goto id_failure;
 	}
 
-	err = rdma_resolve_addr(ib_conn->cma_id, src_addr, dst_addr, 1000);
+	err = rdma_resolve_addr(iser_conn->cma_id, src_addr, dst_addr, 1000);
 	if (err) {
 		iser_err("rdma_resolve_addr failed: %d\n", err);
 		goto addr_failure;
 	}
 
 	if (!non_blocking) {
-		wait_for_completion_interruptible(&ib_conn->up_completion);
+		wait_for_completion_interruptible(&iser_conn->up_completion);
 
-		if (ib_conn->state != ISER_CONN_UP) {
+		if (iser_conn->state != ISER_CONN_UP) {
 			err =  -EIO;
 			goto connect_failure;
 		}
 	}
-	mutex_unlock(&ib_conn->state_mutex);
+	mutex_unlock(&iser_conn->state_mutex);
 
 	mutex_lock(&ig.connlist_mutex);
-	list_add(&ib_conn->conn_list, &ig.connlist);
+	list_add(&iser_conn->conn_list, &ig.connlist);
 	mutex_unlock(&ig.connlist_mutex);
 	return 0;
 
 id_failure:
-	ib_conn->cma_id = NULL;
+	iser_conn->cma_id = NULL;
 addr_failure:
-	ib_conn->state = ISER_CONN_DOWN;
+	iser_conn->state = ISER_CONN_DOWN;
 connect_failure:
-	mutex_unlock(&ib_conn->state_mutex);
-	iser_conn_release(ib_conn);
+	mutex_unlock(&iser_conn->state_mutex);
+	iser_conn_release(iser_conn);
 	return err;
 }
 
@@ -917,7 +919,7 @@ connect_failure:
  *
  * returns: 0 on success, errno code on failure
  */
-int iser_reg_page_vec(struct iser_conn     *ib_conn,
+int iser_reg_page_vec(struct iser_conn     *iser_conn,
 		      struct iser_page_vec *page_vec,
 		      struct iser_mem_reg  *mem_reg)
 {
@@ -929,7 +931,7 @@ int iser_reg_page_vec(struct iser_conn     *ib_conn,
 	page_list = page_vec->pages;
 	io_addr	  = page_list[0];
 
-	mem  = ib_fmr_pool_map_phys(ib_conn->fmr.pool,
+	mem  = ib_fmr_pool_map_phys(iser_conn->fmr.pool,
 				    page_list,
 				    page_vec->length,
 				    io_addr);
@@ -987,7 +989,7 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 			    enum iser_data_dir cmd_dir)
 {
 	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
-	struct iser_conn *ib_conn = iser_task->ib_conn;
+	struct iser_conn *iser_conn = iser_task->iser_conn;
 	struct fast_reg_descriptor *desc = reg->mem_h;
 
 	if (!reg->is_mr)
@@ -995,61 +997,61 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 	reg->mem_h = NULL;
 	reg->is_mr = 0;
-	spin_lock_bh(&ib_conn->lock);
-	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
-	spin_unlock_bh(&ib_conn->lock);
+	spin_lock_bh(&iser_conn->lock);
+	list_add_tail(&desc->list, &iser_conn->fastreg.pool);
+	spin_unlock_bh(&iser_conn->lock);
 }
 
-int iser_post_recvl(struct iser_conn *ib_conn)
+int iser_post_recvl(struct iser_conn *iser_conn)
 {
 	struct ib_recv_wr rx_wr, *rx_wr_failed;
 	struct ib_sge	  sge;
 	int ib_ret;
 
-	sge.addr   = ib_conn->login_resp_dma;
+	sge.addr   = iser_conn->login_resp_dma;
 	sge.length = ISER_RX_LOGIN_SIZE;
-	sge.lkey   = ib_conn->device->mr->lkey;
+	sge.lkey   = iser_conn->device->mr->lkey;
 
-	rx_wr.wr_id   = (unsigned long)ib_conn->login_resp_buf;
+	rx_wr.wr_id   = (unsigned long)iser_conn->login_resp_buf;
 	rx_wr.sg_list = &sge;
 	rx_wr.num_sge = 1;
 	rx_wr.next    = NULL;
 
-	ib_conn->post_recv_buf_count++;
-	ib_ret	= ib_post_recv(ib_conn->qp, &rx_wr, &rx_wr_failed);
+	iser_conn->post_recv_buf_count++;
+	ib_ret	= ib_post_recv(iser_conn->qp, &rx_wr, &rx_wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
-		ib_conn->post_recv_buf_count--;
+		iser_conn->post_recv_buf_count--;
 	}
 	return ib_ret;
 }
 
-int iser_post_recvm(struct iser_conn *ib_conn, int count)
+int iser_post_recvm(struct iser_conn *iser_conn, int count)
 {
 	struct ib_recv_wr *rx_wr, *rx_wr_failed;
 	int i, ib_ret;
-	unsigned int my_rx_head = ib_conn->rx_desc_head;
+	unsigned int my_rx_head = iser_conn->rx_desc_head;
 	struct iser_rx_desc *rx_desc;
 
-	for (rx_wr = ib_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
-		rx_desc		= &ib_conn->rx_descs[my_rx_head];
+	for (rx_wr = iser_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
+		rx_desc		= &iser_conn->rx_descs[my_rx_head];
 		rx_wr->wr_id	= (unsigned long)rx_desc;
 		rx_wr->sg_list	= &rx_desc->rx_sg;
 		rx_wr->num_sge	= 1;
 		rx_wr->next	= rx_wr + 1;
-		my_rx_head = (my_rx_head + 1) & ib_conn->qp_max_recv_dtos_mask;
+		my_rx_head = (my_rx_head + 1) & iser_conn->qp_max_recv_dtos_mask;
 	}
 
 	rx_wr--;
 	rx_wr->next = NULL; /* mark end of work requests list */
 
-	ib_conn->post_recv_buf_count += count;
-	ib_ret	= ib_post_recv(ib_conn->qp, ib_conn->rx_wr, &rx_wr_failed);
+	iser_conn->post_recv_buf_count += count;
+	ib_ret	= ib_post_recv(iser_conn->qp, iser_conn->rx_wr, &rx_wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
-		ib_conn->post_recv_buf_count -= count;
+		iser_conn->post_recv_buf_count -= count;
 	} else
-		ib_conn->rx_desc_head = my_rx_head;
+		iser_conn->rx_desc_head = my_rx_head;
 	return ib_ret;
 }
 
@@ -1059,13 +1061,14 @@ int iser_post_recvm(struct iser_conn *ib_conn, int count)
  *
  * returns 0 on success, -1 on failure
  */
-int iser_post_send(struct iser_conn *ib_conn, struct iser_tx_desc *tx_desc)
+int iser_post_send(struct iser_conn *iser_conn, struct iser_tx_desc *tx_desc)
 {
 	int		  ib_ret;
 	struct ib_send_wr send_wr, *send_wr_failed;
 
-	ib_dma_sync_single_for_device(ib_conn->device->ib_device,
-		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	ib_dma_sync_single_for_device(iser_conn->device->ib_device,
+				      tx_desc->dma_addr, ISER_HEADERS_LEN,
+				      DMA_TO_DEVICE);
 
 	send_wr.next	   = NULL;
 	send_wr.wr_id	   = (unsigned long)tx_desc;
@@ -1074,37 +1077,37 @@ int iser_post_send(struct iser_conn *ib_conn, struct iser_tx_desc *tx_desc)
 	send_wr.opcode	   = IB_WR_SEND;
 	send_wr.send_flags = IB_SEND_SIGNALED;
 
-	atomic_inc(&ib_conn->post_send_buf_count);
+	atomic_inc(&iser_conn->post_send_buf_count);
 
-	ib_ret = ib_post_send(ib_conn->qp, &send_wr, &send_wr_failed);
+	ib_ret = ib_post_send(iser_conn->qp, &send_wr, &send_wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_send failed, ret:%d\n", ib_ret);
-		atomic_dec(&ib_conn->post_send_buf_count);
+		atomic_dec(&iser_conn->post_send_buf_count);
 	}
 	return ib_ret;
 }
 
 static void iser_handle_comp_error(struct iser_tx_desc *desc,
-				struct iser_conn *ib_conn)
+				struct iser_conn *iser_conn)
 {
 	if (desc && desc->type == ISCSI_TX_DATAOUT)
 		kmem_cache_free(ig.desc_cache, desc);
 
-	if (ib_conn->post_recv_buf_count == 0 &&
-	    atomic_read(&ib_conn->post_send_buf_count) == 0) {
+	if (iser_conn->post_recv_buf_count == 0 &&
+	    atomic_read(&iser_conn->post_send_buf_count) == 0) {
 		/**
 		 * getting here when the state is UP means that the conn is
 		 * being terminated asynchronously from the iSCSI layer's
 		 * perspective. It is safe to peek at the connection state
 		 * since iscsi_conn_failure is allowed to be called twice.
 		 **/
-		if (ib_conn->state == ISER_CONN_UP)
-			iscsi_conn_failure(ib_conn->iscsi_conn,
+		if (iser_conn->state == ISER_CONN_UP)
+			iscsi_conn_failure(iser_conn->iscsi_conn,
 					   ISCSI_ERR_CONN_FAILED);
 
 		/* no more non completed posts to the QP, complete the
 		 * termination process w.o worrying on disconnect event */
-		complete(&ib_conn->flush_completion);
+		complete(&iser_conn->flush_completion);
 	}
 }
 
@@ -1113,15 +1116,15 @@ static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
 	struct ib_cq  *cq = device->tx_cq[cq_index];
 	struct ib_wc  wc;
 	struct iser_tx_desc *tx_desc;
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 	int completed_tx = 0;
 
 	while (ib_poll_cq(cq, 1, &wc) == 1) {
 		tx_desc	= (struct iser_tx_desc *) (unsigned long) wc.wr_id;
-		ib_conn = wc.qp->qp_context;
+		iser_conn = wc.qp->qp_context;
 		if (wc.status == IB_WC_SUCCESS) {
 			if (wc.opcode == IB_WC_SEND)
-				iser_snd_completion(tx_desc, ib_conn);
+				iser_snd_completion(tx_desc, iser_conn);
 			else
 				iser_err("expected opcode %d got %d\n",
 					IB_WC_SEND, wc.opcode);
@@ -1129,8 +1132,8 @@ static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
 			iser_err("tx id %llx status %d vend_err %x\n",
 				 wc.wr_id, wc.status, wc.vendor_err);
 			if (wc.wr_id != ISER_FASTREG_LI_WRID) {
-				atomic_dec(&ib_conn->post_send_buf_count);
-				iser_handle_comp_error(tx_desc, ib_conn);
+				atomic_dec(&iser_conn->post_send_buf_count);
+				iser_handle_comp_error(tx_desc, iser_conn);
 			}
 		}
 		completed_tx++;
@@ -1148,7 +1151,7 @@ static void iser_cq_tasklet_fn(unsigned long data)
 	 struct ib_wc	     wc;
 	 struct iser_rx_desc *desc;
 	 unsigned long	     xfer_len;
-	struct iser_conn *ib_conn;
+	struct iser_conn *iser_conn;
 	int completed_tx, completed_rx = 0;
 
 	/* First do tx drain, so in a case where we have rx flushes and a successful
@@ -1159,11 +1162,11 @@ static void iser_cq_tasklet_fn(unsigned long data)
 	while (ib_poll_cq(cq, 1, &wc) == 1) {
 		desc	 = (struct iser_rx_desc *) (unsigned long) wc.wr_id;
 		BUG_ON(desc == NULL);
-		ib_conn = wc.qp->qp_context;
+		iser_conn = wc.qp->qp_context;
 		if (wc.status == IB_WC_SUCCESS) {
 			if (wc.opcode == IB_WC_RECV) {
 				xfer_len = (unsigned long)wc.byte_len;
-				iser_rcv_completion(desc, xfer_len, ib_conn);
+				iser_rcv_completion(desc, xfer_len, iser_conn);
 			} else
 				iser_err("expected opcode %d got %d\n",
 					IB_WC_RECV, wc.opcode);
@@ -1171,8 +1174,8 @@ static void iser_cq_tasklet_fn(unsigned long data)
 			if (wc.status != IB_WC_WR_FLUSH_ERR)
 				iser_err("rx id %llx status %d vend_err %x\n",
 					wc.wr_id, wc.status, wc.vendor_err);
-			ib_conn->post_recv_buf_count--;
-			iser_handle_comp_error(NULL, ib_conn);
+			iser_conn->post_recv_buf_count--;
+			iser_handle_comp_error(NULL, iser_conn);
 		}
 		completed_rx++;
 		if (!(completed_rx & 63))
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

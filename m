From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 02/21] IB/iser: Re-introduce ib_conn
Date: Wed,  1 Oct 2014 14:01:58 +0300
Message-ID: <1412161337-25285-3-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Structure that describes the RDMA relates connection
objects. Static member of iser_conn.

This patch does not change any functionality

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   18 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   85 ++++++----
 drivers/infiniband/ulp/iser/iser_initiator.c |   63 ++++----
 drivers/infiniband/ulp/iser/iser_memory.c    |   52 +++---
 drivers/infiniband/ulp/iser/iser_verbs.c     |  231 ++++++++++++++------------
 5 files changed, 245 insertions(+), 204 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1f3ad2b..db83530 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -148,7 +148,7 @@ int iser_initialize_task_headers(struct iscsi_task *task,
 						struct iser_tx_desc *tx_desc)
 {
 	struct iser_conn       *iser_conn   = task->conn->dd_data;
-	struct iser_device     *device    = iser_conn->device;
+	struct iser_device *device = iser_conn->ib_conn.device;
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	u64 dma_addr;
 
@@ -291,7 +291,7 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_tx_desc    *tx_desc   = &iser_task->desc;
 	struct iser_conn       *iser_conn	  = task->conn->dd_data;
-	struct iser_device     *device	  = iser_conn->device;
+	struct iser_device *device = iser_conn->ib_conn.device;
 
 	ib_dma_unmap_single(device->ib_device,
 		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
@@ -448,6 +448,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	struct iscsi_session *session;
 	struct Scsi_Host *shost;
 	struct iser_conn *iser_conn = NULL;
+	struct ib_conn *ib_conn;
 
 	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 0);
 	if (!shost)
@@ -465,8 +466,9 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	 */
 	if (ep) {
 		iser_conn = ep->dd_data;
-		if (iser_conn->pi_support) {
-			u32 sig_caps = iser_conn->device->dev_attr.sig_prot_cap;
+		ib_conn = &iser_conn->ib_conn;
+		if (ib_conn->pi_support) {
+			u32 sig_caps = ib_conn->device->dev_attr.sig_prot_cap;
 
 			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
 			if (iser_pi_guard)
@@ -477,7 +479,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	}
 
 	if (iscsi_host_add(shost, ep ?
-			   iser_conn->device->ib_device->dma_device : NULL))
+			   ib_conn->device->ib_device->dma_device : NULL))
 		goto free_host;
 
 	if (cmds_max > ISER_DEF_XMIT_CMDS_MAX) {
@@ -583,12 +585,12 @@ static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
 	case ISCSI_PARAM_CONN_ADDRESS:
-		if (!iser_conn || !iser_conn->cma_id)
+		if (!iser_conn || !iser_conn->ib_conn.cma_id)
 			return -ENOTCONN;
 
 		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
-					&iser_conn->cma_id->route.addr.dst_addr,
-					param, buf);
+				&iser_conn->ib_conn.cma_id->route.addr.dst_addr,
+				param, buf);
 		break;
 	default:
 		return -ENOSYS;
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index ec34b8f..4ad73c9 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -265,6 +265,7 @@ struct iser_rx_desc {
 #define ISER_MAX_CQ 4
 
 struct iser_conn;
+struct ib_conn;
 struct iscsi_iser_task;
 
 struct iser_device {
@@ -281,9 +282,9 @@ struct iser_device {
 	int                          cq_active_qps[ISER_MAX_CQ];
 	int			     cqs_used;
 	struct iser_cq_desc	     *cq_desc;
-	int                          (*iser_alloc_rdma_reg_res)(struct iser_conn *iser_conn,
+	int                          (*iser_alloc_rdma_reg_res)(struct ib_conn *ib_conn,
 								unsigned cmds_max);
-	void                         (*iser_free_rdma_reg_res)(struct iser_conn *iser_conn);
+	void                         (*iser_free_rdma_reg_res)(struct ib_conn *ib_conn);
 	int                          (*iser_reg_rdma_mem)(struct iscsi_iser_task *iser_task,
 							  enum iser_data_dir cmd_dir);
 	void                         (*iser_unreg_rdma_mem)(struct iscsi_iser_task *iser_task,
@@ -317,20 +318,57 @@ struct fast_reg_descriptor {
 	u8				  reg_indicators;
 };
 
+/**
+ * struct ib_conn - Infiniband related objects
+ *
+ * @cma_id:              rdma_cm connection maneger handle
+ * @qp:                  Connection Queue-pair
+ * @post_recv_buf_count: post receive counter
+ * @post_send_buf_count: post send counter
+ * @rx_wr:               receive work request for batch posts
+ * @device:              reference to iser device
+ * @pi_support:          Indicate device T10-PI support
+ * @lock:                protects fmr/fastreg pool
+ * @union.fmr:
+ *     @pool:            FMR pool for fast registrations
+ *     @page_vec:        page vector to hold mapped commands pages
+ *                       used for registration
+ * @union.fastreg:
+ *     @pool:            Fast registration descriptors pool for fast
+ *                       registrations
+ *     @pool_size:       Size of pool
+ */
+struct ib_conn {
+	struct rdma_cm_id           *cma_id;
+	struct ib_qp	            *qp;
+	int                          post_recv_buf_count;
+	atomic_t                     post_send_buf_count;
+	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
+	struct iser_device          *device;
+	int			     cq_index;
+	bool			     pi_support;
+	spinlock_t		     lock;
+	union {
+		struct {
+			struct ib_fmr_pool      *pool;
+			struct iser_page_vec	*page_vec;
+		} fmr;
+		struct {
+			struct list_head	 pool;
+			int			 pool_size;
+		} fastreg;
+	};
+};
+
 struct iser_conn {
+	struct ib_conn		     ib_conn;
 	struct iscsi_conn	     *iscsi_conn;
 	struct iscsi_endpoint	     *ep;
 	enum iser_conn_state	     state;	    /* rdma connection state   */
 	atomic_t		     refcount;
-	spinlock_t		     lock;	    /* used for state changes  */
-	struct iser_device           *device;       /* device context          */
-	struct rdma_cm_id            *cma_id;       /* CMA ID		       */
-	struct ib_qp	             *qp;           /* QP 		       */
 	unsigned		     qp_max_recv_dtos; /* num of rx buffers */
 	unsigned		     qp_max_recv_dtos_mask; /* above minus 1 */
 	unsigned		     min_posted_rx; /* qp_max_recv_dtos >> 2 */
-	int                          post_recv_buf_count; /* posted rx count  */
-	atomic_t                     post_send_buf_count; /* posted tx count   */
 	char 			     name[ISER_OBJECT_NAME_SIZE];
 	struct work_struct	     release_work;
 	struct completion	     stop_completion;
@@ -344,21 +382,6 @@ struct iser_conn {
 	u64			     login_req_dma, login_resp_dma;
 	unsigned int 		     rx_desc_head;
 	struct iser_rx_desc	     *rx_descs;
-	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
-	bool			     pi_support;
-
-	/* Connection memory registration pool */
-	union {
-		struct {
-			struct ib_fmr_pool      *pool;	   /* pool of IB FMRs         */
-			struct iser_page_vec	*page_vec; /* represents SG to fmr maps*
-							    * maps serialized as tx is*/
-		} fmr;
-		struct {
-			struct list_head	pool;
-			int			pool_size;
-		} fastreg;
-	};
 };
 
 struct iscsi_iser_task {
@@ -429,10 +452,10 @@ void iser_release_work(struct work_struct *work);
 
 void iser_rcv_completion(struct iser_rx_desc *desc,
 			 unsigned long    dto_xfer_len,
-			struct iser_conn *iser_conn);
+			 struct ib_conn *ib_conn);
 
 void iser_snd_completion(struct iser_tx_desc *desc,
-			 struct iser_conn *iser_conn);
+			 struct ib_conn *ib_conn);
 
 void iser_task_rdma_init(struct iscsi_iser_task *task);
 
@@ -455,7 +478,7 @@ int  iser_connect(struct iser_conn   *iser_conn,
 		  struct sockaddr    *dst_addr,
 		  int                non_blocking);
 
-int  iser_reg_page_vec(struct iser_conn     *iser_conn,
+int  iser_reg_page_vec(struct ib_conn *ib_conn,
 		       struct iser_page_vec *page_vec,
 		       struct iser_mem_reg  *mem_reg);
 
@@ -466,7 +489,7 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 int  iser_post_recvl(struct iser_conn *iser_conn);
 int  iser_post_recvm(struct iser_conn *iser_conn, int count);
-int  iser_post_send(struct iser_conn *iser_conn, struct iser_tx_desc *tx_desc);
+int  iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc);
 
 int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 			    struct iser_data_buf       *data,
@@ -479,10 +502,10 @@ int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
 int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 			      struct iscsi_session *session);
-int iser_create_fmr_pool(struct iser_conn *iser_conn, unsigned cmds_max);
-void iser_free_fmr_pool(struct iser_conn *iser_conn);
-int iser_create_fastreg_pool(struct iser_conn *iser_conn, unsigned cmds_max);
-void iser_free_fastreg_pool(struct iser_conn *iser_conn);
+int iser_create_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max);
+void iser_free_fmr_pool(struct ib_conn *ib_conn);
+int iser_create_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max);
+void iser_free_fastreg_pool(struct ib_conn *ib_conn);
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 1f53ccb..1231745 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -49,7 +49,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_device  *device = iser_task->iser_conn->device;
+	struct iser_device  *device = iser_task->iser_conn->ib_conn.device;
 	struct iser_regd_buf *regd_buf;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
@@ -103,7 +103,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 		       unsigned int edtl)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_device  *device = iser_task->iser_conn->device;
+	struct iser_device  *device = iser_task->iser_conn->ib_conn.device;
 	struct iser_regd_buf *regd_buf;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
@@ -163,7 +163,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 static void iser_create_send_desc(struct iser_conn	*iser_conn,
 				  struct iser_tx_desc	*tx_desc)
 {
-	struct iser_device *device = iser_conn->device;
+	struct iser_device *device = iser_conn->ib_conn.device;
 
 	ib_dma_sync_single_for_cpu(device->ib_device,
 		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
@@ -181,16 +181,18 @@ static void iser_create_send_desc(struct iser_conn	*iser_conn,
 
 static void iser_free_login_buf(struct iser_conn *iser_conn)
 {
+	struct iser_device *device = iser_conn->ib_conn.device;
+
 	if (!iser_conn->login_buf)
 		return;
 
 	if (iser_conn->login_req_dma)
-		ib_dma_unmap_single(iser_conn->device->ib_device,
+		ib_dma_unmap_single(device->ib_device,
 				    iser_conn->login_req_dma,
 				    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
 
 	if (iser_conn->login_resp_dma)
-		ib_dma_unmap_single(iser_conn->device->ib_device,
+		ib_dma_unmap_single(device->ib_device,
 				    iser_conn->login_resp_dma,
 				    ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
 
@@ -204,12 +206,10 @@ static void iser_free_login_buf(struct iser_conn *iser_conn)
 
 static int iser_alloc_login_buf(struct iser_conn *iser_conn)
 {
-	struct iser_device	*device;
+	struct iser_device *device = iser_conn->ib_conn.device;
 	int			req_err, resp_err;
 
-	BUG_ON(iser_conn->device == NULL);
-
-	device = iser_conn->device;
+	BUG_ON(device == NULL);
 
 	iser_conn->login_buf = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
 				     ISER_RX_LOGIN_SIZE, GFP_KERNEL);
@@ -259,13 +259,14 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 	u64 dma_addr;
 	struct iser_rx_desc *rx_desc;
 	struct ib_sge       *rx_sg;
-	struct iser_device  *device = iser_conn->device;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
 
 	iser_conn->qp_max_recv_dtos = session->cmds_max;
 	iser_conn->qp_max_recv_dtos_mask = session->cmds_max - 1; /* cmds_max is 2^N */
 	iser_conn->min_posted_rx = iser_conn->qp_max_recv_dtos >> 2;
 
-	if (device->iser_alloc_rdma_reg_res(iser_conn, session->scsi_cmds_max))
+	if (device->iser_alloc_rdma_reg_res(ib_conn, session->scsi_cmds_max))
 		goto create_rdma_reg_res_failed;
 
 	if (iser_alloc_login_buf(iser_conn))
@@ -305,7 +306,7 @@ rx_desc_dma_map_failed:
 rx_desc_alloc_fail:
 	iser_free_login_buf(iser_conn);
 alloc_login_buf_fail:
-	device->iser_free_rdma_reg_res(iser_conn);
+	device->iser_free_rdma_reg_res(ib_conn);
 create_rdma_reg_res_failed:
 	iser_err("failed allocating rx descriptors / data buffers\n");
 	return -ENOMEM;
@@ -315,13 +316,14 @@ void iser_free_rx_descriptors(struct iser_conn *iser_conn)
 {
 	int i;
 	struct iser_rx_desc *rx_desc;
-	struct iser_device *device = iser_conn->device;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
 
 	if (!iser_conn->rx_descs)
 		goto free_login_buf;
 
 	if (device->iser_free_rdma_reg_res)
-		device->iser_free_rdma_reg_res(iser_conn);
+		device->iser_free_rdma_reg_res(ib_conn);
 
 	rx_desc = iser_conn->rx_descs;
 	for (i = 0; i < iser_conn->qp_max_recv_dtos; i++, rx_desc++)
@@ -338,6 +340,7 @@ free_login_buf:
 static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 {
 	struct iser_conn *iser_conn = conn->dd_data;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct iscsi_session *session = conn->session;
 
 	iser_dbg("req op %x flags %x\n", req->opcode, req->flags);
@@ -350,8 +353,8 @@ static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 	 * response) and no posted send buffers left - they must have been
 	 * consumed during previous login phases.
 	 */
-	WARN_ON(iser_conn->post_recv_buf_count != 1);
-	WARN_ON(atomic_read(&iser_conn->post_send_buf_count) != 0);
+	WARN_ON(ib_conn->post_recv_buf_count != 1);
+	WARN_ON(atomic_read(&ib_conn->post_send_buf_count) != 0);
 
 	if (session->discovery_sess) {
 		iser_info("Discovery session, re-using login RX buffer\n");
@@ -426,7 +429,7 @@ int iser_send_command(struct iscsi_conn *conn,
 
 	iser_task->status = ISER_TASK_STATUS_STARTED;
 
-	err = iser_post_send(iser_conn, tx_desc);
+	err = iser_post_send(&iser_conn->ib_conn, tx_desc);
 	if (!err)
 		return 0;
 
@@ -491,7 +494,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 		 itt, buf_offset, data_seg_len);
 
 
-	err = iser_post_send(iser_conn, tx_desc);
+	err = iser_post_send(&iser_conn->ib_conn, tx_desc);
 	if (!err)
 		return 0;
 
@@ -515,7 +518,7 @@ int iser_send_control(struct iscsi_conn *conn,
 	mdesc->type = ISCSI_TX_CONTROL;
 	iser_create_send_desc(iser_conn, mdesc);
 
-	device = iser_conn->device;
+	device = iser_conn->ib_conn.device;
 
 	data_seg_len = ntoh24(task->hdr->dlength);
 
@@ -553,7 +556,7 @@ int iser_send_control(struct iscsi_conn *conn,
 			goto send_control_error;
 	}
 
-	err = iser_post_send(iser_conn, mdesc);
+	err = iser_post_send(&iser_conn->ib_conn, mdesc);
 	if (!err)
 		return 0;
 
@@ -567,8 +570,10 @@ send_control_error:
  */
 void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 			 unsigned long rx_xfer_len,
-			 struct iser_conn *iser_conn)
+			 struct ib_conn *ib_conn)
 {
+	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
+						   ib_conn);
 	struct iscsi_hdr *hdr;
 	u64 rx_dma;
 	int rx_buflen, outstanding, count, err;
@@ -582,7 +587,7 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 		rx_buflen = ISER_RX_PAYLOAD_SIZE;
 	}
 
-	ib_dma_sync_single_for_cpu(iser_conn->device->ib_device, rx_dma,
+	ib_dma_sync_single_for_cpu(ib_conn->device->ib_device, rx_dma,
 				   rx_buflen, DMA_FROM_DEVICE);
 
 	hdr = &rx_desc->iscsi_header;
@@ -593,19 +598,19 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, rx_desc->data,
 			rx_xfer_len - ISER_HEADERS_LEN);
 
-	ib_dma_sync_single_for_device(iser_conn->device->ib_device, rx_dma,
+	ib_dma_sync_single_for_device(ib_conn->device->ib_device, rx_dma,
 				      rx_buflen, DMA_FROM_DEVICE);
 
 	/* decrementing conn->post_recv_buf_count only --after-- freeing the   *
 	 * task eliminates the need to worry on tasks which are completed in   *
 	 * parallel to the execution of iser_conn_term. So the code that waits *
 	 * for the posted rx bufs refcount to become zero handles everything   */
-	iser_conn->post_recv_buf_count--;
+	ib_conn->post_recv_buf_count--;
 
 	if (rx_dma == iser_conn->login_resp_dma)
 		return;
 
-	outstanding = iser_conn->post_recv_buf_count;
+	outstanding = ib_conn->post_recv_buf_count;
 	if (outstanding + iser_conn->min_posted_rx <= iser_conn->qp_max_recv_dtos) {
 		count = min(iser_conn->qp_max_recv_dtos - outstanding,
 			    iser_conn->min_posted_rx);
@@ -616,10 +621,10 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 }
 
 void iser_snd_completion(struct iser_tx_desc *tx_desc,
-			struct iser_conn *iser_conn)
+			struct ib_conn *ib_conn)
 {
 	struct iscsi_task *task;
-	struct iser_device *device = iser_conn->device;
+	struct iser_device *device = ib_conn->device;
 
 	if (tx_desc->type == ISCSI_TX_DATAOUT) {
 		ib_dma_unmap_single(device->ib_device, tx_desc->dma_addr,
@@ -628,7 +633,7 @@ void iser_snd_completion(struct iser_tx_desc *tx_desc,
 		tx_desc = NULL;
 	}
 
-	atomic_dec(&iser_conn->post_send_buf_count);
+	atomic_dec(&ib_conn->post_send_buf_count);
 
 	if (tx_desc && tx_desc->type == ISCSI_TX_CONTROL) {
 		/* this arithmetic is legal by libiscsi dd_data allocation */
@@ -661,7 +666,7 @@ void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
 
 void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 {
-	struct iser_device *device = iser_task->iser_conn->device;
+	struct iser_device *device = iser_task->iser_conn->ib_conn.device;
 	int is_rdma_data_aligned = 1;
 	int is_rdma_prot_aligned = 1;
 	int prot_count = scsi_prot_sg_count(iser_task->sc);
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index ba09fbb..de4db76 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -49,7 +49,7 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 					struct iser_data_buf *data_copy,
 					enum iser_data_dir cmd_dir)
 {
-	struct ib_device *dev = iser_task->iser_conn->device->ib_device;
+	struct ib_device *dev = iser_task->iser_conn->ib_conn.device->ib_device;
 	struct scatterlist *sgl = (struct scatterlist *)data->buf;
 	struct scatterlist *sg;
 	char *mem = NULL;
@@ -116,7 +116,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 	struct ib_device *dev;
 	unsigned long  cmd_data_len;
 
-	dev = iser_task->iser_conn->device->ib_device;
+	dev = iser_task->iser_conn->ib_conn.device->ib_device;
 
 	ib_dma_unmap_sg(dev, &data_copy->sg_single, 1,
 			(cmd_dir == ISER_DIR_OUT) ?
@@ -322,7 +322,7 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 	struct ib_device *dev;
 
 	iser_task->dir[iser_dir] = 1;
-	dev = iser_task->iser_conn->device->ib_device;
+	dev = iser_task->iser_conn->ib_conn.device->ib_device;
 
 	data->dma_nents = ib_dma_map_sg(dev, data->buf, data->size, dma_dir);
 	if (data->dma_nents == 0) {
@@ -337,7 +337,7 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
 {
 	struct ib_device *dev;
 
-	dev = iser_task->iser_conn->device->ib_device;
+	dev = iser_task->iser_conn->ib_conn.device->ib_device;
 	ib_dma_unmap_sg(dev, data->buf, data->size, DMA_FROM_DEVICE);
 }
 
@@ -377,8 +377,8 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 			  enum iser_data_dir cmd_dir)
 {
-	struct iser_conn     *iser_conn = iser_task->iser_conn;
-	struct iser_device   *device = iser_conn->device;
+	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
+	struct iser_device   *device = ib_conn->device;
 	struct ib_device     *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
 	struct iser_regd_buf *regd_buf;
@@ -418,8 +418,8 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 			 (unsigned long)regd_buf->reg.va,
 			 (unsigned long)regd_buf->reg.len);
 	} else { /* use FMR for multiple dma entries */
-		iser_page_vec_build(mem, iser_conn->fmr.page_vec, ibdev);
-		err = iser_reg_page_vec(iser_conn, iser_conn->fmr.page_vec,
+		iser_page_vec_build(mem, ib_conn->fmr.page_vec, ibdev);
+		err = iser_reg_page_vec(ib_conn, ib_conn->fmr.page_vec,
 					&regd_buf->reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
@@ -427,12 +427,12 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 				 mem->dma_nents,
 				 ntoh24(iser_task->desc.iscsi_header.dlength));
 			iser_err("page_vec: data_size = 0x%x, length = %d, offset = 0x%x\n",
-				 iser_conn->fmr.page_vec->data_size,
-				 iser_conn->fmr.page_vec->length,
-				 iser_conn->fmr.page_vec->offset);
-			for (i = 0; i < iser_conn->fmr.page_vec->length; i++)
+				 ib_conn->fmr.page_vec->data_size,
+				 ib_conn->fmr.page_vec->length,
+				 ib_conn->fmr.page_vec->offset);
+			for (i = 0; i < ib_conn->fmr.page_vec->length; i++)
 				iser_err("page_vec[%d] = 0x%llx\n", i,
-					 (unsigned long long)iser_conn->fmr.page_vec->pages[i]);
+					 (unsigned long long)ib_conn->fmr.page_vec->pages[i]);
 		}
 		if (err)
 			return err;
@@ -533,7 +533,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 		struct fast_reg_descriptor *desc, struct ib_sge *data_sge,
 		struct ib_sge *prot_sge, struct ib_sge *sig_sge)
 {
-	struct iser_conn *iser_conn = iser_task->iser_conn;
+	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
 	struct iser_pi_context *pi_ctx = desc->pi_ctx;
 	struct ib_send_wr sig_wr, inv_wr;
 	struct ib_send_wr *bad_wr, *wr = NULL;
@@ -579,7 +579,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	else
 		wr->next = &sig_wr;
 
-	ret = ib_post_send(iser_conn->qp, wr, &bad_wr);
+	ret = ib_post_send(ib_conn->qp, wr, &bad_wr);
 	if (ret) {
 		iser_err("reg_sig_mr failed, ret:%d\n", ret);
 		goto err;
@@ -609,8 +609,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 			    struct ib_sge *sge)
 {
 	struct fast_reg_descriptor *desc = regd_buf->reg.mem_h;
-	struct iser_conn *iser_conn = iser_task->iser_conn;
-	struct iser_device *device = iser_conn->device;
+	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
 	struct ib_device *ibdev = device->ib_device;
 	struct ib_mr *mr;
 	struct ib_fast_reg_page_list *frpl;
@@ -677,7 +677,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	else
 		wr->next = &fastreg_wr;
 
-	ret = ib_post_send(iser_conn->qp, wr, &bad_wr);
+	ret = ib_post_send(ib_conn->qp, wr, &bad_wr);
 	if (ret) {
 		iser_err("fast registration failed, ret:%d\n", ret);
 		return ret;
@@ -700,8 +700,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 			      enum iser_data_dir cmd_dir)
 {
-	struct iser_conn *iser_conn = iser_task->iser_conn;
-	struct iser_device *device = iser_conn->device;
+	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
 	struct ib_device *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
 	struct iser_regd_buf *regd_buf = &iser_task->rdma_regd[cmd_dir];
@@ -724,11 +724,11 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 	if (mem->dma_nents != 1 ||
 	    scsi_get_prot_op(iser_task->sc) != SCSI_PROT_NORMAL) {
-		spin_lock_irqsave(&iser_conn->lock, flags);
-		desc = list_first_entry(&iser_conn->fastreg.pool,
+		spin_lock_irqsave(&ib_conn->lock, flags);
+		desc = list_first_entry(&ib_conn->fastreg.pool,
 					struct fast_reg_descriptor, list);
 		list_del(&desc->list);
-		spin_unlock_irqrestore(&iser_conn->lock, flags);
+		spin_unlock_irqrestore(&ib_conn->lock, flags);
 		regd_buf->reg.mem_h = desc;
 	}
 
@@ -791,9 +791,9 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 	return 0;
 err_reg:
 	if (desc) {
-		spin_lock_irqsave(&iser_conn->lock, flags);
-		list_add_tail(&desc->list, &iser_conn->fastreg.pool);
-		spin_unlock_irqrestore(&iser_conn->lock, flags);
+		spin_lock_irqsave(&ib_conn->lock, flags);
+		list_add_tail(&desc->list, &ib_conn->fastreg.pool);
+		spin_unlock_irqrestore(&ib_conn->lock, flags);
 	}
 
 	return err;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 778c166..e69aba8 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -213,19 +213,19 @@ static void iser_free_device_ib_res(struct iser_device *device)
  *
  * returns 0 on success, or errno code on failure
  */
-int iser_create_fmr_pool(struct iser_conn *iser_conn, unsigned cmds_max)
+int iser_create_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 {
-	struct iser_device *device = iser_conn->device;
+	struct iser_device *device = ib_conn->device;
 	struct ib_fmr_pool_param params;
 	int ret = -ENOMEM;
 
-	iser_conn->fmr.page_vec = kmalloc(sizeof(*iser_conn->fmr.page_vec) +
+	ib_conn->fmr.page_vec = kmalloc(sizeof(*ib_conn->fmr.page_vec) +
 					(sizeof(u64)*(ISCSI_ISER_SG_TABLESIZE + 1)),
 					GFP_KERNEL);
-	if (!iser_conn->fmr.page_vec)
+	if (!ib_conn->fmr.page_vec)
 		return ret;
 
-	iser_conn->fmr.page_vec->pages = (u64 *)(iser_conn->fmr.page_vec + 1);
+	ib_conn->fmr.page_vec->pages = (u64 *)(ib_conn->fmr.page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
 	/* when the first/last SG element are not start/end *
@@ -241,16 +241,16 @@ int iser_create_fmr_pool(struct iser_conn *iser_conn, unsigned cmds_max)
 				    IB_ACCESS_REMOTE_WRITE |
 				    IB_ACCESS_REMOTE_READ);
 
-	iser_conn->fmr.pool = ib_create_fmr_pool(device->pd, &params);
-	if (!IS_ERR(iser_conn->fmr.pool))
+	ib_conn->fmr.pool = ib_create_fmr_pool(device->pd, &params);
+	if (!IS_ERR(ib_conn->fmr.pool))
 		return 0;
 
 	/* no FMR => no need for page_vec */
-	kfree(iser_conn->fmr.page_vec);
-	iser_conn->fmr.page_vec = NULL;
+	kfree(ib_conn->fmr.page_vec);
+	ib_conn->fmr.page_vec = NULL;
 
-	ret = PTR_ERR(iser_conn->fmr.pool);
-	iser_conn->fmr.pool = NULL;
+	ret = PTR_ERR(ib_conn->fmr.pool);
+	ib_conn->fmr.pool = NULL;
 	if (ret != -ENOSYS) {
 		iser_err("FMR allocation failed, err %d\n", ret);
 		return ret;
@@ -263,18 +263,18 @@ int iser_create_fmr_pool(struct iser_conn *iser_conn, unsigned cmds_max)
 /**
  * iser_free_fmr_pool - releases the FMR pool and page vec
  */
-void iser_free_fmr_pool(struct iser_conn *iser_conn)
+void iser_free_fmr_pool(struct ib_conn *ib_conn)
 {
 	iser_info("freeing conn %p fmr pool %p\n",
-		  iser_conn, iser_conn->fmr.pool);
+		  ib_conn, ib_conn->fmr.pool);
 
-	if (iser_conn->fmr.pool != NULL)
-		ib_destroy_fmr_pool(iser_conn->fmr.pool);
+	if (ib_conn->fmr.pool != NULL)
+		ib_destroy_fmr_pool(ib_conn->fmr.pool);
 
-	iser_conn->fmr.pool = NULL;
+	ib_conn->fmr.pool = NULL;
 
-	kfree(iser_conn->fmr.page_vec);
-	iser_conn->fmr.page_vec = NULL;
+	kfree(ib_conn->fmr.page_vec);
+	ib_conn->fmr.page_vec = NULL;
 }
 
 static int
@@ -367,14 +367,14 @@ fast_reg_mr_failure:
  * for fast registration work requests.
  * returns 0 on success, or errno code on failure
  */
-int iser_create_fastreg_pool(struct iser_conn *iser_conn, unsigned cmds_max)
+int iser_create_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 {
-	struct iser_device	*device = iser_conn->device;
-	struct fast_reg_descriptor	*desc;
+	struct iser_device *device = ib_conn->device;
+	struct fast_reg_descriptor *desc;
 	int i, ret;
 
-	INIT_LIST_HEAD(&iser_conn->fastreg.pool);
-	iser_conn->fastreg.pool_size = 0;
+	INIT_LIST_HEAD(&ib_conn->fastreg.pool);
+	ib_conn->fastreg.pool_size = 0;
 	for (i = 0; i < cmds_max; i++) {
 		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
 		if (!desc) {
@@ -384,7 +384,7 @@ int iser_create_fastreg_pool(struct iser_conn *iser_conn, unsigned cmds_max)
 		}
 
 		ret = iser_create_fastreg_desc(device->ib_device, device->pd,
-					       iser_conn->pi_support, desc);
+					       ib_conn->pi_support, desc);
 		if (ret) {
 			iser_err("Failed to create fastreg descriptor err=%d\n",
 				 ret);
@@ -392,31 +392,31 @@ int iser_create_fastreg_pool(struct iser_conn *iser_conn, unsigned cmds_max)
 			goto err;
 		}
 
-		list_add_tail(&desc->list, &iser_conn->fastreg.pool);
-		iser_conn->fastreg.pool_size++;
+		list_add_tail(&desc->list, &ib_conn->fastreg.pool);
+		ib_conn->fastreg.pool_size++;
 	}
 
 	return 0;
 
 err:
-	iser_free_fastreg_pool(iser_conn);
+	iser_free_fastreg_pool(ib_conn);
 	return ret;
 }
 
 /**
  * iser_free_fastreg_pool - releases the pool of fast_reg descriptors
  */
-void iser_free_fastreg_pool(struct iser_conn *iser_conn)
+void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 {
 	struct fast_reg_descriptor *desc, *tmp;
 	int i = 0;
 
-	if (list_empty(&iser_conn->fastreg.pool))
+	if (list_empty(&ib_conn->fastreg.pool))
 		return;
 
-	iser_info("freeing conn %p fr pool\n", iser_conn);
+	iser_info("freeing conn %p fr pool\n", ib_conn);
 
-	list_for_each_entry_safe(desc, tmp, &iser_conn->fastreg.pool, list) {
+	list_for_each_entry_safe(desc, tmp, &ib_conn->fastreg.pool, list) {
 		list_del(&desc->list);
 		ib_free_fast_reg_page_list(desc->data_frpl);
 		ib_dereg_mr(desc->data_mr);
@@ -430,9 +430,9 @@ void iser_free_fastreg_pool(struct iser_conn *iser_conn)
 		++i;
 	}
 
-	if (i < iser_conn->fastreg.pool_size)
+	if (i < ib_conn->fastreg.pool_size)
 		iser_warn("pool still has %d regions registered\n",
-			  iser_conn->fastreg.pool_size - i);
+			  ib_conn->fastreg.pool_size - i);
 }
 
 /**
@@ -440,16 +440,16 @@ void iser_free_fastreg_pool(struct iser_conn *iser_conn)
  *
  * returns 0 on success, -1 on failure
  */
-static int iser_create_ib_conn_res(struct iser_conn *iser_conn)
+static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 {
 	struct iser_device	*device;
 	struct ib_qp_init_attr	init_attr;
 	int			ret = -ENOMEM;
 	int index, min_index = 0;
 
-	BUG_ON(iser_conn->device == NULL);
+	BUG_ON(ib_conn->device == NULL);
 
-	device = iser_conn->device;
+	device = ib_conn->device;
 
 	memset(&init_attr, 0, sizeof init_attr);
 
@@ -460,11 +460,12 @@ static int iser_create_ib_conn_res(struct iser_conn *iser_conn)
 		    device->cq_active_qps[min_index])
 			min_index = index;
 	device->cq_active_qps[min_index]++;
+	ib_conn->cq_index = min_index;
 	mutex_unlock(&ig.connlist_mutex);
-	iser_info("cq index %d used for iser_conn %p\n", min_index, iser_conn);
+	iser_info("cq index %d used for ib_conn %p\n", min_index, ib_conn);
 
 	init_attr.event_handler = iser_qp_event_callback;
-	init_attr.qp_context	= (void *)iser_conn;
+	init_attr.qp_context	= (void *)ib_conn;
 	init_attr.send_cq	= device->tx_cq[min_index];
 	init_attr.recv_cq	= device->rx_cq[min_index];
 	init_attr.cap.max_recv_wr  = ISER_QP_MAX_RECV_DTOS;
@@ -472,21 +473,21 @@ static int iser_create_ib_conn_res(struct iser_conn *iser_conn)
 	init_attr.cap.max_recv_sge = 1;
 	init_attr.sq_sig_type	= IB_SIGNAL_REQ_WR;
 	init_attr.qp_type	= IB_QPT_RC;
-	if (iser_conn->pi_support) {
+	if (ib_conn->pi_support) {
 		init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS;
 		init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
 	} else {
 		init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS;
 	}
 
-	ret = rdma_create_qp(iser_conn->cma_id, device->pd, &init_attr);
+	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
 	if (ret)
 		goto out_err;
 
-	iser_conn->qp = iser_conn->cma_id->qp;
+	ib_conn->qp = ib_conn->cma_id->qp;
 	iser_info("setting conn %p cma_id %p qp %p\n",
-		  iser_conn, iser_conn->cma_id,
-		  iser_conn->cma_id->qp);
+		  ib_conn, ib_conn->cma_id,
+		  ib_conn->cma_id->qp);
 	return ret;
 
 out_err:
@@ -499,23 +500,20 @@ out_err:
  */
 static void iser_free_ib_conn_res(struct iser_conn *iser_conn)
 {
-	int cq_index;
-	BUG_ON(iser_conn == NULL);
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 
 	iser_info("freeing conn %p cma_id %p qp %p\n",
-		  iser_conn, iser_conn->cma_id,
-		  iser_conn->qp);
+		  ib_conn, ib_conn->cma_id,
+		  ib_conn->qp);
 
 	/* qp is created only once both addr & route are resolved */
 
-	if (iser_conn->qp != NULL) {
-		cq_index = ((struct iser_cq_desc *)iser_conn->qp->recv_cq->cq_context)->cq_index;
-		iser_conn->device->cq_active_qps[cq_index]--;
-
-		rdma_destroy_qp(iser_conn->cma_id);
+	if (ib_conn->qp != NULL) {
+		ib_conn->device->cq_active_qps[ib_conn->cq_index]--;
+		rdma_destroy_qp(ib_conn->cma_id);
 	}
 
-	iser_conn->qp	  = NULL;
+	ib_conn->qp	  = NULL;
 }
 
 /**
@@ -614,7 +612,8 @@ void iser_release_work(struct work_struct *work)
  */
 void iser_conn_release(struct iser_conn *iser_conn)
 {
-	struct iser_device  *device = iser_conn->device;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
+	struct iser_device  *device = ib_conn->device;
 
 	mutex_lock(&ig.connlist_mutex);
 	list_del(&iser_conn->conn_list);
@@ -625,17 +624,17 @@ void iser_conn_release(struct iser_conn *iser_conn)
 
 	iser_free_rx_descriptors(iser_conn);
 	iser_free_ib_conn_res(iser_conn);
-	iser_conn->device = NULL;
+	ib_conn->device = NULL;
 	/* on EVENT_ADDR_ERROR there's no device yet for this conn */
 	if (device != NULL)
 		iser_device_try_release(device);
 	mutex_unlock(&iser_conn->state_mutex);
 
-	/* if cma handler context, the caller actually destroy the id */
-	if (iser_conn->cma_id != NULL) {
-		rdma_destroy_id(iser_conn->cma_id);
-		iser_conn->cma_id = NULL;
+	if (ib_conn->cma_id != NULL) {
+		rdma_destroy_id(ib_conn->cma_id);
+		ib_conn->cma_id = NULL;
 	}
+
 	kfree(iser_conn);
 }
 
@@ -644,6 +643,7 @@ void iser_conn_release(struct iser_conn *iser_conn)
  */
 void iser_conn_terminate(struct iser_conn *iser_conn)
 {
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	int err = 0;
 
 	/* change the ib conn state only if the conn is UP, however always call
@@ -652,7 +652,7 @@ void iser_conn_terminate(struct iser_conn *iser_conn)
 	 */
 
 	iser_conn_state_comp_exch(iser_conn, ISER_CONN_UP, ISER_CONN_TERMINATING);
-	err = rdma_disconnect(iser_conn->cma_id);
+	err = rdma_disconnect(ib_conn->cma_id);
 	if (err)
 		iser_err("Failed to disconnect, conn: 0x%p err %d\n",
 			 iser_conn, err);
@@ -676,6 +676,7 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 {
 	struct iser_device *device;
 	struct iser_conn   *iser_conn;
+	struct ib_conn   *ib_conn;
 	int    ret;
 
 	iser_conn = (struct iser_conn *)cma_id->context;
@@ -683,6 +684,7 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 		/* bailout */
 		return;
 
+	ib_conn = &iser_conn->ib_conn;
 	device = iser_device_find_by_ib_device(cma_id);
 	if (!device) {
 		iser_err("device lookup/creation failed\n");
@@ -690,7 +692,7 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 		return;
 	}
 
-	iser_conn->device = device;
+	ib_conn->device = device;
 
 	/* connection T10-PI support */
 	if (iser_pi_enable) {
@@ -698,10 +700,10 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 		      IB_DEVICE_SIGNATURE_HANDOVER)) {
 			iser_warn("T10-PI requested but not supported on %s, "
 				  "continue without T10-PI\n",
-				  iser_conn->device->ib_device->name);
-			iser_conn->pi_support = false;
+				  ib_conn->device->ib_device->name);
+			ib_conn->pi_support = false;
 		} else {
-			iser_conn->pi_support = true;
+			ib_conn->pi_support = true;
 		}
 	}
 
@@ -722,13 +724,14 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
 	int    ret;
 	struct iser_cm_hdr req_hdr;
 	struct iser_conn *iser_conn = (struct iser_conn *)cma_id->context;
-	struct iser_device *device = iser_conn->device;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
 
 	if (iser_conn->state != ISER_CONN_PENDING)
 		/* bailout */
 		return;
 
-	ret = iser_create_ib_conn_res((struct iser_conn *)cma_id->context);
+	ret = iser_create_ib_conn_res(ib_conn);
 	if (ret)
 		goto failure;
 
@@ -776,6 +779,7 @@ static void iser_connected_handler(struct rdma_cm_id *cma_id)
 static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
 {
 	struct iser_conn *iser_conn;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 
 	iser_conn = (struct iser_conn *)cma_id->context;
 
@@ -793,8 +797,8 @@ static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
 	 * block also exists in iser_handle_comp_error(), but it is needed here
 	 * for cases of no flushes at all, e.g. discovery over rdma.
 	 */
-	if (iser_conn->post_recv_buf_count == 0 &&
-	    (atomic_read(&iser_conn->post_send_buf_count) == 0)) {
+	if (ib_conn->post_recv_buf_count == 0 &&
+	    (atomic_read(&ib_conn->post_send_buf_count) == 0)) {
 		complete(&iser_conn->flush_completion);
 	}
 }
@@ -842,13 +846,13 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 void iser_conn_init(struct iser_conn *iser_conn)
 {
 	iser_conn->state = ISER_CONN_INIT;
-	iser_conn->post_recv_buf_count = 0;
-	atomic_set(&iser_conn->post_send_buf_count, 0);
+	iser_conn->ib_conn.post_recv_buf_count = 0;
+	atomic_set(&iser_conn->ib_conn.post_send_buf_count, 0);
 	init_completion(&iser_conn->stop_completion);
 	init_completion(&iser_conn->flush_completion);
 	init_completion(&iser_conn->up_completion);
 	INIT_LIST_HEAD(&iser_conn->conn_list);
-	spin_lock_init(&iser_conn->lock);
+	spin_lock_init(&iser_conn->ib_conn.lock);
 	mutex_init(&iser_conn->state_mutex);
 }
 
@@ -861,6 +865,7 @@ int iser_connect(struct iser_conn   *iser_conn,
 		 struct sockaddr    *dst_addr,
 		 int                 non_blocking)
 {
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	int err = 0;
 
 	mutex_lock(&iser_conn->state_mutex);
@@ -870,20 +875,20 @@ int iser_connect(struct iser_conn   *iser_conn,
 	iser_info("connecting to: %s\n", iser_conn->name);
 
 	/* the device is known only --after-- address resolution */
-	iser_conn->device = NULL;
+	ib_conn->device = NULL;
 
 	iser_conn->state = ISER_CONN_PENDING;
 
-	iser_conn->cma_id = rdma_create_id(iser_cma_handler,
-					     (void *)iser_conn,
-					     RDMA_PS_TCP, IB_QPT_RC);
-	if (IS_ERR(iser_conn->cma_id)) {
-		err = PTR_ERR(iser_conn->cma_id);
+	ib_conn->cma_id = rdma_create_id(iser_cma_handler,
+					 (void *)iser_conn,
+					 RDMA_PS_TCP, IB_QPT_RC);
+	if (IS_ERR(ib_conn->cma_id)) {
+		err = PTR_ERR(ib_conn->cma_id);
 		iser_err("rdma_create_id failed: %d\n", err);
 		goto id_failure;
 	}
 
-	err = rdma_resolve_addr(iser_conn->cma_id, src_addr, dst_addr, 1000);
+	err = rdma_resolve_addr(ib_conn->cma_id, src_addr, dst_addr, 1000);
 	if (err) {
 		iser_err("rdma_resolve_addr failed: %d\n", err);
 		goto addr_failure;
@@ -905,7 +910,7 @@ int iser_connect(struct iser_conn   *iser_conn,
 	return 0;
 
 id_failure:
-	iser_conn->cma_id = NULL;
+	ib_conn->cma_id = NULL;
 addr_failure:
 	iser_conn->state = ISER_CONN_DOWN;
 connect_failure:
@@ -919,7 +924,7 @@ connect_failure:
  *
  * returns: 0 on success, errno code on failure
  */
-int iser_reg_page_vec(struct iser_conn     *iser_conn,
+int iser_reg_page_vec(struct ib_conn *ib_conn,
 		      struct iser_page_vec *page_vec,
 		      struct iser_mem_reg  *mem_reg)
 {
@@ -931,7 +936,7 @@ int iser_reg_page_vec(struct iser_conn     *iser_conn,
 	page_list = page_vec->pages;
 	io_addr	  = page_list[0];
 
-	mem  = ib_fmr_pool_map_phys(iser_conn->fmr.pool,
+	mem  = ib_fmr_pool_map_phys(ib_conn->fmr.pool,
 				    page_list,
 				    page_vec->length,
 				    io_addr);
@@ -990,6 +995,7 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 {
 	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
 	struct iser_conn *iser_conn = iser_task->iser_conn;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct fast_reg_descriptor *desc = reg->mem_h;
 
 	if (!reg->is_mr)
@@ -997,31 +1003,32 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 	reg->mem_h = NULL;
 	reg->is_mr = 0;
-	spin_lock_bh(&iser_conn->lock);
-	list_add_tail(&desc->list, &iser_conn->fastreg.pool);
-	spin_unlock_bh(&iser_conn->lock);
+	spin_lock_bh(&ib_conn->lock);
+	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
+	spin_unlock_bh(&ib_conn->lock);
 }
 
 int iser_post_recvl(struct iser_conn *iser_conn)
 {
 	struct ib_recv_wr rx_wr, *rx_wr_failed;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct ib_sge	  sge;
 	int ib_ret;
 
 	sge.addr   = iser_conn->login_resp_dma;
 	sge.length = ISER_RX_LOGIN_SIZE;
-	sge.lkey   = iser_conn->device->mr->lkey;
+	sge.lkey   = ib_conn->device->mr->lkey;
 
 	rx_wr.wr_id   = (unsigned long)iser_conn->login_resp_buf;
 	rx_wr.sg_list = &sge;
 	rx_wr.num_sge = 1;
 	rx_wr.next    = NULL;
 
-	iser_conn->post_recv_buf_count++;
-	ib_ret	= ib_post_recv(iser_conn->qp, &rx_wr, &rx_wr_failed);
+	ib_conn->post_recv_buf_count++;
+	ib_ret	= ib_post_recv(ib_conn->qp, &rx_wr, &rx_wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
-		iser_conn->post_recv_buf_count--;
+		ib_conn->post_recv_buf_count--;
 	}
 	return ib_ret;
 }
@@ -1030,10 +1037,11 @@ int iser_post_recvm(struct iser_conn *iser_conn, int count)
 {
 	struct ib_recv_wr *rx_wr, *rx_wr_failed;
 	int i, ib_ret;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	unsigned int my_rx_head = iser_conn->rx_desc_head;
 	struct iser_rx_desc *rx_desc;
 
-	for (rx_wr = iser_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
+	for (rx_wr = ib_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
 		rx_desc		= &iser_conn->rx_descs[my_rx_head];
 		rx_wr->wr_id	= (unsigned long)rx_desc;
 		rx_wr->sg_list	= &rx_desc->rx_sg;
@@ -1045,11 +1053,11 @@ int iser_post_recvm(struct iser_conn *iser_conn, int count)
 	rx_wr--;
 	rx_wr->next = NULL; /* mark end of work requests list */
 
-	iser_conn->post_recv_buf_count += count;
-	ib_ret	= ib_post_recv(iser_conn->qp, iser_conn->rx_wr, &rx_wr_failed);
+	ib_conn->post_recv_buf_count += count;
+	ib_ret	= ib_post_recv(ib_conn->qp, ib_conn->rx_wr, &rx_wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
-		iser_conn->post_recv_buf_count -= count;
+		ib_conn->post_recv_buf_count -= count;
 	} else
 		iser_conn->rx_desc_head = my_rx_head;
 	return ib_ret;
@@ -1061,12 +1069,12 @@ int iser_post_recvm(struct iser_conn *iser_conn, int count)
  *
  * returns 0 on success, -1 on failure
  */
-int iser_post_send(struct iser_conn *iser_conn, struct iser_tx_desc *tx_desc)
+int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc)
 {
 	int		  ib_ret;
 	struct ib_send_wr send_wr, *send_wr_failed;
 
-	ib_dma_sync_single_for_device(iser_conn->device->ib_device,
+	ib_dma_sync_single_for_device(ib_conn->device->ib_device,
 				      tx_desc->dma_addr, ISER_HEADERS_LEN,
 				      DMA_TO_DEVICE);
 
@@ -1077,24 +1085,27 @@ int iser_post_send(struct iser_conn *iser_conn, struct iser_tx_desc *tx_desc)
 	send_wr.opcode	   = IB_WR_SEND;
 	send_wr.send_flags = IB_SEND_SIGNALED;
 
-	atomic_inc(&iser_conn->post_send_buf_count);
+	atomic_inc(&ib_conn->post_send_buf_count);
 
-	ib_ret = ib_post_send(iser_conn->qp, &send_wr, &send_wr_failed);
+	ib_ret = ib_post_send(ib_conn->qp, &send_wr, &send_wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_send failed, ret:%d\n", ib_ret);
-		atomic_dec(&iser_conn->post_send_buf_count);
+		atomic_dec(&ib_conn->post_send_buf_count);
 	}
 	return ib_ret;
 }
 
 static void iser_handle_comp_error(struct iser_tx_desc *desc,
-				struct iser_conn *iser_conn)
+				   struct ib_conn *ib_conn)
 {
+	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
+						   ib_conn);
+
 	if (desc && desc->type == ISCSI_TX_DATAOUT)
 		kmem_cache_free(ig.desc_cache, desc);
 
-	if (iser_conn->post_recv_buf_count == 0 &&
-	    atomic_read(&iser_conn->post_send_buf_count) == 0) {
+	if (ib_conn->post_recv_buf_count == 0 &&
+	    atomic_read(&ib_conn->post_send_buf_count) == 0) {
 		/**
 		 * getting here when the state is UP means that the conn is
 		 * being terminated asynchronously from the iSCSI layer's
@@ -1116,15 +1127,15 @@ static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
 	struct ib_cq  *cq = device->tx_cq[cq_index];
 	struct ib_wc  wc;
 	struct iser_tx_desc *tx_desc;
-	struct iser_conn *iser_conn;
+	struct ib_conn *ib_conn;
 	int completed_tx = 0;
 
 	while (ib_poll_cq(cq, 1, &wc) == 1) {
 		tx_desc	= (struct iser_tx_desc *) (unsigned long) wc.wr_id;
-		iser_conn = wc.qp->qp_context;
+		ib_conn = wc.qp->qp_context;
 		if (wc.status == IB_WC_SUCCESS) {
 			if (wc.opcode == IB_WC_SEND)
-				iser_snd_completion(tx_desc, iser_conn);
+				iser_snd_completion(tx_desc, ib_conn);
 			else
 				iser_err("expected opcode %d got %d\n",
 					IB_WC_SEND, wc.opcode);
@@ -1132,8 +1143,8 @@ static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
 			iser_err("tx id %llx status %d vend_err %x\n",
 				 wc.wr_id, wc.status, wc.vendor_err);
 			if (wc.wr_id != ISER_FASTREG_LI_WRID) {
-				atomic_dec(&iser_conn->post_send_buf_count);
-				iser_handle_comp_error(tx_desc, iser_conn);
+				atomic_dec(&ib_conn->post_send_buf_count);
+				iser_handle_comp_error(tx_desc, ib_conn);
 			}
 		}
 		completed_tx++;
@@ -1151,7 +1162,7 @@ static void iser_cq_tasklet_fn(unsigned long data)
 	 struct ib_wc	     wc;
 	 struct iser_rx_desc *desc;
 	 unsigned long	     xfer_len;
-	struct iser_conn *iser_conn;
+	struct ib_conn *ib_conn;
 	int completed_tx, completed_rx = 0;
 
 	/* First do tx drain, so in a case where we have rx flushes and a successful
@@ -1162,11 +1173,11 @@ static void iser_cq_tasklet_fn(unsigned long data)
 	while (ib_poll_cq(cq, 1, &wc) == 1) {
 		desc	 = (struct iser_rx_desc *) (unsigned long) wc.wr_id;
 		BUG_ON(desc == NULL);
-		iser_conn = wc.qp->qp_context;
+		ib_conn = wc.qp->qp_context;
 		if (wc.status == IB_WC_SUCCESS) {
 			if (wc.opcode == IB_WC_RECV) {
 				xfer_len = (unsigned long)wc.byte_len;
-				iser_rcv_completion(desc, xfer_len, iser_conn);
+				iser_rcv_completion(desc, xfer_len, ib_conn);
 			} else
 				iser_err("expected opcode %d got %d\n",
 					IB_WC_RECV, wc.opcode);
@@ -1174,8 +1185,8 @@ static void iser_cq_tasklet_fn(unsigned long data)
 			if (wc.status != IB_WC_WR_FLUSH_ERR)
 				iser_err("rx id %llx status %d vend_err %x\n",
 					wc.wr_id, wc.status, wc.vendor_err);
-			iser_conn->post_recv_buf_count--;
-			iser_handle_comp_error(NULL, iser_conn);
+			ib_conn->post_recv_buf_count--;
+			iser_handle_comp_error(NULL, ib_conn);
 		}
 		completed_rx++;
 		if (!(completed_rx & 63))
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

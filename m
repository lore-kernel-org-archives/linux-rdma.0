From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 3/3] IB/iser: Accept session->cmds_max from user space
Date: Mon,  8 Jul 2013 17:26:16 +0300
Message-ID: <1373293576-24916-4-git-send-email-ogerlitz@mellanox.com>
References: <1373293576-24916-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373293576-24916-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Use cmds_max passed from user space to be the number of PDUs to be
supported for the session instead of hard-coded ISCSI_DEF_XMIT_CMDS_MAX.
Specifically, this allows to control the max number of SCSI commands
for the seesion. Also don't ignore the qdepth passed from user space.

Derive from session->cmds_max the actual number of RX buffers
and FMR pool size to allocate during the connection bind phase.

Since the iser transport connection is established before the iscsi
session/connection are created and bounded, we still use one hard coded
quantity ISER_DEF_XMIT_CMDS_MAX to compute the maximum number of
work-requests to be supported by the RC QP used for the connection.

The above quantity is made to be a power of two between ISCSI_TOTAL_CMDS_MIN
(16) and ISER_DEF_XMIT_CMDS_MAX (512) inclusive.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   19 ++++++++++++-------
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   21 +++++++++++++++------
 drivers/infiniband/ulp/iser/iser_initiator.c |   25 +++++++++++++++----------
 drivers/infiniband/ulp/iser/iser_verbs.c     |    8 ++++----
 4 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 2e84ef8..705de7b 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -347,6 +347,7 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_iser_conn *iser_conn;
+	struct iscsi_session *session;
 	struct iser_conn *ib_conn;
 	struct iscsi_endpoint *ep;
 	int error;
@@ -365,7 +366,8 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	}
 	ib_conn = ep->dd_data;
 
-	if (iser_alloc_rx_descriptors(ib_conn))
+	session = conn->session;
+	if (iser_alloc_rx_descriptors(ib_conn, session))
 		return -ENOMEM;
 
 	/* binds the iSER connection retrieved from the previously
@@ -419,12 +421,13 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct Scsi_Host *shost;
-	struct iser_conn *ib_conn;
+	struct iser_conn *ib_conn = NULL;
 
 	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 0);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_iser_scsi_transport;
+	shost->cmd_per_lun = qdepth;
 	shost->max_lun = iscsi_max_lun;
 	shost->max_id = 0;
 	shost->max_channel = 0;
@@ -441,12 +444,14 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			   ep ? ib_conn->device->ib_device->dma_device : NULL))
 		goto free_host;
 
-	/*
-	 * we do not support setting can_queue cmd_per_lun from userspace yet
-	 * because we preallocate so many resources
-	 */
+	if (cmds_max > ISER_DEF_XMIT_CMDS_MAX) {
+		iser_info("cmds_max changed from %u to %u\n",
+			  cmds_max, ISER_DEF_XMIT_CMDS_MAX);
+		cmds_max = ISER_DEF_XMIT_CMDS_MAX;
+	}
+
 	cls_session = iscsi_session_setup(&iscsi_iser_transport, shost,
-					  ISCSI_DEF_XMIT_CMDS_MAX, 0,
+					  cmds_max, 0,
 					  sizeof(struct iscsi_iser_task),
 					  initial_cmdsn, 0);
 	if (!cls_session)
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index fee8829..d2fc55a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -102,7 +102,13 @@
 
 					/* support up to 512KB in one RDMA */
 #define ISCSI_ISER_SG_TABLESIZE         (0x80000 >> SHIFT_4K)
-#define ISER_DEF_CMD_PER_LUN		ISCSI_DEF_XMIT_CMDS_MAX
+#define ISER_DEF_XMIT_CMDS_DEFAULT		512
+#if ISCSI_DEF_XMIT_CMDS_MAX > ISER_DEF_XMIT_CMDS_DEFAULT
+	#define ISER_DEF_XMIT_CMDS_MAX		ISCSI_DEF_XMIT_CMDS_MAX
+#else
+	#define ISER_DEF_XMIT_CMDS_MAX		ISER_DEF_XMIT_CMDS_DEFAULT
+#endif
+#define ISER_DEF_CMD_PER_LUN		ISER_DEF_XMIT_CMDS_MAX
 
 /* QP settings */
 /* Maximal bounds on received asynchronous PDUs */
@@ -111,9 +117,9 @@
 #define ISER_MAX_TX_MISC_PDUS		6 /* NOOP_OUT(2), TEXT(1),         *
 					   * SCSI_TMFUNC(2), LOGOUT(1) */
 
-#define ISER_QP_MAX_RECV_DTOS		(ISCSI_DEF_XMIT_CMDS_MAX)
+#define ISER_QP_MAX_RECV_DTOS		(ISER_DEF_XMIT_CMDS_MAX)
 
-#define ISER_MIN_POSTED_RX		(ISCSI_DEF_XMIT_CMDS_MAX >> 2)
+#define ISER_MIN_POSTED_RX		(ISER_DEF_XMIT_CMDS_MAX >> 2)
 
 /* the max TX (send) WR supported by the iSER QP is defined by                 *
  * max_send_wr = T * (1 + D) + C ; D is how many inflight dataouts we expect   *
@@ -123,7 +129,7 @@
 
 #define ISER_INFLIGHT_DATAOUTS		8
 
-#define ISER_QP_MAX_REQ_DTOS		(ISCSI_DEF_XMIT_CMDS_MAX *    \
+#define ISER_QP_MAX_REQ_DTOS		(ISER_DEF_XMIT_CMDS_MAX *    \
 					(1 + ISER_INFLIGHT_DATAOUTS) + \
 					ISER_MAX_TX_MISC_PDUS        + \
 					ISER_MAX_RX_MISC_PDUS)
@@ -272,6 +278,9 @@ struct iser_conn {
 	struct ib_qp	             *qp;           /* QP 		       */
 	struct ib_fmr_pool           *fmr_pool;     /* pool of IB FMRs         */
 	wait_queue_head_t	     wait;          /* waitq for conn/disconn  */
+	unsigned		     qp_max_recv_dtos; /* num of rx buffers */
+	unsigned		     qp_max_recv_dtos_mask; /* above minus 1 */
+	unsigned		     min_posted_rx; /* qp_max_recv_dtos >> 2 */
 	int                          post_recv_buf_count; /* posted rx count  */
 	atomic_t                     post_send_buf_count; /* posted tx count   */
 	char 			     name[ISER_OBJECT_NAME_SIZE];
@@ -394,7 +403,7 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task);
 int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
-int iser_alloc_rx_descriptors(struct iser_conn *ib_conn);
-int iser_create_fmr_pool(struct iser_conn *ib_conn);
+int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *session);
+int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max);
 void iser_free_fmr_pool(struct iser_conn *ib_conn);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 626d950..5c2b142 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -241,7 +241,7 @@ out_err:
 	return -ENOMEM;
 }
 
-int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
+int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *session)
 {
 	int i, j;
 	u64 dma_addr;
@@ -249,20 +249,24 @@ int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
 	struct ib_sge       *rx_sg;
 	struct iser_device  *device = ib_conn->device;
 
-	if (iser_create_fmr_pool(ib_conn))
+	ib_conn->qp_max_recv_dtos = session->cmds_max;
+	ib_conn->qp_max_recv_dtos_mask = session->cmds_max - 1; /* cmds_max is 2^N */
+	ib_conn->min_posted_rx = ib_conn->qp_max_recv_dtos >> 2;
+
+	if (iser_create_fmr_pool(ib_conn, session->scsi_cmds_max))
 		goto create_fmr_pool_failed;
 
 	if (iser_alloc_login_buf(ib_conn))
 		goto alloc_login_buf_fail;
 
-	ib_conn->rx_descs = kmalloc(ISER_QP_MAX_RECV_DTOS *
+	ib_conn->rx_descs = kmalloc(session->cmds_max *
 				sizeof(struct iser_rx_desc), GFP_KERNEL);
 	if (!ib_conn->rx_descs)
 		goto rx_desc_alloc_fail;
 
 	rx_desc = ib_conn->rx_descs;
 
-	for (i = 0; i < ISER_QP_MAX_RECV_DTOS; i++, rx_desc++)  {
+	for (i = 0; i < ib_conn->qp_max_recv_dtos; i++, rx_desc++)  {
 		dma_addr = ib_dma_map_single(device->ib_device, (void *)rx_desc,
 					ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 		if (ib_dma_mapping_error(device->ib_device, dma_addr))
@@ -305,7 +309,7 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn)
 		goto free_login_buf;
 
 	rx_desc = ib_conn->rx_descs;
-	for (i = 0; i < ISER_QP_MAX_RECV_DTOS; i++, rx_desc++)
+	for (i = 0; i < ib_conn->qp_max_recv_dtos; i++, rx_desc++)
 		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
 				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 	kfree(ib_conn->rx_descs);
@@ -334,9 +338,10 @@ static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 	WARN_ON(iser_conn->ib_conn->post_recv_buf_count != 1);
 	WARN_ON(atomic_read(&iser_conn->ib_conn->post_send_buf_count) != 0);
 
-	iser_dbg("Initially post: %d\n", ISER_MIN_POSTED_RX);
+	iser_dbg("Initially post: %d\n", iser_conn->ib_conn->min_posted_rx);
 	/* Initial post receive buffers */
-	if (iser_post_recvm(iser_conn->ib_conn, ISER_MIN_POSTED_RX))
+	if (iser_post_recvm(iser_conn->ib_conn,
+			    iser_conn->ib_conn->min_posted_rx))
 		return -ENOMEM;
 
 	return 0;
@@ -573,9 +578,9 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 		return;
 
 	outstanding = ib_conn->post_recv_buf_count;
-	if (outstanding + ISER_MIN_POSTED_RX <= ISER_QP_MAX_RECV_DTOS) {
-		count = min(ISER_QP_MAX_RECV_DTOS - outstanding,
-						ISER_MIN_POSTED_RX);
+	if (outstanding + ib_conn->min_posted_rx <= ib_conn->qp_max_recv_dtos) {
+		count = min(ib_conn->qp_max_recv_dtos - outstanding,
+						ib_conn->min_posted_rx);
 		err = iser_post_recvm(ib_conn, count);
 		if (err)
 			iser_err("posting %d rx bufs err %d\n", count, err);
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index b72e349..5e49a36 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -182,7 +182,7 @@ static void iser_free_device_ib_res(struct iser_device *device)
  *
  * returns 0 on success, or errno code on failure
  */
-int iser_create_fmr_pool(struct iser_conn *ib_conn)
+int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 {
 	struct iser_device *device = ib_conn->device;
 	struct ib_fmr_pool_param params;
@@ -202,8 +202,8 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn)
 	params.max_pages_per_fmr = ISCSI_ISER_SG_TABLESIZE + 1;
 	/* make the pool size twice the max number of SCSI commands *
 	 * the ML is expected to queue, watermark for unmap at 50%  */
-	params.pool_size	 = ISCSI_DEF_XMIT_CMDS_MAX * 2;
-	params.dirty_watermark	 = ISCSI_DEF_XMIT_CMDS_MAX;
+	params.pool_size	 = cmds_max * 2;
+	params.dirty_watermark	 = cmds_max;
 	params.cache		 = 0;
 	params.flush_function	 = NULL;
 	params.access		 = (IB_ACCESS_LOCAL_WRITE  |
@@ -771,7 +771,7 @@ int iser_post_recvm(struct iser_conn *ib_conn, int count)
 		rx_wr->sg_list	= &rx_desc->rx_sg;
 		rx_wr->num_sge	= 1;
 		rx_wr->next	= rx_wr + 1;
-		my_rx_head = (my_rx_head + 1) & (ISER_QP_MAX_RECV_DTOS - 1);
+		my_rx_head = (my_rx_head + 1) & ib_conn->qp_max_recv_dtos_mask;
 	}
 
 	rx_wr--;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/9] ib/iser: new recv buffer posting logic
Date: Wed, 3 Feb 2010 17:33:20 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002031732030.11944@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002031721280.11944-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, the recv buffer posting logic is based on the transactional
nature of iser which allows for posting a buffer before sending a PDU.
Change this to post only when the number of outstanding recv buffers is
below a water mark and in a batched manner, thus simplifying and
optimizing the data path. Use a pre-allocated ring of recv buffers
instead of allocating from kmem cache. A special treatment is given
to the login response buffer whose size must be 8K unlike the size
of buffers used for any other purpose which is 128 bytes.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    2
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   40 +++-
 drivers/infiniband/ulp/iser/iser_initiator.c |  235 +++++++++++++--------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |  134 +++++++++------
 4 files changed, 235 insertions(+), 176 deletions(-)

Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.h
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -102,9 +102,9 @@
 #define ISER_MAX_TX_MISC_PDUS		6 /* NOOP_OUT(2), TEXT(1),         *
 					   * SCSI_TMFUNC(2), LOGOUT(1) */

-#define ISER_QP_MAX_RECV_DTOS		(ISCSI_DEF_XMIT_CMDS_MAX + \
-					ISER_MAX_RX_MISC_PDUS    +  \
-					ISER_MAX_TX_MISC_PDUS)
+#define ISER_QP_MAX_RECV_DTOS		(ISCSI_DEF_XMIT_CMDS_MAX)
+
+#define ISER_MIN_POSTED_RX		(ISCSI_DEF_XMIT_CMDS_MAX >> 2)

 /* the max TX (send) WR supported by the iSER QP is defined by                 *
  * max_send_wr = T * (1 + D) + C ; D is how many inflight dataouts we expect   *
@@ -132,6 +132,12 @@ struct iser_hdr {
 	__be64  read_va;
 } __attribute__((packed));

+/* Constant PDU lengths calculations */
+#define ISER_HEADERS_LEN  (sizeof(struct iser_hdr) + sizeof(struct iscsi_hdr))
+
+#define ISER_RECV_DATA_SEG_LEN	128
+#define ISER_RX_PAYLOAD_SIZE	(ISER_HEADERS_LEN + ISER_RECV_DATA_SEG_LEN)
+#define ISER_RX_LOGIN_SIZE	(ISER_HEADERS_LEN + ISCSI_DEF_MAX_RECV_SEG_LEN)

 /* Length of an object name string */
 #define ISER_OBJECT_NAME_SIZE		    64
@@ -212,7 +218,6 @@ struct iser_dto {
 };

 enum iser_desc_type {
-	ISCSI_RX,
 	ISCSI_TX_CONTROL ,
 	ISCSI_TX_SCSI_COMMAND,
 	ISCSI_TX_DATAOUT
@@ -228,6 +233,17 @@ struct iser_desc {
 	struct iser_dto              dto;
 };

+#define ISER_RX_PAD_SIZE	(256 - (ISER_RX_PAYLOAD_SIZE + \
+					sizeof(u64) + sizeof(struct ib_sge)))
+struct iser_rx_desc {
+	struct iser_hdr              iser_header;
+	struct iscsi_hdr             iscsi_header;
+	char		             data[ISER_RECV_DATA_SEG_LEN];
+	u64		             dma_addr;
+	struct ib_sge		     rx_sg;
+	char		             pad[ISER_RX_PAD_SIZE];
+} __attribute__((packed));
+
 struct iser_device {
 	struct ib_device             *ib_device;
 	struct ib_pd	             *pd;
@@ -256,6 +272,12 @@ struct iser_conn {
 	struct iser_page_vec         *page_vec;     /* represents SG to fmr maps*
 						     * maps serialized as tx is*/
 	struct list_head	     conn_list;       /* entry in ig conn list */
+
+	char  			     *login_buf;
+	u64 			     login_dma;
+	unsigned int 		     rx_desc_head;
+	struct iser_rx_desc	     *rx_descs;
+	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
 };

 struct iscsi_iser_conn {
@@ -319,8 +341,9 @@ void iser_conn_put(struct iser_conn *ib_

 void iser_conn_terminate(struct iser_conn *ib_conn);

-void iser_rcv_completion(struct iser_desc *desc,
-			 unsigned long    dto_xfer_len);
+void iser_rcv_completion(struct iser_rx_desc *desc,
+			 unsigned long    dto_xfer_len,
+			struct iser_conn *ib_conn);

 void iser_snd_completion(struct iser_desc *desc);

@@ -332,6 +355,8 @@ void iser_dto_buffs_release(struct iser_

 int  iser_regd_buff_release(struct iser_regd_buf *regd_buf);

+void iser_free_rx_descriptors(struct iser_conn *ib_conn);
+
 void iser_reg_single(struct iser_device      *device,
 		     struct iser_regd_buf    *regd_buf,
 		     enum dma_data_direction direction);
@@ -353,7 +378,8 @@ int  iser_reg_page_vec(struct iser_conn

 void iser_unreg_mem(struct iser_mem_reg *mem_reg);

-int  iser_post_recv(struct iser_desc *rx_desc);
+int  iser_post_recvl(struct iser_conn *ib_conn);
+int  iser_post_recvm(struct iser_conn *ib_conn, int count);
 int  iser_post_send(struct iser_desc *tx_desc);

 int iser_conn_state_comp(struct iser_conn *ib_conn,
Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_initiator.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -39,9 +39,6 @@

 #include "iscsi_iser.h"

-/* Constant PDU lengths calculations */
-#define ISER_TOTAL_HEADERS_LEN  (sizeof (struct iser_hdr) + \
-				 sizeof (struct iscsi_hdr))

 /* iser_dto_add_regd_buff - increments the reference count for *
  * the registered buffer & adds it to the DTO object           */
@@ -172,78 +169,6 @@ iser_prepare_write_cmd(struct iscsi_task
 	return 0;
 }

-/**
- * iser_post_receive_control - allocates, initializes and posts receive DTO.
- */
-static int iser_post_receive_control(struct iscsi_conn *conn)
-{
-	struct iscsi_iser_conn *iser_conn = conn->dd_data;
-	struct iser_desc     *rx_desc;
-	struct iser_regd_buf *regd_hdr;
-	struct iser_regd_buf *regd_data;
-	struct iser_dto      *recv_dto = NULL;
-	struct iser_device  *device = iser_conn->ib_conn->device;
-	int rx_data_size, err = 0;
-
-	rx_desc = kmem_cache_alloc(ig.desc_cache, GFP_NOIO);
-	if (rx_desc == NULL) {
-		iser_err("Failed to alloc desc for post recv\n");
-		return -ENOMEM;
-	}
-	rx_desc->type = ISCSI_RX;
-
-	/* for the login sequence we must support rx of upto 8K; login is done
-	 * after conn create/bind (connect) and conn stop/bind (reconnect),
-	 * what's common for both schemes is that the connection is not started
-	 */
-	if (conn->c_stage != ISCSI_CONN_STARTED)
-		rx_data_size = ISCSI_DEF_MAX_RECV_SEG_LEN;
-	else /* FIXME till user space sets conn->max_recv_dlength correctly */
-		rx_data_size = 128;
-
-	rx_desc->data = kmalloc(rx_data_size, GFP_NOIO);
-	if (rx_desc->data == NULL) {
-		iser_err("Failed to alloc data buf for post recv\n");
-		err = -ENOMEM;
-		goto post_rx_kmalloc_failure;
-	}
-
-	recv_dto = &rx_desc->dto;
-	recv_dto->ib_conn = iser_conn->ib_conn;
-	recv_dto->regd_vector_len = 0;
-
-	regd_hdr = &rx_desc->hdr_regd_buf;
-	memset(regd_hdr, 0, sizeof(struct iser_regd_buf));
-	regd_hdr->device  = device;
-	regd_hdr->virt_addr  = rx_desc; /* == &rx_desc->iser_header */
-	regd_hdr->data_size  = ISER_TOTAL_HEADERS_LEN;
-
-	iser_reg_single(device, regd_hdr, DMA_FROM_DEVICE);
-
-	iser_dto_add_regd_buff(recv_dto, regd_hdr, 0, 0);
-
-	regd_data = &rx_desc->data_regd_buf;
-	memset(regd_data, 0, sizeof(struct iser_regd_buf));
-	regd_data->device  = device;
-	regd_data->virt_addr  = rx_desc->data;
-	regd_data->data_size  = rx_data_size;
-
-	iser_reg_single(device, regd_data, DMA_FROM_DEVICE);
-
-	iser_dto_add_regd_buff(recv_dto, regd_data, 0, 0);
-
-	err = iser_post_recv(rx_desc);
-	if (!err)
-		return 0;
-
-	/* iser_post_recv failed */
-	iser_dto_buffs_release(recv_dto);
-	kfree(rx_desc->data);
-post_rx_kmalloc_failure:
-	kmem_cache_free(ig.desc_cache, rx_desc);
-	return err;
-}
-
 /* creates a new tx descriptor and adds header regd buffer */
 static void iser_create_send_desc(struct iscsi_iser_conn *iser_conn,
 				  struct iser_desc       *tx_desc)
@@ -254,7 +179,7 @@ static void iser_create_send_desc(struct
 	memset(regd_hdr, 0, sizeof(struct iser_regd_buf));
 	regd_hdr->device  = iser_conn->ib_conn->device;
 	regd_hdr->virt_addr  = tx_desc; /* == &tx_desc->iser_header */
-	regd_hdr->data_size  = ISER_TOTAL_HEADERS_LEN;
+	regd_hdr->data_size  = ISER_HEADERS_LEN;

 	send_dto->ib_conn         = iser_conn->ib_conn;
 	send_dto->notify_enable   = 1;
@@ -266,6 +191,72 @@ static void iser_create_send_desc(struct
 	iser_dto_add_regd_buff(send_dto, regd_hdr, 0, 0);
 }

+int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
+{
+	int i, j;
+	u64 dma_addr;
+	struct iser_rx_desc *rx_desc;
+	struct ib_sge       *rx_sg;
+	struct iser_device  *device = ib_conn->device;
+
+	ib_conn->rx_descs = kmalloc(ISER_QP_MAX_RECV_DTOS *
+				sizeof(struct iser_rx_desc), GFP_KERNEL);
+	if (!ib_conn->rx_descs)
+		goto rx_desc_alloc_fail;
+
+	rx_desc = ib_conn->rx_descs;
+
+	for (i = 0; i < ISER_QP_MAX_RECV_DTOS; i++, rx_desc++)  {
+		dma_addr = ib_dma_map_single(device->ib_device, (void *)rx_desc,
+					ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+		if (ib_dma_mapping_error(device->ib_device, dma_addr))
+			goto rx_desc_dma_map_failed;
+
+		rx_desc->dma_addr = dma_addr;
+
+		rx_sg = &rx_desc->rx_sg;
+		rx_sg->addr   = rx_desc->dma_addr;
+		rx_sg->length = ISER_RX_PAYLOAD_SIZE;
+		rx_sg->lkey   = device->mr->lkey;
+	}
+
+	ib_conn->rx_desc_head = 0;
+	return 0;
+
+rx_desc_dma_map_failed:
+	rx_desc = ib_conn->rx_descs;
+	for (j = 0; j < i; j++, rx_desc++)
+		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
+			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+	kfree(ib_conn->rx_descs);
+	ib_conn->rx_descs = NULL;
+rx_desc_alloc_fail:
+	iser_err("failed allocating rx descriptors / data buffers\n");
+	return -ENOMEM;
+}
+
+void iser_free_rx_descriptors(struct iser_conn *ib_conn)
+{
+	int i;
+	struct iser_rx_desc *rx_desc;
+	struct iser_device *device = ib_conn->device;
+
+	if (ib_conn->login_buf) {
+		ib_dma_unmap_single(device->ib_device, ib_conn->login_dma,
+			ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+		kfree(ib_conn->login_buf);
+	}
+
+	if (!ib_conn->rx_descs)
+		return;
+
+	rx_desc = ib_conn->rx_descs;
+	for (i = 0; i < ISER_QP_MAX_RECV_DTOS; i++, rx_desc++)
+		ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
+			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+	kfree(ib_conn->rx_descs);
+}
+
 /**
  *  iser_conn_set_full_featured_mode - (iSER API)
  */
@@ -273,27 +264,20 @@ int iser_conn_set_full_featured_mode(str
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;

-	int i;
-	/* no need to keep it in a var, we are after login so if this should
-	 * be negotiated, by now the result should be available here */
-	int initial_post_recv_bufs_num = ISER_MAX_RX_MISC_PDUS;
-
-	iser_dbg("Initially post: %d\n", initial_post_recv_bufs_num);
+	iser_dbg("Initially post: %d\n", ISER_MIN_POSTED_RX);

 	/* Check that there is no posted recv or send buffers left - */
 	/* they must be consumed during the login phase */
 	BUG_ON(atomic_read(&iser_conn->ib_conn->post_recv_buf_count) != 0);
 	BUG_ON(atomic_read(&iser_conn->ib_conn->post_send_buf_count) != 0);

+	if (iser_alloc_rx_descriptors(iser_conn->ib_conn))
+		return -ENOMEM;
+
 	/* Initial post receive buffers */
-	for (i = 0; i < initial_post_recv_bufs_num; i++) {
-		if (iser_post_receive_control(conn) != 0) {
-			iser_err("Failed to post recv bufs at:%d conn:0x%p\n",
-				 i, conn);
-			return -ENOMEM;
-		}
-	}
-	iser_dbg("Posted %d post recv bufs, conn:0x%p\n", i, conn);
+	if (iser_post_recvm(iser_conn->ib_conn, ISER_MIN_POSTED_RX))
+		return -ENOMEM;
+
 	return 0;
 }

@@ -321,7 +305,7 @@ int iser_send_command(struct iscsi_conn
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_dto *send_dto = NULL;
 	unsigned long edtl;
-	int err = 0;
+	int err;
 	struct iser_data_buf *data_buf;
 	struct iscsi_cmd *hdr =  (struct iscsi_cmd *)task->hdr;
 	struct scsi_cmnd *sc  =  task->sc;
@@ -371,12 +355,6 @@ int iser_send_command(struct iscsi_conn
 	iser_reg_single(iser_conn->ib_conn->device,
 			send_dto->regd[0], DMA_TO_DEVICE);

-	if (iser_post_receive_control(conn) != 0) {
-		iser_err("post_recv failed!\n");
-		err = -ENOMEM;
-		goto send_command_error;
-	}
-
 	iser_task->status = ISER_TASK_STATUS_STARTED;

 	err = iser_post_send(&iser_task->desc);
@@ -474,7 +452,7 @@ int iser_send_control(struct iscsi_conn
 	struct iser_desc *mdesc = &iser_task->desc;
 	struct iser_dto *send_dto = NULL;
 	unsigned long data_seg_len;
-	int err = 0;
+	int err;
 	struct iser_regd_buf *regd_buf;
 	struct iser_device *device;

@@ -511,10 +489,10 @@ int iser_send_control(struct iscsi_conn
 				       data_seg_len);
 	}

-	if (iser_post_receive_control(conn) != 0) {
-		iser_err("post_rcv_buff failed!\n");
-		err = -ENOMEM;
-		goto send_control_error;
+	if (task == conn->login_task) {
+		err = iser_post_recvl(iser_conn->ib_conn);
+		if (err)
+			goto send_control_error;
 	}

 	err = iser_post_send(mdesc);
@@ -530,27 +508,34 @@ send_control_error:
 /**
  * iser_rcv_dto_completion - recv DTO completion
  */
-void iser_rcv_completion(struct iser_desc *rx_desc,
-			 unsigned long dto_xfer_len)
+void iser_rcv_completion(struct iser_rx_desc *rx_desc,
+			 unsigned long rx_xfer_len,
+			 struct iser_conn *ib_conn)
 {
-	struct iser_dto *dto = &rx_desc->dto;
-	struct iscsi_iser_conn *conn = dto->ib_conn->iser_conn;
+	struct iscsi_iser_conn *conn = ib_conn->iser_conn;
 	struct iscsi_task *task;
 	struct iscsi_iser_task *iser_task;
 	struct iscsi_hdr *hdr;
-	char   *rx_data = NULL;
-	int     rx_data_len = 0;
 	unsigned char opcode;
+	u64 rx_dma;
+	int rx_buflen, outstanding, count, err;

-	hdr = &rx_desc->iscsi_header;
+	/* differentiate between login to all other PDUs */
+	if ((char *)rx_desc == ib_conn->login_buf) {
+		rx_dma = ib_conn->login_dma;
+		rx_buflen = ISER_RX_LOGIN_SIZE;
+	} else {
+		rx_dma = rx_desc->dma_addr;
+		rx_buflen = ISER_RX_PAYLOAD_SIZE;
+	}

-	iser_dbg("op 0x%x itt 0x%x\n", hdr->opcode,hdr->itt);
+	ib_dma_sync_single_for_cpu(ib_conn->device->ib_device, rx_dma,
+			rx_buflen, DMA_FROM_DEVICE);

-	if (dto_xfer_len > ISER_TOTAL_HEADERS_LEN) { /* we have data */
-		rx_data_len = dto_xfer_len - ISER_TOTAL_HEADERS_LEN;
-		rx_data     = dto->regd[1]->virt_addr;
-		rx_data    += dto->offset[1];
-	}
+	hdr = &rx_desc->iscsi_header;
+
+	iser_dbg("op 0x%x itt 0x%x dlen %d\n", hdr->opcode,
+			hdr->itt, (int)(rx_xfer_len - ISER_HEADERS_LEN));

 	opcode = hdr->opcode & ISCSI_OPCODE_MASK;

@@ -573,18 +558,30 @@ void iser_rcv_completion(struct iser_des
 			iscsi_put_task(task);
 		}
 	}
-	iser_dto_buffs_release(dto);

-	iscsi_iser_recv(conn->iscsi_conn, hdr, rx_data, rx_data_len);
+	iscsi_iser_recv(conn->iscsi_conn, hdr,
+		rx_desc->data, rx_xfer_len - ISER_HEADERS_LEN);

-	kfree(rx_desc->data);
-	kmem_cache_free(ig.desc_cache, rx_desc);
+	ib_dma_sync_single_for_device(ib_conn->device->ib_device, rx_dma,
+			rx_buflen, DMA_FROM_DEVICE);

 	/* decrementing conn->post_recv_buf_count only --after-- freeing the   *
 	 * task eliminates the need to worry on tasks which are completed in   *
 	 * parallel to the execution of iser_conn_term. So the code that waits *
 	 * for the posted rx bufs refcount to become zero handles everything   */
 	atomic_dec(&conn->ib_conn->post_recv_buf_count);
+
+	if (rx_dma == ib_conn->login_dma)
+		return;
+
+	outstanding = atomic_read(&ib_conn->post_recv_buf_count);
+	if (outstanding + ISER_MIN_POSTED_RX <= ISER_QP_MAX_RECV_DTOS) {
+		count = min(ISER_QP_MAX_RECV_DTOS - outstanding,
+						ISER_MIN_POSTED_RX);
+		err = iser_post_recvm(ib_conn, count);
+		if (err)
+			iser_err("posting %d rx bufs err %d\n", count, err);
+	}
 }

 void iser_snd_completion(struct iser_desc *tx_desc)
Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -129,13 +129,23 @@ static int iser_create_ib_conn_res(struc
 {
 	struct iser_device	*device;
 	struct ib_qp_init_attr	init_attr;
-	int			ret;
+	int			ret = -ENOMEM;
 	struct ib_fmr_pool_param params;

 	BUG_ON(ib_conn->device == NULL);

 	device = ib_conn->device;

+	ib_conn->login_buf = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
+	if (!ib_conn->login_buf) {
+		goto alloc_err;
+		ret = -ENOMEM;
+	}
+
+	ib_conn->login_dma = ib_dma_map_single(ib_conn->device->ib_device,
+				(void *)ib_conn->login_buf, ISER_RX_LOGIN_SIZE,
+				DMA_FROM_DEVICE);
+
 	ib_conn->page_vec = kmalloc(sizeof(struct iser_page_vec) +
 				    (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE +1)),
 				    GFP_KERNEL);
@@ -174,7 +184,7 @@ static int iser_create_ib_conn_res(struc
 	init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS;
 	init_attr.cap.max_recv_wr  = ISER_QP_MAX_RECV_DTOS;
 	init_attr.cap.max_send_sge = MAX_REGD_BUF_VECTOR_LEN;
-	init_attr.cap.max_recv_sge = 2;
+	init_attr.cap.max_recv_sge = 1;
 	init_attr.sq_sig_type	= IB_SIGNAL_REQ_WR;
 	init_attr.qp_type	= IB_QPT_RC;

@@ -192,6 +202,7 @@ qp_err:
 	(void)ib_destroy_fmr_pool(ib_conn->fmr_pool);
 fmr_pool_err:
 	kfree(ib_conn->page_vec);
+	kfree(ib_conn->login_buf);
 alloc_err:
 	iser_err("unable to alloc mem or create resource, err %d\n", ret);
 	return ret;
@@ -314,7 +325,7 @@ static void iser_conn_release(struct ise
 	mutex_lock(&ig.connlist_mutex);
 	list_del(&ib_conn->conn_list);
 	mutex_unlock(&ig.connlist_mutex);
-
+	iser_free_rx_descriptors(ib_conn);
 	iser_free_ib_conn_res(ib_conn);
 	ib_conn->device = NULL;
 	/* on EVENT_ADDR_ERROR there's no device yet for this conn */
@@ -625,6 +636,60 @@ void iser_unreg_mem(struct iser_mem_reg
 	reg->mem_h = NULL;
 }

+int iser_post_recvl(struct iser_conn *ib_conn)
+{
+	struct ib_recv_wr rx_wr, *rx_wr_failed;
+	struct ib_sge	  sge;
+	int ib_ret;
+
+	sge.addr   = ib_conn->login_dma;
+	sge.length = ISER_RX_LOGIN_SIZE;
+	sge.lkey   = ib_conn->device->mr->lkey;
+
+	rx_wr.wr_id   = (unsigned long)ib_conn->login_buf;
+	rx_wr.sg_list = &sge;
+	rx_wr.num_sge = 1;
+	rx_wr.next    = NULL;
+
+	atomic_inc(&ib_conn->post_recv_buf_count);
+	ib_ret	= ib_post_recv(ib_conn->qp, &rx_wr, &rx_wr_failed);
+	if (ib_ret) {
+		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
+		atomic_dec(&ib_conn->post_recv_buf_count);
+	}
+	return ib_ret;
+}
+
+int iser_post_recvm(struct iser_conn *ib_conn, int count)
+{
+	struct ib_recv_wr *rx_wr, *rx_wr_failed;
+	int i, ib_ret;
+	unsigned int my_rx_head = ib_conn->rx_desc_head;
+	struct iser_rx_desc *rx_desc;
+
+	for (rx_wr = ib_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
+		rx_desc		= &ib_conn->rx_descs[my_rx_head];
+		rx_wr->wr_id	= (unsigned long)rx_desc;
+		rx_wr->sg_list	= &rx_desc->rx_sg;
+		rx_wr->num_sge	= 1;
+		rx_wr->next	= rx_wr + 1;
+		my_rx_head = (my_rx_head + 1) & (ISER_QP_MAX_RECV_DTOS - 1);
+	}
+
+	rx_wr--;
+	rx_wr->next = NULL; /* mark end of work requests list */
+
+	atomic_add(count, &ib_conn->post_recv_buf_count);
+	ib_ret	= ib_post_recv(ib_conn->qp, ib_conn->rx_wr, &rx_wr_failed);
+	if (ib_ret) {
+		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
+		atomic_sub(count, &ib_conn->post_recv_buf_count);
+	} else
+		ib_conn->rx_desc_head = my_rx_head;
+	return ib_ret;
+}
+
+
 /**
  * iser_dto_to_iov - builds IOV from a dto descriptor
  */
@@ -665,39 +730,6 @@ static void iser_dto_to_iov(struct iser_
 	}
 }

-/**
- * iser_post_recv - Posts a receive buffer.
- *
- * returns 0 on success, -1 on failure
- */
-int iser_post_recv(struct iser_desc *rx_desc)
-{
-	int		  ib_ret, ret_val = 0;
-	struct ib_recv_wr recv_wr, *recv_wr_failed;
-	struct ib_sge	  iov[2];
-	struct iser_conn  *ib_conn;
-	struct iser_dto   *recv_dto = &rx_desc->dto;
-
-	/* Retrieve conn */
-	ib_conn = recv_dto->ib_conn;
-
-	iser_dto_to_iov(recv_dto, iov, 2);
-
-	recv_wr.next	= NULL;
-	recv_wr.sg_list = iov;
-	recv_wr.num_sge = recv_dto->regd_vector_len;
-	recv_wr.wr_id	= (unsigned long)rx_desc;
-
-	atomic_inc(&ib_conn->post_recv_buf_count);
-	ib_ret	= ib_post_recv(ib_conn->qp, &recv_wr, &recv_wr_failed);
-	if (ib_ret) {
-		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
-		atomic_dec(&ib_conn->post_recv_buf_count);
-		ret_val = -1;
-	}
-
-	return ret_val;
-}

 /**
  * iser_start_send - Initiate a Send DTO operation
@@ -737,18 +769,17 @@ int iser_post_send(struct iser_desc *tx_
 	return ret_val;
 }

-static void iser_handle_comp_error(struct iser_desc *desc)
+static void iser_handle_comp_error(struct iser_desc *desc,
+				struct iser_conn *ib_conn)
 {
-	struct iser_dto  *dto     = &desc->dto;
-	struct iser_conn *ib_conn = dto->ib_conn;
+	struct iser_rx_desc *rx       = (struct iser_rx_desc *)desc;
+	struct iser_rx_desc *rx_first = ib_conn->rx_descs;
+	struct iser_rx_desc *rx_last  = rx_first + (ISER_QP_MAX_RECV_DTOS - 1);

-	iser_dto_buffs_release(dto);
-
-	if (desc->type == ISCSI_RX) {
-		kfree(desc->data);
-		kmem_cache_free(ig.desc_cache, desc);
+	if ((char *)desc == ib_conn->login_buf ||
+			(rx_first <= rx && rx <= rx_last))
 		atomic_dec(&ib_conn->post_recv_buf_count);
-	} else { /* type is TX control/command/dataout */
+	 else { /* type is TX control/command/dataout */
 		if (desc->type == ISCSI_TX_DATAOUT)
 			kmem_cache_free(ig.desc_cache, desc);
 		atomic_dec(&ib_conn->post_send_buf_count);
@@ -780,20 +811,25 @@ static void iser_cq_tasklet_fn(unsigned
 	 struct ib_wc	     wc;
 	 struct iser_desc    *desc;
 	 unsigned long	     xfer_len;
+	struct iser_conn *ib_conn;

 	while (ib_poll_cq(cq, 1, &wc) == 1) {
 		desc	 = (struct iser_desc *) (unsigned long) wc.wr_id;
 		BUG_ON(desc == NULL);
+		ib_conn = wc.qp->qp_context;

 		if (wc.status == IB_WC_SUCCESS) {
-			if (desc->type == ISCSI_RX) {
+			if (wc.opcode == IB_WC_RECV) {
 				xfer_len = (unsigned long)wc.byte_len;
-				iser_rcv_completion(desc, xfer_len);
+				iser_rcv_completion((struct iser_rx_desc *)desc,
+							xfer_len, ib_conn);
 			} else /* type == ISCSI_TX_CONTROL/SCSI_CMD/DOUT */
 				iser_snd_completion(desc);
 		} else {
-			iser_err("comp w. error op %d status %d\n",desc->type,wc.status);
-			iser_handle_comp_error(desc);
+			if (wc.status != IB_WC_WR_FLUSH_ERR)
+				iser_err("id %llx status %d vend_err %x\n",
+					wc.wr_id, wc.status, wc.vendor_err);
+			iser_handle_comp_error(desc, ib_conn);
 		}
 	}
 	/* #warning "it is assumed here that arming CQ only once its empty" *
Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -283,7 +283,7 @@ iscsi_iser_conn_create(struct iscsi_cls_
 	 * due to issues with the login code re iser sematics
 	 * this not set in iscsi_conn_setup - FIXME
 	 */
-	conn->max_recv_dlength = 128;
+	conn->max_recv_dlength = ISER_RECV_DATA_SEG_LEN;

 	iser_conn = conn->dd_data;
 	conn->dd_data = iser_conn;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

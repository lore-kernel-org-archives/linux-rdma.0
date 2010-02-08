From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 05/9] ib/iser: simplify send flow/descriptors
Date: Mon, 8 Feb 2010 15:19:56 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002081519290.16288@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002081509400.16288@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002081509400.16288-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Simplify and shrink the logic/code used for the send descriptors.
Changes include removal of struct iser_dto which is unnecessary
abstraction, use struct iser_regd_buf only for handling SCSI commands,
use dma_sync instead of dma_map/unmap, etc.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---

changes from V1:

- remove white spaces that slipped in

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   34 ++++-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   48 +------
 drivers/infiniband/ulp/iser/iser_initiator.c |  178 +++++++++------------------
 drivers/infiniband/ulp/iser/iser_memory.c    |   60 ---------
 drivers/infiniband/ulp/iser/iser_verbs.c     |   75 +----------
 5 files changed, 116 insertions(+), 279 deletions(-)

Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -39,26 +39,6 @@

 #include "iscsi_iser.h"

-
-/* iser_dto_add_regd_buff - increments the reference count for *
- * the registered buffer & adds it to the DTO object           */
-static void iser_dto_add_regd_buff(struct iser_dto *dto,
-				   struct iser_regd_buf *regd_buf,
-				   unsigned long use_offset,
-				   unsigned long use_size)
-{
-	int add_idx;
-
-	atomic_inc(&regd_buf->ref_count);
-
-	add_idx = dto->regd_vector_len;
-	dto->regd[add_idx] = regd_buf;
-	dto->used_sz[add_idx] = use_size;
-	dto->offset[add_idx] = use_offset;
-
-	dto->regd_vector_len++;
-}
-
 /* Register user buffer memory and initialize passive rdma
  *  dto descriptor. Total data size is stored in
  *  iser_task->data[ISER_DIR_IN].data_len
@@ -119,9 +99,9 @@ iser_prepare_write_cmd(struct iscsi_task
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_regd_buf *regd_buf;
 	int err;
-	struct iser_dto *send_dto = &iser_task->desc.dto;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
 	struct iser_data_buf *buf_out = &iser_task->data[ISER_DIR_OUT];
+	struct ib_sge *tx_dsg = &iser_task->desc.tx_sg[1];

 	err = iser_dma_map_task_data(iser_task,
 				     buf_out,
@@ -160,37 +140,36 @@ iser_prepare_write_cmd(struct iscsi_task
 	if (imm_sz > 0) {
 		iser_dbg("Cmd itt:%d, WRITE, adding imm.data sz: %d\n",
 			 task->itt, imm_sz);
-		iser_dto_add_regd_buff(send_dto,
-				       regd_buf,
-				       0,
-				       imm_sz);
+		tx_dsg->addr   = regd_buf->reg.va;
+		tx_dsg->length = imm_sz;
+		tx_dsg->lkey   = regd_buf->reg.lkey;
+		iser_task->desc.num_sge = 2;
 	}

 	return 0;
 }

 /* creates a new tx descriptor and adds header regd buffer */
-static void iser_create_send_desc(struct iscsi_iser_conn *iser_conn,
-				  struct iser_desc       *tx_desc)
+static void iser_create_send_desc(struct iser_conn	*ib_conn,
+				  struct iser_tx_desc	*tx_desc)
 {
-	struct iser_regd_buf *regd_hdr = &tx_desc->hdr_regd_buf;
-	struct iser_dto      *send_dto = &tx_desc->dto;
+	struct iser_device *device = ib_conn->device;

-	memset(regd_hdr, 0, sizeof(struct iser_regd_buf));
-	regd_hdr->device  = iser_conn->ib_conn->device;
-	regd_hdr->virt_addr  = tx_desc; /* == &tx_desc->iser_header */
-	regd_hdr->data_size  = ISER_HEADERS_LEN;
-
-	send_dto->ib_conn         = iser_conn->ib_conn;
-	send_dto->notify_enable   = 1;
-	send_dto->regd_vector_len = 0;
+	ib_dma_sync_single_for_cpu(device->ib_device,
+		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);

 	memset(&tx_desc->iser_header, 0, sizeof(struct iser_hdr));
 	tx_desc->iser_header.flags = ISER_VER;

-	iser_dto_add_regd_buff(send_dto, regd_hdr, 0, 0);
+	tx_desc->num_sge = 1;
+
+	if (tx_desc->tx_sg[0].lkey != device->mr->lkey) {
+		tx_desc->tx_sg[0].lkey = device->mr->lkey;
+		iser_dbg("sdesc %p lkey mismatch, fixing\n", tx_desc);
+	}
 }

+
 int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
 {
 	int i, j;
@@ -303,12 +282,12 @@ int iser_send_command(struct iscsi_conn
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_dto *send_dto = NULL;
 	unsigned long edtl;
 	int err;
 	struct iser_data_buf *data_buf;
 	struct iscsi_cmd *hdr =  (struct iscsi_cmd *)task->hdr;
 	struct scsi_cmnd *sc  =  task->sc;
+	struct iser_tx_desc *tx_desc = &iser_task->desc;

 	if (!iser_conn_state_comp(iser_conn->ib_conn, ISER_CONN_UP)) {
 		iser_err("Failed to send, conn: 0x%p is not up\n", iser_conn->ib_conn);
@@ -320,10 +299,8 @@ int iser_send_command(struct iscsi_conn
 	edtl = ntohl(hdr->data_length);

 	/* build the tx desc regd header and add it to the tx desc dto */
-	iser_task->desc.type = ISCSI_TX_SCSI_COMMAND;
-	send_dto = &iser_task->desc.dto;
-	send_dto->task = iser_task;
-	iser_create_send_desc(iser_conn, &iser_task->desc);
+	tx_desc->type = ISCSI_TX_SCSI_COMMAND;
+	iser_create_send_desc(iser_conn->ib_conn, tx_desc);

 	if (hdr->flags & ISCSI_FLAG_CMD_READ)
 		data_buf = &iser_task->data[ISER_DIR_IN];
@@ -352,17 +329,13 @@ int iser_send_command(struct iscsi_conn
 			goto send_command_error;
 	}

-	iser_reg_single(iser_conn->ib_conn->device,
-			send_dto->regd[0], DMA_TO_DEVICE);
-
 	iser_task->status = ISER_TASK_STATUS_STARTED;

-	err = iser_post_send(&iser_task->desc);
+	err = iser_post_send(iser_conn->ib_conn, tx_desc);
 	if (!err)
 		return 0;

 send_command_error:
-	iser_dto_buffs_release(send_dto);
 	iser_err("conn %p failed task->itt %d err %d\n",conn, task->itt, err);
 	return err;
 }
@@ -376,12 +349,14 @@ int iser_send_data_out(struct iscsi_conn
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_desc *tx_desc = NULL;
-	struct iser_dto *send_dto = NULL;
+	struct iser_tx_desc *tx_desc = NULL;
+	struct iser_regd_buf *regd_buf;
 	unsigned long buf_offset;
 	unsigned long data_seg_len;
 	uint32_t itt;
 	int err = 0;
+	struct ib_sge *tx_dsg;
+

 	if (!iser_conn_state_comp(iser_conn->ib_conn, ISER_CONN_UP)) {
 		iser_err("Failed to send, conn: 0x%p is not up\n", iser_conn->ib_conn);
@@ -398,28 +373,25 @@ int iser_send_data_out(struct iscsi_conn
 	iser_dbg("%s itt %d dseg_len %d offset %d\n",
 		 __func__,(int)itt,(int)data_seg_len,(int)buf_offset);

-	tx_desc = kmem_cache_alloc(ig.desc_cache, GFP_NOIO);
+	tx_desc = kmem_cache_zalloc(ig.desc_cache, GFP_NOIO);
 	if (tx_desc == NULL) {
 		iser_err("Failed to alloc desc for post dataout\n");
 		return -ENOMEM;
 	}

 	tx_desc->type = ISCSI_TX_DATAOUT;
+	tx_desc->iser_header.flags = ISER_VER;
 	memcpy(&tx_desc->iscsi_header, hdr, sizeof(struct iscsi_hdr));

-	/* build the tx desc regd header and add it to the tx desc dto */
-	send_dto = &tx_desc->dto;
-	send_dto->task = iser_task;
-	iser_create_send_desc(iser_conn, tx_desc);
-
-	iser_reg_single(iser_conn->ib_conn->device,
-			send_dto->regd[0], DMA_TO_DEVICE);
-
-	/* all data was registered for RDMA, we can use the lkey */
-	iser_dto_add_regd_buff(send_dto,
-			       &iser_task->rdma_regd[ISER_DIR_OUT],
-			       buf_offset,
-			       data_seg_len);
+	/* build the tx desc */
+	iser_initialize_task_headers(task, tx_desc);
+
+	regd_buf = &iser_task->rdma_regd[ISER_DIR_OUT];
+	tx_dsg = &tx_desc->tx_sg[1];
+	tx_dsg->addr    = regd_buf->reg.va + buf_offset;
+	tx_dsg->length  = data_seg_len;
+	tx_dsg->lkey    = regd_buf->reg.lkey;
+	tx_desc->num_sge = 2;

 	if (buf_offset + data_seg_len > iser_task->data[ISER_DIR_OUT].data_len) {
 		iser_err("Offset:%ld & DSL:%ld in Data-Out "
@@ -433,12 +405,11 @@ int iser_send_data_out(struct iscsi_conn
 		 itt, buf_offset, data_seg_len);


-	err = iser_post_send(tx_desc);
+	err = iser_post_send(iser_conn->ib_conn, tx_desc);
 	if (!err)
 		return 0;

 send_data_out_error:
-	iser_dto_buffs_release(send_dto);
 	kmem_cache_free(ig.desc_cache, tx_desc);
 	iser_err("conn %p failed err %d\n",conn, err);
 	return err;
@@ -449,11 +420,9 @@ int iser_send_control(struct iscsi_conn
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_desc *mdesc = &iser_task->desc;
-	struct iser_dto *send_dto = NULL;
+	struct iser_tx_desc *mdesc = &iser_task->desc;
 	unsigned long data_seg_len;
-	int err;
-	struct iser_regd_buf *regd_buf;
+	int err = 0;
 	struct iser_device *device;

 	if (!iser_conn_state_comp(iser_conn->ib_conn, ISER_CONN_UP)) {
@@ -466,27 +435,24 @@ int iser_send_control(struct iscsi_conn

 	/* build the tx desc regd header and add it to the tx desc dto */
 	mdesc->type = ISCSI_TX_CONTROL;
-	send_dto = &mdesc->dto;
-	send_dto->task = NULL;
-	iser_create_send_desc(iser_conn, mdesc);
+	iser_create_send_desc(iser_conn->ib_conn, mdesc);

 	device = iser_conn->ib_conn->device;

-	iser_reg_single(device, send_dto->regd[0], DMA_TO_DEVICE);
-
 	data_seg_len = ntoh24(task->hdr->dlength);

 	if (data_seg_len > 0) {
-		regd_buf = &mdesc->data_regd_buf;
-		memset(regd_buf, 0, sizeof(struct iser_regd_buf));
-		regd_buf->device = device;
-		regd_buf->virt_addr = task->data;
-		regd_buf->data_size = task->data_count;
-		iser_reg_single(device, regd_buf,
-				DMA_TO_DEVICE);
-		iser_dto_add_regd_buff(send_dto, regd_buf,
-				       0,
-				       data_seg_len);
+		struct ib_sge *tx_dsg = &mdesc->tx_sg[1];
+		if (task != conn->login_task) {
+			iser_err("data present on non login task!!!\n");
+			goto send_control_error;
+		}
+		memcpy(iser_conn->ib_conn->login_buf, task->data,
+							task->data_count);
+		tx_dsg->addr    = iser_conn->ib_conn->login_dma;
+		tx_dsg->length  = data_seg_len;
+		tx_dsg->lkey    = device->mr->lkey;
+		mdesc->num_sge = 2;
 	}

 	if (task == conn->login_task) {
@@ -495,12 +461,11 @@ int iser_send_control(struct iscsi_conn
 			goto send_control_error;
 	}

-	err = iser_post_send(mdesc);
+	err = iser_post_send(iser_conn->ib_conn, mdesc);
 	if (!err)
 		return 0;

 send_control_error:
-	iser_dto_buffs_release(send_dto);
 	iser_err("conn %p failed err %d\n",conn, err);
 	return err;
 }
@@ -584,21 +549,20 @@ void iser_rcv_completion(struct iser_rx_
 	}
 }

-void iser_snd_completion(struct iser_desc *tx_desc)
+void iser_snd_completion(struct iser_tx_desc *tx_desc,
+			struct iser_conn *ib_conn)
 {
-	struct iser_dto        *dto = &tx_desc->dto;
-	struct iser_conn       *ib_conn = dto->ib_conn;
 	struct iscsi_iser_conn *iser_conn = ib_conn->iser_conn;
 	struct iscsi_conn      *conn = iser_conn->iscsi_conn;
 	struct iscsi_task *task;
 	int resume_tx = 0;
+	struct iser_device *device = ib_conn->device;

-	iser_dbg("Initiator, Data sent dto=0x%p\n", dto);
-
-	iser_dto_buffs_release(dto);
-
-	if (tx_desc->type == ISCSI_TX_DATAOUT)
+	if (tx_desc->type == ISCSI_TX_DATAOUT) {
+		ib_dma_unmap_single(device->ib_device, tx_desc->dma_addr,
+					ISER_HEADERS_LEN, DMA_TO_DEVICE);
 		kmem_cache_free(ig.desc_cache, tx_desc);
+	}

 	if (atomic_read(&iser_conn->ib_conn->post_send_buf_count) ==
 	    ISER_QP_MAX_REQ_DTOS)
@@ -639,7 +603,6 @@ void iser_task_rdma_init(struct iscsi_is

 void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 {
-	int deferred;
 	int is_rdma_aligned = 1;
 	struct iser_regd_buf *regd;

@@ -657,32 +620,17 @@ void iser_task_rdma_finalize(struct iscs

 	if (iser_task->dir[ISER_DIR_IN]) {
 		regd = &iser_task->rdma_regd[ISER_DIR_IN];
-		deferred = iser_regd_buff_release(regd);
-		if (deferred) {
-			iser_err("%d references remain for BUF-IN rdma reg\n",
-				 atomic_read(&regd->ref_count));
-		}
+		if (regd->reg.is_fmr)
+			iser_unreg_mem(&regd->reg);
 	}

 	if (iser_task->dir[ISER_DIR_OUT]) {
 		regd = &iser_task->rdma_regd[ISER_DIR_OUT];
-		deferred = iser_regd_buff_release(regd);
-		if (deferred) {
-			iser_err("%d references remain for BUF-OUT rdma reg\n",
-				 atomic_read(&regd->ref_count));
-		}
+		if (regd->reg.is_fmr)
+			iser_unreg_mem(&regd->reg);
 	}

        /* if the data was unaligned, it was already unmapped and then copied */
        if (is_rdma_aligned)
 		iser_dma_unmap_task_data(iser_task);
 }
-
-void iser_dto_buffs_release(struct iser_dto *dto)
-{
-	int i;
-
-	for (i = 0; i < dto->regd_vector_len; i++)
-		iser_regd_buff_release(dto->regd[i]);
-}
-
Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iscsi_iser.h
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -193,28 +193,8 @@ struct iser_regd_buf {
 	struct iser_mem_reg     reg;        /* memory registration info        */
 	void                    *virt_addr;
 	struct iser_device      *device;    /* device->device for dma_unmap    */
-	u64                     dma_addr;   /* if non zero, addr for dma_unmap */
 	enum dma_data_direction direction;  /* direction for dma_unmap	       */
 	unsigned int            data_size;
-	atomic_t                ref_count;  /* refcount, freed when dec to 0   */
-};
-
-#define MAX_REGD_BUF_VECTOR_LEN	2
-
-struct iser_dto {
-	struct iscsi_iser_task *task;
-	struct iser_conn *ib_conn;
-	int                        notify_enable;
-
-	/* vector of registered buffers */
-	unsigned int               regd_vector_len;
-	struct iser_regd_buf       *regd[MAX_REGD_BUF_VECTOR_LEN];
-
-	/* offset into the registered buffer may be specified */
-	unsigned int               offset[MAX_REGD_BUF_VECTOR_LEN];
-
-	/* a smaller size may be specified, if 0, then full size is used */
-	unsigned int               used_sz[MAX_REGD_BUF_VECTOR_LEN];
 };

 enum iser_desc_type {
@@ -223,14 +203,15 @@ enum iser_desc_type {
 	ISCSI_TX_DATAOUT
 };

-struct iser_desc {
+struct iser_tx_desc {
 	struct iser_hdr              iser_header;
 	struct iscsi_hdr             iscsi_header;
-	struct iser_regd_buf         hdr_regd_buf;
-	void                         *data;         /* used by RX & TX_CONTROL */
-	struct iser_regd_buf         data_regd_buf; /* used by RX & TX_CONTROL */
 	enum   iser_desc_type        type;
-	struct iser_dto              dto;
+	u64		             dma_addr;
+	/* sg[0] points to iser/iscsi headers, sg[1] optionally points to either
+	of immediate data, unsolicited data-out or control (login,text) */
+	struct ib_sge		     tx_sg[2];
+	int                          num_sge;
 };

 #define ISER_RX_PAD_SIZE	(256 - (ISER_RX_PAYLOAD_SIZE + \
@@ -287,7 +268,7 @@ struct iscsi_iser_conn {
 };

 struct iscsi_iser_task {
-	struct iser_desc             desc;
+	struct iser_tx_desc          desc;
 	struct iscsi_iser_conn	     *iser_conn;
 	enum iser_task_status 	     status;
 	int                          command_sent;  /* set if command  sent  */
@@ -295,6 +276,7 @@ struct iscsi_iser_task {
 	struct iser_regd_buf         rdma_regd[ISER_DIRS_NUM];/* regd rdma buf */
 	struct iser_data_buf         data[ISER_DIRS_NUM];     /* orig. data des*/
 	struct iser_data_buf         data_copy[ISER_DIRS_NUM];/* contig. copy  */
+	int                          headers_initialized;
 };

 struct iser_page_vec {
@@ -346,22 +328,14 @@ void iser_rcv_completion(struct iser_rx_
 			 unsigned long    dto_xfer_len,
 			struct iser_conn *ib_conn);

-void iser_snd_completion(struct iser_desc *desc);
+void iser_snd_completion(struct iser_tx_desc *desc, struct iser_conn *ib_conn);

 void iser_task_rdma_init(struct iscsi_iser_task *task);

 void iser_task_rdma_finalize(struct iscsi_iser_task *task);

-void iser_dto_buffs_release(struct iser_dto *dto);
-
-int  iser_regd_buff_release(struct iser_regd_buf *regd_buf);
-
 void iser_free_rx_descriptors(struct iser_conn *ib_conn);

-void iser_reg_single(struct iser_device      *device,
-		     struct iser_regd_buf    *regd_buf,
-		     enum dma_data_direction direction);
-
 void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *task,
 				     enum iser_data_dir         cmd_dir);

@@ -381,7 +355,7 @@ void iser_unreg_mem(struct iser_mem_reg

 int  iser_post_recvl(struct iser_conn *ib_conn);
 int  iser_post_recvm(struct iser_conn *ib_conn, int count);
-int  iser_post_send(struct iser_desc *tx_desc);
+int  iser_post_send(struct iser_conn *ib_conn, struct iser_tx_desc *tx_desc);

 int iser_conn_state_comp(struct iser_conn *ib_conn,
 			 enum iser_ib_conn_state comp);
@@ -392,4 +366,6 @@ int iser_dma_map_task_data(struct iscsi_
 			    enum   dma_data_direction  dma_dir);

 void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task);
+int  iser_initialize_task_headers(struct iscsi_task *task,
+			struct iser_tx_desc *tx_desc);
 #endif
Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iscsi_iser.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -128,6 +128,28 @@ static int iscsi_iser_pdu_alloc(struct i
 	return 0;
 }

+int iser_initialize_task_headers(struct iscsi_task *task,
+						struct iser_tx_desc *tx_desc)
+{
+	struct iscsi_iser_conn *iser_conn = task->conn->dd_data;
+	struct iser_device     *device    = iser_conn->ib_conn->device;
+	struct iscsi_iser_task *iser_task = task->dd_data;
+	u64 dma_addr;
+
+	dma_addr = ib_dma_map_single(device->ib_device, (void *)tx_desc,
+				ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	if (ib_dma_mapping_error(device->ib_device, dma_addr))
+		return -ENOMEM;
+
+	tx_desc->dma_addr = dma_addr;
+	tx_desc->tx_sg[0].addr   = tx_desc->dma_addr;
+	tx_desc->tx_sg[0].length = ISER_HEADERS_LEN;
+	tx_desc->tx_sg[0].lkey   = device->mr->lkey;
+
+	iser_task->headers_initialized	= 1;
+	iser_task->iser_conn		= iser_conn;
+	return 0;
+}
 /**
  * iscsi_iser_task_init - Initialize task
  * @task: iscsi task
@@ -137,17 +159,17 @@ static int iscsi_iser_pdu_alloc(struct i
 static int
 iscsi_iser_task_init(struct iscsi_task *task)
 {
-	struct iscsi_iser_conn *iser_conn  = task->conn->dd_data;
 	struct iscsi_iser_task *iser_task = task->dd_data;

+	if (!iser_task->headers_initialized)
+		if (iser_initialize_task_headers(task, &iser_task->desc))
+			return -ENOMEM;
+
 	/* mgmt task */
-	if (!task->sc) {
-		iser_task->desc.data = task->data;
+	if (!task->sc)
 		return 0;
-	}

 	iser_task->command_sent = 0;
-	iser_task->iser_conn    = iser_conn;
 	iser_task_rdma_init(iser_task);
 	return 0;
 }
@@ -675,7 +697,7 @@ static int __init iser_init(void)
 	memset(&ig, 0, sizeof(struct iser_global));

 	ig.desc_cache = kmem_cache_create("iser_descriptors",
-					  sizeof (struct iser_desc),
+					  sizeof(struct iser_tx_desc),
 					  0, SLAB_HWCACHE_ALIGN,
 					  NULL);
 	if (ig.desc_cache == NULL)
Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -194,7 +194,7 @@ static int iser_create_ib_conn_res(struc
 	init_attr.recv_cq	= device->rx_cq;
 	init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS;
 	init_attr.cap.max_recv_wr  = ISER_QP_MAX_RECV_DTOS;
-	init_attr.cap.max_send_sge = MAX_REGD_BUF_VECTOR_LEN;
+	init_attr.cap.max_send_sge = 2;
 	init_attr.cap.max_recv_sge = 1;
 	init_attr.sq_sig_type	= IB_SIGNAL_REQ_WR;
 	init_attr.qp_type	= IB_QPT_RC;
@@ -702,85 +702,36 @@ int iser_post_recvm(struct iser_conn *ib


 /**
- * iser_dto_to_iov - builds IOV from a dto descriptor
- */
-static void iser_dto_to_iov(struct iser_dto *dto, struct ib_sge *iov, int iov_len)
-{
-	int		     i;
-	struct ib_sge	     *sge;
-	struct iser_regd_buf *regd_buf;
-
-	if (dto->regd_vector_len > iov_len) {
-		iser_err("iov size %d too small for posting dto of len %d\n",
-			 iov_len, dto->regd_vector_len);
-		BUG();
-	}
-
-	for (i = 0; i < dto->regd_vector_len; i++) {
-		sge	    = &iov[i];
-		regd_buf  = dto->regd[i];
-
-		sge->addr   = regd_buf->reg.va;
-		sge->length = regd_buf->reg.len;
-		sge->lkey   = regd_buf->reg.lkey;
-
-		if (dto->used_sz[i] > 0)  /* Adjust size */
-			sge->length = dto->used_sz[i];
-
-		/* offset and length should not exceed the regd buf length */
-		if (sge->length + dto->offset[i] > regd_buf->reg.len) {
-			iser_err("Used len:%ld + offset:%d, exceed reg.buf.len:"
-				 "%ld in dto:0x%p [%d], va:0x%08lX\n",
-				 (unsigned long)sge->length, dto->offset[i],
-				 (unsigned long)regd_buf->reg.len, dto, i,
-				 (unsigned long)sge->addr);
-			BUG();
-		}
-
-		sge->addr += dto->offset[i]; /* Adjust offset */
-	}
-}
-
-
-/**
  * iser_start_send - Initiate a Send DTO operation
  *
  * returns 0 on success, -1 on failure
  */
-int iser_post_send(struct iser_desc *tx_desc)
+int iser_post_send(struct iser_conn *ib_conn, struct iser_tx_desc *tx_desc)
 {
-	int		  ib_ret, ret_val = 0;
+	int		  ib_ret;
 	struct ib_send_wr send_wr, *send_wr_failed;
-	struct ib_sge	  iov[MAX_REGD_BUF_VECTOR_LEN];
-	struct iser_conn  *ib_conn;
-	struct iser_dto   *dto = &tx_desc->dto;

-	ib_conn = dto->ib_conn;
-
-	iser_dto_to_iov(dto, iov, MAX_REGD_BUF_VECTOR_LEN);
+	ib_dma_sync_single_for_device(ib_conn->device->ib_device,
+		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);

 	send_wr.next	   = NULL;
 	send_wr.wr_id	   = (unsigned long)tx_desc;
-	send_wr.sg_list	   = iov;
-	send_wr.num_sge	   = dto->regd_vector_len;
+	send_wr.sg_list	   = tx_desc->tx_sg;
+	send_wr.num_sge	   = tx_desc->num_sge;
 	send_wr.opcode	   = IB_WR_SEND;
-	send_wr.send_flags = dto->notify_enable ? IB_SEND_SIGNALED : 0;
+	send_wr.send_flags = IB_SEND_SIGNALED;

 	atomic_inc(&ib_conn->post_send_buf_count);

 	ib_ret = ib_post_send(ib_conn->qp, &send_wr, &send_wr_failed);
 	if (ib_ret) {
-		iser_err("Failed to start SEND DTO, dto: 0x%p, IOV len: %d\n",
-			 dto, dto->regd_vector_len);
 		iser_err("ib_post_send failed, ret:%d\n", ib_ret);
 		atomic_dec(&ib_conn->post_send_buf_count);
-		ret_val = -1;
 	}
-
-	return ret_val;
+	return ib_ret;
 }

-static void iser_handle_comp_error(struct iser_desc *desc,
+static void iser_handle_comp_error(struct iser_tx_desc *desc,
 				struct iser_conn *ib_conn)
 {
 	if (desc && desc->type == ISCSI_TX_DATAOUT)
@@ -809,16 +760,16 @@ static int iser_drain_tx_cq(struct iser_
 {
 	struct ib_cq  *cq = device->tx_cq;
 	struct ib_wc  wc;
-	struct iser_desc *tx_desc;
+	struct iser_tx_desc *tx_desc;
 	struct iser_conn *ib_conn;
 	int completed_tx = 0;

 	while (ib_poll_cq(cq, 1, &wc) == 1) {
-		tx_desc	= (struct iser_desc *) (unsigned long) wc.wr_id;
+		tx_desc	= (struct iser_tx_desc *) (unsigned long) wc.wr_id;
 		ib_conn = wc.qp->qp_context;
 		if (wc.status == IB_WC_SUCCESS) {
 			if (wc.opcode == IB_WC_SEND)
-				iser_snd_completion(tx_desc);
+				iser_snd_completion(tx_desc, ib_conn);
 			else
 				iser_err("expected opcode %d got %d\n",
 					IB_WC_SEND, wc.opcode);
Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_memory.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iser_memory.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_memory.c
@@ -41,62 +41,6 @@
 #define ISER_KMALLOC_THRESHOLD 0x20000 /* 128K - kmalloc limit */

 /**
- * Decrements the reference count for the
- * registered buffer & releases it
- *
- * returns 0 if released, 1 if deferred
- */
-int iser_regd_buff_release(struct iser_regd_buf *regd_buf)
-{
-	struct ib_device *dev;
-
-	if ((atomic_read(&regd_buf->ref_count) == 0) ||
-	    atomic_dec_and_test(&regd_buf->ref_count)) {
-		/* if we used the dma mr, unreg is just NOP */
-		if (regd_buf->reg.is_fmr)
-			iser_unreg_mem(&regd_buf->reg);
-
-		if (regd_buf->dma_addr) {
-			dev = regd_buf->device->ib_device;
-			ib_dma_unmap_single(dev,
-					 regd_buf->dma_addr,
-					 regd_buf->data_size,
-					 regd_buf->direction);
-		}
-		/* else this regd buf is associated with task which we */
-		/* dma_unmap_single/sg later */
-		return 0;
-	} else {
-		iser_dbg("Release deferred, regd.buff: 0x%p\n", regd_buf);
-		return 1;
-	}
-}
-
-/**
- * iser_reg_single - fills registered buffer descriptor with
- *		     registration information
- */
-void iser_reg_single(struct iser_device *device,
-		     struct iser_regd_buf *regd_buf,
-		     enum dma_data_direction direction)
-{
-	u64 dma_addr;
-
-	dma_addr = ib_dma_map_single(device->ib_device,
-				     regd_buf->virt_addr,
-				     regd_buf->data_size, direction);
-	BUG_ON(ib_dma_mapping_error(device->ib_device, dma_addr));
-
-	regd_buf->reg.lkey = device->mr->lkey;
-	regd_buf->reg.len  = regd_buf->data_size;
-	regd_buf->reg.va   = dma_addr;
-	regd_buf->reg.is_fmr = 0;
-
-	regd_buf->dma_addr  = dma_addr;
-	regd_buf->direction = direction;
-}
-
-/**
  * iser_start_rdma_unaligned_sg
  */
 static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
@@ -474,9 +418,5 @@ int iser_reg_rdma_mem(struct iscsi_iser_
 			return err;
 		}
 	}
-
-	/* take a reference on this regd buf such that it will not be released *
-	 * (eg in send dto completion) before we get the scsi response         */
-	atomic_inc(&regd_buf->ref_count);
 	return 0;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

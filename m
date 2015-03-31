From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 09/18] IB/iser: Get rid of struct iser_rdma_regd
Date: Tue, 31 Mar 2015 19:45:49 +0300
Message-ID: <1427820358-15087-10-git-send-email-sagig@mellanox.com>
References: <1427820358-15087-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427820358-15087-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This struct members other than struct iser_mem_reg are unused,
so remove it altogether.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   21 +---------
 drivers/infiniband/ulp/iser/iser_initiator.c |   44 ++++++++++----------
 drivers/infiniband/ulp/iser/iser_memory.c    |   56 +++++++++++++-------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |    2 +-
 4 files changed, 53 insertions(+), 70 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index d5e5288..8133678 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -261,23 +261,6 @@ struct iser_mem_reg {
 	void *mem_h;
 };
 
-/**
- * struct iser_regd_buf - iSER buffer registration desc
- *
- * @reg:          memory registration info
- * @virt_addr:    virtual address of buffer
- * @device:       reference to iser device
- * @direction:    dma direction (for dma_unmap)
- * @data_size:    data buffer size in bytes
- */
-struct iser_regd_buf {
-	struct iser_mem_reg     reg;
-	void                    *virt_addr;
-	struct iser_device      *device;
-	enum dma_data_direction direction;
-	unsigned int            data_size;
-};
-
 enum iser_desc_type {
 	ISCSI_TX_CONTROL ,
 	ISCSI_TX_SCSI_COMMAND,
@@ -537,7 +520,7 @@ struct iser_conn {
  * @sc:               link to scsi command
  * @command_sent:     indicate if command was sent
  * @dir:              iser data direction
- * @rdma_regd:        task rdma registration desc
+ * @rdma_reg:         task rdma registration desc
  * @data:             iser data buffer desc
  * @prot:             iser protection buffer desc
  */
@@ -548,7 +531,7 @@ struct iscsi_iser_task {
 	struct scsi_cmnd	     *sc;
 	int                          command_sent;
 	int                          dir[ISER_DIRS_NUM];
-	struct iser_regd_buf         rdma_regd[ISER_DIRS_NUM];
+	struct iser_mem_reg          rdma_reg[ISER_DIRS_NUM];
 	struct iser_data_buf         data[ISER_DIRS_NUM];
 	struct iser_data_buf         prot[ISER_DIRS_NUM];
 };
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 0e414db..420a613 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -50,7 +50,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_device  *device = iser_task->iser_conn->ib_conn.device;
-	struct iser_regd_buf *regd_buf;
+	struct iser_mem_reg *mem_reg;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
 	struct iser_data_buf *buf_in = &iser_task->data[ISER_DIR_IN];
@@ -78,15 +78,15 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 		iser_err("Failed to set up Data-IN RDMA\n");
 		return err;
 	}
-	regd_buf = &iser_task->rdma_regd[ISER_DIR_IN];
+	mem_reg = &iser_task->rdma_reg[ISER_DIR_IN];
 
 	hdr->flags    |= ISER_RSV;
-	hdr->read_stag = cpu_to_be32(regd_buf->reg.rkey);
-	hdr->read_va   = cpu_to_be64(regd_buf->reg.va);
+	hdr->read_stag = cpu_to_be32(mem_reg->rkey);
+	hdr->read_va   = cpu_to_be64(mem_reg->va);
 
 	iser_dbg("Cmd itt:%d READ tags RKEY:%#.4X VA:%#llX\n",
-		 task->itt, regd_buf->reg.rkey,
-		 (unsigned long long)regd_buf->reg.va);
+		 task->itt, mem_reg->rkey,
+		 (unsigned long long)mem_reg->va);
 
 	return 0;
 }
@@ -104,7 +104,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_device  *device = iser_task->iser_conn->ib_conn.device;
-	struct iser_regd_buf *regd_buf;
+	struct iser_mem_reg *mem_reg;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
 	struct iser_data_buf *buf_out = &iser_task->data[ISER_DIR_OUT];
@@ -134,25 +134,25 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 		return err;
 	}
 
-	regd_buf = &iser_task->rdma_regd[ISER_DIR_OUT];
+	mem_reg = &iser_task->rdma_reg[ISER_DIR_OUT];
 
 	if (unsol_sz < edtl) {
 		hdr->flags     |= ISER_WSV;
-		hdr->write_stag = cpu_to_be32(regd_buf->reg.rkey);
-		hdr->write_va   = cpu_to_be64(regd_buf->reg.va + unsol_sz);
+		hdr->write_stag = cpu_to_be32(mem_reg->rkey);
+		hdr->write_va   = cpu_to_be64(mem_reg->va + unsol_sz);
 
 		iser_dbg("Cmd itt:%d, WRITE tags, RKEY:%#.4X "
 			 "VA:%#llX + unsol:%d\n",
-			 task->itt, regd_buf->reg.rkey,
-			 (unsigned long long)regd_buf->reg.va, unsol_sz);
+			 task->itt, mem_reg->rkey,
+			 (unsigned long long)mem_reg->va, unsol_sz);
 	}
 
 	if (imm_sz > 0) {
 		iser_dbg("Cmd itt:%d, WRITE, adding imm.data sz: %d\n",
 			 task->itt, imm_sz);
-		tx_dsg->addr   = regd_buf->reg.va;
+		tx_dsg->addr   = mem_reg->va;
 		tx_dsg->length = imm_sz;
-		tx_dsg->lkey   = regd_buf->reg.lkey;
+		tx_dsg->lkey   = mem_reg->lkey;
 		iser_task->desc.num_sge = 2;
 	}
 
@@ -450,7 +450,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 	struct iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_tx_desc *tx_desc = NULL;
-	struct iser_regd_buf *regd_buf;
+	struct iser_mem_reg *mem_reg;
 	unsigned long buf_offset;
 	unsigned long data_seg_len;
 	uint32_t itt;
@@ -477,11 +477,11 @@ int iser_send_data_out(struct iscsi_conn *conn,
 	/* build the tx desc */
 	iser_initialize_task_headers(task, tx_desc);
 
-	regd_buf = &iser_task->rdma_regd[ISER_DIR_OUT];
+	mem_reg = &iser_task->rdma_reg[ISER_DIR_OUT];
 	tx_dsg = &tx_desc->tx_sg[1];
-	tx_dsg->addr    = regd_buf->reg.va + buf_offset;
+	tx_dsg->addr    = mem_reg->va + buf_offset;
 	tx_dsg->length  = data_seg_len;
-	tx_dsg->lkey    = regd_buf->reg.lkey;
+	tx_dsg->lkey    = mem_reg->lkey;
 	tx_desc->num_sge = 2;
 
 	if (buf_offset + data_seg_len > iser_task->data[ISER_DIR_OUT].data_len) {
@@ -658,10 +658,10 @@ void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
 	iser_task->prot[ISER_DIR_IN].data_len  = 0;
 	iser_task->prot[ISER_DIR_OUT].data_len = 0;
 
-	memset(&iser_task->rdma_regd[ISER_DIR_IN], 0,
-	       sizeof(struct iser_regd_buf));
-	memset(&iser_task->rdma_regd[ISER_DIR_OUT], 0,
-	       sizeof(struct iser_regd_buf));
+	memset(&iser_task->rdma_reg[ISER_DIR_IN], 0,
+	       sizeof(struct iser_mem_reg));
+	memset(&iser_task->rdma_reg[ISER_DIR_OUT], 0,
+	       sizeof(struct iser_mem_reg));
 }
 
 void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index cb30865..0b8656f 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -414,7 +414,7 @@ int iser_reg_page_vec(struct ib_conn *ib_conn,
 void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 			enum iser_data_dir cmd_dir)
 {
-	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
+	struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
 	int ret;
 
 	if (!reg->mem_h)
@@ -432,7 +432,7 @@ void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 			    enum iser_data_dir cmd_dir)
 {
-	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
+	struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
 	struct iser_conn *iser_conn = iser_task->iser_conn;
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct fast_reg_descriptor *desc = reg->mem_h;
@@ -459,13 +459,13 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	struct iser_device   *device = ib_conn->device;
 	struct ib_device     *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
-	struct iser_regd_buf *regd_buf;
+	struct iser_mem_reg *mem_reg;
 	int aligned_len;
 	int err;
 	int i;
 	struct scatterlist *sg;
 
-	regd_buf = &iser_task->rdma_regd[cmd_dir];
+	mem_reg = &iser_task->rdma_reg[cmd_dir];
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
@@ -481,21 +481,21 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	if (mem->dma_nents == 1) {
 		sg = mem->sg;
 
-		regd_buf->reg.lkey = device->mr->lkey;
-		regd_buf->reg.rkey = device->mr->rkey;
-		regd_buf->reg.len  = ib_sg_dma_len(ibdev, &sg[0]);
-		regd_buf->reg.va   = ib_sg_dma_address(ibdev, &sg[0]);
+		mem_reg->lkey = device->mr->lkey;
+		mem_reg->rkey = device->mr->rkey;
+		mem_reg->len  = ib_sg_dma_len(ibdev, &sg[0]);
+		mem_reg->va   = ib_sg_dma_address(ibdev, &sg[0]);
 
 		iser_dbg("PHYSICAL Mem.register: lkey: 0x%08X rkey: 0x%08X  "
 			 "va: 0x%08lX sz: %ld]\n",
-			 (unsigned int)regd_buf->reg.lkey,
-			 (unsigned int)regd_buf->reg.rkey,
-			 (unsigned long)regd_buf->reg.va,
-			 (unsigned long)regd_buf->reg.len);
+			 (unsigned int)mem_reg->lkey,
+			 (unsigned int)mem_reg->rkey,
+			 (unsigned long)mem_reg->va,
+			 (unsigned long)mem_reg->len);
 	} else { /* use FMR for multiple dma entries */
 		iser_page_vec_build(mem, ib_conn->fmr.page_vec, ibdev);
 		err = iser_reg_page_vec(ib_conn, ib_conn->fmr.page_vec,
-					&regd_buf->reg);
+					mem_reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
 			iser_err("mem->dma_nents = %d (dlength = 0x%x)\n",
@@ -652,12 +652,12 @@ err:
 }
 
 static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
-			    struct iser_regd_buf *regd_buf,
+			    struct iser_mem_reg *mem_reg,
 			    struct iser_data_buf *mem,
 			    enum iser_reg_indicator ind,
 			    struct ib_sge *sge)
 {
-	struct fast_reg_descriptor *desc = regd_buf->reg.mem_h;
+	struct fast_reg_descriptor *desc = mem_reg->mem_h;
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
 	struct ib_device *ibdev = device->ib_device;
@@ -746,7 +746,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 	struct iser_device *device = ib_conn->device;
 	struct ib_device *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
-	struct iser_regd_buf *regd_buf = &iser_task->rdma_regd[cmd_dir];
+	struct iser_mem_reg *mem_reg = &iser_task->rdma_reg[cmd_dir];
 	struct fast_reg_descriptor *desc = NULL;
 	struct ib_sge data_sge;
 	int err, aligned_len;
@@ -769,10 +769,10 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 					struct fast_reg_descriptor, list);
 		list_del(&desc->list);
 		spin_unlock_irqrestore(&ib_conn->lock, flags);
-		regd_buf->reg.mem_h = desc;
+		mem_reg->mem_h = desc;
 	}
 
-	err = iser_fast_reg_mr(iser_task, regd_buf, mem,
+	err = iser_fast_reg_mr(iser_task, mem_reg, mem,
 			       ISER_DATA_KEY_VALID, &data_sge);
 	if (err)
 		goto err_reg;
@@ -793,7 +793,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 				}
 			}
 
-			err = iser_fast_reg_mr(iser_task, regd_buf, mem,
+			err = iser_fast_reg_mr(iser_task, mem_reg, mem,
 					       ISER_PROT_KEY_VALID, &prot_sge);
 			if (err)
 				goto err_reg;
@@ -807,19 +807,19 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 		}
 		desc->reg_indicators |= ISER_FASTREG_PROTECTED;
 
-		regd_buf->reg.lkey = sig_sge.lkey;
-		regd_buf->reg.rkey = desc->pi_ctx->sig_mr->rkey;
-		regd_buf->reg.va = sig_sge.addr;
-		regd_buf->reg.len = sig_sge.length;
+		mem_reg->lkey = sig_sge.lkey;
+		mem_reg->rkey = desc->pi_ctx->sig_mr->rkey;
+		mem_reg->va = sig_sge.addr;
+		mem_reg->len = sig_sge.length;
 	} else {
 		if (desc)
-			regd_buf->reg.rkey = desc->data_mr->rkey;
+			mem_reg->rkey = desc->data_mr->rkey;
 		else
-			regd_buf->reg.rkey = device->mr->rkey;
+			mem_reg->rkey = device->mr->rkey;
 
-		regd_buf->reg.lkey = data_sge.lkey;
-		regd_buf->reg.va = data_sge.addr;
-		regd_buf->reg.len = data_sge.length;
+		mem_reg->lkey = data_sge.lkey;
+		mem_reg->va = data_sge.addr;
+		mem_reg->len = data_sge.length;
 	}
 
 	return 0;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 986b5f4..20eec09 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1220,7 +1220,7 @@ static void iser_cq_callback(struct ib_cq *cq, void *cq_context)
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector)
 {
-	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
+	struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
 	struct fast_reg_descriptor *desc = reg->mem_h;
 	unsigned long sector_size = iser_task->sc->device->sector_size;
 	struct ib_mr_status mr_status;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

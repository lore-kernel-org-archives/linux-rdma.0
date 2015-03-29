From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 05/18] IB/iser: Remove a redundant struct iser_data_buf
Date: Sun, 29 Mar 2015 15:45:19 +0300
Message-ID: <1427633132-23910-6-git-send-email-sagig@mellanox.com>
References: <1427633132-23910-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633132-23910-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No need to keep two iser_data_buf structures just in case we use
mem copy. We can avoid that just by adding a pointer to the original
sg. So keep only two iser_data_buf per command (data and protection)
and pass the relevant data_buf to bounce buffer routine.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   12 ++---
 drivers/infiniband/ulp/iser/iser_initiator.c |   16 +++----
 drivers/infiniband/ulp/iser/iser_memory.c    |   58 ++++++++++---------------
 3 files changed, 34 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index b47aea1..5c7036c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -218,20 +218,23 @@ enum iser_data_dir {
 /**
  * struct iser_data_buf - iSER data buffer
  *
- * @buf:          pointer to the sg list
+ * @sg:           pointer to the sg list
  * @size:         num entries of this sg
  * @data_len:     total beffer byte len
  * @dma_nents:    returned by dma_map_sg
  * @copy_buf:     allocated copy buf for SGs unaligned
  *                for rdma which are copied
+ * @orig_sg:      pointer to the original sg list (in case
+ *                we used a copy)
  * @sg_single:    SG-ified clone of a non SG SC or
  *                unaligned SG
  */
 struct iser_data_buf {
-	void               *buf;
+	struct scatterlist *sg;
 	unsigned int       size;
 	unsigned long      data_len;
 	unsigned int       dma_nents;
+	struct scatterlist *orig_sg;
 	char               *copy_buf;
 	struct scatterlist sg_single;
   };
@@ -536,9 +539,7 @@ struct iser_conn {
  * @dir:              iser data direction
  * @rdma_regd:        task rdma registration desc
  * @data:             iser data buffer desc
- * @data_copy:        iser data copy buffer desc (bounce buffer)
  * @prot:             iser protection buffer desc
- * @prot_copy:        iser protection copy buffer desc (bounce buffer)
  */
 struct iscsi_iser_task {
 	struct iser_tx_desc          desc;
@@ -549,9 +550,7 @@ struct iscsi_iser_task {
 	int                          dir[ISER_DIRS_NUM];
 	struct iser_regd_buf         rdma_regd[ISER_DIRS_NUM];
 	struct iser_data_buf         data[ISER_DIRS_NUM];
-	struct iser_data_buf         data_copy[ISER_DIRS_NUM];
 	struct iser_data_buf         prot[ISER_DIRS_NUM];
-	struct iser_data_buf         prot_copy[ISER_DIRS_NUM];
 };
 
 struct iser_page_vec {
@@ -621,7 +620,6 @@ void iser_free_rx_descriptors(struct iser_conn *iser_conn);
 
 void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 				     struct iser_data_buf *mem,
-				     struct iser_data_buf *mem_copy,
 				     enum iser_data_dir cmd_dir);
 
 int  iser_reg_rdma_mem_fmr(struct iscsi_iser_task *task,
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 76eb57b..0e414db 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -401,13 +401,13 @@ int iser_send_command(struct iscsi_conn *conn,
 	}
 
 	if (scsi_sg_count(sc)) { /* using a scatter list */
-		data_buf->buf  = scsi_sglist(sc);
+		data_buf->sg = scsi_sglist(sc);
 		data_buf->size = scsi_sg_count(sc);
 	}
 	data_buf->data_len = scsi_bufflen(sc);
 
 	if (scsi_prot_sg_count(sc)) {
-		prot_buf->buf  = scsi_prot_sglist(sc);
+		prot_buf->sg  = scsi_prot_sglist(sc);
 		prot_buf->size = scsi_prot_sg_count(sc);
 		prot_buf->data_len = (data_buf->data_len >>
 				     ilog2(sc->device->sector_size)) * 8;
@@ -674,35 +674,31 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 	/* if we were reading, copy back to unaligned sglist,
 	 * anyway dma_unmap and free the copy
 	 */
-	if (iser_task->data_copy[ISER_DIR_IN].copy_buf != NULL) {
+	if (iser_task->data[ISER_DIR_IN].copy_buf) {
 		is_rdma_data_aligned = 0;
 		iser_finalize_rdma_unaligned_sg(iser_task,
 						&iser_task->data[ISER_DIR_IN],
-						&iser_task->data_copy[ISER_DIR_IN],
 						ISER_DIR_IN);
 	}
 
-	if (iser_task->data_copy[ISER_DIR_OUT].copy_buf != NULL) {
+	if (iser_task->data[ISER_DIR_OUT].copy_buf) {
 		is_rdma_data_aligned = 0;
 		iser_finalize_rdma_unaligned_sg(iser_task,
 						&iser_task->data[ISER_DIR_OUT],
-						&iser_task->data_copy[ISER_DIR_OUT],
 						ISER_DIR_OUT);
 	}
 
-	if (iser_task->prot_copy[ISER_DIR_IN].copy_buf != NULL) {
+	if (iser_task->prot[ISER_DIR_IN].copy_buf) {
 		is_rdma_prot_aligned = 0;
 		iser_finalize_rdma_unaligned_sg(iser_task,
 						&iser_task->prot[ISER_DIR_IN],
-						&iser_task->prot_copy[ISER_DIR_IN],
 						ISER_DIR_IN);
 	}
 
-	if (iser_task->prot_copy[ISER_DIR_OUT].copy_buf != NULL) {
+	if (iser_task->prot[ISER_DIR_OUT].copy_buf) {
 		is_rdma_prot_aligned = 0;
 		iser_finalize_rdma_unaligned_sg(iser_task,
 						&iser_task->prot[ISER_DIR_OUT],
-						&iser_task->prot_copy[ISER_DIR_OUT],
 						ISER_DIR_OUT);
 	}
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 32ccd5c..beeabd0 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -46,11 +46,10 @@
  */
 static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 					struct iser_data_buf *data,
-					struct iser_data_buf *data_copy,
 					enum iser_data_dir cmd_dir)
 {
 	struct ib_device *dev = iser_task->iser_conn->ib_conn.device->ib_device;
-	struct scatterlist *sgl = (struct scatterlist *)data->buf;
+	struct scatterlist *sgl = data->sg;
 	struct scatterlist *sg;
 	char *mem = NULL;
 	unsigned long  cmd_data_len = data->data_len;
@@ -72,7 +71,7 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 		/* copy the unaligned sg the buffer which is used for RDMA */
 		char *p, *from;
 
-		sgl = (struct scatterlist *)data->buf;
+		sgl = data->sg;
 		p = mem;
 		for_each_sg(sgl, sg, data->size, i) {
 			from = kmap_atomic(sg_page(sg));
@@ -84,18 +83,16 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 		}
 	}
 
-	sg_init_one(&data_copy->sg_single, mem, cmd_data_len);
-	data_copy->buf = &data_copy->sg_single;
-	data_copy->size = 1;
-	data_copy->copy_buf = mem;
-
-	dma_nents = ib_dma_map_sg(dev, &data_copy->sg_single, 1,
+	sg_init_one(&data->sg_single, mem, cmd_data_len);
+	data->orig_sg = data->sg;
+	data->sg = &data->sg_single;
+	data->copy_buf = mem;
+	dma_nents = ib_dma_map_sg(dev, data->sg, 1,
 				  (cmd_dir == ISER_DIR_OUT) ?
 				  DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	BUG_ON(dma_nents == 0);
 
-	data_copy->dma_nents = dma_nents;
-	data_copy->data_len = cmd_data_len;
+	data->dma_nents = dma_nents;
 
 	return 0;
 }
@@ -106,7 +103,6 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 
 void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 				     struct iser_data_buf *data,
-				     struct iser_data_buf *data_copy,
 				     enum iser_data_dir cmd_dir)
 {
 	struct ib_device *dev;
@@ -114,7 +110,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 
 	dev = iser_task->iser_conn->ib_conn.device->ib_device;
 
-	ib_dma_unmap_sg(dev, &data_copy->sg_single, 1,
+	ib_dma_unmap_sg(dev, data->sg, 1,
 			(cmd_dir == ISER_DIR_OUT) ?
 			DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
@@ -126,9 +122,9 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 		int i;
 
 		/* copy back read RDMA to unaligned sg */
-		mem = data_copy->copy_buf;
+		mem = data->copy_buf;
 
-		sgl = (struct scatterlist *)data->buf;
+		sgl = data->sg;
 		sg_size = data->size;
 
 		p = mem;
@@ -145,12 +141,12 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 	cmd_data_len = data->data_len;
 
 	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
-		free_pages((unsigned long)data_copy->copy_buf,
+		free_pages((unsigned long)data->copy_buf,
 			   ilog2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
 	else
-		kfree(data_copy->copy_buf);
+		kfree(data->copy_buf);
 
-	data_copy->copy_buf = NULL;
+	data->copy_buf = NULL;
 }
 
 #define IS_4K_ALIGNED(addr)	((((unsigned long)addr) & ~MASK_4K) == 0)
@@ -172,7 +168,7 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 			       struct ib_device *ibdev, u64 *pages,
 			       int *offset, int *data_size)
 {
-	struct scatterlist *sg, *sgl = (struct scatterlist *)data->buf;
+	struct scatterlist *sg, *sgl = data->sg;
 	u64 start_addr, end_addr, page, chunk_start = 0;
 	unsigned long total_sz = 0;
 	unsigned int dma_len;
@@ -224,14 +220,14 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 static int iser_data_buf_aligned_len(struct iser_data_buf *data,
 				      struct ib_device *ibdev)
 {
-	struct scatterlist *sgl, *sg, *next_sg = NULL;
+	struct scatterlist *sg, *sgl, *next_sg = NULL;
 	u64 start_addr, end_addr;
 	int i, ret_len, start_check = 0;
 
 	if (data->dma_nents == 1)
 		return 1;
 
-	sgl = (struct scatterlist *)data->buf;
+	sgl = data->sg;
 	start_addr  = ib_sg_dma_address(ibdev, sgl);
 
 	for_each_sg(sgl, sg, data->dma_nents, i) {
@@ -263,11 +259,10 @@ static int iser_data_buf_aligned_len(struct iser_data_buf *data,
 static void iser_data_buf_dump(struct iser_data_buf *data,
 			       struct ib_device *ibdev)
 {
-	struct scatterlist *sgl = (struct scatterlist *)data->buf;
 	struct scatterlist *sg;
 	int i;
 
-	for_each_sg(sgl, sg, data->dma_nents, i)
+	for_each_sg(data->sg, sg, data->dma_nents, i)
 		iser_dbg("sg[%d] dma_addr:0x%lX page:0x%p "
 			 "off:0x%x sz:0x%x dma_len:0x%x\n",
 			 i, (unsigned long)ib_sg_dma_address(ibdev, sg),
@@ -320,7 +315,7 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 	iser_task->dir[iser_dir] = 1;
 	dev = iser_task->iser_conn->ib_conn.device->ib_device;
 
-	data->dma_nents = ib_dma_map_sg(dev, data->buf, data->size, dma_dir);
+	data->dma_nents = ib_dma_map_sg(dev, data->sg, data->size, dma_dir);
 	if (data->dma_nents == 0) {
 		iser_err("dma_map_sg failed!!!\n");
 		return -EINVAL;
@@ -335,13 +330,12 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
 	struct ib_device *dev;
 
 	dev = iser_task->iser_conn->ib_conn.device->ib_device;
-	ib_dma_unmap_sg(dev, data->buf, data->size, dir);
+	ib_dma_unmap_sg(dev, data->sg, data->size, dir);
 }
 
 static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 			      struct ib_device *ibdev,
 			      struct iser_data_buf *mem,
-			      struct iser_data_buf *mem_copy,
 			      enum iser_data_dir cmd_dir,
 			      int aligned_len)
 {
@@ -361,7 +355,7 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 
 	/* allocate copy buf, if we are writing, copy the */
 	/* unaligned scatterlist, dma map the copy        */
-	if (iser_start_rdma_unaligned_sg(iser_task, mem, mem_copy, cmd_dir) != 0)
+	if (iser_start_rdma_unaligned_sg(iser_task, mem, cmd_dir) != 0)
 		return -ENOMEM;
 
 	return 0;
@@ -391,18 +385,16 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
 		err = fall_to_bounce_buf(iser_task, ibdev, mem,
-					 &iser_task->data_copy[cmd_dir],
 					 cmd_dir, aligned_len);
 		if (err) {
 			iser_err("failed to allocate bounce buffer\n");
 			return err;
 		}
-		mem = &iser_task->data_copy[cmd_dir];
 	}
 
 	/* if there a single dma entry, FMR is not needed */
 	if (mem->dma_nents == 1) {
-		sg = (struct scatterlist *)mem->buf;
+		sg = mem->sg;
 
 		regd_buf->reg.lkey = device->mr->lkey;
 		regd_buf->reg.rkey = device->mr->rkey;
@@ -592,7 +584,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 
 	/* if there a single dma entry, dma mr suffices */
 	if (mem->dma_nents == 1) {
-		struct scatterlist *sg = (struct scatterlist *)mem->buf;
+		struct scatterlist *sg = mem->sg;
 
 		sge->lkey = device->mr->lkey;
 		sge->addr   = ib_sg_dma_address(ibdev, &sg[0]);
@@ -678,13 +670,11 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
 		err = fall_to_bounce_buf(iser_task, ibdev, mem,
-					 &iser_task->data_copy[cmd_dir],
 					 cmd_dir, aligned_len);
 		if (err) {
 			iser_err("failed to allocate bounce buffer\n");
 			return err;
 		}
-		mem = &iser_task->data_copy[cmd_dir];
 	}
 
 	if (mem->dma_nents != 1 ||
@@ -711,13 +701,11 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 			aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 			if (aligned_len != mem->dma_nents) {
 				err = fall_to_bounce_buf(iser_task, ibdev, mem,
-							 &iser_task->prot_copy[cmd_dir],
 							 cmd_dir, aligned_len);
 				if (err) {
 					iser_err("failed to allocate bounce buffer\n");
 					return err;
 				}
-				mem = &iser_task->prot_copy[cmd_dir];
 			}
 
 			err = iser_fast_reg_mr(iser_task, regd_buf, mem,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 1/2] IB/iser: set block queue_virt_boundary
Date: Sun, 11 Oct 2015 18:35:06 +0300
Message-ID: <1444577707-15778-2-git-send-email-sagig@mellanox.com>
References: <1444577707-15778-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444577707-15778-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

By limiting the sg lists that we are allowing to meet
and 4k virtual boundary, we can completely remove the
entire bounce buffering logic.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  12 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   7 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |  51 +----
 drivers/infiniband/ulp/iser/iser_memory.c    | 274 ---------------------------
 4 files changed, 18 insertions(+), 326 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index f58ff96b6cbb..f559fe9e3baf 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -766,9 +766,7 @@ iscsi_iser_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *s
 	stats->r2t_pdus = conn->r2t_pdus_cnt; /* always 0 */
 	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
 	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->custom_length = 1;
-	strcpy(stats->custom[0].desc, "fmr_unalign_cnt");
-	stats->custom[0].value = conn->fmr_unalign_cnt;
+	stats->custom_length = 0;
 }
 
 static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
@@ -973,6 +971,13 @@ static umode_t iser_attr_is_visible(int param_type, int param)
 	return 0;
 }
 
+static int iscsi_iser_slave_alloc(struct scsi_device *sdev)
+{
+	blk_queue_virt_boundary(sdev->request_queue, ~MASK_4K);
+
+	return 0;
+}
+
 static struct scsi_host_template iscsi_iser_sht = {
 	.module                 = THIS_MODULE,
 	.name                   = "iSCSI Initiator over iSER",
@@ -986,6 +991,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.target_alloc		= iscsi_target_alloc,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.slave_alloc            = iscsi_iser_slave_alloc,
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
 	.track_queue_depth	= 1,
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 2fab519dbd86..2484bee993ec 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -227,18 +227,13 @@ enum iser_data_dir {
  * @size:         num entries of this sg
  * @data_len:     total beffer byte len
  * @dma_nents:    returned by dma_map_sg
- * @orig_sg:      pointer to the original sg list (in case
- *                we used a copy)
- * @orig_size:    num entris of orig sg list
  */
 struct iser_data_buf {
 	struct scatterlist *sg;
 	unsigned int       size;
 	unsigned long      data_len;
 	unsigned int       dma_nents;
-	struct scatterlist *orig_sg;
-	unsigned int       orig_size;
-  };
+};
 
 /* fwd declarations */
 struct iser_device;
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index d511879d8cdf..ffd00c420729 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -661,48 +661,14 @@ void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
 
 void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 {
-	int is_rdma_data_aligned = 1;
-	int is_rdma_prot_aligned = 1;
 	int prot_count = scsi_prot_sg_count(iser_task->sc);
 
-	/* if we were reading, copy back to unaligned sglist,
-	 * anyway dma_unmap and free the copy
-	 */
-	if (iser_task->data[ISER_DIR_IN].orig_sg) {
-		is_rdma_data_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_task,
-						&iser_task->data[ISER_DIR_IN],
-						ISER_DIR_IN);
-	}
-
-	if (iser_task->data[ISER_DIR_OUT].orig_sg) {
-		is_rdma_data_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_task,
-						&iser_task->data[ISER_DIR_OUT],
-						ISER_DIR_OUT);
-	}
-
-	if (iser_task->prot[ISER_DIR_IN].orig_sg) {
-		is_rdma_prot_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_task,
-						&iser_task->prot[ISER_DIR_IN],
-						ISER_DIR_IN);
-	}
-
-	if (iser_task->prot[ISER_DIR_OUT].orig_sg) {
-		is_rdma_prot_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_task,
-						&iser_task->prot[ISER_DIR_OUT],
-						ISER_DIR_OUT);
-	}
-
 	if (iser_task->dir[ISER_DIR_IN]) {
 		iser_unreg_rdma_mem(iser_task, ISER_DIR_IN);
-		if (is_rdma_data_aligned)
-			iser_dma_unmap_task_data(iser_task,
-						 &iser_task->data[ISER_DIR_IN],
-						 DMA_FROM_DEVICE);
-		if (prot_count && is_rdma_prot_aligned)
+		iser_dma_unmap_task_data(iser_task,
+					 &iser_task->data[ISER_DIR_IN],
+					 DMA_FROM_DEVICE);
+		if (prot_count)
 			iser_dma_unmap_task_data(iser_task,
 						 &iser_task->prot[ISER_DIR_IN],
 						 DMA_FROM_DEVICE);
@@ -710,11 +676,10 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 
 	if (iser_task->dir[ISER_DIR_OUT]) {
 		iser_unreg_rdma_mem(iser_task, ISER_DIR_OUT);
-		if (is_rdma_data_aligned)
-			iser_dma_unmap_task_data(iser_task,
-						 &iser_task->data[ISER_DIR_OUT],
-						 DMA_TO_DEVICE);
-		if (prot_count && is_rdma_prot_aligned)
+		iser_dma_unmap_task_data(iser_task,
+					 &iser_task->data[ISER_DIR_OUT],
+					 DMA_TO_DEVICE);
+		if (prot_count)
 			iser_dma_unmap_task_data(iser_task,
 						 &iser_task->prot[ISER_DIR_OUT],
 						 DMA_TO_DEVICE);
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index f45e6a352173..b29fda3e8e74 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -88,113 +88,6 @@ int iser_assign_reg_ops(struct iser_device *device)
 	return 0;
 }
 
-static void
-iser_free_bounce_sg(struct iser_data_buf *data)
-{
-	struct scatterlist *sg;
-	int count;
-
-	for_each_sg(data->sg, sg, data->size, count)
-		__free_page(sg_page(sg));
-
-	kfree(data->sg);
-
-	data->sg = data->orig_sg;
-	data->size = data->orig_size;
-	data->orig_sg = NULL;
-	data->orig_size = 0;
-}
-
-static int
-iser_alloc_bounce_sg(struct iser_data_buf *data)
-{
-	struct scatterlist *sg;
-	struct page *page;
-	unsigned long length = data->data_len;
-	int i = 0, nents = DIV_ROUND_UP(length, PAGE_SIZE);
-
-	sg = kcalloc(nents, sizeof(*sg), GFP_ATOMIC);
-	if (!sg)
-		goto err;
-
-	sg_init_table(sg, nents);
-	while (length) {
-		u32 page_len = min_t(u32, length, PAGE_SIZE);
-
-		page = alloc_page(GFP_ATOMIC);
-		if (!page)
-			goto err;
-
-		sg_set_page(&sg[i], page, page_len, 0);
-		length -= page_len;
-		i++;
-	}
-
-	data->orig_sg = data->sg;
-	data->orig_size = data->size;
-	data->sg = sg;
-	data->size = nents;
-
-	return 0;
-
-err:
-	for (; i > 0; i--)
-		__free_page(sg_page(&sg[i - 1]));
-	kfree(sg);
-
-	return -ENOMEM;
-}
-
-static void
-iser_copy_bounce(struct iser_data_buf *data, bool to_buffer)
-{
-	struct scatterlist *osg, *bsg = data->sg;
-	void *oaddr, *baddr;
-	unsigned int left = data->data_len;
-	unsigned int bsg_off = 0;
-	int i;
-
-	for_each_sg(data->orig_sg, osg, data->orig_size, i) {
-		unsigned int copy_len, osg_off = 0;
-
-		oaddr = kmap_atomic(sg_page(osg)) + osg->offset;
-		copy_len = min(left, osg->length);
-		while (copy_len) {
-			unsigned int len = min(copy_len, bsg->length - bsg_off);
-
-			baddr = kmap_atomic(sg_page(bsg)) + bsg->offset;
-			if (to_buffer)
-				memcpy(baddr + bsg_off, oaddr + osg_off, len);
-			else
-				memcpy(oaddr + osg_off, baddr + bsg_off, len);
-
-			kunmap_atomic(baddr - bsg->offset);
-			osg_off += len;
-			bsg_off += len;
-			copy_len -= len;
-
-			if (bsg_off >= bsg->length) {
-				bsg = sg_next(bsg);
-				bsg_off = 0;
-			}
-		}
-		kunmap_atomic(oaddr - osg->offset);
-		left -= osg_off;
-	}
-}
-
-static inline void
-iser_copy_from_bounce(struct iser_data_buf *data)
-{
-	iser_copy_bounce(data, false);
-}
-
-static inline void
-iser_copy_to_bounce(struct iser_data_buf *data)
-{
-	iser_copy_bounce(data, true);
-}
-
 struct iser_fr_desc *
 iser_reg_desc_get_fr(struct ib_conn *ib_conn)
 {
@@ -238,62 +131,6 @@ iser_reg_desc_put_fmr(struct ib_conn *ib_conn,
 {
 }
 
-/**
- * iser_start_rdma_unaligned_sg
- */
-static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
-					struct iser_data_buf *data,
-					enum iser_data_dir cmd_dir)
-{
-	struct ib_device *dev = iser_task->iser_conn->ib_conn.device->ib_device;
-	int rc;
-
-	rc = iser_alloc_bounce_sg(data);
-	if (rc) {
-		iser_err("Failed to allocate bounce for data len %lu\n",
-			 data->data_len);
-		return rc;
-	}
-
-	if (cmd_dir == ISER_DIR_OUT)
-		iser_copy_to_bounce(data);
-
-	data->dma_nents = ib_dma_map_sg(dev, data->sg, data->size,
-					(cmd_dir == ISER_DIR_OUT) ?
-					DMA_TO_DEVICE : DMA_FROM_DEVICE);
-	if (!data->dma_nents) {
-		iser_err("Got dma_nents %d, something went wrong...\n",
-			 data->dma_nents);
-		rc = -ENOMEM;
-		goto err;
-	}
-
-	return 0;
-err:
-	iser_free_bounce_sg(data);
-	return rc;
-}
-
-/**
- * iser_finalize_rdma_unaligned_sg
- */
-
-void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
-				     struct iser_data_buf *data,
-				     enum iser_data_dir cmd_dir)
-{
-	struct ib_device *dev = iser_task->iser_conn->ib_conn.device->ib_device;
-
-	ib_dma_unmap_sg(dev, data->sg, data->size,
-			(cmd_dir == ISER_DIR_OUT) ?
-			DMA_TO_DEVICE : DMA_FROM_DEVICE);
-
-	if (cmd_dir == ISER_DIR_IN)
-		iser_copy_from_bounce(data);
-
-	iser_free_bounce_sg(data);
-}
-
 #define IS_4K_ALIGNED(addr)	((((unsigned long)addr) & ~MASK_4K) == 0)
 
 /**
@@ -355,64 +192,6 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 	return cur_page;
 }
 
-
-/**
- * iser_data_buf_aligned_len - Tries to determine the maximal correctly aligned
- * for RDMA sub-list of a scatter-gather list of memory buffers, and  returns
- * the number of entries which are aligned correctly. Supports the case where
- * consecutive SG elements are actually fragments of the same physcial page.
- */
-static int iser_data_buf_aligned_len(struct iser_data_buf *data,
-				     struct ib_device *ibdev,
-				     unsigned sg_tablesize)
-{
-	struct scatterlist *sg, *sgl, *next_sg = NULL;
-	u64 start_addr, end_addr;
-	int i, ret_len, start_check = 0;
-
-	if (data->dma_nents == 1)
-		return 1;
-
-	sgl = data->sg;
-	start_addr  = ib_sg_dma_address(ibdev, sgl);
-
-	if (unlikely(sgl[0].offset &&
-		     data->data_len >= sg_tablesize * PAGE_SIZE)) {
-		iser_dbg("can't register length %lx with offset %x "
-			 "fall to bounce buffer\n", data->data_len,
-			 sgl[0].offset);
-		return 0;
-	}
-
-	for_each_sg(sgl, sg, data->dma_nents, i) {
-		if (start_check && !IS_4K_ALIGNED(start_addr))
-			break;
-
-		next_sg = sg_next(sg);
-		if (!next_sg)
-			break;
-
-		end_addr    = start_addr + ib_sg_dma_len(ibdev, sg);
-		start_addr  = ib_sg_dma_address(ibdev, next_sg);
-
-		if (end_addr == start_addr) {
-			start_check = 0;
-			continue;
-		} else
-			start_check = 1;
-
-		if (!IS_4K_ALIGNED(end_addr))
-			break;
-	}
-	ret_len = (next_sg) ? i : i+1;
-
-	if (unlikely(ret_len != data->dma_nents))
-		iser_warn("rdma alignment violation (%d/%d aligned)\n",
-			  ret_len, data->dma_nents);
-
-	return ret_len;
-}
-
 static void iser_data_buf_dump(struct iser_data_buf *data,
 			       struct ib_device *ibdev)
 {
@@ -483,31 +262,6 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 	return 0;
 }
 
-static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
-			      struct iser_data_buf *mem,
-			      enum iser_data_dir cmd_dir)
-{
-	struct iscsi_conn *iscsi_conn = iser_task->iser_conn->iscsi_conn;
-	struct iser_device *device = iser_task->iser_conn->ib_conn.device;
-
-	iscsi_conn->fmr_unalign_cnt++;
-
-	if (iser_debug_level > 0)
-		iser_data_buf_dump(mem, device->ib_device);
-
-	/* unmap the command data before accessing it */
-	iser_dma_unmap_task_data(iser_task, mem,
-				 (cmd_dir == ISER_DIR_OUT) ?
-				 DMA_TO_DEVICE : DMA_FROM_DEVICE);
-
-	/* allocate copy buf, if we are writing, copy the */
-	/* unaligned scatterlist, dma map the copy        */
-	if (iser_start_rdma_unaligned_sg(iser_task, mem, cmd_dir) != 0)
-		return -ENOMEM;
-
-	return 0;
-}
-
 /**
  * iser_reg_page_vec - Register physical memory
  *
@@ -776,26 +530,6 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 }
 
 static int
-iser_handle_unaligned_buf(struct iscsi_iser_task *task,
-			  struct iser_data_buf *mem,
-			  enum iser_data_dir dir)
-{
-	struct iser_conn *iser_conn = task->iser_conn;
-	struct iser_device *device = iser_conn->ib_conn.device;
-	int err, aligned_len;
-
-	aligned_len = iser_data_buf_aligned_len(mem, device->ib_device,
-						iser_conn->scsi_sg_tablesize);
-	if (aligned_len != mem->dma_nents) {
-		err = fall_to_bounce_buf(task, mem, dir);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int
 iser_reg_prot_sg(struct iscsi_iser_task *task,
 		 struct iser_data_buf *mem,
 		 struct iser_fr_desc *desc,
@@ -837,10 +571,6 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 	bool use_dma_key;
 	int err;
 
-	err = iser_handle_unaligned_buf(task, mem, dir);
-	if (unlikely(err))
-		return err;
-
 	use_dma_key = (mem->dma_nents == 1 && !iser_always_reg &&
 		       scsi_get_prot_op(task->sc) == SCSI_PROT_NORMAL);
 
@@ -863,10 +593,6 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 
 		if (scsi_prot_sg_count(task->sc)) {
 			mem = &task->prot[dir];
-			err = iser_handle_unaligned_buf(task, mem, dir);
-			if (unlikely(err))
-				goto err_reg;
-
 			err = iser_reg_prot_sg(task, mem, desc,
 					       use_dma_key, prot_reg);
 			if (unlikely(err))
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

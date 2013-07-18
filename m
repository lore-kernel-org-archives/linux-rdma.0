From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.11 5/7] IB/iser: Handle unaligned SG in separate function
Date: Thu, 18 Jul 2013 16:25:29 +0300
Message-ID: <1374153931-7313-6-git-send-email-ogerlitz@mellanox.com>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374153931-7313-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This routine will be shared with other rdma management schemes. The bounce
buffer solution for unaligned SG-lists and the sg_to_page_vec routine are
likely to be used for other registration schemes and not just FMR.

Move them out of the FMR specific code, and call them from there, later
they will be called also from other reg methods code.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |   66 +++++++++++++++++++----------
 1 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 797e49f..4dea1ba 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -170,8 +170,8 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
  */
 
 static int iser_sg_to_page_vec(struct iser_data_buf *data,
-			       struct iser_page_vec *page_vec,
-			       struct ib_device *ibdev)
+			       struct ib_device *ibdev, u64 *pages,
+			       int *offset, int *data_size)
 {
 	struct scatterlist *sg, *sgl = (struct scatterlist *)data->buf;
 	u64 start_addr, end_addr, page, chunk_start = 0;
@@ -180,7 +180,7 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 	int i, new_chunk, cur_page, last_ent = data->dma_nents - 1;
 
 	/* compute the offset of first element */
-	page_vec->offset = (u64) sgl[0].offset & ~MASK_4K;
+	*offset = (u64) sgl[0].offset & ~MASK_4K;
 
 	new_chunk = 1;
 	cur_page  = 0;
@@ -204,13 +204,14 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 		   which might be unaligned */
 		page = chunk_start & MASK_4K;
 		do {
-			page_vec->pages[cur_page++] = page;
+			pages[cur_page++] = page;
 			page += SIZE_4K;
 		} while (page < end_addr);
 	}
 
-	page_vec->data_size = total_sz;
-	iser_dbg("page_vec->data_size:%d cur_page %d\n", page_vec->data_size,cur_page);
+	*data_size = total_sz;
+	iser_dbg("page_vec->data_size:%d cur_page %d\n",
+		 *data_size, cur_page);
 	return cur_page;
 }
 
@@ -295,8 +296,10 @@ static void iser_page_vec_build(struct iser_data_buf *data,
 	page_vec->offset = 0;
 
 	iser_dbg("Translating sg sz: %d\n", data->dma_nents);
-	page_vec_len = iser_sg_to_page_vec(data, page_vec, ibdev);
-	iser_dbg("sg len %d page_vec_len %d\n", data->dma_nents,page_vec_len);
+	page_vec_len = iser_sg_to_page_vec(data, ibdev, page_vec->pages,
+					   &page_vec->offset,
+					   &page_vec->data_size);
+	iser_dbg("sg len %d page_vec_len %d\n", data->dma_nents, page_vec_len);
 
 	page_vec->length = page_vec_len;
 
@@ -344,6 +347,32 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task)
 	}
 }
 
+static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
+			      struct ib_device *ibdev,
+			      enum iser_data_dir cmd_dir,
+			      int aligned_len)
+{
+	struct iscsi_conn    *iscsi_conn = iser_task->iser_conn->iscsi_conn;
+	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
+
+	iscsi_conn->fmr_unalign_cnt++;
+	iser_warn("rdma alignment violation (%d/%d aligned) or FMR not supported\n",
+		  aligned_len, mem->size);
+
+	if (iser_debug_level > 0)
+		iser_data_buf_dump(mem, ibdev);
+
+	/* unmap the command data before accessing it */
+	iser_dma_unmap_task_data(iser_task);
+
+	/* allocate copy buf, if we are writing, copy the */
+	/* unaligned scatterlist, dma map the copy        */
+	if (iser_start_rdma_unaligned_sg(iser_task, cmd_dir) != 0)
+			return -ENOMEM;
+
+	return 0;
+}
+
 /**
  * iser_reg_rdma_mem - Registers memory intended for RDMA,
  * obtaining rkey and va
@@ -353,7 +382,6 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task)
 int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
 		      enum   iser_data_dir        cmd_dir)
 {
-	struct iscsi_conn    *iscsi_conn = iser_task->iser_conn->iscsi_conn;
 	struct iser_conn     *ib_conn = iser_task->iser_conn->ib_conn;
 	struct iser_device   *device = ib_conn->device;
 	struct ib_device     *ibdev = device->ib_device;
@@ -369,20 +397,12 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents ||
 	    (!ib_conn->fmr_pool && mem->dma_nents > 1)) {
-		iscsi_conn->fmr_unalign_cnt++;
-		iser_dbg("rdma alignment violation (%d/%d aligned) or FMR not supported\n",
-			 aligned_len, mem->size);
-
-		if (iser_debug_level > 0)
-			iser_data_buf_dump(mem, ibdev);
-
-		/* unmap the command data before accessing it */
-		iser_dma_unmap_task_data(iser_task);
-
-		/* allocate copy buf, if we are writing, copy the */
-		/* unaligned scatterlist, dma map the copy        */
-		if (iser_start_rdma_unaligned_sg(iser_task, cmd_dir) != 0)
-				return -ENOMEM;
+		err = fall_to_bounce_buf(iser_task, ibdev,
+					 cmd_dir, aligned_len);
+		if (err) {
+			iser_err("failed to allocate bounce buffer\n");
+			return err;
+		}
 		mem = &iser_task->data_copy[cmd_dir];
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

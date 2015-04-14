From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [patch v3 18/18] IB/iser: Rewrite bounce buffer code path
Date: Tue, 14 Apr 2015 18:08:28 +0300
Message-ID: <1429024108-7221-19-git-send-email-sagig@mellanox.com>
References: <1429024108-7221-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429024108-7221-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In some rare cases, IO operations may be not aligned to page
boundaries. This prevents iser from performing fast memory
registration. In order to overcome that iser uses a bounce
buffer to carry the transaction. We basically allocate a buffer
in the size of the transaction and perform a copy.

The buffer allocation using kmalloc is too restrictive since it
requires higher order (atomic) allocations for large transactions
(which may result in memory exhaustion fairly fast for some workloads).
We rewrite the bounce buffer code path to allocate scattered pages
and perform a copy between the transaction sg and the bounce sg.

Reported-by: Alex Lyakas <alex-liwybQIp9wHp1aIWIFLecAC/G2K4zDHf@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    8 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |    8 +-
 drivers/infiniband/ulp/iser/iser_memory.c    |  211 ++++++++++++++++----------
 3 files changed, 138 insertions(+), 89 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index a39645a..262ba1f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -222,12 +222,9 @@ enum iser_data_dir {
  * @size:         num entries of this sg
  * @data_len:     total beffer byte len
  * @dma_nents:    returned by dma_map_sg
- * @copy_buf:     allocated copy buf for SGs unaligned
- *                for rdma which are copied
  * @orig_sg:      pointer to the original sg list (in case
  *                we used a copy)
- * @sg_single:    SG-ified clone of a non SG SC or
- *                unaligned SG
+ * @orig_size:    num entris of orig sg list
  */
 struct iser_data_buf {
 	struct scatterlist *sg;
@@ -235,8 +232,7 @@ struct iser_data_buf {
 	unsigned long      data_len;
 	unsigned int       dma_nents;
 	struct scatterlist *orig_sg;
-	char               *copy_buf;
-	struct scatterlist sg_single;
+	unsigned int       orig_size;
   };
 
 /* fwd declarations */
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index b2e3b77..3e2118e 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -674,28 +674,28 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 	/* if we were reading, copy back to unaligned sglist,
 	 * anyway dma_unmap and free the copy
 	 */
-	if (iser_task->data[ISER_DIR_IN].copy_buf) {
+	if (iser_task->data[ISER_DIR_IN].orig_sg) {
 		is_rdma_data_aligned = 0;
 		iser_finalize_rdma_unaligned_sg(iser_task,
 						&iser_task->data[ISER_DIR_IN],
 						ISER_DIR_IN);
 	}
 
-	if (iser_task->data[ISER_DIR_OUT].copy_buf) {
+	if (iser_task->data[ISER_DIR_OUT].orig_sg) {
 		is_rdma_data_aligned = 0;
 		iser_finalize_rdma_unaligned_sg(iser_task,
 						&iser_task->data[ISER_DIR_OUT],
 						ISER_DIR_OUT);
 	}
 
-	if (iser_task->prot[ISER_DIR_IN].copy_buf) {
+	if (iser_task->prot[ISER_DIR_IN].orig_sg) {
 		is_rdma_prot_aligned = 0;
 		iser_finalize_rdma_unaligned_sg(iser_task,
 						&iser_task->prot[ISER_DIR_IN],
 						ISER_DIR_IN);
 	}
 
-	if (iser_task->prot[ISER_DIR_OUT].copy_buf) {
+	if (iser_task->prot[ISER_DIR_OUT].orig_sg) {
 		is_rdma_prot_aligned = 0;
 		iser_finalize_rdma_unaligned_sg(iser_task,
 						&iser_task->prot[ISER_DIR_OUT],
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index abc979e..f0cdc96 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -39,7 +39,112 @@
 
 #include "iscsi_iser.h"
 
-#define ISER_KMALLOC_THRESHOLD 0x20000 /* 128K - kmalloc limit */
+static void
+iser_free_bounce_sg(struct iser_data_buf *data)
+{
+	struct scatterlist *sg;
+	int count;
+
+	for_each_sg(data->sg, sg, data->size, count)
+		__free_page(sg_page(sg));
+
+	kfree(data->sg);
+
+	data->sg = data->orig_sg;
+	data->size = data->orig_size;
+	data->orig_sg = NULL;
+	data->orig_size = 0;
+}
+
+static int
+iser_alloc_bounce_sg(struct iser_data_buf *data)
+{
+	struct scatterlist *sg;
+	struct page *page;
+	unsigned long length = data->data_len;
+	int i = 0, nents = DIV_ROUND_UP(length, PAGE_SIZE);
+
+	sg = kcalloc(nents, sizeof(*sg), GFP_ATOMIC);
+	if (!sg)
+		goto err;
+
+	sg_init_table(sg, nents);
+	while (length) {
+		u32 page_len = min_t(u32, length, PAGE_SIZE);
+
+		page = alloc_page(GFP_ATOMIC);
+		if (!page)
+			goto err;
+
+		sg_set_page(&sg[i], page, page_len, 0);
+		length -= page_len;
+		i++;
+	}
+
+	data->orig_sg = data->sg;
+	data->orig_size = data->size;
+	data->sg = sg;
+	data->size = nents;
+
+	return 0;
+
+err:
+	for (; i > 0; i--)
+		__free_page(sg_page(&sg[i - 1]));
+	kfree(sg);
+
+	return -ENOMEM;
+}
+
+static void
+iser_copy_bounce(struct iser_data_buf *data, bool to_buffer)
+{
+	struct scatterlist *osg, *bsg = data->sg;
+	void *oaddr, *baddr;
+	unsigned int left = data->data_len;
+	unsigned int bsg_off = 0;
+	int i;
+
+	for_each_sg(data->orig_sg, osg, data->orig_size, i) {
+		unsigned int copy_len, osg_off = 0;
+
+		oaddr = kmap_atomic(sg_page(osg)) + osg->offset;
+		copy_len = min(left, osg->length);
+		while (copy_len) {
+			unsigned int len = min(copy_len, bsg->length - bsg_off);
+
+			baddr = kmap_atomic(sg_page(bsg)) + bsg->offset;
+			if (to_buffer)
+				memcpy(baddr + bsg_off, oaddr + osg_off, len);
+			else
+				memcpy(oaddr + osg_off, baddr + bsg_off, len);
+
+			kunmap_atomic(baddr - bsg->offset);
+			osg_off += len;
+			bsg_off += len;
+			copy_len -= len;
+
+			if (bsg_off >= bsg->length) {
+				bsg = sg_next(bsg);
+				bsg_off = 0;
+			}
+		}
+		kunmap_atomic(oaddr - osg->offset);
+		left -= osg_off;
+	}
+}
+
+static inline void
+iser_copy_from_bounce(struct iser_data_buf *data)
+{
+	iser_copy_bounce(data, false);
+}
+
+static inline void
+iser_copy_to_bounce(struct iser_data_buf *data)
+{
+	iser_copy_bounce(data, true);
+}
 
 struct fast_reg_descriptor *
 iser_reg_desc_get(struct ib_conn *ib_conn)
@@ -75,52 +180,32 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 					enum iser_data_dir cmd_dir)
 {
 	struct ib_device *dev = iser_task->iser_conn->ib_conn.device->ib_device;
-	struct scatterlist *sgl = data->sg;
-	struct scatterlist *sg;
-	char *mem = NULL;
-	unsigned long  cmd_data_len = data->data_len;
-	int dma_nents, i;
-
-	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
-		mem = (void *)__get_free_pages(GFP_ATOMIC,
-		      ilog2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
-	else
-		mem = kmalloc(cmd_data_len, GFP_ATOMIC);
+	int rc;
 
-	if (mem == NULL) {
-		iser_err("Failed to allocate mem size %d %d for copying sglist\n",
-			 data->size, (int)cmd_data_len);
-		return -ENOMEM;
+	rc = iser_alloc_bounce_sg(data);
+	if (rc) {
+		iser_err("Failed to allocate bounce for data len %lu\n",
+			 data->data_len);
+		return rc;
 	}
 
-	if (cmd_dir == ISER_DIR_OUT) {
-		/* copy the unaligned sg the buffer which is used for RDMA */
-		char *p, *from;
-
-		sgl = data->sg;
-		p = mem;
-		for_each_sg(sgl, sg, data->size, i) {
-			from = kmap_atomic(sg_page(sg));
-			memcpy(p,
-			       from + sg->offset,
-			       sg->length);
-			kunmap_atomic(from);
-			p += sg->length;
-		}
-	}
-
-	sg_init_one(&data->sg_single, mem, cmd_data_len);
-	data->orig_sg = data->sg;
-	data->sg = &data->sg_single;
-	data->copy_buf = mem;
-	dma_nents = ib_dma_map_sg(dev, data->sg, 1,
-				  (cmd_dir == ISER_DIR_OUT) ?
-				  DMA_TO_DEVICE : DMA_FROM_DEVICE);
-	BUG_ON(dma_nents == 0);
+	if (cmd_dir == ISER_DIR_OUT)
+		iser_copy_to_bounce(data);
 
-	data->dma_nents = dma_nents;
+	data->dma_nents = ib_dma_map_sg(dev, data->sg, data->size,
+					(cmd_dir == ISER_DIR_OUT) ?
+					DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	if (!data->dma_nents) {
+		iser_err("Got dma_nents %d, something went wrong...\n",
+			 data->dma_nents);
+		rc = -ENOMEM;
+		goto err;
+	}
 
 	return 0;
+err:
+	iser_free_bounce_sg(data);
+	return rc;
 }
 
 /**
@@ -131,48 +216,16 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 				     struct iser_data_buf *data,
 				     enum iser_data_dir cmd_dir)
 {
-	struct ib_device *dev;
-	unsigned long  cmd_data_len;
-
-	dev = iser_task->iser_conn->ib_conn.device->ib_device;
+	struct ib_device *dev = iser_task->iser_conn->ib_conn.device->ib_device;
 
-	ib_dma_unmap_sg(dev, data->sg, 1,
+	ib_dma_unmap_sg(dev, data->sg, data->size,
 			(cmd_dir == ISER_DIR_OUT) ?
 			DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
-	if (cmd_dir == ISER_DIR_IN) {
-		char *mem;
-		struct scatterlist *sgl, *sg;
-		unsigned char *p, *to;
-		unsigned int sg_size;
-		int i;
-
-		/* copy back read RDMA to unaligned sg */
-		mem = data->copy_buf;
-
-		sgl = data->sg;
-		sg_size = data->size;
-
-		p = mem;
-		for_each_sg(sgl, sg, sg_size, i) {
-			to = kmap_atomic(sg_page(sg));
-			memcpy(to + sg->offset,
-			       p,
-			       sg->length);
-			kunmap_atomic(to);
-			p += sg->length;
-		}
-	}
-
-	cmd_data_len = data->data_len;
-
-	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
-		free_pages((unsigned long)data->copy_buf,
-			   ilog2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
-	else
-		kfree(data->copy_buf);
+	if (cmd_dir == ISER_DIR_IN)
+		iser_copy_from_bounce(data);
 
-	data->copy_buf = NULL;
+	iser_free_bounce_sg(data);
 }
 
 #define IS_4K_ALIGNED(addr)	((((unsigned long)addr) & ~MASK_4K) == 0)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 02/10] IB/iser: Reuse ib_sg_to_pages
Date: Tue, 24 Nov 2015 18:23:46 +0200
Message-ID: <1448382234-24806-3-git-send-email-sagig@mellanox.com>
References: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448382234-24806-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have in iser iser_sg_to_page_vec which has exactly
the same role as ib_sg_to_pages. Customize the page_vec
to hold a fake MR so we can reuse ib_sg_to_pages.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |   5 +-
 drivers/infiniband/ulp/iser/iser_memory.c | 105 +++++++-----------------------
 2 files changed, 25 insertions(+), 85 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 8a5998e6a407..233ec0c2ae3d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -579,9 +579,8 @@ struct iscsi_iser_task {
 
 struct iser_page_vec {
 	u64 *pages;
-	int length;
-	int offset;
-	int data_size;
+	int npages;
+	struct ib_mr fake_mr;
 };
 
 /**
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index ea765fb9664d..b7a2b88f48ce 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -131,67 +131,6 @@ iser_reg_desc_put_fmr(struct ib_conn *ib_conn,
 {
 }
 
-#define IS_4K_ALIGNED(addr)	((((unsigned long)addr) & ~MASK_4K) == 0)
-
-/**
- * iser_sg_to_page_vec - Translates scatterlist entries to physical addresses
- * and returns the length of resulting physical address array (may be less than
- * the original due to possible compaction).
- *
- * we build a "page vec" under the assumption that the SG meets the RDMA
- * alignment requirements. Other then the first and last SG elements, all
- * the "internal" elements can be compacted into a list whose elements are
- * dma addresses of physical pages. The code supports also the weird case
- * where --few fragments of the same page-- are present in the SG as
- * consecutive elements. Also, it handles one entry SG.
- */
-
-static int iser_sg_to_page_vec(struct iser_data_buf *data,
-			       struct ib_device *ibdev, u64 *pages,
-			       int *offset, int *data_size)
-{
-	struct scatterlist *sg, *sgl = data->sg;
-	u64 start_addr, end_addr, page, chunk_start = 0;
-	unsigned long total_sz = 0;
-	unsigned int dma_len;
-	int i, new_chunk, cur_page, last_ent = data->dma_nents - 1;
-
-	/* compute the offset of first element */
-	*offset = (u64) sgl[0].offset & ~MASK_4K;
-
-	new_chunk = 1;
-	cur_page  = 0;
-	for_each_sg(sgl, sg, data->dma_nents, i) {
-		start_addr = ib_sg_dma_address(ibdev, sg);
-		if (new_chunk)
-			chunk_start = start_addr;
-		dma_len = ib_sg_dma_len(ibdev, sg);
-		end_addr = start_addr + dma_len;
-		total_sz += dma_len;
-
-		/* collect page fragments until aligned or end of SG list */
-		if (!IS_4K_ALIGNED(end_addr) && i < last_ent) {
-			new_chunk = 0;
-			continue;
-		}
-		new_chunk = 1;
-
-		/* address of the first page in the contiguous chunk;
-		   masking relevant for the very first SG entry,
-		   which might be unaligned */
-		page = chunk_start & MASK_4K;
-		do {
-			pages[cur_page++] = page;
-			page += SIZE_4K;
-		} while (page < end_addr);
-	}
-
-	*data_size = total_sz;
-	iser_dbg("page_vec->data_size:%d cur_page %d\n",
-		 *data_size, cur_page);
-	return cur_page;
-}
-
 static void iser_data_buf_dump(struct iser_data_buf *data,
 			       struct ib_device *ibdev)
 {
@@ -210,10 +149,10 @@ static void iser_dump_page_vec(struct iser_page_vec *page_vec)
 {
 	int i;
 
-	iser_err("page vec length %d data size %d\n",
-		 page_vec->length, page_vec->data_size);
-	for (i = 0; i < page_vec->length; i++)
-		iser_err("%d %lx\n",i,(unsigned long)page_vec->pages[i]);
+	iser_err("page vec npages %d data length %d\n",
+		 page_vec->npages, page_vec->fake_mr.length);
+	for (i = 0; i < page_vec->npages; i++)
+		iser_err("vec[%d]: %llx\n", i, page_vec->pages[i]);
 }
 
 int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
@@ -262,11 +201,16 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 	return 0;
 }
 
-/**
- * iser_reg_page_vec - Register physical memory
- *
- * returns: 0 on success, errno code on failure
- */
+static int iser_set_page(struct ib_mr *mr, u64 addr)
+{
+	struct iser_page_vec *page_vec =
+		container_of(mr, struct iser_page_vec, fake_mr);
+
+	page_vec->pages[page_vec->npages++] = addr;
+
+	return 0;
+}
+
 static
 int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
 		      struct iser_data_buf *mem,
@@ -280,22 +224,19 @@ int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
 	struct ib_pool_fmr *fmr;
 	int ret, plen;
 
-	plen = iser_sg_to_page_vec(mem, device->ib_device,
-				   page_vec->pages,
-				   &page_vec->offset,
-				   &page_vec->data_size);
-	page_vec->length = plen;
-	if (plen * SIZE_4K < page_vec->data_size) {
+	page_vec->npages = 0;
+	page_vec->fake_mr.page_size = SIZE_4K;
+	plen = ib_sg_to_pages(&page_vec->fake_mr, mem->sg,
+			      mem->size, iser_set_page);
+	if (unlikely(plen < mem->size)) {
 		iser_err("page vec too short to hold this SG\n");
 		iser_data_buf_dump(mem, device->ib_device);
 		iser_dump_page_vec(page_vec);
 		return -EINVAL;
 	}
 
-	fmr  = ib_fmr_pool_map_phys(fmr_pool,
-				    page_vec->pages,
-				    page_vec->length,
-				    page_vec->pages[0]);
+	fmr  = ib_fmr_pool_map_phys(fmr_pool, page_vec->pages,
+				    page_vec->npages, page_vec->pages[0]);
 	if (IS_ERR(fmr)) {
 		ret = PTR_ERR(fmr);
 		iser_err("ib_fmr_pool_map_phys failed: %d\n", ret);
@@ -304,8 +245,8 @@ int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
 
 	reg->sge.lkey = fmr->fmr->lkey;
 	reg->rkey = fmr->fmr->rkey;
-	reg->sge.addr = page_vec->pages[0] + page_vec->offset;
-	reg->sge.length = page_vec->data_size;
+	reg->sge.addr = page_vec->fake_mr.iova;
+	reg->sge.length = page_vec->fake_mr.length;
 	reg->mem_h = fmr;
 
 	iser_dbg("fmr reg: lkey=0x%x, rkey=0x%x, addr=0x%llx,"
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

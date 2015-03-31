From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 10/18] IB/iser: Merge build page-vec into register page-vec
Date: Tue, 31 Mar 2015 19:45:50 +0300
Message-ID: <1427820358-15087-11-git-send-email-sagig@mellanox.com>
References: <1427820358-15087-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427820358-15087-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No need for these two separate. Keep it in a single routine
like in the fastreg case. This will also make iser_reg_page_vec
closer to iser_fast_reg_mr arguments. This is a preparation
step for registration flow refactor.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |   91 ++++++++++------------------
 1 files changed, 33 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 0b8656f..6e6b753 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -280,31 +280,6 @@ static void iser_dump_page_vec(struct iser_page_vec *page_vec)
 		iser_err("%d %lx\n",i,(unsigned long)page_vec->pages[i]);
 }
 
-static void iser_page_vec_build(struct iser_data_buf *data,
-				struct iser_page_vec *page_vec,
-				struct ib_device *ibdev)
-{
-	int page_vec_len = 0;
-
-	page_vec->length = 0;
-	page_vec->offset = 0;
-
-	iser_dbg("Translating sg sz: %d\n", data->dma_nents);
-	page_vec_len = iser_sg_to_page_vec(data, ibdev, page_vec->pages,
-					   &page_vec->offset,
-					   &page_vec->data_size);
-	iser_dbg("sg len %d page_vec_len %d\n", data->dma_nents, page_vec_len);
-
-	page_vec->length = page_vec_len;
-
-	if (page_vec_len * SIZE_4K < page_vec->data_size) {
-		iser_err("page_vec too short to hold this SG\n");
-		iser_data_buf_dump(data, ibdev);
-		iser_dump_page_vec(page_vec);
-		BUG();
-	}
-}
-
 int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 			    struct iser_data_buf *data,
 			    enum iser_data_dir iser_dir,
@@ -367,43 +342,44 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
  * returns: 0 on success, errno code on failure
  */
 static
-int iser_reg_page_vec(struct ib_conn *ib_conn,
+int iser_reg_page_vec(struct iscsi_iser_task *iser_task,
+		      struct iser_data_buf *mem,
 		      struct iser_page_vec *page_vec,
-		      struct iser_mem_reg  *mem_reg)
+		      struct iser_mem_reg *mem_reg)
 {
-	struct ib_pool_fmr *mem;
-	u64		   io_addr;
-	u64		   *page_list;
-	int		   status;
-
-	page_list = page_vec->pages;
-	io_addr	  = page_list[0];
+	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
+	struct ib_pool_fmr *fmr;
+	int ret, plen;
+
+	plen = iser_sg_to_page_vec(mem, device->ib_device,
+				   page_vec->pages,
+				   &page_vec->offset,
+				   &page_vec->data_size);
+	page_vec->length = plen;
+	if (plen * SIZE_4K < page_vec->data_size) {
+		iser_err("page vec too short to hold this SG\n");
+		iser_data_buf_dump(mem, device->ib_device);
+		iser_dump_page_vec(page_vec);
+		return -EINVAL;
+	}
 
-	mem  = ib_fmr_pool_map_phys(ib_conn->fmr.pool,
-				    page_list,
+	fmr  = ib_fmr_pool_map_phys(ib_conn->fmr.pool,
+				    page_vec->pages,
 				    page_vec->length,
-				    io_addr);
-
-	if (IS_ERR(mem)) {
-		status = (int)PTR_ERR(mem);
-		iser_err("ib_fmr_pool_map_phys failed: %d\n", status);
-		return status;
+				    page_vec->pages[0]);
+	if (IS_ERR(fmr)) {
+		ret = PTR_ERR(fmr);
+		iser_err("ib_fmr_pool_map_phys failed: %d\n", ret);
+		return ret;
 	}
 
-	mem_reg->lkey  = mem->fmr->lkey;
-	mem_reg->rkey  = mem->fmr->rkey;
-	mem_reg->len   = page_vec->data_size;
-	mem_reg->va    = io_addr + page_vec->offset;
-	mem_reg->mem_h = (void *)mem;
-
-	iser_dbg("PHYSICAL Mem.register, [PHYS p_array: 0x%p, sz: %d, "
-		 "entry[0]: (0x%08lx,%ld)] -> "
-		 "[lkey: 0x%08X mem_h: 0x%p va: 0x%08lX sz: %ld]\n",
-		 page_vec, page_vec->length,
-		 (unsigned long)page_vec->pages[0],
-		 (unsigned long)page_vec->data_size,
-		 (unsigned int)mem_reg->lkey, mem_reg->mem_h,
-		 (unsigned long)mem_reg->va, (unsigned long)mem_reg->len);
+	mem_reg->lkey = fmr->fmr->lkey;
+	mem_reg->rkey = fmr->fmr->rkey;
+	mem_reg->va = page_vec->pages[0] + page_vec->offset;
+	mem_reg->len = page_vec->data_size;
+	mem_reg->mem_h = fmr;
+
 	return 0;
 }
 
@@ -493,8 +469,7 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 			 (unsigned long)mem_reg->va,
 			 (unsigned long)mem_reg->len);
 	} else { /* use FMR for multiple dma entries */
-		iser_page_vec_build(mem, ib_conn->fmr.page_vec, ibdev);
-		err = iser_reg_page_vec(ib_conn, ib_conn->fmr.page_vec,
+		err = iser_reg_page_vec(iser_task, mem, ib_conn->fmr.page_vec,
 					mem_reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

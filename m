From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [patch v3 07/18] IB/iser: Move memory reg/dereg routines to iser_memory.c
Date: Tue, 14 Apr 2015 18:08:17 +0300
Message-ID: <1429024108-7221-8-git-send-email-sagig@mellanox.com>
References: <1429024108-7221-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429024108-7221-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As memory registration/de-registration methods, lets
move them to their natural location. While we're at it,
make iser_reg_page_vec routine static.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    4 -
 drivers/infiniband/ulp/iser/iser_memory.c |   88 +++++++++++++++++++++++++++++
 drivers/infiniband/ulp/iser/iser_verbs.c  |   87 ----------------------------
 3 files changed, 88 insertions(+), 91 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 5c7036c..d5e5288 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -632,10 +632,6 @@ int  iser_connect(struct iser_conn *iser_conn,
 		  struct sockaddr *dst_addr,
 		  int non_blocking);
 
-int  iser_reg_page_vec(struct ib_conn *ib_conn,
-		       struct iser_page_vec *page_vec,
-		       struct iser_mem_reg *mem_reg);
-
 void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 			enum iser_data_dir cmd_dir);
 void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 9c60ff1..4e0cbbb 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -362,6 +362,94 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 }
 
 /**
+ * iser_reg_page_vec - Register physical memory
+ *
+ * returns: 0 on success, errno code on failure
+ */
+static
+int iser_reg_page_vec(struct ib_conn *ib_conn,
+		      struct iser_page_vec *page_vec,
+		      struct iser_mem_reg  *mem_reg)
+{
+	struct ib_pool_fmr *mem;
+	u64		   io_addr;
+	u64		   *page_list;
+	int		   status;
+
+	page_list = page_vec->pages;
+	io_addr	  = page_list[0];
+
+	mem  = ib_fmr_pool_map_phys(ib_conn->fmr.pool,
+				    page_list,
+				    page_vec->length,
+				    io_addr);
+
+	if (IS_ERR(mem)) {
+		status = (int)PTR_ERR(mem);
+		iser_err("ib_fmr_pool_map_phys failed: %d\n", status);
+		return status;
+	}
+
+	mem_reg->lkey  = mem->fmr->lkey;
+	mem_reg->rkey  = mem->fmr->rkey;
+	mem_reg->len   = page_vec->length * SIZE_4K;
+	mem_reg->va    = io_addr;
+	mem_reg->mem_h = (void *)mem;
+
+	mem_reg->va   += page_vec->offset;
+	mem_reg->len   = page_vec->data_size;
+
+	iser_dbg("PHYSICAL Mem.register, [PHYS p_array: 0x%p, sz: %d, "
+		 "entry[0]: (0x%08lx,%ld)] -> "
+		 "[lkey: 0x%08X mem_h: 0x%p va: 0x%08lX sz: %ld]\n",
+		 page_vec, page_vec->length,
+		 (unsigned long)page_vec->pages[0],
+		 (unsigned long)page_vec->data_size,
+		 (unsigned int)mem_reg->lkey, mem_reg->mem_h,
+		 (unsigned long)mem_reg->va, (unsigned long)mem_reg->len);
+	return 0;
+}
+
+/**
+ * Unregister (previosuly registered using FMR) memory.
+ * If memory is non-FMR does nothing.
+ */
+void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
+			enum iser_data_dir cmd_dir)
+{
+	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
+	int ret;
+
+	if (!reg->mem_h)
+		return;
+
+	iser_dbg("PHYSICAL Mem.Unregister mem_h %p\n", reg->mem_h);
+
+	ret = ib_fmr_pool_unmap((struct ib_pool_fmr *)reg->mem_h);
+	if (ret)
+		iser_err("ib_fmr_pool_unmap failed %d\n", ret);
+
+	reg->mem_h = NULL;
+}
+
+void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
+			    enum iser_data_dir cmd_dir)
+{
+	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
+	struct iser_conn *iser_conn = iser_task->iser_conn;
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
+	struct fast_reg_descriptor *desc = reg->mem_h;
+
+	if (!desc)
+		return;
+
+	reg->mem_h = NULL;
+	spin_lock_bh(&ib_conn->lock);
+	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
+	spin_unlock_bh(&ib_conn->lock);
+}
+
+/**
  * iser_reg_rdma_mem_fmr - Registers memory intended for RDMA,
  * using FMR (if possible) obtaining rkey and va
  *
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 7ee4926..986b5f4 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -992,93 +992,6 @@ connect_failure:
 	return err;
 }
 
-/**
- * iser_reg_page_vec - Register physical memory
- *
- * returns: 0 on success, errno code on failure
- */
-int iser_reg_page_vec(struct ib_conn *ib_conn,
-		      struct iser_page_vec *page_vec,
-		      struct iser_mem_reg  *mem_reg)
-{
-	struct ib_pool_fmr *mem;
-	u64		   io_addr;
-	u64		   *page_list;
-	int		   status;
-
-	page_list = page_vec->pages;
-	io_addr	  = page_list[0];
-
-	mem  = ib_fmr_pool_map_phys(ib_conn->fmr.pool,
-				    page_list,
-				    page_vec->length,
-				    io_addr);
-
-	if (IS_ERR(mem)) {
-		status = (int)PTR_ERR(mem);
-		iser_err("ib_fmr_pool_map_phys failed: %d\n", status);
-		return status;
-	}
-
-	mem_reg->lkey  = mem->fmr->lkey;
-	mem_reg->rkey  = mem->fmr->rkey;
-	mem_reg->len   = page_vec->length * SIZE_4K;
-	mem_reg->va    = io_addr;
-	mem_reg->mem_h = (void *)mem;
-
-	mem_reg->va   += page_vec->offset;
-	mem_reg->len   = page_vec->data_size;
-
-	iser_dbg("PHYSICAL Mem.register, [PHYS p_array: 0x%p, sz: %d, "
-		 "entry[0]: (0x%08lx,%ld)] -> "
-		 "[lkey: 0x%08X mem_h: 0x%p va: 0x%08lX sz: %ld]\n",
-		 page_vec, page_vec->length,
-		 (unsigned long)page_vec->pages[0],
-		 (unsigned long)page_vec->data_size,
-		 (unsigned int)mem_reg->lkey, mem_reg->mem_h,
-		 (unsigned long)mem_reg->va, (unsigned long)mem_reg->len);
-	return 0;
-}
-
-/**
- * Unregister (previosuly registered using FMR) memory.
- * If memory is non-FMR does nothing.
- */
-void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
-			enum iser_data_dir cmd_dir)
-{
-	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
-	int ret;
-
-	if (!reg->mem_h)
-		return;
-
-	iser_dbg("PHYSICAL Mem.Unregister mem_h %p\n",reg->mem_h);
-
-	ret = ib_fmr_pool_unmap((struct ib_pool_fmr *)reg->mem_h);
-	if (ret)
-		iser_err("ib_fmr_pool_unmap failed %d\n", ret);
-
-	reg->mem_h = NULL;
-}
-
-void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
-			    enum iser_data_dir cmd_dir)
-{
-	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
-	struct iser_conn *iser_conn = iser_task->iser_conn;
-	struct ib_conn *ib_conn = &iser_conn->ib_conn;
-	struct fast_reg_descriptor *desc = reg->mem_h;
-
-	if (!desc)
-		return;
-
-	reg->mem_h = NULL;
-	spin_lock_bh(&ib_conn->lock);
-	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
-	spin_unlock_bh(&ib_conn->lock);
-}
-
 int iser_post_recvl(struct iser_conn *iser_conn)
 {
 	struct ib_recv_wr rx_wr, *rx_wr_failed;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

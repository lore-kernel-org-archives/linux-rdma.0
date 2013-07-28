From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-3.11 6/7] IB/iser: Place the fmr pool into a union in iser's IB conn struct
Date: Sun, 28 Jul 2013 12:35:41 +0300
Message-ID: <1375004142-22559-7-git-send-email-ogerlitz@mellanox.com>
References: <1375004142-22559-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375004142-22559-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is preparation step for other memory registration methods to be
added. In addition, change reg/unreg routines signature to indicate
they use FMRs.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |   18 +++++++----
 drivers/infiniband/ulp/iser/iser_memory.c |   24 ++++++++-------
 drivers/infiniband/ulp/iser/iser_verbs.c  |   47 +++++++++++++++--------------
 3 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 78117be..75c5352 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -286,7 +286,6 @@ struct iser_conn {
 	struct iser_device           *device;       /* device context          */
 	struct rdma_cm_id            *cma_id;       /* CMA ID		       */
 	struct ib_qp	             *qp;           /* QP 		       */
-	struct ib_fmr_pool           *fmr_pool;     /* pool of IB FMRs         */
 	wait_queue_head_t	     wait;          /* waitq for conn/disconn  */
 	unsigned		     qp_max_recv_dtos; /* num of rx buffers */
 	unsigned		     qp_max_recv_dtos_mask; /* above minus 1 */
@@ -294,8 +293,6 @@ struct iser_conn {
 	int                          post_recv_buf_count; /* posted rx count  */
 	atomic_t                     post_send_buf_count; /* posted tx count   */
 	char 			     name[ISER_OBJECT_NAME_SIZE];
-	struct iser_page_vec         *page_vec;     /* represents SG to fmr maps*
-						     * maps serialized as tx is*/
 	struct list_head	     conn_list;       /* entry in ig conn list */
 
 	char  			     *login_buf;
@@ -304,6 +301,13 @@ struct iser_conn {
 	unsigned int 		     rx_desc_head;
 	struct iser_rx_desc	     *rx_descs;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
+	union {
+		struct {
+			struct ib_fmr_pool      *pool;	   /* pool of IB FMRs         */
+			struct iser_page_vec	*page_vec; /* represents SG to fmr maps*
+							    * maps serialized as tx is*/
+		} fmr;
+	} fastreg;
 };
 
 struct iscsi_iser_conn {
@@ -387,8 +391,8 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn);
 void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *task,
 				     enum iser_data_dir         cmd_dir);
 
-int  iser_reg_rdma_mem(struct iscsi_iser_task *task,
-		       enum   iser_data_dir        cmd_dir);
+int  iser_reg_rdma_mem_fmr(struct iscsi_iser_task *task,
+			   enum iser_data_dir cmd_dir);
 
 int  iser_connect(struct iser_conn   *ib_conn,
 		  struct sockaddr_in *src_addr,
@@ -399,8 +403,8 @@ int  iser_reg_page_vec(struct iser_conn     *ib_conn,
 		       struct iser_page_vec *page_vec,
 		       struct iser_mem_reg  *mem_reg);
 
-void iser_unreg_mem(struct iscsi_iser_task *iser_task,
-		    enum iser_data_dir cmd_dir);
+void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
+			enum iser_data_dir cmd_dir);
 
 int  iser_post_recvl(struct iser_conn *ib_conn);
 int  iser_post_recvm(struct iser_conn *ib_conn, int count);
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 4dea1ba..1985e90 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -374,13 +374,13 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 }
 
 /**
- * iser_reg_rdma_mem - Registers memory intended for RDMA,
- * obtaining rkey and va
+ * iser_reg_rdma_mem_fmr - Registers memory intended for RDMA,
+ * using FMR (if possible) obtaining rkey and va
  *
  * returns 0 on success, errno code on failure
  */
-int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
-		      enum   iser_data_dir        cmd_dir)
+int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
+			  enum iser_data_dir cmd_dir)
 {
 	struct iser_conn     *ib_conn = iser_task->iser_conn->ib_conn;
 	struct iser_device   *device = ib_conn->device;
@@ -396,7 +396,7 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents ||
-	    (!ib_conn->fmr_pool && mem->dma_nents > 1)) {
+	    (!ib_conn->fastreg.fmr.pool && mem->dma_nents > 1)) {
 		err = fall_to_bounce_buf(iser_task, ibdev,
 					 cmd_dir, aligned_len);
 		if (err) {
@@ -423,19 +423,21 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
 			 (unsigned long)regd_buf->reg.va,
 			 (unsigned long)regd_buf->reg.len);
 	} else { /* use FMR for multiple dma entries */
-		iser_page_vec_build(mem, ib_conn->page_vec, ibdev);
-		err = iser_reg_page_vec(ib_conn, ib_conn->page_vec, &regd_buf->reg);
+		iser_page_vec_build(mem, ib_conn->fastreg.fmr.page_vec, ibdev);
+		err = iser_reg_page_vec(ib_conn, ib_conn->fastreg.fmr.page_vec,
+					&regd_buf->reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
 			iser_err("mem->dma_nents = %d (dlength = 0x%x)\n",
 				 mem->dma_nents,
 				 ntoh24(iser_task->desc.iscsi_header.dlength));
 			iser_err("page_vec: data_size = 0x%x, length = %d, offset = 0x%x\n",
-				 ib_conn->page_vec->data_size, ib_conn->page_vec->length,
-				 ib_conn->page_vec->offset);
-			for (i=0 ; i<ib_conn->page_vec->length ; i++)
+				 ib_conn->fastreg.fmr.page_vec->data_size,
+				 ib_conn->fastreg.fmr.page_vec->length,
+				 ib_conn->fastreg.fmr.page_vec->offset);
+			for (i = 0; i < ib_conn->fastreg.fmr.page_vec->length; i++)
 				iser_err("page_vec[%d] = 0x%llx\n", i,
-					 (unsigned long long) ib_conn->page_vec->pages[i]);
+					 (unsigned long long) ib_conn->fastreg.fmr.page_vec->pages[i]);
 		}
 		if (err)
 			return err;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 5b53428..d9a47b9 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -77,8 +77,8 @@ static int iser_create_device_ib_res(struct iser_device *device)
 	/* Assign function handles */
 	device->iser_alloc_rdma_reg_res = iser_create_fmr_pool;
 	device->iser_free_rdma_reg_res = iser_free_fmr_pool;
-	device->iser_reg_rdma_mem = iser_reg_rdma_mem;
-	device->iser_unreg_rdma_mem = iser_unreg_mem;
+	device->iser_reg_rdma_mem = iser_reg_rdma_mem_fmr;
+	device->iser_unreg_rdma_mem = iser_unreg_mem_fmr;
 
 	device->cqs_used = min(ISER_MAX_CQ, device->ib_device->num_comp_vectors);
 	iser_info("using %d CQs, device %s supports %d vectors\n",
@@ -194,13 +194,13 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 	struct ib_fmr_pool_param params;
 	int ret = -ENOMEM;
 
-	ib_conn->page_vec = kmalloc(sizeof(struct iser_page_vec) +
-				    (sizeof(u64)*(ISCSI_ISER_SG_TABLESIZE+1)),
-				    GFP_KERNEL);
-	if (!ib_conn->page_vec)
+	ib_conn->fastreg.fmr.page_vec = kmalloc(sizeof(struct iser_page_vec) +
+						(sizeof(u64)*(ISCSI_ISER_SG_TABLESIZE + 1)),
+						GFP_KERNEL);
+	if (!ib_conn->fastreg.fmr.page_vec)
 		return ret;
 
-	ib_conn->page_vec->pages = (u64 *)(ib_conn->page_vec + 1);
+	ib_conn->fastreg.fmr.page_vec->pages = (u64 *)(ib_conn->fastreg.fmr.page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
 	/* when the first/last SG element are not start/end *
@@ -216,16 +216,16 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 				    IB_ACCESS_REMOTE_WRITE |
 				    IB_ACCESS_REMOTE_READ);
 
-	ib_conn->fmr_pool = ib_create_fmr_pool(device->pd, &params);
-	if (!IS_ERR(ib_conn->fmr_pool))
+	ib_conn->fastreg.fmr.pool = ib_create_fmr_pool(device->pd, &params);
+	if (!IS_ERR(ib_conn->fastreg.fmr.pool))
 		return 0;
 
 	/* no FMR => no need for page_vec */
-	kfree(ib_conn->page_vec);
-	ib_conn->page_vec = NULL;
+	kfree(ib_conn->fastreg.fmr.page_vec);
+	ib_conn->fastreg.fmr.page_vec = NULL;
 
-	ret = PTR_ERR(ib_conn->fmr_pool);
-	ib_conn->fmr_pool = NULL;
+	ret = PTR_ERR(ib_conn->fastreg.fmr.pool);
+	ib_conn->fastreg.fmr.pool = NULL;
 	if (ret != -ENOSYS) {
 		iser_err("FMR allocation failed, err %d\n", ret);
 		return ret;
@@ -241,15 +241,15 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 void iser_free_fmr_pool(struct iser_conn *ib_conn)
 {
 	iser_info("freeing conn %p fmr pool %p\n",
-		  ib_conn, ib_conn->fmr_pool);
+		  ib_conn, ib_conn->fastreg.fmr.pool);
 
-	if (ib_conn->fmr_pool != NULL)
-		ib_destroy_fmr_pool(ib_conn->fmr_pool);
+	if (ib_conn->fastreg.fmr.pool != NULL)
+		ib_destroy_fmr_pool(ib_conn->fastreg.fmr.pool);
 
-	ib_conn->fmr_pool = NULL;
+	ib_conn->fastreg.fmr.pool = NULL;
 
-	kfree(ib_conn->page_vec);
-	ib_conn->page_vec = NULL;
+	kfree(ib_conn->fastreg.fmr.page_vec);
+	ib_conn->fastreg.fmr.page_vec = NULL;
 }
 
 /**
@@ -692,7 +692,7 @@ int iser_reg_page_vec(struct iser_conn     *ib_conn,
 	page_list = page_vec->pages;
 	io_addr	  = page_list[0];
 
-	mem  = ib_fmr_pool_map_phys(ib_conn->fmr_pool,
+	mem  = ib_fmr_pool_map_phys(ib_conn->fastreg.fmr.pool,
 				    page_list,
 				    page_vec->length,
 				    io_addr);
@@ -725,10 +725,11 @@ int iser_reg_page_vec(struct iser_conn     *ib_conn,
 }
 
 /**
- * Unregister (previosuly registered) memory.
+ * Unregister (previosuly registered using FMR) memory.
+ * If memory is non-FMR does nothing.
  */
-void iser_unreg_mem(struct iscsi_iser_task *iser_task,
-		    enum iser_data_dir cmd_dir)
+void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
+			enum iser_data_dir cmd_dir)
 {
 	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
 	int ret;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

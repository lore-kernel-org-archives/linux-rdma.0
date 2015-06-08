From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 07/11] IB/iser: Introduce iser registration pool struct
Date: Mon,  8 Jun 2015 16:15:19 +0300
Message-ID: <1433769323-790-8-git-send-email-sagig@mellanox.com>
References: <1433769323-790-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433769323-790-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead of having it a part of the connection structure,
have it be under a dedicated (embedded) structure in the
connection. A logical separation of the registration pool
and the connection structure.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |   49 ++++++++++++++----------
 drivers/infiniband/ulp/iser/iser_memory.c |   32 +++++++++-------
 drivers/infiniband/ulp/iser/iser_verbs.c  |   60 +++++++++++++++++------------
 3 files changed, 82 insertions(+), 59 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index b8af719..6670986 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -416,6 +416,33 @@ struct iser_fr_desc {
 };
 
 /**
+ * struct iser_fr_pool: connection fast registration pool
+ *
+ * @lock:                protects fmr/fastreg pool
+ * @union.fmr:
+ *     @pool:            FMR pool for fast registrations
+ *     @page_vec:        fast reg page list to hold mapped commands pages
+ *                       used for registration
+ * @union.fastreg:
+ *     @pool:            Fast registration descriptors pool for fast
+ *                       registrations
+ *     @pool_size:       Size of pool
+ */
+struct iser_fr_pool {
+	spinlock_t		     lock;
+	union {
+		struct {
+			struct ib_fmr_pool              *pool;
+			struct iser_page_vec            *page_vec;
+		} fmr;
+		struct {
+			struct list_head	 pool;
+			int			 pool_size;
+		} fastreg;
+	};
+};
+
+/**
  * struct ib_conn - Infiniband related objects
  *
  * @cma_id:              rdma_cm connection maneger handle
@@ -428,15 +455,7 @@ struct iser_fr_desc {
  * @pi_support:          Indicate device T10-PI support
  * @beacon:              beacon send wr to signal all flush errors were drained
  * @flush_comp:          completes when all connection completions consumed
- * @lock:                protects fmr/fastreg pool
- * @union.fmr:
- *     @pool:            FMR pool for fast registrations
- *     @page_vec:        page vector to hold mapped commands pages
- *                       used for registration
- * @union.fastreg:
- *     @pool:            Fast registration descriptors pool for fast
- *                       registrations
- *     @pool_size:       Size of pool
+ * @fr_pool:             connection fast registration poool
  */
 struct ib_conn {
 	struct rdma_cm_id           *cma_id;
@@ -449,17 +468,7 @@ struct ib_conn {
 	bool			     pi_support;
 	struct ib_send_wr	     beacon;
 	struct completion	     flush_comp;
-	spinlock_t		     lock;
-	union {
-		struct {
-			struct ib_fmr_pool      *pool;
-			struct iser_page_vec	*page_vec;
-		} fmr;
-		struct {
-			struct list_head	 pool;
-			int			 pool_size;
-		} fastreg;
-	};
+	struct iser_fr_pool          fr_pool;
 };
 
 /**
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 9febfc1..d731ed7 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -184,14 +184,15 @@ iser_copy_to_bounce(struct iser_data_buf *data)
 struct iser_fr_desc *
 iser_reg_desc_get(struct ib_conn *ib_conn)
 {
+	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	struct iser_fr_desc *desc;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ib_conn->lock, flags);
-	desc = list_first_entry(&ib_conn->fastreg.pool,
+	spin_lock_irqsave(&fr_pool->lock, flags);
+	desc = list_first_entry(&fr_pool->fastreg.pool,
 				struct iser_fr_desc, list);
 	list_del(&desc->list);
-	spin_unlock_irqrestore(&ib_conn->lock, flags);
+	spin_unlock_irqrestore(&fr_pool->lock, flags);
 
 	return desc;
 }
@@ -200,11 +201,12 @@ void
 iser_reg_desc_put(struct ib_conn *ib_conn,
 		  struct iser_fr_desc *desc)
 {
+	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ib_conn->lock, flags);
-	list_add(&desc->list, &ib_conn->fastreg.pool);
-	spin_unlock_irqrestore(&ib_conn->lock, flags);
+	spin_lock_irqsave(&fr_pool->lock, flags);
+	list_add(&desc->list, &fr_pool->fastreg.pool);
+	spin_unlock_irqrestore(&fr_pool->lock, flags);
 }
 
 /**
@@ -480,6 +482,7 @@ int iser_reg_page_vec(struct iscsi_iser_task *iser_task,
 		      struct iser_mem_reg *mem_reg)
 {
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
+	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	struct iser_device *device = ib_conn->device;
 	struct ib_pool_fmr *fmr;
 	int ret, plen;
@@ -496,7 +499,7 @@ int iser_reg_page_vec(struct iscsi_iser_task *iser_task,
 		return -EINVAL;
 	}
 
-	fmr  = ib_fmr_pool_map_phys(ib_conn->fmr.pool,
+	fmr  = ib_fmr_pool_map_phys(fr_pool->fmr.pool,
 				    page_vec->pages,
 				    page_vec->length,
 				    page_vec->pages[0]);
@@ -560,6 +563,7 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 			  enum iser_data_dir cmd_dir)
 {
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
+	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	struct iser_device   *device = ib_conn->device;
 	struct ib_device     *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
@@ -583,20 +587,20 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	if (mem->dma_nents == 1) {
 		return iser_reg_dma(device, mem, mem_reg);
 	} else { /* use FMR for multiple dma entries */
-		err = iser_reg_page_vec(iser_task, mem, ib_conn->fmr.page_vec,
-					mem_reg);
+		err = iser_reg_page_vec(iser_task, mem,
+					fr_pool->fmr.page_vec, mem_reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
 			iser_err("mem->dma_nents = %d (dlength = 0x%x)\n",
 				 mem->dma_nents,
 				 ntoh24(iser_task->desc.iscsi_header.dlength));
 			iser_err("page_vec: data_size = 0x%x, length = %d, offset = 0x%x\n",
-				 ib_conn->fmr.page_vec->data_size,
-				 ib_conn->fmr.page_vec->length,
-				 ib_conn->fmr.page_vec->offset);
-			for (i = 0; i < ib_conn->fmr.page_vec->length; i++)
+				 fr_pool->fmr.page_vec->data_size,
+				 fr_pool->fmr.page_vec->length,
+				 fr_pool->fmr.page_vec->offset);
+			for (i = 0; i < fr_pool->fmr.page_vec->length; i++)
 				iser_err("page_vec[%d] = 0x%llx\n", i,
-					 (unsigned long long)ib_conn->fmr.page_vec->pages[i]);
+					 (unsigned long long)fr_pool->fmr.page_vec->pages[i]);
 		}
 		if (err)
 			return err;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 8762c61..055f7eb 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -199,16 +199,21 @@ static void iser_free_device_ib_res(struct iser_device *device)
 int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 {
 	struct iser_device *device = ib_conn->device;
+	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
+	struct iser_page_vec *page_vec;
+	struct ib_fmr_pool *fmr_pool;
 	struct ib_fmr_pool_param params;
 	int ret = -ENOMEM;
 
-	ib_conn->fmr.page_vec = kmalloc(sizeof(*ib_conn->fmr.page_vec) +
-					(sizeof(u64)*(ISCSI_ISER_SG_TABLESIZE + 1)),
-					GFP_KERNEL);
-	if (!ib_conn->fmr.page_vec)
+	spin_lock_init(&fr_pool->lock);
+
+	page_vec = kmalloc(sizeof(*page_vec) +
+			   (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE + 1)),
+			   GFP_KERNEL);
+	if (!page_vec)
 		return ret;
 
-	ib_conn->fmr.page_vec->pages = (u64 *)(ib_conn->fmr.page_vec + 1);
+	page_vec->pages = (u64 *)(page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
 	/* when the first/last SG element are not start/end *
@@ -224,18 +229,20 @@ int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 				    IB_ACCESS_REMOTE_WRITE |
 				    IB_ACCESS_REMOTE_READ);
 
-	ib_conn->fmr.pool = ib_create_fmr_pool(device->pd, &params);
-	if (IS_ERR(ib_conn->fmr.pool)) {
-		ret = PTR_ERR(ib_conn->fmr.pool);
+	fmr_pool = ib_create_fmr_pool(device->pd, &params);
+	if (IS_ERR(fmr_pool)) {
+		ret = PTR_ERR(fmr_pool);
 		iser_err("FMR allocation failed, err %d\n", ret);
 		goto err;
 	}
 
+	fr_pool->fmr.page_vec = page_vec;
+	fr_pool->fmr.pool = fmr_pool;
+
 	return 0;
 
 err:
-	kfree(ib_conn->fmr.page_vec);
-	ib_conn->fmr.page_vec = NULL;
+	kfree(page_vec);
 	return ret;
 }
 
@@ -244,14 +251,15 @@ err:
  */
 void iser_free_fmr_pool(struct ib_conn *ib_conn)
 {
-	iser_info("freeing conn %p fmr pool %p\n",
-		  ib_conn, ib_conn->fmr.pool);
+	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 
-	ib_destroy_fmr_pool(ib_conn->fmr.pool);
-	ib_conn->fmr.pool = NULL;
+	iser_info("freeing conn %p fmr pool %p\n",
+		  ib_conn, fr_pool->fmr.pool);
 
-	kfree(ib_conn->fmr.page_vec);
-	ib_conn->fmr.page_vec = NULL;
+	ib_destroy_fmr_pool(fr_pool->fmr.pool);
+	fr_pool->fmr.pool = NULL;
+	kfree(fr_pool->fmr.page_vec);
+	fr_pool->fmr.page_vec = NULL;
 }
 
 static int
@@ -378,19 +386,21 @@ reg_res_alloc_failure:
 int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 {
 	struct iser_device *device = ib_conn->device;
+	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	struct iser_fr_desc *desc;
 	int i, ret;
 
-	INIT_LIST_HEAD(&ib_conn->fastreg.pool);
-	ib_conn->fastreg.pool_size = 0;
+	INIT_LIST_HEAD(&fr_pool->fastreg.pool);
+	spin_lock_init(&fr_pool->lock);
+	fr_pool->fastreg.pool_size = 0;
 	for (i = 0; i < cmds_max; i++) {
 		desc = iser_create_fastreg_desc(device->ib_device, device->pd,
 						ib_conn->pi_support);
 		if (IS_ERR(desc))
 			goto err;
 
-		list_add_tail(&desc->list, &ib_conn->fastreg.pool);
-		ib_conn->fastreg.pool_size++;
+		list_add_tail(&desc->list, &fr_pool->fastreg.pool);
+		fr_pool->fastreg.pool_size++;
 	}
 
 	return 0;
@@ -405,15 +415,16 @@ err:
  */
 void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 {
+	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	struct iser_fr_desc *desc, *tmp;
 	int i = 0;
 
-	if (list_empty(&ib_conn->fastreg.pool))
+	if (list_empty(&fr_pool->fastreg.pool))
 		return;
 
 	iser_info("freeing conn %p fr pool\n", ib_conn);
 
-	list_for_each_entry_safe(desc, tmp, &ib_conn->fastreg.pool, list) {
+	list_for_each_entry_safe(desc, tmp, &fr_pool->fastreg.pool, list) {
 		list_del(&desc->list);
 		iser_free_reg_res(&desc->rsc);
 		if (desc->pi_ctx)
@@ -422,9 +433,9 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 		++i;
 	}
 
-	if (i < ib_conn->fastreg.pool_size)
+	if (i < fr_pool->fastreg.pool_size)
 		iser_warn("pool still has %d regions registered\n",
-			  ib_conn->fastreg.pool_size - i);
+			  fr_pool->fastreg.pool_size - i);
 }
 
 /**
@@ -920,7 +931,6 @@ void iser_conn_init(struct iser_conn *iser_conn)
 	init_completion(&iser_conn->ib_completion);
 	init_completion(&iser_conn->up_completion);
 	INIT_LIST_HEAD(&iser_conn->conn_list);
-	spin_lock_init(&iser_conn->ib_conn.lock);
 	mutex_init(&iser_conn->state_mutex);
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

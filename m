From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 15/22] IB/iser: Maintain connection fmr_pool under a single registration descriptor
Date: Thu, 30 Jul 2015 11:06:28 +0300
Message-ID: <1438243595-32288-16-git-send-email-sagig@mellanox.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This will allow us to unify the memory registration code path between
the various methods which vary by the device capabilities. This change
will make it easier and less intrusive to remove fmr_pools from the
code when we'd want to.

The reason we use a single descriptor is to avoid taking a
redundant spinlock when working with FMRs.

We also change the signature of iser_reg_page_vec to make it match
iser_fast_reg_mr (and the future indirect registration method).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  | 38 +++++++++------------
 drivers/infiniband/ulp/iser/iser_memory.c | 28 +++++++++-------
 drivers/infiniband/ulp/iser/iser_verbs.c  | 56 ++++++++++++++++++++-----------
 3 files changed, 68 insertions(+), 54 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 1fc4c23..a8c8177 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -380,12 +380,20 @@ struct iser_device {
  * struct iser_reg_resources - Fast registration recources
  *
  * @mr:         memory region
- * @frpl:       fast reg page list
+ * @fmr_pool:   pool of fmrs
+ * @frpl:       fast reg page list used by frwrs
+ * @page_vec:   fast reg page list used by fmr pool
  * @mr_valid:   is mr valid indicator
  */
 struct iser_reg_resources {
-	struct ib_mr			 *mr;
-	struct ib_fast_reg_page_list     *frpl;
+	union {
+		struct ib_mr             *mr;
+		struct ib_fmr_pool       *fmr_pool;
+	};
+	union {
+		struct ib_fast_reg_page_list     *frpl;
+		struct iser_page_vec             *page_vec;
+	};
 	u8				  mr_valid:1;
 };
 
@@ -420,28 +428,14 @@ struct iser_fr_desc {
 /**
  * struct iser_fr_pool: connection fast registration pool
  *
+ * @list:                list of fastreg descriptors
  * @lock:                protects fmr/fastreg pool
- * @union.fmr:
- *     @pool:            FMR pool for fast registrations
- *     @page_vec:        fast reg page list to hold mapped commands pages
- *                       used for registration
- * @union.fastreg:
- *     @pool:            Fast registration descriptors pool for fast
- *                       registrations
- *     @pool_size:       Size of pool
+ * @size:                size of the pool
  */
 struct iser_fr_pool {
-	spinlock_t		     lock;
-	union {
-		struct {
-			struct ib_fmr_pool              *pool;
-			struct iser_page_vec            *page_vec;
-		} fmr;
-		struct {
-			struct list_head	 pool;
-			int			 pool_size;
-		} fastreg;
-	};
+	struct list_head        list;
+	spinlock_t              lock;
+	int                     size;
 };
 
 /**
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 65c035d..d0c01e1 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -189,7 +189,7 @@ iser_reg_desc_get(struct ib_conn *ib_conn)
 	unsigned long flags;
 
 	spin_lock_irqsave(&fr_pool->lock, flags);
-	desc = list_first_entry(&fr_pool->fastreg.pool,
+	desc = list_first_entry(&fr_pool->list,
 				struct iser_fr_desc, list);
 	list_del(&desc->list);
 	spin_unlock_irqrestore(&fr_pool->lock, flags);
@@ -205,7 +205,7 @@ iser_reg_desc_put(struct ib_conn *ib_conn,
 	unsigned long flags;
 
 	spin_lock_irqsave(&fr_pool->lock, flags);
-	list_add(&desc->list, &fr_pool->fastreg.pool);
+	list_add(&desc->list, &fr_pool->list);
 	spin_unlock_irqrestore(&fr_pool->lock, flags);
 }
 
@@ -478,12 +478,13 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 static
 int iser_reg_page_vec(struct iscsi_iser_task *iser_task,
 		      struct iser_data_buf *mem,
-		      struct iser_page_vec *page_vec,
+		      struct iser_reg_resources *rsc,
 		      struct iser_mem_reg *mem_reg)
 {
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
-	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	struct iser_device *device = ib_conn->device;
+	struct iser_page_vec *page_vec = rsc->page_vec;
+	struct ib_fmr_pool *fmr_pool = rsc->fmr_pool;
 	struct ib_pool_fmr *fmr;
 	int ret, plen;
 
@@ -499,7 +500,7 @@ int iser_reg_page_vec(struct iscsi_iser_task *iser_task,
 		return -EINVAL;
 	}
 
-	fmr  = ib_fmr_pool_map_phys(fr_pool->fmr.pool,
+	fmr  = ib_fmr_pool_map_phys(fmr_pool,
 				    page_vec->pages,
 				    page_vec->length,
 				    page_vec->pages[0]);
@@ -587,20 +588,23 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	if (mem->dma_nents == 1) {
 		return iser_reg_dma(device, mem, mem_reg);
 	} else { /* use FMR for multiple dma entries */
-		err = iser_reg_page_vec(iser_task, mem,
-					fr_pool->fmr.page_vec, mem_reg);
+		struct iser_fr_desc *desc;
+
+		desc = list_first_entry(&fr_pool->list,
+					struct iser_fr_desc, list);
+		err = iser_reg_page_vec(iser_task, mem, &desc->rsc, mem_reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
 			iser_err("mem->dma_nents = %d (dlength = 0x%x)\n",
 				 mem->dma_nents,
 				 ntoh24(iser_task->desc.iscsi_header.dlength));
 			iser_err("page_vec: data_size = 0x%x, length = %d, offset = 0x%x\n",
-				 fr_pool->fmr.page_vec->data_size,
-				 fr_pool->fmr.page_vec->length,
-				 fr_pool->fmr.page_vec->offset);
-			for (i = 0; i < fr_pool->fmr.page_vec->length; i++)
+				 desc->rsc.page_vec->data_size,
+				 desc->rsc.page_vec->length,
+				 desc->rsc.page_vec->offset);
+			for (i = 0; i < desc->rsc.page_vec->length; i++)
 				iser_err("page_vec[%d] = 0x%llx\n", i,
-					 (unsigned long long)fr_pool->fmr.page_vec->pages[i]);
+					 (unsigned long long)desc->rsc.page_vec->pages[i]);
 		}
 		if (err)
 			return err;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index d50477c..6b464e6 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -204,17 +204,25 @@ int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 	struct iser_device *device = ib_conn->device;
 	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
 	struct iser_page_vec *page_vec;
+	struct iser_fr_desc *desc;
 	struct ib_fmr_pool *fmr_pool;
 	struct ib_fmr_pool_param params;
-	int ret = -ENOMEM;
+	int ret;
 
+	INIT_LIST_HEAD(&fr_pool->list);
 	spin_lock_init(&fr_pool->lock);
 
+	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
 	page_vec = kmalloc(sizeof(*page_vec) +
 			   (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE + 1)),
 			   GFP_KERNEL);
-	if (!page_vec)
-		return ret;
+	if (!page_vec) {
+		ret = -ENOMEM;
+		goto err_frpl;
+	}
 
 	page_vec->pages = (u64 *)(page_vec + 1);
 
@@ -236,16 +244,20 @@ int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 	if (IS_ERR(fmr_pool)) {
 		ret = PTR_ERR(fmr_pool);
 		iser_err("FMR allocation failed, err %d\n", ret);
-		goto err;
+		goto err_fmr;
 	}
 
-	fr_pool->fmr.page_vec = page_vec;
-	fr_pool->fmr.pool = fmr_pool;
+	desc->rsc.page_vec = page_vec;
+	desc->rsc.fmr_pool = fmr_pool;
+	list_add(&desc->list, &fr_pool->list);
 
 	return 0;
 
-err:
+err_fmr:
 	kfree(page_vec);
+err_frpl:
+	kfree(desc);
+
 	return ret;
 }
 
@@ -255,14 +267,18 @@ err:
 void iser_free_fmr_pool(struct ib_conn *ib_conn)
 {
 	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
+	struct iser_fr_desc *desc;
+
+	desc = list_first_entry(&fr_pool->list,
+				struct iser_fr_desc, list);
+	list_del(&desc->list);
 
 	iser_info("freeing conn %p fmr pool %p\n",
-		  ib_conn, fr_pool->fmr.pool);
+		  ib_conn, desc->rsc.fmr_pool);
 
-	ib_destroy_fmr_pool(fr_pool->fmr.pool);
-	fr_pool->fmr.pool = NULL;
-	kfree(fr_pool->fmr.page_vec);
-	fr_pool->fmr.page_vec = NULL;
+	ib_destroy_fmr_pool(desc->rsc.fmr_pool);
+	kfree(desc->rsc.page_vec);
+	kfree(desc);
 }
 
 static int
@@ -392,9 +408,9 @@ int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 	struct iser_fr_desc *desc;
 	int i, ret;
 
-	INIT_LIST_HEAD(&fr_pool->fastreg.pool);
+	INIT_LIST_HEAD(&fr_pool->list);
 	spin_lock_init(&fr_pool->lock);
-	fr_pool->fastreg.pool_size = 0;
+	fr_pool->size = 0;
 	for (i = 0; i < cmds_max; i++) {
 		desc = iser_create_fastreg_desc(device->ib_device, device->pd,
 						ib_conn->pi_support);
@@ -403,8 +419,8 @@ int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 			goto err;
 		}
 
-		list_add_tail(&desc->list, &fr_pool->fastreg.pool);
-		fr_pool->fastreg.pool_size++;
+		list_add_tail(&desc->list, &fr_pool->list);
+		fr_pool->size++;
 	}
 
 	return 0;
@@ -423,12 +439,12 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 	struct iser_fr_desc *desc, *tmp;
 	int i = 0;
 
-	if (list_empty(&fr_pool->fastreg.pool))
+	if (list_empty(&fr_pool->list))
 		return;
 
 	iser_info("freeing conn %p fr pool\n", ib_conn);
 
-	list_for_each_entry_safe(desc, tmp, &fr_pool->fastreg.pool, list) {
+	list_for_each_entry_safe(desc, tmp, &fr_pool->list, list) {
 		list_del(&desc->list);
 		iser_free_reg_res(&desc->rsc);
 		if (desc->pi_ctx)
@@ -437,9 +453,9 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 		++i;
 	}
 
-	if (i < fr_pool->fastreg.pool_size)
+	if (i < fr_pool->size)
 		iser_warn("pool still has %d regions registered\n",
-			  fr_pool->fastreg.pool_size - i);
+			  fr_pool->size - i);
 }
 
 /**
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

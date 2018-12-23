From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 4/5] RDMA/mlx5: Embed into the code flow the ODP config option
Date: Sun, 23 Dec 2018 11:14:17 +0200
Message-ID: <20181223091418.26218-5-leon@kernel.org>
References: <20181223091418.26218-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181223091418.26218-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Convert various places to more readable code, which embeds
CONFIG_INFINIBAND_ON_DEMAND_PAGING into the code flow.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c |  3 --
 drivers/infiniband/hw/mlx5/main.c    | 41 ++++++++++++++--------------
 drivers/infiniband/hw/mlx5/mem.c     |  5 +---
 drivers/infiniband/hw/mlx5/mr.c      | 16 +++++------
 include/rdma/ib_umem_odp.h           | 26 +++++++++---------
 5 files changed, 41 insertions(+), 50 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 549d9eedf62e..d4f1a2ef5015 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -234,14 +234,11 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
 	ucontext->closing = false;
 	ucontext->cleanup_retryable = false;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	mutex_init(&ucontext->per_mm_list_lock);
 	INIT_LIST_HEAD(&ucontext->per_mm_list);
 	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
 		ucontext->invalidate_range = NULL;
 
-#endif
-
 	resp.num_comp_vectors = file->device->num_comp_vectors;
 
 	ret = get_unused_fd_flags(O_CLOEXEC);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c98343e50a00..9f5f0c638663 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1763,9 +1763,9 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (err)
 		goto out_sys_pages;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	context->ibucontext.invalidate_range = &mlx5_ib_invalidate_range;
-#endif
+	if (ibdev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING)
+		context->ibucontext.invalidate_range =
+			&mlx5_ib_invalidate_range;
 
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
 		err = mlx5_ib_devx_create(dev, true);
@@ -1897,12 +1897,10 @@ static int mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	struct mlx5_ib_dev *dev = to_mdev(ibcontext->device);
 	struct mlx5_bfreg_info *bfregi;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	/* All umem's must be destroyed before destroying the ucontext. */
 	mutex_lock(&ibcontext->per_mm_list_lock);
 	WARN_ON(!list_empty(&ibcontext->per_mm_list));
 	mutex_unlock(&ibcontext->per_mm_list_lock);
-#endif
 
 	bfregi = &context->bfregi;
 	mlx5_ib_dealloc_transport_domain(dev, context->tdn, context->devx_uid);
@@ -5722,11 +5720,11 @@ static struct ib_counters *mlx5_ib_create_counters(struct ib_device *device,
 void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 {
 	mlx5_ib_cleanup_multiport_master(dev);
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	cleanup_srcu_struct(&dev->mr_srcu);
-	drain_workqueue(dev->advise_mr_wq);
-	destroy_workqueue(dev->advise_mr_wq);
-#endif
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
+		cleanup_srcu_struct(&dev->mr_srcu);
+		drain_workqueue(dev->advise_mr_wq);
+		destroy_workqueue(dev->advise_mr_wq);
+	}
 	kfree(dev->port);
 }
 
@@ -5779,19 +5777,20 @@ int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	spin_lock_init(&dev->memic.memic_lock);
 	dev->memic.dev = mdev;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	dev->advise_mr_wq = alloc_ordered_workqueue("mlx5_ib_advise_mr_wq", 0);
-	if (!dev->advise_mr_wq) {
-		err = -ENOMEM;
-		goto err_mp;
-	}
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
+		dev->advise_mr_wq =
+			alloc_ordered_workqueue("mlx5_ib_advise_mr_wq", 0);
+		if (!dev->advise_mr_wq) {
+			err = -ENOMEM;
+			goto err_mp;
+		}
 
-	err = init_srcu_struct(&dev->mr_srcu);
-	if (err) {
-		destroy_workqueue(dev->advise_mr_wq);
-		goto err_mp;
+		err = init_srcu_struct(&dev->mr_srcu);
+		if (err) {
+			destroy_workqueue(dev->advise_mr_wq);
+			goto err_mp;
+		}
 	}
-#endif
 
 	return 0;
 err_mp:
diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 549234988bb4..9f90be296ee0 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -111,7 +111,6 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,
 	*count = i;
 }
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 static u64 umem_dma_to_mtt(dma_addr_t umem_dma)
 {
 	u64 mtt_entry = umem_dma & ODP_DMA_ADDR_MASK;
@@ -123,7 +122,6 @@ static u64 umem_dma_to_mtt(dma_addr_t umem_dma)
 
 	return mtt_entry;
 }
-#endif
 
 /*
  * Populate the given array with bus addresses from the umem.
@@ -151,7 +149,7 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 	int len;
 	struct scatterlist *sg;
 	int entry;
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+
 	if (umem->is_odp) {
 		WARN_ON(shift != 0);
 		WARN_ON(access_flags != (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE));
@@ -164,7 +162,6 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 		}
 		return;
 	}
-#endif
 
 	i = 0;
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index b861b4a5b0e0..65d07c111d42 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1332,8 +1332,8 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
 		    start, virt_addr, length, access_flags);
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (!start && length == U64_MAX) {
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && !start &&
+	    length == U64_MAX) {
 		if (!(access_flags & IB_ACCESS_ON_DEMAND) ||
 		    !(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 			return ERR_PTR(-EINVAL);
@@ -1343,7 +1343,6 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			return ERR_CAST(mr);
 		return &mr->ibmr;
 	}
-#endif
 
 	err = mr_umem_get(pd, start, length, access_flags, &umem, &npages,
 			   &page_shift, &ncont, &order);
@@ -1404,9 +1403,9 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		}
 	}
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	mr->live = 1;
-#endif
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
+		mr->live = 1;
+
 	return &mr->ibmr;
 error:
 	ib_umem_release(umem);
@@ -1521,9 +1520,8 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		}
 
 		mr->allocated_from_cache = 0;
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-		mr->live = 1;
-#endif
+		if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
+			mr->live = 1;
 	} else {
 		/*
 		 * Send a UMR WQE
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 0b1446fe2fab..d3725cf13ecd 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -83,6 +83,19 @@ static inline struct ib_umem_odp *to_ib_umem_odp(struct ib_umem *umem)
 	return container_of(umem, struct ib_umem_odp, umem);
 }
 
+/*
+ * The lower 2 bits of the DMA address signal the R/W permissions for
+ * the entry. To upgrade the permissions, provide the appropriate
+ * bitmask to the map_dma_pages function.
+ *
+ * Be aware that upgrading a mapped address might result in change of
+ * the DMA address for the page.
+ */
+#define ODP_READ_ALLOWED_BIT  (1<<0ULL)
+#define ODP_WRITE_ALLOWED_BIT (1<<1ULL)
+
+#define ODP_DMA_ADDR_MASK (~(ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT))
+
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 
 struct ib_ucontext_per_mm {
@@ -107,19 +120,6 @@ struct ib_umem_odp *ib_alloc_odp_umem(struct ib_ucontext_per_mm *per_mm,
 				      unsigned long addr, size_t size);
 void ib_umem_odp_release(struct ib_umem_odp *umem_odp);
 
-/*
- * The lower 2 bits of the DMA address signal the R/W permissions for
- * the entry. To upgrade the permissions, provide the appropriate
- * bitmask to the map_dma_pages function.
- *
- * Be aware that upgrading a mapped address might result in change of
- * the DMA address for the page.
- */
-#define ODP_READ_ALLOWED_BIT  (1<<0ULL)
-#define ODP_WRITE_ALLOWED_BIT (1<<1ULL)
-
-#define ODP_DMA_ADDR_MASK (~(ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT))
-
 int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 start_offset,
 			      u64 bcnt, u64 access_mask,
 			      unsigned long current_seq);
-- 
2.19.1

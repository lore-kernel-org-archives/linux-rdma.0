From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 3/5] RDMA/mlx5: Introduce and reuse helper to identify ODP MR
Date: Sun, 23 Dec 2018 11:14:16 +0200
Message-ID: <20181223091418.26218-4-leon@kernel.org>
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

Consolidate various checks if MR is ODP backed to one simple
helper and update call sites to use it.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 10 ++++++++++
 drivers/infiniband/hw/mlx5/mr.c      | 29 ++++++----------------------
 drivers/infiniband/hw/mlx5/odp.c     |  6 +++---
 3 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 58efcbd596fd..6563e531fdc2 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -36,6 +36,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <rdma/ib_verbs.h>
+#include <rdma/ib_umem.h>
 #include <rdma/ib_smi.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/cq.h>
@@ -589,6 +590,12 @@ struct mlx5_ib_mr {
 	wait_queue_head_t       q_leaf_free;
 };
 
+static inline bool is_odp_mr(struct mlx5_ib_mr *mr)
+{
+	return IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && mr->umem &&
+	       mr->umem->is_odp;
+}
+
 struct mlx5_ib_mw {
 	struct ib_mw		ibmw;
 	struct mlx5_core_mkey	mmkey;
@@ -1212,6 +1219,9 @@ mlx5_ib_advise_mr_prefetch(struct ib_pd *pd,
 {
 	return -EOPNOTSUPP;
 }
+static inline void mlx5_ib_invalidate_range(struct ib_umem_odp *umem_odp,
+					    unsigned long start,
+					    unsigned long end){};
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 
 /* Needed for rep profile */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1bd8c1b1dba1..b861b4a5b0e0 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -71,11 +71,9 @@ static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	int err = mlx5_core_destroy_mkey(dev->mdev, &mr->mmkey);
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	/* Wait until all page fault handlers using the mr complete. */
-	if (mr->umem && mr->umem->is_odp)
+	if (is_odp_mr(mr))
 		synchronize_srcu(&dev->mr_srcu);
-#endif
 
 	return err;
 }
@@ -96,10 +94,9 @@ static bool use_umr_mtt_update(struct mlx5_ib_mr *mr, u64 start, u64 length)
 		length + (start & (MLX5_ADAPTER_PAGE_SIZE - 1));
 }
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 static void update_odp_mr(struct mlx5_ib_mr *mr)
 {
-	if (mr->umem->is_odp) {
+	if (is_odp_mr(mr)) {
 		/*
 		 * This barrier prevents the compiler from moving the
 		 * setting of umem->odp_data->private to point to our
@@ -122,7 +119,6 @@ static void update_odp_mr(struct mlx5_ib_mr *mr)
 		smp_wmb();
 	}
 }
-#endif
 
 static void reg_mr_callback(int status, void *context)
 {
@@ -238,9 +234,7 @@ static void remove_keys(struct mlx5_ib_dev *dev, int c, int num)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent = &cache->ent[c];
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	bool odp_mkey_exist = false;
-#endif
 	struct mlx5_ib_mr *tmp_mr;
 	struct mlx5_ib_mr *mr;
 	LIST_HEAD(del_list);
@@ -253,10 +247,8 @@ static void remove_keys(struct mlx5_ib_dev *dev, int c, int num)
 			break;
 		}
 		mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-		if (mr->umem && mr->umem->is_odp)
+		if (is_odp_mr(mr))
 			odp_mkey_exist = true;
-#endif
 		list_move(&mr->list, &del_list);
 		ent->cur--;
 		ent->size--;
@@ -264,10 +256,8 @@ static void remove_keys(struct mlx5_ib_dev *dev, int c, int num)
 		mlx5_core_destroy_mkey(dev->mdev, &mr->mmkey);
 	}
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (odp_mkey_exist)
 		synchronize_srcu(&dev->mr_srcu);
-#endif
 
 	list_for_each_entry_safe(mr, tmp_mr, &del_list, list) {
 		list_del(&mr->list);
@@ -594,7 +584,7 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 			break;
 		}
 		mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-		if (mr->umem && mr->umem->is_odp)
+		if (is_odp_mr(mr))
 			odp_mkey_exist = true;
 		list_move(&mr->list, &del_list);
 		ent->cur--;
@@ -603,10 +593,8 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 		mlx5_core_destroy_mkey(dev->mdev, &mr->mmkey);
 	}
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (odp_mkey_exist)
 		synchronize_srcu(&dev->mr_srcu);
-#endif
 
 	list_for_each_entry_safe(mr, tmp_mr, &del_list, list) {
 		list_del(&mr->list);
@@ -1399,9 +1387,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->umem = umem;
 	set_mr_fields(dev, mr, npages, length, access_flags);
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	update_odp_mr(mr);
-#endif
 
 	if (!populate_mtts) {
 		int update_xlt_flags = MLX5_IB_UPD_XLT_ENABLE;
@@ -1566,9 +1552,7 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 
 	set_mr_fields(dev, mr, npages, len, access_flags);
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	update_odp_mr(mr);
-#endif
 	return 0;
 
 err:
@@ -1654,8 +1638,7 @@ static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	int npages = mr->npages;
 	struct ib_umem *umem = mr->umem;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (umem && umem->is_odp) {
+	if (is_odp_mr(mr)) {
 		struct ib_umem_odp *umem_odp = to_ib_umem_odp(umem);
 
 		/* Prevent new page faults from succeeding */
@@ -1679,7 +1662,7 @@ static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 		/* Avoid double-freeing the umem. */
 		umem = NULL;
 	}
-#endif
+
 	clean_mr(dev, mr);
 
 	/*
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 80fa2438db8f..86c64c3468df 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -103,7 +103,7 @@ static int check_parent(struct ib_umem_odp *odp,
 
 struct ib_ucontext_per_mm *mr_to_per_mm(struct mlx5_ib_mr *mr)
 {
-	if (WARN_ON(!mr || !mr->umem || !mr->umem->is_odp))
+	if (WARN_ON(!mr || !is_odp_mr(mr)))
 		return NULL;
 
 	return to_ib_umem_odp(mr->umem)->per_mm;
@@ -740,12 +740,12 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev, u32 key,
 			goto srcu_unlock;
 		}
 
-		if (prefetch && !mr->umem->is_odp) {
+		if (prefetch && !is_odp_mr(mr)) {
 			ret = -EINVAL;
 			goto srcu_unlock;
 		}
 
-		if (!mr->umem->is_odp) {
+		if (!is_odp_mr(mr)) {
 			mlx5_ib_dbg(dev, "skipping non ODP MR (lkey=0x%06x) in page fault handler.\n",
 				    key);
 			if (bytes_mapped)
-- 
2.19.1

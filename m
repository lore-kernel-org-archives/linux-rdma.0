From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 2/8] IB/mlx5: Enable UMR for MRs created with reg_create
Date: Thu, 17 Aug 2017 15:52:29 +0300
Message-ID: <20170817125235.5107-3-leon@kernel.org>
References: <20170817125235.5107-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125235.5107-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch is the first step in decoupling UMR usage and
allocation from the MR cache. The only functional change
in this patch is to enables UMR for MRs created with
reg_create.

This change fixes a bug where ODP memory regions that
were not allocated from the MR cache did not have UMR
enabled.

Signed-off-by: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 33 ++++++++++++++-------------------
 include/linux/mlx5/driver.h          |  2 +-
 3 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 76a731f39d2b..189e80cd6b2f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -508,7 +508,7 @@ struct mlx5_ib_mr {
 	struct mlx5_shared_mr_info	*smr_info;
 	struct list_head	list;
 	int			order;
-	int			umred;
+	bool			allocated_from_cache;
 	int			npages;
 	struct mlx5_ib_dev     *dev;
 	u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index a0eb2f96179a..bc87016021e3 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -48,8 +48,7 @@ enum {
 #define MLX5_UMR_ALIGN 2048
 
 static int clean_mr(struct mlx5_ib_mr *mr);
-static int max_umr_order(struct mlx5_ib_dev *dev);
-static int use_umr(struct mlx5_ib_dev *dev, int order);
+static int mr_cache_max_order(struct mlx5_ib_dev *dev);
 static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 
 static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
@@ -184,7 +183,7 @@ static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
 			break;
 		}
 		mr->order = ent->order;
-		mr->umred = 1;
+		mr->allocated_from_cache = 1;
 		mr->dev = dev;
 
 		MLX5_SET(mkc, mkc, free, 1);
@@ -497,7 +496,7 @@ static struct mlx5_ib_mr *alloc_cached_mr(struct mlx5_ib_dev *dev, int order)
 	int i;
 
 	c = order2idx(dev, order);
-	last_umr_cache_entry = order2idx(dev, max_umr_order(dev));
+	last_umr_cache_entry = order2idx(dev, mr_cache_max_order(dev));
 	if (c < 0 || c > last_umr_cache_entry) {
 		mlx5_ib_warn(dev, "order %d, cache index %d\n", order, c);
 		return NULL;
@@ -677,12 +676,12 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
 		queue_work(cache->wq, &ent->work);
 
-		if (i > MAX_UMR_CACHE_ENTRY) {
+		if (i > MR_CACHE_LAST_STD_ENTRY) {
 			mlx5_odp_init_mr_cache_entry(ent);
 			continue;
 		}
 
-		if (!use_umr(dev, ent->order))
+		if (ent->order > mr_cache_max_order(dev))
 			continue;
 
 		ent->page = PAGE_SHIFT;
@@ -819,18 +818,13 @@ static int get_octo_len(u64 addr, u64 len, int page_size)
 	return (npages + 1) / 2;
 }
 
-static int max_umr_order(struct mlx5_ib_dev *dev)
+static int mr_cache_max_order(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
-		return MAX_UMR_CACHE_ENTRY + 2;
+		return MR_CACHE_LAST_STD_ENTRY + 2;
 	return MLX5_MAX_UMR_SHIFT;
 }
 
-static int use_umr(struct mlx5_ib_dev *dev, int order)
-{
-	return order <= max_umr_order(dev);
-}
-
 static int mr_umem_get(struct ib_pd *pd, u64 start, u64 length,
 		       int access_flags, struct ib_umem **umem,
 		       int *npages, int *page_shift, int *ncont,
@@ -1149,6 +1143,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 	MLX5_SET(mkc, mkc, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
 	MLX5_SET(mkc, mkc, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, mkc, lr, 1);
+	MLX5_SET(mkc, mkc, umr_en, 1);
 
 	MLX5_SET64(mkc, mkc, start_addr, virt_addr);
 	MLX5_SET64(mkc, mkc, len, length);
@@ -1231,7 +1226,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
         if (err < 0)
 		return ERR_PTR(err);
 
-	if (use_umr(dev, order)) {
+	if (order <= mr_cache_max_order(dev)) {
 		mr = reg_umr(pd, umem, virt_addr, length, ncont, page_shift,
 			     order, access_flags);
 		if (PTR_ERR(mr) == -EAGAIN) {
@@ -1355,7 +1350,7 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		/*
 		 * UMR can't be used - MKey needs to be replaced.
 		 */
-		if (mr->umred) {
+		if (mr->allocated_from_cache) {
 			err = unreg_umr(dev, mr);
 			if (err)
 				mlx5_ib_warn(dev, "Failed to unregister MR\n");
@@ -1373,7 +1368,7 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		if (IS_ERR(mr))
 			return PTR_ERR(mr);
 
-		mr->umred = 0;
+		mr->allocated_from_cache = 0;
 	} else {
 		/*
 		 * Send a UMR WQE
@@ -1461,7 +1456,7 @@ mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 static int clean_mr(struct mlx5_ib_mr *mr)
 {
 	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
-	int umred = mr->umred;
+	int allocated_from_cache = mr->allocated_from_cache;
 	int err;
 
 	if (mr->sig) {
@@ -1479,7 +1474,7 @@ static int clean_mr(struct mlx5_ib_mr *mr)
 
 	mlx5_free_priv_descs(mr);
 
-	if (!umred) {
+	if (!allocated_from_cache) {
 		err = destroy_mkey(dev, mr);
 		if (err) {
 			mlx5_ib_warn(dev, "failed to destroy mkey 0x%x (%d)\n",
@@ -1490,7 +1485,7 @@ static int clean_mr(struct mlx5_ib_mr *mr)
 		mlx5_mr_cache_free(dev, mr);
 	}
 
-	if (!umred)
+	if (!allocated_from_cache)
 		kfree(mr);
 
 	return 0;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f17e51a4ef94..1640de3200b8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1099,7 +1099,7 @@ enum {
 };
 
 enum {
-	MAX_UMR_CACHE_ENTRY = 20,
+	MR_CACHE_LAST_STD_ENTRY = 20,
 	MLX5_IMR_MTT_CACHE_ENTRY,
 	MLX5_IMR_KSM_CACHE_ENTRY,
 	MAX_MR_CACHE_ENTRIES
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

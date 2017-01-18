From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/6] IB/mlx5: Expose MR cache for mlx5_ib
Date: Wed, 18 Jan 2017 16:58:10 +0200
Message-ID: <20170118145811.9136-6-leon@kernel.org>
References: <20170118145811.9136-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118145811.9136-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allow other parts of mlx5_ib to use MR cache mechanism.
* Add new functions mlx5_mr_cache_alloc and mlx5_mr_cache_free
* Traditional MTT MKey buckets are limited by MAX_UMR_CACHE_ENTRY
  Additinal buckets may be added above.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  9 +++-
 drivers/infiniband/hw/mlx5/mr.c      | 99 ++++++++++++++++++++++++++----------
 include/linux/mlx5/driver.h          |  3 +-
 3 files changed, 82 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e1a4b93d..0eda2de 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -535,6 +535,10 @@ struct mlx5_cache_ent {
 	struct dentry	       *dir;
 	char                    name[4];
 	u32                     order;
+	u32			xlt;
+	u32			access_mode;
+	u32			page;
+
 	u32			size;
 	u32                     cur;
 	u32                     miss;
@@ -549,6 +553,7 @@ struct mlx5_cache_ent {
 	struct work_struct	work;
 	struct delayed_work	dwork;
 	int			pending;
+	struct completion	compl;
 };
 
 struct mlx5_mr_cache {
@@ -824,7 +829,9 @@ void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
 int mlx5_ib_get_cqe_size(struct mlx5_ib_dev *dev, struct ib_cq *ibcq);
 int mlx5_mr_cache_init(struct mlx5_ib_dev *dev);
 int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev);
-int mlx5_mr_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift);
+
+struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev, int entry);
+void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 			    struct ib_mr_status *mr_status);
 struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 8cf2a67..8f5b94d 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -49,6 +49,7 @@ enum {
 
 static int clean_mr(struct mlx5_ib_mr *mr);
 static int use_umr(struct mlx5_ib_dev *dev, int order);
+static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 
 static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
@@ -149,6 +150,9 @@ static void reg_mr_callback(int status, void *context)
 	if (err)
 		pr_err("Error inserting to mkey tree. 0x%x\n", -err);
 	write_unlock_irqrestore(&table->lock, flags);
+
+	if (!completion_done(&ent->compl))
+		complete(&ent->compl);
 }
 
 static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
@@ -157,7 +161,6 @@ static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
 	struct mlx5_cache_ent *ent = &cache->ent[c];
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	struct mlx5_ib_mr *mr;
-	int npages = 1 << ent->order;
 	void *mkc;
 	u32 *in;
 	int err = 0;
@@ -185,11 +188,11 @@ static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
 
 		MLX5_SET(mkc, mkc, free, 1);
 		MLX5_SET(mkc, mkc, umr_en, 1);
-		MLX5_SET(mkc, mkc, access_mode, MLX5_MKC_ACCESS_MODE_MTT);
+		MLX5_SET(mkc, mkc, access_mode, ent->access_mode);
 
 		MLX5_SET(mkc, mkc, qpn, 0xffffff);
-		MLX5_SET(mkc, mkc, translations_octword_size, (npages + 1) / 2);
-		MLX5_SET(mkc, mkc, log_page_size, 12);
+		MLX5_SET(mkc, mkc, translations_octword_size, ent->xlt);
+		MLX5_SET(mkc, mkc, log_page_size, ent->page);
 
 		spin_lock_irq(&ent->lock);
 		ent->pending++;
@@ -447,6 +450,42 @@ static void cache_work_func(struct work_struct *work)
 	__cache_work_func(ent);
 }
 
+struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev, int entry)
+{
+	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_cache_ent *ent;
+	struct mlx5_ib_mr *mr;
+	int err;
+
+	if (entry < 0 || entry >= MAX_MR_CACHE_ENTRIES) {
+		mlx5_ib_err(dev, "cache entry %d is out of range\n", entry);
+		return NULL;
+	}
+
+	ent = &cache->ent[entry];
+	while (1) {
+		spin_lock_irq(&ent->lock);
+		if (list_empty(&ent->head)) {
+			spin_unlock_irq(&ent->lock);
+
+			err = add_keys(dev, entry, 1);
+			if (err)
+				return ERR_PTR(err);
+
+			wait_for_completion(&ent->compl);
+		} else {
+			mr = list_first_entry(&ent->head, struct mlx5_ib_mr,
+					      list);
+			list_del(&mr->list);
+			ent->cur--;
+			spin_unlock_irq(&ent->lock);
+			if (ent->cur < ent->limit)
+				queue_work(cache->wq, &ent->work);
+			return mr;
+		}
+	}
+}
+
 static struct mlx5_ib_mr *alloc_cached_mr(struct mlx5_ib_dev *dev, int order)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
@@ -456,12 +495,12 @@ static struct mlx5_ib_mr *alloc_cached_mr(struct mlx5_ib_dev *dev, int order)
 	int i;
 
 	c = order2idx(dev, order);
-	if (c < 0 || c >= MAX_MR_CACHE_ENTRIES) {
+	if (c < 0 || c > MAX_UMR_CACHE_ENTRY) {
 		mlx5_ib_warn(dev, "order %d, cache index %d\n", order, c);
 		return NULL;
 	}
 
-	for (i = c; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = c; i < MAX_UMR_CACHE_ENTRY; i++) {
 		ent = &cache->ent[i];
 
 		mlx5_ib_dbg(dev, "order %d, cache index %d\n", ent->order, i);
@@ -488,7 +527,7 @@ static struct mlx5_ib_mr *alloc_cached_mr(struct mlx5_ib_dev *dev, int order)
 	return mr;
 }
 
-static void free_cached_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
+void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
@@ -500,6 +539,10 @@ static void free_cached_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 		mlx5_ib_warn(dev, "order %d, cache index %d\n", mr->order, c);
 		return;
 	}
+
+	if (unreg_umr(dev, mr))
+		return;
+
 	ent = &cache->ent[c];
 	spin_lock_irq(&ent->lock);
 	list_add_tail(&mr->list, &ent->head);
@@ -602,7 +645,6 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
-	int limit;
 	int err;
 	int i;
 
@@ -615,26 +657,33 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 
 	setup_timer(&dev->delay_timer, delay_time_func, (unsigned long)dev);
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
-		INIT_LIST_HEAD(&cache->ent[i].head);
-		spin_lock_init(&cache->ent[i].lock);
-
 		ent = &cache->ent[i];
 		INIT_LIST_HEAD(&ent->head);
 		spin_lock_init(&ent->lock);
 		ent->order = i + 2;
 		ent->dev = dev;
+		ent->limit = 0;
 
-		if ((dev->mdev->profile->mask & MLX5_PROF_MASK_MR_CACHE) &&
-		    mlx5_core_is_pf(dev->mdev) &&
-		    use_umr(dev, ent->order))
-			limit = dev->mdev->profile->mr_cache[i].limit;
-		else
-			limit = 0;
-
+		init_completion(&ent->compl);
 		INIT_WORK(&ent->work, cache_work_func);
 		INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
-		ent->limit = limit;
 		queue_work(cache->wq, &ent->work);
+
+		if (i > MAX_UMR_CACHE_ENTRY)
+			continue;
+
+		if (!use_umr(dev, ent->order))
+			continue;
+
+		ent->page = PAGE_SHIFT;
+		ent->xlt = (1 << ent->order) * sizeof(struct mlx5_mtt) /
+			   MLX5_IB_UMR_OCTOWORD;
+		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
+		if ((dev->mdev->profile->mask & MLX5_PROF_MASK_MR_CACHE) &&
+		    mlx5_core_is_pf(dev->mdev))
+			ent->limit = dev->mdev->profile->mr_cache[i].limit;
+		else
+			ent->limit = 0;
 	}
 
 	err = mlx5_mr_cache_debugfs_init(dev);
@@ -758,7 +807,7 @@ static int get_octo_len(u64 addr, u64 len, int page_size)
 static int use_umr(struct mlx5_ib_dev *dev, int order)
 {
 	if (MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
-		return order < MAX_MR_CACHE_ENTRIES + 2;
+		return order <= MAX_UMR_CACHE_ENTRY + 2;
 	return order <= MLX5_MAX_UMR_SHIFT;
 }
 
@@ -871,7 +920,7 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 				 MLX5_IB_UPD_XLT_ENABLE);
 
 	if (err) {
-		free_cached_mr(dev, mr);
+		mlx5_mr_cache_free(dev, mr);
 		return ERR_PTR(err);
 	}
 
@@ -1091,6 +1140,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 		goto err_2;
 	}
 	mr->mmkey.type = MLX5_MKEY_MR;
+	mr->desc_size = sizeof(struct mlx5_mtt);
 	mr->umem = umem;
 	mr->dev = dev;
 	mr->live = 1;
@@ -1398,12 +1448,7 @@ static int clean_mr(struct mlx5_ib_mr *mr)
 			return err;
 		}
 	} else {
-		err = unreg_umr(dev, mr);
-		if (err) {
-			mlx5_ib_warn(dev, "failed unregister\n");
-			return err;
-		}
-		free_cached_mr(dev, mr);
+		mlx5_mr_cache_free(dev, mr);
 	}
 
 	if (!umred)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 10e6325..a78ee73 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1052,7 +1052,8 @@ enum {
 };
 
 enum {
-	MAX_MR_CACHE_ENTRIES    = 21,
+	MAX_UMR_CACHE_ENTRY = 20,
+	MAX_MR_CACHE_ENTRIES
 };
 
 enum {
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

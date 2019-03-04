From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] mellanox: Switch to bitmap_zalloc()
Date: Mon,  4 Mar 2019 10:57:00 +0200
Message-ID: <20190304085700.88095-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, linux-rdma@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-rdma@vger.kernel.org

Switch to bitmap_zalloc() to show clearly what we are allocating.
Besides that it returns pointer of bitmap type instead of opaque void *.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/mellanox/mlx4/alloc.c         |  5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |  9 +++------
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |  5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/uar.c      | 12 ++++++------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c |  7 +++----
 5 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/alloc.c b/drivers/net/ethernet/mellanox/mlx4/alloc.c
index dbc483e4a2ef..b330020dc0d6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx4/alloc.c
@@ -185,8 +185,7 @@ int mlx4_bitmap_init(struct mlx4_bitmap *bitmap, u32 num, u32 mask,
 	bitmap->avail = num - reserved_top - reserved_bot;
 	bitmap->effective_len = bitmap->avail;
 	spin_lock_init(&bitmap->lock);
-	bitmap->table = kcalloc(BITS_TO_LONGS(bitmap->max), sizeof(long),
-				GFP_KERNEL);
+	bitmap->table = bitmap_zalloc(bitmap->max, GFP_KERNEL);
 	if (!bitmap->table)
 		return -ENOMEM;
 
@@ -197,7 +196,7 @@ int mlx4_bitmap_init(struct mlx4_bitmap *bitmap, u32 num, u32 mask,
 
 void mlx4_bitmap_cleanup(struct mlx4_bitmap *bitmap)
 {
-	kfree(bitmap->table);
+	bitmap_free(bitmap->table);
 }
 
 struct mlx4_zone_allocator {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index 421b9c3c8bf7..9008e17126db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -186,10 +186,7 @@ static struct mlx5_db_pgdir *mlx5_alloc_db_pgdir(struct mlx5_core_dev *dev,
 	if (!pgdir)
 		return NULL;
 
-	pgdir->bitmap = kcalloc(BITS_TO_LONGS(db_per_page),
-				sizeof(unsigned long),
-				GFP_KERNEL);
-
+	pgdir->bitmap = bitmap_zalloc(db_per_page, GFP_KERNEL);
 	if (!pgdir->bitmap) {
 		kfree(pgdir);
 		return NULL;
@@ -200,7 +197,7 @@ static struct mlx5_db_pgdir *mlx5_alloc_db_pgdir(struct mlx5_core_dev *dev,
 	pgdir->db_page = mlx5_dma_zalloc_coherent_node(dev, PAGE_SIZE,
 						       &pgdir->db_dma, node);
 	if (!pgdir->db_page) {
-		kfree(pgdir->bitmap);
+		bitmap_free(pgdir->bitmap);
 		kfree(pgdir);
 		return NULL;
 	}
@@ -280,7 +277,7 @@ void mlx5_db_free(struct mlx5_core_dev *dev, struct mlx5_db *db)
 		dma_free_coherent(&(dev->pdev->dev), PAGE_SIZE,
 				  db->u.pgdir->db_page, db->u.pgdir->db_dma);
 		list_del(&db->u.pgdir->list);
-		kfree(db->u.pgdir->bitmap);
+		bitmap_free(db->u.pgdir->bitmap);
 		kfree(db->u.pgdir);
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
index 98359559c77e..a71d5b9c7ab2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
@@ -108,8 +108,7 @@ int mlx5_mpfs_init(struct mlx5_core_dev *dev)
 
 	mutex_init(&mpfs->lock);
 	mpfs->size   = l2table_size;
-	mpfs->bitmap = kcalloc(BITS_TO_LONGS(l2table_size),
-			       sizeof(uintptr_t), GFP_KERNEL);
+	mpfs->bitmap = bitmap_zalloc(l2table_size, GFP_KERNEL);
 	if (!mpfs->bitmap) {
 		kfree(mpfs);
 		return -ENOMEM;
@@ -127,7 +126,7 @@ void mlx5_mpfs_cleanup(struct mlx5_core_dev *dev)
 		return;
 
 	WARN_ON(!hlist_empty(mpfs->hash));
-	kfree(mpfs->bitmap);
+	bitmap_free(mpfs->bitmap);
 	kfree(mpfs);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/uar.c b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
index 8b97066dd1f1..94464723ff77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/uar.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
@@ -90,8 +90,8 @@ static void up_rel_func(struct kref *kref)
 	iounmap(up->map);
 	if (mlx5_cmd_free_uar(up->mdev, up->index))
 		mlx5_core_warn(up->mdev, "failed to free uar index %d\n", up->index);
-	kfree(up->reg_bitmap);
-	kfree(up->fp_bitmap);
+	bitmap_free(up->reg_bitmap);
+	bitmap_free(up->fp_bitmap);
 	kfree(up);
 }
 
@@ -110,11 +110,11 @@ static struct mlx5_uars_page *alloc_uars_page(struct mlx5_core_dev *mdev,
 		return ERR_PTR(err);
 
 	up->mdev = mdev;
-	up->reg_bitmap = kcalloc(BITS_TO_LONGS(bfregs), sizeof(unsigned long), GFP_KERNEL);
+	up->reg_bitmap = bitmap_zalloc(bfregs, GFP_KERNEL);
 	if (!up->reg_bitmap)
 		goto error1;
 
-	up->fp_bitmap = kcalloc(BITS_TO_LONGS(bfregs), sizeof(unsigned long), GFP_KERNEL);
+	up->fp_bitmap = bitmap_zalloc(bfregs, GFP_KERNEL);
 	if (!up->fp_bitmap)
 		goto error1;
 
@@ -157,8 +157,8 @@ static struct mlx5_uars_page *alloc_uars_page(struct mlx5_core_dev *mdev,
 	if (mlx5_cmd_free_uar(mdev, up->index))
 		mlx5_core_warn(mdev, "failed to free uar index %d\n", up->index);
 error1:
-	kfree(up->fp_bitmap);
-	kfree(up->reg_bitmap);
+	bitmap_free(up->fp_bitmap);
+	bitmap_free(up->reg_bitmap);
 	kfree(up);
 	return ERR_PTR(err);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 9d9aa28684af..46baf3b44309 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -1188,8 +1188,7 @@ static int mlxsw_sp_fid_family_register(struct mlxsw_sp *mlxsw_sp,
 
 	fid_family->mlxsw_sp = mlxsw_sp;
 	INIT_LIST_HEAD(&fid_family->fids_list);
-	fid_family->fids_bitmap = kcalloc(BITS_TO_LONGS(nr_fids),
-					  sizeof(unsigned long), GFP_KERNEL);
+	fid_family->fids_bitmap = bitmap_zalloc(nr_fids, GFP_KERNEL);
 	if (!fid_family->fids_bitmap) {
 		err = -ENOMEM;
 		goto err_alloc_fids_bitmap;
@@ -1206,7 +1205,7 @@ static int mlxsw_sp_fid_family_register(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_fid_flood_tables_init:
-	kfree(fid_family->fids_bitmap);
+	bitmap_free(fid_family->fids_bitmap);
 err_alloc_fids_bitmap:
 	kfree(fid_family);
 	return err;
@@ -1217,7 +1216,7 @@ mlxsw_sp_fid_family_unregister(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_fid_family *fid_family)
 {
 	mlxsw_sp->fid_core->fid_family_arr[fid_family->type] = NULL;
-	kfree(fid_family->fids_bitmap);
+	bitmap_free(fid_family->fids_bitmap);
 	WARN_ON_ONCE(!list_empty(&fid_family->fids_list));
 	kfree(fid_family);
 }
-- 
2.20.1

From: yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Subject: [PATCH V2] net/mlx4_core: enable 8TB of memory registration
Date: Tue,  7 Aug 2012 15:34:38 +0300
Message-ID: <1344342878-32650-1-git-send-email-yishaih@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch solves below issue:
Fix the mlx4 core limitation of log num mtt higher than 28.
- There were some int overflows which were fixed to enable using 31.

- When we auto scaling number of MTTs with the size of the system memory
  we can map 8TB instead of 1TB.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sigend-off-by: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

changes from V1:
mlx4_init_icm_table - use casting in left side to prevent int overflow.



 drivers/net/ethernet/mellanox/mlx4/icm.c     |    9 ++++++---
 drivers/net/ethernet/mellanox/mlx4/icm.h     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |   10 +++-------
 drivers/net/ethernet/mellanox/mlx4/mr.c      |    4 ++--
 drivers/net/ethernet/mellanox/mlx4/profile.c |    6 +++---
 5 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index 88b7b3e..d56784d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.c
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
@@ -358,13 +358,14 @@ void mlx4_table_put_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 }
 
 int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
-			u64 virt, int obj_size,	int nobj, int reserved,
+			u64 virt, int obj_size,	u32 nobj, int reserved,
 			int use_lowmem, int use_coherent)
 {
 	int obj_per_chunk;
 	int num_icm;
 	unsigned chunk_size;
 	int i;
+	u64 size;
 
 	obj_per_chunk = MLX4_TABLE_CHUNK_SIZE / obj_size;
 	num_icm = (nobj + obj_per_chunk - 1) / obj_per_chunk;
@@ -380,10 +381,12 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 	table->coherent = use_coherent;
 	mutex_init(&table->mutex);
 
+	size = (u64)nobj * (u64)obj_size;
 	for (i = 0; i * MLX4_TABLE_CHUNK_SIZE < reserved * obj_size; ++i) {
 		chunk_size = MLX4_TABLE_CHUNK_SIZE;
-		if ((i + 1) * MLX4_TABLE_CHUNK_SIZE > nobj * obj_size)
-			chunk_size = PAGE_ALIGN(nobj * obj_size - i * MLX4_TABLE_CHUNK_SIZE);
+		if ((i + 1) * MLX4_TABLE_CHUNK_SIZE > size)
+			chunk_size = PAGE_ALIGN(size -
+					i * MLX4_TABLE_CHUNK_SIZE);
 
 		table->icm[i] = mlx4_alloc_icm(dev, chunk_size >> PAGE_SHIFT,
 					       (use_lowmem ? GFP_KERNEL : GFP_HIGHUSER) |
diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.h b/drivers/net/ethernet/mellanox/mlx4/icm.h
index 19e4efc..a67744f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.h
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.h
@@ -78,7 +78,7 @@ int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 void mlx4_table_put_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 			  int start, int end);
 int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
-			u64 virt, int obj_size,	int nobj, int reserved,
+			u64 virt, int obj_size,	u32 nobj, int reserved,
 			int use_lowmem, int use_coherent);
 void mlx4_cleanup_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table);
 void *mlx4_table_find(struct mlx4_icm_table *table, int obj, dma_addr_t *dma_handle);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 964e33c..b67b9c4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -59,11 +59,7 @@
 #define MLX4_FS_NUM_OF_L2_ADDR		8
 #define MLX4_FS_MGM_LOG_ENTRY_SIZE	7
 #define MLX4_FS_NUM_MCG			(1 << 17)
-
-/* When a higher value than 28 is used we get a failure via initializing
-     the event queue table as of trying to allocate more than 2GB in ICM.
-*/
-#define MLX4_MAX_LOG_NUM_MTT 28
+#define MLX4_MAX_LOG_NUM_MTT 31
 
 enum {
 	MLX4_FS_L2_HASH = 0,
@@ -254,7 +250,7 @@ struct mlx4_bitmap {
 struct mlx4_buddy {
 	unsigned long	      **bits;
 	unsigned int	       *num_free;
-	int			max_order;
+	u32			max_order;
 	spinlock_t		lock;
 };
 
@@ -263,7 +259,7 @@ struct mlx4_icm;
 struct mlx4_icm_table {
 	u64			virt;
 	int			num_icm;
-	int			num_obj;
+	u32			num_obj;
 	int			obj_size;
 	int			lowmem;
 	int			coherent;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c b/drivers/net/ethernet/mellanox/mlx4/mr.c
index 31f672a..42f6cb6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -677,7 +677,7 @@ int mlx4_init_mr_table(struct mlx4_dev *dev)
 		return err;
 
 	err = mlx4_buddy_init(&mr_table->mtt_buddy,
-			      ilog2(dev->caps.num_mtts /
+			      ilog2((u32)dev->caps.num_mtts /
 			      (1 << log_mtts_per_seg)));
 	if (err)
 		goto err_buddy;
@@ -687,7 +687,7 @@ int mlx4_init_mr_table(struct mlx4_dev *dev)
 			mlx4_alloc_mtt_range(dev,
 					     fls(dev->caps.reserved_mtts - 1));
 		if (priv->reserved_mtts < 0) {
-			mlx4_warn(dev, "MTT table of order %d is too small.\n",
+			mlx4_warn(dev, "MTT table of order %u is too small.\n",
 				  mr_table->mtt_buddy.max_order);
 			err = -ENOMEM;
 			goto err_reserve_mtts;
diff --git a/drivers/net/ethernet/mellanox/mlx4/profile.c b/drivers/net/ethernet/mellanox/mlx4/profile.c
index e3af4f3..0dfb1cc 100644
--- a/drivers/net/ethernet/mellanox/mlx4/profile.c
+++ b/drivers/net/ethernet/mellanox/mlx4/profile.c
@@ -76,7 +76,7 @@ u64 mlx4_make_profile(struct mlx4_dev *dev,
 		u64 size;
 		u64 start;
 		int type;
-		int num;
+		u32 num;
 		int log_num;
 	};
 
@@ -98,8 +98,8 @@ u64 mlx4_make_profile(struct mlx4_dev *dev,
 	 * memory (with PAGE_SIZE entries).
 	 *
 	 * This number has to be a power of two and fit into 32 bits
-	 * due to device limitations, so cap this at 2^28 as well.
-	 * That limits us to 1TB of memory registration per HCA with
+	 * due to device limitations, so cap this at 2^31 as well.
+	 * That limits us to 8TB of memory registration per HCA with
 	 * 4KB pages, which is probably OK for the next few months.
 	 */
 	si_meminfo(&si);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

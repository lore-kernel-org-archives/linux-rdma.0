From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes/for-3.6 3/3] net/mlx4_core: Enable 8TB memory registration
Date: Wed, 29 Aug 2012 18:14:35 +0300
Message-ID: <1346253275-12347-4-git-send-email-ogerlitz@mellanox.com>
References: <1346253275-12347-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346253275-12347-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds on the fixes done in commits 89dd86db78 "Allow large
mlx4_buddy bitmaps" and 3de819e6b "Fix integer overflow issues around
MTT table" such that finally memory registration of up to 8TB
(log_num_mtt=31) works fine.

It handle int overflows in few mlx4_table_yyy routines in icm.c by
using a u64 intermediate variable, and int/uint issues that caused
table indexes to become nagive by setting some variables to be u32
instead of int, these problems turned into crashes that came into
play once a user attempted to register > 512GB of RAM.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/icm.c |   30 ++++++++++++++++++------------
 drivers/net/ethernet/mellanox/mlx4/icm.h |   10 +++++-----
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index daf4179..3e91cb6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.c
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
@@ -227,9 +227,10 @@ int mlx4_UNMAP_ICM_AUX(struct mlx4_dev *dev)
 			MLX4_CMD_TIME_CLASS_B, MLX4_CMD_NATIVE);
 }
 
-int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj)
+int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj)
 {
-	int i = (obj & (table->num_obj - 1)) / (MLX4_TABLE_CHUNK_SIZE / table->obj_size);
+	u32 i = (obj & (table->num_obj - 1)) /
+			(MLX4_TABLE_CHUNK_SIZE / table->obj_size);
 	int ret = 0;
 
 	mutex_lock(&table->mutex);
@@ -262,16 +263,18 @@ out:
 	return ret;
 }
 
-void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj)
+void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj)
 {
-	int i;
+	u32 i;
+	u64 offset;
 
 	i = (obj & (table->num_obj - 1)) / (MLX4_TABLE_CHUNK_SIZE / table->obj_size);
 
 	mutex_lock(&table->mutex);
 
 	if (--table->icm[i]->refcount == 0) {
-		mlx4_UNMAP_ICM(dev, table->virt + i * MLX4_TABLE_CHUNK_SIZE,
+		offset = (u64)i * (u64)MLX4_TABLE_CHUNK_SIZE;
+		mlx4_UNMAP_ICM(dev, table->virt + offset,
 			       MLX4_TABLE_CHUNK_SIZE / MLX4_ICM_PAGE_SIZE);
 		mlx4_free_icm(dev, table->icm[i], table->coherent);
 		table->icm[i] = NULL;
@@ -280,9 +283,11 @@ void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj)
 	mutex_unlock(&table->mutex);
 }
 
-void *mlx4_table_find(struct mlx4_icm_table *table, int obj, dma_addr_t *dma_handle)
+void *mlx4_table_find(struct mlx4_icm_table *table, u32 obj,
+			dma_addr_t *dma_handle)
 {
-	int idx, offset, dma_offset, i;
+	int offset, dma_offset, i;
+	u64 idx;
 	struct mlx4_icm_chunk *chunk;
 	struct mlx4_icm *icm;
 	struct page *page = NULL;
@@ -292,7 +297,7 @@ void *mlx4_table_find(struct mlx4_icm_table *table, int obj, dma_addr_t *dma_han
 
 	mutex_lock(&table->mutex);
 
-	idx = (obj & (table->num_obj - 1)) * table->obj_size;
+	idx = (u64)(obj & (table->num_obj - 1)) * (u64)table->obj_size;
 	icm = table->icm[idx / MLX4_TABLE_CHUNK_SIZE];
 	dma_offset = offset = idx % MLX4_TABLE_CHUNK_SIZE;
 
@@ -326,10 +331,11 @@ out:
 }
 
 int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
-			 int start, int end)
+			 u32 start, u32 end)
 {
 	int inc = MLX4_TABLE_CHUNK_SIZE / table->obj_size;
-	int i, err;
+	int err;
+	u32 i;
 
 	for (i = start; i <= end; i += inc) {
 		err = mlx4_table_get(dev, table, i);
@@ -349,9 +355,9 @@ fail:
 }
 
 void mlx4_table_put_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
-			  int start, int end)
+			  u32 start, u32 end)
 {
-	int i;
+	u32 i;
 
 	for (i = start; i <= end; i += MLX4_TABLE_CHUNK_SIZE / table->obj_size)
 		mlx4_table_put(dev, table, i);
diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.h b/drivers/net/ethernet/mellanox/mlx4/icm.h
index a67744f..dee67fa 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.h
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.h
@@ -71,17 +71,17 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 				gfp_t gfp_mask, int coherent);
 void mlx4_free_icm(struct mlx4_dev *dev, struct mlx4_icm *icm, int coherent);
 
-int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj);
-void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj);
+int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj);
+void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj);
 int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
-			 int start, int end);
+			 u32 start, u32 end);
 void mlx4_table_put_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
-			  int start, int end);
+			  u32 start, u32 end);
 int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 			u64 virt, int obj_size,	u32 nobj, int reserved,
 			int use_lowmem, int use_coherent);
 void mlx4_cleanup_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table);
-void *mlx4_table_find(struct mlx4_icm_table *table, int obj, dma_addr_t *dma_handle);
+void *mlx4_table_find(struct mlx4_icm_table *table, u32 obj, dma_addr_t *dma_handle);
 
 static inline void mlx4_icm_first(struct mlx4_icm *icm,
 				  struct mlx4_icm_iter *iter)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fix V2 2/2] net/mlx4_core: Fix scaling issues related to memory registration
Date: Mon, 13 Aug 2012 11:15:07 +0300
Message-ID: <1344845707-23157-3-git-send-email-ogerlitz@mellanox.com>
References: <1344845707-23157-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344845707-23157-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix some issues around int variables used in data structures
related to memory registration.

Handle int overflow in mlx4_init_icm_table by using a u64 intermediate
variable and changing struct mlx4_icm_table num_obj field to be u32.

Change some more fields/variables to use u32 instead of int to
prevent a case where the variable becomes negative when bit 31 is set.

Also subtract log_mtts_per_seg from the exponent when computing
num_mtt, since its added later on in that very same code area.

This and the previous commit fixes some issues which actually prevent
commit b5a7a65c05 "mlx4_core: Scale size of MTT table with system RAM"
to function properly. Now, when the number of MTTs is scaled with the
size of the RAM we can map up to 8TB.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/icm.c     |    9 ++++++---
 drivers/net/ethernet/mellanox/mlx4/icm.h     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |    4 ++--
 drivers/net/ethernet/mellanox/mlx4/mr.c      |    4 ++--
 drivers/net/ethernet/mellanox/mlx4/profile.c |    4 ++--
 5 files changed, 13 insertions(+), 10 deletions(-)

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
index 59ebc03..4d9df8f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -249,7 +249,7 @@ struct mlx4_bitmap {
 struct mlx4_buddy {
 	unsigned long	      **bits;
 	unsigned int	       *num_free;
-	int			max_order;
+	u32			max_order;
 	spinlock_t		lock;
 };
 
@@ -258,7 +258,7 @@ struct mlx4_icm;
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
index 9ee4725..8e0c3cc 100644
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
 
@@ -105,7 +105,7 @@ u64 mlx4_make_profile(struct mlx4_dev *dev,
 	si_meminfo(&si);
 	request->num_mtt =
 		roundup_pow_of_two(max_t(unsigned, request->num_mtt,
-					 min(1UL << 31,
+					 min(1UL << (31 - log_mtts_per_seg),
 					     si.totalram >> (log_mtts_per_seg - 1))));
 
 	profile[MLX4_RES_QP].size     = dev_cap->qpc_entry_sz;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

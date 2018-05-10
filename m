From: Qing Huang <qing.huang@oracle.com>
Subject: [PATCH] mlx4_core: allocate 4KB ICM chunks
Date: Thu, 10 May 2018 16:31:43 -0700
Message-ID: <20180510233143.7236-1-qing.huang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tariqt@mellanox.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Qing Huang <qing.huang@oracle.com>
List-Id: linux-rdma@vger.kernel.org

When a system is under memory presure (high usage with fragments),
the original 256KB ICM chunk allocations will likely trigger kernel
memory management to enter slow path doing memory compact/migration
ops in order to complete high order memory allocations.

When that happens, user processes calling uverb APIs may get stuck
for more than 120s easily even though there are a lot of free pages
in smaller chunks available in the system.

Syslog:
...
Dec 10 09:04:51 slcc03db02 kernel: [397078.572732] INFO: task
oracle_205573_e:205573 blocked for more than 120 seconds.
...

With 4KB ICM chunk size, the above issue is fixed.

However in order to support 4KB ICM chunk size, we need to fix another
issue in large size kcalloc allocations.

E.g.
Setting log_num_mtt=30 requires 1G mtt entries. With the 4KB ICM chunk
size, each ICM chunk can only hold 512 mtt entries (8 bytes for each mtt
entry). So we need a 16MB allocation for a table->icm pointer array to
hold 2M pointers which can easily cause kcalloc to fail.

The solution is to use vzalloc to replace kcalloc. There is no need
for contiguous memory pages for a driver meta data structure (no need
of DMA ops).

Signed-off-by: Qing Huang <qing.huang@oracle.com>
Acked-by: Daniel Jurgens <danielj@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/icm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index a822f7a..2b17a4b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.c
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
@@ -43,12 +43,12 @@
 #include "fw.h"
 
 /*
- * We allocate in as big chunks as we can, up to a maximum of 256 KB
- * per chunk.
+ * We allocate in 4KB page size chunks to avoid high order memory
+ * allocations in fragmented/high usage memory situation.
  */
 enum {
-	MLX4_ICM_ALLOC_SIZE	= 1 << 18,
-	MLX4_TABLE_CHUNK_SIZE	= 1 << 18
+	MLX4_ICM_ALLOC_SIZE	= 1 << 12,
+	MLX4_TABLE_CHUNK_SIZE	= 1 << 12
 };
 
 static void mlx4_free_icm_pages(struct mlx4_dev *dev, struct mlx4_icm_chunk *chunk)
@@ -400,7 +400,7 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 	obj_per_chunk = MLX4_TABLE_CHUNK_SIZE / obj_size;
 	num_icm = (nobj + obj_per_chunk - 1) / obj_per_chunk;
 
-	table->icm      = kcalloc(num_icm, sizeof(*table->icm), GFP_KERNEL);
+	table->icm      = vzalloc(num_icm * sizeof(*table->icm));
 	if (!table->icm)
 		return -ENOMEM;
 	table->virt     = virt;
@@ -446,7 +446,7 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 			mlx4_free_icm(dev, table->icm[i], use_coherent);
 		}
 
-	kfree(table->icm);
+	vfree(table->icm);
 
 	return -ENOMEM;
 }
@@ -462,5 +462,5 @@ void mlx4_cleanup_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table)
 			mlx4_free_icm(dev, table->icm[i], table->coherent);
 		}
 
-	kfree(table->icm);
+	vfree(table->icm);
 }
-- 
2.9.3

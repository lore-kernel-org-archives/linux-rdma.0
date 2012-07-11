From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/6] net/mlx4_core: Remove double function declarations
Date: Wed, 11 Jul 2012 18:33:43 +0300
Message-ID: <1342020825-18878-5-git-send-email-ogerlitz@mellanox.com>
References: <1342020825-18878-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342020825-18878-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-LDSdmyG8hGU/bZweECJiwQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Spotted four duplicate declarations in icm.h, remove them.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-LDSdmyG8hGU/bZweECJiwQ@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/icm.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.h b/drivers/net/ethernet/mellanox/mlx4/icm.h
index b10c07a..19e4efc 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.h
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.h
@@ -81,13 +81,7 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 			u64 virt, int obj_size,	int nobj, int reserved,
 			int use_lowmem, int use_coherent);
 void mlx4_cleanup_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table);
-int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj);
-void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj);
 void *mlx4_table_find(struct mlx4_icm_table *table, int obj, dma_addr_t *dma_handle);
-int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
-			 int start, int end);
-void mlx4_table_put_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
-			  int start, int end);
 
 static inline void mlx4_icm_first(struct mlx4_icm *icm,
 				  struct mlx4_icm_iter *iter)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

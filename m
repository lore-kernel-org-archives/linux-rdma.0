From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 02/12] net/mlx5: EQ, Remove unused fields and structures
Date: Fri, 16 Nov 2018 13:58:51 -0800
Message-ID: <20181116215901.5874-3-saeedm@mellanox.com>
References: <20181116215901.5874-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116215901.5874-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Some fields and structures are not referenced nor used by the driver,
remove them.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 11 -----------
 include/linux/mlx5/driver.h                  |  3 ---
 2 files changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index aeab0c4f60f4..fd5926daa0a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -78,17 +78,6 @@ enum {
 			       (1ull << MLX5_EVENT_TYPE_SRQ_LAST_WQE)	    | \
 			       (1ull << MLX5_EVENT_TYPE_SRQ_RQ_LIMIT))
 
-struct map_eq_in {
-	u64	mask;
-	u32	reserved;
-	u32	unmap_eqn;
-};
-
-struct cre_des_eq {
-	u8	reserved[15];
-	u8	eqn;
-};
-
 static int mlx5_cmd_destroy_eq(struct mlx5_core_dev *dev, u8 eqn)
 {
 	u32 out[MLX5_ST_SZ_DW(destroy_eq_out)] = {0};
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7d4ed995b4ce..15cf6727a62d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -398,7 +398,6 @@ struct mlx5_eq {
 	unsigned int		irqn;
 	u8			eqn;
 	int			nent;
-	u64			mask;
 	struct list_head	list;
 	int			index;
 	struct mlx5_rsc_debug	*dbg;
@@ -478,8 +477,6 @@ struct mlx5_core_srq {
 };
 
 struct mlx5_eq_table {
-	void __iomem	       *update_ci;
-	void __iomem	       *update_arm_ci;
 	struct list_head	comp_eqs_list;
 	struct mlx5_eq		pages_eq;
 	struct mlx5_eq		async_eq;
-- 
2.19.1

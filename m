From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 09/10] net/mlx5: Remove unused function
Date: Thu,  8 Nov 2018 21:10:16 +0200
Message-ID: <20181108191017.21891-10-leon@kernel.org>
References: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

No callers to the function mlx5_core_page_fault_resume() so it is OK to
delete it.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 16 ----------------
 include/linux/mlx5/driver.h                  |  4 ----
 2 files changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index aeab0c4f60f4..22eabb80e122 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -373,22 +373,6 @@ static int init_pf_ctx(struct mlx5_eq_pagefault *pf_ctx, const char *name)
 	return -ENOMEM;
 }
 
-int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 token,
-				u32 wq_num, u8 type, int error)
-{
-	u32 out[MLX5_ST_SZ_DW(page_fault_resume_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(page_fault_resume_in)]   = {0};
-
-	MLX5_SET(page_fault_resume_in, in, opcode,
-		 MLX5_CMD_OP_PAGE_FAULT_RESUME);
-	MLX5_SET(page_fault_resume_in, in, error, !!error);
-	MLX5_SET(page_fault_resume_in, in, page_fault_type, type);
-	MLX5_SET(page_fault_resume_in, in, wq_number, wq_num);
-	MLX5_SET(page_fault_resume_in, in, token, token);
-
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-}
-EXPORT_SYMBOL_GPL(mlx5_core_page_fault_resume);
 #endif
 
 static void general_event_handler(struct mlx5_core_dev *dev,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 85275612a473..1de1e8e91382 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1141,10 +1141,6 @@ int mlx5_query_odp_caps(struct mlx5_core_dev *dev,
 			struct mlx5_odp_caps *odp_caps);
 int mlx5_core_query_ib_ppcnt(struct mlx5_core_dev *dev,
 			     u8 port_num, void *out, size_t sz);
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 token,
-				u32 wq_num, u8 type, int error);
-#endif
 
 int mlx5_init_rl_table(struct mlx5_core_dev *dev);
 void mlx5_cleanup_rl_table(struct mlx5_core_dev *dev);
-- 
2.19.1

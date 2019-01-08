From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 5/5] RDMA/mlx5: Delete declaration of already removed function
Date: Tue,  8 Jan 2019 08:16:45 +0200
Message-ID: <20190108061645.25226-6-leon@kernel.org>
References: <20190108061645.25226-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190108061645.25226-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The implementation of mlx5_core_page_fault_resume() was removed
in commit d5d284b829a6 ("{net,IB}/mlx5: Move Page fault EQ and
ODP logic to RDMA"). This patch removes declaration too.

Fixes: d5d284b829a6 ("{net,IB}/mlx5: Move Page fault EQ and ODP logic to RDMA")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/driver.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 54299251d40d..b6f5839f129a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -939,10 +939,6 @@ int mlx5_query_odp_caps(struct mlx5_core_dev *dev,
 			struct mlx5_odp_caps *odp_caps);
 int mlx5_core_query_ib_ppcnt(struct mlx5_core_dev *dev,
 			     u8 port_num, void *out, size_t sz);
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 token,
-				u32 wq_num, u8 type, int error);
-#endif

 int mlx5_init_rl_table(struct mlx5_core_dev *dev);
 void mlx5_cleanup_rl_table(struct mlx5_core_dev *dev);

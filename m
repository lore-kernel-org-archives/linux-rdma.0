From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 3/4] net/mlx5: Remove unused MLX5_*_DOORBELL_LOCK macros
Date: Fri, 18 Jan 2019 16:33:12 -0800
Message-ID: <20190119003313.16711-4-saeedm@mellanox.com>
References: <20190119003313.16711-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190119003313.16711-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Maxim Mikityanskiy <maximmi@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

MLX5_*_DOORBELL_LOCK macros provided a way to avoid locking for
mlx5_write64 on 64-bit platforms where it's not necessary. Currently all
calls to mlx5_write64 don't use a spinlock, so the macros became unused.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/doorbell.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/mlx5/doorbell.h b/include/linux/mlx5/doorbell.h
index 0787de28f2fc..9ef3f9d00154 100644
--- a/include/linux/mlx5/doorbell.h
+++ b/include/linux/mlx5/doorbell.h
@@ -42,10 +42,6 @@
  * PCI so we won't worry about it.
  */
 
-#define MLX5_DECLARE_DOORBELL_LOCK(name)
-#define MLX5_INIT_DOORBELL_LOCK(ptr)    do { } while (0)
-#define MLX5_GET_DOORBELL_LOCK(ptr)      (NULL)
-
 static inline void mlx5_write64(__be32 val[2], void __iomem *dest,
 				spinlock_t *doorbell_lock)
 {
@@ -59,10 +55,6 @@ static inline void mlx5_write64(__be32 val[2], void __iomem *dest,
  * MMIO writes.
  */
 
-#define MLX5_DECLARE_DOORBELL_LOCK(name) spinlock_t name;
-#define MLX5_INIT_DOORBELL_LOCK(ptr)     spin_lock_init(ptr)
-#define MLX5_GET_DOORBELL_LOCK(ptr)      (ptr)
-
 static inline void mlx5_write64(__be32 val[2], void __iomem *dest,
 				spinlock_t *doorbell_lock)
 {
-- 
2.20.1

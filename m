From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next] net/mlx5: Fix atomic_mode enum values
Date: Mon,  3 Sep 2018 20:19:28 +0300
Message-ID: <20180903171928.19348-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Moni Shoua <monis@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

The field atomic_mode is 4 bits wide and therefore can hold values
from 0x0 to 0xf. Remove the unnecessary 20 bit shift that made the values
be incorrect. While that, remove unused enum values.

Fixes: 57cda166bbe0 ("net/mlx5: Add DCT command interface")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/driver.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 66c1170500cf..89caed98ef0b 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -163,10 +163,7 @@ enum mlx5_dcbx_oper_mode {
 };
 
 enum mlx5_dct_atomic_mode {
-	MLX5_ATOMIC_MODE_DCT_OFF        = 20,
-	MLX5_ATOMIC_MODE_DCT_NONE       = 0 << MLX5_ATOMIC_MODE_DCT_OFF,
-	MLX5_ATOMIC_MODE_DCT_IB_COMP    = 1 << MLX5_ATOMIC_MODE_DCT_OFF,
-	MLX5_ATOMIC_MODE_DCT_CX         = 2 << MLX5_ATOMIC_MODE_DCT_OFF,
+	MLX5_ATOMIC_MODE_DCT_CX         = 2,
 };
 
 enum {
-- 
2.14.4

From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next] net/mlx5: fix an unused-function warning
Date: Tue, 17 Jul 2018 15:49:48 +0200
Message-ID: <20180717135009.3584984-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Ilya Lesokhin <ilyal@mellanox.com>, Boris Pismenny <borisp@mellanox.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

These dummy helpers are all intended to be inline functions,
but one of them by accident came without the 'inline' keyword,
causing a harmless warning:

In file included from drivers/net/ethernet/mellanox/mlx5/core/main.c:63:
drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h:79:1: error: 'mlx5_accel_tls_add_flow' defined but not used [-Werror=unused-function]
 mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,

Fixes: ab412e1dd7db ("net/mlx5: Accel, add TLS rx offload routines")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
index 2228c1083528..def4093ebfae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -75,7 +75,7 @@ void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev);
 
 #else
 
-static int
+static inline int
 mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
 			struct tls_crypto_info *crypto_info,
 			u32 start_offload_tcp_sn, u32 *p_swid,
-- 
2.9.0

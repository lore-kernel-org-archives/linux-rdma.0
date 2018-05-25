From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH, net-next] net/mlx5e: fix TLS dependency
Date: Fri, 25 May 2018 23:36:06 +0200
Message-ID: <20180525213630.2119214-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Boris Pismenny <borisp@mellanox.com>, Ilan Tayari <ilant@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Ilya Lesokhin <ilyal@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

With CONFIG_TLS=m and MLX5_CORE_EN=y, we get a link failure:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.o: In function `mlx5e_tls_handle_ooo':
tls_rxtx.c:(.text+0x24c): undefined reference to `tls_get_record'
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.o: In function `mlx5e_tls_handle_tx_skb':
tls_rxtx.c:(.text+0x9a8): undefined reference to `tls_device_sk_destruct'

This narrows down the dependency to only allow the configurations
that will actually work. The existing dependency on TLS_DEVICE is
not sufficient here since MLX5_EN_TLS is a 'bool' symbol.

Fixes: c83294b9efa5 ("net/mlx5e: TLS, Add Innova TLS TX support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index ee6684779d11..2545296a0c08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -91,6 +91,7 @@ config MLX5_EN_TLS
 	bool "TLS cryptography-offload accelaration"
 	depends on MLX5_CORE_EN
 	depends on TLS_DEVICE
+	depends on TLS=y || MLX5_CORE=m
 	depends on MLX5_ACCEL
 	default n
 	---help---
-- 
2.9.0

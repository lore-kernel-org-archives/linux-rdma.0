From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 28/41] net/mlx4_en: Fix build break when CONFIG_INET is off
Date: Wed, 12 Dec 2018 23:30:41 -0500
Message-ID: <20181213043054.75891-28-sashal@kernel.org>
References: <20181213043054.75891-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181213043054.75891-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Saeed Mahameed <saeedm@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, "David S . Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

[ Upstream commit 1b603f9e4313348608f256b564ed6e3d9e67f377 ]

MLX4_EN depends on NETDEVICES, ETHERNET and INET Kconfigs.
Make sure they are listed in MLX4_EN Kconfig dependencies.

This fixes the following build break:

drivers/net/ethernet/mellanox/mlx4/en_rx.c:582:18: warning: ‘struct iphdr’ declared inside parameter list [enabled by default]
struct iphdr *iph)
^
drivers/net/ethernet/mellanox/mlx4/en_rx.c:582:18: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
drivers/net/ethernet/mellanox/mlx4/en_rx.c: In function ‘get_fixed_ipv4_csum’:
drivers/net/ethernet/mellanox/mlx4/en_rx.c:586:20: error: dereferencing pointer to incomplete type
_u8 ipproto = iph->protocol;

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/Kconfig b/drivers/net/ethernet/mellanox/mlx4/Kconfig
index 22b1cc012bc9..c1a39be0dbe7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx4/Kconfig
@@ -5,7 +5,7 @@
 config MLX4_EN
 	tristate "Mellanox Technologies 1/10/40Gbit Ethernet support"
 	depends on MAY_USE_DEVLINK
-	depends on PCI
+	depends on PCI && NETDEVICES && ETHERNET && INET
 	select MLX4_CORE
 	imply PTP_1588_CLOCK
 	---help---
-- 
2.19.1

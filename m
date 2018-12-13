From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 27/41] net/mlx4_en: Change min MTU size to ETH_MIN_MTU
Date: Wed, 12 Dec 2018 23:30:40 -0500
Message-ID: <20181213043054.75891-27-sashal@kernel.org>
References: <20181213043054.75891-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181213043054.75891-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eran Ben Elisha <eranbe@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, "David S . Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit 24be19e47779d604d1492c114459dca9a92acf78 ]

NIC driver minimal MTU size shall be set to ETH_MIN_MTU, as defined in
the RFC791 and in the network stack. Remove old mlx4_en only define for
it, which was set to wrong value.

Fixes: b80f71f5816f ("ethernet/mellanox: use core min/max MTU checking")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index faa4bd21f148..0fb85d71c11b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3505,8 +3505,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
-	/* MTU range: 46 - hw-specific max */
-	dev->min_mtu = MLX4_EN_MIN_MTU;
+	/* MTU range: 68 - hw-specific max */
+	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = priv->max_mtu;
 
 	mdev->pndev[port] = dev;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 09f4764a3f39..bdd87438a354 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -157,7 +157,6 @@
 #define HEADER_COPY_SIZE       (128 - NET_IP_ALIGN)
 #define MLX4_LOOPBACK_TEST_PAYLOAD (HEADER_COPY_SIZE - ETH_HLEN)
 
-#define MLX4_EN_MIN_MTU		46
 /* VLAN_HLEN is added twice,to support skb vlan tagged with multiple
  * headers. (For example: ETH_P_8021Q and ETH_P_8021AD).
  */
-- 
2.19.1

From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 48/73] net/mlx4_en: Change min MTU size to ETH_MIN_MTU
Date: Wed, 12 Dec 2018 23:28:13 -0500
Message-ID: <20181213042838.75160-48-sashal@kernel.org>
References: <20181213042838.75160-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213042838.75160-1-sashal@kernel.org>
Sender: netdev-owner@vger.kernel.org
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
index fe49384eba48..0d7fd3f043cf 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3494,8 +3494,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
-	/* MTU range: 46 - hw-specific max */
-	dev->min_mtu = MLX4_EN_MIN_MTU;
+	/* MTU range: 68 - hw-specific max */
+	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = priv->max_mtu;
 
 	mdev->pndev[port] = dev;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index c3228b89df46..240f9c9ca943 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -161,7 +161,6 @@
 #define MLX4_SELFTEST_LB_MIN_MTU (MLX4_LOOPBACK_TEST_PAYLOAD + NET_IP_ALIGN + \
 				  ETH_HLEN + PREAMBLE_LEN)
 
-#define MLX4_EN_MIN_MTU		46
 /* VLAN_HLEN is added twice,to support skb vlan tagged with multiple
  * headers. (For example: ETH_P_8021Q and ETH_P_8021AD).
  */
-- 
2.19.1

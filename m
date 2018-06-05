From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] net/mlx5e: Make function mlx5e_change_rep_mtu() static
Date: Tue, 5 Jun 2018 02:42:45 +0000
Message-ID: <1528166565-54828-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Adi Nissim <adin@mellanox.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fixes the following sparse warning:

drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:903:5: warning:
 symbol 'mlx5e_change_rep_mtu' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3857f22..57987f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -900,7 +900,7 @@ int mlx5e_get_offload_stats(int attr_id, const struct net_device *dev,
 	.switchdev_port_attr_get	= mlx5e_attr_get,
 };
 
-int mlx5e_change_rep_mtu(struct net_device *netdev, int new_mtu)
+static int mlx5e_change_rep_mtu(struct net_device *netdev, int new_mtu)
 {
 	return mlx5e_change_mtu(netdev, new_mtu, NULL);
 }

From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] net/mlx5e: Make function mlx5i_grp_sw_update_stats() static
Date: Wed, 5 Sep 2018 11:16:02 +0000
Message-ID: <1536146162-132732-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Or Gerlitz <ogerlitz@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Alex Vesker <valex@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fixes the following sparse warning:

drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c:119:6: warning:
 symbol 'mlx5i_grp_sw_update_stats' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 48886b3..3dd9f88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -116,7 +116,7 @@ static void mlx5i_cleanup(struct mlx5e_priv *priv)
 	/* Do nothing .. */
 }
 
-void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
+static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
 {
 	struct mlx5e_sw_stats s = { 0 };
 	int i, j;

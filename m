From: Colin King <colin.king@canonical.com>
Subject: [PATCH] net/mlx5e: fix spelling mistake: "loobpack" -> "loopback"
Date: Thu,  3 May 2018 10:12:53 +0100
Message-ID: <20180503091253.29324-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in netdev_err error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 707976482c09..027f54ac1ca2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -290,7 +290,7 @@ static int mlx5e_test_loopback(struct mlx5e_priv *priv)
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		netdev_err(priv->netdev,
-			   "\tCan't perform loobpack test while device is down\n");
+			   "\tCan't perform loopback test while device is down\n");
 		return -ENODEV;
 	}
 
-- 
2.17.0

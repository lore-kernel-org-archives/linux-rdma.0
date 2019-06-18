From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] net/mlx5: add missing void argument to function mlx5_devlink_alloc
Date: Tue, 18 Jun 2019 16:15:10 +0100
Message-ID: <20190618151510.18672-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Function mlx5_devlink_alloc is missing a void argument, add it
to clean up the non-ANSI function declaration.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index ed4202e883f0..1533c657220b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -37,7 +37,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.flash_update = mlx5_devlink_flash_update,
 };
 
-struct devlink *mlx5_devlink_alloc()
+struct devlink *mlx5_devlink_alloc(void)
 {
 	return devlink_alloc(&mlx5_devlink_ops, sizeof(struct mlx5_core_dev));
 }
-- 
2.20.1

From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 44/97] net/mlx5e: Cancel DIM work on close SQ
Date: Wed, 26 Dec 2018 17:35:04 -0500
Message-ID: <20181226223557.149329-44-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tal Gilboa <talgi@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Tal Gilboa <talgi@mellanox.com>

[ Upstream commit fa2bf86bab4bbc61e5678a42a14e40075093a98f ]

TXQ SQ closure is followed by closing the corresponding CQ. A pending
DIM work would try to modify the now non-existing CQ.
This would trigger an error:
[85535.835926] mlx5_core 0000:af:00.0: mlx5_cmd_check:769:(pid 124399):
MODIFY_CQ(0x403) op_mod(0x0) failed, status bad resource state(0x9), syndrome (0x1d7771)

Fix by making sure to cancel any pending DIM work before destroying the SQ.

Fixes: cbce4f444798 ("net/mlx5e: Enable adaptive-TX moderation")
Signed-off-by: Tal Gilboa <talgi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 06c3902d1f94..7365899c3ac9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1388,6 +1388,7 @@ static void mlx5e_close_txqsq(struct mlx5e_txqsq *sq)
 	struct mlx5_core_dev *mdev = c->mdev;
 	struct mlx5_rate_limit rl = {0};
 
+	cancel_work_sync(&sq->dim.work);
 	mlx5e_destroy_sq(mdev, sq->sqn);
 	if (sq->rate_limit) {
 		rl.rate = sq->rate_limit;
-- 
2.19.1

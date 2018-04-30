From: Colin King <colin.king@canonical.com>
Subject: [PATCH] net/mlx4: fix spelling mistake: "failedi" -> "failed"
Date: Mon, 30 Apr 2018 17:29:45 +0100
Message-ID: <20180430162945.5274-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in mlx4_warn message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index bfef69235d71..211578ffc70d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1317,7 +1317,7 @@ static int mlx4_mf_unbond(struct mlx4_dev *dev)
 
 	ret = mlx4_unbond_fs_rules(dev);
 	if (ret)
-		mlx4_warn(dev, "multifunction unbond for flow rules failedi (%d)\n", ret);
+		mlx4_warn(dev, "multifunction unbond for flow rules failed (%d)\n", ret);
 	ret1 = mlx4_unbond_mac_table(dev);
 	if (ret1) {
 		mlx4_warn(dev, "multifunction unbond for MAC table failed (%d)\n", ret1);
-- 
2.17.0

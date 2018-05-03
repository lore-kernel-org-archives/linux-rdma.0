From: Colin King <colin.king@canonical.com>
Subject: [PATCH] net/mlx5: fix spelling mistake: "modfiy" -> "modify"
Date: Thu,  3 May 2018 14:35:03 +0100
Message-ID: <20180503133503.14508-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in netdev_warn warning message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 610d485c4b03..f64b5e78519b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -565,7 +565,7 @@ static void arfs_modify_rule_rq(struct mlx5e_priv *priv,
 	err =  mlx5_modify_rule_destination(rule, &dst, NULL);
 	if (err)
 		netdev_warn(priv->netdev,
-			    "Failed to modfiy aRFS rule destination to rq=%d\n", rxq);
+			    "Failed to modify aRFS rule destination to rq=%d\n", rxq);
 }
 
 static void arfs_handle_work(struct work_struct *work)
-- 
2.17.0

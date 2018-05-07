From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 6/6] net/mlx5: fix spelling mistake: "modfiy" -> "modify"
Date: Mon,  7 May 2018 16:53:04 -0700
Message-ID: <20180507235304.25085-7-saeedm@mellanox.com>
References: <20180507235304.25085-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180507235304.25085-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Colin Ian King <colin.king@canonical.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in netdev_warn warning message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
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
2.14.3

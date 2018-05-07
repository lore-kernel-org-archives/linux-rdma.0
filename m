From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 5/6] net/mlx5: Cleanup unused field in Work Queue parameters
Date: Mon,  7 May 2018 16:53:03 -0700
Message-ID: <20180507235304.25085-6-saeedm@mellanox.com>
References: <20180507235304.25085-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180507235304.25085-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Remove the 'linear' field from struct mlx5_wq_param.
It is redundant, set but never read.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/wq.h      | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b29c1d93f058..f60905648797 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1896,7 +1896,6 @@ static void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 	MLX5_SET(rqc, rqc, scatter_fcs,    params->scatter_fcs_en);
 
 	param->wq.buf_numa_node = dev_to_node(&mdev->pdev->dev);
-	param->wq.linear = 1;
 }
 
 static void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
index fca90b94596d..f3dfa0ca3c5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -38,7 +38,6 @@
 #include <linux/mlx5/qp.h>
 
 struct mlx5_wq_param {
-	int		linear;
 	int		buf_numa_node;
 	int		db_numa_node;
 };
-- 
2.14.3

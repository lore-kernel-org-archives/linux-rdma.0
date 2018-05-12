From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/mlx5: Use 'kvfree()' for memory allocated by 'kvzalloc()'
Date: Sat, 12 May 2018 19:09:25 +0200
Message-ID: <20180512170925.23690-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: saeedm@mellanox.com, matanb@mellanox.com, leon@kernel.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

'out' is allocated with 'kvzalloc()'. 'kvfree()' must be used to free it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 177e076b8d17..49968a4db758 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -511,7 +511,7 @@ int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 	*system_image_guid = MLX5_GET64(query_nic_vport_context_out, out,
 					nic_vport_context.system_image_guid);
 
-	kfree(out);
+	kvfree(out);
 
 	return 0;
 }
-- 
2.17.0

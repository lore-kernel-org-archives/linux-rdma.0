From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 01/15] net/mlx5: Vport, Use 'kvfree()' for memory allocated by 'kvzalloc()'
Date: Thu, 17 May 2018 18:22:44 -0700
Message-ID: <20180518012258.26968-2-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

When 'kvzalloc()' is used to allocate memory, 'kvfree()' must be used to
free it.

Fixes: 9efa75254593d ("net/mlx5_core: Introduce access functions to query vport RoCE fields")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 177e076b8d17..719cecb182c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -511,7 +511,7 @@ int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 	*system_image_guid = MLX5_GET64(query_nic_vport_context_out, out,
 					nic_vport_context.system_image_guid);
 
-	kfree(out);
+	kvfree(out);
 
 	return 0;
 }
@@ -531,7 +531,7 @@ int mlx5_query_nic_vport_node_guid(struct mlx5_core_dev *mdev, u64 *node_guid)
 	*node_guid = MLX5_GET64(query_nic_vport_context_out, out,
 				nic_vport_context.node_guid);
 
-	kfree(out);
+	kvfree(out);
 
 	return 0;
 }
@@ -587,7 +587,7 @@ int mlx5_query_nic_vport_qkey_viol_cntr(struct mlx5_core_dev *mdev,
 	*qkey_viol_cntr = MLX5_GET(query_nic_vport_context_out, out,
 				   nic_vport_context.qkey_violation_counter);
 
-	kfree(out);
+	kvfree(out);
 
 	return 0;
 }
-- 
2.17.0

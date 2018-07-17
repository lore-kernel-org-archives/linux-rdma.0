From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 6/8] net/mlx5: Use ERR_CAST() instead of coding it
Date: Mon, 16 Jul 2018 18:35:35 -0700
Message-ID: <20180717013537.26411-7-saeedm@mellanox.com>
References: <20180717013537.26411-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717013537.26411-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Roi Dayan <roid@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

This makes it more readable that rule is being used to return an err.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 05e7a5112b74..29b86232f13a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1825,7 +1825,7 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 
 	g = alloc_auto_flow_group(ft, spec);
 	if (IS_ERR(g)) {
-		rule = (void *)g;
+		rule = ERR_CAST(g);
 		up_write_ref_node(&ft->node);
 		return rule;
 	}
-- 
2.17.0

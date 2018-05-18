From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 02/15] net/mlx5: Eswitch, Use 'kvfree()' for memory allocated by 'kvzalloc()'
Date: Thu, 17 May 2018 18:22:45 -0700
Message-ID: <20180518012258.26968-3-saeedm@mellanox.com>
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

Fixes: fed9ce22bf8ae ("net/mlx5: E-Switch, Add API to create vport rx rules")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 35e256eb2f6e..b123f8a52ad8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -663,7 +663,7 @@ static int esw_create_vport_rx_group(struct mlx5_eswitch *esw)
 
 	esw->offloads.vport_rx_group = g;
 out:
-	kfree(flow_group_in);
+	kvfree(flow_group_in);
 	return err;
 }
 
-- 
2.17.0

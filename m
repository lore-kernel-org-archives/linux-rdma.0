From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 05/15] net/mlx5: Properly handle a vport destination when setting FTE
Date: Thu, 17 May 2018 18:22:48 -0700
Message-ID: <20180518012258.26968-6-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Shahar Klein <shahark@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Shahar Klein <shahark@mellanox.com>

When creating FTE, properly distinguish between destination being vport
or tir. The previous code just worked accidentally b/c of both dest being
in the same offset within a union.

Signed-off-by: Shahar Klein <shahark@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index ef5afd7c9325..0bfce6a82c91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -372,6 +372,9 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 			if (dst->dest_attr.type ==
 			    MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE) {
 				id = dst->dest_attr.ft->id;
+			} else if (dst->dest_attr.type ==
+				   MLX5_FLOW_DESTINATION_TYPE_VPORT) {
+				id = dst->dest_attr.vport_num;
 			} else {
 				id = dst->dest_attr.tir_num;
 			}
-- 
2.17.0

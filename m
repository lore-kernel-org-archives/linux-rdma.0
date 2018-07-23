From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 7/8] IB/mlx5: Add support for a flow table destination
Date: Mon, 23 Jul 2018 15:25:11 +0300
Message-ID: <20180723122512.20967-8-leon@kernel.org>
References: <20180723122512.20967-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180723122512.20967-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add support to set a destination that is a flow table, this can come
from the DEVX destination.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index dba3d529f49f..d750562cb2c5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3791,9 +3791,6 @@ mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 	if (fs_matcher->priority > MLX5_IB_FLOW_LAST_PRIO)
 		return ERR_PTR(-ENOMEM);
 
-	if (dest_type != MLX5_FLOW_DESTINATION_TYPE_TIR)
-		return ERR_PTR(-ENOTSUPP);
-
 	dst = kzalloc(sizeof(*dst), GFP_KERNEL);
 	if (!dst)
 		return ERR_PTR(-ENOMEM);
@@ -3807,8 +3804,14 @@ mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 		goto unlock;
 	}
 
-	dst->type = dest_type;
-	dst->tir_num = dest_id;
+	if (dest_type == MLX5_FLOW_DESTINATION_TYPE_TIR) {
+		dst->type = dest_type;
+		dst->tir_num = dest_id;
+	} else {
+		dst->type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM;
+		dst->ft_num = dest_id;
+	}
+
 	handler = _create_raw_flow_rule(dev, ft_prio, dst, fs_matcher, cmd_in,
 					inlen);
 
-- 
2.14.4

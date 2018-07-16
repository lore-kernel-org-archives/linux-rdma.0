From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH rdma-next 13/18] RDMA/mlx5: Enable decap and packet reformat on flow tables
Date: Mon, 16 Jul 2018 11:23:00 +0300
Message-ID: <20180716082305.11744-14-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

If NIC RX flow tables support decap opertion, enable it on creation.
If NIC TX flow tables support reformat opertion, enable it on creation.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fe4640fe025b..ecbf9f3e12d8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3036,14 +3036,15 @@ enum flow_table_type {
 static struct mlx5_ib_flow_prio *_get_prio(struct mlx5_flow_namespace *ns,
 					   struct mlx5_ib_flow_prio *prio,
 					   int priority,
-					   int num_entries, int num_groups)
+					   int num_entries, int num_groups,
+					   u32 flags)
 {
 	struct mlx5_flow_table *ft;

 	ft = mlx5_create_auto_grouped_flow_table(ns, priority,
 						 num_entries,
 						 num_groups,
-						 0, 0);
+						 0, flags);
 	if (IS_ERR(ft))
 		return ERR_CAST(ft);

@@ -3063,6 +3064,7 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	int max_table_size;
 	int num_entries;
 	int num_groups;
+	u32 flags = 0;
 	int priority;

 	max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
@@ -3079,11 +3081,15 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 		if (ft_type == MLX5_IB_FT_RX) {
 			fn_type = MLX5_FLOW_NAMESPACE_BYPASS;
 			prio = &dev->flow_db->prios[priority];
+			if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap))
+			    flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
 		} else {
 			max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev,
 								       log_max_ft_size));
 			fn_type = MLX5_FLOW_NAMESPACE_EGRESS;
 			prio = &dev->flow_db->egress_prios[priority];
+			if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, reformat))
+			    flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 		}
 		ns = mlx5_get_flow_namespace(dev->mdev, fn_type);
 		num_entries = MLX5_FS_MAX_ENTRIES;
@@ -3119,7 +3125,8 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,

 	ft = prio->flow_table;
 	if (!ft)
-		return _get_prio(ns, prio, priority, num_entries, num_groups);
+		return _get_prio(ns, prio, priority, num_entries, num_groups,
+				 flags);

 	return prio;
 }
@@ -3694,7 +3701,7 @@ static struct mlx5_ib_flow_prio *_get_flow_table(struct mlx5_ib_dev *dev,
 		return prio;

 	return _get_prio(ns, prio, priority, MLX5_FS_MAX_ENTRIES,
-			 MLX5_FS_MAX_TYPES);
+			 MLX5_FS_MAX_TYPES, 0);
 }

 static struct mlx5_ib_flow_handler *

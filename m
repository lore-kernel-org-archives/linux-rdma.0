From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/3] RDMA/mlx5: Consider eswitch encap mode
Date: Thu,  6 Jun 2019 14:06:08 +0300
Message-ID: <20190606110609.11588-3-leon@kernel.org>
References: <20190606110609.11588-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190606110609.11588-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

When flow steering is created, then the encap support should
consider the eswitch encap mode. If the eswitch flow table (FDB)
supports encap then it shouldn't be supported on NIC RX flow tables.

Fixes: 4adda1122c490 ('RDMA/mlx5: Enable decap and packet reformat on flow tables')
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5fd5db2b397f..70d565283508 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -52,6 +52,7 @@
 #include <linux/mlx5/port.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/eswitch.h>
 #include <linux/list.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
@@ -3247,9 +3248,12 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	int num_groups;
 	u32 flags = 0;
 	int priority;
+	u8 esw_encap;
 
 	max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 						       log_max_ft_size));
+	esw_encap = mlx5_eswitch_get_encap_mode(dev->mdev) !=
+		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 	if (flow_attr->type == IB_FLOW_ATTR_NORMAL) {
 		enum mlx5_flow_namespace_type fn_type;
 
@@ -3262,10 +3266,10 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 		if (ft_type == MLX5_IB_FT_RX) {
 			fn_type = MLX5_FLOW_NAMESPACE_BYPASS;
 			prio = &dev->flow_db->prios[priority];
-			if (!dev->is_rep &&
+			if (!dev->is_rep && !esw_encap &&
 			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
-			if (!dev->is_rep &&
+			if (!dev->is_rep && !esw_encap &&
 			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 					reformat_l3_tunnel_to_l2))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
@@ -3275,7 +3279,7 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 							      log_max_ft_size));
 			fn_type = MLX5_FLOW_NAMESPACE_EGRESS;
 			prio = &dev->flow_db->egress_prios[priority];
-			if (!dev->is_rep &&
+			if (!dev->is_rep && !esw_encap &&
 			    MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, reformat))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 		}
@@ -3887,24 +3891,28 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 	int max_table_size = 0;
 	u32 flags = 0;
 	int priority;
+	u8 esw_encap;
 
 	if (mcast)
 		priority = MLX5_IB_FLOW_MCAST_PRIO;
 	else
 		priority = ib_prio_to_core_prio(fs_matcher->priority, false);
 
+	esw_encap = mlx5_eswitch_get_encap_mode(dev->mdev) !=
+		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_BYPASS) {
 		max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 					log_max_ft_size));
-		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap))
+		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap) && !esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
 		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
-					      reformat_l3_tunnel_to_l2))
+					      reformat_l3_tunnel_to_l2) &&
+		    !esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_EGRESS) {
 		max_table_size = BIT(
 			MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, log_max_ft_size));
-		if (MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, reformat))
+		if (MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, reformat) && !esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB) {
 		max_table_size = BIT(
-- 
2.20.1

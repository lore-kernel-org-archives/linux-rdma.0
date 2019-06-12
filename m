From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 3/4] RDMA/mlx5: Consider eswitch encap mode
Date: Wed, 12 Jun 2019 15:20:13 +0300
Message-ID: <20190612122014.22359-4-leon@kernel.org>
References: <20190612122014.22359-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190612122014.22359-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Parav Pandit <parav@mellanox.com>, Petr Vorel <pvorel@suse.cz>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

When flow steering is created, then the encap support should
consider the eswitch encap mode. If the eswitch flow table (FDB)
supports encap then it shouldn't be supported on NIC RX flow tables.

Fixes: 4adda1122c490 ('RDMA/mlx5: Enable decap and packet reformat on flow tables')
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e832ac6c83a4..a6e2e0210ebb 100644
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
@@ -3245,11 +3246,14 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	int max_table_size;
 	int num_entries;
 	int num_groups;
+	bool esw_encap;
 	u32 flags = 0;
 	int priority;

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
@@ -3885,6 +3889,7 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 	struct mlx5_flow_namespace *ns = NULL;
 	struct mlx5_ib_flow_prio *prio = NULL;
 	int max_table_size = 0;
+	bool esw_encap;
 	u32 flags = 0;
 	int priority;

@@ -3893,18 +3898,21 @@ _get_flow_table(struct mlx5_ib_dev *dev,
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

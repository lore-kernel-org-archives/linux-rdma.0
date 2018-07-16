From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH rdma-next 10/18] RDMA/mlx5: Add NIC TX steering support
Date: Mon, 16 Jul 2018 11:22:57 +0300
Message-ID: <20180716082305.11744-11-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Add support for proper NIC TX (egress) steering with multiple priorities.
We expose the same number of priorities as the bypass (NIC RX) steering.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 25 +++++++++++++++----------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ec2eca20a09a..4d4e00ffc340 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2885,7 +2885,7 @@ is_valid_esp_aes_gcm(struct mlx5_core_dev *mdev,
 	 * rules would be supported, always return VALID_SPEC_NA.
 	 */
 	if (!is_crypto)
-		return egress ? VALID_SPEC_INVALID : VALID_SPEC_NA;
+		return VALID_SPEC_NA;

 	return is_crypto && is_ipsec &&
 		(!egress || (!is_drop && !flow_act->has_flow_tag)) ?
@@ -3060,21 +3060,26 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 						       log_max_ft_size));
 	if (flow_attr->type == IB_FLOW_ATTR_NORMAL) {
-		if (ft_type == MLX5_IB_FT_TX)
-			priority = 0;
-		else if (flow_is_multicast_only(flow_attr) &&
-			 !dont_trap)
+		enum mlx5_flow_namespace_type fn_type;
+
+		if (flow_is_multicast_only(flow_attr) &&
+		    !dont_trap)
 			priority = MLX5_IB_FLOW_MCAST_PRIO;
 		else
 			priority = ib_prio_to_core_prio(flow_attr->priority,
 							dont_trap);
-		ns = mlx5_get_flow_namespace(dev->mdev,
-					     ft_type == MLX5_IB_FT_TX ?
-					     MLX5_FLOW_NAMESPACE_EGRESS :
-					     MLX5_FLOW_NAMESPACE_BYPASS);
+		if (ft_type == MLX5_IB_FT_RX) {
+			fn_type = MLX5_FLOW_NAMESPACE_BYPASS;
+			prio = &dev->flow_db->prios[priority];
+		} else {
+			max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev,
+								       log_max_ft_size));
+			fn_type = MLX5_FLOW_NAMESPACE_EGRESS;
+			prio = &dev->flow_db->egress_prios[priority];
+		}
+		ns = mlx5_get_flow_namespace(dev->mdev, fn_type);
 		num_entries = MLX5_FS_MAX_ENTRIES;
 		num_groups = MLX5_FS_MAX_TYPES;
-		prio = &dev->flow_db->prios[priority];
 	} else if (flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT ||
 		   flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT) {
 		ns = mlx5_get_flow_namespace(dev->mdev,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 5f08b69f8a4f..274aefd73a7d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -188,6 +188,7 @@ struct mlx5_ib_flow_matcher {

 struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	prios[MLX5_IB_NUM_FLOW_FT];
+	struct mlx5_ib_flow_prio	egress_prios[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	sniffer[MLX5_IB_NUM_SNIFFER_FTS];
 	struct mlx5_ib_flow_prio	egress[MLX5_IB_NUM_EGRESS_FTS];
 	struct mlx5_flow_table		*lag_demux_ft;

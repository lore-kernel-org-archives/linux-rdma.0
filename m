From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v1 02/15] net/mlx5: Add proper NIC TX steering flow tables support
Date: Tue, 28 Aug 2018 14:18:41 +0300
Message-ID: <20180828111854.14367-3-leon@kernel.org>
References: <20180828111854.14367-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180828111854.14367-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Extend the ability to add steering rules to NIC TX flow tables.
For now, we are only adding TX bypass (egress) which is used by the RDMA
side. This will allow to shape outgoing traffic and tweak it if needed, for
example performing encapsulation or rewriting headers.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 51 +++++++++++++++++------
 include/linux/mlx5/device.h                       |  6 +++
 3 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 8e01f818021b..28c7301e08f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -760,8 +760,8 @@ const struct mlx5_flow_cmds *mlx5_fs_cmd_get_default(enum fs_flow_table_type typ
 	case FS_FT_FDB:
 	case FS_FT_SNIFFER_RX:
 	case FS_FT_SNIFFER_TX:
-		return mlx5_fs_cmd_get_fw_cmds();
 	case FS_FT_NIC_TX:
+		return mlx5_fs_cmd_get_fw_cmds();
 	default:
 		return mlx5_fs_cmd_get_stub_cmds();
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 5624030d2ed4..b7e7eb3535c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -76,6 +76,14 @@
 					   FS_CAP(flow_table_properties_nic_receive.identified_miss_table_mode), \
 					   FS_CAP(flow_table_properties_nic_receive.flow_table_modify))
 
+#define FS_CHAINING_CAPS_EGRESS                                                \
+	FS_REQUIRED_CAPS(                                                      \
+		FS_CAP(flow_table_properties_nic_transmit.flow_modify_en),     \
+		FS_CAP(flow_table_properties_nic_transmit.modify_root),        \
+		FS_CAP(flow_table_properties_nic_transmit                      \
+			       .identified_miss_table_mode),                   \
+		FS_CAP(flow_table_properties_nic_transmit.flow_table_modify))
+
 #define LEFTOVERS_NUM_LEVELS 1
 #define LEFTOVERS_NUM_PRIOS 1
 
@@ -151,6 +159,17 @@ static struct init_tree_node {
 	}
 };
 
+static struct init_tree_node egress_root_fs = {
+	.type = FS_TYPE_NAMESPACE,
+	.ar_size = 1,
+	.children = (struct init_tree_node[]) {
+		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
+			 FS_CHAINING_CAPS_EGRESS,
+			 ADD_NS(ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
+						  BY_PASS_PRIO_NUM_LEVELS))),
+	}
+};
+
 enum fs_i_lock_class {
 	FS_LOCK_GRANDPARENT,
 	FS_LOCK_PARENT,
@@ -1978,7 +1997,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 {
 	struct mlx5_flow_steering *steering = dev->priv.steering;
 	struct mlx5_flow_root_namespace *root_ns;
-	int prio;
+	int prio = 0;
 	struct fs_prio *fs_prio;
 	struct mlx5_flow_namespace *ns;
 
@@ -1998,16 +2017,17 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		if (steering->sniffer_tx_root_ns)
 			return &steering->sniffer_tx_root_ns->ns;
 		return NULL;
-	case MLX5_FLOW_NAMESPACE_EGRESS:
-		if (steering->egress_root_ns)
-			return &steering->egress_root_ns->ns;
-		return NULL;
 	default:
 		break;
 	}
 
-	root_ns = steering->root_ns;
-	prio = type;
+	if (type == MLX5_FLOW_NAMESPACE_EGRESS) {
+		root_ns = steering->egress_root_ns;
+	} else { /* Must be NIC RX */
+		root_ns = steering->root_ns;
+		prio = type;
+	}
+
 	if (!root_ns)
 		return NULL;
 
@@ -2523,16 +2543,23 @@ static int init_ingress_acls_root_ns(struct mlx5_core_dev *dev)
 
 static int init_egress_root_ns(struct mlx5_flow_steering *steering)
 {
-	struct fs_prio *prio;
+	int err;
 
 	steering->egress_root_ns = create_root_ns(steering,
 						  FS_FT_NIC_TX);
 	if (!steering->egress_root_ns)
 		return -ENOMEM;
 
-	/* create 1 prio*/
-	prio = fs_create_prio(&steering->egress_root_ns->ns, 0, 1);
-	return PTR_ERR_OR_ZERO(prio);
+	err = init_root_tree(steering, &egress_root_fs,
+			     &steering->egress_root_ns->ns.node);
+	if (err)
+		goto cleanup;
+	set_prio_attrs(steering->egress_root_ns);
+	return 0;
+cleanup:
+	cleanup_root_ns(steering->egress_root_ns);
+	steering->egress_root_ns = NULL;
+	return err;
 }
 
 int mlx5_init_fs(struct mlx5_core_dev *dev)
@@ -2600,7 +2627,7 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 			goto err;
 	}
 
-	if (MLX5_IPSEC_DEV(dev)) {
+	if (MLX5_IPSEC_DEV(dev) || MLX5_CAP_FLOWTABLE_NIC_TX(dev, ft_support)) {
 		err = init_egress_root_ns(steering);
 		if (err)
 			goto err;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 11fa4e66afc5..f2281e69ab39 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1120,6 +1120,12 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_FLOWTABLE_NIC_RX_MAX(mdev, cap) \
 	MLX5_CAP_FLOWTABLE_MAX(mdev, flow_table_properties_nic_receive.cap)
 
+#define MLX5_CAP_FLOWTABLE_NIC_TX(mdev, cap) \
+		MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_transmit.cap)
+
+#define MLX5_CAP_FLOWTABLE_NIC_TX_MAX(mdev, cap) \
+	MLX5_CAP_FLOWTABLE_MAX(mdev, flow_table_properties_nic_transmit.cap)
+
 #define MLX5_CAP_FLOWTABLE_SNIFFER_RX(mdev, cap) \
 	MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive_sniffer.cap)
 
-- 
2.14.4

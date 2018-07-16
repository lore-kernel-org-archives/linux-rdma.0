From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH mlx5-next 01/18] net/mlx5: Add proper NIC TX steering flow tables support
Date: Mon, 16 Jul 2018 11:22:48 +0300
Message-ID: <20180716082305.11744-2-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Expose the ability to add steering rules to NIC TX flow tables.
For now, we are only adding TX bypass (egress) which is used by the RDMA
side. While we are here clean the switch logic.

We expose the same number of priorities as the RX bypass.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 55 ++++++++++++++---------
 include/linux/mlx5/device.h                       |  6 +++
 3 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 3a04551696c0..1be56e2eb1c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -753,8 +753,8 @@ const struct mlx5_flow_cmds *mlx5_fs_cmd_get_default(enum fs_flow_table_type typ
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
index 69aa298a0b1c..68653ca76a11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -150,6 +150,17 @@ static struct init_tree_node {
 	}
 };

+static struct init_tree_node egress_root_fs = {
+	.type = FS_TYPE_NAMESPACE,
+	.ar_size = 1,
+	.children = (struct init_tree_node[]) {
+		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
+						  BY_PASS_PRIO_NUM_LEVELS))),
+	}
+};
+
 enum fs_i_lock_class {
 	FS_LOCK_GRANDPARENT,
 	FS_LOCK_PARENT,
@@ -1974,7 +1985,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 						    enum mlx5_flow_namespace_type type)
 {
 	struct mlx5_flow_steering *steering = dev->priv.steering;
-	struct mlx5_flow_root_namespace *root_ns;
+	struct mlx5_flow_root_namespace *steering_ns = NULL;
 	int prio;
 	struct fs_prio *fs_prio;
 	struct mlx5_flow_namespace *ns;
@@ -1990,37 +2001,35 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 	case MLX5_FLOW_NAMESPACE_KERNEL:
 	case MLX5_FLOW_NAMESPACE_LEFTOVERS:
 	case MLX5_FLOW_NAMESPACE_ANCHOR:
+		steering_ns = steering->root_ns;
 		prio = type;
 		break;
 	case MLX5_FLOW_NAMESPACE_FDB:
 		if (steering->fdb_root_ns)
 			return &steering->fdb_root_ns->ns;
-		else
-			return NULL;
+		break;
 	case MLX5_FLOW_NAMESPACE_SNIFFER_RX:
 		if (steering->sniffer_rx_root_ns)
 			return &steering->sniffer_rx_root_ns->ns;
-		else
-			return NULL;
+		break;
 	case MLX5_FLOW_NAMESPACE_SNIFFER_TX:
 		if (steering->sniffer_tx_root_ns)
 			return &steering->sniffer_tx_root_ns->ns;
-		else
-			return NULL;
+		break;
 	case MLX5_FLOW_NAMESPACE_EGRESS:
-		if (steering->egress_root_ns)
-			return &steering->egress_root_ns->ns;
-		else
-			return NULL;
+		if (steering->egress_root_ns) {
+			steering_ns = steering->egress_root_ns;
+			prio = 0;
+		}
+		break;
 	default:
-		return NULL;
+		break;
 	}

-	root_ns = steering->root_ns;
-	if (!root_ns)
+	if (!steering_ns)
 		return NULL;

-	fs_prio = find_prio(&root_ns->ns, prio);
+	fs_prio = find_prio(&steering_ns->ns, prio);
 	if (!fs_prio)
 		return NULL;

@@ -2532,16 +2541,20 @@ static int init_ingress_acls_root_ns(struct mlx5_core_dev *dev)

 static int init_egress_root_ns(struct mlx5_flow_steering *steering)
 {
-	struct fs_prio *prio;
-
 	steering->egress_root_ns = create_root_ns(steering,
 						  FS_FT_NIC_TX);
 	if (!steering->egress_root_ns)
 		return -ENOMEM;

-	/* create 1 prio*/
-	prio = fs_create_prio(&steering->egress_root_ns->ns, 0, 1);
-	return PTR_ERR_OR_ZERO(prio);
+	if (init_root_tree(steering, &egress_root_fs,
+			   &steering->egress_root_ns->ns.node))
+		goto cleanup;
+	set_prio_attrs(steering->egress_root_ns);
+	return 0;
+cleanup:
+	cleanup_root_ns(steering->egress_root_ns);
+	steering->egress_root_ns = NULL;
+	return -ENOMEM;
 }

 int mlx5_init_fs(struct mlx5_core_dev *dev)
@@ -2609,7 +2622,7 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 			goto err;
 	}

-	if (MLX5_IPSEC_DEV(dev)) {
+	if (MLX5_IPSEC_DEV(dev) || MLX5_CAP_FLOWTABLE_NIC_TX(dev, ft_support)) {
 		err = init_egress_root_ns(steering);
 		if (err)
 			goto err;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index f8671c0a43aa..0c298869fd1c 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1113,6 +1113,12 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_FLOWTABLE_NIC_RX_MAX(mdev, cap) \
 	MLX5_CAP_FLOWTABLE_MAX(mdev, flow_table_properties_nic_receive.cap)

+#define MLX5_CAP_FLOWTABLE_NIC_TX(mdev, cap) \
+		MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_transmit.cap)
+
+#define MLX5_CAP_FLOWTABLE_NIC_TX_MAX(mdev, cap) \
+		MLX5_CAP_FLOWTABLE_MAX(mdev, flow_table_properties_nic_transmit.cap)
+
 #define MLX5_CAP_FLOWTABLE_SNIFFER_RX(mdev, cap) \
 	MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive_sniffer.cap)

From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 02/27] net/mlx5: Add proper NIC TX steering flow tables support
Date: Sun, 29 Jul 2018 15:58:40 +0300
Message-ID: <20180729125905.31989-3-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Expose the ability to add steering rules to NIC TX flow tables.
For now, we are only adding TX bypass (egress) which is used by the RDMA
side. This will allow an administrator to control outgoing traffic and
tweak it if needed, for example preforming encapsulation or rewriting
headers.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 33 +++++++++++++++++------
 include/linux/mlx5/device.h                       |  6 +++++
 3 files changed, 32 insertions(+), 9 deletions(-)

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
index 17bbad8ee882..8243a93e1d6c 100644
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
@@ -2008,8 +2019,10 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 			return &steering->sniffer_tx_root_ns->ns;
 		break;
 	case MLX5_FLOW_NAMESPACE_EGRESS:
-		if (steering->egress_root_ns)
-			return &steering->egress_root_ns->ns;
+		if (steering->egress_root_ns) {
+			steering_ns = steering->egress_root_ns;
+			prio = 0;
+		}
 		break;
 	default:
 		break;
@@ -2530,16 +2543,20 @@ static int init_ingress_acls_root_ns(struct mlx5_core_dev *dev)
 
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
@@ -2607,7 +2624,7 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 			goto err;
 	}
 
-	if (MLX5_IPSEC_DEV(dev)) {
+	if (MLX5_IPSEC_DEV(dev) || MLX5_CAP_FLOWTABLE_NIC_TX(dev, ft_support)) {
 		err = init_egress_root_ns(steering);
 		if (err)
 			goto err;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 0566c6a94805..e9c35eb1cc26 100644
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
 
-- 
2.14.4

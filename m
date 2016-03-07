From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/3] net/mlx5_core: Create anchor of last flow table
Date: Mon,  7 Mar 2016 18:51:45 +0200
Message-ID: <1457369507-30999-2-git-send-email-matanb@mellanox.com>
References: <1457369507-30999-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457369507-30999-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Create an empty flow table in the end of NIC rx namesapce.
Adding this flow table simplify the implementation of "forward
to next prio" rules.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 40 ++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  6 ++++
 include/linux/mlx5/fs.h                           |  1 +
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 6f68dba..a2781ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -77,6 +77,9 @@
 #define KERNEL_NUM_PRIOS 1
 #define KENREL_MIN_LEVEL 2
 
+#define ANCHOR_MAX_FT 1
+#define ANCHOR_NUM_PRIOS 1
+#define ANCHOR_MIN_LEVEL (BY_PASS_MIN_LEVEL + 1)
 struct node_caps {
 	size_t	arr_sz;
 	long	*caps;
@@ -92,7 +95,7 @@ static struct init_tree_node {
 	int max_ft;
 } root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 3,
+	.ar_size = 4,
 	.children = (struct init_tree_node[]) {
 		ADD_PRIO(0, BY_PASS_MIN_LEVEL, 0,
 			 FS_REQUIRED_CAPS(FS_CAP(flow_table_properties_nic_receive.flow_modify_en),
@@ -108,6 +111,8 @@ static struct init_tree_node {
 					  FS_CAP(flow_table_properties_nic_receive.identified_miss_table_mode),
 					  FS_CAP(flow_table_properties_nic_receive.flow_table_modify)),
 			 ADD_NS(ADD_MULTIPLE_PRIO(LEFTOVERS_NUM_PRIOS, LEFTOVERS_MAX_FT))),
+		ADD_PRIO(0, ANCHOR_MIN_LEVEL, 0, {},
+			 ADD_NS(ADD_MULTIPLE_PRIO(ANCHOR_NUM_PRIOS, ANCHOR_MAX_FT))),
 	}
 };
 
@@ -1126,6 +1131,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 	case MLX5_FLOW_NAMESPACE_BYPASS:
 	case MLX5_FLOW_NAMESPACE_KERNEL:
 	case MLX5_FLOW_NAMESPACE_LEFTOVERS:
+	case MLX5_FLOW_NAMESPACE_ANCHOR:
 		prio = type;
 		break;
 	case MLX5_FLOW_NAMESPACE_FDB:
@@ -1351,6 +1357,25 @@ static void set_prio_attrs(struct mlx5_flow_root_namespace *root_ns)
 	}
 }
 
+#define ANCHOR_PRIO 0
+#define ANCHOR_SIZE 1
+static int create_anchor_flow_table(struct mlx5_core_dev
+							*dev)
+{
+	struct mlx5_flow_namespace *ns = NULL;
+	struct mlx5_flow_table *ft;
+
+	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_ANCHOR);
+	if (!ns)
+		return -EINVAL;
+	ft = mlx5_create_flow_table(ns, ANCHOR_PRIO, ANCHOR_SIZE);
+	if (IS_ERR(ft)) {
+		mlx5_core_err(dev, "Failed to create last anchor flow table");
+		return PTR_ERR(ft);
+	}
+	return 0;
+}
+
 static int init_root_ns(struct mlx5_core_dev *dev)
 {
 
@@ -1363,6 +1388,9 @@ static int init_root_ns(struct mlx5_core_dev *dev)
 
 	set_prio_attrs(dev->priv.root_ns);
 
+	if (create_anchor_flow_table(dev))
+		goto cleanup;
+
 	return 0;
 
 cleanup:
@@ -1392,6 +1420,15 @@ static void cleanup_single_prio_root_ns(struct mlx5_core_dev *dev,
 	root_ns = NULL;
 }
 
+static void destroy_flow_tables(struct fs_prio *prio)
+{
+	struct mlx5_flow_table *iter;
+	struct mlx5_flow_table *tmp;
+
+	fs_for_each_ft_safe(iter, tmp, prio)
+		mlx5_destroy_flow_table(iter);
+}
+
 static void cleanup_root_ns(struct mlx5_core_dev *dev)
 {
 	struct mlx5_flow_root_namespace *root_ns = dev->priv.root_ns;
@@ -1420,6 +1457,7 @@ static void cleanup_root_ns(struct mlx5_core_dev *dev)
 							 list);
 
 				fs_get_obj(obj_iter_prio2, iter_prio2);
+				destroy_flow_tables(obj_iter_prio2);
 				if (tree_remove_node(iter_prio2)) {
 					mlx5_core_warn(dev,
 						       "Priority %d wasn't destroyed, refcount > 1\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 00245fd..574a903 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -142,6 +142,9 @@ void mlx5_cleanup_fs(struct mlx5_core_dev *dev);
 #define fs_list_for_each_entry(pos, root)		\
 	list_for_each_entry(pos, root, node.list)
 
+#define fs_list_for_each_entry_safe(pos, tmp, root)		\
+	list_for_each_entry_safe(pos, tmp, root, node.list)
+
 #define fs_for_each_ns_or_ft_reverse(pos, prio)				\
 	list_for_each_entry_reverse(pos, &(prio)->node.children, list)
 
@@ -157,6 +160,9 @@ void mlx5_cleanup_fs(struct mlx5_core_dev *dev);
 #define fs_for_each_ft(pos, prio)			\
 	fs_list_for_each_entry(pos, &(prio)->node.children)
 
+#define fs_for_each_ft_safe(pos, tmp, prio)			\
+	fs_list_for_each_entry_safe(pos, tmp, &(prio)->node.children)
+
 #define fs_for_each_fg(pos, ft)			\
 	fs_list_for_each_entry(pos, &(ft)->node.children)
 
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 8230caa..72adf53 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -52,6 +52,7 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_BYPASS,
 	MLX5_FLOW_NAMESPACE_KERNEL,
 	MLX5_FLOW_NAMESPACE_LEFTOVERS,
+	MLX5_FLOW_NAMESPACE_ANCHOR,
 	MLX5_FLOW_NAMESPACE_FDB,
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

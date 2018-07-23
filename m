From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 8/8] IB/mlx5: Expose vendor flow trees
Date: Mon, 23 Jul 2018 15:25:12 +0300
Message-ID: <20180723122512.20967-9-leon@kernel.org>
References: <20180723122512.20967-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180723122512.20967-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose mlx5 flow trees to be used by upper layers.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c    | 9 +++++++++
 drivers/infiniband/hw/mlx5/main.c    | 4 +++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 3 +++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index 21e31f2a8f72..c94ee1a43e2c 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -243,3 +243,12 @@ DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_FLOW_MATCHER,
 DECLARE_UVERBS_OBJECT_TREE(flow_objects,
 			&UVERBS_OBJECT(MLX5_IB_OBJECT_FLOW_MATCHER));
 
+int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root)
+{
+	int i = 0;
+
+	root[i++] = &flow_objects;
+	root[i++] = &mlx5_ib_fs;
+
+	return i;
+}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d750562cb2c5..71f3e9677622 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5537,7 +5537,7 @@ ADD_UVERBS_ATTRIBUTES_SIMPLE(
 			   UVERBS_ATTR_TYPE(u64),
 			   UA_MANDATORY));
 
-#define NUM_TREES	3
+#define NUM_TREES	5
 static int populate_specs_root(struct mlx5_ib_dev *dev)
 {
 	const struct uverbs_object_tree_def *default_root[NUM_TREES + 1] = {
@@ -5557,6 +5557,8 @@ static int populate_specs_root(struct mlx5_ib_dev *dev)
 	    !WARN_ON(num_trees >= ARRAY_SIZE(default_root)))
 		default_root[num_trees++] = mlx5_ib_get_devx_tree();
 
+	num_trees += mlx5_ib_get_flow_trees(default_root + num_trees);
+
 	dev->ib_dev.driver_specs_root =
 		uverbs_alloc_spec_tree(num_trees, default_root);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 600cd3f78232..5f08b69f8a4f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1238,6 +1238,7 @@ struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 						     int inlen, int dest_id,
 						     int dest_type);
 bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id, int *dest_type);
+int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root);
 #else
 static inline int
 mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
@@ -1255,6 +1256,8 @@ mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 static inline bool
 mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id,
 			  int *dest_type) { return false; };
+static inline int
+mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root) { return 0; };
 #endif
 static inline void init_query_mad(struct ib_smp *mad)
 {
-- 
2.14.4

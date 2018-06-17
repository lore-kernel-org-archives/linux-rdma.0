From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 20/20] IB/mlx5: Expose DEVX tree
Date: Sun, 17 Jun 2018 13:00:06 +0300
Message-ID: <20180617100006.30663-21-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose DEVX tree to be used by upper layers.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c    | 5 +++++
 drivers/infiniband/hw/mlx5/main.c    | 7 ++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 3 +++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index de1a418331b2..875f8c705ab9 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1099,3 +1099,8 @@ static DECLARE_UVERBS_OBJECT_TREE(devx_objects,
 	&UVERBS_OBJECT(MLX5_IB_OBJECT_DEVX),
 	&UVERBS_OBJECT(MLX5_IB_OBJECT_DEVX_OBJ),
 	&UVERBS_OBJECT(MLX5_IB_OBJECT_DEVX_UMEM));
+
+const struct uverbs_object_tree_def *mlx5_ib_get_devx_tree(void)
+{
+	return &devx_objects;
+}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 430a9e36d392..c7c31bbbca72 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5290,7 +5290,7 @@ ADD_UVERBS_ATTRIBUTES_SIMPLE(mlx5_ib_flow_action, UVERBS_OBJECT_FLOW_ACTION,
 						 UVERBS_ATTR_TYPE(u64),
 						 UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
 
-#define NUM_TREES	2
+#define NUM_TREES	3
 static int populate_specs_root(struct mlx5_ib_dev *dev)
 {
 	const struct uverbs_object_tree_def *default_root[NUM_TREES + 1] = {
@@ -5305,6 +5305,11 @@ static int populate_specs_root(struct mlx5_ib_dev *dev)
 	    !WARN_ON(num_trees >= ARRAY_SIZE(default_root)))
 		default_root[num_trees++] = &mlx5_ib_dm;
 
+	if (MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
+			    MLX5_GENERAL_OBJ_TYPES_CAP_UCTX &&
+	    !WARN_ON(num_trees >= ARRAY_SIZE(default_root)))
+		default_root[num_trees++] = mlx5_ib_get_devx_tree();
+
 	dev->ib_dev.specs_root =
 		uverbs_alloc_spec_tree(num_trees, default_root);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a5560375047a..be8615de14fc 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1223,12 +1223,15 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
 			struct mlx5_ib_ucontext *context);
 void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
 			  struct mlx5_ib_ucontext *context);
+const struct uverbs_object_tree_def *mlx5_ib_get_devx_tree(void);
 #else
 static inline int
 mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
 		    struct mlx5_ib_ucontext *context) { return -EOPNOTSUPP; };
 static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
 					struct mlx5_ib_ucontext *context) {}
+static inline const struct uverbs_object_tree_def *
+mlx5_ib_get_devx_tree(void) { return NULL; }
 #endif
 static inline void init_query_mad(struct ib_smp *mad)
 {
-- 
2.14.4

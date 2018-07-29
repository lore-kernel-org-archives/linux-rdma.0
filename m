From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 13/27] RDMA/mlx5: Add a new flow action verb, modify header
Date: Sun, 29 Jul 2018 15:58:51 +0300
Message-ID: <20180729125905.31989-14-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Expose the ability to create a flow action which mutates packet
headers. The data passed from userspace should be modify header actions
as defined by Mellanox's PRM.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c         | 128 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c         |   5 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |  15 ++++
 include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  10 +++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |   5 ++
 5 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index ee398a9b5f26..2c7d75cb8ade 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -8,6 +8,7 @@
 #include <rdma/uverbs_types.h>
 #include <rdma/uverbs_ioctl.h>
 #include <rdma/mlx5_user_ioctl_cmds.h>
+#include <rdma/mlx5_user_ioctl_verbs.h>
 #include <rdma/ib_umem.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/fs.h>
@@ -177,6 +178,114 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	return err;
 }
 
+static int mlx5_ib_ft_type_to_namespace(u8 table_type, u8 *namespace)
+{
+	switch (table_type) {
+	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_RX:
+		*namespace = MLX5_FLOW_NAMESPACE_BYPASS;
+		break;
+	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_TX:
+		*namespace = MLX5_FLOW_NAMESPACE_EGRESS;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_flow_action *maction)
+{
+	switch (maction->flow_action_raw.sub_type) {
+	case MLX5_IB_FLOW_ACTION_MODIFY_HEADER:
+		mlx5_modify_header_dealloc(maction->flow_action_raw.dev->mdev,
+					   maction->flow_action_raw.action_id);
+		break;
+	default:
+		WARN_ON(true);
+		break;
+	}
+}
+
+static struct ib_flow_action *
+mlx5_ib_create_modify_header(struct mlx5_ib_dev *dev, u8 ft_type,
+			     u8 num_actions, void *in)
+{
+	struct mlx5_ib_flow_action *maction;
+	u8 namespace;
+	int ret;
+
+	ret = mlx5_ib_ft_type_to_namespace(ft_type, &namespace);
+	if (ret)
+		return ERR_PTR(-EINVAL);
+
+	maction = kzalloc(sizeof(*maction), GFP_KERNEL);
+	if (!maction)
+		return ERR_PTR(-ENOMEM);
+
+	ret = mlx5_modify_header_alloc(dev->mdev, namespace, num_actions, in,
+				       &maction->flow_action_raw.action_id);
+
+	if (ret) {
+		kfree(maction);
+		return ERR_PTR(ret);
+	}
+	maction->flow_action_raw.sub_type =
+		MLX5_IB_FLOW_ACTION_MODIFY_HEADER;
+	maction->flow_action_raw.dev = dev;
+
+	return &maction->ib_action;
+}
+
+static bool mlx5_ib_modify_header_supported(struct mlx5_ib_dev *dev)
+{
+	return MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, max_modify_header_actions) ||
+	       MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, max_modify_header_actions);
+}
+
+static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(struct ib_device *ib_dev,
+									   struct ib_uverbs_file *file,
+									   struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
+					MLX5_IB_ATTR_CREATE_MODIFY_HEADER_HANDLE);
+	struct mlx5_ib_dev *mdev = to_mdev(uobj->context->device);
+	enum mlx5_ib_uapi_flow_table_type ft_type;
+	struct ib_flow_action *action;
+	void *in;
+	int len;
+	int ret;
+
+	if (!mlx5_ib_modify_header_supported(mdev))
+		return -EOPNOTSUPP;
+
+	in = uverbs_attr_get_alloced_ptr(attrs,
+					 MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM);
+	len = uverbs_attr_get_len(attrs, MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM);
+
+	if (len % MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto))
+		return -EINVAL;
+
+	ret = uverbs_get_const(&ft_type, attrs,
+			       MLX5_IB_ATTR_CREATE_MODIFY_HEADER_FT_TYPE);
+	if (ret)
+		return -EINVAL;
+
+	action = mlx5_ib_create_modify_header(mdev, ft_type,
+					      len / MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto),
+					      in);
+	if (IS_ERR(action))
+		return PTR_ERR(action);
+
+	atomic_set(&action->usecnt, 0);
+	action->device = uobj->context->device;
+	action->type = IB_FLOW_ACTION_UNSPECIFIED;
+	action->uobject = uobj;
+	uobj->object = action;
+
+	return 0;
+}
+
 DECLARE_UVERBS_NAMED_METHOD(
 	MLX5_IB_METHOD_CREATE_FLOW,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_HANDLE,
@@ -211,6 +320,24 @@ ADD_UVERBS_METHODS(mlx5_ib_fs,
 		   &UVERBS_METHOD(MLX5_IB_METHOD_CREATE_FLOW),
 		   &UVERBS_METHOD(MLX5_IB_METHOD_DESTROY_FLOW));
 
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_MODIFY_HEADER_HANDLE,
+			UVERBS_OBJECT_FLOW_ACTION,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM,
+			   UVERBS_ATTR_MIN_SIZE(MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)),
+			   UA_MANDATORY,
+			   UA_ALLOC_AND_COPY),
+	UVERBS_ATTR_CONST_IN(MLX5_IB_ATTR_CREATE_MODIFY_HEADER_FT_TYPE,
+			     enum mlx5_ib_uapi_flow_table_type,
+			     UA_MANDATORY));
+
+ADD_UVERBS_METHODS(mlx5_ib_flow_actions,
+		   UVERBS_OBJECT_FLOW_ACTION,
+		   &UVERBS_METHOD(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER));
+
 DECLARE_UVERBS_NAMED_METHOD(
 	MLX5_IB_METHOD_FLOW_MATCHER_CREATE,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE,
@@ -249,6 +376,7 @@ int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root)
 
 	root[i++] = &flow_objects;
 	root[i++] = &mlx5_ib_fs;
+	root[i++] = &mlx5_ib_flow_actions;
 
 	return i;
 }
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b3281e408d2a..b56ac6614be6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3997,6 +3997,9 @@ static int mlx5_ib_destroy_flow_action(struct ib_flow_action *action)
 		 */
 		mlx5_accel_esp_destroy_xfrm(maction->esp_aes_gcm.ctx);
 		break;
+	case IB_FLOW_ACTION_UNSPECIFIED:
+		mlx5_ib_destroy_flow_action_raw(maction);
+		break;
 	default:
 		WARN_ON(true);
 		break;
@@ -5533,7 +5536,7 @@ ADD_UVERBS_ATTRIBUTES_SIMPLE(
 	UVERBS_ATTR_FLAGS_IN(MLX5_IB_ATTR_CREATE_FLOW_ACTION_FLAGS,
 			     enum mlx5_ib_uapi_flow_action_flags));
 
-#define NUM_TREES	5
+#define NUM_TREES	6
 static int populate_specs_root(struct mlx5_ib_dev *dev)
 {
 	const struct uverbs_object_tree_def *default_root[NUM_TREES + 1] = {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 01bef4c2d396..b5dd68114588 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -151,6 +151,10 @@ struct mlx5_ib_pd {
 	u32			pdn;
 };
 
+enum {
+	MLX5_IB_FLOW_ACTION_MODIFY_HEADER,
+};
+
 #define MLX5_IB_FLOW_MCAST_PRIO		(MLX5_BY_PASS_NUM_PRIOS - 1)
 #define MLX5_IB_FLOW_LAST_PRIO		(MLX5_BY_PASS_NUM_REGULAR_PRIOS - 1)
 #if (MLX5_IB_FLOW_LAST_PRIO <= 0)
@@ -815,6 +819,11 @@ struct mlx5_ib_flow_action {
 			u64			    ib_flags;
 			struct mlx5_accel_esp_xfrm *ctx;
 		} esp_aes_gcm;
+		struct {
+			struct mlx5_ib_dev *dev;
+			u32 sub_type;
+			u32 action_id;
+		} flow_action_raw;
 	};
 };
 
@@ -1238,6 +1247,7 @@ struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(
 	void *cmd_in, int inlen, int dest_id, int dest_type);
 bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id, int *dest_type);
 int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root);
+void mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_flow_action *maction);
 #else
 static inline int
 mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
@@ -1256,6 +1266,11 @@ mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root)
 {
 	return 0;
 }
+static inline void
+mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_flow_action *maction)
+{
+	return;
+};
 #endif
 static inline void init_query_mad(struct ib_smp *mad)
 {
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 9c51801b9e64..9c83e13c0e89 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -166,4 +166,14 @@ enum mlx5_ib_flow_methods {
 	MLX5_IB_METHOD_DESTROY_FLOW,
 };
 
+enum mlx5_ib_flow_action_methods {
+	MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum mlx5_ib_create_flow_action_create_modify_header_attrs {
+	MLX5_IB_ATTR_CREATE_MODIFY_HEADER_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM,
+	MLX5_IB_ATTR_CREATE_MODIFY_HEADER_FT_TYPE,
+};
+
 #endif
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index 8a2fb33f3ed4..ceb6d0d8529a 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -39,5 +39,10 @@ enum mlx5_ib_uapi_flow_action_flags {
 	MLX5_IB_UAPI_FLOW_ACTION_FLAGS_REQUIRE_METADATA	= 1 << 0,
 };
 
+enum mlx5_ib_uapi_flow_table_type {
+	MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_RX     = 0x0,
+	MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_TX	= 0x1,
+};
+
 #endif
 
-- 
2.14.4

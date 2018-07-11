From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 5/8] IB/mlx5: Introduce vendor create and destroy flow methods
Date: Wed, 11 Jul 2018 14:10:42 +0300
Message-ID: <20180711111045.6282-6-leon@kernel.org>
References: <20180711111045.6282-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180711111045.6282-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Introduce vendor create and destroy flow methods on the uverbs flow
object.

This enables the driver to get its specific device attributes to match
the underlay specification while still using the generic ib_flow object
for cleanup and code sharing.

The IB object's attributes are set via ib_set_flow() helper function.

The specific implementation for the given specification is added in
downstream patches.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c        |  22 +++++++
 drivers/infiniband/hw/mlx5/flow.c        | 108 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c        |   9 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  15 +++++
 include/rdma/ib_verbs.h                  |  14 ++++
 include/rdma/uverbs_named_ioctl.h        |  29 +++++----
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  17 +++++
 7 files changed, 202 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 60ac1fbe940e..32c7d8c71d85 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -89,6 +89,28 @@ void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
 	mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
 }
 
+bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id, int *dest_type)
+{
+	struct devx_obj *devx_obj = obj;
+	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, devx_obj->dinbox, opcode);
+
+	switch (opcode) {
+	case MLX5_CMD_OP_DESTROY_TIR:
+		*dest_type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+		*dest_id = MLX5_GET(general_obj_in_cmd_hdr, devx_obj->dinbox,
+				    obj_id);
+		return true;
+
+	case MLX5_CMD_OP_DESTROY_FLOW_TABLE:
+		*dest_type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		*dest_id = MLX5_GET(destroy_flow_table_in, devx_obj->dinbox,
+				    table_id);
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int devx_is_valid_obj_id(struct devx_obj *obj, const void *in)
 {
 	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index f1c16defe7ff..76e76b87e5e9 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -38,6 +38,81 @@ static const struct uverbs_attr_spec mlx5_ib_flow_type[] = {
 	},
 };
 
+static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(struct ib_device *ib_dev,
+						      struct ib_uverbs_file *file,
+						      struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_flow_handler *flow_handler;
+	struct mlx5_ib_flow_matcher *fs_matcher;
+	void *devx_obj;
+	int dest_id, dest_type;
+	void *cmd_in;
+	int inlen;
+	bool dest_devx, dest_qp;
+	struct ib_qp *qp = NULL;
+	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
+                         MLX5_IB_ATTR_CREATE_FLOW_HANDLE);
+	struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
+
+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
+	dest_devx = uverbs_attr_is_valid(attrs,
+					 MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX);
+	dest_qp = uverbs_attr_is_valid(attrs,
+				       MLX5_IB_ATTR_CREATE_FLOW_DEST_QP);
+
+	if ((dest_devx && dest_qp) || (!dest_devx && !dest_qp))
+		return -EINVAL;
+
+	if (dest_devx) {
+		devx_obj = uverbs_attr_get_obj(attrs, MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX);
+		if (IS_ERR(devx_obj))
+			return PTR_ERR(devx_obj);
+
+		/* Verify that the given DEVX object is a flow
+		 * steering destination.
+		 */
+		if (!mlx5_ib_devx_is_flow_dest(devx_obj, &dest_id, &dest_type))
+			return -EINVAL;
+	} else {
+		struct mlx5_ib_qp *mqp;
+
+		qp = uverbs_attr_get_obj(attrs,
+					 MLX5_IB_ATTR_CREATE_FLOW_DEST_QP);
+		if (IS_ERR(qp))
+			return PTR_ERR(qp);
+
+		if (qp->qp_type != IB_QPT_RAW_PACKET)
+			return -EINVAL;
+
+		mqp = to_mqp(qp);
+		if (mqp->flags & MLX5_IB_QP_RSS)
+			dest_id = mqp->rss_qp.tirn;
+		else
+			dest_id = mqp->raw_packet_qp.rq.tirn;
+		dest_type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+	}
+
+	if (dev->rep)
+		return -ENOTSUPP;
+
+	cmd_in = uverbs_attr_get_alloced_ptr(attrs,
+					     MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE);
+	inlen = uverbs_attr_get_len(attrs,
+				    MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE);
+	fs_matcher = uverbs_attr_get_obj(attrs,
+					 MLX5_IB_ATTR_CREATE_FLOW_MATCHER);
+	flow_handler = mlx5_ib_raw_fs_rule_add(dev, fs_matcher, cmd_in, inlen,
+					       dest_id, dest_type);
+	if (IS_ERR(flow_handler))
+		return PTR_ERR(flow_handler);
+
+	ib_set_flow(uobj, &flow_handler->ibflow, qp, ib_dev);
+
+	return 0;
+}
+
 static int flow_matcher_cleanup(struct ib_uobject *uobject,
 				enum rdma_remove_reason why)
 {
@@ -101,6 +176,39 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(struct ib_device *
 	return err;
 }
 
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_CREATE_FLOW,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_HANDLE,
+			UVERBS_OBJECT_FLOW,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE,
+			   UVERBS_ATTR_SIZE(1, sizeof(struct mlx5_ib_match_params)),
+			   UA_MANDATORY,
+			   UA_ALLOC_AND_COPY),
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_MATCHER,
+			MLX5_IB_OBJECT_FLOW_MATCHER,
+			UVERBS_ACCESS_READ,
+			UA_MANDATORY),
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_DEST_QP, UVERBS_OBJECT_QP,
+			UVERBS_ACCESS_READ),
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX,
+			MLX5_IB_OBJECT_DEVX_OBJ,
+			UVERBS_ACCESS_READ));
+
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(
+	MLX5_IB_METHOD_DESTROY_FLOW,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_HANDLE,
+			UVERBS_OBJECT_FLOW,
+			UVERBS_ACCESS_DESTROY,
+			UA_MANDATORY));
+
+ADD_UVERBS_METHODS(mlx5_ib_fs,
+		   UVERBS_OBJECT_FLOW,
+		   &UVERBS_METHOD(MLX5_IB_METHOD_CREATE_FLOW),
+		   &UVERBS_METHOD(MLX5_IB_METHOD_DESTROY_FLOW));
+
 DECLARE_UVERBS_NAMED_METHOD(
 	MLX5_IB_METHOD_FLOW_MATCHER_CREATE,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b7f94bc3811a..53e30449477e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3643,6 +3643,15 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	return ERR_PTR(err);
 }
 
+struct mlx5_ib_flow_handler *
+mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
+			struct mlx5_ib_flow_matcher *fs_matcher,
+			void *cmd_in, int inlen, int dest_id,
+			int dest_type)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static u32 mlx5_ib_flow_action_flags_to_accel_xfrm_flags(u32 mlx5_flags)
 {
 	u32 flags = 0;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 3d9544ec996f..7c502052cb87 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1236,6 +1236,12 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
 void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
 			  struct mlx5_ib_ucontext *context);
 const struct uverbs_object_tree_def *mlx5_ib_get_devx_tree(void);
+struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
+						     struct mlx5_ib_flow_matcher *fs_matcher,
+						     void *cmd_in,
+						     int inlen, int dest_id,
+						     int dest_type);
+bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id, int *dest_type);
 #else
 static inline int
 mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
@@ -1244,6 +1250,15 @@ static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
 					struct mlx5_ib_ucontext *context) {}
 static inline const struct uverbs_object_tree_def *
 mlx5_ib_get_devx_tree(void) { return NULL; }
+static inline struct mlx5_ib_flow_handler *
+mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
+			struct mlx5_ib_flow_matcher *fs_matcher,
+			void *cmd_in,
+			int inlen, int dest_id,
+			int dest_type) { return -EOPNOTSUPP; };
+static inline bool
+mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id,
+			  int *dest_type) { return false; };
 #endif
 static inline void init_query_mad(struct ib_smp *mad)
 {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d02bbbafbd3c..d360e6f381c8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4137,6 +4137,20 @@ ib_get_vector_affinity(struct ib_device *device, int comp_vector)
 
 }
 
+static inline void ib_set_flow(struct ib_uobject *uobj, struct ib_flow *ibflow,
+			       struct ib_qp *qp, struct ib_device *device)
+{
+	uobj->object = ibflow;
+	ibflow->uobject = uobj;
+
+	if (qp) {
+		atomic_inc(&qp->usecnt);
+		ibflow->qp = qp;
+	}
+
+	ibflow->device = device;
+}
+
 /**
  * rdma_roce_rescan_device - Rescan all of the network devices in the system
  * and add their gids, as needed, to the relevant RoCE devices.
diff --git a/include/rdma/uverbs_named_ioctl.h b/include/rdma/uverbs_named_ioctl.h
index 2eb1767042af..b3b21733cc55 100644
--- a/include/rdma/uverbs_named_ioctl.h
+++ b/include/rdma/uverbs_named_ioctl.h
@@ -97,22 +97,14 @@
 		.methods = &UVERBS_OBJECT_METHODS(_object_id)                  \
 	}
 
-/* Used by drivers to declare a complete parsing tree for a single method that
- * differs only in having additional driver specific attributes.
+/* Used by drivers to declare a complete parsing tree for new methods
  */
-#define ADD_UVERBS_ATTRIBUTES_SIMPLE(_name, _object_id, _method_id, ...)       \
-	static const struct uverbs_attr_def *const UVERBS_METHOD_ATTRS(        \
-		_method_id)[] = { __VA_ARGS__ };                               \
-	static const struct uverbs_method_def UVERBS_METHOD(_method_id) = {    \
-		.id = _method_id,                                              \
-		.num_attrs = ARRAY_SIZE(UVERBS_METHOD_ATTRS(_method_id)),      \
-		.attrs = &UVERBS_METHOD_ATTRS(_method_id),                     \
-	};                                                                     \
+#define ADD_UVERBS_METHODS(_name, _object_id, ...)                             \
 	static const struct uverbs_method_def *const UVERBS_OBJECT_METHODS(    \
-		_object_id)[] = { &UVERBS_METHOD(_method_id) };                \
+		_object_id)[] = { __VA_ARGS__ };                               \
 	static const struct uverbs_object_def _name##_struct = {               \
 		.id = _object_id,                                              \
-		.num_methods = 1,                                              \
+		.num_methods = ARRAY_SIZE(UVERBS_OBJECT_METHODS(_object_id)),  \
 		.methods = &UVERBS_OBJECT_METHODS(_object_id)                  \
 	};                                                                     \
 	static const struct uverbs_object_def *const _name##_ptrs[] = {        \
@@ -123,4 +115,17 @@
 		.objects = &_name##_ptrs,                                      \
 	}
 
+/* Used by drivers to declare a complete parsing tree for a single method that
+ * differs only in having additional driver specific attributes.
+ */
+#define ADD_UVERBS_ATTRIBUTES_SIMPLE(_name, _object_id, _method_id, ...)       \
+	static const struct uverbs_attr_def *const UVERBS_METHOD_ATTRS(        \
+		_method_id)[] = { __VA_ARGS__ };                               \
+	static const struct uverbs_method_def UVERBS_METHOD(_method_id) = {    \
+		.id = _method_id,                                              \
+		.num_attrs = ARRAY_SIZE(UVERBS_METHOD_ATTRS(_method_id)),      \
+		.attrs = &UVERBS_METHOD_ATTRS(_method_id),                     \
+	};                                                                     \
+	ADD_UVERBS_METHODS(_name, _object_id, &UVERBS_METHOD(_method_id))
+
 #endif
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 233d5d140179..9c51801b9e64 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -149,4 +149,21 @@ enum mlx5_ib_flow_type {
 	MLX5_IB_FLOW_TYPE_MC_DEFAULT,
 };
 
+enum mlx5_ib_create_flow_attrs {
+	MLX5_IB_ATTR_CREATE_FLOW_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE,
+	MLX5_IB_ATTR_CREATE_FLOW_DEST_QP,
+	MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX,
+	MLX5_IB_ATTR_CREATE_FLOW_MATCHER,
+};
+
+enum mlx5_ib_destoy_flow_attrs {
+	MLX5_IB_ATTR_DESTROY_FLOW_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum mlx5_ib_flow_methods {
+	MLX5_IB_METHOD_CREATE_FLOW = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_METHOD_DESTROY_FLOW,
+};
+
 #endif
-- 
2.14.4

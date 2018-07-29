From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 27/27] RDMA/mlx5: Allow creating a matcher for a NIC TX flow table
Date: Sun, 29 Jul 2018 15:59:05 +0300
Message-ID: <20180729125905.31989-28-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Currently a matcher can only be created and attached to a NIC RX flow
table. Extend it to allow it on NIC TX flow tables as well.

In order to achieve that, We:

1) Expose a new attribute: MLX5_IB_ATTR_FLOW_MATCHER_FLOW_FLAGS.
   enum ib_flow_flags is used as valid flags. Only
   IB_FLOW_ATTR_FLAGS_EGRESS is supported.

2) Remove the requirement to have a DEVX or QP destination when creating a
   flow. A flow added to NIC TX flow table will forward the packet outside
   of the vport (Wire or E-Switch in the SR-iOV case).

Only a single flow action can be attached to a flow rule at the moment.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c        | 62 +++++++++++++++++++++-----------
 drivers/infiniband/hw/mlx5/main.c        |  5 ++-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  1 +
 3 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index 2422629f48c9..26c5112100e6 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -18,6 +18,22 @@
 #define UVERBS_MODULE_NAME mlx5_ib
 #include <rdma/uverbs_named_ioctl.h>
 
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
 static const struct uverbs_attr_spec mlx5_ib_flow_type[] = {
 	[MLX5_IB_FLOW_TYPE_NORMAL] = {
 		.type = UVERBS_ATTR_TYPE_PTR_IN,
@@ -69,7 +85,14 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	dest_qp = uverbs_attr_is_valid(attrs,
 				       MLX5_IB_ATTR_CREATE_FLOW_DEST_QP);
 
-	if ((dest_devx && dest_qp) || (!dest_devx && !dest_qp))
+	fs_matcher = uverbs_attr_get_obj(attrs,
+					 MLX5_IB_ATTR_CREATE_FLOW_MATCHER);
+	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_BYPASS &&
+	    ((dest_devx && dest_qp) || (!dest_devx && !dest_qp)))
+		return -EINVAL;
+
+	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_EGRESS &&
+	    (dest_devx || dest_qp))
 		return -EINVAL;
 
 	if (dest_devx) {
@@ -83,7 +106,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 		 */
 		if (!mlx5_ib_devx_is_flow_dest(devx_obj, &dest_id, &dest_type))
 			return -EINVAL;
-	} else {
+	} else if (dest_qp) {
 		struct mlx5_ib_qp *mqp;
 
 		qp = uverbs_attr_get_obj(attrs,
@@ -100,6 +123,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 		else
 			dest_id = mqp->raw_packet_qp.rq.tirn;
 		dest_type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+	} else {
+		dest_type = MLX5_FLOW_DESTINATION_TYPE_PORT;
 	}
 
 	if (dev->rep)
@@ -109,8 +134,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 		attrs, MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE);
 	inlen = uverbs_attr_get_len(attrs,
 				    MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE);
-	fs_matcher = uverbs_attr_get_obj(attrs,
-					 MLX5_IB_ATTR_CREATE_FLOW_MATCHER);
 
 	len = uverbs_attr_get_uobjs_arr(attrs,
 					MLX5_IB_ATTR_CREATE_FLOW_ARR_FLOW_ACTIONS,
@@ -156,6 +179,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 		attrs, MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE);
 	struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
 	struct mlx5_ib_flow_matcher *obj;
+	u32 flags;
 	int err;
 
 	obj = kzalloc(sizeof(struct mlx5_ib_flow_matcher), GFP_KERNEL);
@@ -188,6 +212,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	if (err)
 		goto end;
 
+	err = uverbs_get_flags32(&flags, attrs,
+				 MLX5_IB_ATTR_FLOW_MATCHER_FLOW_FLAGS,
+				 IB_FLOW_ATTR_FLAGS_EGRESS);
+	if (!err && flags) {
+		err = mlx5_ib_ft_type_to_namespace(MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_TX,
+						   &obj->ns_type);
+		if (err)
+			goto end;
+	}
+
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
 	atomic_set(&obj->usecnt, 0);
@@ -198,22 +232,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	return err;
 }
 
-static int mlx5_ib_ft_type_to_namespace(u8 table_type, u8 *namespace)
-{
-	switch (table_type) {
-	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_RX:
-		*namespace = MLX5_FLOW_NAMESPACE_BYPASS;
-		break;
-	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_TX:
-		*namespace = MLX5_FLOW_NAMESPACE_EGRESS;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 void mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_flow_action *maction)
 {
 	switch (maction->flow_action_raw.sub_type) {
@@ -542,7 +560,9 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UA_MANDATORY),
 	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_FLOW_MATCHER_MATCH_CRITERIA,
 			   UVERBS_ATTR_TYPE(u8),
-			   UA_MANDATORY));
+			   UA_MANDATORY),
+	UVERBS_ATTR_FLAGS_IN(MLX5_IB_ATTR_FLOW_MATCHER_FLOW_FLAGS,
+			     enum ib_flow_flags));
 
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	MLX5_IB_METHOD_FLOW_MATCHER_DESTROY,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ba4bcbc3adb6..08bf16161435 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3866,10 +3866,13 @@ mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 		dst->type = dest_type;
 		dst->tir_num = dest_id;
 		flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	} else {
+	} else if (dest_type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE) {
 		dst->type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM;
 		dst->ft_num = dest_id;
 		flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	} else {
+		dst->type = MLX5_FLOW_DESTINATION_TYPE_PORT;
+		flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	}
 
 	handler = _create_raw_flow_rule(dev, ft_prio, dst, fs_matcher, flow_act,
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 91c3d42ebd0f..fb4a8b17cca8 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -125,6 +125,7 @@ enum mlx5_ib_flow_matcher_create_attrs {
 	MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK,
 	MLX5_IB_ATTR_FLOW_MATCHER_FLOW_TYPE,
 	MLX5_IB_ATTR_FLOW_MATCHER_MATCH_CRITERIA,
+	MLX5_IB_ATTR_FLOW_MATCHER_FLOW_FLAGS,
 };
 
 enum mlx5_ib_flow_matcher_destroy_attrs {
-- 
2.14.4

From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 25/27] RDMA/mlx5: Add flow actions support to DEVX create flow
Date: Sun, 29 Jul 2018 15:59:03 +0300
Message-ID: <20180729125905.31989-26-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Support attaching flow actions to a flow rule via DEVX.
For now only NIC RX path is supported.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c        | 21 ++++++++++++++++++++-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index 072b8fc7e057..b254b55e8de0 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -47,6 +47,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	struct mlx5_flow_act flow_act = {.flow_tag = MLX5_FS_DEFAULT_FLOW_TAG};
 	struct mlx5_ib_flow_handler *flow_handler;
 	struct mlx5_ib_flow_matcher *fs_matcher;
+	struct ib_uobject **arr_flow_actions;
 	void *devx_obj;
 	int dest_id, dest_type;
 	void *cmd_in;
@@ -56,6 +57,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	struct ib_uobject *uobj =
 		uverbs_attr_get_uobject(attrs, MLX5_IB_ATTR_CREATE_FLOW_HANDLE);
 	struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
+	int len;
+	int ret;
+	int i;
 
 	if (!capable(CAP_NET_RAW))
 		return -EPERM;
@@ -107,6 +111,18 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 				    MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE);
 	fs_matcher = uverbs_attr_get_obj(attrs,
 					 MLX5_IB_ATTR_CREATE_FLOW_MATCHER);
+
+	len = uverbs_attr_get_uobjs_arr(attrs,
+					MLX5_IB_ATTR_CREATE_FLOW_ARR_FLOW_ACTIONS,
+					&arr_flow_actions);
+	for (i = 0; i < len; i++) {
+		struct mlx5_ib_flow_action *maction = to_mflow_act(arr_flow_actions[i]->object);
+
+		ret = parse_flow_flow_action(maction, false, &flow_act);
+		if (ret)
+			return -EINVAL;
+	}
+
 	flow_handler = mlx5_ib_raw_fs_rule_add(dev, fs_matcher, &flow_act,
 					       cmd_in, inlen,
 					       dest_id, dest_type);
@@ -458,7 +474,10 @@ DECLARE_UVERBS_NAMED_METHOD(
 			UVERBS_ACCESS_READ),
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX,
 			MLX5_IB_OBJECT_DEVX_OBJ,
-			UVERBS_ACCESS_READ));
+			UVERBS_ACCESS_READ),
+	UVERBS_ATTR_IDRS_ARR(MLX5_IB_ATTR_CREATE_FLOW_ARR_FLOW_ACTIONS,
+			     UVERBS_OBJECT_FLOW_ACTION,
+			     UVERBS_ACCESS_READ, 1, 1));
 
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	MLX5_IB_METHOD_DESTROY_FLOW,
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 75c7093fd95b..91c3d42ebd0f 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -155,6 +155,7 @@ enum mlx5_ib_create_flow_attrs {
 	MLX5_IB_ATTR_CREATE_FLOW_DEST_QP,
 	MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX,
 	MLX5_IB_ATTR_CREATE_FLOW_MATCHER,
+	MLX5_IB_ATTR_CREATE_FLOW_ARR_FLOW_ACTIONS,
 };
 
 enum mlx5_ib_destoy_flow_attrs {
-- 
2.14.4

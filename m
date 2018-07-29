From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 17/27] RDMA/mlx5: Add new flow action verb, packet reformat
Date: Sun, 29 Jul 2018 15:58:55 +0300
Message-ID: <20180729125905.31989-18-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

For now, only add L2_TUNNEL_TO_L2 option, for example this can be used
to decap VXLAN packets.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c         | 76 ++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |  1 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  7 +++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |  4 ++
 4 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index d0325e468801..0fea98cb7d42 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -202,6 +202,8 @@ void mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_flow_action *maction)
 		mlx5_modify_header_dealloc(maction->flow_action_raw.dev->mdev,
 					   maction->flow_action_raw.action_id);
 		break;
+	case MLX5_IB_FLOW_ACTION_DECAP:
+		break;
 	default:
 		WARN_ON(true);
 		break;
@@ -284,6 +286,64 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(struc
 	return 0;
 }
 
+static bool mlx5_ib_flow_action_packet_reformat_valid(struct mlx5_ib_dev *ibdev,
+						      u8 packet_reformat_type,
+						      u8 ft_type)
+{
+	switch (packet_reformat_type) {
+	case MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TUNNEL_TO_L2:
+		if (ft_type == MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_RX)
+			return MLX5_CAP_FLOWTABLE_NIC_RX(ibdev->mdev, decap);
+		break;
+	default:
+		break;
+	}
+
+	return false;
+}
+
+static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT)(struct ib_device *ib_dev,
+									     struct ib_uverbs_file *file,
+									     struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
+				       MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_HANDLE);
+	struct mlx5_ib_dev *mdev = to_mdev(uobj->context->device);
+	enum mlx5_ib_uapi_flow_action_packet_reformat_type dv_prt;
+	enum mlx5_ib_uapi_flow_table_type ft_type;
+	struct mlx5_ib_flow_action *maction;
+	int ret;
+
+	ret = uverbs_get_const(&ft_type, attrs,
+			       MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_FT_TYPE);
+	if (ret)
+		return -EINVAL;
+
+	ret = uverbs_get_const(&dv_prt, attrs,
+			       MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_TYPE);
+	if (ret)
+		return -EINVAL;
+
+	if (!mlx5_ib_flow_action_packet_reformat_valid(mdev, dv_prt, ft_type))
+		return -EOPNOTSUPP;
+
+	maction = kzalloc(sizeof(*maction), GFP_KERNEL);
+	if (!maction)
+		return -ENOMEM;
+
+	if (dv_prt ==
+	    MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TUNNEL_TO_L2) {
+		maction->flow_action_raw.sub_type =
+			MLX5_IB_FLOW_ACTION_DECAP;
+		maction->flow_action_raw.dev = mdev;
+	}
+
+	uverbs_flow_action_fill_action(&maction->ib_action, uobj,
+				       uobj->context->device,
+				       IB_FLOW_ACTION_UNSPECIFIED);
+	return 0;
+}
+
 DECLARE_UVERBS_NAMED_METHOD(
 	MLX5_IB_METHOD_CREATE_FLOW,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_HANDLE,
@@ -332,9 +392,23 @@ DECLARE_UVERBS_NAMED_METHOD(
 			     enum mlx5_ib_uapi_flow_table_type,
 			     UA_MANDATORY));
 
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_HANDLE,
+			UVERBS_OBJECT_FLOW_ACTION,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY),
+	UVERBS_ATTR_CONST_IN(MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_TYPE,
+			     enum mlx5_ib_uapi_flow_action_packet_reformat_type,
+			     UA_MANDATORY),
+	UVERBS_ATTR_CONST_IN(MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_FT_TYPE,
+			     enum mlx5_ib_uapi_flow_table_type,
+			     UA_MANDATORY));
+
 ADD_UVERBS_METHODS(mlx5_ib_flow_actions,
 		   UVERBS_OBJECT_FLOW_ACTION,
-		   &UVERBS_METHOD(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER));
+		   &UVERBS_METHOD(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER),
+		   &UVERBS_METHOD(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT));
 
 DECLARE_UVERBS_NAMED_METHOD(
 	MLX5_IB_METHOD_FLOW_MATCHER_CREATE,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b5dd68114588..856cb389c821 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -153,6 +153,7 @@ struct mlx5_ib_pd {
 
 enum {
 	MLX5_IB_FLOW_ACTION_MODIFY_HEADER,
+	MLX5_IB_FLOW_ACTION_DECAP,
 };
 
 #define MLX5_IB_FLOW_MCAST_PRIO		(MLX5_BY_PASS_NUM_PRIOS - 1)
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 9c83e13c0e89..40db7fca3d0b 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -168,6 +168,7 @@ enum mlx5_ib_flow_methods {
 
 enum mlx5_ib_flow_action_methods {
 	MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT,
 };
 
 enum mlx5_ib_create_flow_action_create_modify_header_attrs {
@@ -176,4 +177,10 @@ enum mlx5_ib_create_flow_action_create_modify_header_attrs {
 	MLX5_IB_ATTR_CREATE_MODIFY_HEADER_FT_TYPE,
 };
 
+enum mlx5_ib_create_flow_action_create_packet_reformat_attrs {
+	MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_TYPE,
+	MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_FT_TYPE,
+};
+
 #endif
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index ceb6d0d8529a..b5fda0fcd484 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -44,5 +44,9 @@ enum mlx5_ib_uapi_flow_table_type {
 	MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_TX	= 0x1,
 };
 
+enum mlx5_ib_uapi_flow_action_packet_reformat_type {
+	MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TUNNEL_TO_L2 = 0x0,
+};
+
 #endif
 
-- 
2.14.4

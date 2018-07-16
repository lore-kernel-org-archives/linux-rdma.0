From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH rdma-next 17/18] RDMA/mlx5: Extend packet reformat verbs
Date: Mon, 16 Jul 2018 11:23:04 +0300
Message-ID: <20180716082305.11744-18-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

We expose new actions:

L2_TO_L2_TUNNEL - A generic encap from L2 to L2, the data passed should
be the encapsulating headers.

L3_TUNNEL_TO_L2 - Will do decap where the inner packet starts from L3,
the data should be mac or mac + vlan (14 or 18 bytes).

L2_TO_L3_TUNNEL - Will do encap where is L2 of the original packet will
not be included, the data should be the encapsulating header.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c         | 85 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |  1 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  1 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |  3 ++
 4 files changed, 90 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index 263b86db7c60..9f20907dccff 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -201,6 +201,10 @@ void mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_flow_action *maction)
 		mlx5_modify_header_dealloc(maction->flow_action_raw.dev->mdev,
 					   maction->flow_action_raw.action_id);
 		break;
+	case MLX5_IB_FLOW_ACTION_PACKET_REFORMAT:
+		mlx5_packet_reformat_dealloc(maction->flow_action_raw.dev->mdev,
+					     maction->flow_action_raw.action_id);
+		break;
 	case MLX5_IB_FLOW_ACTION_DECAP:
 		break;
 	default:
@@ -287,6 +291,11 @@ static bool mlx5_ib_flow_action_packet_reformat_valid(struct mlx5_ib_dev *ibdev,
 						      u8 ft_type)
 {
 	switch (packet_reformat_type) {
+	case MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TO_L2_TUNNEL:
+		if (ft_type == MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_TX)
+			return MLX5_CAP_FLOWTABLE(ibdev->mdev,
+						  encap_general_header);
+		break;
 	case MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TUNNEL_TO_L2:
 		if (ft_type == MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_RX)
 			return MLX5_CAP_FLOWTABLE_NIC_RX(ibdev->mdev, decap);
@@ -298,6 +307,55 @@ static bool mlx5_ib_flow_action_packet_reformat_valid(struct mlx5_ib_dev *ibdev,
 	return false;
 }

+static int mlx5_ib_dv_to_prm_packet_reforamt_type(u8 dv_prt, u8 *prm_prt)
+{
+	switch (dv_prt) {
+	case MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TO_L2_TUNNEL:
+		*prm_prt = MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
+		break;
+	case MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L3_TUNNEL_TO_L2:
+		*prm_prt = MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2;
+		break;
+	case MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
+		*prm_prt = MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int mlx5_ib_flow_action_create_packet_reformat_ctx(struct mlx5_ib_dev *dev,
+							  struct mlx5_ib_flow_action *maction,
+							  u8 ft_type, u8 dv_prt,
+							  void *in, size_t len)
+{
+	u8 namespace;
+	u8 prm_prt;
+	int ret;
+
+	ret = mlx5_ib_ft_type_to_namespace(ft_type, &namespace);
+	if (ret)
+		return ret;
+
+	ret = mlx5_ib_dv_to_prm_packet_reforamt_type(dv_prt, &prm_prt);
+	if (ret)
+		return ret;
+
+	ret = mlx5_packet_reformat_alloc(dev->mdev, prm_prt, len,
+					 in, namespace,
+					 &maction->flow_action_raw.action_id);
+	if (ret)
+		return ret;
+
+	maction->flow_action_raw.sub_type =
+		MLX5_IB_FLOW_ACTION_PACKET_REFORMAT;
+	maction->flow_action_raw.dev = dev;
+
+	return 0;
+}
+
 static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT)(struct ib_device *ib_dev,
 									     struct ib_uverbs_file *file,
 									     struct uverbs_attr_bundle *attrs)
@@ -306,6 +364,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT)(str
 				       MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_HANDLE);
 	struct mlx5_ib_dev *mdev = to_mdev(uobj->context->device);
 	struct mlx5_ib_flow_action *maction;
+	int ret = 0;
 	u8 ft_type;
 	u8 dv_prt;

@@ -327,12 +386,35 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT)(str
 		maction->flow_action_raw.sub_type =
 			MLX5_IB_FLOW_ACTION_DECAP;
 		maction->flow_action_raw.dev = mdev;
+	} else {
+		void *in;
+		int len;
+
+		if (!uverbs_attr_is_valid(attrs,
+					  MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_DATA_PRM)) {
+			ret = -EINVAL;
+			goto free_maction;
+		}
+
+		in = uverbs_attr_get_alloced_ptr(attrs, MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_DATA_PRM);
+		len = uverbs_attr_get_len(attrs, MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_DATA_PRM);
+
+		ret = mlx5_ib_flow_action_create_packet_reformat_ctx(mdev, maction,
+								     ft_type,
+								     dv_prt, in,
+								     len);
+		if (ret)
+			goto free_maction;
 	}

 	uverbs_flow_action_fill_action(&maction->ib_action, uobj,
 				       uobj->context->device,
 				       IB_FLOW_ACTION_UNSPECIFIED);
 	return 0;
+
+free_maction:
+	kfree(maction);
+	return ret;
 }

 DECLARE_UVERBS_NAMED_METHOD(
@@ -389,6 +471,9 @@ DECLARE_UVERBS_NAMED_METHOD(
 			UVERBS_OBJECT_FLOW_ACTION,
 			UVERBS_ACCESS_NEW,
 			UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_DATA_PRM,
+			   UVERBS_ATTR_MIN_SIZE(1),
+			   UA_ALLOC_AND_COPY),
 	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_TYPE,
 			   /* See enum mlx5_ib_uapi_flow_action_packet_reformat_type */
 			   UVERBS_ATTR_TYPE(u8),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 56ee65023d94..b12ea4838d25 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -153,6 +153,7 @@ struct mlx5_ib_pd {

 enum {
 	MLX5_IB_FLOW_ACTION_MODIFY_HEADER,
+	MLX5_IB_FLOW_ACTION_PACKET_REFORMAT,
 	MLX5_IB_FLOW_ACTION_DECAP,
 };

diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 40db7fca3d0b..67c1ed12af72 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -181,6 +181,7 @@ enum mlx5_ib_create_flow_action_create_packet_reformat_attrs {
 	MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
 	MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_TYPE,
 	MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_FT_TYPE,
+	MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_DATA_PRM,
 };

 #endif
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index b5fda0fcd484..4ef62c0e8452 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -46,6 +46,9 @@ enum mlx5_ib_uapi_flow_table_type {

 enum mlx5_ib_uapi_flow_action_packet_reformat_type {
 	MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TUNNEL_TO_L2 = 0x0,
+	MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TO_L2_TUNNEL = 0x1,
+	MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L3_TUNNEL_TO_L2 = 0x2,
+	MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TO_L3_TUNNEL = 0x3,
 };

 #endif

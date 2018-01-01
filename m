From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 2/6] IB/mlx5: Move RoCE/ETH initialization to the corresponding stage
Date: Mon,  1 Jan 2018 13:06:59 +0200
Message-ID: <20180101110703.28759-3-leon@kernel.org>
References: <20180101110703.28759-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180101110703.28759-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Now that we have a stage just for RoCE/ETH, move all relevant
initialization logic into one place.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 97c2b6b25ac8..9a5de242b74d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4074,13 +4074,8 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
-	enum rdma_link_layer ll;
-	int port_type_cap;
 	int err;
 
-	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
-	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
-
 	dev->ib_dev.uverbs_abi_ver	= MLX5_IB_UVERBS_ABI_VERSION;
 	dev->ib_dev.uverbs_cmd_mask	=
 		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
@@ -4119,8 +4114,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
 	dev->ib_dev.get_link_layer	= mlx5_ib_port_link_layer;
-	if (ll == IB_LINK_LAYER_ETHERNET)
-		dev->ib_dev.get_netdev	= mlx5_ib_get_netdev;
 	dev->ib_dev.query_gid		= mlx5_ib_query_gid;
 	dev->ib_dev.add_gid		= mlx5_ib_add_gid;
 	dev->ib_dev.del_gid		= mlx5_ib_del_gid;
@@ -4208,20 +4201,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 			(1ull << IB_USER_VERBS_EX_CMD_CREATE_FLOW) |
 			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW);
 
-	if (mlx5_ib_port_link_layer(&dev->ib_dev, 1) ==
-	    IB_LINK_LAYER_ETHERNET) {
-		dev->ib_dev.create_wq	 = mlx5_ib_create_wq;
-		dev->ib_dev.modify_wq	 = mlx5_ib_modify_wq;
-		dev->ib_dev.destroy_wq	 = mlx5_ib_destroy_wq;
-		dev->ib_dev.create_rwq_ind_table = mlx5_ib_create_rwq_ind_table;
-		dev->ib_dev.destroy_rwq_ind_table = mlx5_ib_destroy_rwq_ind_table;
-		dev->ib_dev.uverbs_ex_cmd_mask |=
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ) |
-			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ) |
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL);
-	}
 	err = init_node_data(dev);
 	if (err)
 		return err;
@@ -4245,6 +4224,18 @@ static int mlx5_ib_stage_roce_init(struct mlx5_ib_dev *dev)
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
 	if (ll == IB_LINK_LAYER_ETHERNET) {
+		dev->ib_dev.get_netdev	= mlx5_ib_get_netdev;
+		dev->ib_dev.create_wq	 = mlx5_ib_create_wq;
+		dev->ib_dev.modify_wq	 = mlx5_ib_modify_wq;
+		dev->ib_dev.destroy_wq	 = mlx5_ib_destroy_wq;
+		dev->ib_dev.create_rwq_ind_table = mlx5_ib_create_rwq_ind_table;
+		dev->ib_dev.destroy_rwq_ind_table = mlx5_ib_destroy_rwq_ind_table;
+		dev->ib_dev.uverbs_ex_cmd_mask |=
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ) |
+			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ) |
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ) |
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL) |
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL);
 		err = mlx5_enable_eth(dev);
 		if (err)
 			return err;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 14/14] RDMA/verbs: Drop uverbs_ex_mask
Date: Wed, 14 Feb 2018 14:38:44 +0200
Message-ID: <20180214123844.30321-15-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is no need to manage mask of available function pointers
while the core is checking that function pointers is set prior
to calling that function, so remove it.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c |  2 +-
 drivers/infiniband/hw/mlx4/main.c     | 18 ------------------
 drivers/infiniband/hw/mlx5/main.c     | 15 ---------------
 include/rdma/ib_verbs.h               |  1 -
 4 files changed, 1 insertion(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e07326139ce9..00d751121446 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -641,7 +641,7 @@ static bool verify_command_mask(struct ib_device *ib_dev,
 	if (!extended)
 		return ib_dev->uverbs_cmd_mask & BIT_ULL(command);
 
-	return ib_dev->uverbs_ex_cmd_mask & BIT_ULL(command);
+	return true;
 }
 
 static bool verify_command_idx(__u32 command, bool extended)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8d2ee9322f2e..9a083803f81f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2759,9 +2759,6 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.get_dev_fw_str    = get_fw_ver_str;
 	ibdev->ib_dev.disassociate_ucontext = mlx4_ib_disassociate_ucontext;
 
-	ibdev->ib_dev.uverbs_ex_cmd_mask |=
-		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_CQ);
-
 	if ((dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS) &&
 	    ((mlx4_ib_port_link_layer(&ibdev->ib_dev, 1) ==
 	    IB_LINK_LAYER_ETHERNET) ||
@@ -2774,12 +2771,6 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			mlx4_ib_create_rwq_ind_table;
 		ibdev->ib_dev.destroy_rwq_ind_table =
 			mlx4_ib_destroy_rwq_ind_table;
-		ibdev->ib_dev.uverbs_ex_cmd_mask |=
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ)	  |
-			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ)	  |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ)	  |
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL);
 	}
 
 	if (!mlx4_is_slave(ibdev->dev)) {
@@ -2811,17 +2802,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ibdev->steering_support = MLX4_STEERING_MODE_DEVICE_MANAGED;
 		ibdev->ib_dev.create_flow	= mlx4_ib_create_flow;
 		ibdev->ib_dev.destroy_flow	= mlx4_ib_destroy_flow;
-
-		ibdev->ib_dev.uverbs_ex_cmd_mask	|=
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_FLOW) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW);
 	}
 
-	ibdev->ib_dev.uverbs_ex_cmd_mask |=
-		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE) |
-		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ) |
-		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP);
-
 	mlx4_ib_alloc_eqs(dev, ibdev);
 
 	spin_lock_init(&iboe->lock);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4236c8086820..7074c418e2c9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4618,12 +4618,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
 		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
-	dev->ib_dev.uverbs_ex_cmd_mask =
-		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE)	|
-		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ)	|
-		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP)	|
-		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_QP)	|
-		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_CQ);
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
@@ -4704,9 +4698,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 
 	dev->ib_dev.create_flow	= mlx5_ib_create_flow;
 	dev->ib_dev.destroy_flow = mlx5_ib_destroy_flow;
-	dev->ib_dev.uverbs_ex_cmd_mask |=
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_FLOW) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW);
 
 	err = init_node_data(dev);
 	if (err)
@@ -4746,12 +4737,6 @@ static int mlx5_ib_stage_roce_init(struct mlx5_ib_dev *dev)
 		dev->ib_dev.destroy_wq	 = mlx5_ib_destroy_wq;
 		dev->ib_dev.create_rwq_ind_table = mlx5_ib_create_rwq_ind_table;
 		dev->ib_dev.destroy_rwq_ind_table = mlx5_ib_destroy_rwq_ind_table;
-		dev->ib_dev.uverbs_ex_cmd_mask |=
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ) |
-			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ) |
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL);
 		err = mlx5_enable_eth(dev, port_num);
 		if (err)
 			return err;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 73b2387e3f74..f31ba8df5c66 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2346,7 +2346,6 @@ struct ib_device {
 
 	int			     uverbs_abi_ver;
 	u64			     uverbs_cmd_mask;
-	u64			     uverbs_ex_cmd_mask;
 
 	char			     node_desc[IB_DEVICE_NODE_DESC_MAX];
 	__be64			     node_guid;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 4/6] IB/mlx5: Add multicast flow steering support for underlay QP
Date: Mon,  5 Jun 2017 08:00:19 +0300
Message-ID: <20170605050021.12236-5-leon@kernel.org>
References: <20170605050021.12236-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605050021.12236-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to add multicast flow steering support, there is need
to block the attaching of mcg flow for underlay QP, recognize
multicast IB_FLOW_SPEC_IPV4 based on its IP and enable
creating/destroying flow for IB layer.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 43 ++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d45772da0963..92d8c764529c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2044,21 +2044,32 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
  */
 static bool flow_is_multicast_only(struct ib_flow_attr *ib_attr)
 {
-	struct ib_flow_spec_eth *eth_spec;
+	union ib_flow_spec *flow_spec;

 	if (ib_attr->type != IB_FLOW_ATTR_NORMAL ||
-	    ib_attr->size < sizeof(struct ib_flow_attr) +
-	    sizeof(struct ib_flow_spec_eth) ||
 	    ib_attr->num_of_specs < 1)
 		return false;

-	eth_spec = (struct ib_flow_spec_eth *)(ib_attr + 1);
-	if (eth_spec->type != IB_FLOW_SPEC_ETH ||
-	    eth_spec->size != sizeof(*eth_spec))
+	flow_spec = (union ib_flow_spec *)(ib_attr + 1);
+	if (flow_spec->type == IB_FLOW_SPEC_IPV4) {
+		struct ib_flow_spec_ipv4 *ipv4_spec;
+
+		ipv4_spec = (struct ib_flow_spec_ipv4 *)flow_spec;
+		if (ipv4_is_multicast(ipv4_spec->val.dst_ip))
+			return true;
+
 		return false;
+	}
+
+	if (flow_spec->type == IB_FLOW_SPEC_ETH) {
+		struct ib_flow_spec_eth *eth_spec;
+
+		eth_spec = (struct ib_flow_spec_eth *)flow_spec;
+		return is_multicast_ether_addr(eth_spec->mask.dst_mac) &&
+		       is_multicast_ether_addr(eth_spec->val.dst_mac);
+	}

-	return is_multicast_ether_addr(eth_spec->mask.dst_mac) &&
-	       is_multicast_ether_addr(eth_spec->val.dst_mac);
+	return false;
 }

 static bool is_valid_ethertype(struct mlx5_core_dev *mdev,
@@ -2536,8 +2547,14 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 static int mlx5_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_qp *mqp = to_mqp(ibqp);
 	int err;

+	if (mqp->flags & MLX5_IB_QP_UNDERLAY) {
+		mlx5_ib_dbg(dev, "Attaching a multi cast group to underlay QP is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	err = mlx5_core_attach_mcg(dev->mdev, gid, ibqp->qp_num);
 	if (err)
 		mlx5_ib_warn(dev, "failed attaching QPN 0x%x, MGID %pI6\n",
@@ -3714,18 +3731,20 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD);
 	}

+	dev->ib_dev.create_flow	= mlx5_ib_create_flow;
+	dev->ib_dev.destroy_flow = mlx5_ib_destroy_flow;
+	dev->ib_dev.uverbs_ex_cmd_mask |=
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_FLOW) |
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW);
+
 	if (mlx5_ib_port_link_layer(&dev->ib_dev, 1) ==
 	    IB_LINK_LAYER_ETHERNET) {
-		dev->ib_dev.create_flow	= mlx5_ib_create_flow;
-		dev->ib_dev.destroy_flow = mlx5_ib_destroy_flow;
 		dev->ib_dev.create_wq	 = mlx5_ib_create_wq;
 		dev->ib_dev.modify_wq	 = mlx5_ib_modify_wq;
 		dev->ib_dev.destroy_wq	 = mlx5_ib_destroy_wq;
 		dev->ib_dev.create_rwq_ind_table = mlx5_ib_create_rwq_ind_table;
 		dev->ib_dev.destroy_rwq_ind_table = mlx5_ib_destroy_rwq_ind_table;
 		dev->ib_dev.uverbs_ex_cmd_mask |=
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_FLOW) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW) |
 			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ) |
 			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ) |
 			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ) |
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

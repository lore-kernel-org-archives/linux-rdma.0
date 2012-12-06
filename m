From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [FIXES for-next 1/4] mlx4_core: Add QPN enforcement for flow steering rules set by VFs
Date: Thu,  6 Dec 2012 19:11:57 +0200
Message-ID: <1354813920-27358-2-git-send-email-ogerlitz@mellanox.com>
References: <1354813920-27358-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354813920-27358-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since VFs may be mapped to VMs which aren't trusted entities, flow
steering rules attached through the wrapper on behalf of VFs must be
checked to make sure that the specified QP number is assigned to that VF.
Also, make sure to keep the QP busy till the end of the operation from
the resource tracker point of view.

Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   26 +++++++++++++++----
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index b05705f..0b3f2d2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -3071,6 +3071,7 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 	struct mlx4_resource_tracker *tracker = &priv->mfunc.master.res_tracker;
 	struct list_head *rlist = &tracker->slave_list[slave].res_list[RES_MAC];
 	int err;
+	int qpn;
 	struct mlx4_net_trans_rule_hw_ctrl *ctrl;
 	struct _rule_hw  *rule_header;
 	int header_id;
@@ -3080,13 +3081,21 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 		return -EOPNOTSUPP;
 
 	ctrl = (struct mlx4_net_trans_rule_hw_ctrl *)inbox->buf;
+	qpn = be32_to_cpu(ctrl->qpn) & 0xffffff;
+	err = get_res(dev, slave, qpn, RES_QP, NULL);
+	if (err) {
+		pr_err("Steering rule with qpn 0x%x rejected.\n", qpn);
+		return err;
+	}
 	rule_header = (struct _rule_hw *)(ctrl + 1);
 	header_id = map_hw_to_sw_id(be16_to_cpu(rule_header->id));
 
 	switch (header_id) {
 	case MLX4_NET_TRANS_RULE_ID_ETH:
-		if (validate_eth_header_mac(slave, rule_header, rlist))
-			return -EINVAL;
+		if (validate_eth_header_mac(slave, rule_header, rlist)) {
+			err = -EINVAL;
+			goto err_put;
+		}
 		break;
 	case MLX4_NET_TRANS_RULE_ID_IB:
 		break;
@@ -3094,14 +3103,17 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 	case MLX4_NET_TRANS_RULE_ID_TCP:
 	case MLX4_NET_TRANS_RULE_ID_UDP:
 		pr_warn("Can't attach FS rule without L2 headers, adding L2 header.\n");
-		if (add_eth_header(dev, slave, inbox, rlist, header_id))
-			return -EINVAL;
+		if (add_eth_header(dev, slave, inbox, rlist, header_id)) {
+			err = -EINVAL;
+			goto err_put;
+		}
 		vhcr->in_modifier +=
 			sizeof(struct mlx4_net_trans_rule_hw_eth) >> 2;
 		break;
 	default:
 		pr_err("Corrupted mailbox.\n");
-		return -EINVAL;
+		err = -EINVAL;
+		goto err_put;
 	}
 
 	err = mlx4_cmd_imm(dev, inbox->dma, &vhcr->out_param,
@@ -3109,7 +3121,7 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 			   MLX4_QP_FLOW_STEERING_ATTACH, MLX4_CMD_TIME_CLASS_A,
 			   MLX4_CMD_NATIVE);
 	if (err)
-		return err;
+		goto err_put;
 
 	err = add_res_range(dev, slave, vhcr->out_param, 1, RES_FS_RULE, 0);
 	if (err) {
@@ -3119,6 +3131,8 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 			 MLX4_QP_FLOW_STEERING_ATTACH, MLX4_CMD_TIME_CLASS_A,
 			 MLX4_CMD_NATIVE);
 	}
+err_put:
+	put_res(dev, slave, qpn, RES_QP);
 	return err;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

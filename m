From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/6] IB/mlx4_ib: Add mechanism to support flow-steering over IB links
Date: Thu,  7 Nov 2013 15:25:16 +0200
Message-ID: <1383830717-17312-6-git-send-email-ogerlitz@mellanox.com>
References: <1383830717-17312-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383830717-17312-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The mlx4 device requires adding IB flow spec to rules that apply over
infiniband link layer. This patch adds a mechanism to add such a rule.

If higher levels e.g. IP/UDP/TCP flow specs are provided, the device
require us to add an empty wildecarded IB rule. Furthermore, the device
requires the qpn to be put in the rule.

Add here specific parsing support for IB empty rules and the
ability to self-generate missing specs based on existing ones.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |  135 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 134 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 093fc85..ecfd48b 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -55,6 +55,7 @@
 #define DRV_RELDATE	"April 4, 2008"
 
 #define MLX4_IB_FLOW_MAX_PRIO 0xFFF
+#define MLX4_IB_FLOW_QPN_MASK 0xFFFFFF
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
@@ -828,6 +829,7 @@ struct mlx4_ib_steering {
 };
 
 static int parse_flow_attr(struct mlx4_dev *dev,
+			   u32 qp_num,
 			   union ib_flow_spec *ib_spec,
 			   struct _rule_hw *mlx4_spec)
 {
@@ -843,6 +845,14 @@ static int parse_flow_attr(struct mlx4_dev *dev,
 		mlx4_spec->eth.vlan_tag = ib_spec->eth.val.vlan_tag;
 		mlx4_spec->eth.vlan_tag_msk = ib_spec->eth.mask.vlan_tag;
 		break;
+	case IB_FLOW_SPEC_IB:
+		type = MLX4_NET_TRANS_RULE_ID_IB;
+		mlx4_spec->ib.l3_qpn =
+			cpu_to_be32(qp_num);
+		mlx4_spec->ib.qpn_mask =
+			cpu_to_be32(MLX4_IB_FLOW_QPN_MASK);
+		break;
+
 
 	case IB_FLOW_SPEC_IPV4:
 		type = MLX4_NET_TRANS_RULE_ID_IPV4;
@@ -874,6 +884,115 @@ static int parse_flow_attr(struct mlx4_dev *dev,
 	return mlx4_hw_rule_sz(dev, type);
 }
 
+struct default_rules {
+	__u32 mandatory_fields[IB_FLOW_SPEC_SUPPORT_LAYERS];
+	__u32 mandatory_not_fields[IB_FLOW_SPEC_SUPPORT_LAYERS];
+	__u32 rules_create_list[IB_FLOW_SPEC_SUPPORT_LAYERS];
+	__u8  link_layer;
+};
+static const struct default_rules default_table[] = {
+	{
+		.mandatory_fields = {IB_FLOW_SPEC_IPV4},
+		.mandatory_not_fields = {IB_FLOW_SPEC_ETH},
+		.rules_create_list = {IB_FLOW_SPEC_IB},
+		.link_layer = IB_LINK_LAYER_INFINIBAND
+	}
+};
+
+static int __mlx4_ib_default_rules_match(struct ib_qp *qp,
+					 struct ib_flow_attr *flow_attr)
+{
+	int i, j, k;
+	void *ib_flow;
+	const struct default_rules *pdefault_rules = default_table;
+	u8 link_layer = rdma_port_get_link_layer(qp->device, flow_attr->port);
+
+	for (i = 0; i < sizeof(default_table)/sizeof(default_table[0]); i++,
+	     pdefault_rules++) {
+		__u32 field_types[IB_FLOW_SPEC_SUPPORT_LAYERS];
+		memset(&field_types, 0, sizeof(field_types));
+
+		if (link_layer != pdefault_rules->link_layer)
+			continue;
+
+		ib_flow = flow_attr + 1;
+		/* we assume the specs are sorted */
+		for (j = 0, k = 0; k < IB_FLOW_SPEC_SUPPORT_LAYERS &&
+		     j < flow_attr->num_of_specs; k++) {
+			union ib_flow_spec *current_flow =
+				(union ib_flow_spec *)ib_flow;
+
+			/* same layer but different type */
+			if (((current_flow->type & IB_FLOW_SPEC_LAYER_MASK) ==
+			     (pdefault_rules->mandatory_fields[k] &
+			      IB_FLOW_SPEC_LAYER_MASK)) &&
+			    (current_flow->type !=
+			     pdefault_rules->mandatory_fields[k]))
+				goto out;
+
+			/* same layer, try match next one */
+			if (current_flow->type ==
+			    pdefault_rules->mandatory_fields[k]) {
+				j++;
+				ib_flow +=
+					((union ib_flow_spec *)ib_flow)->size;
+			}
+		}
+
+		ib_flow = flow_attr + 1;
+		for (j = 0; j < flow_attr->num_of_specs;
+		     j++, ib_flow += ((union ib_flow_spec *)ib_flow)->size)
+			for (k = 0; k < IB_FLOW_SPEC_SUPPORT_LAYERS; k++)
+				/* same layer and same type */
+				if (((union ib_flow_spec *)ib_flow)->type ==
+				    pdefault_rules->mandatory_not_fields[k])
+					goto out;
+
+		return i;
+	}
+out:
+	return -1;
+}
+
+static int __mlx4_ib_create_default_rules(
+		struct mlx4_ib_dev *mdev,
+		struct ib_qp *qp,
+		const struct default_rules *pdefault_rules,
+		struct _rule_hw *mlx4_spec) {
+	int size = 0;
+	int i;
+
+	for (i = 0; i < sizeof(pdefault_rules->rules_create_list)/
+			sizeof(pdefault_rules->rules_create_list[0]); i++) {
+		int ret;
+		union ib_flow_spec ib_spec;
+		switch (pdefault_rules->rules_create_list[i]) {
+		case 0:
+			/* no rule */
+			continue;
+		case IB_FLOW_SPEC_IB:
+			ib_spec.type = IB_FLOW_SPEC_IB;
+			ib_spec.size = sizeof(struct ib_flow_spec_ib);
+
+			break;
+		default:
+			/* invalid rule */
+			return -EINVAL;
+		}
+		/* We must put empty rule, qpn is being ignored */
+		ret = parse_flow_attr(mdev->dev, 0, &ib_spec,
+				      mlx4_spec);
+		if (ret < 0) {
+			pr_info("invalid parsing\n");
+			return -EINVAL;
+		}
+
+		mlx4_spec = (void *)mlx4_spec + ret;
+		size += ret;
+	}
+	return size;
+}
+
 static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_attr,
 			  int domain,
 			  enum mlx4_net_trans_promisc_mode flow_type,
@@ -887,6 +1006,7 @@ static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_att
 	struct mlx4_net_trans_rule_hw_ctrl *ctrl;
 	size_t rule_size = sizeof(struct mlx4_net_trans_rule_hw_ctrl) +
 			   (sizeof(struct _rule_hw) * flow_attr->num_of_specs);
+	int default_flow;
 
 	static const u16 __mlx4_domain[] = {
 		[IB_FLOW_DOMAIN_USER] = MLX4_DOMAIN_UVERBS,
@@ -922,8 +1042,21 @@ static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_att
 
 	ib_flow = flow_attr + 1;
 	size += sizeof(struct mlx4_net_trans_rule_hw_ctrl);
+	/* Add default flows */
+	default_flow = __mlx4_ib_default_rules_match(qp, flow_attr);
+	if (default_flow >= 0) {
+		ret = __mlx4_ib_create_default_rules(
+				mdev, qp, default_table + default_flow,
+				mailbox->buf + size);
+		if (ret < 0) {
+			mlx4_free_cmd_mailbox(mdev->dev, mailbox);
+			return -EINVAL;
+		}
+		size += ret;
+	}
 	for (i = 0; i < flow_attr->num_of_specs; i++) {
-		ret = parse_flow_attr(mdev->dev, ib_flow, mailbox->buf + size);
+		ret = parse_flow_attr(mdev->dev, qp->qp_num, ib_flow,
+				      mailbox->buf + size);
 		if (ret < 0) {
 			mlx4_free_cmd_mailbox(mdev->dev, mailbox);
 			return -EINVAL;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

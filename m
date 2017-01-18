From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/5] IB/mlx5: Add flow tag support
Date: Wed, 18 Jan 2017 14:59:50 +0200
Message-ID: <20170118125951.3469-5-leon@kernel.org>
References: <20170118125951.3469-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118125951.3469-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Set flow tag in flow table entry, when IB_FLOW_SPEC_ACTION_TAG
is part of the flow specifications.

Flow tag doesn't support multicast flows, so it's passing to
hardware only when used.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a191b93..d557150 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1652,6 +1652,7 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 #define LAST_IPV6_FIELD traffic_class
 #define LAST_TCP_UDP_FIELD src_port
 #define LAST_TUNNEL_FIELD tunnel_id
+#define LAST_FLOW_TAG_FIELD tag_id
 
 /* Field is the last supported field */
 #define FIELDS_NOT_SUPPORTED(filter, field)\
@@ -1662,7 +1663,7 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 		   sizeof(filter.field))
 
 static int parse_flow_attr(u32 *match_c, u32 *match_v,
-			   const union ib_flow_spec *ib_spec)
+			   const union ib_flow_spec *ib_spec, u32 *tag_id)
 {
 	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
 					   misc_parameters);
@@ -1854,6 +1855,15 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 		MLX5_SET(fte_match_set_misc, misc_params_v, vxlan_vni,
 			 ntohl(ib_spec->tunnel.val.tunnel_id));
 		break;
+	case IB_FLOW_SPEC_ACTION_TAG:
+		if (FIELDS_NOT_SUPPORTED(ib_spec->flow_tag,
+					 LAST_FLOW_TAG_FIELD))
+			return -EOPNOTSUPP;
+		if (ib_spec->flow_tag.tag_id >= BIT(24))
+			return -EINVAL;
+
+		*tag_id = ib_spec->flow_tag.tag_id;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2037,6 +2047,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	struct mlx5_flow_spec *spec;
 	const void *ib_flow = (const void *)flow_attr + sizeof(*flow_attr);
 	unsigned int spec_index;
+	u32 flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
 	int err = 0;
 
 	if (!is_valid_attr(flow_attr))
@@ -2053,7 +2064,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
 		err = parse_flow_attr(spec->match_criteria,
-				      spec->match_value, ib_flow);
+				      spec->match_value, ib_flow, &flow_tag);
 		if (err < 0)
 			goto free;
 
@@ -2063,7 +2074,16 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	spec->match_criteria_enable = get_match_criteria_enable(spec->match_criteria);
 	flow_act.action = dst ? MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
 		MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
-	flow_act.flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
+
+	if (flow_tag != MLX5_FS_DEFAULT_FLOW_TAG &&
+	    (flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT ||
+	     flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT)) {
+		mlx5_ib_warn(dev, "Flow tag %u and attribute type %x isn't allowed in leftovers\n",
+			     flow_tag, flow_attr->type);
+		err = -EINVAL;
+		goto free;
+	}
+	flow_act.flow_tag = flow_tag;
 	handler->rule = mlx5_add_flow_rules(ft, spec,
 					    &flow_act,
 					    dst, 1);
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

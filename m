From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Add drop flow steering rule support
Date: Mon,  3 Apr 2017 13:13:52 +0300
Message-ID: <20170403101352.5692-3-leon@kernel.org>
References: <20170403101352.5692-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403101352.5692-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A drop rule is described by an action drop and no destination.
If a user specified IB_FLOW_SPEC_ACTION_DROP then set the action
to MLX5_FLOW_CONTEXT_ACTION_DROP and clear the destination.

Signed-off-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4dc0a8785fe0..e5e5cdeee8d9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1726,6 +1726,7 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 #define LAST_TCP_UDP_FIELD src_port
 #define LAST_TUNNEL_FIELD tunnel_id
 #define LAST_FLOW_TAG_FIELD tag_id
+#define LAST_DROP_FIELD size
 
 /* Field is the last supported field */
 #define FIELDS_NOT_SUPPORTED(filter, field)\
@@ -1736,7 +1737,8 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 		   sizeof(filter.field))
 
 static int parse_flow_attr(u32 *match_c, u32 *match_v,
-			   const union ib_flow_spec *ib_spec, u32 *tag_id)
+			   const union ib_flow_spec *ib_spec,
+			   u32 *tag_id, bool *is_drop)
 {
 	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
 					   misc_parameters);
@@ -1937,6 +1939,12 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 
 		*tag_id = ib_spec->flow_tag.tag_id;
 		break;
+	case IB_FLOW_SPEC_ACTION_DROP:
+		if (FIELDS_NOT_SUPPORTED(ib_spec->drop,
+					 LAST_DROP_FIELD))
+			return -EOPNOTSUPP;
+		*is_drop = true;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2118,10 +2126,13 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	struct mlx5_ib_flow_handler *handler;
 	struct mlx5_flow_act flow_act = {0};
 	struct mlx5_flow_spec *spec;
+	struct mlx5_flow_destination *rule_dst = dst;
 	const void *ib_flow = (const void *)flow_attr + sizeof(*flow_attr);
 	unsigned int spec_index;
 	u32 flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
+	bool is_drop = false;
 	int err = 0;
+	int dest_num = 1;
 
 	if (!is_valid_attr(flow_attr))
 		return ERR_PTR(-EINVAL);
@@ -2137,7 +2148,8 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
 		err = parse_flow_attr(spec->match_criteria,
-				      spec->match_value, ib_flow, &flow_tag);
+				      spec->match_value,
+				      ib_flow, &flow_tag, &is_drop);
 		if (err < 0)
 			goto free;
 
@@ -2145,8 +2157,14 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	}
 
 	spec->match_criteria_enable = get_match_criteria_enable(spec->match_criteria);
-	flow_act.action = dst ? MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
-		MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
+	if (is_drop) {
+		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
+		rule_dst = NULL;
+		dest_num = 0;
+	} else {
+		flow_act.action = dst ? MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
+		    MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
+	}
 
 	if (flow_tag != MLX5_FS_DEFAULT_FLOW_TAG &&
 	    (flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT ||
@@ -2159,7 +2177,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	flow_act.flow_tag = flow_tag;
 	handler->rule = mlx5_add_flow_rules(ft, spec,
 					    &flow_act,
-					    dst, 1);
+					    rule_dst, dest_num);
 
 	if (IS_ERR(handler->rule)) {
 		err = PTR_ERR(handler->rule);
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

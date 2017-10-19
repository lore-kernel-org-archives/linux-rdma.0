From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 14/16] IB/mlx5: Pass mlx5_flow_act struct instead of multiple arguments
Date: Thu, 19 Oct 2017 17:41:56 +0300
Message-ID: <1508424118-27205-15-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Group and pass all function arguments of parse_flow_attr call in one
common struct mlx5_flow_act.

This patch passes all the action arguments of parse_flow_attr in one common
struct mlx5_flow_act. It allows us to scale the number of actions without adding
new arguments to the function.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a5ff217..2b434db 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1952,7 +1952,7 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 #define IPV6_VERSION 6
 static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 			   u32 *match_v, const union ib_flow_spec *ib_spec,
-			   u32 *tag_id, bool *is_drop)
+			   struct mlx5_flow_act *action)
 {
 	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
 					   misc_parameters);
@@ -2170,13 +2170,13 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 		if (ib_spec->flow_tag.tag_id >= BIT(24))
 			return -EINVAL;
 
-		*tag_id = ib_spec->flow_tag.tag_id;
+		action->flow_tag = ib_spec->flow_tag.tag_id;
 		break;
 	case IB_FLOW_SPEC_ACTION_DROP:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->drop,
 					 LAST_DROP_FIELD))
 			return -EOPNOTSUPP;
-		*is_drop = true;
+		action->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
 		break;
 	default:
 		return -EINVAL;
@@ -2429,13 +2429,11 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 {
 	struct mlx5_flow_table	*ft = ft_prio->flow_table;
 	struct mlx5_ib_flow_handler *handler;
-	struct mlx5_flow_act flow_act = {0};
+	struct mlx5_flow_act flow_act = {.flow_tag = MLX5_FS_DEFAULT_FLOW_TAG};
 	struct mlx5_flow_spec *spec;
 	struct mlx5_flow_destination *rule_dst = dst;
 	const void *ib_flow = (const void *)flow_attr + sizeof(*flow_attr);
 	unsigned int spec_index;
-	u32 flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
-	bool is_drop = false;
 	int err = 0;
 	int dest_num = 1;
 
@@ -2454,7 +2452,7 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
 		err = parse_flow_attr(dev->mdev, spec->match_criteria,
 				      spec->match_value,
-				      ib_flow, &flow_tag, &is_drop);
+				      ib_flow, &flow_act);
 		if (err < 0)
 			goto free;
 
@@ -2465,8 +2463,7 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 		set_underlay_qp(dev, spec, underlay_qpn);
 
 	spec->match_criteria_enable = get_match_criteria_enable(spec->match_criteria);
-	if (is_drop) {
-		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
+	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP) {
 		rule_dst = NULL;
 		dest_num = 0;
 	} else {
@@ -2474,15 +2471,14 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 		    MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
 	}
 
-	if (flow_tag != MLX5_FS_DEFAULT_FLOW_TAG &&
+	if (flow_act.flow_tag != MLX5_FS_DEFAULT_FLOW_TAG &&
 	    (flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT ||
 	     flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT)) {
 		mlx5_ib_warn(dev, "Flow tag %u and attribute type %x isn't allowed in leftovers\n",
-			     flow_tag, flow_attr->type);
+			     flow_act.flow_tag, flow_attr->type);
 		err = -EINVAL;
 		goto free;
 	}
-	flow_act.flow_tag = flow_tag;
 	handler->rule = mlx5_add_flow_rules(ft, spec,
 					    &flow_act,
 					    rule_dst, dest_num);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

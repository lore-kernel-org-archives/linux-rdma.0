From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/5] net/mlx5: Consolidate flow rules regardless their flow tag
Date: Wed, 18 Jan 2017 14:59:47 +0200
Message-ID: <20170118125951.3469-2-leon@kernel.org>
References: <20170118125951.3469-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118125951.3469-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Flow rules with same match criteria and value should be mapped to
the same flow table entry regardless the flow tag identifier.

Flow tag is part of flow table entry context and not of the
destination, therefore we should return error when we try to add
destination to flow table entry with different flow tag.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index a263d89..1c750af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1232,10 +1232,18 @@ static struct mlx5_flow_handle *add_rule_fg(struct mlx5_flow_group *fg,
 	fs_for_each_fte(fte, fg) {
 		nested_lock_ref_node(&fte->node, FS_MUTEX_CHILD);
 		if (compare_match_value(&fg->mask, match_value, &fte->val) &&
-		    (flow_act->action & fte->action) &&
-		    flow_act->flow_tag == fte->flow_tag) {
+		    (flow_act->action & fte->action)) {
 			int old_action = fte->action;
 
+			if (fte->flow_tag != flow_act->flow_tag) {
+				mlx5_core_warn(get_dev(&fte->node),
+					       "FTE flow tag %u already exists with different flow tag %u\n",
+					       fte->flow_tag,
+					       flow_act->flow_tag);
+				handle = ERR_PTR(-EEXIST);
+				goto unlock_fte;
+			}
+
 			fte->action |= flow_act->action;
 			handle = add_rule_fte(fte, fg, dest, dest_num,
 					      old_action != flow_act->action);
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

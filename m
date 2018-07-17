From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 3/8] net/mlx5: Add core support for double vlan push/pop steering action
Date: Mon, 16 Jul 2018 18:35:32 -0700
Message-ID: <20180717013537.26411-4-saeedm@mellanox.com>
References: <20180717013537.26411-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717013537.26411-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Jianbo Liu <jianbol@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

As newer firmware supports double push/pop in a single FTE, we add
core bits and extend vlan action logic for it.

Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/diag/fs_tracepoint.h |  2 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c     | 12 +++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c    |  4 +++-
 include/linux/mlx5/fs.h                              |  4 +++-
 include/linux/mlx5/mlx5_ifc.h                        | 11 +++++++++--
 6 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.h
index 09f178a3fcab..0240aee9189e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.h
@@ -138,6 +138,8 @@ TRACE_EVENT(mlx5_fs_del_fg,
 	{MLX5_FLOW_CONTEXT_ACTION_MOD_HDR,	 "MOD_HDR"},\
 	{MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH,	 "VLAN_PUSH"},\
 	{MLX5_FLOW_CONTEXT_ACTION_VLAN_POP,	 "VLAN_POP"},\
+	{MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2,	 "VLAN_PUSH_2"},\
+	{MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2,	 "VLAN_POP_2"},\
 	{MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO, "NEXT_PRIO"}
 
 TRACE_EVENT(mlx5_fs_set_fte,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index cecd201f0b73..8f50ce80ff66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -70,9 +70,9 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		flow_act.action &= ~(MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH |
 				     MLX5_FLOW_CONTEXT_ACTION_VLAN_POP);
 	else if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
-		flow_act.vlan.ethtype = ntohs(attr->vlan_proto);
-		flow_act.vlan.vid = attr->vlan_vid;
-		flow_act.vlan.prio = attr->vlan_prio;
+		flow_act.vlan[0].ethtype = ntohs(attr->vlan_proto);
+		flow_act.vlan[0].vid = attr->vlan_vid;
+		flow_act.vlan[0].prio = attr->vlan_prio;
 	}
 
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 5a00deff5457..6a62b84e57f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -349,9 +349,15 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 
 	vlan = MLX5_ADDR_OF(flow_context, in_flow_context, push_vlan);
 
-	MLX5_SET(vlan, vlan, ethtype, fte->action.vlan.ethtype);
-	MLX5_SET(vlan, vlan, vid, fte->action.vlan.vid);
-	MLX5_SET(vlan, vlan, prio, fte->action.vlan.prio);
+	MLX5_SET(vlan, vlan, ethtype, fte->action.vlan[0].ethtype);
+	MLX5_SET(vlan, vlan, vid, fte->action.vlan[0].vid);
+	MLX5_SET(vlan, vlan, prio, fte->action.vlan[0].prio);
+
+	vlan = MLX5_ADDR_OF(flow_context, in_flow_context, push_vlan_2);
+
+	MLX5_SET(vlan, vlan, ethtype, fte->action.vlan[1].ethtype);
+	MLX5_SET(vlan, vlan, vid, fte->action.vlan[1].vid);
+	MLX5_SET(vlan, vlan, prio, fte->action.vlan[1].prio);
 
 	in_match_value = MLX5_ADDR_OF(flow_context, in_flow_context,
 				      match_value);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 49a75d31185e..05e7a5112b74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1464,7 +1464,9 @@ static bool check_conflicting_actions(u32 action1, u32 action2)
 			     MLX5_FLOW_CONTEXT_ACTION_DECAP |
 			     MLX5_FLOW_CONTEXT_ACTION_MOD_HDR  |
 			     MLX5_FLOW_CONTEXT_ACTION_VLAN_POP |
-			     MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH))
+			     MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH |
+			     MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2 |
+			     MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2))
 		return true;
 
 	return false;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 757b4a30281e..c40f2fc68655 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -152,6 +152,8 @@ struct mlx5_fs_vlan {
         u8  prio;
 };
 
+#define MLX5_FS_VLAN_DEPTH	2
+
 struct mlx5_flow_act {
 	u32 action;
 	bool has_flow_tag;
@@ -159,7 +161,7 @@ struct mlx5_flow_act {
 	u32 encap_id;
 	u32 modify_id;
 	uintptr_t esp_id;
-	struct mlx5_fs_vlan vlan;
+	struct mlx5_fs_vlan vlan[MLX5_FS_VLAN_DEPTH];
 	struct ib_counters *counters;
 };
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2de5feaeb74a..ae12120ef021 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -337,7 +337,10 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         reserved_at_9[0x1];
 	u8         pop_vlan[0x1];
 	u8         push_vlan[0x1];
-	u8         reserved_at_c[0x14];
+	u8         reserved_at_c[0x1];
+	u8         pop_vlan_2[0x1];
+	u8         push_vlan_2[0x1];
+	u8         reserved_at_f[0x11];
 
 	u8         reserved_at_20[0x2];
 	u8         log_max_ft_size[0x6];
@@ -2386,6 +2389,8 @@ enum {
 	MLX5_FLOW_CONTEXT_ACTION_MOD_HDR   = 0x40,
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_POP  = 0x80,
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH = 0x100,
+	MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2  = 0x400,
+	MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2 = 0x800,
 };
 
 struct mlx5_ifc_vlan_bits {
@@ -2416,7 +2421,9 @@ struct mlx5_ifc_flow_context_bits {
 
 	u8         modify_header_id[0x20];
 
-	u8         reserved_at_100[0x100];
+	struct mlx5_ifc_vlan_bits push_vlan_2;
+
+	u8         reserved_at_120[0xe0];
 
 	struct mlx5_ifc_fte_match_param_bits match_value;
 
-- 
2.17.0

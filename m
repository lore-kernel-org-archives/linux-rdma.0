From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 06/15] net/mlx5: Add destination e-switch owner
Date: Thu, 17 May 2018 18:22:49 -0700
Message-ID: <20180518012258.26968-7-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Shahar Klein <shahark@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Shahar Klein <shahark@mellanox.com>

The destination e-switch owner allows a rule in namespace of one e-switch
owner to point to a vport that is natively associated with another
e-switch owner.

Signed-off-by: Shahar Klein <shahark@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c         | 2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c          | 8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c         | 2 +-
 include/linux/mlx5/fs.h                                   | 6 +++++-
 include/linux/mlx5/mlx5_ifc.h                             | 5 +++--
 7 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index d93ff567b40d..b3820a34e773 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -235,7 +235,7 @@ const char *parse_fs_dst(struct trace_seq *p,
 
 	switch (dst->type) {
 	case MLX5_FLOW_DESTINATION_TYPE_VPORT:
-		trace_seq_printf(p, "vport=%u\n", dst->vport_num);
+		trace_seq_printf(p, "vport=%u\n", dst->vport.num);
 		break;
 	case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 		trace_seq_printf(p, "ft=%p\n", dst->ft);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 332bc56306bf..9a24314b817a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -192,7 +192,7 @@ __esw_fdb_set_vport_rule(struct mlx5_eswitch *esw, u32 vport, bool rx_rule,
 	}
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-	dest.vport_num = vport;
+	dest.vport.num = vport;
 
 	esw_debug(esw->dev,
 		  "\tFDB add rule dmac_v(%pM) dmac_c(%pM) -> vport(%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b123f8a52ad8..90c8cb31e633 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -71,7 +71,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		dest[i].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-		dest[i].vport_num = attr->out_rep->vport;
+		dest[i].vport.num = attr->out_rep->vport;
 		i++;
 	}
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
@@ -343,7 +343,7 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw, int vport, u32 sqn
 
 	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-	dest.vport_num = vport;
+	dest.vport.num = vport;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
 	flow_rule = mlx5_add_flow_rules(esw->fdb_table.offloads.fdb, spec,
@@ -387,7 +387,7 @@ static int esw_add_fdb_miss_rule(struct mlx5_eswitch *esw)
 	dmac_c[0] = 0x01;
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-	dest.vport_num = 0;
+	dest.vport.num = 0;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
 	flow_rule = mlx5_add_flow_rules(esw->fdb_table.offloads.fdb, spec,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 0bfce6a82c91..5a00deff5457 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -374,7 +374,13 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				id = dst->dest_attr.ft->id;
 			} else if (dst->dest_attr.type ==
 				   MLX5_FLOW_DESTINATION_TYPE_VPORT) {
-				id = dst->dest_attr.vport_num;
+				id = dst->dest_attr.vport.num;
+				MLX5_SET(dest_format_struct, in_dests,
+					 destination_eswitch_owner_vhca_id_valid,
+					 dst->dest_attr.vport.vhca_id_valid);
+				MLX5_SET(dest_format_struct, in_dests,
+					 destination_eswitch_owner_vhca_id,
+					 dst->dest_attr.vport.vhca_id);
 			} else {
 				id = dst->dest_attr.tir_num;
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index de51e7c39bc8..5a80279b052a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1404,7 +1404,7 @@ static bool mlx5_flow_dests_cmp(struct mlx5_flow_destination *d1,
 {
 	if (d1->type == d2->type) {
 		if ((d1->type == MLX5_FLOW_DESTINATION_TYPE_VPORT &&
-		     d1->vport_num == d2->vport_num) ||
+		     d1->vport.num == d2->vport.num) ||
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE &&
 		     d1->ft == d2->ft) ||
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_TIR &&
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 47aecc4fa8c2..9f4d32e41c06 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -90,8 +90,12 @@ struct mlx5_flow_destination {
 	union {
 		u32			tir_num;
 		struct mlx5_flow_table	*ft;
-		u32			vport_num;
 		struct mlx5_fc		*counter;
+		struct {
+			u16		num;
+			u16		vhca_id;
+			bool		vhca_id_valid;
+		} vport;
 	};
 };
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ef15f751a984..3d17709bc30c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1148,8 +1148,9 @@ enum mlx5_flow_destination_type {
 struct mlx5_ifc_dest_format_struct_bits {
 	u8         destination_type[0x8];
 	u8         destination_id[0x18];
-
-	u8         reserved_at_20[0x20];
+	u8         destination_eswitch_owner_vhca_id_valid[0x1];
+	u8         reserved_at_21[0xf];
+	u8         destination_eswitch_owner_vhca_id[0x10];
 };
 
 struct mlx5_ifc_flow_counter_list_bits {
-- 
2.17.0

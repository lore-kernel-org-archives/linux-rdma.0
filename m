From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 8/9] net/mlx5: Support extended destination format in flow steering command
Date: Mon, 10 Dec 2018 13:15:16 -0800
Message-ID: <20181210211517.3686-9-saeedm@mellanox.com>
References: <20181210211517.3686-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210211517.3686-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Eli Britstein <elibr@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Update the flow steering command formatting according to the extended
destination API.
Note that the FW dictates that multi destination FTEs that involve at
least one encap must use the extended destination format, while single
destination ones must use the legacy format.
Using extended destination format requires FW support. Check for its
capabilities and return error if not supported.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 80 +++++++++++++++++--
 include/linux/mlx5/fs.h                       |  2 +
 2 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index dda63dedaa49..c44ccb67c4a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -308,22 +308,68 @@ static int mlx5_cmd_destroy_flow_group(struct mlx5_core_dev *dev,
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
+static int mlx5_set_extended_dest(struct mlx5_core_dev *dev,
+				  struct fs_fte *fte, bool *extended_dest)
+{
+	int fw_log_max_fdb_encap_uplink =
+		MLX5_CAP_ESW(dev, log_max_fdb_encap_uplink);
+	int num_fwd_destinations = 0;
+	struct mlx5_flow_rule *dst;
+	int num_encap = 0;
+
+	*extended_dest = false;
+	if (!(fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST))
+		return 0;
+
+	list_for_each_entry(dst, &fte->node.children, node.list) {
+		if (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+			continue;
+		if (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_VPORT &&
+		    dst->dest_attr.vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID)
+			num_encap++;
+		num_fwd_destinations++;
+	}
+	if (num_fwd_destinations > 1 && num_encap > 0)
+		*extended_dest = true;
+
+	if (*extended_dest && !fw_log_max_fdb_encap_uplink) {
+		mlx5_core_warn(dev, "FW does not support extended destination");
+		return -EOPNOTSUPP;
+	}
+	if (num_encap > (1 << fw_log_max_fdb_encap_uplink)) {
+		mlx5_core_warn(dev, "FW does not support more than %d encaps",
+			       1 << fw_log_max_fdb_encap_uplink);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
 static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 			    int opmod, int modify_mask,
 			    struct mlx5_flow_table *ft,
 			    unsigned group_id,
 			    struct fs_fte *fte)
 {
-	unsigned int inlen = MLX5_ST_SZ_BYTES(set_fte_in) +
-		fte->dests_size * MLX5_ST_SZ_BYTES(dest_format_struct);
 	u32 out[MLX5_ST_SZ_DW(set_fte_out)] = {0};
+	bool extended_dest = false;
 	struct mlx5_flow_rule *dst;
 	void *in_flow_context, *vlan;
 	void *in_match_value;
+	unsigned int inlen;
+	int dst_cnt_size;
 	void *in_dests;
 	u32 *in;
 	int err;
 
+	if (mlx5_set_extended_dest(dev, fte, &extended_dest))
+		return -EOPNOTSUPP;
+
+	if (!extended_dest)
+		dst_cnt_size = MLX5_ST_SZ_BYTES(dest_format_struct);
+	else
+		dst_cnt_size = MLX5_ST_SZ_BYTES(extended_dest_format);
+
+	inlen = MLX5_ST_SZ_BYTES(set_fte_in) + fte->dests_size * dst_cnt_size;
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -343,9 +389,20 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 	MLX5_SET(flow_context, in_flow_context, group_id, group_id);
 
 	MLX5_SET(flow_context, in_flow_context, flow_tag, fte->action.flow_tag);
-	MLX5_SET(flow_context, in_flow_context, action, fte->action.action);
-	MLX5_SET(flow_context, in_flow_context, packet_reformat_id,
-		 fte->action.reformat_id);
+	MLX5_SET(flow_context, in_flow_context, extended_destination,
+		 extended_dest);
+	if (extended_dest) {
+		u32 action;
+
+		action = fte->action.action &
+			~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+		MLX5_SET(flow_context, in_flow_context, action, action);
+	} else {
+		MLX5_SET(flow_context, in_flow_context, action,
+			 fte->action.action);
+		MLX5_SET(flow_context, in_flow_context, packet_reformat_id,
+			 fte->action.reformat_id);
+	}
 	MLX5_SET(flow_context, in_flow_context, modify_header_id,
 		 fte->action.modify_id);
 
@@ -392,6 +449,15 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				MLX5_SET(dest_format_struct, in_dests,
 					 destination_eswitch_owner_vhca_id,
 					 dst->dest_attr.vport.vhca_id);
+				if (extended_dest) {
+					MLX5_SET(dest_format_struct, in_dests,
+						 packet_reformat,
+						 !!(dst->dest_attr.vport.flags &
+						    MLX5_FLOW_DEST_VPORT_REFORMAT_ID));
+					MLX5_SET(extended_dest_format, in_dests,
+						 packet_reformat_id,
+						 dst->dest_attr.vport.reformat_id);
+				}
 				break;
 			default:
 				id = dst->dest_attr.tir_num;
@@ -400,7 +466,7 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 			MLX5_SET(dest_format_struct, in_dests, destination_type,
 				 type);
 			MLX5_SET(dest_format_struct, in_dests, destination_id, id);
-			in_dests += MLX5_ST_SZ_BYTES(dest_format_struct);
+			in_dests += dst_cnt_size;
 			list_size++;
 		}
 
@@ -421,7 +487,7 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 
 			MLX5_SET(flow_counter_list, in_dests, flow_counter_id,
 				 dst->dest_attr.counter_id);
-			in_dests += MLX5_ST_SZ_BYTES(dest_format_struct);
+			in_dests += dst_cnt_size;
 			list_size++;
 		}
 		if (list_size > max_list_size) {
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 25ffd8018b72..9df51da04621 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -88,6 +88,7 @@ struct mlx5_flow_spec {
 
 enum {
 	MLX5_FLOW_DEST_VPORT_VHCA_ID      = BIT(0),
+	MLX5_FLOW_DEST_VPORT_REFORMAT_ID  = BIT(1),
 };
 
 struct mlx5_flow_destination {
@@ -100,6 +101,7 @@ struct mlx5_flow_destination {
 		struct {
 			u16		num;
 			u16		vhca_id;
+			u32		reformat_id;
 			u8		flags;
 		} vport;
 	};
-- 
2.19.2

From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 2/9] net/mlx5: Add support for flow table destination number
Date: Sun,  8 Jul 2018 13:24:38 +0300
Message-ID: <20180708102445.25496-3-leon@kernel.org>
References: <20180708102445.25496-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180708102445.25496-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add support to set a destination from a flow table number.
This functionality will be used in downstream patches from this
series by the DEVX stuff.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../mellanox/mlx5/core/diag/fs_tracepoint.c         |  3 +++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c    | 21 ++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c   |  4 +++-
 include/linux/mlx5/fs.h                             |  1 +
 include/linux/mlx5/mlx5_ifc.h                       |  1 +
 5 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index b3820a34e773..0f11fff32a9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -240,6 +240,9 @@ const char *parse_fs_dst(struct trace_seq *p,
 	case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 		trace_seq_printf(p, "ft=%p\n", dst->ft);
 		break;
+	case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
+		trace_seq_printf(p, "ft_num=%u\n", dst->ft_num);
+		break;
 	case MLX5_FLOW_DESTINATION_TYPE_TIR:
 		trace_seq_printf(p, "tir=%u\n", dst->tir_num);
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 5a00deff5457..a98584576c2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -363,17 +363,21 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 
 		list_for_each_entry(dst, &fte->node.children, node.list) {
 			unsigned int id;
+			unsigned int type;
 
 			if (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
 				continue;
 
-			MLX5_SET(dest_format_struct, in_dests, destination_type,
-				 dst->dest_attr.type);
-			if (dst->dest_attr.type ==
-			    MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE) {
+			type = dst->dest_attr.type;
+			switch (type) {
+			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
+				id = dst->dest_attr.ft_num;
+				type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+				break;
+			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 				id = dst->dest_attr.ft->id;
-			} else if (dst->dest_attr.type ==
-				   MLX5_FLOW_DESTINATION_TYPE_VPORT) {
+				break;
+			case MLX5_FLOW_DESTINATION_TYPE_VPORT:
 				id = dst->dest_attr.vport.num;
 				MLX5_SET(dest_format_struct, in_dests,
 					 destination_eswitch_owner_vhca_id_valid,
@@ -381,9 +385,12 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				MLX5_SET(dest_format_struct, in_dests,
 					 destination_eswitch_owner_vhca_id,
 					 dst->dest_attr.vport.vhca_id);
-			} else {
+				break;
+			default:
 				id = dst->dest_attr.tir_num;
 			}
+
+			MLX5_SET(dest_format_struct, in_dests, destination_type, type);
 			MLX5_SET(dest_format_struct, in_dests, destination_id, id);
 			in_dests += MLX5_ST_SZ_BYTES(dest_format_struct);
 			list_size++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index eba113cf1117..69aa298a0b1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1356,7 +1356,9 @@ static bool mlx5_flow_dests_cmp(struct mlx5_flow_destination *d1,
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE &&
 		     d1->ft == d2->ft) ||
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_TIR &&
-		     d1->tir_num == d2->tir_num))
+		     d1->tir_num == d2->tir_num) ||
+		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM &&
+		     d1->ft_num == d2->ft_num))
 			return true;
 	}
 
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 757b4a30281e..a45febcf6b51 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -89,6 +89,7 @@ struct mlx5_flow_destination {
 	enum mlx5_flow_destination_type	type;
 	union {
 		u32			tir_num;
+		u32			ft_num;
 		struct mlx5_flow_table	*ft;
 		struct mlx5_fc		*counter;
 		struct {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 44a6ce01c3bb..fb89cc519703 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1181,6 +1181,7 @@ enum mlx5_flow_destination_type {
 
 	MLX5_FLOW_DESTINATION_TYPE_PORT         = 0x99,
 	MLX5_FLOW_DESTINATION_TYPE_COUNTER      = 0x100,
+	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM = 0x101,
 };
 
 struct mlx5_ifc_dest_format_struct_bits {
-- 
2.14.4

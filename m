From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 7/9] net/mlx5: E-Switch, Change vhca id valid bool field to bit flag
Date: Mon, 10 Dec 2018 13:15:15 -0800
Message-ID: <20181210211517.3686-8-saeedm@mellanox.com>
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

Change the driver flow destination struct to use bit flags with the vhca
id valid being the 1st one. The flags field is more extendable and will
be used in downstream patch.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c          | 3 ++-
 include/linux/mlx5/fs.h                                   | 6 +++++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9eac137790f5..4d7b65df32ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -125,8 +125,9 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 				dest[i].vport.num = attr->out_rep[j]->vport;
 				dest[i].vport.vhca_id =
 					MLX5_CAP_GEN(attr->out_mdev[j], vhca_id);
-				dest[i].vport.vhca_id_valid =
-					!!MLX5_CAP_ESW(esw->dev, merged_eswitch);
+				if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+					dest[i].vport.flags |=
+						MLX5_FLOW_DEST_VPORT_VHCA_ID;
 				i++;
 			}
 		}
@@ -220,7 +221,8 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 		dest[i].vport.num = attr->out_rep[i]->vport;
 		dest[i].vport.vhca_id =
 			MLX5_CAP_GEN(attr->out_mdev[i], vhca_id);
-		dest[i].vport.vhca_id_valid = !!MLX5_CAP_ESW(esw->dev, merged_eswitch);
+		if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+			dest[i].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	}
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[i].ft = fwd_fdb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 08a891f9aade..dda63dedaa49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -387,7 +387,8 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				id = dst->dest_attr.vport.num;
 				MLX5_SET(dest_format_struct, in_dests,
 					 destination_eswitch_owner_vhca_id_valid,
-					 dst->dest_attr.vport.vhca_id_valid);
+					 !!(dst->dest_attr.vport.flags &
+					    MLX5_FLOW_DEST_VPORT_VHCA_ID));
 				MLX5_SET(dest_format_struct, in_dests,
 					 destination_eswitch_owner_vhca_id,
 					 dst->dest_attr.vport.vhca_id);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 5660f07d3be0..25ffd8018b72 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -86,6 +86,10 @@ struct mlx5_flow_spec {
 	u32  match_value[MLX5_ST_SZ_DW(fte_match_param)];
 };
 
+enum {
+	MLX5_FLOW_DEST_VPORT_VHCA_ID      = BIT(0),
+};
+
 struct mlx5_flow_destination {
 	enum mlx5_flow_destination_type	type;
 	union {
@@ -96,7 +100,7 @@ struct mlx5_flow_destination {
 		struct {
 			u16		num;
 			u16		vhca_id;
-			bool		vhca_id_valid;
+			u8		flags;
 		} vport;
 	};
 };
-- 
2.19.2

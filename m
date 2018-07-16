From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH mlx5-next 04/18] net/mlx5: Break encap/decap into two separated flags
Date: Mon, 16 Jul 2018 11:22:51 +0300
Message-ID: <20180716082305.11744-5-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Today we are able to attach encap and decap actions only to the FDB.
In preparation to enable those actions on the NIC flow tables break
the single flag into two.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c           | 7 ++++---
 include/linux/mlx5/fs.h                                    | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index cecd201f0b73..53718080d262 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -524,7 +524,8 @@ static int esw_create_offloads_fast_fdb_table(struct mlx5_eswitch *esw)
 		esw_size >>= 1;

 	if (esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE)
-		flags |= MLX5_FLOW_TABLE_TUNNEL_EN;
+		flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP |
+			  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);

 	fdb = mlx5_create_auto_grouped_flow_table(root_ns, FDB_FAST_PATH,
 						  esw_size,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 53666b22ad92..615063757c3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -152,7 +152,8 @@ static int mlx5_cmd_create_flow_table(struct mlx5_core_dev *dev,
 				      struct mlx5_flow_table *next_ft,
 				      unsigned int *table_id, u32 flags)
 {
-	int en_encap_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN);
+	int en_encap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP);
+	int en_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 	u32 out[MLX5_ST_SZ_DW(create_flow_table_out)] = {0};
 	u32 in[MLX5_ST_SZ_DW(create_flow_table_in)]   = {0};
 	int err;
@@ -169,9 +170,9 @@ static int mlx5_cmd_create_flow_table(struct mlx5_core_dev *dev,
 	}

 	MLX5_SET(create_flow_table_in, in, flow_table_context.decap_en,
-		 en_encap_decap);
+		 en_decap);
 	MLX5_SET(create_flow_table_in, in, flow_table_context.encap_en,
-		 en_encap_decap);
+		 en_encap);

 	switch (op_mod) {
 	case FS_FT_OP_MOD_NORMAL:
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 5371373230a7..e95ea05565f1 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -45,7 +45,8 @@ enum {
 };

 enum {
-	MLX5_FLOW_TABLE_TUNNEL_EN = BIT(0),
+	MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP = BIT(0),
+	MLX5_FLOW_TABLE_TUNNEL_EN_DECAP = BIT(1),
 };

 #define LEFTOVERS_RULE_NUM	 2
